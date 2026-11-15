SMODS.Joker {
    key = 'statistician',
    name = 'Estadístico',
    atlas = 'CustomJokers',
    pos = { x = 3, y = 9 },
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    loc_vars = function(self, info_queue, card) return { vars = {} } end,
    
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
    
    calculate = function(self, card, context)
        
        if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
            if G.hand and G.hand.cards and #G.hand.cards > 0 then
                
                
                local ranks = {}
                for i = 1, #G.hand.cards do
                    table.insert(ranks, G.hand.cards[i].base.nominal)
                end
                
                
                table.sort(ranks)
                
                
                local mid_index = math.floor((#ranks + 1) / 2)
                local money_to_give = ranks[mid_index]
                
                if money_to_give > 0 then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.2,
                        func = function()
                            ease_dollars(money_to_give)
                            card:juice_up(0.5, 0.5)
                            play_sound('coin1')
                            return true
                        end
                    }))
                    return {
                        message = "+$" .. money_to_give,
                        colour = G.C.MONEY
                    }
                end
            end
        end
    end
}