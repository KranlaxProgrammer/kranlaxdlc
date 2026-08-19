SMODS.Voucher {
    key = 'shiny_appearance',
    pos = { x = 4, y = 0 }, -- Ajusta según tu Sprite Sheet
    cost = 10, -- Un precio más accesible para el Tier 1
    unlocked = true,
    discovered = true,
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
        -- Actualizamos las probabilidades inmediatamente al comprar el vale
        if SMODS.ConsumableTypes['Quartz'] then
            SMODS.ConsumableTypes['Quartz'].shop_rate = 0.15
            SMODS.ConsumableTypes['InverseTarot'].shop_rate = 0.1
            SMODS.ConsumableTypes['UNOCards'].shop_rate = 0.1
        end
    end
}