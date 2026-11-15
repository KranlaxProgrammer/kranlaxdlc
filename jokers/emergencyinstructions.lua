SMODS.Joker{
    key = "emergencyinstructions",
    config = { extra = {} },
    pos = { x = 011, y = 08 }, 
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    loc_vars = function(self, info_queue, card) return { vars = {} } end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if G.GAME.current_round.hands_left == 0 then
                local c = context.other_card
                local chips = c.base.nominal + c:get_chip_bonus()
                local mult = c:get_chip_mult()
                local xmult = c:get_chip_x_mult(context)
                
                local ret = {}
                if chips > 0 then ret.chips = chips end
                if mult > 0 then ret.mult = mult end
                if xmult > 1 then ret.x_mult = xmult end
                
                if next(ret) then
                    ret.card = card
                    return ret
                end
            end
        end
    end
}