SMODS.Voucher {
    key = 'even_more_stock',
    pos = { x = 7, y = 0 },
    cost = 10,
    unlocked = false,
    discovered = false,
    requires = {'v_kranlaxs_more_stock'},
    atlas = 'CustomVouchers',

    check_for_unlock = function(self, args)
        local count = 0
        if G.PROFILES and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].voucher_usage then
            for k, v in pairs(G.PROFILES[G.SETTINGS.profile].voucher_usage) do
                count = count + (v.count or 0)
            end
        end
        if count >= 50 then return true end
        return false
    end,

    locked_loc_vars = function(self, info_queue, card)
        local count = 0
        if G.PROFILES and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].voucher_usage then
            for k, v in pairs(G.PROFILES[G.SETTINGS.profile].voucher_usage) do
                count = count + (v.count or 0)
            end
        end
        return {vars = {count}}
    end,

    in_pool = function(self, args)
        if G.GAME and G.GAME.used_vouchers and G.GAME.used_vouchers['v_kranlaxs_' .. self.key] then
            return false 
        end
        return true
    end,
    
    redeem = function(self, card)
        G.E_MANAGER:add_event(Event({
            func = function()
                SMODS.change_voucher_limit(1)
                return true
            end
        }))
    end
}