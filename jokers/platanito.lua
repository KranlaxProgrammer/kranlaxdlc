SMODS.Joker{
    key = "platanito",
    config = { extra = { x_mult = 1.5, odds = 20 } },
    pos = { x = 0, y = 6 },
    display_size = { w = 71, h = 95 },
    cost = 5,
    bm_cost = 8,
    rarity = "kranlaxs_zenith",
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    
    unlocked = false,
    discovered = false,
    unlock_condition = {type = '', extra = ''},
    
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    check_for_unlock = function(self, args)
        if args.type == 'win' then
            if G.GAME.selected_back.effect.center.key == 'b_kranlaxs_space_deck' and G.GAME.stake == 'kranlaxs_platinum' then
                return true
            end
        end
        return false
    end,
    
    loc_vars = function(self, info_queue, card)
        local prob = G.GAME and G.GAME.probabilities.normal or 1
        return {vars = {prob, card.ability.extra.odds, card.ability.extra.x_mult}}
    end,
    
    calculate = function(self, card, context)
        if context.other_joker and context.other_joker ~= card then
            return {
                message = "X" .. card.ability.extra.x_mult,
                Xmult_mod = card.ability.extra.x_mult
            }
        end

        if context.end_of_round and context.main_eval and not context.blueprint then
            if pseudorandom('platanito') < G.GAME.probabilities.normal / card.ability.extra.odds then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.collide.can = false
                        
                        card:start_dissolve({G.C.RED}, nil, 1.6)
                        return true
                    end
                }))
                return {
                    message = "Destroyed!",
                    colour = G.C.RED
                }
            end
        end
    end
}