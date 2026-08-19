SMODS.Joker{
    key = "luckyseven",
    config = {
        extra = {
            chips = 0,
            mult = 0,
            gain = 7,
            dollars = 7
        }
    },
    pos = { x = 8, y = 5 },
    display_size = { w = 71, h = 95 },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    
    -- ===================================================
    -- SISTEMA DE DESBLOQUEO
    -- ===================================================
    unlocked = false,
    discovered = false,
    
    check_for_unlock = function(self, args)
        -- Escaneamos la baraja completa del jugador
        if G.playing_cards then
            local sevens_count = 0
            
            for _, card in ipairs(G.playing_cards) do
                -- Si el ID de la carta es exactamente 7
                if card:get_id() == 7 then
                    sevens_count = sevens_count + 1
                end
            end
            
            -- Si llegamos a 10, desbloqueamos
            if sevens_count >= 10 then
                return true
            end
        end
        return false
    end,
    -- ===================================================

    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    in_pool = function(self, args)
        -- Si el juego apenas está cargando y no hay barra de jokers, permitir que exista en la pool
        if not G.jokers or not G.jokers.cards then return true end
        
        -- Escanear tu barra de Jokers
        for _, v in ipairs(G.jokers.cards) do
            -- Si ya tienes una copia exacta de esta carta, bloquear su aparición
            if v.config.center.key == 'j_kranlaxs_' .. self.key then
                return false 
            end
        end
        
        return true
    end,
    
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.chips, card.ability.extra.mult}}
    end,
    
    calculate = function(self, card, context)
        -- 1. Dar las Fichas y Multiplicador acumulados durante la puntuación
        if context.joker_main then
            if card.ability.extra.chips > 0 or card.ability.extra.mult > 0 then
                return {
                    message = "Lucky!",
                    -- ARREGLO: 'chip_mod' a 'chips' y 'mult_mod' a 'mult'
                    chips = card.ability.extra.chips > 0 and card.ability.extra.chips or nil,
                    mult = card.ability.extra.mult > 0 and card.ability.extra.mult or nil,
                    colour = G.C.ORANGE
                }
            end
        end

        -- 2. Antes de puntuar: Comprobar condición para mejorar el comodín y dar dinero
        if context.before and not context.blueprint then
            if context.scoring_name == "Three of a Kind" and #context.scoring_hand == 3 then
                local all_sevens = true
                for _, v in ipairs(context.scoring_hand) do
                    if v:get_id() ~= 7 then
                        all_sevens = false
                        break
                    end
                end

                if all_sevens then
                    -- Mejorar estadísticas
                    card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.gain
                    card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.gain
                    
                    -- Dar dinero directamente a la billetera
                    ease_dollars(card.ability.extra.dollars)

                    G.E_MANAGER:add_event(Event({
                        func = function()
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = "+7 / +7 / $7", colour = G.C.MONEY})
                            return true
                        end
                    }))
                end
            end
        end
    end
}