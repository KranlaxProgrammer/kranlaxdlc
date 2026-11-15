local function get_ophiuchus_enhancement(seed_str)
    local all_enh = {'m_bonus', 'm_mult', 'm_wild', 'm_glass', 'm_steel', 'm_stone', 'm_gold', 'm_lucky'}
    local in_deck = {}
    local not_in_deck = {}

    if G.playing_cards then
        local found = {}
        for _, c in ipairs(G.playing_cards) do
            if c.config.center.effect ~= 'Base' then found[c.config.center.key] = true end
        end
        for _, e in ipairs(all_enh) do
            if found[e] then table.insert(in_deck, e)
            else table.insert(not_in_deck, e) end
        end
    else
        not_in_deck = all_enh
    end

    local pool = in_deck
    if #in_deck == 0 then pool = not_in_deck
    elseif #not_in_deck > 0 and pseudorandom(seed_str) < 0.15 then pool = not_in_deck end

    return pseudorandom_element(pool, pseudoseed(seed_str .. '_select'))
end

SMODS.Joker{
    key = "ophiuchus",
    config = { extra = { payout = 4, target_enhancement = nil } },
    pos = { x = 6, y = 1 }, 
    cost = 8,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',
    is_constellation = true, 
    
    set_badges = function(self, card, badges)
        local badge_text = "Constellation"
        if G.localization and G.localization.misc and G.localization.misc.dictionary and G.localization.misc.dictionary.k_constellation then
            badge_text = G.localization.misc.dictionary.k_constellation
        else
            if G.SETTINGS.language == 'es_419' or G.SETTINGS.language == 'es_ES' then badge_text = "Constelación" end
        end
        badges[#badges + 1] = create_badge(badge_text, HEX('3D266B'), G.C.WHITE, 1.2)
    end,

    check_for_unlock = function(self, args)
        local c_hiero, c_empress, c_lovers, c_chariot, c_justice, c_tower, c_magician, c_devil = 0, 0, 0, 0, 0, 0, 0, 0
        local p = G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile]
        if p and p.consumeable_usage then
            local u = p.consumeable_usage
            if u['c_heirophant'] then c_hiero = u['c_heirophant'].count or 0 end
            if u['c_empress'] then c_empress = u['c_empress'].count or 0 end
            if u['c_lovers'] then c_lovers = u['c_lovers'].count or 0 end
            if u['c_chariot'] then c_chariot = u['c_chariot'].count or 0 end
            if u['c_justice'] then c_justice = u['c_justice'].count or 0 end
            if u['c_tower'] then c_tower = u['c_tower'].count or 0 end
            if u['c_magician'] then c_magician = u['c_magician'].count or 0 end
            if u['c_devil'] then c_devil = u['c_devil'].count or 0 end
        end
        if c_hiero >= 2 and c_empress >= 2 and c_lovers >= 2 and c_chariot >= 2 and c_justice >= 2 and c_tower >= 2 and c_magician >= 2 and c_devil >= 2 then
            return true
        end
        return false
    end,

    locked_loc_vars = function(self, info_queue, card)
        local c_hiero, c_empress, c_lovers, c_chariot, c_justice, c_tower, c_magician, c_devil = 0, 0, 0, 0, 0, 0, 0, 0
        local p = G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile]
        if p and p.consumeable_usage then
            local u = p.consumeable_usage
            if u['c_heirophant'] then c_hiero = math.min(2, u['c_heirophant'].count or 0) end
            if u['c_empress'] then c_empress = math.min(2, u['c_empress'].count or 0) end
            if u['c_lovers'] then c_lovers = math.min(2, u['c_lovers'].count or 0) end
            if u['c_chariot'] then c_chariot = math.min(2, u['c_chariot'].count or 0) end
            if u['c_justice'] then c_justice = math.min(2, u['c_justice'].count or 0) end
            if u['c_tower'] then c_tower = math.min(2, u['c_tower'].count or 0) end
            if u['c_magician'] then c_magician = math.min(2, u['c_magician'].count or 0) end
            if u['c_devil'] then c_devil = math.min(2, u['c_devil'].count or 0) end
        end
        -- Enviamos 10 variables para evitar crasheos si el SMODS inspecciona la descripción oculta
        return { vars = { c_hiero, c_empress, c_lovers, c_chariot, c_justice, c_tower, c_magician, c_devil, "Aleatoria", self.config.extra.payout } }
    end,

    loc_vars = function(self, info_queue, card)
        local payout = card and card.ability.extra.payout or self.config.extra.payout
        local target = card and card.ability.extra.target_enhancement
        local enh_str = target and localize{type='name_text', key=target, set='Enhanced'} or "Aleatoria"
        
        local c_hiero, c_empress, c_lovers, c_chariot, c_justice, c_tower, c_magician, c_devil = 0, 0, 0, 0, 0, 0, 0, 0
        local p = G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile]
        if p and p.consumeable_usage then
            local u = p.consumeable_usage
            if u['c_heirophant'] then c_hiero = math.min(2, u['c_heirophant'].count or 0) end
            if u['c_empress'] then c_empress = math.min(2, u['c_empress'].count or 0) end
            if u['c_lovers'] then c_lovers = math.min(2, u['c_lovers'].count or 0) end
            if u['c_chariot'] then c_chariot = math.min(2, u['c_chariot'].count or 0) end
            if u['c_justice'] then c_justice = math.min(2, u['c_justice'].count or 0) end
            if u['c_tower'] then c_tower = math.min(2, u['c_tower'].count or 0) end
            if u['c_magician'] then c_magician = math.min(2, u['c_magician'].count or 0) end
            if u['c_devil'] then c_devil = math.min(2, u['c_devil'].count or 0) end
        end
        
        return { vars = { c_hiero, c_empress, c_lovers, c_chariot, c_justice, c_tower, c_magician, c_devil, enh_str, payout } }
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

    set_ability = function(self, card, initial)
        if initial then
            card.ability.extra.target_enhancement = get_ophiuchus_enhancement('ophiuchus_init')
        end
    end,

    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            card.ability.extra.target_enhancement = get_ophiuchus_enhancement('ophiuchus_blind' .. G.GAME.round)
            local center = G.P_CENTERS[card.ability.extra.target_enhancement]
            local name = center and center.loc_txt and center.loc_txt.name or "???"
            
            G.E_MANAGER:add_event(Event({
                func = function()
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = name, colour = G.C.MONEY})
                    return true
                end
            }))
        end

        if context.individual and context.cardarea == G.play then
            if context.other_card.config.center.key == card.ability.extra.target_enhancement then
                ease_dollars(card.ability.extra.payout)
                return {
                    message = "+$" .. card.ability.extra.payout,
                    colour = G.C.MONEY,
                    card = card
                }
            end
        end
    end
}