SMODS.Consumable {
    key = 'graphite',
    set = 'Quartz',
    pos = { x = 16, y = 0 }, -- Ajusta a tu Atlas
    cost = 6,
    unlocked = false, -- ¡Cambiado a false para que inicie bloqueado!
    discovered = false,
    unlock_condition = {type = '', extra = ''},
    atlas = 'QuartzConsumables',
    config = { extra = { chance = 12, max_chance = 12 } },
    
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.chance, card.ability.extra.max_chance}}
    end,
    
    can_use = function(self, card)
        return false -- Es pasivo
    end,
    
    calculate = function(self, card, context)
        -- Actúa justo después de que se evalúa y juega la mano
        if context.after and not context.blueprint then
            if card.ability.extra.chance > 0 then
                -- Comprobación de probabilidad dinámica (Ej: 12/12 = 100%, 6/12 = 50%)
                if pseudorandom('graphite') < (card.ability.extra.chance / card.ability.extra.max_chance) then
                    
                    -- Animación del consumible
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after', delay = 0.2,
                        func = function()
                            play_sound('tarot1')
                            card:juice_up(0.3, 0.5)
                            return true
                        end
                    }))

                    -- Copia todas las cartas jugadas en esta mano a la baraja y a la mano del jugador
                    for i = 1, #context.full_hand do
                        local copied_card = context.full_hand[i]
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                local copy = copy_card(copied_card, nil, nil, G.playing_card)
                                copy:add_to_deck()
                                G.deck.config.card_limit = G.deck.config.card_limit + 1
                                table.insert(G.playing_cards, copy)
                                G.hand:emplace(copy)
                                copy:juice_up()
                                return true
                            end
                        }))
                    end
                    
                    -- Reduce el chance solo si se activó con éxito
                    card.ability.extra.chance = card.ability.extra.chance - 1
                    
                    return {
                        message = "¡Copiadas!",
                        colour = G.C.DARK_EDITION
                    }
                end
            end
        end
    end,

    -- Función nativa para gestionar el desbloqueo
    check_for_unlock = function(self, args)
        if args.type == 'win' then
            -- Comprueba que la baraja sea la Negra ('b_black') y se juegue en Magenta o superior
            if G.GAME.selected_back.effect.center.key == 'b_black' and G.GAME.modifiers.kranlaxs_magenta_pinned then
                return true -- ¡Desbloqueado!
            end
        end
        return false
    end
}