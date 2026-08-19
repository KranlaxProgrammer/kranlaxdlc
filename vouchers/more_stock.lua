SMODS.Voucher {
    key = 'more_stock',
    pos = { x = 6, y = 0 },
    cost = 10,
    unlocked = true,
    discovered = false,
    atlas = 'CustomVouchers',

    in_pool = function(self, args)
        -- Revisa el registro interno de Vales comprados en esta partida
        if G.GAME and G.GAME.used_vouchers and G.GAME.used_vouchers['v_kranlaxs_' .. self.key] then
            return false -- Si ya está registrado como usado, no vuelve a salir
        end
        
        return true
    end,
    
    redeem = function(self, card)
        G.E_MANAGER:add_event(Event({
            func = function()
                SMODS.change_booster_limit(1)
                return true
            end
        }))
    end
}