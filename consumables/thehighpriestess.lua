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
        -- Si el juego apenas está cargando y no hay barra de consumibles, lo permite
        if not G.consumeables or not G.consumeables.cards then return true end
        
        -- Escanea los consumibles que tienes guardados actualmente
        for _, v in ipairs(G.consumeables.cards) do
            -- Revisa si ya posees esta carta (usando el prefijo c_)
            if v.config.center.key == 'c_kranlaxs_' .. self.key then
                return false 
            end
        end
        
        return true
    end,
    
    use = function(self, card, area, copier)
        local used_card = copier or card
        
        -- Crear Agujero Negro
        if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.4,
                func = function()
                    play_sound('timpani')
                    SMODS.add_card({ set = 'Spectral', key = 'c_black_hole'})                            
                    used_card:juice_up(0.3, 0.5)
                    G.GAME.consumeable_buffer = 0
                    return true
                end
            }))
        end
        
        -- Reducir 20% del dinero
        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.6,
            func = function()
                -- ¡PROTECCIÓN ACTIVA! Extraemos el valor sin importar si es Talisman o juego base
                local current_dollars = 0
                if type(G.GAME.dollars) == 'table' and G.GAME.dollars.to_number then
                    current_dollars = G.GAME.dollars:to_number()
                else
                    current_dollars = tonumber(G.GAME.dollars) or 0
                end
                
                -- Se modificó de 0.10 a 0.20 para reflejar la pérdida del 20%
                local money_to_lose = math.floor(current_dollars * 0.20)
                
                if money_to_lose > 0 then
                    card_eval_status_text(used_card, 'extra', nil, nil, nil, {message = "-$"..money_to_lose, colour = G.C.RED})
                    ease_dollars(-money_to_lose, true)
                end
                return true
            end
        }))
    end,
    
    can_use = function(self, card)
        -- ¡PROTECCIÓN ACTIVA! Ambos lados de la balanza hablan el mismo idioma
        return to_big(G.GAME.dollars) > to_big(0)
    end
}