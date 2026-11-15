SMODS.Joker {
    key = 'professor',
    name = 'Profesor',
    atlas = 'CustomJokers',
    pos = { x = 4, y = 9 },
    rarity = 2,
    cost = 6,
    unlocked = false,
    discovered = false,
    blueprint_compat = true,
    
    check_for_unlock = function(self, args)
        if args.type == 'hand_played' and args.scoring_hand then
            local aces = 0
            for _, v in ipairs(args.scoring_hand) do
                if v.base.value == 'Ace' then aces = aces + 1 end
            end
            if aces > 0 then G.GAME.kranlaxs_aces_played = (G.GAME.kranlaxs_aces_played or 0) + aces end
            if G.GAME.kranlaxs_aces_played >= 20 then return true end
        end
        return false
    end,

    locked_loc_vars = function(self, info_queue, card)
        local aces_played = (G.GAME and G.GAME.kranlaxs_aces_played) or 0
        return { vars = { aces_played } }
    end,

    loc_vars = function(self, info_queue, card)
        local aces_played = (G.GAME and G.GAME.kranlaxs_aces_played) or 0
        return { vars = { aces_played } } 
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
        if context.individual and context.cardarea == G.play then
            local rank = context.other_card.base.value
            local xmult_bonus = 0
            
            if rank == '6' then xmult_bonus = 0.2
            elseif rank == '7' then xmult_bonus = 0.4
            elseif rank == '8' then xmult_bonus = 0.6
            elseif rank == '9' then xmult_bonus = 0.8
            elseif rank == '10' then xmult_bonus = 1.0
            elseif rank == 'Ace' then xmult_bonus = 1.5 end
            
            if xmult_bonus > 0 then
                return {
                    x_mult = 1 + xmult_bonus,
                    message = "X" .. (1 + xmult_bonus) .. " Mult",
                    card = card
                }
            end
        end
    end
}