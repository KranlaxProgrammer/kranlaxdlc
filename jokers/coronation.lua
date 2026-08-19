-- ==============================================================================
-- EL INTERCEPTOR: Vigila las cartas exactas al jugar una mano
-- ==============================================================================
if not SMODS.kranlaxs_coronation_hook then
    local orig_play = G.FUNCS.play_cards_from_highlighted
    G.FUNCS.play_cards_from_highlighted = function(e, hook)
        -- Si hay una partida activa y hay cartas seleccionadas para jugar
        if G.GAME and G.hand and G.hand.highlighted then
            -- Condición 1: Deben ser exactamente 5 cartas
            if #G.hand.highlighted == 5 then
                local valid_kings = 0
                
                -- Evaluamos cada carta seleccionada
                for _, card in ipairs(G.hand.highlighted) do
                    -- Condición 2: Es un Rey (id 13)
                    -- Condición 3: Tiene Sello Rojo (seal == 'Red')
                    -- Condición 4: Es una carta de Acero (m_steel)
                    if card.base.id == 13 and card.seal == 'Red' and card.config.center.key == 'm_steel' then
                        valid_kings = valid_kings + 1
                    end
                end
                
                -- Si las 5 cartas cumplieron todos los requisitos, mandamos la señal
                if valid_kings == 5 then
                    G.GAME.kranlaxs_coronation_unlocked = true
                end
            end
        end
        
        -- Continuamos con la acción normal de jugar la mano
        orig_play(e, hook)
    end
    SMODS.kranlaxs_coronation_hook = true
end

-- ==============================================================================
-- JOKER: CORONATION
-- ==============================================================================
SMODS.Joker{
    key = "coronation",
    config = { extra = {} },
    pos = { x = 7, y = 6 },
    display_size = { w = 71, h = 95 },
    cost = 6,
    rarity = 2,
    blueprint_compat = false, 
    eternal_compat = true,
    perishable_compat = true,
    
    unlocked = false, -- ¡Cambiado a false para activar el candado!
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    -- Función que atrapa la señal del interceptor
    check_for_unlock = function(self, args)
        if G.GAME and G.GAME.kranlaxs_coronation_unlocked then
            return true
        end
        return false
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
    
    calculate = function(self, card, context)
        -- Usamos 'before' para que el cambio de carta o el sello ocurra justo ANTES de puntuar,
        -- así el nuevo Rey (o el Sello) sumará puntos inmediatamente en esta misma mano.
        if context.before and not context.blueprint then
            
            -- 1. ESCANEAR EL MAZO COMPLETO
            local has_low_cards = false
            if G.playing_cards then
                for _, c in ipairs(G.playing_cards) do
                    -- En Balatro, la J es 11, Q es 12, K es 13 y el As es 14.
                    -- Por lo tanto, cualquier ID entre 2 y 10 es una carta "baja".
                    if c.base.id >= 2 and c.base.id <= 10 then
                        has_low_cards = true
                        break
                    end
                end
            end

            -- FASE 1: Aún hay cartas bajas en el mazo (Coronación)
            if has_low_cards then
                local lowest_card = nil
                local lowest_val = 99

                -- Buscamos la carta con el número más pequeño de la mano jugada (que puntúe)
                for _, sc in ipairs(context.scoring_hand) do
                    if sc.base.id >= 2 and sc.base.id <= 10 then
                        if sc.base.id < lowest_val then
                            lowest_val = sc.base.id
                            lowest_card = sc
                        end
                    end
                end

                if lowest_card then
                    -- Extraemos el palo original de la carta ('Spades' -> 'S') y lo combinamos con la 'K'
                    local suit_prefix = string.sub(lowest_card.base.suit, 1, 1)
                    local new_code = suit_prefix .. '_K'
                    
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            lowest_card:juice_up()
                            lowest_card:set_base(G.P_CARDS[new_code]) -- Transforma en Rey manteniendo su palo
                            return true
                        end
                    }))
                    
                    return {
                        message = "¡Coronación!",
                        colour = G.C.ORANGE,
                        card = card
                    }
                end

            -- FASE 2: El mazo es puro J, Q, K, A (Sello Rojo)
            else
                local first_king = nil
                -- Buscamos el primer rey de la mano puntuada
                for _, sc in ipairs(context.scoring_hand) do
                    if sc.base.id == 13 then
                        first_king = sc
                        break
                    end
                end

                if first_king then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            first_king:juice_up()
                            first_king:set_seal('Red', true, true)
                            return true
                        end
                    }))
                    
                    return {
                        message = "¡Poder Real!",
                        colour = G.C.RED,
                        card = card
                    }
                end
            end
        end
    end
}