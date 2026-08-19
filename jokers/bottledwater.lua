SMODS.Joker{
    key = "bottledwater",
    config = {
        extra = {
            agua = 2,
            drop = 0.01,
            cumulo = 0
        }
    },
    pos = { x = 0, y = 3 },
    display_size = { w = 71, h = 95 },
    cost = 4,
    rarity = 1,
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
            -- Verificamos Pozo Azul (stake == 5) y la baraja Reto Semanal
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
        local current_x = string.format("%.2f", card.ability.extra.agua):gsub("%.?0+$", "")
        return {vars = {current_x, card.ability.extra.drop}}
    end,
    
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.blueprint then
            card.ability.extra.cumulo = card.ability.extra.cumulo + card.ability.extra.drop
        end

        if context.joker_main then
            if card.ability.extra.agua > 1 then
                return {
                    message = "X" .. string.format("%.2f", card.ability.extra.agua),
                    Xchip_mod = card.ability.extra.agua,
                    colour = G.C.CHIPS
                }
            end
        end

        if context.after and context.cardarea == G.jokers and not context.blueprint then
            if card.ability.extra.cumulo > 0 then
                card.ability.extra.agua = card.ability.extra.agua - card.ability.extra.cumulo
                local drop_amount = card.ability.extra.cumulo
                card.ability.extra.cumulo = 0 

                if card.ability.extra.agua <= 1 then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            card.getting_sliced = true
                            card:start_dissolve({G.C.BLUE}, nil, 1.6)
                            return true
                        end
                    }))
                    return {
                        message = localize('k_eaten_ex'),
                        colour = G.C.BLUE
                    }
                else
                    return {
                        message = "-X" .. string.format("%.2f", drop_amount),
                        colour = G.C.RED
                    }
                end
            end
        end
    end
}