SMODS.Joker {
    key = 'nazar',
    name = 'Nazar',
    atlas = 'CustomJokers',
    pos = { x = 6, y = 9 },
    rarity = 1,
    cost = 5,
    unlocked = false,
    discovered = false,
    blueprint_compat = false,
    config = { extra = { blinds_left = 9 } },
    
    check_for_unlock = function(self, args)
        if args.type == 'win' then
            if G.GAME.stake >= 4 then
                if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
                    G.PROFILES[G.SETTINGS.profile].kranlaxs_nazar_decks_won = G.PROFILES[G.SETTINGS.profile].kranlaxs_nazar_decks_won or {}
                    G.PROFILES[G.SETTINGS.profile].kranlaxs_nazar_decks_won[G.GAME.selected_back.name] = true
                    G:save_progress()
                end
            end
        end
        
        local c = 0
        if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].kranlaxs_nazar_decks_won then
            for k,v in pairs(G.PROFILES[G.SETTINGS.profile].kranlaxs_nazar_decks_won) do c = c + 1 end
        end
        if c >= 7 then return true end
        return false
    end,

    locked_loc_vars = function(self, info_queue, card)
        local c = 0
        if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].kranlaxs_nazar_decks_won then
            for k,v in pairs(G.PROFILES[G.SETTINGS.profile].kranlaxs_nazar_decks_won) do c = c + 1 end
        end
        return { vars = { c } }
    end,

    loc_vars = function(self, info_queue, card)
        local c = 0
        if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].kranlaxs_nazar_decks_won then
            for k,v in pairs(G.PROFILES[G.SETTINGS.profile].kranlaxs_nazar_decks_won) do c = c + 1 end
        end
        local blinds = card and card.ability and card.ability.extra and card.ability.extra.blinds_left or self.config.extra.blinds_left
        return { vars = { c, blinds } }
    end,
    
    in_pool = function(self, args)
        if G.GAME.stake < 5 then return false end
        if G.GAME.pool_flags and G.GAME.pool_flags.nazar_exhausted then return false end
        if not G.jokers or not G.jokers.cards then return true end
        for _, v in ipairs(G.jokers.cards) do
            if v.config.center.key == 'j_kranlaxs_nazar' then return false end
        end
        return true
    end,

    update = function(self, card, dt)
        if card.ability.extra.blinds_left > 0 and G.shop_jokers and G.shop_jokers.cards then
            for _, c in ipairs(G.shop_jokers.cards) do
                if c.ability.eternal or c.ability.perishable or c.ability.rental then
                    c.ability.eternal = nil
                    c.ability.perishable = nil
                    c.ability.rental = nil
                    c:set_cost()
                end
            end
        end
    end,
    
    calculate = function(self, card, context)
        if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
            if card.ability.extra.blinds_left > 0 then
                card.ability.extra.blinds_left = card.ability.extra.blinds_left - 1
                if card.ability.extra.blinds_left <= 0 then
                    G.GAME.pool_flags = G.GAME.pool_flags or {}
                    G.GAME.pool_flags.nazar_exhausted = true
                    return { message = "¡Agotado!", colour = G.C.FILTER }
                else
                    return { message = card.ability.extra.blinds_left .. " Ciegas", colour = G.C.FILTER }
                end
            end
        end
    end
}