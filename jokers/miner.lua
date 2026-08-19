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

SMODS.Joker{
    key = "miner",
    config = {
        extra = {
            stonemult = 0,
            odds = 4,
            min_dollars = 1,
            max_dollars = 8
        }
    },
    pos = { x = 8, y = 1 },
    display_size = { w = 71, h = 95 },
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
        if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
            if G.PROFILES[G.SETTINGS.profile].kranlaxs_miner_unlocked then
                return true
            end
        end
        return false
    end,

    in_pool = function(self, args)
        if not G.jokers or not G.jokers.cards then return true end
        for _, v in ipairs(G.jokers.cards) do
            if v.config.center.key == 'j_kranlaxs_' .. self.key then
                return false 
            end
        end
        return true
    end,
    
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_stone
        local prob_numerator, prob_denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'miner_gold') 
        return {vars = {card.ability.extra.stonemult, prob_numerator, prob_denominator, card.ability.extra.min_dollars, card.ability.extra.max_dollars}}
    end,
    
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card.ability.name == 'Stone Card' and not context.blueprint then
                card.ability.extra.stonemult = card.ability.extra.stonemult + 5
                return {
                    message = 'Upgrade!',
                    colour = G.C.RED,
                    card = card
                }
            end
        end

        if context.joker_main then
            if SMODS.pseudorandom_probability(card, 'miner_gold', 1, card.ability.extra.odds) then
                local gold = pseudorandom('miner_dollars', card.ability.extra.min_dollars, card.ability.extra.max_dollars)
                G.E_MANAGER:add_event(Event({
                    func = function()
                        ease_dollars(gold)
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "+$" .. gold, colour = G.C.MONEY})
                        return true
                    end
                }))
            end

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