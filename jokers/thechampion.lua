SMODS.Joker{
    key = "thechampion",
    config = {
        extra = {
            blind_size0 = 2.25,
            blind_reward0 = 8
        }
    },
    pos = { x = 4, y = 1 },
    display_size = { w = 71, h = 95 },
    cost = 5,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    
    -- ===================================================
    -- SISTEMA DE DESBLOQUEO
    -- ===================================================
    unlocked = false, -- Falso para que aparezca con el candado en la colección
    discovered = false, 
    
    check_for_unlock = function(self, args)
        -- Cuando subes de Ante (derrotas al jefe)
        if args.type == 'ante_up' and args.ante >= 16 then
            return true
        end
        -- Seguro de respaldo por si cargas una partida ya en la Ante 16
        if args.type == 'round_win' and G.GAME.round_resets.ante >= 16 then
            return true
        end
    end,
    -- ===================================================

    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true }, 

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
        return {vars = {card.ability.extra.blind_size0, card.ability.extra.blind_reward0}}
    end,
    
    calc_dollar_bonus = function(self, card)
        if card.ability.extra.blind_reward0 > 0 then
            return card.ability.extra.blind_reward0
        end
    end,
    
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            if G.GAME.blind and G.GAME.blind.in_blind then
                return {
                    func = function()
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = "X" .. card.ability.extra.blind_size0 .. " Blind Size", colour = G.C.RED})
                        G.GAME.blind.chips = math.floor(G.GAME.blind.chips * card.ability.extra.blind_size0)
                        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                        G.HUD_blind:recalculate()
                        return true
                    end
                }
            end
        end
    end
}