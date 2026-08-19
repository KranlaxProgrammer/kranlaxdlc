SMODS.Joker{ --Zenith beanstalk
    key = "zenithbeanstalk",
    config = { extra = { conteo = 0, limite = 10 } },
    pos = { x = 3, y = 4 },
    display_size = { w = 71, h = 95 },
    cost = 20,
    rarity = 4,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    no_collection = true,
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
    
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.conteo, card.ability.extra.limite}}
    end,
    
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  and not context.blueprint then
            card.ability.extra.conteo = (card.ability.extra.conteo) + 1
        end
        if context.end_of_round and context.game_over == false and context.main_eval  and not context.blueprint then
            if to_big((card.ability.extra.conteo or 0)) >= to_big(card.ability.extra.limite) then
                return {
                    func = function()
                        local created_joker = true
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                local joker_card = SMODS.add_card({ set = 'Joker', key = 'j_kranlaxs_godseed' })
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
                            card.ability.extra.conteo = 0
                            return true
                        end,
                        colour = G.C.BLUE,
                        extra = {
                            func = function()
                                card.ability.extra.limite = (card.ability.extra.limite) + 3
                                return true
                            end,
                            colour = G.C.GREEN
                        }
                    }
                }
            end
        end
    end
}