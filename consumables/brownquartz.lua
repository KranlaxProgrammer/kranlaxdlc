SMODS.Consumable {
    key = 'brownquartz',
    set = 'Quartz',
    pos = { x = 11, y = 0 }, 
    cost = 4,
    unlocked = false, -- ¡Cambiado a false para que inicie bloqueado!
    discovered = false,
    unlock_condition = {type = '', extra = ''},
    atlas = 'QuartzConsumables',
    config = { extra = { target_card = nil } },

    set_ability = function(self, card, initial, delay_sprites)
        if initial then
            local valid_cards = {}
            for k, v in pairs(G.P_CENTERS) do
                if (v.set == 'InverseTarot' or v.set == 'UNOCards' or v.set == 'Quartz') and not v.no_pool then
                    table.insert(valid_cards, k)
                end
            end
            if #valid_cards > 0 then
                card.ability.extra.target_card = pseudorandom_element(valid_cards, pseudoseed('b_quartz_init'))
            end
        end
    end,

    loc_vars = function(self, info_queue, card)
        local c_key = card.ability.extra.target_card
        local c_name = '?'
        if c_key and G.P_CENTERS[c_key] then
            c_name = localize{type = 'name_text', key = c_key, set = G.P_CENTERS[c_key].set}
            -- TRUCO CORREGIDO: Le pasamos el objeto completo para evitar el crash
            info_queue[#info_queue+1] = G.P_CENTERS[c_key]
        end
        return {vars = {c_name}}
    end,

    can_use = function(self, card)
        -- Si ya está en tu inventario, usarlo libera su propio espacio, así que siempre se puede usar.
        if card.area == G.consumeables then return true end
        return #G.consumeables.cards < G.consumeables.config.card_limit
    end,

    use = function(self, card, area, copier)
        local used_card = copier or card
        local c_key = card.ability.extra.target_card

        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.4,
            func = function()
                play_sound('timpani')
                used_card:juice_up(0.3, 0.5)
                return true
            end
        }))

        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.4,
            func = function()
                local new_card = create_card('Consumeables', G.consumeables, nil, nil, nil, nil, c_key, 'b_quartz')
                new_card:add_to_deck()
                G.consumeables:emplace(new_card)
                return true
            end
        }))
    end,

    -- Detecta cuando haces click en el botón "Reroll" de la tienda
    calculate = function(self, card, context)
        if context.reroll_shop and not context.blueprint then
            local valid_cards = {}
            for k, v in pairs(G.P_CENTERS) do
                if (v.set == 'InverseTarot' or v.set == 'UNOCards' or v.set == 'Quartz') and not v.no_pool then
                    table.insert(valid_cards, k)
                end
            end
            if #valid_cards > 0 then
                card.ability.extra.target_card = pseudorandom_element(valid_cards, pseudoseed('b_quartz_reroll'))
                
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card:juice_up(0.5, 0.5)
                        return true
                    end
                }))
                return {
                    message = "¡Cambio!",
                    colour = G.C.ORANGE
                }
            end
        end
    end,

    -- Función nativa para gestionar el desbloqueo
    check_for_unlock = function(self, args)
        if args.type == 'win' then
            -- Comprueba que la baraja sea la Anaglifo ('b_anaglyph') y el pozo sea tu Pozo Turquesa
            if G.GAME.selected_back.effect.center.key == 'b_anaglyph' and G.GAME.stake == 'kranlaxs_turquoise' then
                return true -- ¡Desbloqueado!
            end
        end
        return false
    end
}