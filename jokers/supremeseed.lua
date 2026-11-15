SMODS.Joker{ 
    key = "supremeseed",
    config = { extra = {} },
    pos = { x = 0, y = 0 }, 
    display_size = { w = 71, h = 95 },
    cost = 10,
    rarity = "kranlaxs_zenith",
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    in_pool = function(self, args)
        return false -- Bloqueado de tiendas
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval  and not context.blueprint then
            return {
                func = function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            -- Creación forzada de un Joker rareza Zenith
                            local new_card = create_card('Joker', G.jokers, nil, 'kranlaxs_zenith', nil, nil, nil, 'supremeseed_zen')
                            new_card:add_to_deck()
                            G.jokers:emplace(new_card)
                            return true
                        end
                    }))
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_joker'), colour = G.C.BLUE})
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
}