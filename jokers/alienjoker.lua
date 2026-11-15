SMODS.Joker{
    key = "alienjoker",
    config = { extra = { x_mult = 2, limit_mod = -1 } },
    pos = { x = 10, y = 05 }, 
    cost = 5,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    check_for_unlock = function(self, args)
        local count = 0
        local p = G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile]
        if p and p.deck_usage then
            for k, v in pairs(p.deck_usage) do
                if v.wins_by_key and (v.wins_by_key['stake_green'] or 0) > 0 then
                    count = count + 1
                end
            end
        end
        if count >= 5 then return true end
        return false
    end,

    locked_loc_vars = function(self, info_queue, card)
        local count = 0
        local p = G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile]
        if p and p.deck_usage then
            for k, v in pairs(p.deck_usage) do
                if v.wins_by_key and (v.wins_by_key['stake_green'] or 0) > 0 then count = count + 1 end
            end
        end
        return { vars = { count } }
    end,

    loc_vars = function(self, info_queue, card)
        local count = 0
        local p = G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile]
        if p and p.deck_usage then
            for k, v in pairs(p.deck_usage) do
                if v.wins_by_key and (v.wins_by_key['stake_green'] or 0) > 0 then count = count + 1 end
            end
        end
        local mod = card and card.ability.extra.limit_mod or self.config.extra.limit_mod
        local xmult = card and card.ability.extra.x_mult or self.config.extra.x_mult
        return { vars = { count, math.abs(mod), xmult } }
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
        if G.hand and G.hand.config then
            G.hand.config.highlighted_limit = G.hand.config.highlighted_limit + card.ability.extra.limit_mod
        end
    end,

    remove_from_deck = function(self, card, from_debuff)
        if G.hand and G.hand.config then
            G.hand.config.highlighted_limit = G.hand.config.highlighted_limit - card.ability.extra.limit_mod
        end
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = "X" .. card.ability.extra.x_mult .. " Mult",
                Xmult_mod = card.ability.extra.x_mult,
                colour = G.C.MULT
            }
        end
    end
}