SMODS.Consumable {
    key = 'greenquartz',
    set = 'Quartz',
    pos = { x = 10, y = 0 }, 
    cost = 5,
    unlocked = false, -- ¡Cambiado a false para que inicie bloqueado!
    discovered = false,
    unlock_condition = {type = '', extra = ''},
    atlas = 'QuartzConsumables',
    config = { extra = { tags_created = 0, max_tags = 5 } },

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.tags_created, card.ability.extra.max_tags}}
    end,

    can_use = function(self, card)
        -- Pasivo. No se puede forzar su uso.
        return false
    end,

    calculate = function(self, card, context)
        -- Tras vencer la ciega y terminar la evaluación, regala su etiqueta
        if context.end_of_round and context.main_eval and not context.blueprint then
            G.E_MANAGER:add_event(Event({
                func = function()
                    local tag = Tag(get_next_tag_key('g_quartz'))
                    add_tag(tag)
                    play_sound('generic1', 0.9, 1.5)
                    card.ability.extra.tags_created = card.ability.extra.tags_created + 1
                    card:juice_up(0.3, 0.5)
                    
                    -- Si llegó al límite, la carta se autodestruye majestuosamente
                    if card.ability.extra.tags_created >= card.ability.extra.max_tags then
                        card:start_dissolve()
                    end
                    return true
                end
            }))
            return {
                message = "¡Etiqueta!",
                colour = G.C.GREEN
            }
        end
    end,

    -- Función nativa para gestionar el desbloqueo
    check_for_unlock = function(self, args)
        if args.type == 'win' then
            -- Comprueba que la baraja sea la Verde ('b_green') y se juegue en Magenta o superior
            if G.GAME.selected_back.effect.center.key == 'b_green' and G.GAME.modifiers.kranlaxs_magenta_pinned then
                return true -- ¡Desbloqueado!
            end
        end
        return false
    end
}