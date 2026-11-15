SMODS.Voucher {
    key = 'shiny_appearance',
    pos = { x = 4 , y = 0 }, 
    cost = 20, 
    unlocked = true,
    discovered = false,
    atlas = 'CustomVouchers',

    in_pool = function(self, args)
        if G.GAME and G.GAME.used_vouchers and G.GAME.used_vouchers['v_kranlaxs_' .. self.key] then
            return false 
        end
        return true
    end,
    
    loc_vars = function(self, info_queue, card)
        return {vars = {}}
    end,
    
    redeem = function(self, card)
        
        if SMODS.ConsumableTypes['Quartz'] then
            SMODS.ConsumableTypes['Quartz'].shop_rate = 0.15
            SMODS.ConsumableTypes['InverseTarot'].shop_rate = 0.1
            SMODS.ConsumableTypes['UNOCards'].shop_rate = 0.1
        end
    end
}