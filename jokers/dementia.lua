SMODS.Joker{
    key = "dementia",
    config = { extra = {} },
    pos = { x = 11, y = 2 }, 
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local seed_str = 'demencia_' .. G.GAME.current_round.hands_played
            local roll = pseudorandom(pseudoseed(seed_str))
            
            if roll < 0.333 then
                local amt = math.floor(pseudorandom(pseudoseed(seed_str .. 'c')) * 50) + 1
                return {
                    message = "+" .. amt .. " Fichas",
                    chip_mod = amt,
                    colour = G.C.CHIPS
                }
            elseif roll < 0.666 then
                local amt = math.floor(pseudorandom(pseudoseed(seed_str .. 'm')) * 50) + 1
                return {
                    message = "+" .. amt .. " Mult",
                    mult_mod = amt,
                    colour = G.C.MULT
                }
            else
                local amt = math.floor(pseudorandom(pseudoseed(seed_str .. 'd')) * 10) + 1
                ease_dollars(amt)
                return {
                    message = "+$" .. amt,
                    colour = G.C.MONEY
                }
            end
        end
    end
}