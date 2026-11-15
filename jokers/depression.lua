SMODS.Joker{
    key = "depression",
    config = {
        extra = {
            increment = 0.05,
            base_mult = 1 -- FIX: Cambiado a 1
        }
    },
    pos = { x = 2, y = 5 },
    display_size = { w = 71, h = 95 },
    cost = 8,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    discovered = false,
    
    check_for_unlock = function(self, args)
        if args and (args.type == 'round_win' or args.type == 'money') then
            if G.GAME and G.GAME.dollars and to_number(G.GAME.dollars) <= -25 then
                return true
            end
        end
        return false
    end,
    
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

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
        local inc = unbal and 0.2 or card.ability.extra.increment
        local debt = 0
        
        if G.GAME and G.GAME.dollars and to_big(G.GAME.dollars) < to_big(0) then
            debt = to_number(G.GAME.dollars) * -1 
        end
        
        local current_mult = card.ability.extra.base_mult + (debt * inc)
        return {vars = {inc, current_mult}}
    end,
    
    calculate = function(self, card, context)
        if context.joker_main then
            local unbal = SMODS.Mods["kranlaxs"] and SMODS.Mods["kranlaxs"].config.unbalanced_mode
            local inc = unbal and 0.2 or card.ability.extra.increment
            local debt = 0
            
            if G.GAME and G.GAME.dollars and to_big(G.GAME.dollars) < to_big(0) then
                debt = to_number(G.GAME.dollars) * -1
            end
            
            local current_mult = card.ability.extra.base_mult + (debt * inc)
            
            if current_mult > 1 then
                return {
                    message = "^" .. current_mult .. " Mult",
                    e_mult = current_mult,
                    colour = G.C.DARK_EDITION
                }
            end
        end
    end
}