SMODS.Seal {
    key = 'orangeseal',
    pos = { x = 3, y = 0 }, 
    badge_colour = HEX('FFA500'),

    atlas = 'CustomSeals',
    unlocked = true,
    discovered = true,
    no_collection = false,

    loc_vars = function(self, info_queue, card)
        -- Si la carta recibe este sello pero aún no tiene misión, se la creamos de inmediato.
        if not card.orange_target_hand or not card.orange_target_consumable then
            local pool_x = {'High Card', 'Pair', 'Two Pair', 'Three of a Kind', 'Straight', 'Flush', 'Full House', 'Four of a Kind'}
            local pool_y = {
                "c_kranlaxs_skip", "c_kranlaxs_reverse", "c_kranlaxs_draw4", "c_kranlaxs_draw2", "c_kranlaxs_wildcard", "c_kranlaxs_stacking",
                "c_kranlaxs_thefool", "c_kranlaxs_themagician", "c_kranlaxs_thehighpriestess", "c_kranlaxs_theempress", "c_kranlaxs_theemperor", "c_kranlaxs_thehierophant", "c_kranlaxs_thelovers", "c_kranlaxs_thechariot", "c_kranlaxs_justice", "c_kranlaxs_thehermit", "c_kranlaxs_thewheeloffortune", "c_kranlaxs_strenght", "c_kranlaxs_thehangedman", "c_kranlaxs_death", "c_kranlaxs_thedevil", "c_kranlaxs_thetower", "c_kranlaxs_thestars", "c_kranlaxs_themoon", "c_kranlaxs_theworld", "c_kranlaxs_thesun", "c_kranlaxs_judgement",
                "c_kranlaxs_blackquartz", "c_kranlaxs_whitequartz", "c_kranlaxs_pinkquartz", "c_kranlaxs_bluequartz", "c_kranlaxs_lilacquartz", "c_kranlaxs_grayquartz", "c_kranlaxs_transparentquartz", "c_kranlaxs_redquartz", "c_kranlaxs_celestequartz", "c_kranlaxs_yellowquartz", "c_kranlaxs_greenquartz", "c_kranlaxs_brownquartz", "c_kranlaxs_turquoisequartz", "c_kranlaxs_orangequartz", "c_kranlaxs_lapislazuli", "c_kranlaxs_cinnabar", "c_kranlaxs_graphite", "c_kranlaxs_uranium"
            }
            card.orange_target_hand = pseudorandom_element(pool_x, pseudoseed('orange_init_x'))
            card.orange_target_consumable = pseudorandom_element(pool_y, pseudoseed('orange_init_y'))
        end

        local hand_str = card.orange_target_hand
        local cons_key = card.orange_target_consumable
        
        local cons_name = "Card"
        if G.P_CENTERS[cons_key] then
            cons_name = localize{type = 'name_text', key = cons_key, set = G.P_CENTERS[cons_key].set}
        end
        -- Extraemos el nombre traducido de la mano de forma nativa
        local localized_hand = localize(hand_str, 'poker_hands')

        return { vars = { localized_hand, cons_name } }
    end,

    calculate = function(self, card, context)
        -- 'main_scoring' verifica que esta carta exacta fue jugada y puntuó
        if context.main_scoring then
            
            -- Seguro de fallo: Si por alguna razón la misión no cargó, cancelamos
            if not card.orange_target_hand or not card.orange_target_consumable then return end

            local required_hand = card.orange_target_hand
            local reward_key = card.orange_target_consumable

            -- context.scoring_name extrae del juego la mano que el jugador acaba de hacer. 
            -- Verificamos que sea EXACTAMENTE la que pide el sello.
            if context.scoring_name == required_hand then
                
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            -- 1. ENTREGAMOS EL PREMIO
                            local reward = create_card(nil, G.consumeables, nil, nil, nil, nil, reward_key, 'orange_seal_reward')
                            reward:add_to_deck()
                            G.consumeables:emplace(reward)
                            G.GAME.consumeable_buffer = 0
                            
                            -- 2. RE-ROLL (Cambiamos la misión para el próximo uso)
                            local pool_x = {'High Card', 'Pair', 'Two Pair', 'Three of a Kind', 'Straight', 'Flush', 'Full House', 'Four of a Kind'}
                            local pool_y = {
                                "c_kranlaxs_skip", "c_kranlaxs_reverse", "c_kranlaxs_draw4", "c_kranlaxs_draw2", "c_kranlaxs_wildcard", "c_kranlaxs_stacking",
                                "c_kranlaxs_thefool", "c_kranlaxs_themagician", "c_kranlaxs_thehighpriestess", "c_kranlaxs_theempress", "c_kranlaxs_theemperor", "c_kranlaxs_thehierophant", "c_kranlaxs_thelovers", "c_kranlaxs_thechariot", "c_kranlaxs_justice", "c_kranlaxs_thehermit", "c_kranlaxs_thewheeloffortune", "c_kranlaxs_strenght", "c_kranlaxs_thehangedman", "c_kranlaxs_death", "c_kranlaxs_thedevil", "c_kranlaxs_thetower", "c_kranlaxs_thestars", "c_kranlaxs_themoon", "c_kranlaxs_theworld", "c_kranlaxs_thesun", "c_kranlaxs_judgement",
                                "c_kranlaxs_blackquartz", "c_kranlaxs_whitequartz", "c_kranlaxs_pinkquartz", "c_kranlaxs_bluequartz", "c_kranlaxs_lilacquartz", "c_kranlaxs_grayquartz", "c_kranlaxs_transparentquartz", "c_kranlaxs_redquartz", "c_kranlaxs_celestequartz", "c_kranlaxs_yellowquartz", "c_kranlaxs_greenquartz", "c_kranlaxs_brownquartz", "c_kranlaxs_turquoisequartz", "c_kranlaxs_orangequartz", "c_kranlaxs_lapislazuli", "c_kranlaxs_cinnabar", "c_kranlaxs_graphite", "c_kranlaxs_uranium"
                            }
                            card.orange_target_hand = pseudorandom_element(pool_x, pseudoseed('orange_reroll_x'))
                            card.orange_target_consumable = pseudorandom_element(pool_y, pseudoseed('orange_reroll_y'))
                            
                            card:juice_up(0.5, 0.5)
                            play_sound('tarot1')
                            return true
                        end
                    }))

                    return {
                        message = "Brewed!",
                        colour = HEX('FFA500')
                    }
                end
            end
        end
    end
}