SMODS.Consumable {
    key = 'temperance',
    set = 'InverseTarot',
    pos = { x = 7, y = 2 },
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
                return true
            end
        }))
        
        if G.jokers and G.jokers.cards then
            for i = #G.jokers.cards, 1, -1 do
                local j = G.jokers.cards[i]
                
                -- Se vende si no está fijado, O si está fijado pero NO estamos en un reto
                if not (j.pinned and G.GAME.challenge) then
                    
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after', delay = 0.15,
                        func = function()
                            
                            if j.ability then j.ability.eternal = false end
                            
                            j.sell_cost = (j.sell_cost or 0) * 3
                            
                            j:sell_card()
                            
                            return true
                        end
                    }))
                end
            end
        end
    end,
    
    can_use = function(self, card)
        if G.jokers and G.jokers.cards then
            for _, j in ipairs(G.jokers.cards) do
                -- La carta es usable si hay al menos un Joker que NO sea (Fijado + Reto)
                if not (j.pinned and G.GAME.challenge) then
                    return true
                end
            end
        end
        return false
    end
}