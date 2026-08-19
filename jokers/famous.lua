SMODS.Joker{
    key = 'famous',
    config = { extra = { chips = 200 } },
    rarity = 1,
    atlas = 'CustomJokers',
    pos = { x = 1, y = 8 },
    cost = 4,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if context.scoring_name == 'Five of a Kind' or context.scoring_name == 'Flush Five' or context.scoring_name == 'Flush House' then
                return {
                    chip_mod = card.ability.extra.chips,
                    message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}}
                }
            end
        end
    end
}