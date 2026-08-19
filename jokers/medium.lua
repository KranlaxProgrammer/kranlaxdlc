SMODS.Joker{
    key = 'medium',
    config = { extra = { mult = 1 } },
    rarity = 3,
    atlas = 'CustomJokers',
    pos = { x = 7, y = 7 },
    cost = 8,
    blueprint_compat = true,
    
    -- ===================================================
    -- SISTEMA DE DESBLOQUEO
    -- ===================================================
    unlocked = false,
    discovered = false,
    unlock_condition = {type = '', extra = ''},
    
    check_for_unlock = function(self, args)
        if G.PROFILES and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].career_stats then
            local perdidas = G.PROFILES[G.SETTINGS.profile].career_stats.c_losses or 0
            if perdidas >= 1 then
                return true
            end
        end
        return false
    end,
    
    locked_loc_vars = function(self, info_queue, card)
        local perdidas = 0
        if G.PROFILES and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].career_stats then
            perdidas = G.PROFILES[G.SETTINGS.profile].career_stats.c_losses or 0
        end
        return {vars = {perdidas}}
    end,
    -- ===================================================

    loc_vars = function(self, info_queue, card)
        local perdidas = 0
        if G.PROFILES and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].career_stats then
            perdidas = G.PROFILES[G.SETTINGS.profile].career_stats.c_losses or 0
        end
        return { vars = { card.ability.extra.mult, perdidas * card.ability.extra.mult } }
    end,
    
    calculate = function(self, card, context)
        if context.joker_main then
            local perdidas = 0
            if G.PROFILES and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].career_stats then
                perdidas = G.PROFILES[G.SETTINGS.profile].career_stats.c_losses or 0
            end
            local mult = perdidas * card.ability.extra.mult
            if mult > 0 then
                return {
                    mult_mod = mult,
                    message = localize{type='variable',key='a_mult',vars={mult}}
                }
            end
        end
    end
}