if not SMODS.kranlaxs_fidelity_hook then
    local orig_ease_dollars = ease_dollars
    function ease_dollars(mod, instant)
        if mod < 0 and G.jokers and G.jokers.cards then
            local fidelity_cards = {}
            for _, v in ipairs(G.jokers.cards) do
                if v.config.center.key == 'j_kranlaxs_fidelitycard' and not v.debuff then
                    table.insert(fidelity_cards, v)
                end
            end
            
            orig_ease_dollars(mod, instant)
            
            if #fidelity_cards > 0 then
                for _, card in ipairs(fidelity_cards) do
                    card.ability.extra.muchBought = (card.ability.extra.muchBought or 0) + 1
                    
                    if card.ability.extra.muchBought >= 7 then
                        card.ability.extra.muchBought = 0
                        local refund = math.abs(mod) 
                        
                        local unbal = SMODS.Mods["kranlaxs"] and SMODS.Mods["kranlaxs"].config.unbalanced_mode
                        if unbal then
                            local total_sell = 0
                            for _, jc in ipairs(G.jokers.cards) do
                                total_sell = total_sell + (jc.sell_cost or 0)
                            end
                            refund = math.floor(total_sell / 2)
                        end
                        
                        if refund > 0 then
                            G.E_MANAGER:add_event(Event({
                                trigger = 'after', delay = 0.2,
                                func = function()
                                    orig_ease_dollars(refund, instant)
                                    card:juice_up(0.5, 0.5)
                                    play_sound('coin1')
                                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = "+$"..tostring(refund), colour = G.C.MONEY})
                                    return true
                                end
                            }))
                        end
                    else
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after', delay = 0.1,
                            func = function()
                                card:juice_up(0.2, 0.2)
                                card_eval_status_text(card, 'extra', nil, nil, nil, {message = card.ability.extra.muchBought.."/7", colour = G.C.ORANGE})
                                return true
                            end
                        }))
                    end
                end
            end
            return
        end
        orig_ease_dollars(mod, instant)
    end
    SMODS.kranlaxs_fidelity_hook = true
end

SMODS.Joker{
    key = "fidelitycard",
    config = { extra = { muchBought = 0, shake_timer = 0 } },
    pos = { x = 0, y = 1 },
    display_size = { w = 71, h = 95 },
    cost = 4,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

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
        return {vars = {card.ability.extra.muchBought}}
    end,
    
    update = function(self, card, dt)
        if card.area == G.jokers and card.ability.extra.muchBought >= 6 then
            card.ability.extra.shake_timer = (card.ability.extra.shake_timer or 0) + dt
            if card.ability.extra.shake_timer > 1.2 then
                card:juice_up(0.04, 0.04) 
                card.ability.extra.shake_timer = 0
            end
        end
    end,
    
    calculate = function(self, card, context) end
}