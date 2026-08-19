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
        if G.hand and #G.hand.cards > 0 then
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.4,
                func = function()
                    play_sound('tarot1')
                    used_card:juice_up(0.3, 0.5)
                    
                    for _, c in ipairs(G.hand.cards) do
                        c:flip()
                    end
                    play_sound('card1', 1)
                    return true
                end
            }))
            
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.2,
                func = function()
                    for _, c in ipairs(G.hand.cards) do
                        -- Elegimos un palo aleatorio para CADA carta
                        local random_suit = pseudorandom_element(SMODS.Suits, pseudoseed('uno_wildcard')).key
                        SMODS.change_base(c, random_suit, nil)
                    end
                    return true
                end
            }))
            
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.2,
                func = function()
                    for _, c in ipairs(G.hand.cards) do
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
        return G.hand and #G.hand.cards > 0
    end
}