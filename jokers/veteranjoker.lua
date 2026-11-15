SMODS.Joker {
    key = 'legendaryhero',
    atlas = 'CustomJokers',
    pos = { x = 04, y = 10 },
    rarity = 1,
    cost = 4,
    unlocked = false,
    discovered = false,
    blueprint_compat = true,
    config = { extra = { chips = 15 } },
    
    check_for_unlock = function(self, args)
        if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].challenge_progress then
            local progress = G.PROFILES[G.SETTINGS.profile].challenge_progress.completed
            if progress then
                for k, v in pairs(progress) do
                    if v then return true end
                end
            end
        end
        return false
    end,

    locked_loc_vars = function(self, info_queue, card)
        local completed = 0
        if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].challenge_progress then
            local progress = G.PROFILES[G.SETTINGS.profile].challenge_progress.completed
            if progress then
                for k, v in pairs(progress) do
                    if v then completed = completed + 1 end
                end
            end
        end
        return { vars = { completed } }
    end,

    loc_vars = function(self, info_queue, card)
        local completed = 0
        if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].challenge_progress then
            local progress = G.PROFILES[G.SETTINGS.profile].challenge_progress.completed
            if progress then
                for k, v in pairs(progress) do
                    if v then completed = completed + 1 end
                end
            end
        end
        
        local chips = card and card.ability and card.ability.extra and card.ability.extra.chips or self.config.extra.chips
        local unbal = SMODS.Mods["kranlaxs"] and SMODS.Mods["kranlaxs"].config.unbalanced_mode
        local chip_val = unbal and 20 or chips
        
        return { vars = { completed, chip_val, completed * chip_val } }
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
        if context.joker_main then
            local completed = 0
            if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].challenge_progress then
                local progress = G.PROFILES[G.SETTINGS.profile].challenge_progress.completed
                if progress then
                    for k, v in pairs(progress) do
                        if v then completed = completed + 1 end
                    end
                end
            end
            
            local unbal = SMODS.Mods["kranlaxs"] and SMODS.Mods["kranlaxs"].config.unbalanced_mode
            local chip_val = unbal and 20 or card.ability.extra.chips
            
            local total_chips = completed * chip_val
            if total_chips > 0 then
                return { chips = total_chips, colour = G.C.CHIPS }
            end
        end
    end
}