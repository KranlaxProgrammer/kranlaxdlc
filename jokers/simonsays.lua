local function get_new_req(card)
    local reqs = {
        {t = 'play_hand', v = pseudorandom_element({'High Card', 'Pair', 'Two Pair', 'Three of a Kind', 'Straight', 'Flush', 'Full House'}, pseudoseed('simon'))},
        {t = 'discard_hand', v = pseudorandom_element({'High Card', 'Pair', 'Two Pair', 'Three of a Kind', 'Straight', 'Flush', 'Full House'}, pseudoseed('simon'))},
        {t = 'use_consumable', v = pseudorandom_element({'Tarot', 'Planet', 'Spectral'}, pseudoseed('simon'))},
        {t = 'buy_joker', v = 'Joker'},
        {t = 'sell_joker', v = 'Joker'},
        {t = 'buy_voucher', v = 'Voucher'},
        {t = 'buy_booster', v = 'Booster'},
        {t = 'skip_booster', v = 'Booster'},
        {t = 'skip_blind', v = 'Blind'}
    }
    local choice = pseudorandom_element(reqs, pseudoseed('simon_choice'))
    card.ability.extra.req_type = choice.t
    card.ability.extra.req_val = choice.v
end

SMODS.Joker{
    key = 'simonsays',
    config = { extra = { xmult = 1, xmult_add = 0.25 } },
    rarity = 2,
    atlas = 'CustomJokers',
    pos = { x = 2, y = 7 },
    cost = 6,
    blueprint_compat = true,
    unlocked = false,
    discovered = false,
    unlock_condition = {type = '', extra = ''},
    
    check_for_unlock = function(self, args)
        if G and G.PROFILES and G.PROFILES[G.SETTINGS.profile] then
            if G.PROFILES[G.SETTINGS.profile].all_unlocked then return true end
            if G.PROFILES[G.SETTINGS.profile].challenge_progress and G.PROFILES[G.SETTINGS.profile].challenge_progress.completed then
                -- Requiere: El Gran Tallo
                if G.PROFILES[G.SETTINGS.profile].challenge_progress.completed.c_kranlaxs_reto_tallo then return true end
            end
        end
        return false
    end,
    
    loc_vars = function(self, info_queue, card)
        if not card.ability.extra.req_type then get_new_req(card) end
        local req_t, req_v = card.ability.extra.req_type, card.ability.extra.req_val
        local is_es = (G.SETTINGS.language == 'es_419' or G.SETTINGS.language == 'es_ES')
        local peticion = ""
        if req_t == 'play_hand' then peticion = (is_es and "Juega " or "Play ") .. localize(req_v, 'poker_hands')
        elseif req_t == 'discard_hand' then peticion = (is_es and "Descarta " or "Discard ") .. localize(req_v, 'poker_hands')
        elseif req_t == 'use_consumable' then peticion = (is_es and "Usa carta " or "Use ") .. localize(req_v, 'set')
        elseif req_t == 'buy_joker' then peticion = (is_es and "Compra un Comodín" or "Buy a Joker")
        elseif req_t == 'sell_joker' then peticion = (is_es and "Vende un Comodín" or "Sell a Joker")
        elseif req_t == 'buy_voucher' then peticion = (is_es and "Compra un Vale" or "Buy a Voucher")
        elseif req_t == 'buy_booster' then peticion = (is_es and "Abre un Paquete" or "Open a Booster Pack")
        elseif req_t == 'skip_booster' then peticion = (is_es and "Omite un Paquete" or "Skip a Booster Pack")
        elseif req_t == 'skip_blind' then peticion = (is_es and "Omite una Ciega" or "Skip a Blind")
        end
        return { vars = { card.ability.extra.xmult, card.ability.extra.xmult_add, peticion } }
    end,
    
    calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.xmult > 1 then
            return { Xmult_mod = card.ability.extra.xmult, message = localize{type='variable',key='a_xmult',vars={card.ability.extra.xmult}} }
        end
        local req_t, req_v = card.ability.extra.req_type, card.ability.extra.req_val
        local success = false
        if req_t == 'play_hand' and context.joker_main and context.scoring_name == req_v then success = true end
        if req_t == 'discard_hand' and context.pre_discard and not context.blueprint then
            local text, _, _, _, _ = G.FUNCS.get_poker_hand_info(context.full_hand)
            if text == req_v then success = true end
        end
        if req_t == 'use_consumable' and context.using_consumeable and not context.blueprint then
            if context.consumeable.ability.set == req_v then success = true end
        end
        if context.buying_card and not context.blueprint then
            if req_t == 'buy_joker' and context.card.ability.set == 'Joker' then success = true end
            if req_t == 'buy_voucher' and context.card.ability.set == 'Voucher' then success = true end
            if req_t == 'buy_booster' and context.card.ability.set == 'Booster' then success = true end
        end
        if req_t == 'sell_joker' and context.selling_card and not context.blueprint then
            if context.card.ability.set == 'Joker' then success = true end
        end
        if req_t == 'skip_booster' and context.skip_booster and not context.blueprint then success = true end
        if req_t == 'skip_blind' and context.skip_blind and not context.blueprint then success = true end

        if success then
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_add
            get_new_req(card)
            return { message = localize('k_upgrade_ex'), colour = G.C.MULT }
        end
    end
}