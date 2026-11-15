SMODS.Voucher {
    key = 'stickeralbum',
    requires = {'v_kranlaxs_stickerfever'},
    atlas = 'CustomVouchers',
    pos = { x = 1, y = 0 }, 
    cost = 30,
    unlocked = false,
    discovered = false,

    check_for_unlock = function(self, args)
        local count = (G.PROFILES and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].kranlaxs_blinds_skipped) or 0
        if count >= 75 then return true end
        return false
    end,

    locked_loc_vars = function(self, info_queue, card)
        local count = (G.PROFILES and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].kranlaxs_blinds_skipped) or 0
        return {vars = {count}}
    end,

    in_pool = function(self) return not G.GAME.used_vouchers[self.key] end
}

if not SMODS.kranlaxs_skip_blind_tracker_hook then
    local orig_skip = G.FUNCS.skip_blind
    G.FUNCS.skip_blind = function(e)
        if G.PROFILES and G.PROFILES[G.SETTINGS.profile] then
            G.PROFILES[G.SETTINGS.profile].kranlaxs_blinds_skipped = (G.PROFILES[G.SETTINGS.profile].kranlaxs_blinds_skipped or 0) + 1
            G:save_progress()
        end
        orig_skip(e)
    end
    SMODS.kranlaxs_skip_blind_tracker_hook = true
end