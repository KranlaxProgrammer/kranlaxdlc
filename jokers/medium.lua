SMODS.Joker{
    key = 'medium',
    config = { extra = { chips = 1 } }, 
    rarity = 3,
    atlas = 'CustomJokers',
    pos = { x = 7, y = 7 },
    cost = 8,
    blueprint_compat = true,
    unlocked = false,
    discovered = false,

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
    
    check_for_unlock = function(self, args)
        if G.PROFILES and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].career_stats then
            local perdidas = G.PROFILES[G.SETTINGS.profile].career_stats.c_losses or 0
            if perdidas >= 1 then return true end
        end
        return false
    end,

    locked_loc_vars = function(self, info_queue, card)
        local perdidas = 0
        if G.PROFILES and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].career_stats then
            perdidas = G.PROFILES[G.SETTINGS.profile].career_stats.c_losses or 0
        end
        return { vars = { perdidas } }
    end,

    loc_vars = function(self, info_queue, card)
        local perdidas = 0
        if G.PROFILES and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].career_stats then
            perdidas = G.PROFILES[G.SETTINGS.profile].career_stats.c_losses or 0
        end
        
        local chips = card and card.ability and card.ability.extra and card.ability.extra.chips or self.config.extra.chips
        local unbal = SMODS.Mods["kranlaxs"] and SMODS.Mods["kranlaxs"].config.unbalanced_mode
        local tipo = unbal and "multi" or "fichas"
        
        return { vars = { perdidas, chips, perdidas * chips, tipo } }
    end,
    
    calculate = function(self, card, context)
        if context.joker_main then
            local perdidas = 0
            if G.PROFILES and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].career_stats then
                perdidas = G.PROFILES[G.SETTINGS.profile].career_stats.c_losses or 0
            end
            
            local total_bonus = perdidas * card.ability.extra.chips
            
            if total_bonus > 0 then
                local unbal = SMODS.Mods["kranlaxs"] and SMODS.Mods["kranlaxs"].config.unbalanced_mode
                if unbal then
                    return { mult_mod = total_bonus, message = localize{type='variable', key='a_mult', vars={total_bonus}}, colour = G.C.MULT }
                else
                    return { chip_mod = total_bonus, message = localize{type='variable', key='a_chips', vars={total_bonus}}, colour = G.C.CHIPS }
                end
            end
        end
    end
}