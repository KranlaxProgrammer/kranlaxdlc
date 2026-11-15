SMODS.Edition {
    key = 'monochrome',
    shader = 'monochrome',
    config = {
        extra = {
            emult0 = 3
        }
    },
    in_shop = false,
    loc_vars = function(self, info_queue, card)
        return {vars = {self.config.extra.emult0}}
    end,
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    
    calculate = function(self, card, context)
        -- 1. Efecto principal y Sonido para Jokers y Cartas Jugadas
        if (context.edition and context.cardarea == G.jokers and card.config.trigger) or (context.main_scoring and context.cardarea == G.play) then
            
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound('kranlaxs_exponentialmultsound', 1.0, 1.0)
                    return true
                end
            }))
            
            -- Aplicamos la instrucción de destrucción oficial para Cartas Jugadas
            if context.main_scoring and context.cardarea == G.play and not context.blueprint then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card.ability.eternal = false -- Rompe la inmunidad del sticker Eterno
                        card.getting_sliced = true   -- Evita bugs visuales o triggers fantasma
                        SMODS.destroy_cards({card})
                        return true
                    end
                }))
            end
            
            return {
                e_mult = self.config.extra.emult0
            }
        end
        
        if context.joker_main then card.config.trigger = true end
        
        -- 2. Destrucción oficial para Jokers
        if context.after and not context.blueprint and card.area == G.jokers then
            card.config.trigger = nil
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.2,
                func = function()
                    card.ability.eternal = false -- Rompe la inmunidad del sticker Eterno
                    card.getting_sliced = true   -- Evita bugs visuales o triggers fantasma
                    SMODS.destroy_cards({card})
                    return true
                end
            }))
        end
    end
}