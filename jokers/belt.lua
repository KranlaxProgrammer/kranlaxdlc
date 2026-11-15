SMODS.Joker{
    key = "belt",
    config = { extra = { x_mult_gain = 0.5, threshold = 8 } },
    pos = { x = 012, y = 06 }, 
    cost = 5,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    check_for_unlock = function(self, args)
        if G.hand and G.hand.config and G.hand.config.card_limit <= 3 then return true end
        return false
    end,

    locked_loc_vars = function(self, info_queue, card)
        local current_size = G.hand and G.hand.config.card_limit or 5
        return { vars = { current_size } }
    end,

    loc_vars = function(self, info_queue, card)
        local current_size = G.hand and G.hand.config.card_limit or 5
        local threshold = card and card.ability.extra.threshold or self.config.extra.threshold
        local gain = card and card.ability.extra.x_mult_gain or self.config.extra.x_mult_gain
        
        local diff = math.max(0, threshold - current_size)
        local current_xmult = 1 + (diff * gain)
        
        return { vars = { current_size, threshold, gain, current_xmult } }
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
        if context.joker_main then
            local current_size = G.hand and G.hand.config.card_limit or 5
            local diff = math.max(0, card.ability.extra.threshold - current_size)
            local current_xmult = 1 + (diff * card.ability.extra.x_mult_gain)
            
            if current_xmult > 1 then
                return {
                    message = "X" .. current_xmult .. " Mult",
                    Xmult_mod = current_xmult,
                    colour = G.C.DARK_EDITION
                }
            end
        end
    end
}