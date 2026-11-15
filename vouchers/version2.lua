SMODS.Voucher {
    key = 'version2',
    requires = {'v_kranlaxs_hotfix'}, 
    atlas = 'CustomVouchers',
    pos = { x = 3, y = 0 },
    cost = 15,
    unlocked = false,
    discovered = false,

    check_for_unlock = function(self, args)
        local count = (G.PROFILES and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].kranlaxs_shop_rerolls) or 0
        if count >= 100 then return true end
        return false
    end,

    locked_loc_vars = function(self, info_queue, card)
        local count = (G.PROFILES and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].kranlaxs_shop_rerolls) or 0
        return {vars = {count}}
    end,
    
    in_pool = function(self) return not G.GAME.used_vouchers[self.key] end
}

if not SMODS.kranlaxs_version2_hook then
    
    local orig_skip = G.FUNCS.skip_blind
    G.FUNCS.skip_blind = function(e)
        if G.GAME and G.GAME.used_vouchers and G.GAME.used_vouchers['v_kranlaxs_version2'] then
            ease_dollars(5) 
        end
        orig_skip(e)
    end

    local orig_set_blind = Blind.set_blind
    function Blind:set_blind(blind, reset, silent)
        orig_set_blind(self, blind, reset, silent)
        if G.GAME and G.GAME.used_vouchers and G.GAME.used_vouchers['v_kranlaxs_version2'] then
            if self.chips then
                self.chips = math.floor(self.chips * 0.85)
                self.chip_text = number_format(self.chips)
            end
        end
    end
    
    -- Tracker de rerolls para el desbloqueo
    local orig_reroll = G.FUNCS.reroll_shop
    G.FUNCS.reroll_shop = function(e)
        if G.PROFILES and G.PROFILES[G.SETTINGS.profile] then
            G.PROFILES[G.SETTINGS.profile].kranlaxs_shop_rerolls = (G.PROFILES[G.SETTINGS.profile].kranlaxs_shop_rerolls or 0) + 1
            G:save_progress()
        end
        orig_reroll(e)
    end

    SMODS.kranlaxs_version2_hook = true
end