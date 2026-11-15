SMODS.Back {
    key = 'ash_deck',
    atlas = 'CustomDecks',
    pos = { x = 7, y = 0 }, 
    config = {},
    unlocked = false, 
    discovered = false,
    
    check_for_unlock = function(self, args)
        if G.PROFILES and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].consumeable_usage then
            local c = G.PROFILES[G.SETTINGS.profile].consumeable_usage['c_immolate']
            if c and (c.count or 0) >= 5 then return true end
        end
        return false
    end,

    locked_loc_vars = function(self, info_queue, card)
        local count = 0
        if G.PROFILES and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].consumeable_usage then
            local c = G.PROFILES[G.SETTINGS.profile].consumeable_usage['c_immolate']
            if c then count = c.count or 0 end
        end
        return { vars = { count } }
    end,

    loc_vars = function(self, info_queue, card)
        local count = 0
        if G.PROFILES and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].consumeable_usage then
            local c = G.PROFILES[G.SETTINGS.profile].consumeable_usage['c_immolate']
            if c then count = c.count or 0 end
        end
        return { vars = { count } }
    end,

    apply = function(self)
        G.GAME.modifiers.ash_deck = true
    end
}

if not SMODS.kranlaxs_ash_deck_hook then
    local orig_start_run = Game.start_run
    function Game:start_run(args)
        orig_start_run(self, args)
        if G.GAME and G.GAME.modifiers and G.GAME.modifiers.ash_deck then
            
            local v1 = Card(G.ROOM.T.x, G.ROOM.T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, G.P_CENTERS['v_magic_trick'])
            v1:apply_to_run()
            G.GAME.used_vouchers['v_magic_trick'] = true
            v1:remove()
            
            local v2 = Card(G.ROOM.T.x, G.ROOM.T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, G.P_CENTERS['v_illusion'])
            v2:apply_to_run()
            G.GAME.used_vouchers['v_illusion'] = true
            v2:remove()
        end
    end

    local orig_play_cards = G.FUNCS.play_cards_from_highlighted
    G.FUNCS.play_cards_from_highlighted = function(e)
        if G.GAME and G.GAME.modifiers and G.GAME.modifiers.ash_deck then
            local destroyed_any = false
            
            if G.hand and G.hand.cards then
                for i = #G.hand.cards, 1, -1 do
                    local c = G.hand.cards[i]
                    
                    if not c.highlighted and not c.getting_sliced then
                        if pseudorandom('ash_decay' .. (G.GAME.round or 1) .. i) < (G.GAME.probabilities.normal or 1) / 4 then
                            c.getting_sliced = true
                            G.E_MANAGER:add_event(Event({
                                trigger = 'after',
                                delay = 0.15,
                                func = function()
                                    c:start_dissolve({G.C.RED}, nil, 1.6)
                                    return true
                                end
                            }))
                            destroyed_any = true
                        end
                    end
                end
            end
            
            if destroyed_any then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.1,
                    func = function() 
                        play_sound('tarot1') 
                        return true 
                    end
                }))
            end
        end
        
        orig_play_cards(e)
    end

    SMODS.kranlaxs_ash_deck_hook = true
end