SMODS.Consumable {
    key = 'grayquartz',
    set = 'Quartz',
    pos = { x = 5, y = 0 }, 
    cost = 5,
    unlocked = false, 
    discovered = false,
    unlock_condition = {type = '', extra = ''},
    atlas = 'QuartzConsumables',

    in_pool = function(self, args)
        if SMODS.showman and SMODS.showman('c_kranlaxs_' .. self.key) then return true end
        if not G.consumeables or not G.consumeables.cards then return true end
        for _, v in ipairs(G.consumeables.cards) do
            if v.config.center.key == 'c_kranlaxs_' .. self.key then return false end
        end
        return true
    end,
    
    can_use = function(self, card)
        local joker_selected = (G.jokers and G.jokers.highlighted) and #G.jokers.highlighted or 0
        local cons_selected = 0
        
        
        if G.consumeables and G.consumeables.highlighted then
            for _, v in ipairs(G.consumeables.highlighted) do
                if v ~= card then
                    cons_selected = cons_selected + 1
                end
            end
        end
        
        return (joker_selected + cons_selected) == 1
    end,
    
    use = function(self, card, area, copier)
        local used_card = copier or card
        local target_card = nil
        
        if G.jokers and G.jokers.highlighted and #G.jokers.highlighted == 1 then
            target_card = G.jokers.highlighted[1]
        elseif G.consumeables and G.consumeables.highlighted then
            
            for _, v in ipairs(G.consumeables.highlighted) do
                if v ~= used_card then
                    target_card = v
                    break
                end
            end
        end
        
        if target_card then
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.4,
                func = function()
                    play_sound('tarot1')
                    used_card:juice_up(0.3, 0.5)
                    return true
                end
            }))
            
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.2,
                func = function()
                    target_card:juice_up(0.3, 0.5)
                    play_sound('holo1', 1.2, 1.4)
                    
                    target_card:set_edition({negative = true}, true, true)
                    return true
                end
            }))
        end
    end,

    
    check_for_unlock = function(self, args)
        if args.type == 'win' then
            
            if G.GAME.selected_back.effect.center.key == 'b_painted' and G.GAME.stake == 'kranlaxs_turquoise' then
                return true 
            end
        end
        return false
    end
}




if not SMODS.gray_quartz_limit_hook then
    local original_update = Game.update
    function Game:update(dt)
        original_update(self, dt)
        
        if G.consumeables and G.consumeables.config.highlighted_limit < 2 then
            G.consumeables.config.highlighted_limit = 2
        end
    end
    SMODS.gray_quartz_limit_hook = true
end