SMODS.Joker{
    key = "envidia",
    config = { extra = { x_mult_per = 2 } },
    pos = { x = 0, y = 0 },
    cost = 20,
    bm_cost = 7,
    rarity = "kranlaxs_zenith",
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    loc_vars = function(self, info_queue, card)
        local count = 0
        if G.jokers and G.jokers.cards then
            for _, j in ipairs(G.jokers.cards) do
                if j ~= card then count = count + 1 end
            end
        end
        local total_x = count > 0 and (card.ability.extra.x_mult_per * count) or 1
        return { vars = { card.ability.extra.x_mult_per, total_x } }
    end,

    calculate = function(self, card, context)
        if context.joker_main and not context.blueprint then
            local count = 0
            if G.jokers and G.jokers.cards then
                for _, j in ipairs(G.jokers.cards) do
                    if j ~= card then count = count + 1 end
                end
            end
            
            if count > 0 then
                local total_x = card.ability.extra.x_mult_per * count
                return {
                    message = "X" .. total_x .. " Mult",
                    Xmult_mod = total_x,
                    colour = G.C.MULT
                }
            end
        end
    end
}