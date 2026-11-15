SMODS.Joker {
    key = 'beingoflight',
    atlas = 'CustomJokers',
    pos = { x = 10, y = 0 },
    rarity = 3,
    cost = 8,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    
    loc_vars = function(self, info_queue, card) return { vars = {} } end,
    
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
        if context.individual and context.cardarea == G.play then
            if not context.other_card.edition then
                if pseudorandom('beingoflight') < 1 / 12 then
                    context.other_card:set_edition({kranlaxs_cosmic = true}, true, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound('kranlaxs_cosmicedition', 1, 1)
                            return true
                        end
                    }))
                    return {
                        extra = {message = "Cosmico", colour = G.C.DARK_EDITION},
                        card = card
                    }
                end
            end
        end
    end
}