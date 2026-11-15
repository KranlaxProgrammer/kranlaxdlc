SMODS.Joker{
    key = "cancer",
    pos = { x = 05, y = 012 }, 
    display_size = { w = 71, h = 95 },
    cost = 10,
    bm_cost = 5, 
    rarity = "kranlaxs_zenith",
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',

    is_constellation = true, 
    
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
    
    loc_vars = function(self, info_queue, card)
        local ante = G.GAME and G.GAME.round_resets and G.GAME.round_resets.ante or 1
        local current_odds = 4 + math.max(0, 9 - ante)
        
        return {vars = {"1", current_odds}}
    end,

    calculate = function(self, card, context)
        if context.game_over and not context.blueprint then
            local ante = G.GAME and G.GAME.round_resets and G.GAME.round_resets.ante or 1
            local current_odds = 4 + math.max(0, 9 - ante)
            
            if pseudorandom('cancer_save') < (1 / current_odds) then
                return {
                    message = "¡Salvado!",
                    saved = 'ph_kranlaxs_cancer',
                    colour = G.C.RED
                }
            end
        end
    end
}