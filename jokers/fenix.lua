if not SMODS.kranlaxs_fenix_wild_hook then
    local orig_is_suit = Card.is_suit
    -- EL ERROR ESTABA AQUÍ: Ya no se escribe 'self' en los paréntesis porque se usa ':'
    function Card:is_suit(suit, bypass_debuff, flush_calc)
        if G.jokers and G.jokers.cards then
            for _, j in ipairs(G.jokers.cards) do
                if j.config.center.key == 'j_kranlaxs_fenix' and j.ability and j.ability.extra and j.ability.extra.enh_wild > 0 and not j.debuff then
                    return true
                end
            end
        end
        return orig_is_suit(self, suit, bypass_debuff, flush_calc)
    end
    SMODS.kranlaxs_fenix_wild_hook = true
end

SMODS.Joker {
    key = 'fenix',
    atlas = 'CustomJokers',
    pos = { x = 5, y = 1 }, 
    rarity = "kranlaxs_zenith",
    cost = 10,
    bm_cost = 6,
    unlocked = false,
    discovered = false,
    blueprint_compat = true, 
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },
    config = { 
        extra = {
            -- Mejoras
            enh_bonus = 0, enh_mult = 0, enh_wild = 0, enh_glass = 0, 
            enh_steel = 0, enh_stone = 0, enh_gold = 0, enh_lucky = 0,
            -- Ediciones
            ed_foil = 0, ed_holo = 0, ed_poly = 0,
            -- Sellos
            seal_red = 0, seal_blue = 0, seal_gold = 0,
            -- Memoria de mano
            last_hand = 'High Card'
        } 
    },

    check_for_unlock = function(self, args)
        if args.type == 'win' and G.GAME.selected_back.effect.center.key == 'b_kranlaxs_ash_deck' and G.GAME.stake >= 15 then
            return true
        end
        return false
    end,
    locked_loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
    
    loc_vars = function(self, info_queue, card)
        return { vars = { 
            card.ability.extra.enh_bonus, card.ability.extra.enh_mult, card.ability.extra.enh_glass,
            card.ability.extra.enh_steel, card.ability.extra.enh_lucky, card.ability.extra.enh_gold,
            card.ability.extra.enh_wild > 0 and "Sí" or "No", 
            card.ability.extra.seal_blue > 0 and "Sí" or "No"
        }}
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
        
        -- 1) REGISTRO DE CARTAS DESTRUIDAS (Soporte masivo para Tarots, Vidrio, Inmolación, etc.)
        if (context.cards_destroyed or (context.remove_playing_cards and context.removed)) and not context.blueprint then
            local destroyed_cards = {}
            if context.cards_destroyed then 
                for _, v in ipairs(context.cards_destroyed) do table.insert(destroyed_cards, v) end
            end
            if context.remove_playing_cards and context.removed then
                for _, v in ipairs(context.removed) do table.insert(destroyed_cards, v) end
            end

            if #destroyed_cards > 0 then
                local absorbed = false
                for _, dc in ipairs(destroyed_cards) do
                    if dc.config and dc.config.center then
                        local center = dc.config.center.key
                        local seal = dc.seal
                        local edition = dc.edition

                        -- Absorber Mejoras
                        if center == 'm_bonus' then card.ability.extra.enh_bonus = card.ability.extra.enh_bonus + 1; absorbed = true
                        elseif center == 'm_mult' then card.ability.extra.enh_mult = card.ability.extra.enh_mult + 1; absorbed = true
                        elseif center == 'm_wild' then card.ability.extra.enh_wild = card.ability.extra.enh_wild + 1; absorbed = true
                        elseif center == 'm_glass' then card.ability.extra.enh_glass = card.ability.extra.enh_glass + 1; absorbed = true
                        elseif center == 'm_steel' then card.ability.extra.enh_steel = card.ability.extra.enh_steel + 1; absorbed = true
                        elseif center == 'm_stone' then card.ability.extra.enh_stone = card.ability.extra.enh_stone + 1; absorbed = true
                        elseif center == 'm_gold' then card.ability.extra.enh_gold = card.ability.extra.enh_gold + 1; absorbed = true
                        elseif center == 'm_lucky' then card.ability.extra.enh_lucky = card.ability.extra.enh_lucky + 1; absorbed = true
                        end

                        -- Absorber Sellos (Omitiendo el morado)
                        if seal == 'Red' then card.ability.extra.seal_red = card.ability.extra.seal_red + 1; absorbed = true
                        elseif seal == 'Blue' then card.ability.extra.seal_blue = card.ability.extra.seal_blue + 1; absorbed = true
                        elseif seal == 'Gold' then card.ability.extra.seal_gold = card.ability.extra.seal_gold + 1; absorbed = true
                        end

                        -- Absorber Ediciones
                        if edition then
                            if edition.foil then card.ability.extra.ed_foil = card.ability.extra.ed_foil + 1; absorbed = true
                            elseif edition.holo then card.ability.extra.ed_holo = card.ability.extra.ed_holo + 1; absorbed = true
                            elseif edition.polychrome then card.ability.extra.ed_poly = card.ability.extra.ed_poly + 1; absorbed = true
                            end
                        end
                    end
                end

                if absorbed then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            card:juice_up(0.5, 0.5)
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = "¡Absorbido!", colour = G.C.ORANGE})
                            return true
                        end
                    }))
                end
            end
        end

        -- 2) REGISTRO DE ÚLTIMA MANO (Para Sello Azul)
        if context.before and not context.blueprint then
            card.ability.extra.last_hand = context.scoring_name
        end

        -- 3) REACTIVACIÓN DEL SELLO ROJO (Aplicado estrictamente a la primera carta jugada)
        if context.repetition and context.cardarea == G.play then
            if context.other_card == context.scoring_hand[1] and card.ability.extra.seal_red > 0 then
                return {
                    message = "¡Reactivado!",
                    repetitions = card.ability.extra.seal_red,
                    card = card
                }
            end
        end

        -- 4) EVALUACIÓN PRINCIPAL (Puntuación y Fases Activas)
        if context.joker_main then
            local chips = (card.ability.extra.enh_bonus * 30) + (card.ability.extra.enh_stone * 50) + (card.ability.extra.ed_foil * 50)
            local mult = (card.ability.extra.enh_mult * 4) + (card.ability.extra.ed_holo * 10)
            
            -- El XMult escala sumando sus modificadores
            local xmult = (card.ability.extra.enh_glass * 2) + (card.ability.extra.enh_steel * 1.5) + (card.ability.extra.ed_poly * 1.5)
            
            local dollars = (card.ability.extra.seal_gold * 3)

            -- Probabilidades de la Suerte (Lucky)
            if card.ability.extra.enh_lucky > 0 then
                if pseudorandom('fenix_lucky_mult') < G.GAME.probabilities.normal / 5 then
                    mult = mult + (card.ability.extra.enh_lucky * 20)
                end
                if pseudorandom('fenix_lucky_money') < G.GAME.probabilities.normal / 20 then
                    dollars = dollars + (card.ability.extra.enh_lucky * 20)
                end
            end

            -- Dinero del Sello Dorado
            if dollars > 0 then
                ease_dollars(dollars)
            end

            -- Riesgo de Romperse por el Vidrio (No aplica a la copia del Plano)
            if card.ability.extra.enh_glass > 0 and not context.blueprint then
                if pseudorandom('fenix_glass') < G.GAME.probabilities.normal / 4 then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after', delay = 0.3,
                        func = function()
                            play_sound('glass1')
                            card:start_dissolve({G.C.ORANGE}, nil, 1.6)
                            return true
                        end
                    }))
                end
            end

            local ret = {}
            local triggered = false
            
            if chips > 0 then ret.chips = chips; triggered = true end
            if mult > 0 then ret.mult = mult; triggered = true end
            if xmult > 0 then ret.Xmult_mod = xmult; triggered = true end

            if triggered then
                ret.message = "¡Fénix!"
                ret.colour = G.C.ORANGE
                return ret
            end
        end

        -- 5) FINAL DE LA RONDA (Sello Azul y Carta de Oro)
        if context.end_of_round and not context.individual and not context.repetition and context.main_eval then
            -- Efecto Oro
            local gold_dollars = card.ability.extra.enh_gold * 3
            if gold_dollars > 0 then
                ease_dollars(gold_dollars)
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = "+$"..gold_dollars, colour = G.C.MONEY})
            end

            -- Efecto Sello Azul (Crea un Planeta basado en la última mano)
            if card.ability.extra.seal_blue > 0 and card.ability.extra.last_hand then
                if G.consumeables.config.card_limit > #G.consumeables.cards then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            local _planet = 0
                            for k, v in pairs(G.P_CENTER_POOLS.Planet) do
                                if v.config.hand_type == card.ability.extra.last_hand then
                                    _planet = v.key
                                    break
                                end
                            end
                            if _planet ~= 0 then
                                local p_card = create_card('Planet', G.consumeables, nil, nil, nil, nil, _planet, 'fenix_planet')
                                p_card:add_to_deck()
                                G.consumeables:emplace(p_card)
                                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_plus_planet'), colour = G.C.SECONDARY_SET.Planet})
                            end
                            return true
                        end
                    }))
                end
            end
        end

    end
}