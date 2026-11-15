SMODS.Back {
    key = 'evil_deck',
    atlas = 'CustomDecks',
    pos = { x = 8, y = 0 }, 
    unlocked = false,
    discovered = false,
    
    check_for_unlock = function(self, args)
        if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
            if (G.PROFILES[G.SETTINGS.profile].kranlaxs_bm_purchases or 0) >= 50 then return true end
        end
        return false
    end,

    locked_loc_vars = function(self, info_queue, card)
        local count = G.PROFILES and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].kranlaxs_bm_purchases or 0
        return { vars = { count } }
    end,

    loc_vars = function(self, info_queue, card)
        local count = G.PROFILES and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].kranlaxs_bm_purchases or 0
        return { vars = { count } }
    end,

    apply = function(self)
        G.GAME.modifiers.kranlaxs_evil_deck = true
    end
}

if not SMODS.kranlaxs_evil_deck_hooks then
    local orig_update = Game.update
    function Game:update(dt)
        if orig_update then orig_update(self, dt) end
        if G.GAME and G.GAME.modifiers and G.GAME.modifiers.kranlaxs_evil_deck then
            G.GAME.kranlaxs_evil_meter = 100
        end
    end

    local orig_get_blind_amount = get_blind_amount
    function get_blind_amount(ante)
        local amt = orig_get_blind_amount(ante)
        if G.GAME and G.GAME.modifiers and G.GAME.modifiers.kranlaxs_evil_deck and ante >= 2 then
            amt = amt * (1.5 ^ (ante - 1))
        end
        return amt
    end

    local orig_blind_defeat = Blind.defeat
    function Blind:defeat(force)
        local pre_defeated = self.defeated
        local res = orig_blind_defeat(self, force)
        
        if self.boss and G.GAME and G.GAME.modifiers.kranlaxs_evil_deck and not pre_defeated then
            local extra_tokens = (G.GAME.round_resets.ante >= 9) and 2 or 1
            G.GAME.kranlaxs_dark_coins = (G.GAME.kranlaxs_dark_coins or 0) + extra_tokens
        end
        return res
    end

    local orig_buy = G.FUNCS.buy_from_shop
    G.FUNCS.buy_from_shop = function(e)
        local card = e.config.ref_table
        local was_in_bm = card and G.kranlaxs_bm_area and card.area == G.kranlaxs_bm_area
        
        orig_buy(e)
        
        if card and was_in_bm and card.area ~= G.kranlaxs_bm_area then
            if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
                G.PROFILES[G.SETTINGS.profile].kranlaxs_bm_purchases = (G.PROFILES[G.SETTINGS.profile].kranlaxs_bm_purchases or 0) + 1
                G:save_progress()
            end
        end
    end

    SMODS.kranlaxs_evil_deck_hooks = true
end