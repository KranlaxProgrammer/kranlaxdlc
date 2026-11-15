SMODS.Joker{
    key = "venusstatue",
    config = { extra = { payout = 1, gain = 1, odds = 4 } },
    pos = { x = 012, y = 01 }, 
    display_size = { w = 71, h = 95 },
    cost = 6,
    rarity = 2, 
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    check_for_unlock = function(self, args)
        if args.type == 'win' then
            -- Nivel 9 = Pozo Magenta
            if G.GAME.selected_back.effect.center.key == 'b_kranlaxs_embedded_deck' and G.GAME.stake >= 9 then
                return true
            end
        end
        return false
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
    
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_stone
        return {vars = {card.ability.extra.payout, card.ability.extra.gain, G.GAME.probabilities.normal or 1, card.ability.extra.odds}}
    end,
    
    calc_dollar_bonus = function(self, card)
        if card.ability.extra.payout > 0 then
            return card.ability.extra.payout
        end
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card.ability.name == 'Stone Card' then
                if pseudorandom('venus_statue') < (G.GAME.probabilities.normal or 1) / card.ability.extra.odds then
                    if not context.blueprint then
                        card.ability.extra.payout = card.ability.extra.payout + card.ability.extra.gain
                    end
                    return {
                        message = "¡+$" .. card.ability.extra.gain .. "!",
                        colour = G.C.MONEY,
                        card = card
                    }
                end
            end
        end
    end
}