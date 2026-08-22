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
        -- 1. BALANCEO INSTANTÁNEO
        if (context.edition and context.cardarea == G.jokers and card.config.trigger) or (context.main_scoring and context.cardarea == G.play) then
            local tot = hand_chips + mult
            
            -- Compatible con números gigantes de Talisman
            if to_big then
                hand_chips = tot / to_big(2)
                mult = tot / to_big(2)
            else
                hand_chips = math.floor(tot / 2)
                mult = math.floor(tot / 2)
            end
            
            update_hand_text({delay = 0}, {mult = mult, chips = hand_chips})
            
            return {
                message = "¡Equilibrado!",
                colour = G.C.DARK_EDITION
            }
        end
        
        -- Seguro anti-doble activación
        if context.joker_main then card.config.trigger = true end
        
        -- 2. DADO DE DESTRUCCIÓN POST-MANO
        if context.after then
            card.config.trigger = nil
            if not context.blueprint and pseudorandom('cursed_destruct') < G.GAME.probabilities.normal / self.config.extra.odds then
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