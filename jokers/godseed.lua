SMODS.Joker{ --God seed
    key = "godseed",
    config = { extra = {} },
    pos = { x = 4, y = 4 },
    display_size = { w = 71, h = 95 },
    cost = 20,
    rarity = 4,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    no_collection = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },
    
    in_pool = function(self, args)
        -- Si el motor no envía argumentos, lo permitimos por defecto para que no crashee
        if not args then return true end
        
        -- LISTA NEGRA: Bloqueamos explícitamente Tienda, Bufón, Juicio, etc.
        if args.source == 'sho' or args.source == 'buf' or args.source == 'jud' or args.source == 'rif' or args.source == 'sou' then
            return false
        end
        
        -- Si viene de cualquier otra fuente (como 'rta', 'uta', 'wra'), lo permitimos
        return true
    end,
    
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval  and not context.blueprint then
            return {
                func = function()
                    local created_joker = true
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            local joker_card = SMODS.add_card({ set = 'Joker', rarity = 'Legendary' })
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
}