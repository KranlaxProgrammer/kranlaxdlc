SMODS.Joker{
    key = "nightlamp",
    config = { extra = { odds = 4, bonus = 2 } },
    pos = { x = 011, y = 06 }, 
    cost = 20,
    bm_cost = 6,
    rarity = "kranlaxs_zenith",
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    check_for_unlock = function(self, args)
        if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
            if (G.PROFILES[G.SETTINGS.profile].kranlaxs_bosses_defeated or 0) >= 50 then return true end
        end
        return false
    end,

    locked_loc_vars = function(self, info_queue, card)
        local bosses = G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].kranlaxs_bosses_defeated or 0
        return { vars = { bosses } }
    end,

    loc_vars = function(self, info_queue, card)
        local bosses = G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].kranlaxs_bosses_defeated or 0
        local odds = card and card.ability.extra.odds or self.config.extra.odds
        local bonus = card and card.ability.extra.bonus or self.config.extra.bonus
        return { vars = { bosses, G.GAME and G.GAME.probabilities.normal or 1, odds, bonus } }
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

    calculate = function(self, card, context)
        local target = context.blueprint and context.blueprint_card or card
        
        if context.setting_blind then
            if pseudorandom('nightlamp_trigger') < G.GAME.probabilities.normal / card.ability.extra.odds then
                target.ability.nightlamp_bonus = (target.ability.nightlamp_bonus or 0) + card.ability.extra.bonus
                G.hand:change_size(card.ability.extra.bonus)
                return { message = "¡Iluminado!", colour = G.C.BLUE, card = target }
            end
        end
        
        if context.end_of_round and not context.individual and not context.repetition then
            if target.ability.nightlamp_bonus and target.ability.nightlamp_bonus > 0 then
                G.hand:change_size(-target.ability.nightlamp_bonus)
                target.ability.nightlamp_bonus = 0
                return { message = "Apagado...", colour = G.C.RED, card = target }
            end
        end
    end,

    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
                G.PROFILES[G.SETTINGS.profile].kranlaxs_nightlamp_bought = (G.PROFILES[G.SETTINGS.profile].kranlaxs_nightlamp_bought or 0) + 1
                G:save_progress()
                if G.PROFILES[G.SETTINGS.profile].kranlaxs_nightlamp_bought >= 3 then
                    unlock_card(G.P_CENTERS.j_kranlaxs_darkhallway)
                end
            end
        end
    end,

    remove_from_deck = function(self, card, from_debuff)
        if card.ability.nightlamp_bonus and card.ability.nightlamp_bonus > 0 then
            G.hand:change_size(-card.ability.nightlamp_bonus)
            card.ability.nightlamp_bonus = 0
        end
    end
}

if not SMODS.kranlaxs_nightlamp_hook then
    local orig_blind_defeat = Blind.defeat
    function Blind:defeat(force)
        local pre_defeated = self.defeated
        local res = orig_blind_defeat(self, force)
        
        if self.boss and G.GAME and not pre_defeated then
            if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
                G.PROFILES[G.SETTINGS.profile].kranlaxs_bosses_defeated = (G.PROFILES[G.SETTINGS.profile].kranlaxs_bosses_defeated or 0) + 1
                G:save_progress()
            end
        end
        return res
    end
    SMODS.kranlaxs_nightlamp_hook = true
end