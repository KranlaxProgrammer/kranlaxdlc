if not SMODS.kranlaxs_miner_hooked then
    local original_evaluate_play = G.FUNCS.evaluate_play
    G.FUNCS.evaluate_play = function(e)
        if G.play and G.play.cards and #G.play.cards == 5 then
            local stones = 0
            for _, v in ipairs(G.play.cards) do
                if v.ability and v.ability.name == 'Stone Card' then
                    stones = stones + 1
                end
            end
            if stones == 5 then
                if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
                    G.PROFILES[G.SETTINGS.profile].kranlaxs_miner_unlocked = true
                end
            end
        end
        original_evaluate_play(e)
    end
    SMODS.kranlaxs_miner_hooked = true
end

SMODS.Joker {
    key = "miner",
    atlas = 'CustomJokers',
    pos = { x = 8, y = 1 },
    rarity = 2,
    cost = 6,
    unlocked = false,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = { extra = { stonemult = 0, odds = 4, min_dollars = 1, max_dollars = 8 } },
    
    check_for_unlock = function(self, args)
        if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
            if G.PROFILES[G.SETTINGS.profile].kranlaxs_miner_unlocked then
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
        local prob_numerator, prob_denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'miner_gold') 
        return { vars = { card.ability.extra.stonemult, prob_numerator, prob_denominator, card.ability.extra.min_dollars, card.ability.extra.max_dollars } }
    end,
    
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card.ability.name == 'Stone Card' and not context.other_card.getting_sliced then
                local upgraded = false
                local destroyed = false
                local gold = 0
                
                if not context.blueprint then
                    card.ability.extra.stonemult = card.ability.extra.stonemult + 5
                    upgraded = true
                end
                
                if pseudorandom('miner_gold') < (G.GAME.probabilities.normal or 1) / card.ability.extra.odds then
                    
                    gold = card.ability.extra.min_dollars + math.floor(pseudorandom('miner_dollars') * (card.ability.extra.max_dollars - card.ability.extra.min_dollars + 1))
                    destroyed = true
                    context.other_card.shattered = true 
                end

                if upgraded or destroyed then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            if destroyed then
                                ease_dollars(gold)
                                card_eval_status_text(card, 'extra', nil, nil, nil, {message = "+$"..gold, colour = G.C.MONEY})
                            else
                                card_eval_status_text(card, 'extra', nil, nil, nil, {message = "¡Mejora!", colour = G.C.RED})
                            end
                            return true
                        end
                    }))
                end
            end
        end

        if context.joker_main then
            if card.ability.extra.stonemult > 0 then
                return {
                    message = "+" .. card.ability.extra.stonemult,
                    mult_mod = card.ability.extra.stonemult,
                    colour = G.C.MULT
                }
            end
        end
    end
}