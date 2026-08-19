SMODS.Consumable {
    key = 'celestequartz',
    set = 'Quartz',
    pos = { x = 8, y = 0 }, -- Ajusta la coordenada x según tu sprite sheet
    cost = 5,
    unlocked = false, -- ¡Cambiado a false para que inicie bloqueado!
    discovered = false,
    unlock_condition = {type = '', extra = ''},
    atlas = 'QuartzConsumables',
    
    can_use = function(self, card)
        return false 
    end,
    
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = "X1.5",
                -- Agregamos todas las variantes para garantizar compatibilidad con tu mod Talisman
                x_chips = 1.5,
                Xchips = 1.5, 
                Xchip_mod = 1.5,
                colour = G.C.CHIPS
            }
        end
    end,

    -- Función nativa para gestionar el desbloqueo
    check_for_unlock = function(self, args)
        if args.type == 'win' then
            -- Comprueba que la baraja sea la de Cuadros ('b_checkered') y el pozo sea tu Pozo Turquesa
            if G.GAME.selected_back.effect.center.key == 'b_checkered' and G.GAME.stake == 'kranlaxs_turquoise' then
                return true -- ¡Desbloqueado!
            end
        end
        return false
    end
}