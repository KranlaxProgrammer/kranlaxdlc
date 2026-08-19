SMODS.Joker{
    key = "dispensermachine",
    config = {
        extra = {
            cost = 4
        }
    },
    pos = { x = 9, y = 2 },
    display_size = { w = 71, h = 95 },
    cost = 5,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    check_for_unlock = function(self, args)
        if G.jokers and G.jokers.cards then
            local food_count = 0
            for _, v in ipairs(G.jokers.cards) do
                if v.config and v.config.center and v.config.center.pools and v.config.center.pools["kranlaxs_food"] then
                    food_count = food_count + 1
                end
            end
            if food_count >= 4 then
                return true
            end
        end
        return false
    end,

    in_pool = function(self, args)
        if not G.jokers or not G.jokers.cards then return true end
        for _, v in ipairs(G.jokers.cards) do
            if v.config.center.key == 'j_kranlaxs_' .. self.key then
                return false 
            end
        end
        return true
    end,
    
    loc_vars = function(self, info_queue, card)
        -- EL PARCHE DE BLUEPRINT: Si Blueprint intenta leer esto, usará el valor de self.config
        local cost = (card.ability.extra and type(card.ability.extra.cost) == 'number') and card.ability.extra.cost or self.config.extra.cost
        return {vars = {cost}}
    end,
    
    calculate = function(self, card, context)
        if context.ending_shop and not context.blueprint then
            
            local is_highlighted = false
            if G.jokers and G.jokers.highlighted then
                for _, hc in ipairs(G.jokers.highlighted) do
                    if hc == card then
                        is_highlighted = true
                        break
                    end
                end
            end

            -- Protección anti-crasheos para mods como Talisman
            local _to_big = to_big or function(x) return tonumber(x) or 0 end
            local current_dollars = _to_big(G.GAME.dollars or 0)
            local safe_cost = _to_big(card.ability.extra.cost)

            if is_highlighted and current_dollars >= safe_cost then
                local cost = card.ability.extra.cost
                
                G.E_MANAGER:add_event(Event({
                    func = function()
                        ease_dollars(-cost)
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = "-$" .. cost, colour = G.C.MONEY})
                        return true
                    end
                }))
                
                G.E_MANAGER:add_event(Event({
                    delay = 0.5,
                    func = function()
                        if #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
                            G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                            
                            local valid_food = {}
                            for k, v in pairs(G.P_CENTERS) do
                                if v.pools and v.pools["kranlaxs_food"] then
                                    table.insert(valid_food, k)
                                end
                            end
                            
                            local spawned_key = #valid_food > 0 and pseudorandom_element(valid_food, pseudoseed('dispenser')) or 'j_popcorn'
                            SMODS.add_card({ set = 'Joker', key = spawned_key })
                            
                            G.GAME.joker_buffer = 0
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_plus_joker'), colour = G.C.BLUE})
                        end
                        
                        if G.jokers then G.jokers:unhighlight_all() end
                        
                        return true
                    end
                }))
            end
        end
    end
}