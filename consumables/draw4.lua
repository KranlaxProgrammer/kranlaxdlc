SMODS.Consumable {
    key = 'draw4',
    set = 'UNOCards',
    pos = { x = 0, y = 0 },
    config = { extra = { hands0 = 1 } },
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
        if G.GAME.blind.in_blind then
            if G.hand and #G.hand.cards > 0 then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after', delay = 0.4,
                    func = function()
                        card_eval_status_text(used_card, 'extra', nil, nil, nil, {message = "+4 Cards Drawn", colour = G.C.BLUE})
                        SMODS.draw_cards(4)
                        return true
                    end
                }))
            end
            
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.4,
                func = function()
                    card_eval_status_text(used_card, 'extra', nil, nil, nil, {message = "-1 Hand", colour = G.C.RED})
                    G.GAME.current_round.hands_left = math.max(0, G.GAME.current_round.hands_left - 1)
                    return true
                end
            }))
        end
    end,
    
    can_use = function(self, card)
        -- Solo se puede usar si estás dentro de una Ciega y tienes MÁS de 1 mano restante
        return G.GAME.blind and G.GAME.blind.in_blind and G.GAME.current_round.hands_left > 1
    end
}