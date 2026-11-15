SMODS.Joker{
    key = "thechampion",
    config = {
        extra = {
            blind_size0 = 1.75,
            interest_bonus = 2
        }
    },
    pos = { x = 4, y = 1 },
    display_size = { w = 71, h = 95 },
    cost = 5,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    discovered = false, 
    
    check_for_unlock = function(self, args)
        if args.type == 'ante_up' and args.ante >= 16 then return true end
        if args.type == 'round_win' and G.GAME.round_resets.ante >= 16 then return true end
        return false
    end,

    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },
    
    loc_vars = function(self, info_queue, card)
        local unbal = SMODS.Mods["kranlaxs"] and SMODS.Mods["kranlaxs"].config.unbalanced_mode
        local b_size = unbal and 1.5 or card.ability.extra.blind_size0
        return {vars = {b_size, card.ability.extra.interest_bonus}}
    end,
    
    calc_dollar_bonus = function(self, card)
        if G.GAME.dollars >= 5 then
            local instances = math.min(math.floor(G.GAME.dollars / 5), math.floor((G.GAME.interest_cap or 25) / 5))
            if instances > 0 then
                return instances * card.ability.extra.interest_bonus
            end
        end
        return 0
    end,
    
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            if G.GAME.blind and G.GAME.blind.in_blind then
                local unbal = SMODS.Mods["kranlaxs"] and SMODS.Mods["kranlaxs"].config.unbalanced_mode
                local b_size = unbal and 1.5 or card.ability.extra.blind_size0
                
                return {
                    func = function()
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = "X" .. b_size .. " Blind Size", colour = G.C.RED})
                        G.GAME.blind.chips = math.floor(G.GAME.blind.chips * b_size)
                        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                        G.HUD_blind:recalculate()
                        return true
                    end
                }
            end
        end
    end
}