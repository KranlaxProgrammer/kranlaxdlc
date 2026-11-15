SMODS.Edition {
    key = 'cursed',
    shader = 'cursed',
    config = {
        extra = {
            odds = 4
        }
    },
    in_shop = false,
    loc_vars = function(self, info_queue, card)
        return {vars = {G.GAME.probabilities.normal or 1, self.config.extra.odds}}
    end,
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    
    calculate = function(self, card, context)
        -- 1. Equilibrar usando el estándar recomendado (pre_joker)
        if context.pre_joker or (context.main_scoring and context.cardarea == G.play) then
            
            -- Sonidos clásicos de Plasma
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound('gong', 0.94, 0.3)
                    play_sound('gong', 0.94, 0.3)
                    play_sound('tarot1', 1.5, 0.4)
                    return true
                end
            }))
            
            -- Retornamos a Steamodded para que haga la matemática de forma nativa
            return {
                message = "¡Equilibrado!",
                colour = G.C.DARK_EDITION,
                balance = true
            }
        end
        
        -- 2. Riesgo de destrucción para JOKERS (usando probabilidad oficial)
        if context.after and not context.blueprint and card.area == G.jokers then
            if pseudorandom('cursed_destruct') < (G.GAME.probabilities.normal or 1) / self.config.extra.odds then
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

        -- 3. Riesgo de destrucción para CARTAS JUGADAS (usando probabilidad oficial)
        if context.destroying_card and not context.blueprint and card.area == G.play then
            if pseudorandom('cursed_destruct_card') < (G.GAME.probabilities.normal or 1) / self.config.extra.odds then
                return true
            end
        end
    end
}