


if not SMODS.kranlaxs_icecreamsandwich_hook then
    local orig_ease_dollars = ease_dollars
    function ease_dollars(mod, args)
        if to_big(mod) > to_big(0) and G.STATE == G.STATES.ROUND_EVAL and G.GAME and G.GAME.blind then
            local current_blind_id = tostring(G.GAME.round_resets.ante) .. "_" .. tostring(G.GAME.blind.name)
            
            if G.GAME.kranlaxs_payout_round_id ~= current_blind_id then
                G.GAME.kranlaxs_payout_round_id = current_blind_id
                G.GAME.kranlaxs_current_payout = to_big(0)
            end
            
            G.GAME.kranlaxs_current_payout = to_big(G.GAME.kranlaxs_current_payout) + to_big(mod)
        end
        orig_ease_dollars(mod, args)
    end
    SMODS.kranlaxs_icecreamsandwich_hook = true
end




SMODS.Joker{
    key = "icecreamsandwich",
    config = {
        extra = {
            extrapay = 15,
            drop = 3,
            current_payout = 15 
        }
    },
    pos = { x = 8, y = 2 },
    display_size = { w = 71, h = 95 },
    cost = 6,
    rarity = 2,
    blueprint_compat = true, 
    eternal_compat = false,
    perishable_compat = true,
    
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_food"] = true },

    check_for_unlock = function(self, args)
        if args and args.type == 'money' then
            if G.GAME and G.GAME.kranlaxs_current_payout and to_big(G.GAME.kranlaxs_current_payout) >= to_big(50) then
                return true
            end
        end
        return false
    end,

    in_pool = function(self, args)
        if SMODS.showman and SMODS.showman('j_kranlaxs_' .. self.key) then return true end
        
        local areas_to_check = {G.jokers, G.shop_jokers, G.pack_cards}
        for _, area in ipairs(areas_to_check) do
            if area and area.cards then
                for _, v in ipairs(area.cards) do
                    if v.config and v.config.center and v.config.center.key == 'j_kranlaxs_' .. self.key then return false end
                end
            end
        end
        return true
    end,
    
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.extrapay, card.ability.extra.drop}}
    end,
    
    
    calc_dollar_bonus = function(self, card)
        local payout = card.ability.extra.current_payout or card.ability.extra.extrapay
        if payout > 0 then
            return payout
        end
        return 0
    end,

    calculate = function(self, card, context)
        
        if context.end_of_round and not context.individual and not context.repetition then
            if not context.blueprint then
                
                card.ability.extra.current_payout = card.ability.extra.extrapay
                
                
                card.ability.extra.extrapay = card.ability.extra.extrapay - card.ability.extra.drop
                
                
                if card.ability.extra.extrapay <= 0 then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after', delay = 0.5,
                        func = function()
                            play_sound('tarot1')
                            card.T.r = -0.2
                            card:juice_up(0.3, 0.4)
                            card.getting_sliced = true
                            card:start_dissolve({G.C.RED}, nil, 1.6)
                            return true
                        end
                    }))
                else
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after', delay = 0.5,
                        func = function()
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = "-$" .. card.ability.extra.drop, colour = G.C.RED})
                            return true
                        end
                    }))
                end
            else
                
                card.ability.extra.current_payout = card.ability.extra.extrapay
            end
        end
    end
}