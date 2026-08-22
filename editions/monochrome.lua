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
        -- 1. FASE DE PUNTUACIÓN (Ya sea en Carta o en Joker)
        if (context.edition and context.cardarea == G.jokers and card.config.trigger) or (context.main_scoring and context.cardarea == G.play) then
            return {
                e_mult = self.config.extra.emult0
            }
        end
        
        -- Seguro anti-doble activación (Estructura de Cryptid)
        if context.joker_main then card.config.trigger = true end
        
        -- 2. FASE DE LIMPIEZA (Destrucción)
        if context.after then
            card.config.trigger = nil
            if not context.blueprint then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.2,
                    func = function()
                        card.getting_sliced = true
                        play_sound('tarot1')
                        card:start_dissolve()
                        return true
                    end
                }))
            end
        end
    end
}