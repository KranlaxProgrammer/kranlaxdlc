-- ==========================================
-- HOOK GLOBAL: Inyección del Botón "Apostar"
-- ==========================================
if not SMODS.kranlaxs_gambling_ui_hook then
    
    local orig_use_and_sell = G.UIDEF.use_and_sell_buttons
    function G.UIDEF.use_and_sell_buttons(card)
        local t = orig_use_and_sell(card)
        
        if card and card.config and card.config.center and card.config.center.key == 'j_kranlaxs_neverendinggambling' 
           and not card.debuff and card.area == G.jokers then
            
            -- Detección de idioma dinámico
            local is_es = (G.SETTINGS.language == 'es_419' or G.SETTINGS.language == 'es_ES')
            local btn_text = is_es and "¡Apostar!" or "Gamble!"
            
            local gamble_btn = {
                n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
                    {n = G.UIT.C, config = {ref_table = card, align = "cm", padding = 0.1, r = 0.1, hover = true, colour = G.C.BLUE, button = 'kranlaxs_gamble_action', shadow = true}, nodes = {
                        {n = G.UIT.T, config = {text = btn_text, scale = 0.45, colour = G.C.WHITE, shadow = true}}
                    }}
                }
            }
            
            if t and type(t) == 'table' and t.nodes then
                table.insert(t.nodes, gamble_btn)
            end
        end
        return t
    end
    
    G.FUNCS.kranlaxs_gamble_action = function(e)
        local card = e.config.ref_table
        local is_es = (G.SETTINGS.language == 'es_419' or G.SETTINGS.language == 'es_ES')
        
        if card and card.ability and (G.GAME.dollars or 0) >= 1 then
            play_sound('coin3')
            
            card.ability.extra.rolls = (card.ability.extra.rolls or 0) + 1
            local roll_seed = (G.GAME.round or 1) .. '_' .. card.ability.extra.rolls
            
            G.E_MANAGER:add_event(Event({
                func = function()
                    ease_dollars(-1)
                    
                    local n1 = pseudorandom('ng_1_' .. roll_seed, 1, 7)
                    local n2 = pseudorandom('ng_2_' .. roll_seed, 1, 7)
                    local n3 = pseudorandom('ng_3_' .. roll_seed, 1, 7)
                    
                    card.ability.extra.num1 = n1
                    card.ability.extra.num2 = n2
                    card.ability.extra.num3 = n3

                    -- PREMIO MAYOR (3 Iguales)
                    if n1 == n2 and n2 == n3 then
                        card.ability.extra.fails_in_a_row = 0 
                        play_sound('timpani')
                        local msg_win = is_es and ("¡BINGO! ("..n1..")") or ("WIN! ("..n1..")")
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = msg_win, colour = G.C.GREEN})

                        if n1 == 1 then 
                            ease_dollars(100)
                        elseif n1 == 2 then 
                            if G.jokers and G.jokers.cards and #G.jokers.cards > 0 then
                                local target = pseudorandom_element(G.jokers.cards, pseudoseed('copy_jkr_' .. roll_seed))
                                local copy = copy_card(target, nil, nil, nil, true)
                                copy:set_edition({negative = true}, true)
                                copy:add_to_deck()
                                G.jokers:emplace(copy)
                            end
                        elseif n1 == 3 then 
                            card.ability.extra.blind_reduction = card.ability.extra.blind_reduction + 0.15
                        elseif n1 == 4 then 
                            local hands = {}
                            for k, v in pairs(G.GAME.hands) do if v.visible then table.insert(hands, k) end end
                            if #hands > 0 then
                                level_up_hand(card, pseudorandom_element(hands, pseudoseed('lvl_up_' .. roll_seed)), true, 3)
                            end
                        elseif n1 == 5 then 
                            for i = 1, 3 do 
                                local tag = Tag(pseudorandom_element(G.P_TAGS, pseudoseed('tg_' .. i .. '_' .. roll_seed)).key)
                                tag:set_ability()
                                add_tag(tag)
                            end
                        elseif n1 == 6 then
                            for i = 1, 2 do
                                SMODS.add_card({set = 'Spectral'})
                            end
                        elseif n1 == 7 then 
                            ease_ante(-1)
                            G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante - 1
                        end
                        
                    -- PREMIO MENOR (2 Iguales)
                    elseif n1 == n2 or n2 == n3 or n1 == n3 then
                        card.ability.extra.fails_in_a_row = 0 
                        ease_dollars(1)
                        local msg_casi = is_es and "¡Casi! +$1" or "Close! +$1"
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = msg_casi, colour = G.C.MONEY})
                    
                    -- NADA (Fallo)
                    else
                        card.ability.extra.fails_in_a_row = (card.ability.extra.fails_in_a_row or 0) + 1
                        
                        -- SISTEMA DE REEMBOLSO SECRETO (10 Fallos seguidos)
                        if card.ability.extra.fails_in_a_row >= 10 then
                            card.ability.extra.fails_in_a_row = 0
                            ease_dollars(10)
                            play_sound('coin1') 
                            local msg_refund = is_es and "¡Reembolso! +$10" or "Refund! +$10"
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = msg_refund, colour = G.C.MONEY})
                        else
                            -- Mensaje genérico, sin revelar el contador
                            local msg_try = is_es and "¡Fallaste!" or "Try again!"
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = msg_try, colour = G.C.UI.TEXT_INACTIVE})
                        end
                    end
                    
                    return true
                end
            }))
        else
            play_sound('cancel')
            if card then card:juice_up(0.3, 0.3) end
        end
    end
    
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
    
    SMODS.kranlaxs_gambling_ui_hook = true
end

-- ==========================================
-- EL COMODÍN EN SÍ
-- ==========================================
SMODS.Joker {
    key = "neverendinggambling",
    atlas = 'CustomJokers',
    pos = { x = 3, y = 3 },
    rarity = 2,
    cost = 5,
    unlocked = false,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    config = { extra = { num1 = 0, num2 = 0, num3 = 0, blind_reduction = 0, fails_in_a_row = 0, rolls = 0 } },

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
                    if G.GAME.blind and G.GAME.blind.chips then
                        G.GAME.blind.chips = math.floor(G.GAME.blind.chips * (1 - reduction))
                        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                        if G.HUD_blind then G.HUD_blind:recalculate() end
                    end
                    return true
                end
            }))
        end
    end
}
