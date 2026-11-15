SMODS.Joker {
    key = 'postagestamp',
    atlas = 'CustomJokers',
    pos = { x = 8, y = 9 },
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    config = { extra = { chips = 0, chip_gain = 2 } },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chip_gain, card.ability.extra.chips } }
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
        if context.joker_main and card.ability.extra.chips > 0 then
            return {
                chips = card.ability.extra.chips,
                colour = G.C.CHIPS
            }
        end
        
        if context.individual and context.cardarea == G.play and not context.blueprint then
            if context.other_card.seal then
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
                return {
                    extra = {message = "¡Sellado!", colour = G.C.CHIPS},
                    card = card
                }
            end
        end
    end
}