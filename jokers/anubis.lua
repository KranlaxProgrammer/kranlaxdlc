SMODS.Joker{
    key = "anubis",
    config = {
        extra = {
            balance = 0
        }
    },
    pos = { x = 6, y = 5 },
    display_size = { w = 71, h = 95 },
    cost = 6,
    rarity = 3,
    blueprint_compat = false,
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

    in_pool = function(self, args)
        if not G.jokers or not G.jokers.cards then return true end
        for _, v in ipairs(G.jokers.cards) do
            if v.config.center.key == 'j_kranlaxs_' .. self.key then
                return false 
            end
        end
        return true
    end,
    
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.balance}}
    end,
    
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.blueprint then
            local has_enhancement = false
            local enhancements = SMODS.get_enhancements(context.other_card)
            for k, v in pairs(enhancements) do
                if v then
                    has_enhancement = true
                    break
                end
            end
            
            if not has_enhancement and not context.other_card.seal and not context.other_card.edition then
                card.ability.extra.balance = 1
            end
        end
        
        if context.cardarea == G.jokers and context.joker_main and not context.blueprint then
            if to_big((card.ability.extra.balance or 0)) == to_big(1) then
                card.ability.extra.balance = 0
                return {
                    balance = true
                }
            end
        end
    end
}