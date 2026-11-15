SMODS.Back {
    key = 'space_deck',
    pos = { x = 3, y = 0 }, 
    atlas = 'CustomDecks',
    
    unlocked = false,
    discovered = false,
    
    check_for_unlock = function(self, args)
        if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
            if (G.PROFILES[G.SETTINGS.profile].kranlaxs_max_hand_level or 0) >= 100 then return true end
        end
        return false
    end,

    locked_loc_vars = function(self, info_queue, card)
        local count = G.PROFILES and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].kranlaxs_max_hand_level or 0
        return { vars = { count } }
    end,

    loc_vars = function(self, info_queue, card)
        local count = G.PROFILES and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].kranlaxs_max_hand_level or 0
        return { vars = { count } }
    end,
    
    apply = function(self, back)
        G.E_MANAGER:add_event(Event({
            func = function()
                local valid_hands = {"Straight Flush", "Four of a Kind", "Full House", "Flush", "Straight", "Three of a Kind", "Two Pair", "Pair", "High Card"}
                local random_hand = pseudorandom_element(valid_hands, pseudoseed('space_deck_hand'))
                
                level_up_hand(nil, random_hand, true, 4)
                update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(random_hand, 'poker_hands'),sounds={sound= 'button', volume = 0.7, pitch = 0.8}, delay=0.3})
                play_sound('tarot1')
                
                return true
            end
        }))
    end
}

if not SMODS.kranlaxs_space_deck_hooks then
    local orig_level_up = level_up_hand
    function level_up_hand(card, hand, instant, amount)
        orig_level_up(card, hand, instant, amount)
        if G.GAME and G.GAME.hands and G.GAME.hands[hand] then
            local level = G.GAME.hands[hand].level
            if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
                local max_lvl = G.PROFILES[G.SETTINGS.profile].kranlaxs_max_hand_level or 0
                if level > max_lvl then
                    G.PROFILES[G.SETTINGS.profile].kranlaxs_max_hand_level = level
                    G:save_progress()
                end
            end
        end
    end
    SMODS.kranlaxs_space_deck_hooks = true
end