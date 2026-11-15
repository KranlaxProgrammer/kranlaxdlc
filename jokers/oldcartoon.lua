SMODS.Joker {
    key = 'oldcartoon',
    atlas = 'CustomJokers',
    pos = { x = 08, y = 011 },
    rarity = 2,
    cost = 6,
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
                if pseudorandom('oldcartoon') < 0.10 then
                    context.other_card:set_edition({kranlaxs_sepia = true}, true, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound('kranlaxs_sepiaedition', 1, 1)
                            return true
                        end
                    }))
                    return {
                        extra = {message = "Sepia", colour = G.C.ORANGE},
                        card = card
                    }
                end
            end
        end
    end
}