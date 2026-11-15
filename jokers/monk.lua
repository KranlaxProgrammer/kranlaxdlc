if not SMODS.kranlaxs_monk_spend_hook then
    local orig_ease_dollars = ease_dollars
    function ease_dollars(mod, force)
        local mod_num = type(mod) == 'table' and (tonumber(tostring(mod)) or 0) or mod
        
        if mod_num < 0 and G.STATE == G.STATES.SHOP then
            if G.GAME then
                G.GAME.kranlaxs_shop_spent = (G.GAME.kranlaxs_shop_spent or 0) + 1
            end
        end
        orig_ease_dollars(mod, force)
    end
    SMODS.kranlaxs_monk_spend_hook = true
end

SMODS.Joker{
    key = 'monk',
    config = { extra = { xchips = 1, xchips_add = 0.1, in_shop = false } },
    rarity = 2, 
    atlas = 'CustomJokers',
    pos = { x = 6, y = 7 },
    cost = 4,
    blueprint_compat = true,
    unlocked = false,
    discovered = false,
    unlock_condition = {type = '', extra = ''},

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
    
    check_for_unlock = function(self, args)
        if G and G.PROFILES and G.PROFILES[G.SETTINGS.profile] then
            if G.PROFILES[G.SETTINGS.profile].all_unlocked then return true end
            if G.PROFILES[G.SETTINGS.profile].challenge_progress and G.PROFILES[G.SETTINGS.profile].challenge_progress.completed then
                if G.PROFILES[G.SETTINGS.profile].challenge_progress.completed.c_kranlaxs_reto_pobreza then return true end
            end
        end
        return false
    end,
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xchips_add, card.ability.extra.xchips } }
    end,
    
    update = function(self, card, dt)
        if G.STATE == G.STATES.SHOP and not card.ability.extra.in_shop then
            card.ability.extra.in_shop = true
            G.GAME.kranlaxs_shop_spent = 0
        end
        if G.STATE ~= G.STATES.SHOP and card.ability.extra.in_shop then
            card.ability.extra.in_shop = false
        end
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            if card.ability.extra.xchips > 1 then
                return {
                    message = 'X' .. card.ability.extra.xchips,
                    x_chips = card.ability.extra.xchips,
                    Xchip_mod = card.ability.extra.xchips,
                    colour = G.C.CHIPS,
                    sound = 'kranlaxs_multiplicativechips'
                }
            end
        end
        
        if context.ending_shop and not context.blueprint then
            local spent_times = G.GAME.kranlaxs_shop_spent or 0
            card.ability.extra.in_shop = false
            
            if spent_times == 0 then
                card.ability.extra.xchips = card.ability.extra.xchips + card.ability.extra.xchips_add
                return { message = localize('k_upgrade_ex'), colour = G.C.CHIPS }
            else
                if G.GAME and G.GAME.challenge == 'c_kranlaxs_reto_pobreza' then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after', delay = 1.0,
                        func = function()
                            G.STATE = G.STATES.GAME_OVER
                            G.STATE_COMPLETE = false
                            return true
                        end
                    }))
                    return { message = "¡Castigo Divino!", colour = G.C.RED }
                end
                
                if card.ability.extra.xchips > 1 then
                    card.ability.extra.xchips = 1
                    return { message = localize('k_reset'), colour = G.C.RED }
                end
            end
        end
    end
}