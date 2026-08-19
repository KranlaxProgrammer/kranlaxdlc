SMODS.Consumable {
    key = 'temperance',
    set = 'InverseTarot',
    pos = { x = 7, y = 2 },
    cost = 5,
    unlocked = true,
    discovered = false,
    hidden = false,
    can_repeat_soul = false,
    atlas = 'CustomConsumables',

    in_pool = function(self, args)
        if not G.consumeables or not G.consumeables.cards then return true end
        for _, v in ipairs(G.consumeables.cards) do
            if v.config.center.key == 'c_kranlaxs_' .. self.key then
                return false 
            end
        end
        return true
    end,
    
    use = function(self, card, area, copier)
        local used_card = copier or card
        
        -- Animación inicial de la carta de Tarot
        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.4,
            func = function()
                play_sound('tarot1')
                used_card:juice_up(0.3, 0.5)
                return true
            end
        }))
        
        -- Escaneamos la zona de comodines
        if G.jokers and G.jokers.cards then
            -- Iteramos en reversa para evitar problemas al eliminar elementos de una lista
            for i = #G.jokers.cards, 1, -1 do
                local j = G.jokers.cards[i]
                
                -- QoL: Solo afecta a comodines que NO estén fijados
                if not j.pinned then
                    
                    -- Ponemos la venta en un pequeño evento para crear una "reacción en cadena" visual
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after', delay = 0.15,
                        func = function()
                            -- 1. Forzamos la desactivación del estado "Eterno"
                            if j.ability then j.ability.eternal = false end
                            
                            -- 2. Triplicamos su valor actual
                            j.sell_cost = (j.sell_cost or 0) * 3
                            
                            -- 3. Lo vendemos de forma nativa (esto suma el dinero y activa sinergias)
                            j:sell_card()
                            
                            return true
                        end
                    }))
                end
            end
        end
    end,
    
    
    can_use = function(self, card)
        -- El consumible solo se puede usar si tienes al menos 1 comodín que no esté Fijado
        if G.jokers and G.jokers.cards then
            for _, j in ipairs(G.jokers.cards) do
                if not j.pinned then
                    return true
                end
            end
        end
        return false
    end
}