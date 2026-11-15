SMODS.Joker{
    key = "sushi",
    config = {
        extra = {
            reduction = 50,
            drop = 5        
        }
    },
    pos = { x = 4, y = 3 },
    display_size = { w = 71, h = 95 },
    cost = 6,
    rarity = 3,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    unlocked = false, 
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_food"] = true },
    
    check_for_unlock = function(self, args)
        if args and args.type == 'win' then
            if G.GAME and G.GAME.stake == 6 and G.GAME.selected_back and G.GAME.selected_back.effect.center.key == 'b_kranlaxs_week_challenge' then
                return true
            end
        end
        return false
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
    
    loc_vars = function(self, info_queue, card)
        local unbal = SMODS.Mods["kranlaxs"] and SMODS.Mods["kranlaxs"].config.unbalanced_mode
        local drop_amt = unbal and 10 or card.ability.extra.drop
        return {vars = {card.ability.extra.reduction, drop_amt}}
    end,
    
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            local reduction_mult = 1 - (card.ability.extra.reduction / 100)

            G.E_MANAGER:add_event(Event({
                func = function()
                    G.GAME.blind.chips = G.GAME.blind.chips * to_big(reduction_mult)
                    G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                    G.HUD_blind:recalculate()
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = "-" .. card.ability.extra.reduction .. "%", colour = G.C.GREEN})
                    return true
                end
            }))
        end

        if context.end_of_round and context.main_eval and not context.blueprint then
            local unbal = SMODS.Mods["kranlaxs"] and SMODS.Mods["kranlaxs"].config.unbalanced_mode
            local drop_amt = unbal and 10 or card.ability.extra.drop
            
            -- Modo Desbalance: Solo reduce al vencer Ciegas Jefe. Vanilla: Reduce en todas.
            local should_drop = not unbal or (unbal and G.GAME.blind.boss)
            
            if should_drop then
                card.ability.extra.reduction = card.ability.extra.reduction - drop_amt

                if card.ability.extra.reduction <= 0 then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound('tarot1')
                            card.T.r = -0.2
                            card:juice_up(0.3, 0.4)
                            card.getting_sliced = true
                            card:start_dissolve({G.C.RED}, nil, 1.6)
                            return true
                        end
                    }))
                    return {
                        message = localize('k_eaten_ex'),
                        colour = G.C.RED
                    }
                else
                    return {
                        message = "-" .. drop_amt .. "%",
                        colour = G.C.RED
                    }
                end
            end
        end
    end
}