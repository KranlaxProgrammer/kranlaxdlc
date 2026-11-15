SMODS.Joker {
    key = 'mysteryserum',
    atlas = 'CustomJokers',
    pos = { x = 07, y = 10 },
    rarity = 3,
    cost = 6,
    eternal_compat = false,
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
        if context.selling_self and not context.blueprint then
            local my_index = 0
            if G.jokers and G.jokers.cards then
                for i = 1, #G.jokers.cards do
                    if G.jokers.cards[i] == card then my_index = i; break end
                end
            end
            
            local left_joker = my_index > 1 and G.jokers.cards[my_index - 1] or nil
            local right_joker = my_index < #G.jokers.cards and G.jokers.cards[my_index + 1] or nil
            
            if left_joker or right_joker then
                
                local function apply_random_transformation(target)
                    if not target then return end
                    
                    local valid_new_jokers = {}
                    for k, v in pairs(G.P_CENTERS) do
                        if v.set == 'Joker' and not v.no_pool and v.unlocked and k ~= target.config.center.key then
                            table.insert(valid_new_jokers, k)
                        end
                    end
                    
                    if #valid_new_jokers > 0 then
                        local new_key = pseudorandom_element(valid_new_jokers, pseudoseed('ms_transform_rand'))
                        target:set_ability(G.P_CENTERS[new_key], true, true)
                        target:juice_up(1, 1)
                    end
                end
                
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.2,
                    func = function()
                        if left_joker then apply_random_transformation(left_joker) end
                        if right_joker then apply_random_transformation(right_joker) end
                        play_sound('tarot1')
                        return true
                    end
                }))
            end
        end
    end
}