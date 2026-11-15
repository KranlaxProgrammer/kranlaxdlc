SMODS.Joker {
    key = 'licenseplate',
    name = 'Placa de auto',
    atlas = 'CustomJokers',
    pos = { x = 9, y = 9 },
    rarity = 3,
    cost = 8,
    unlocked = false,
    discovered = false,
    blueprint_compat = true,
    config = { extra = { x_mult = 1, x_gain = 0.25 } },
    
    check_for_unlock = function(self, args)
        if args.type == 'hand_played' then
            if G.GAME and G.GAME.current_round and G.GAME.current_round.hands_played >= 6 then return true end
        end
        return false
    end,

    locked_loc_vars = function(self, info_queue, card)
        local hands = (G.GAME and G.GAME.current_round and G.GAME.current_round.hands_played) or 0
        return { vars = { hands } }
    end,

    loc_vars = function(self, info_queue, card)
        local hands = (G.GAME and G.GAME.current_round and G.GAME.current_round.hands_played) or 0
        local x_gain = card and card.ability and card.ability.extra and card.ability.extra.x_gain or self.config.extra.x_gain
        local x_mult = card and card.ability and card.ability.extra and card.ability.extra.x_mult or self.config.extra.x_mult
        return { vars = { hands, x_gain, x_mult } }
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
    
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_gain
            return { message = "¡Arrancando!", colour = G.C.DARK_EDITION }
        end
        
        if context.joker_main then
            if card.ability.extra.x_mult > 1 then
                return { message = "X" .. card.ability.extra.x_mult .. " Mult", Xmult_mod = card.ability.extra.x_mult, colour = G.C.DARK_EDITION }
            end
        end
        
        if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
            card.ability.extra.x_mult = 1
            return { message = "¡Frenando!", colour = G.C.RED }
        end
    end
}