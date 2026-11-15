SMODS.Joker {
    key = 'transmuter',
    atlas = 'CustomJokers',
    pos = { x = 1, y = 9 },
    rarity = 2,
    cost = 5,
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
            local unbal = SMODS.Mods["kranlaxs"] and SMODS.Mods["kranlaxs"].config.unbalanced_mode
            local chips = 0
            
            if unbal then
                -- Obtiene base + Mejora de Bono + Fichas permanentes
                chips = context.other_card:get_chip_bonus() 
                -- Suma Fichas de Edición (Laminada)
                if context.other_card.edition and context.other_card.edition.chips then
                    chips = chips + context.other_card.edition.chips
                end
            else
                -- Obtiene estrictamente el valor nominal impreso
                chips = context.other_card.base.nominal or 0
            end
            
            if chips > 0 then
                return {
                    mult = chips,
                    card = card
                }
            end
        end
    end
}