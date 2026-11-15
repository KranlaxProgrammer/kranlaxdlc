SMODS.Joker{
    key = "diligencia",
    config = { extra = { mult_per = 5 }, holy = true },
    pos = { x = 0, y = 0 },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    set_badges = function(self, card, badges)
        local badge_text = (G.SETTINGS.language == 'es_419' or G.SETTINGS.language == 'es_ES') and "Sagrada" or "Holy"
        badges[#badges + 1] = create_badge(badge_text, HEX('FFD700'), G.C.WHITE, 1.2)
    end,

    loc_vars = function(self, info_queue, card)
        local ante = (G.GAME and G.GAME.round_resets and G.GAME.round_resets.ante) or 1
        return { vars = { card.ability.extra.mult_per, ante * card.ability.extra.mult_per } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local ante = (G.GAME and G.GAME.round_resets and G.GAME.round_resets.ante) or 1
            local mult = ante * card.ability.extra.mult_per
            if mult > 0 then
                return {
                    message = "+" .. mult .. " Mult",
                    mult_mod = mult,
                    colour = G.C.MULT
                }
            end
        end
    end
}