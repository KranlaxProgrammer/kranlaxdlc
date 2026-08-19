SMODS.Consumable{
    key = 'customdraw',
    set = 'UNOCards',
    cost = 4,
    unlocked = true,
    discovered = false,
    atlas = 'CustomConsumables', -- Ajusta a tu atlas de UNO
    pos = { x = 2, y = 3 }, -- Ajusta a la coordenada de la carta
    
    -- Pasamos la variable a la interfaz para que el jugador vea el acumulado
    loc_vars = function(self, info_queue, card)
        local tally = G.GAME and G.GAME.kranlaxs_custom_draw_tally or 0
        return {vars = {tally}}
    end,
    
    can_use = function(self, card)
        local tally = G.GAME and G.GAME.kranlaxs_custom_draw_tally or 0
        -- Solo se usa si estamos seleccionando mano, el contador es mayor a 0 y hay cartas en el mazo
        if G.STATE ~= G.STATES.SELECTING_HAND then return false end
        if tally > 0 and G.deck and #G.deck.cards > 0 then return true end
        return false
    end,
    
    use = function(self, card, area, copier)
        local draws = G.GAME.kranlaxs_custom_draw_tally or 0
        
        -- Prevención de crasheo: No puedes robar más cartas de las que físicamente hay en el mazo
        if draws > #G.deck.cards then 
            draws = #G.deck.cards 
        end
        
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                
                -- Encolamos el robo carta por carta
                for i = 1, draws do
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.15,
                        func = function()
                            if G.deck.cards[#G.deck.cards] then
                                draw_card(G.deck, G.hand, i * 100 / draws, 'up', true)
                            end
                            return true
                        end
                    }))
                end
                
                -- Ordenamos la mano y vaciamos el contador de la carta
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.3,
                    func = function()
                        G.hand:sort()
                        G.GAME.kranlaxs_custom_draw_tally = 0
                        return true
                    end
                }))
                
                return true
            end
        }))
    end
}