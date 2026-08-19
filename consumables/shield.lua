SMODS.Consumable{
    key = 'shield',
    set = 'UNOCards',
    cost = 4,
    unlocked = true,
    discovered = false,
    atlas = 'CustomConsumables', -- Ajusta al atlas de tus cartas UNO
    pos = { x = 0, y = 3 }, -- Ajusta a la coordenada de la carta Shield
    
    -- La función ACTIVA: Solo se puede usar si hay una ciega jefe y no está deshabilitada
    can_use = function(self, card)
        if G.GAME and G.GAME.blind and G.GAME.blind.boss and not G.GAME.blind.disabled then
            return true
        end
        return false
    end,
    
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                
                -- Deshabilita la habilidad del jefe
                G.GAME.blind:disable()
                return true
            end
        }))
    end
}