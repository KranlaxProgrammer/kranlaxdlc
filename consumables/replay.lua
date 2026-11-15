SMODS.Consumable{
    key = 'replay',
    set = 'UNOCards',
    cost = 3,
    unlocked = true,
    discovered = false,
    atlas = 'CustomConsumables', 
    pos = { x = 3, y = 3 }, 

    in_pool = function(self, args)
        if SMODS.showman and SMODS.showman('c_kranlaxs_' .. self.key) then return true end
        if not G.consumeables or not G.consumeables.cards then return true end
        for _, v in ipairs(G.consumeables.cards) do
            if v.config.center.key == 'c_kranlaxs_' .. self.key then return false end
        end
        return true
    end,
    
    
    
    can_use = function(self, card)
        if G.STATE ~= G.STATES.SELECTING_HAND then return false end
        if not G.GAME.kranlaxs_replay_memory or #G.GAME.kranlaxs_replay_memory == 0 then return false end
        
        local has_recoverable = false
        for _, c in ipairs(G.GAME.kranlaxs_replay_memory) do
            
            if c.area == G.discard then
                has_recoverable = true
                break
            end
        end
        return has_recoverable
    end,
    
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after', 
            delay = 0.4, 
            func = function()
                play_sound('card1')
                card:juice_up(0.3, 0.5)
                
                local cards_recovered = false
                
                for _, c in ipairs(G.GAME.kranlaxs_replay_memory) do
                    if c.area == G.discard then
                        G.discard:remove_card(c)
                        G.hand:emplace(c)
                        cards_recovered = true
                    end
                end
                
                if cards_recovered then
                    G.hand:sort()
                end
                
                
                G.GAME.kranlaxs_replay_memory = {}
                return true
            end
        }))
    end
}