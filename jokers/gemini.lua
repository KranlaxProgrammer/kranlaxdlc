SMODS.Joker{
    key = "gemini",
    config = { extra = { odds = 8 } },
    pos = { x = 02, y = 011 }, 
    display_size = { w = 71, h = 95 },
    cost = 5,
    rarity = 2, 
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',
    is_constellation = true, 

    check_for_unlock = function(self, args)
        if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
            if G.PROFILES[G.SETTINGS.profile].kranlaxs_invisible_sold_boss then return true end
        end
        return false
    end,

    in_pool = function(self, args)
        if SMODS.showman and SMODS.showman('j_kranlaxs_' .. self.key) then return true end
        local areas_to_check = {G.jokers, G.shop_jokers, G.pack_cards}
        for _, area in ipairs(areas_to_check) do
            if area and area.cards then
                for _, v in ipairs(area.cards) do
                    if v.config and v.config.center and v.config.center.key == 'j_kranlaxs_' .. self.key then return false end
                end
            end
        end
        return true
    end,
    
    set_badges = function(self, card, badges)
        local badge_text = "Constellation"
        if G.localization and G.localization.misc and G.localization.misc.dictionary and G.localization.misc.dictionary.k_constellation then
            badge_text = G.localization.misc.dictionary.k_constellation
        else
            if G.SETTINGS.language == 'es_419' or G.SETTINGS.language == 'es_ES' then badge_text = "Constelación" end
        end
        badges[#badges + 1] = create_badge(badge_text, HEX('3D266B'), G.C.WHITE, 1.2)
    end,
    
    loc_vars = function(self, info_queue, card)
        local unbal = SMODS.Mods["kranlaxs"] and SMODS.Mods["kranlaxs"].config.unbalanced_mode
        local final_odds = unbal and 6 or card.ability.extra.odds
        return {vars = {G.GAME.probabilities.normal, final_odds}}
    end,
    
    calculate = function(self, card, context)
        if context.end_of_round and not context.individual and not context.repetition then
            if G.GAME.blind.boss then
                local unbal = SMODS.Mods["kranlaxs"] and SMODS.Mods["kranlaxs"].config.unbalanced_mode
                local final_odds = unbal and 6 or card.ability.extra.odds
                
                if pseudorandom('gemini') < G.GAME.probabilities.normal / final_odds then
                    if G.jokers and #G.jokers.cards < G.jokers.config.card_limit then
                        local valid_jokers = {}
                        for _, j in ipairs(G.jokers.cards) do
                            if j ~= card then table.insert(valid_jokers, j) end
                        end
                        
                        if #valid_jokers > 0 then
                            local chosen = pseudorandom_element(valid_jokers, pseudoseed('gemini_choice'))
                            local copy = copy_card(chosen, nil, nil, nil, chosen.playing_card)
                            copy:add_to_deck()
                            G.jokers:emplace(copy)
                            return { message = "¡Gemelo!", colour = G.C.BLUE }
                        end
                    end
                end
            end
        end
    end
}

-- Hook global para detectar la venta de 'j_invisible' en una ciega jefe
if not SMODS.kranlaxs_gemini_sell_hook then
    local orig_sell = Card.sell_card
    function Card:sell_card()
        if self.config and self.config.center and self.config.center.key == 'j_invisible' then
            if G.GAME and G.GAME.blind and G.GAME.blind.boss then
                if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
                    G.PROFILES[G.SETTINGS.profile].kranlaxs_invisible_sold_boss = true
                    G:save_progress()
                end
            end
        end
        if orig_sell then orig_sell(self) end
    end
    SMODS.kranlaxs_gemini_sell_hook = true
end