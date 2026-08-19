SMODS.Consumable {
    key = 'lapislazuli',
    set = 'Quartz',
    pos = { x = 14, y = 0 }, -- Ajusta a tu Atlas
    cost = 4,
    unlocked = false, -- ¡Cambiado a false para que inicie bloqueado!
    discovered = false,
    unlock_condition = {type = '', extra = ''},
    atlas = 'QuartzConsumables',
    config = { extra = { chips = 40, chip_mod = 4 } },
    
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.chips, card.ability.extra.chip_mod}}
    end,
    
    can_use = function(self, card)
        return false -- Es pasivo
    end,
    
    calculate = function(self, card, context)
        -- Evalúa de forma individual a cada carta jugada
        if context.individual and context.cardarea == G.play and not context.blueprint then
            -- Se asegura de que sea EXCLUSIVAMENTE la primera carta de la mano en puntuar
            if context.other_card == context.scoring_hand[1] then
                if card.ability.extra.chips > 0 then
                    local chips_to_give = card.ability.extra.chips
                    
                    -- Decrementa las fichas
                    card.ability.extra.chips = card.ability.extra.chips - card.ability.extra.chip_mod
                    card:juice_up()

                    return {
                        chips = chips_to_give,
                        card = card,
                        colour = G.C.CHIPS
                    }
                end
            end
        end
    end,

    -- Función nativa para gestionar el desbloqueo
    check_for_unlock = function(self, args)
        -- Si el evento es ganar la partida ('win')
        if args.type == 'win' then
            -- Comprueba que la baraja sea la Azul ('b_blue') y se juegue en Magenta o superior
            if G.GAME.selected_back.effect.center.key == 'b_blue' and G.GAME.modifiers.kranlaxs_magenta_pinned then
                return true -- ¡Desbloqueado!
            end
        end
        return false
    end
}