SMODS.Edition {
    key = 'cosmic',
    shader = 'cosmic',
    in_shop = false,
    loc_vars = function(self, info_queue, card) 
        return {vars = {}} 
    end,
    loc_txt = {
        name = 'Cosmic',
        label = 'Cosmic',
        text = {
            "Sube de nivel la {C:attention}mano de{}",
            "{C:attention}póker seleccionada{}",
            "al ser {C:red}descartada{}"
        }
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    
    calculate = function(self, card, context)
        if context.discard and context.other_card == card and not context.blueprint then
            -- Obtenemos la información de la mano resaltada
            local text, disp_text = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
            
            if text then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.2,
                    func = function()
                        play_sound('tarot1')
                        card:juice_up(0.8, 0.5)
                        G.TAROT_INTERRUPT_PULSE = true
                        
                        -- CORRECCIÓN: Usamos 'text' (el ID interno) para buscar en G.GAME.hands
                        update_hand_text({delay = 0}, {mult = 0, chips = 0, handname = text, level = G.GAME.hands[text].level})
                        level_up_hand(card, text, false, 1)
                        update_hand_text({delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
                        
                        return true
                    end
                }))
                return {
                    message = localize('k_level_up_ex'),
                    colour = G.C.RED
                }
            end
        end
    end
}