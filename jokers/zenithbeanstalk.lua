SMODS.Joker{
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
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },
    
    in_pool = function(self, args)
        return false -- Bloqueado de tiendas
    end,
    
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.conteo, card.ability.extra.limite}}
    end,
    
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main and not context.blueprint then
            card.ability.extra.conteo = card.ability.extra.conteo + 1
        end
        
        if context.end_of_round and not context.game_over and context.main_eval and not context.blueprint then
            if to_big(card.ability.extra.conteo) >= to_big(card.ability.extra.limite) then
                
                card.ability.extra.conteo = 0
                card.ability.extra.limite = card.ability.extra.limite + 3
                
                G.E_MANAGER:add_event(Event({
                    func = function()
                        -- Inyección forzada ignorando el espacio límite
                        local new_card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_kranlaxs_godseed', 'zen')
                        new_card:add_to_deck()
                        G.jokers:emplace(new_card)
                        
                        card:juice_up(0.5, 0.5)
                        play_sound('timpani')
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = "+1 Joker", colour = G.C.BLUE})
                        
                        return true
                    end
                }))
            end
        end
    end
}