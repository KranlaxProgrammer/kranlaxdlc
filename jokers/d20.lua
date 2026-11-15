-- Hook global para sobreescribir el costo de las renovaciones sin romper otros mods
if not SMODS.kranlaxs_d20_reroll_hook then
    local alias_calc_reroll = calculate_reroll_cost
    function calculate_reroll_cost(skip_increment)
        alias_calc_reroll(skip_increment)
        
        -- Prioridad 1: Tira de Cupones (fuerza $0). Si existe, el D20 no interfiere.
        local coupon = SMODS.find_card('j_kranlaxs_couponstrip')
        if coupon and #coupon > 0 then
            return 
        end
        
        -- Prioridad 2: D20
        local d20 = SMODS.find_card('j_kranlaxs_d20')
        if d20 and #d20 > 0 then
            local fixed_cost = d20[1].ability.extra.current_cost
            if G.GAME.current_round then 
                -- Congela matemáticamente el coste en el valor que haya dictado el dado
                G.GAME.current_round.reroll_cost = fixed_cost 
            end
        end
    end
    SMODS.kranlaxs_d20_reroll_hook = true
end

SMODS.Joker{
    key = "d20",
    config = { extra = { current_cost = 0, initialized = false } },
    pos = { x = 0, y = 0 }, -- Cambia esto por las coordenadas de tu sprite en el Atlas
    cost = 6,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    loc_vars = function(self, info_queue, card)
        local cost = card.ability.extra.current_cost
        if cost == 0 then cost = "?" end -- Muestra un "?" antes de su primera activación
        return { vars = { cost } }
    end,

    -- Tira el dado por primera vez cuando lo consigues
    set_ability = function(self, card, initial)
        if not card.ability.extra.initialized then
            card.ability.extra.current_cost = pseudorandom('d20_init' .. (G.GAME.round or 1), 1, 20)
            card.ability.extra.initialized = true
        end
    end,
    
    -- Actualizamos la interfaz de la tienda de inmediato si lo compras o lo vendes
    add_to_deck = function(self, card, from_debuff)
        calculate_reroll_cost(true)
    end,
    remove_from_deck = function(self, card, from_debuff)
        calculate_reroll_cost(true)
    end,

    calculate = function(self, card, context)
        -- Se activa exactamente al finalizar la ronda (justo antes de pagar y entrar a la tienda)
        if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
            
            -- Tira el dado con una semilla protegida (varía de 1 a 20)
            local new_cost = pseudorandom('d20_roll' .. (G.GAME.round or 1), 1, 20)
            card.ability.extra.current_cost = new_cost
            
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.2,
                func = function()
                    card:juice_up(0.5, 0.5)
                    play_sound('chips1', 1, 0.8)
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = "$" .. new_cost, colour = G.C.MONEY})
                    calculate_reroll_cost(true)
                    return true
                end
            }))
        end
    end
}
