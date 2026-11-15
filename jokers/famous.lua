SMODS.Joker{
    key = 'famous',
    config = { extra = { chips = 200 } },
    rarity = 1,
    atlas = 'CustomJokers',
    pos = { x = 1, y = 8 },
    cost = 4,
    blueprint_compat = true,

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