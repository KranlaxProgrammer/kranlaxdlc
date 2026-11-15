SMODS.Joker{
    key = "darkhallway",
    config = { extra = { e_mult = 2, hand_size = -6 } },
    pos = { x = 0, y = 0 }, 
    cost = 6,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    check_for_unlock = function(self, args)
        if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
            if (G.PROFILES[G.SETTINGS.profile].kranlaxs_nightlamp_bought or 0) >= 3 then return true end
        end
        return false
    end,

    locked_loc_vars = function(self, info_queue, card)
        local bought = G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].kranlaxs_nightlamp_bought or 0
        return { vars = { bought } }
    end,

    loc_vars = function(self, info_queue, card)
        local bought = G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].kranlaxs_nightlamp_bought or 0
        local e_mult = card and card.ability.extra.e_mult or self.config.extra.e_mult
        local h_size = card and card.ability.extra.hand_size or self.config.extra.hand_size
        return { vars = { bought, e_mult, math.abs(h_size) } }
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

    add_to_deck = function(self, card, from_debuff)
        G.hand:change_size(card.ability.extra.hand_size)
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(-card.ability.extra.hand_size)
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = "^" .. card.ability.extra.e_mult .. " Mult",
                e_mult = card.ability.extra.e_mult,
                colour = G.C.DARK_EDITION
            }
        end
    end
}