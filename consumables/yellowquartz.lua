SMODS.Consumable {
    key = 'yellowquartz',
    set = 'Quartz',
    pos = { x = 9, y = 0 }, 
    cost = 6,
    unlocked = false, -- ¡Cambiado a false!
    discovered = false,
    unlock_condition = {type = '', extra = ''},
    atlas = 'QuartzConsumables',
    config = { extra = { target_joker = nil } }, 

    set_ability = function(self, card, initial, delay_sprites)
        if initial then
            local valid_jokers = {}
            for k, v in pairs(G.P_CENTERS) do
                if v.set == 'Joker' and not v.no_pool then
                    table.insert(valid_jokers, k)
                end
            end
            if #valid_jokers > 0 then
                card.ability.extra.target_joker = pseudorandom_element(valid_jokers, pseudoseed('y_quartz_init'))
            end
        end
    end,

    loc_vars = function(self, info_queue, card)
        local j_key = card.ability.extra.target_joker
        local j_name = '?'
        
        if j_key and G.P_CENTERS[j_key] then
            j_name = localize{type = 'name_text', key = j_key, set = 'Joker'}
            info_queue[#info_queue+1] = G.P_CENTERS[j_key]
        end
        return {vars = {j_name}}
    end,

    can_use = function(self, card)
        return G.jokers and #G.jokers.cards < G.jokers.config.card_limit
    end,

    use = function(self, card, area, copier)
        local used_card = copier or card
        local j_key = card.ability.extra.target_joker

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
                local new_card = create_card('Joker', G.jokers, nil, nil, nil, nil, j_key, 'y_quartz')
                new_card:add_to_deck()
                G.jokers:emplace(new_card)
                return true
            end
        }))
    end,

    calculate = function(self, card, context)
        if context.end_of_round and not context.blueprint then
            local valid_jokers = {}
            for k, v in pairs(G.P_CENTERS) do
                if v.set == 'Joker' and not v.no_pool then
                    table.insert(valid_jokers, k)
                end
            end
            if #valid_jokers > 0 then
                card.ability.extra.target_joker = pseudorandom_element(valid_jokers, pseudoseed('y_quartz_round'))
                return {
                    message = "¡Cambio!",
                    colour = G.C.ORANGE
                }
            end
        end
    end,

    -- Validación de desbloqueo: Baraja de Mazmorra en Pozo Azul
    check_for_unlock = function(self, args)
        if args.type == 'win' then
            if G.GAME.selected_back.effect.center.key == 'b_kranlaxs_dungeon_deck' and G.GAME.stake == 'blue' then
                return true
            end
        end
        return false
    end
}