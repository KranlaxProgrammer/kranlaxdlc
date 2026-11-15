SMODS.Joker{
    key = "anubis",
    config = {
        extra = {}
    },
    pos = { x = 6, y = 5 },
    display_size = { w = 71, h = 95 },
    cost = 6,
    rarity = "kranlaxs_zenith",
    bm_cost = 8,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    check_for_unlock = function(self, args)
        if args and args.type == 'win' then
            if G.GAME.selected_back and G.GAME.selected_back.effect.center.key == 'b_plasma' then
                if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
                    local profile = G.PROFILES[G.SETTINGS.profile]
                    profile.kranlaxs_plasma_stakes = profile.kranlaxs_plasma_stakes or {}
                    profile.kranlaxs_plasma_stakes[G.GAME.stake] = true
                end
            end
        end
        
        if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
            local stakes = G.PROFILES[G.SETTINGS.profile].kranlaxs_plasma_stakes
            if stakes then
                local all_won = true
                for i = 1, 8 do
                    if not stakes[i] then
                        all_won = false
                        break
                    end
                end
                if all_won then return true end
            end
        end
        return false
    end,
    
    loc_vars = function(self, info_queue, card)
        return {vars = {}}
    end,
    
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main then
            return {
                message = "¡Equilibrio!",
                colour = G.C.ORANGE,
                balance = true
            }
        end
    end
}