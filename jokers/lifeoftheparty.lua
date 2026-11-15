SMODS.Joker{
    key = "lifeoftheparty",
    config = { extra = { x_gain = 0.25 } },
    pos = { x = 11, y = 3 }, 
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    loc_vars = function(self, info_queue, card)
        local j_count = G.jokers and G.jokers.cards and #G.jokers.cards or 0
        local current_xmult = 1 + (j_count * card.ability.extra.x_gain)
        return { vars = { card.ability.extra.x_gain, current_xmult } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local j_count = G.jokers and G.jokers.cards and #G.jokers.cards or 0
            local current_xmult = 1 + (j_count * card.ability.extra.x_gain)
            
            if current_xmult > 1 then
                return { message = "X" .. current_xmult .. " Mult", Xmult_mod = current_xmult, colour = G.C.RED }
            end
        end
    end
}