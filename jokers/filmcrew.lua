SMODS.Joker {
    key = 'filmcrew',
    atlas = 'CustomJokers',
    pos = { x = 01, y = 10 },
    rarity = 1,
    cost = 4,
    unlocked = false,
    discovered = false,
    blueprint_compat = true,
    config = { extra = { mult = 10 } },
    
    check_for_unlock = function(self, args)
        if G.GAME and G.GAME.used_vouchers then
            local count = 0
            for k, v in pairs(G.GAME.used_vouchers) do count = count + 1 end
            if count >= 10 then return true end
        end
        return false
    end,

    locked_loc_vars = function(self, info_queue, card)
        local count = 0
        if G.GAME and G.GAME.used_vouchers then
            for k, v in pairs(G.GAME.used_vouchers) do count = count + 1 end
        end
        return { vars = { count } }
    end,

    loc_vars = function(self, info_queue, card)
        local count = 0
        if G.GAME and G.GAME.used_vouchers then
            for k, v in pairs(G.GAME.used_vouchers) do count = count + 1 end
        end
        
        local unbal = SMODS.Mods["kranlaxs"] and SMODS.Mods["kranlaxs"].config.unbalanced_mode
        local base_mult = card and card.ability and card.ability.extra and card.ability.extra.mult or self.config.extra.mult
        local current_mult = unbal and 15 or base_mult
        
        return { vars = { count, current_mult, count * current_mult } }
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
            local count = 0
            if G.GAME and G.GAME.used_vouchers then
                for k, v in pairs(G.GAME.used_vouchers) do count = count + 1 end
            end
            
            local unbal = SMODS.Mods["kranlaxs"] and SMODS.Mods["kranlaxs"].config.unbalanced_mode
            local current_mult = unbal and 15 or card.ability.extra.mult
            
            local total_mult = count * current_mult
            if total_mult > 0 then
                return { mult = total_mult, colour = G.C.RED }
            end
        end
    end
}