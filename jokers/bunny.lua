SMODS.Joker{
    key = "bunny",
    config = {
        extra = {
            x_bonus = 0.1
        }
    },
    pos = { x = 2, y = 3 },
    display_size = { w = 71, h = 95 },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_prey"] = true },

    in_pool = function(self, args)
        if not args then return true end
        if args.source == 'sho' or args.source == 'buf' then return false end
        if G.jokers and G.jokers.cards then
            for _, v in ipairs(G.jokers.cards) do
                if v.config.center.key == 'j_kranlaxs_' .. self.key then return false end
            end
        end
        return true
    end,
    
    loc_vars = function(self, info_queue, card)
        local unbal = SMODS.Mods["kranlaxs"] and SMODS.Mods["kranlaxs"].config.unbalanced_mode
        local bonus = unbal and 0.5 or card.ability.extra.x_bonus
        
        local bunny_count = 0
        if G.jokers and G.jokers.cards then
            for _, v in ipairs(G.jokers.cards) do
                if v.config.center.key == 'j_kranlaxs_bunny' then
                    bunny_count = bunny_count + 1
                end
            end
        end
        
        local current_xmult = 1 + (bunny_count * bonus)
        return {vars = {bonus, current_xmult}}
    end,
    
    calculate = function(self, card, context)
        if context.joker_main then
            local unbal = SMODS.Mods["kranlaxs"] and SMODS.Mods["kranlaxs"].config.unbalanced_mode
            local bonus = unbal and 0.5 or card.ability.extra.x_bonus
            
            local bunny_count = 0
            if G.jokers and G.jokers.cards then
                for _, v in ipairs(G.jokers.cards) do
                    if v.config.center.key == 'j_kranlaxs_bunny' then
                        bunny_count = bunny_count + 1
                    end
                end
            end
            
            local final_xmult = 1 + (bunny_count * bonus)
            if final_xmult > 1 then
                return {
                    message = "X" .. final_xmult,
                    Xmult_mod = final_xmult,
                    colour = G.C.MULT
                }
            end
        end
    end
}