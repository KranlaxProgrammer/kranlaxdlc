SMODS.Consumable {
    key = 'redquartz',
    set = 'Quartz',
    pos = { x = 7, y = 0 }, -- Ajusta la coordenada x según tu sprite sheet
    cost = 5,
    unlocked = false, -- ¡IMPORTANTE! Cambiado a false para que inicie bloqueado
    discovered = false,
    unlock_condition = {type = '', extra = ''},
    atlas = 'QuartzConsumables',
    
    can_use = function(self, card)
        -- Al devolver false, el botón "Usar" se desactiva. ¡Es puramente pasivo!
        return false 
    end,
    
    calculate = function(self, card, context)
        -- Cuando se evalúa la mano principal...
        if context.joker_main then
            return {
                message = "X2",
                Xmult_mod = 2,
                colour = G.C.MULT
            }
        end
    end,

    -- Función nativa para gestionar el desbloqueo
    check_for_unlock = function(self, args)
        -- args.type nos dice qué evento acaba de ocurrir. Nos interesa 'win' (ganar partida)
        if args.type == 'win' then
            -- G.GAME.selected_back.effect.center.key lee la baraja usada ('b_red' es la Roja original)
            -- G.GAME.modifiers.kranlaxs_magenta_pinned verifica que juegues en Magenta (o superior)
            if G.GAME.selected_back.effect.center.key == 'b_red' and G.GAME.modifiers.kranlaxs_magenta_pinned then
                return true -- ¡Desbloqueado!
            end
        end
        return false
    end
}