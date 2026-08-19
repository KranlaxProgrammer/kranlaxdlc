-- ==============================================================================
-- JOKER: LIFE ASSURANCE (Seguro de Vida)
-- ==============================================================================
SMODS.Joker{ 
    key = "lifeassurance",
    config = {
        extra = {
            seguro = 20
        }
    },
    pos = { x = 3, y = 1 },
    display_size = { w = 71, h = 95 },
    cost = 5,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

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
        return {vars = {card.ability.extra.seguro}}
    end,
    
    -- Método nativo para aplicar la pegatina de Alquiler
    set_ability = function(self, card, initial)
        if initial and G.STAGE == G.STAGES.RUN then
            card:set_rental(true)
        end
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
                    saved = true,
                    colour = G.C.RED
                }
            end
        end
    end
}