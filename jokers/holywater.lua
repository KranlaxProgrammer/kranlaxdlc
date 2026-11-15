SMODS.Joker{
    key = "holywater",
    config = { extra = {}, holy = true },
    pos = { x = 012, y = 0 }, 
    cost = 8,
    rarity = 3,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    check_for_unlock = function(self, args)
        if args.type == 'win' and G.GAME.stake >= 15 then
            local p = G.PROFILES[G.SETTINGS.profile]
            p.kranlaxs_platinum_wins_decks = p.kranlaxs_platinum_wins_decks or {}
            p.kranlaxs_platinum_wins_decks[G.GAME.selected_back.effect.center.key] = true
            G:save_progress()
        end
        local count = 0
        if G.PROFILES and G.PROFILES[G.SETTINGS.profile].kranlaxs_platinum_wins_decks then
            for k, v in pairs(G.PROFILES[G.SETTINGS.profile].kranlaxs_platinum_wins_decks) do count = count + 1 end
        end
        return count >= 4
    end,

    locked_loc_vars = function(self, info_queue, card)
        local count = 0
        if G.PROFILES and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].kranlaxs_platinum_wins_decks then
            for k, v in pairs(G.PROFILES[G.SETTINGS.profile].kranlaxs_platinum_wins_decks) do count = count + 1 end
        end
        return {vars = {count}}
    end,

    set_badges = function(self, card, badges)
        local badge_text = "Holy"
        if G.localization and G.localization.misc and G.localization.misc.dictionary and G.localization.misc.dictionary.k_holy then
            badge_text = G.localization.misc.dictionary.k_holy
        else
            if G.SETTINGS.language == 'es_419' or G.SETTINGS.language == 'es_ES' then
                badge_text = "Sagrada"
            end
        end
        badges[#badges + 1] = create_badge(badge_text, HEX('FFD700'), G.C.WHITE, 1.2)
    end,

    loc_vars = function(self, info_queue, card) return { vars = {} } end,

    calculate = function(self, card, context)
        if context.selling_self and not context.blueprint then
            if G.GAME and G.GAME.kranlaxs_evil_meter then G.GAME.kranlaxs_evil_meter = 0 end
            
            if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
                G.PROFILES[G.SETTINGS.profile].kranlaxs_holy_jokers_pending = (G.PROFILES[G.SETTINGS.profile].kranlaxs_holy_jokers_pending or 0) + 1
                G:save_progress()
            end
            
            return { message = "¡Bendito!", colour = G.C.BLUE }
        end
    end
}

if not SMODS.kranlaxs_holywater_run_hook then
    local orig_start_run = Game.start_run
    function Game:start_run(args)
        orig_start_run(self, args)
        if not args.savetext then
            if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
                local pending = G.PROFILES[G.SETTINGS.profile].kranlaxs_holy_jokers_pending or 0
                if pending > 0 then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after', delay = 1.5,
                        func = function()
                            for i = 1, pending do
                                local new_card = create_card('Joker', G.jokers, nil, nil, nil, nil, nil, 'holywater_spawn')
                                new_card:add_to_deck()
                                G.jokers:emplace(new_card)
                                new_card:juice_up(0.5, 0.5)
                            end
                            play_sound('tarot1')
                            return true
                        end
                    }))
                    G.PROFILES[G.SETTINGS.profile].kranlaxs_holy_jokers_pending = 0
                    G:save_progress()
                end
            end
        end
    end
    SMODS.kranlaxs_holywater_run_hook = true
end