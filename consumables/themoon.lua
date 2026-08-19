SMODS.Consumable {
    key = 'themoon',
    set = 'InverseTarot',
    pos = { x = 3, y = 2 },
    cost = 5,
    unlocked = true,
    discovered = false,
    hidden = false,
    can_repeat_soul = false,
    atlas = 'CustomConsumables',
    
    config = { max_highlighted = 2 },

    -- AÑADIDO: Tooltip del Sello Gris
    loc_vars = function(self, info_queue, card)
        -- Añadimos vars = {} al final
        info_queue[#info_queue+1] = {set = 'Other', key = 'kranlaxs_grayseal_seal', vars = {}}
        return {vars = {}}
    end,

    in_pool = function(self, args)
        if not G.consumeables or not G.consumeables.cards then return true end
        for _, v in ipairs(G.consumeables.cards) do
            if v.config.center.key == 'c_kranlaxs_' .. self.key then return false end
        end
        return true
    end,
    
    use = function(self, card, area, copier)
        local used_card = copier or card
        if G.hand and G.hand.highlighted and #G.hand.highlighted > 0 then
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.4,
                func = function()
                    play_sound('tarot1')
                    used_card:juice_up(0.3, 0.5)
                    for _, c in ipairs(G.hand.highlighted) do c:flip() end
                    play_sound('card1', 1)
                    return true
                end
            }))
            
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.2,
                func = function()
                    for _, c in ipairs(G.hand.highlighted) do
                        c:set_seal('kranlaxs_grayseal', true, true)
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
                    G.hand:unhighlight_all()
                    return true
                end
            }))
        end
    end,
    
    can_use = function(self, card)
        return G.hand and G.hand.highlighted and #G.hand.highlighted > 0 and #G.hand.highlighted <= self.config.max_highlighted
    end
}