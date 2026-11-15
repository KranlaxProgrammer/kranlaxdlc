SMODS.Joker{
    key = "brokenmodem",
    config = { extra = { odds = 5 } },
    pos = { x = 012, y = 07 }, 
    cost = 5,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    check_for_unlock = function(self, args)
        local p = G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile]
        if p and p.deck_usage and p.deck_usage['b_red'] and p.deck_usage['b_red'].wins_by_key then
            local w = p.deck_usage['b_red'].wins_by_key
            if (w['stake_kranlaxs_glass'] or 0) > 0 and (w['stake_crimson'] or w['stake_kranlaxs_crimson'] or 0) > 0 then
                return true
            end
        end
        return false
    end,

    locked_loc_vars = function(self, info_queue, card)
        local glass = 0; local crimson = 0
        local p = G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile]
        if p and p.deck_usage and p.deck_usage['b_red'] and p.deck_usage['b_red'].wins_by_key then
            local w = p.deck_usage['b_red'].wins_by_key
            if (w['stake_kranlaxs_glass'] or 0) > 0 then glass = 1 end
            if (w['stake_crimson'] or w['stake_kranlaxs_crimson'] or 0) > 0 then crimson = 1 end
        end
        return { vars = { glass, crimson } }
    end,

    loc_vars = function(self, info_queue, card)
        local glass = 0; local crimson = 0
        local p = G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile]
        if p and p.deck_usage and p.deck_usage['b_red'] and p.deck_usage['b_red'].wins_by_key then
            local w = p.deck_usage['b_red'].wins_by_key
            if (w['stake_kranlaxs_glass'] or 0) > 0 then glass = 1 end
            if (w['stake_crimson'] or w['stake_kranlaxs_crimson'] or 0) > 0 then crimson = 1 end
        end
        local odds = card and card.ability.extra.odds or self.config.extra.odds
        return { vars = { glass, crimson, G.GAME and G.GAME.probabilities.normal or 1, odds } }
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

    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play then
            if pseudorandom('brokenmodem') < G.GAME.probabilities.normal / card.ability.extra.odds then
                return {
                    message = '¡Re-señal!',
                    repetitions = 1,
                    card = card
                }
            end
        end
    end
}