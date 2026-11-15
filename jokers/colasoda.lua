SMODS.Joker {
    key = "colasoda",
    atlas = 'CustomJokers',
    pos = { x = 7, y = 2 },
    rarity = "kranlaxs_zenith",
    cost = 6,
    unlocked = false,
    bm_cost = 4,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    config = { extra = { coca = 3, coca_drop = 0.001 } },

    check_for_unlock = function(self, args)
        if args and args.type == 'win' then
            if G.GAME and G.GAME.stake == 5 and G.GAME.selected_back and G.GAME.selected_back.effect.center.key == 'b_kranlaxs_week_challenge' then
                return true
            end
        end
        return false
    end,
    
    loc_vars = function(self, info_queue, card)
        local current_mult = string.format("%.3f", math.max(1, card.ability.extra.coca)):gsub("%.?0+$", "")
        return { vars = { current_mult, card.ability.extra.coca_drop } }
    end,
    
    update = function(self, card, dt)
        if card.area and card.area == G.jokers and not card.debuff then
            if card.ability.extra.coca > 1 then
                card.ability.extra.coca = card.ability.extra.coca - (card.ability.extra.coca_drop * dt)
                if card.ability.extra.coca <= 1 and not card.getting_sliced then
                    card.getting_sliced = true
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            card:start_dissolve({G.C.RED}, nil, 1.6)
                            return true
                        end
                    }))
                end
            end
        end
    end,
    
    calculate = function(self, card, context)
        if context.joker_main then
            if card.ability.extra.coca > 1 then
                return {
                    message = "^" .. string.format("%.2f", card.ability.extra.coca),
                    e_mult = card.ability.extra.coca,
                    colour = G.C.DARK_EDITION
                }
            end
        end
    end
}