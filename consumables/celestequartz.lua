SMODS.Consumable {
    key = 'celestequartz',
    set = 'Quartz',
    pos = { x = 8, y = 0 }, 
    cost = 5,
    unlocked = false,
    discovered = false,
    unlock_condition = {type = '', extra = ''},
    atlas = 'QuartzConsumables',

    in_pool = function(self, args)
        if SMODS.showman and SMODS.showman('c_kranlaxs_' .. self.key) then return true end
        if not G.consumeables or not G.consumeables.cards then return true end
        for _, v in ipairs(G.consumeables.cards) do
            if v.config.center.key == 'c_kranlaxs_' .. self.key then return false end
        end
        return true
    end,
    
    can_use = function(self, card)
        return false 
    end,
    
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = "X1.5",
                x_chips = 1.5,
                Xchips = 1.5, 
                Xchip_mod = 1.5,
                colour = G.C.CHIPS
            }
        end
    end,

    check_for_unlock = function(self, args)
        if args.type == 'win' then
            if G.GAME.selected_back.effect.center.key == 'b_checkered' and G.GAME.stake == 'kranlaxs_turquoise' then
                return true
            end
        end
        return false
    end
}