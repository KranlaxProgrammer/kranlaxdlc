SMODS.Consumable{
    key = 'discardall',
    set = 'UNOCards',
    cost = 3,
    unlocked = true,
    discovered = false,
    atlas = 'CustomConsumables', 
    pos = { x = 5, y = 3 }, 

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
        if G.hand and G.hand.highlighted and #G.hand.highlighted == 1 then
            return true
        end
        return false
    end,
    
    use = function(self, card, area, copier)
        local target_card = G.hand.highlighted[1]
        local target_suit = target_card.base.suit
        
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)

                
                local to_discard_hand = {}
                for i = 1, #G.hand.cards do
                    if G.hand.cards[i]:is_suit(target_suit) then
                        table.insert(to_discard_hand, G.hand.cards[i])
                    end
                end

                
                local to_discard_deck = {}
                for i = 1, #G.deck.cards do
                    if G.deck.cards[i]:is_suit(target_suit) then
                        table.insert(to_discard_deck, G.deck.cards[i])
                    end
                end

                G.hand:unhighlight_all()

                
                for _, c in ipairs(to_discard_hand) do
                    G.hand:remove_card(c)
                    G.discard:emplace(c)
                end

                
                for _, c in ipairs(to_discard_deck) do
                    G.deck:remove_card(c)
                    G.discard:emplace(c)
                end

                G.hand:sort()
                
                
                local cards_to_draw = math.max(0, G.hand.config.card_limit - #G.hand.cards)
                
                
                if cards_to_draw > #G.deck.cards then 
                    cards_to_draw = #G.deck.cards 
                end
                
                if cards_to_draw > 0 then
                    
                    for i = 1, cards_to_draw do
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.15,
                            func = function()
                                if G.deck.cards[#G.deck.cards] then
                                    draw_card(G.deck, G.hand, i * 100 / cards_to_draw, 'up', true)
                                end
                                return true
                            end
                        }))
                    end
                    
                    
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.3,
                        func = function()
                            G.hand:sort()
                            return true
                        end
                    }))
                end
                
                return true
            end
        }))
    end
}