-- ========================================================
-- RASTREADOR GLOBAL DE FRACASOS EN APUESTAS
-- ========================================================
if not SMODS.kranlaxs_gambling_hooked then
    -- 1. Atrapar mensajes de "¡Nop!" (Rueda de la Fortuna) y "¡Extinto!" (Gros Michel)
    local orig_card_eval_status_text = card_eval_status_text
    function card_eval_status_text(card, eval_type, amt, percent, dir, extra)
        if extra and extra.message then
            local m = extra.message
            if m == localize('k_nope_ex') or m == localize('k_extinct_ex') or m == "Nope!" or m == "Extinct!" then
                if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
                    G.PROFILES[G.SETTINGS.profile].kranlaxs_failed_gambles = (G.PROFILES[G.SETTINGS.profile].kranlaxs_failed_gambles or 0) + 1
                end
            end
        end
        orig_card_eval_status_text(card, eval_type, amt, percent, dir, extra)
    end

    -- 2. Atrapar fallos en comodines con probabilidades (Minero y futuros mods)
    if SMODS.pseudorandom_probability then
        local orig_pseudo_prob = SMODS.pseudorandom_probability
        function SMODS.pseudorandom_probability(card, seed, default, odds)
            local result = orig_pseudo_prob(card, seed, default, odds)
            if not result then 
                if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
                    G.PROFILES[G.SETTINGS.profile].kranlaxs_failed_gambles = (G.PROFILES[G.SETTINGS.profile].kranlaxs_failed_gambles or 0) + 1
                end
            end
            return result
        end
    end

    SMODS.kranlaxs_gambling_hooked = true
end

-- ========================================================
-- LUDOPATÍA SIN FIN
-- ========================================================
SMODS.Joker{
    key = "neverendinggambling",
    config = {
        extra = {
            num1 = 0,
            num2 = 0,
            num3 = 0,
            blind_reduction = 0
        }
    },
    pos = { x = 3, y = 3 },
    display_size = { w = 71, h = 95 },
    cost = 5,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    check_for_unlock = function(self, args)
        if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
            local fails = G.PROFILES[G.SETTINGS.profile].kranlaxs_failed_gambles or 0
            if fails >= 30 then
                return true
            end
        end
        return false
    end,

    locked_loc_vars = function(self, info_queue, card)
        local fails = 0
        if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
            fails = G.PROFILES[G.SETTINGS.profile].kranlaxs_failed_gambles or 0
        end
        return {vars = {fails}}
    end,

    in_pool = function(self, args)
        if not G.jokers or not G.jokers.cards then return true end
        for _, v in ipairs(G.jokers.cards) do
            if v.config.center.key == 'j_kranlaxs_' .. self.key then
                return false 
            end
        end
        return true
    end,

    loc_vars = function(self, info_queue, card)
        local v1 = card.ability.extra.num1 == 0 and "?" or card.ability.extra.num1
        local v2 = card.ability.extra.num2 == 0 and "?" or card.ability.extra.num2
        local v3 = card.ability.extra.num3 == 0 and "?" or card.ability.extra.num3
        return {vars = {v1, v2, v3}}
    end,

    calculate = function(self, card, context)
        if context.setting_blind and card.ability.extra.blind_reduction > 0 and not context.blueprint then
            local reduction = math.min(0.9, card.ability.extra.blind_reduction)
            
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.GAME.blind.chips = G.GAME.blind.chips * to_big(1 - reduction)
                    G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                    G.HUD_blind:recalculate()
                    return true
                end
            }))
        end

        local player_action = context.reroll_shop or context.buying_card or context.selling_card or 
                              context.ending_shop or context.starting_shop or context.ending_booster or 
                              context.skipping_booster or context.open_booster or context.skip_blind or 
                              context.before or context.pre_discard or context.setting_blind or 
                              context.using_consumeable

        if player_action and not context.blueprint and to_big(G.GAME.dollars) >= to_big(5) then
            G.E_MANAGER:add_event(Event({
                func = function()
                    ease_dollars(-1)
                    
                    local n1 = pseudorandom('ng_1', 1, 10)
                    local n2 = pseudorandom('ng_2', 1, 10)
                    local n3 = pseudorandom('ng_3', 1, 10)
                    
                    card.ability.extra.num1 = n1
                    card.ability.extra.num2 = n2
                    card.ability.extra.num3 = n3

                    if n1 == n2 and n2 == n3 then
                        play_sound('timpani')
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = "WIN! ("..n1..")", colour = G.C.GREEN})

                        if n1 == 1 then SMODS.add_card({set = 'Tarot'})
                        elseif n1 == 2 then SMODS.add_card({set = 'Planet'})
                        elseif n1 == 3 then SMODS.add_card({set = 'Spectral'})
                        elseif n1 == 4 then 
                            local jokers = G.jokers.cards
                            if #jokers > 0 and #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
                                local target = pseudorandom_element(jokers, pseudoseed('copy_joker'))
                                local copy = copy_card(target, nil, nil, nil, true)
                                copy:set_edition({negative = true}, true)
                                copy:add_to_deck()
                                G.jokers:emplace(copy)
                            end
                        elseif n1 == 5 then SMODS.add_card({set = 'InverseTarot'})
                        elseif n1 == 6 then
                            local hands = {}
                            for k, v in pairs(G.GAME.hands) do if v.visible then table.insert(hands, k) end end
                            if #hands > 0 then
                                level_up_hand(card, pseudorandom_element(hands, pseudoseed('lvl_up')), true, 2)
                            end
                        elseif n1 == 7 then 
                            ease_dollars(1000)
                        elseif n1 == 8 then 
                            card.ability.extra.blind_reduction = card.ability.extra.blind_reduction + 0.4
                        elseif n1 == 9 then 
                            ease_ante(-1)
                            G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante - 1
                        elseif n1 == 10 then
                            for i = 1, 5 do 
                                local selected_tag = pseudorandom_element(G.P_TAGS, pseudoseed('tg')).key
                                local tag = Tag(selected_tag)
                                tag:set_ability()
                                add_tag(tag)
                            end
                        end
                        
                    elseif n1 == n2 or n2 == n3 or n1 == n3 then
                        ease_dollars(1)
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Close! +$1", colour = G.C.MONEY})
                    else
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Try again", colour = G.C.UI.TEXT_INACTIVE})
                    end
                    
                    return true
                end
            }))
        end
    end
}