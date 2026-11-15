SMODS.Joker{
    key = "credits",
    config = { extra = { payout = 1, increase = 1 } },
    pos = { x = 0, y = 0 }, 
    display_size = { w = 71, h = 95 },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    check_for_unlock = function(self, args)
        if args.type == 'win' and G.GAME.stake >= 14 then
            if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
                G.PROFILES[G.SETTINGS.profile].kranlaxs_mustard_decks_won = G.PROFILES[G.SETTINGS.profile].kranlaxs_mustard_decks_won or {}
                G.PROFILES[G.SETTINGS.profile].kranlaxs_mustard_decks_won[G.GAME.selected_back.name] = true
                G:save_progress()
            end
        end
        local c = 0
        if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].kranlaxs_mustard_decks_won then
            for k,v in pairs(G.PROFILES[G.SETTINGS.profile].kranlaxs_mustard_decks_won) do c = c + 1 end
        end
        if c >= 3 then return true end
        return false
    end,

    locked_loc_vars = function(self, info_queue, card)
        local c = 0
        if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].kranlaxs_mustard_decks_won then
            for k,v in pairs(G.PROFILES[G.SETTINGS.profile].kranlaxs_mustard_decks_won) do c = c + 1 end
        end
        return { vars = { c } }
    end,

    loc_vars = function(self, info_queue, card)
        local c = 0
        if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].kranlaxs_mustard_decks_won then
            for k,v in pairs(G.PROFILES[G.SETTINGS.profile].kranlaxs_mustard_decks_won) do c = c + 1 end
        end
        local payout = card and card.ability and card.ability.extra and card.ability.extra.payout or self.config.extra.payout
        local increase = card and card.ability and card.ability.extra and card.ability.extra.increase or self.config.extra.increase
        return {vars = {c, payout, increase}}
    end,

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
    
    calc_dollar_bonus = function(self, card)
        if card.ability.extra.payout > 0 then return card.ability.extra.payout end
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and not context.blueprint then
            if G.GAME and G.GAME.current_round and G.GAME.current_round.hands_played == 1 then
                card.ability.extra.payout = card.ability.extra.payout + card.ability.extra.increase
                return { message = "¡Mejora!", colour = G.C.MONEY, card = card }
            end
        end
    end
}