SMODS.Joker{
    key = "scorpio",
    config = { extra = { e_mult = 1.1 } },
    pos = { x = 03, y = 011 }, 
    display_size = { w = 71, h = 95 },
    cost = 10,
    bm_cost = 9, 
    rarity = "kranlaxs_zenith",
    blueprint_compat = true,
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
        local unbal = SMODS.Mods["kranlaxs"] and SMODS.Mods["kranlaxs"].config.unbalanced_mode
        local e_m = unbal and 1.75 or card.ability.extra.e_mult
        return {vars = {e_m}}
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local unbal = SMODS.Mods["kranlaxs"] and SMODS.Mods["kranlaxs"].config.unbalanced_mode
            local e_m = unbal and 1.75 or card.ability.extra.e_mult
            return {
                e_mult = e_m, 
                colour = G.C.DARK_EDITION,
                card = card
            }
        end
    end
}