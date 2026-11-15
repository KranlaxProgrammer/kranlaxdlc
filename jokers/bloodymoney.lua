SMODS.Joker{
    key = "dinerosangriento",
    pos = { x = 0, y = 0 }, 
    display_size = { w = 71, h = 95 },
    cost = 5,
    rarity = 2, 
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',

    check_for_unlock = function(self, args)
        if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
            if (G.PROFILES[G.SETTINGS.profile].kranlaxs_bm_purchases or 0) >= 15 then return true end
        end
        return false
    end,

    locked_loc_vars = function(self, info_queue, card)
        local count = G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].kranlaxs_bm_purchases or 0
        return { vars = { count } }
    end,

    loc_vars = function(self, info_queue, card)
        local count = G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].kranlaxs_bm_purchases or 0
        return {vars = {count}} 
    end,

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
    
    calculate = function(self, card, context)
        if context.end_of_round and not context.individual and not context.repetition then
            if G.GAME.blind.boss then
                G.GAME.kranlaxs_dark_coins = (G.GAME.kranlaxs_dark_coins or 0) + 1
                return { message = "+1 Token", colour = G.C.PURPLE }
            end
        end
    end
}