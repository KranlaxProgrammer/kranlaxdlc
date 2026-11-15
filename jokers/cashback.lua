
if not SMODS.kranlaxs_cashback_hook then
    local orig_ease_dollars = ease_dollars
    function ease_dollars(mod, instant)
        if mod < 0 and G.jokers and G.jokers.cards then
            local cashback_cards = {}
            for _, v in ipairs(G.jokers.cards) do
                if v.config.center.key == 'j_kranlaxs_Cashback' and not v.debuff then
                    table.insert(cashback_cards, v)
                end
            end
            
            
            orig_ease_dollars(mod, instant)
            
            
            if #cashback_cards > 0 then
                for _, card in ipairs(cashback_cards) do
                    if pseudorandom('cashback_roll') < (G.GAME.probabilities.normal or 1) / card.ability.extra.odds then
                        
                        local refund = math.ceil(math.abs(mod) / 2)
                        if refund > 0 then
                            G.E_MANAGER:add_event(Event({
                                trigger = 'after',
                                delay = 0.2,
                                func = function()
                                    orig_ease_dollars(refund, instant)
                                    card:juice_up(0.5, 0.5)
                                    play_sound('coin1')
                                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = "+$"..tostring(refund), colour = G.C.MONEY})
                                    return true
                                end
                            }))
                        end
                    end
                end
            end
            return
        end
        orig_ease_dollars(mod, instant)
    end
    SMODS.kranlaxs_cashback_hook = true
end

SMODS.Joker {
    key = "Cashback",
    atlas = 'CustomJokers',
    pos = { x = 0, y = 0 },
    rarity = "kranlaxs_zenith",
    cost = 6,
    bm_cost = 5,
    unlocked = false,
    discovered = false,
    blueprint_compat = true,
    config = { extra = { odds = 2 } },
    
    check_for_unlock = function(self, args)
        if args and args.type == 'win' then
            if G.GAME and G.GAME.selected_back and G.GAME.selected_back.effect.center.key == 'b_kranlaxs_space_deck' and G.GAME.stake == 'red' then
                return true
            end
        end
        return false
    end,
    
    loc_vars = function(self, info_queue, card)
        return { vars = { G.GAME.probabilities.normal or 1, card.ability.extra.odds } }
    end,
    
    calculate = function(self, card, context)
        
    end
}