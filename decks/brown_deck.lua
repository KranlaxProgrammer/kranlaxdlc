SMODS.Back {
    key = 'brown_deck',
    atlas = 'CustomDecks',
    pos = { x = 5, y = 0 }, 
    unlocked = false,
    discovered = false,
    
    check_for_unlock = function(self, args)
        if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
            if (G.PROFILES[G.SETTINGS.profile].kranlaxs_destroyed_total or 0) >= 400 then return true end
        end
        return false
    end,

    locked_loc_vars = function(self, info_queue, card)
        local count = G.PROFILES and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].kranlaxs_destroyed_total or 0
        return { vars = { count } }
    end,

    loc_vars = function(self, info_queue, card)
        local count = G.PROFILES and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].kranlaxs_destroyed_total or 0
        return { vars = { count } }
    end,

    apply = function(self)
        G.GAME.modifiers.kranlaxs_coffee_deck = true
    end
}

if not SMODS.kranlaxs_coffee_deck_hooks then
    local orig_draw_from_play = G.FUNCS.draw_from_play_to_discard
    G.FUNCS.draw_from_play_to_discard = function(e)
        if G.GAME and G.GAME.modifiers and G.GAME.modifiers.kranlaxs_coffee_deck then
            if G.play and G.play.cards then
                for i = #G.play.cards, 1, -1 do
                    local card = G.play.cards[i]
                    card.getting_sliced = true
                    
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            local copy = copy_card(card, nil, nil, nil, true)
                            copy:add_to_deck()
                            G.deck.config.card_limit = G.deck.config.card_limit + 1
                            table.insert(G.playing_cards, copy)
                            
                            G.deck:emplace(copy)
                            copy.playing_card = G.playing_cards[#G.playing_cards]
                            
                            card:start_dissolve({HEX("883200")}, nil, 1.6)
                            return true
                        end
                    }))
                end
            end
        end
        if orig_draw_from_play then orig_draw_from_play(e) end
    end

    local orig_start_dissolve = Card.start_dissolve
    function Card:start_dissolve(color, silent, dissolve_time_fac, no_juice)
        if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
            G.PROFILES[G.SETTINGS.profile].kranlaxs_destroyed_total = (G.PROFILES[G.SETTINGS.profile].kranlaxs_destroyed_total or 0) + 1
            G:save_progress()
        end
        if orig_start_dissolve then orig_start_dissolve(self, color, silent, dissolve_time_fac, no_juice) end
    end

    SMODS.kranlaxs_coffee_deck_hooks = true
end