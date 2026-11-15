SMODS.Joker{
    key = "brokenvhs",
    config = { extra = { odds = 6 } },
    pos = { x = 012, y = 04 }, 
    cost = 8,
    rarity = 3,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    check_for_unlock = function(self, args)
        if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
            if (G.PROFILES[G.SETTINGS.profile].kranlaxs_replay_uno_used or 0) >= 5 then return true end
        end
        return false
    end,

    locked_loc_vars = function(self, info_queue, card)
        local uses = G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].kranlaxs_replay_uno_used or 0
        return { vars = { uses } }
    end,

    loc_vars = function(self, info_queue, card)
        local uses = G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].kranlaxs_replay_uno_used or 0
        local odds = card and card.ability.extra.odds or self.config.extra.odds
        return { vars = { uses, G.GAME and G.GAME.probabilities.normal or 1, odds } }
    end,

    in_pool = function(self, args)
        if SMODS.showman and SMODS.showman('j_kranlaxs_' .. self.key) then return true end
        local areas_to_check = {G.jokers, G.shop_jokers, G.pack_cards}
        for _, area in ipairs(areas_to_check) do
            if area and area.cards then
                for _, v in ipairs(area.cards) do
                    if v.config and v.config.center and v.config.center.key == 'j_kranlaxs_' .. self.key then return false end
                end
            end
        end
        return true
    end,

    calculate = function(self, card, context)
        if context.blueprint then return end

        if context.after and context.full_hand then
            if pseudorandom('brokenvhs_retrigger') < G.GAME.probabilities.normal / card.ability.extra.odds then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local recovered = false
                        for i = 1, #context.full_hand do
                            local c = context.full_hand[i]
                            if c.area == G.play then
                                G.play:remove_card(c)
                                G.hand:emplace(c)
                                recovered = true
                            elseif c.area == G.discard then
                                G.discard:remove_card(c)
                                G.hand:emplace(c)
                                recovered = true
                            end
                        end
                        if recovered then G.hand:sort() end
                        return true
                    end
                }))
                return {
                    message = '¡Recuperadas!',
                    colour = G.C.BLUE,
                    card = card
                }
            end
        end
    end
}

if not SMODS.kranlaxs_brokenvhs_hook then
    local orig_use_consumeable = Card.use_consumeable
    function Card:use_consumeable(area, copier)
        if self.config and self.config.center and self.config.center.key == 'c_kranlaxs_replay' then
            if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
                G.PROFILES[G.SETTINGS.profile].kranlaxs_replay_uno_used = (G.PROFILES[G.SETTINGS.profile].kranlaxs_replay_uno_used or 0) + 1
                G:save_progress()
            end
        end
        if orig_use_consumeable then orig_use_consumeable(self, area, copier) end
    end
    SMODS.kranlaxs_brokenvhs_hook = true
end