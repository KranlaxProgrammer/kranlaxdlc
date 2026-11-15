SMODS.Consumable {
    key = 'wildcard',
    set = 'UNOCards',
    pos = { x = 4, y = 0 },
    cost = 3,
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
        if G.hand and #G.hand.highlighted > 0 then
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.4,
                func = function()
                    play_sound('tarot1')
                    used_card:juice_up(0.3, 0.5)
                    
                    for _, c in ipairs(G.hand.highlighted) do
                        c:flip()
                    end
                    play_sound('card1', 1)
                    return true
                end
            }))
            
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.2,
                func = function()
                    for _, c in ipairs(G.hand.highlighted) do
                        
                        c:set_ability(G.P_CENTERS.m_wild, nil, true)
                        
                        local ed = poll_edition('wildcard_ed', nil, true, true)
                        if ed then 
                            c:set_edition(ed, true, true) 
                        else 
                            c:set_edition({foil = true}, true, true) 
                        end
                    end
                    return true
                end
            }))
            
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.2,
                func = function()
                    for _, c in ipairs(G.hand.highlighted) do
                        c:flip()
                        c:juice_up(0.3, 0.3)
                    end
                    play_sound('tarot2', 1, 0.6)
                    return true
                end
            }))
        end
    end,
    
    can_use = function(self, card)
        
        return G.hand and G.hand.highlighted and #G.hand.highlighted > 0
    end
}