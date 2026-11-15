SMODS.Joker{
    key = 'clerigo',
    config = { extra = { mult_add = 1, mult_sub = 1, current_mult = 0 }, holy = true },
    rarity = 1,
    atlas = 'CustomJokers',
    pos = { x = 4, y = 8 },
    cost = 4,
    blueprint_compat = true,
    unlocked = false,
    discovered = false,
    unlock_condition = {type = '', extra = ''},

    set_badges = function(self, card, badges)
        local badge_text = "Holy"
        if G.localization and G.localization.misc and G.localization.misc.dictionary and G.localization.misc.dictionary.k_holy then
            badge_text = G.localization.misc.dictionary.k_holy
        else
            if G.SETTINGS.language == 'es_419' or G.SETTINGS.language == 'es_ES' then badge_text = "Sagrada" end
        end
        badges[#badges + 1] = create_badge(badge_text, HEX('FFD700'), G.C.WHITE, 1.2)
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
    
    check_for_unlock = function(self, args)
        if G and G.PROFILES and G.PROFILES[G.SETTINGS.profile] then
            if G.PROFILES[G.SETTINGS.profile].all_unlocked then return true end
            if G.PROFILES[G.SETTINGS.profile].challenge_progress and G.PROFILES[G.SETTINGS.profile].challenge_progress.completed then
                if G.PROFILES[G.SETTINGS.profile].challenge_progress.completed.c_kranlaxs_reto_abuela then return true end
            end
        end
        return false
    end,
    
    update = function(self, card, dt)
        if G.playing_cards then
            local unbal = SMODS.Mods["kranlaxs"] and SMODS.Mods["kranlaxs"].config.unbalanced_mode
            local m_add = unbal and 3 or card.ability.extra.mult_add
            local m_sub = card.ability.extra.mult_sub
            
            local totales = #G.playing_cards
            local modificadas = 0
            for _, v in ipairs(G.playing_cards) do
                if (v.config.center and v.config.center.key ~= 'c_base') or v.edition or v.seal then
                    modificadas = modificadas + 1
                end
            end
            card.ability.extra.current_mult = (totales * m_add) - (modificadas * m_sub)
        end
    end,

    loc_vars = function(self, info_queue, card)
        local unbal = SMODS.Mods["kranlaxs"] and SMODS.Mods["kranlaxs"].config.unbalanced_mode
        local m_add = unbal and 3 or card.ability.extra.mult_add
        return { vars = { m_add, card.ability.extra.mult_sub, card.ability.extra.current_mult } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            if card.ability.extra.current_mult > 0 then
                return {
                    mult_mod = card.ability.extra.current_mult,
                    message = localize{type='variable',key='a_mult',vars={card.ability.extra.current_mult}}
                }
            end
        end
    end
}