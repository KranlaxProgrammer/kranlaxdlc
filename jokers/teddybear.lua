SMODS.Joker{
    key = "teddybear",
    config = { extra = { chips = 0, chip_gain = 3 } },
    pos = { x = 11, y = 0 }, 
    display_size = { w = 71, h = 95 },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

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
        return {vars = {card.ability.extra.chips, card.ability.extra.chip_gain}}
    end,

    calculate = function(self, card, context)
        
        if context.selling_card and not context.blueprint then
            if context.card and context.card.ability and context.card.ability.set == 'Joker' then
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
                
                
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = "+" .. card.ability.extra.chip_gain .. " Fichas", colour = G.C.CHIPS})
            end
        end

        
        if context.joker_main and card.ability.extra.chips > 0 then
            return {
                message = "+" .. card.ability.extra.chips,
                chip_mod = card.ability.extra.chips,
                colour = G.C.CHIPS
            }
        end
    end
}