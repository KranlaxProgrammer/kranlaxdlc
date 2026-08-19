-- ==============================================================================
-- EL INTERCEPTOR: Vigila cuánto dinero ganas al final de la ronda
-- ==============================================================================
if not SMODS.kranlaxs_icecreamsandwich_hook then
    local orig_ease_dollars = ease_dollars
    function ease_dollars(mod, args)
        -- Usamos to_big() para evitar crasheos si el jugador usa el mod Talisman
        if to_big(mod) > to_big(0) and G.STATE == G.STATES.ROUND_EVAL and G.GAME and G.GAME.blind then
            -- Creamos un ID único para la ronda actual (Ej: "1_Small Blind")
            local current_blind_id = tostring(G.GAME.round_resets.ante) .. "_" .. tostring(G.GAME.blind.name)
            
            -- Si el ID de la ronda cambió, significa que es un nuevo cobro. Reiniciamos la cuenta a 0.
            if G.GAME.kranlaxs_payout_round_id ~= current_blind_id then
                G.GAME.kranlaxs_payout_round_id = current_blind_id
                G.GAME.kranlaxs_current_payout = to_big(0)
            end
            
            -- Sumamos el dinero asegurándonos de que ambos sean compatibles con Bignums
            G.GAME.kranlaxs_current_payout = to_big(G.GAME.kranlaxs_current_payout) + to_big(mod)
        end
        
        -- Ejecutamos la función original de Balatro
        orig_ease_dollars(mod, args)
    end
    SMODS.kranlaxs_icecreamsandwich_hook = true
end

-- ==============================================================================
-- JOKER: ICE CREAM SANDWICH
-- ==============================================================================
SMODS.Joker{
    key = "icecreamsandwich",
    config = {
        extra = {
            extrapay = 15,
            drop = 3
        }
    },
    pos = { x = 8, y = 2 },
    display_size = { w = 71, h = 95 },
    cost = 6,
    rarity = 2,
    blueprint_compat = true, -- ¡Ahora es compatible con Plano/Lluvia de Ideas!
    eternal_compat = false,
    perishable_compat = true,
    
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_food"] = true },

    check_for_unlock = function(self, args)
        if args and args.type == 'money' then
            if G.GAME and G.GAME.kranlaxs_current_payout and to_big(G.GAME.kranlaxs_current_payout) >= to_big(50) then
                return true
            end
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
    
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.extrapay, card.ability.extra.drop}}
    end,
    
    -- ¡Eliminamos calc_dollar_bonus() por completo! Todo pasa aquí:
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval then
            
            -- Si lo está copiando el Blueprint, solo da el dinero
            if context.blueprint then
                local money = card.ability.extra.extrapay
                ease_dollars(money)
                return {
                    message = localize('$')..money,
                    colour = G.C.MONEY
                }
            else
                -- Si es el Sándwich original, procedemos con la secuencia completa:
                local money = card.ability.extra.extrapay
                
                -- Primero, bajamos su valor matemáticamente
                card.ability.extra.extrapay = card.ability.extra.extrapay - card.ability.extra.drop
                
                -- Segundo: Evento visual para dar el dinero correcto a la billetera (+15$)
                ease_dollars(money)
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('$')..money, colour = G.C.MONEY})
                        return true
                    end
                }))
                
                -- Tercero: Evaluamos si se derritió por completo
                if card.ability.extra.extrapay <= 0 then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after', delay = 0.5,
                        func = function()
                            play_sound('tarot1')
                            card.T.r = -0.2
                            card:juice_up(0.3, 0.4)
                            card.getting_sliced = true
                            card:start_dissolve({G.C.RED}, nil, 1.6)
                            return true
                        end
                    }))
                else
                    -- Si no se derritió, mostramos el mensaje de que perdió valor (-3$)
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after', delay = 0.5,
                        func = function()
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = "-$" .. card.ability.extra.drop, colour = G.C.RED})
                            return true
                        end
                    }))
                end
            end
        end
    end
}