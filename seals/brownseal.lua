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
        
        
        
        
        
        
        
        if card.area == G.hand and not card.highlighted and G.STATE == G.STATES.HAND_PLAYED and not context.repetition then
            
            
            local hand_id = G.GAME.round .. "_" .. G.GAME.current_round.hands_left
            
            if card.brownseal_lock == hand_id then return end
            card.brownseal_lock = hand_id

            if pseudorandom('brown_seal') < (G.GAME.probabilities.normal or 1) / 3 then
                
                G.E_MANAGER:add_event(Event({
                    trigger = 'after', delay = 0.2, 
                    func = function()
                        
                        local copy = copy_card(card, nil, nil, G.playing_card)
                        
                        
                        copy.brownseal_lock = hand_id 
                        
                        
                        copy:add_to_deck()
                        
                        
                        if G.deck and G.deck.config then
                            G.deck.config.card_limit = G.deck.config.card_limit + 1
                        end
                        
                        
                        if G.playing_cards then
                            table.insert(G.playing_cards, copy)
                        end
                        
                        
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
                return {
                    message = "Falló",
                    colour = G.C.UI.TEXT_INACTIVE
                }
            end
        end
    end
}