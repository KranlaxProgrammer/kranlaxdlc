SMODS.Joker{
    key = "contrabandista",
    pos = { x = 0, y = 0 }, 
    display_size = { w = 71, h = 95 },
    cost = 6,
    rarity = 3, 
    -- Rework: Permite copias e indicaciones de acumulación
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',

    in_pool = function(self, args)
        -- Bloqueo por Joker Sagrado
        if G.GAME and G.FUNCS.has_holy_joker and G.FUNCS.has_holy_joker() then 
            return false 
        end
        
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
    
    loc_vars = function(self, info_queue, card) return {vars = {}} end
}