SMODS.Consumable {
    key = 'theempress',
    set = 'InverseTarot',
    pos = { x = 9, y = 0 },
    cost = 5,
    unlocked = true,
    discovered = false,
    hidden = false,
    can_repeat_soul = false,
    atlas = 'CustomConsumables',

    in_pool = function(self, args)
        -- Si el juego apenas está cargando y no hay barra de consumibles, lo permite
        if not G.consumeables or not G.consumeables.cards then return true end
        
        -- Escanea los consumibles que tienes guardados actualmente
        for _, v in ipairs(G.consumeables.cards) do
            -- Revisa si ya posees esta carta (usando el prefijo c_)
            if v.config.center.key == 'c_kranlaxs_' .. self.key then
                return false 
            end
        end
        
        return true
    end,
    
    use = function(self, card, area, copier)
        local used_card = copier or card
        if #G.hand.highlighted > 0 and #G.hand.highlighted <= 2 then
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.4,
                func = function()
                    play_sound('tarot1')
                    used_card:juice_up(0.3, 0.5)
                    return true
                end
            }))
            
            for i = 1, #G.hand.highlighted do
                local c = G.hand.highlighted[i]
                G.E_MANAGER:add_event(Event({
                    trigger = 'after', delay = 0.15,
                    func = function()
                        c:flip()
                        play_sound('card1', 1)
                        return true
                    end
                }))
                
                G.E_MANAGER:add_event(Event({
                    trigger = 'after', delay = 0.1,
                    func = function()
                        c.ability.perma_mult = (c.ability.perma_mult or 0) + 8
                        return true
                    end
                }))
                
                G.E_MANAGER:add_event(Event({
                    trigger = 'after', delay = 0.15,
                    func = function()
                        c:flip()
                        play_sound('tarot2', 1, 0.6)
                        c:juice_up(0.3, 0.3)
                        return true
                    end
                }))
            end
            
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.2,
                func = function()
                    G.hand:unhighlight_all()
                    return true
                end
            }))
        end
    end,
    
    can_use = function(self, card)
        return #G.hand.highlighted >= 1 and #G.hand.highlighted <= 2
    end
}