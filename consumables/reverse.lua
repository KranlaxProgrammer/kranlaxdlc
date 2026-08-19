SMODS.Consumable {
    key = 'reverse',
    set = 'UNOCards',
    pos = { x = 3, y = 0 }, 
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
        local cards_in_hand = #G.hand.cards
        
        if cards_in_hand > 0 then
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.4,
                func = function()
                    play_sound('tarot1')
                    used_card:juice_up(0.3, 0.5)
                    return true
                end
            }))

            G.E_MANAGER:add_event(Event({
                func = function()
                    for i = #G.hand.cards, 1, -1 do
                        local c = G.hand.cards[i]
                        G.hand:remove_card(c)
                        G.deck:emplace(c)
                    end
                    return true
                end
            }))

            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.3,
                func = function()
                    G.deck:shuffle('uno_reverse')
                    play_sound('paper1', 1, 0.5)
                    card_eval_status_text(used_card, 'extra', nil, nil, nil, {message = "Reverse!", colour = G.C.RED})
                    return true
                end
            }))

            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.4,
                func = function()
                    SMODS.draw_cards(cards_in_hand)
                    return true
                end
            }))
        end
    end,
    
    can_use = function(self, card)
        return G.GAME.blind and G.GAME.blind.in_blind and G.hand and #G.hand.cards > 0
    end
}