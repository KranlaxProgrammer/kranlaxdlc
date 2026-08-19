SMODS.Seal {
    key = 'brownseal',
    pos = { x = 4, y = 0 }, 
    badge_colour = HEX('8d6f49'),

    atlas = 'CustomSeals',
    unlocked = true,
    discovered = true,
    no_collection = false,
    
    loc_vars = function(self, info_queue, card)
        return { vars = { ''..(G.GAME and G.GAME.probabilities.normal or 1), 3 } }
    end,

    calculate = function(self, card, context)
        -- ===============================================================
        -- EL FILTRO DEFINITIVO:
        -- 1. Físicamente en la mano (ignora cartas en la mesa)
        -- 2. No está seleccionada (evita clonar las que vas a jugar)
        -- 3. Estado de juego es HAND_PLAYED
        -- 4. No es repetición por comodines como el Mimo
        -- ===============================================================
        if card.area == G.hand and not card.highlighted and G.STATE == G.STATES.HAND_PLAYED and not context.repetition then
            
            -- ===============================================================
            -- EL CANDADO DE ID ESTÁTICO:
            -- Creamos un ID único usando la ronda actual y las MANOS RESTANTES.
            -- Las manos restantes cambian en cuanto presionas "Jugar" y no se
            -- mueven en absoluto durante toda la evaluación.
            -- ===============================================================
            local hand_id = G.GAME.round .. "_" .. G.GAME.current_round.hands_left
            
            -- Si la carta ya tiene este ID exacto, bloqueamos la ejecución
            if card.brownseal_lock == hand_id then return end
            
            -- Aplicamos el candado
            card.brownseal_lock = hand_id

            -- Tiramos el dado respetando la probabilidad del juego
            if pseudorandom('brown_seal') < G.GAME.probabilities.normal / 3 then
                
                -- ÉXITO: Creamos el clon
                G.E_MANAGER:add_event(Event({
                    trigger = 'after', delay = 0.2, 
                    func = function()
                        local copy = copy_card(card, nil, nil, nil, card.playing_card and card.playing_card or nil)
                        
                        -- ¡VITAL! El clon nace con el mismo candado de la mano actual
                        -- para que no se clone a sí mismo en esta misma jugada
                        copy.brownseal_lock = hand_id 
                        
                        copy:add_to_deck()
                        G.hand:emplace(copy)
                        
                        card:juice_up(0.5, 0.5)
                        play_sound('tarot1')
                        
                        return true
                    end
                }))

                return {
                    message = "¡Mitosis!",
                    colour = HEX('8d6f49')
                }
            else
                -- FALLO:
                return {
                    message = "Falló",
                    colour = G.C.UI.TEXT_INACTIVE
                }
            end
        end
    end
}