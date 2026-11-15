SMODS.Joker{
    key = "capricorn",
    pos = { x = 02, y = 012 }, 
    display_size = { w = 71, h = 95 },
    cost = 10,
    bm_cost = 4, 
    rarity = "kranlaxs_zenith",
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',
    
    is_constellation = true, 
    
    set_badges = function(self, card, badges)
        local badge_text = "Constellation"
        if G.localization and G.localization.misc and G.localization.misc.dictionary and G.localization.misc.dictionary.k_constellation then
            badge_text = G.localization.misc.dictionary.k_constellation
        else
            if G.SETTINGS.language == 'es_419' or G.SETTINGS.language == 'es_ES' then badge_text = "Constelación" end
        end
        badges[#badges + 1] = create_badge(badge_text, HEX('3D266B'), G.C.WHITE, 1.2)
    end,

    check_for_unlock = function(self, args)
        if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
            if (G.PROFILES[G.SETTINGS.profile].kranlaxs_bm_purchases or 0) >= 5 then return true end
        end
        return false
    end,

    locked_loc_vars = function(self, info_queue, card)
        local prog = (G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].kranlaxs_bm_purchases) or 0
        return {vars = { prog }} 
    end,
    
    loc_vars = function(self, info_queue, card)
        local prog = (G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].kranlaxs_bm_purchases) or 0
        return {vars = { prog }} 
    end,
    
    calculate = function(self, card, context) end
}

if not SMODS.kranlaxs_capricorn_hook then
    local orig_update = Card.update
    function Card:update(dt)
        if orig_update then orig_update(self, dt) end
        if self.config.center.key == 'j_kranlaxs_capricorn' and self.area == G.jokers and not self.debuff then
            if G.GAME and G.GAME.kranlaxs_evil_meter and G.GAME.kranlaxs_evil_meter < 20 then
                G.GAME.kranlaxs_evil_meter = 20
            end
        end
    end
    SMODS.kranlaxs_capricorn_hook = true
end