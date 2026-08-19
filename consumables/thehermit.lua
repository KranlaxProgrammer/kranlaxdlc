SMODS.Consumable {
    key = 'thehermit',
    set = 'InverseTarot',
    pos = { x = 5, y = 1 },
    cost = 5,
    unlocked = true,
    discovered = false,
    hidden = false,
    can_repeat_soul = false,
    atlas = 'CustomConsumables',

    in_pool = function(self, args)
        if not G.consumeables or not G.consumeables.cards then return true end
        
        for _, v in ipairs(G.consumeables.cards) do
            if v.config.center.key == 'c_kranlaxs_' .. self.key then
                return false 
            end
        end
        
        return true
    end,
    
    use = function(self, card, area, copier)
        local used_card = copier or card
        
        -- ¡AQUÍ ESTABA LA PARADOJA! Cambiado a menor que (<)
        if to_big(G.GAME.dollars) < to_big(25) then
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.4,
                func = function()
                    local current_dollars = G.GAME.dollars
                    local dollar_value = 25 - current_dollars
                    card_eval_status_text(used_card, 'extra', nil, nil, nil, {message = "Set to $25", colour = G.C.MONEY})
                    ease_dollars(dollar_value, true)
                    return true
                end
            }))
        end
    end,
    
    can_use = function(self, card)
        return to_big(G.GAME.dollars) < to_big(25)
    end
}