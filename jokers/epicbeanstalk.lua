SMODS.Joker{ 
    key = "epicbeanstalk",
    config = { extra = { conteo = 0 } },
    pos = { x = 9, y = 3 },
    display_size = { w = 71, h = 95 },
    cost = 6,
    rarity = 3,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },
    in_pool = function(self, args)
        -- Bloquea la carta de la tienda, paquetes y cualquier generación aleatoria
        return false
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.conteo}}
    end,
    calculate = function(self, card, context)
        if context.setting_blind  and not context.blueprint then
            return {
                func = function()
                    card.ability.extra.conteo = (card.ability.extra.conteo) + 1
                    return true
                end,
                extra = {
                    func = function()
                        local created_joker = true
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                local joker_card = SMODS.add_card({ set = 'Joker', key = 'j_kranlaxs_magnificentseed' })
                                return true
                            end
                        }))
                        if created_joker then
                            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_joker'), colour = G.C.BLUE})
                        end
                        return true
                    end,
                    colour = G.C.BLUE
                }
            }
        end
        if context.end_of_round and context.game_over == false and context.main_eval  and not context.blueprint then
            if to_big((card.ability.extra.conteo or 0)) == to_big(3) then
                return {
                    func = function()
                        local created_joker = true
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                
                                local joker_card = SMODS.add_card({ set = 'Joker', key = 'j_kranlaxs_ascendedbeanstalk' })
                                return true
                            end
                        }))
                        if created_joker then
                            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_joker'), colour = G.C.BLUE})
                        end
                        return true
                    end,
                    extra = {
                        func = function()
                            local target_joker = card
                            if target_joker then
                                target_joker.getting_sliced = true
                                G.E_MANAGER:add_event(Event({
                                    func = function()
                                        target_joker:start_dissolve({G.C.RED}, nil, 1.6)
                                        return true
                                    end
                                }))
                                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Destroyed!", colour = G.C.RED})
                            end
                            return true
                        end,
                        colour = G.C.RED
                    }
                }
            end
        end
    end
}