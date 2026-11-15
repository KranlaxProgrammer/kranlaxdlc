SMODS.Joker{
    key = "leo",
    config = { extra = { base_xmult = 2, bonus_per_eternal = 1 } },
    pos = { x = 05, y = 011 }, 
    display_size = { w = 71, h = 95 },
    cost = 10,
    bm_cost = 7, 
    rarity = "kranlaxs_zenith",
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',
    is_constellation = true, 
    
    check_for_unlock = function(self, args)
        if args.type == 'win' and G.GAME.stake >= 6 then
            local p = G.PROFILES[G.SETTINGS.profile]
            p.kranlaxs_black_wins_decks = p.kranlaxs_black_wins_decks or {}
            p.kranlaxs_black_wins_decks[G.GAME.selected_back.effect.center.key] = true
            G:save_progress()
        end
        local count = 0
        if G.PROFILES and G.PROFILES[G.SETTINGS.profile].kranlaxs_black_wins_decks then
            for k, v in pairs(G.PROFILES[G.SETTINGS.profile].kranlaxs_black_wins_decks) do count = count + 1 end
        end
        return count >= 15
    end,

    locked_loc_vars = function(self, info_queue, card)
        local count = 0
        if G.PROFILES and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].kranlaxs_black_wins_decks then
            for k, v in pairs(G.PROFILES[G.SETTINGS.profile].kranlaxs_black_wins_decks) do count = count + 1 end
        end
        return {vars = {count}}
    end,

    set_badges = function(self, card, badges)
        local badge_text = "Constellation"
        if G.localization and G.localization.misc and G.localization.misc.dictionary and G.localization.misc.dictionary.k_constellation then
            badge_text = G.localization.misc.dictionary.k_constellation
        else
            if G.SETTINGS.language == 'es_419' or G.SETTINGS.language == 'es_ES' then
                badge_text = "Constelación"
            end
        end
        badges[#badges + 1] = create_badge(badge_text, HEX('3D266B'), G.C.WHITE, 1.2)
    end,
    
    in_pool = function(self)
        return G.GAME and G.GAME.modifiers and G.GAME.modifiers.enable_eternals_in_shop
    end,

    loc_vars = function(self, info_queue, card)
        local eternal_count = 0
        if G.jokers and G.jokers.cards then
            for _, j in ipairs(G.jokers.cards) do
                if j.ability and j.ability.eternal then
                    eternal_count = eternal_count + 1
                end
            end
        end
        local current_xmult = card.ability.extra.base_xmult + (eternal_count * card.ability.extra.bonus_per_eternal)
        return {vars = {card.ability.extra.base_xmult, card.ability.extra.bonus_per_eternal, current_xmult}}
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local eternal_count = 0
            if G.jokers and G.jokers.cards then
                for _, j in ipairs(G.jokers.cards) do
                    if j.ability and j.ability.eternal then
                        eternal_count = eternal_count + 1
                    end
                end
            end
            
            local final_xmult = card.ability.extra.base_xmult + (eternal_count * card.ability.extra.bonus_per_eternal)
            
            if final_xmult > 1 then
                return {
                    message = "X" .. final_xmult .. " Mult",
                    Xmult_mod = final_xmult,
                    colour = G.C.RED
                }
            end
        end
    end
}