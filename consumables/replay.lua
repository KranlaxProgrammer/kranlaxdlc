SMODS.Consumable{
    key = 'replay',
    set = 'UNOCards',
    cost = 3,
    unlocked = true,
    discovered = false,
    atlas = 'CustomConsumables', -- Recuerda ajustar a tu atlas de UNO
    pos = { x = 3, y = 3 }, -- Recuerda ajustar las coordenadas
    
    -- Solo se puede usar si estamos en la fase de seleccionar mano 
    -- y si hay cartas válidas en la pila de descartes
    can_use = function(self, card)
        if G.STATE ~= G.STATES.SELECTING_HAND then return false end
        if not G.GAME.kranlaxs_replay_memory or #G.GAME.kranlaxs_replay_memory == 0 then return false end
        
        local has_recoverable = false
        for _, c in ipairs(G.GAME.kranlaxs_replay_memory) do
            -- Solo confirmamos uso si al menos una carta sobrevivió y está en el descarte
            if c.area == G.discard then
                has_recoverable = true
                break
            end
        end
        return has_recoverable
    end,
    
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after', 
            delay = 0.4, 
            func = function()
                play_sound('card1')
                card:juice_up(0.3, 0.5)
                
                local cards_recovered = false
                
                for _, c in ipairs(G.GAME.kranlaxs_replay_memory) do
                    if c.area == G.discard then
                        G.discard:remove_card(c)
                        G.hand:emplace(c)
                        cards_recovered = true
                    end
                end
                
                if cards_recovered then
                    G.hand:sort()
                end
                
                -- Limpiamos la memoria para cumplir la regla de "un solo uso"
                G.GAME.kranlaxs_replay_memory = {}
                return true
            end
        }))
    end
}