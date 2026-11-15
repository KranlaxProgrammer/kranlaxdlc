SMODS.Joker {
    key = 'semaforo',
    atlas = 'CustomJokers',
    pos = { x = 012, y = 08 }, -- Ajusta la posición de tu atlas
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },
    
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
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

    calc_dollar_bonus = function(self, card)
        local blind_type = G.GAME.blind and G.GAME.blind:get_type() or ''
        
        if blind_type == 'Small' then
            return 4
        elseif blind_type == 'Big' then
            return 2
        elseif blind_type == 'Boss' then
            return 0
        end
        
        return 0
    end
}