SMODS.Joker{
    key = "entropy2",
    config = { extra = {} },
    pos = { x = 6, y = 0 },
    display_size = { w = 71, h = 95 },
    cost = 20,
    bm_cost = 15,
    rarity = "kranlaxs_zenith",
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_mycustom_jokers"] = true },
    
    check_for_unlock = function(self, args)
        if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
            if (G.PROFILES[G.SETTINGS.profile].kranlaxs_min_deck_size or 52) <= 5 then
                return true
            end
        end
        return false
    end,

    locked_loc_vars = function(self, info_queue, card)
        local min_size = 52
        if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
            min_size = G.PROFILES[G.SETTINGS.profile].kranlaxs_min_deck_size or 52
        end
        return {vars = {min_size}}
    end,
    
    loc_vars = function(self, info_queue, card)
        local min_size = 52
        if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
            min_size = G.PROFILES[G.SETTINGS.profile].kranlaxs_min_deck_size or 52
        end
        
        local deck_size = G.playing_cards and #G.playing_cards or 52
        local unbal = SMODS.Mods["kranlaxs"] and SMODS.Mods["kranlaxs"].config.unbalanced_mode
        local factor = unbal and 2 or 1
        local power = 1 + (math.max(0, 52 - deck_size) * factor)
        
        return {vars = {min_size, power}}
    end,

    update = function(self, card, dt)
        if G.playing_cards then
            local current_size = #G.playing_cards
            if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
                local min_size = G.PROFILES[G.SETTINGS.profile].kranlaxs_min_deck_size or 52
                if current_size < min_size then
                    G.PROFILES[G.SETTINGS.profile].kranlaxs_min_deck_size = current_size
                    G:save_progress()
                end
            end
        end
    end,
    
    calculate = function(self, card, context)
        if context.joker_main then
            local deck_size = G.playing_cards and #G.playing_cards or 52
            local unbal = SMODS.Mods["kranlaxs"] and SMODS.Mods["kranlaxs"].config.unbalanced_mode
            local factor = unbal and 2 or 1
            local power = 1 + (math.max(0, 52 - deck_size) * factor)
            
            if power > 1 then
                return {
                    message = "^" .. power,
                    e_chips = power,
                    e_mult = power,
                    colour = G.C.DARK_EDITION,
                    sound = 'kranlaxs_exponentialchips'
                }
            end
        end
    end
}