SMODS.Consumable {
    key = 'skip',
    set = 'UNOCards',
    pos = { x = 2, y = 0 }, 
    cost = 3,
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
        
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                used_card:juice_up(0.3, 0.5)
                return true
            end
        }))

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                -- Quitamos bonos de dinero
                G.GAME.blind.dollars = 0
                G.GAME.current_round.hands_left = 0
                
                -- Empatamos los puntos con la ciega de forma segura
                G.GAME.chips = to_big(1) * G.GAME.blind.chips
                
                -- Engañamos al juego para que salte a la victoria
                G.STATE = G.STATES.HAND_PLAYED
                G.STATE_COMPLETE = true
                
                return true
            end
        }))
    end,
    
    can_use = function(self, card)
        return G.GAME.blind and G.GAME.blind.in_blind and not G.GAME.blind.boss
    end
}