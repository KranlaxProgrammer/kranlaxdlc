SMODS.Joker{
    key = "benchwarmer",
    config = { extra = { mult_chips = 4 } },
    pos = { x = 5, y = 0 },
    display_size = { w = 71, h = 95 },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_mycustom_jokers"] = true },

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
        local max_chips = 0
        if G.hand and G.hand.cards then
            for _, c in ipairs(G.hand.cards) do
                if c.base and c.base.nominal and not c.debuff then
                    if c.base.nominal > max_chips then max_chips = c.base.nominal end
                end
            end
        end
        return { vars = { max_chips * (card.ability.extra.mult_chips or 4) } }
    end,
    
    calculate = function(self, card, context)
        
        if context.individual and context.cardarea == G.hand and not context.end_of_round then
            local max_chips = 0
            
            
            if G.hand and G.hand.cards then
                for _, c in ipairs(G.hand.cards) do
                    if c.base and c.base.nominal and not c.debuff then
                        if c.base.nominal > max_chips then max_chips = c.base.nominal end
                    end
                end
            end
            
            
            if context.other_card.base.nominal == max_chips and not context.other_card.debuff then
                local earned_chips = max_chips * (card.ability.extra.mult_chips or 4)
                if earned_chips > 0 then
                    return {
                        h_chips = earned_chips,
                        card = card
                    }
                end
            end
        end
    end
}