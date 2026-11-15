SMODS.Joker{ 
    key = "lifeassurance",
    atlas = 'CustomJokers',
    pos = { x = 3, y = 1 },
    rarity = "kranlaxs_zenith",
    cost = 9,
    unlocked = true,
    discovered = false,
    bm_cost = 4,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    config = { extra = { seguro = 25 } },
    
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.seguro}}
    end,
    
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over and not context.blueprint then
            if G.GAME.dollars >= card.ability.extra.seguro then
                local cost = card.ability.extra.seguro
                
                G.E_MANAGER:add_event(Event({
                    func = function()
                        ease_dollars(-cost)
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = "-$" .. tostring(cost), colour = G.C.MONEY})
                        card.ability.extra.seguro = card.ability.extra.seguro * 2
                        return true
                    end
                }))
                
                return {
                    message = localize('k_saved_ex'),
                    saved = 'ph_kranlaxs_lifeassurance',
                    colour = G.C.RED
                }
            end
        end
    end
}