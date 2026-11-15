SMODS.Consumable {
    key = 'theemperor',
    set = 'InverseTarot',
    pos = { x = 0, y = 1 },
    cost = 5,
    unlocked = true,
    discovered = false,
    hidden = false,
    can_repeat_soul = false,
    atlas = 'CustomConsumables',

    in_pool = function(self, args)
        if SMODS.showman and SMODS.showman('c_kranlaxs_' .. self.key) then return true end
        if not G.consumeables or not G.consumeables.cards then return true end
        for _, v in ipairs(G.consumeables.cards) do
            if v.config.center.key == 'c_kranlaxs_' .. self.key then return false end
        end
        return true
    end,
    
    use = function(self, card, area, copier)
        local used_card = copier or card
        
        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.4,
            func = function()
                play_sound('tarot1')
                used_card:juice_up(0.3, 0.5)
                
                
                for i = 1, 2 do
                    local tag = Tag(get_next_tag_key('emperor_tag'))
                    add_tag(tag)
                end
                
                play_sound('generic1', 0.9, 0.8)
                return true
            end
        }))
    end,
    
    can_use = function(self, card)
        return true
    end
}