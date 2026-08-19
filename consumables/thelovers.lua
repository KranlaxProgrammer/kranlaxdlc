SMODS.Consumable {
    key = 'thelovers',
    set = 'InverseTarot',
    pos = { x = 2, y = 1 },
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
        
        -- Verificación segura de cartas versátiles en la baraja
        local has_wild = false
        for _, pc in pairs(G.playing_cards or {}) do
            if pc.config.center.key == 'm_wild' or SMODS.has_enhancement(pc, 'm_wild') then
                has_wild = true
                break
            end
        end

        if has_wild then
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.4,
                func = function()
                    card_eval_status_text(used_card, 'extra', nil, nil, nil, {message = "+1 Hand Limit", colour = G.C.BLUE})
                    G.hand:change_size(1)
                    return true
                end
            }))
        end
    end,
    
    can_use = function(self, card)
        -- El botón de usar solo se activa si hay al menos una carta Versátil en la baraja
        local has_wild = false
        for _, pc in pairs(G.playing_cards or {}) do
            if pc.config.center.key == 'm_wild' or SMODS.has_enhancement(pc, 'm_wild') then
                has_wild = true
                break
            end
        end
        return has_wild
    end
}