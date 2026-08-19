SMODS.Consumable {
    key = 'thefool',
    set = 'InverseTarot',
    pos = { x = 6, y = 0 },
    cost = 5,
    unlocked = true,
    discovered = false,
    hidden = false,
    can_repeat_soul = false,
    atlas = 'CustomConsumables',

    in_pool = function(self, args)
        -- Si el juego apenas está cargando y no hay barra de consumibles, lo permite
        if not G.consumeables or not G.consumeables.cards then return true end
        
        -- Escanea los consumibles que tienes guardados actualmente
        for _, v in ipairs(G.consumeables.cards) do
            -- Revisa si ya posees esta carta (usando el prefijo c_)
            if v.config.center.key == 'c_kranlaxs_' .. self.key then
                return false 
            end
        end
        
        return true
    end,
    
    use = function(self, card, area, copier)
        local used_card = copier or card
        
        -- 1. Crear carta Espectral
        if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.4,
                func = function()
                    play_sound('timpani')
                    SMODS.add_card({ set = 'Spectral' })                            
                    used_card:juice_up(0.3, 0.5)
                    G.GAME.consumeable_buffer = 0
                    return true
                end
            }))
        end
        
        -- 2. Bajar de nivel una mano de póker aleatoria
        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.6,
            func = function()
                local hand_pool = {}
                for hand_key, _ in pairs(G.GAME.hands) do
                    table.insert(hand_pool, hand_key)
                end
                local random_hand = pseudorandom_element(hand_pool, pseudoseed('random_hand_leveldown'))
                
                -- level_up_hand con cantidad negativa reduce el nivel
                level_up_hand(used_card, random_hand, true, -1)
                return true
            end
        }))
    end,
    
    can_use = function(self, card)
        return true
    end
}