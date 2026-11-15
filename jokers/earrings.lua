SMODS.Joker{
    key = "earrings",
    config = { extra = { odds = 4 } },
    pos = { x = 0, y = 0 },
    cost = 20,
    bm_cost = 5,
    rarity = "kranlaxs_zenith",
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    check_for_unlock = function(self, args)
        if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
            if (G.PROFILES[G.SETTINGS.profile].kranlaxs_quartz_used or 0) >= 5 then return true end
        end
        return false
    end,

    loc_vars = function(self, info_queue, card)
        return { vars = { ''..(G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
    end,

    calculate = function(self, card, context)
        if context.setting_blind then
            if pseudorandom('earrings') < G.GAME.probabilities.normal / card.ability.extra.odds then
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            local new_card = create_card('Quartz', G.consumeables, nil, nil, nil, nil, nil, 'ear')
                            new_card:add_to_deck()
                            G.consumeables:emplace(new_card)
                            G.GAME.consumeable_buffer = 0
                            return true
                        end
                    }))
                    return {
                        message = "¡Cuarzo!",
                        colour = HEX('FFC0CB')
                    }
                end
            end
        end
    end
}

-- Hook para llevar la cuenta de cuarzos usados a nivel global
if not SMODS.kranlaxs_earrings_use_hook then
    local orig_use_consumeable = Card.use_consumeable
    function Card:use_consumeable(area, copier)
        if self.config and self.config.center and self.config.center.set == 'Quartz' then
            if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
                G.PROFILES[G.SETTINGS.profile].kranlaxs_quartz_used = (G.PROFILES[G.SETTINGS.profile].kranlaxs_quartz_used or 0) + 1
                G:save_progress()
            end
        end
        if orig_use_consumeable then orig_use_consumeable(self, area, copier) end
    end
    SMODS.kranlaxs_earrings_use_hook = true
end