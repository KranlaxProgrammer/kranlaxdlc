SMODS.Joker{
    key = "colasoda",
    config = {
        extra = {
            coca = 2.5,
            coca_drop = 0.015,
            is_active = false
        }
    },
    pos = { x = 7, y = 2 },
    display_size = { w = 71, h = 95 },
    cost = 6,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    
    unlocked = false, -- ¡Cambiado a false para activar el candado!
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_food"] = true },

    -- Función que atrapa la victoria en Pozo Azul
    check_for_unlock = function(self, args)
        if args and args.type == 'win' then
            if G.GAME and G.GAME.stake == 5 and G.GAME.selected_back and G.GAME.selected_back.effect.center.key == 'b_kranlaxs_week_challenge' then
                return true
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
        local current_mult = string.format("%.3f", card.ability.extra.coca):gsub("%.?0+$", "")
        return {vars = {current_mult, card.ability.extra.coca_drop}}
    end,
    
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            card.ability.extra.is_active = true
        end

        local player_action = context.end_of_round or context.reroll_shop or context.buying_card or 
                              context.selling_card or context.ending_shop or context.starting_shop or 
                              context.ending_booster or context.skipping_booster or context.open_booster or 
                              context.skip_blind or context.before or context.pre_discard or context.discard or 
                              context.setting_blind or context.using_consumeable

        if player_action and card.ability.extra.is_active and not context.blueprint then
            card.ability.extra.coca = card.ability.extra.coca - card.ability.extra.coca_drop
            
            if card.ability.extra.coca <= 1 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card.getting_sliced = true
                        card:start_dissolve({G.C.RED}, nil, 1.6)
                        return true
                    end
                }))
            end
        end

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