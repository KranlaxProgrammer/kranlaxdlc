SMODS.Joker{
    key = "christmastree",
    config = { extra = {} },
    pos = { x = 0, y = 0 },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = false,
    atlas = 'CustomJokers',
    discovered = false,

    check_for_unlock = function(self, args)
        if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
            if (G.PROFILES[G.SETTINGS.profile].kranlaxs_regift_sold or 0) >= 5 then return true end
        end
        return false
    end,

    locked_loc_vars = function(self, info_queue, card)
        local count = G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].kranlaxs_regift_sold or 0
        return { vars = { count } }
    end,

    loc_vars = function(self, info_queue, card)
        local count = G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].kranlaxs_regift_sold or 0
        return { vars = { count } }
    end,

    calculate = function(self, card, context)
        if context.end_of_round and not context.repetition and not context.individual then
            if G.GAME.current_round.hands_played > 1 then
                if #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
                    G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            local new_card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_kranlaxs_regift', 'xmas')
                            new_card:add_to_deck()
                            G.jokers:emplace(new_card)
                            G.GAME.joker_buffer = 0
                            return true
                        end
                    }))
                    return { message = '¡Re-regalo!', colour = G.C.GREEN }
                end
            end
        end
    end
}

if not SMODS.kranlaxs_christmastree_sell_hook then
    local orig_sell_card = Card.sell_card
    function Card:sell_card()
        if self.config and self.config.center and self.config.center.key == 'j_kranlaxs_regift' then
            if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
                G.PROFILES[G.SETTINGS.profile].kranlaxs_regift_sold = (G.PROFILES[G.SETTINGS.profile].kranlaxs_regift_sold or 0) + 1
                G:save_progress()
            end
        end
        if orig_sell_card then orig_sell_card(self) end
    end
    SMODS.kranlaxs_christmastree_sell_hook = true
end