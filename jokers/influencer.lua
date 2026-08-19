SMODS.Joker{
    key = 'influencer',
    config = { extra = { mult = 75 } },
    rarity = 1,
    atlas = 'CustomJokers',
    pos = { x = 0, y = 8 },
    cost = 4,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if context.scoring_name == 'Five of a Kind' or context.scoring_name == 'Flush Five' or context.scoring_name == 'Flush House' then
                return {
                    mult_mod = card.ability.extra.mult,
                    message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}}
                }
            end
        end
    end
}