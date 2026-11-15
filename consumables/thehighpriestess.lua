SMODS.Consumable {
    key = 'thehighpriestess',
    set = 'InverseTarot',
    pos = { x = 8, y = 0 },
    cost = 5,
    unlocked = true,
    discovered = false,
    hidden = false,
    can_repeat_soul = false,
    atlas = 'CustomConsumables',

    in_pool = function(self, args)
        if SMODS.showman and SMODS.showman('c_kranlaxs_' .. self.key) then return true end
        if not G.consumeables or not G.consumeables.cards then return true end
        for _, v in ipairs(G.consumeables.cards) do
            if v.config.center.key == 'c_kranlaxs_' .. self.key then return false end
        end
        return true
    end,
    
    use = function(self, card, area, copier)
        local used_card = copier or card
        
        -- Evento 1: Generar el Agujero Negro usando tu bucle de espacio seguro
        for i = 1, math.min(1, G.consumeables.config.card_limit - #G.consumeables.cards) do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    play_sound('timpani')
                    SMODS.add_card({ set = 'Spectral', key = 'c_black_hole'})                            
                    used_card:juice_up(0.3, 0.5)
                    card_eval_status_text(used_card, 'extra', nil, nil, nil, {message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral})
                    return true
                end
            }))
        end
        
        delay(0.6)
        
        -- Evento 2: Multiplicar el dinero por 0.8 y restar la diferencia
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                local current_dollars = G.GAME.dollars or 0
                -- math.floor redondea hacia abajo para evitar centavos invisibles que rompan Balatro
                local target_dollars = math.floor(current_dollars * 0.8) 
                local dollar_value = target_dollars - current_dollars
                
                if dollar_value < 0 then
                    card_eval_status_text(used_card, 'extra', nil, nil, nil, {message = "X0.8 $", colour = G.C.RED})
                    ease_dollars(dollar_value, true)
                end
                
                return true
            end
        }))
        
        delay(0.6)
        
        -- El return true DEBE ir al final de todo para que no corte la ejecución
        return true
    end,
    
    can_use = function(self, card)
        return true
    end
}