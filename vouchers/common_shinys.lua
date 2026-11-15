SMODS.Voucher {
    key = 'common_shinys',
    pos = { x = 5 , y = 0 }, 
    cost = 30,
    unlocked = false,
    discovered = false,
    requires = {'v_kranlaxs_shiny_appearance'},
    atlas = 'CustomVouchers',

    check_for_unlock = function(self, args)
        local count = 0
        if G.PROFILES and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].consumeable_usage and G.PROFILES[G.SETTINGS.profile].consumeable_usage['c_soul'] then
            count = G.PROFILES[G.SETTINGS.profile].consumeable_usage['c_soul'].count or 0
        end
        if count >= 3 then return true end
        return false
    end,

    locked_loc_vars = function(self, info_queue, card)
        local count = 0
        if G.PROFILES and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].consumeable_usage and G.PROFILES[G.SETTINGS.profile].consumeable_usage['c_soul'] then
            count = G.PROFILES[G.SETTINGS.profile].consumeable_usage['c_soul'].count or 0
        end
        return {vars = {count}}
    end,

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
            SMODS.ConsumableTypes['Quartz'].shop_rate = 0.25
            SMODS.ConsumableTypes['InverseTarot'].shop_rate = 0.175
            SMODS.ConsumableTypes['UNOCards'].shop_rate = 0.175
        end
    end
}