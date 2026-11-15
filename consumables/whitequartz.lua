SMODS.Consumable {
    key = 'whitequartz',
    set = 'Quartz',
    pos = { x = 1, y = 0 }, 
    cost = 3,
    unlocked = false, 
    discovered = false,
    unlock_condition = {type = '', extra = ''},
    atlas = 'QuartzConsumables', 
    
    config = { extra = { saved_card = 'none' } }, 

    in_pool = function(self, args)
        if SMODS.showman and SMODS.showman('c_kranlaxs_' .. self.key) then return true end
        if not G.consumeables or not G.consumeables.cards then return true end
        for _, v in ipairs(G.consumeables.cards) do
            if v.config.center.key == 'c_kranlaxs_' .. self.key then return false end
        end
        return true
    end,
    
    loc_vars = function(self, info_queue, card)
        
        local saved_key = card.ability.extra and card.ability.extra.saved_card
        local card_name = '?'
        
        
        if saved_key and saved_key ~= 'none' and G.P_CENTERS[saved_key] then
            card_name = localize{type = 'name_text', key = saved_key, set = G.P_CENTERS[saved_key].set}
        end
        
        return {vars = {card_name}}
    end,
    
    can_use = function(self, card)
        local saved_key = card.ability.extra and card.ability.extra.saved_card
        
        
        return #G.consumeables.cards < G.consumeables.config.card_limit and 
               saved_key and saved_key ~= 'none'
    end,
    
    use = function(self, card, area, copier)
        local used_card = copier or card
        local saved_key = card.ability.extra and card.ability.extra.saved_card
        
        if saved_key and saved_key ~= 'none' then
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.4,
                func = function()
                    play_sound('timpani')
                    used_card:juice_up(0.3, 0.5)
                    return true
                end
            }))
            
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.4,
                func = function()
                    
                    local new_card = create_card('Consumeables', G.consumeables, nil, nil, nil, nil, saved_key, 'white_quartz')
                    new_card:add_to_deck()
                    G.consumeables:emplace(new_card)
                    return true
                end
            }))
        end
    end,

    
    check_for_unlock = function(self, args)
        if args.type == 'win' then
            
            if G.GAME.selected_back.effect.center.key == 'b_ghost' and G.GAME.stake == 'kranlaxs_brown' then
                return true 
            end
        end
        return false
    end
}





if not SMODS.whitequartz_hooked then
    local original_use_consumeable = Card.use_consumeable
    
    function Card:use_consumeable(area, copier)
        
        local key = self.config.center.key
        
        
        original_use_consumeable(self, area, copier)
        
        
        if key ~= 'c_kranlaxs_whitequartz' then
            
            
            if G.consumeables and G.consumeables.cards then
                for _, v in ipairs(G.consumeables.cards) do
                    
                    if v.config.center.key == 'c_kranlaxs_whitequartz' then
                        
                        v.ability.extra = v.ability.extra or {}
                        v.ability.extra.saved_card = key
                    end
                end
            end
        end
    end
    
    SMODS.whitequartz_hooked = true
end