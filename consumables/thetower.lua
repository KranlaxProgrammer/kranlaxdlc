SMODS.Consumable {
    key = 'thetower',
    set = 'InverseTarot',
    pos = { x = 1, y = 2 },
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
        if G.hand and #G.hand.cards > 0 then
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.4,
                func = function()
                    play_sound('tarot1')
                    used_card:juice_up(0.3, 0.5)
                    
                    for _, c in ipairs(G.hand.cards) do
                        c:flip()
                    end
                    play_sound('card1', 1)
                    return true
                end
            }))
            
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.2,
                func = function()
                    local total_dollars_gained = 0
                    
                    for _, c in ipairs(G.hand.cards) do
                        local modifications_removed = 0
                        
                        -- Sello
                        if c.seal then 
                            modifications_removed = modifications_removed + 1
                            c:set_seal(nil, true, true) 
                        end
                        -- Edición
                        if c.edition then 
                            modifications_removed = modifications_removed + 1
                            c:set_edition(nil, true, true) 
                        end
                        -- Mejora (Enhancement)
                        if c.config.center.key ~= 'c_base' then 
                            modifications_removed = modifications_removed + 1
                            c:set_ability(G.P_CENTERS.c_base, true, nil) 
                        end
                        -- Estadísticas permanentes
                        if c.ability.perma_bonus and c.ability.perma_bonus > 0 then 
                            modifications_removed = modifications_removed + 1; c.ability.perma_bonus = 0 
                        end
                        if c.ability.perma_mult and c.ability.perma_mult > 0 then 
                            modifications_removed = modifications_removed + 1; c.ability.perma_mult = 0 
                        end
                        if c.ability.perma_x_chips and c.ability.perma_x_chips > 0 then 
                            modifications_removed = modifications_removed + 1; c.ability.perma_x_chips = 0 
                        end
                        if c.ability.perma_x_mult and c.ability.perma_x_mult > 0 then 
                            modifications_removed = modifications_removed + 1; c.ability.perma_x_mult = 0 
                        end
                        if c.ability.perma_p_dollars and c.ability.perma_p_dollars > 0 then 
                            modifications_removed = modifications_removed + 1; c.ability.perma_p_dollars = 0 
                        end
                        
                        total_dollars_gained = total_dollars_gained + modifications_removed
                    end
                    
                    if total_dollars_gained > 0 then
                        ease_dollars(total_dollars_gained, true)
                        card_eval_status_text(used_card, 'extra', nil, nil, nil, {message = "+$"..total_dollars_gained, colour = G.C.MONEY})
                    else
                        card_eval_status_text(used_card, 'extra', nil, nil, nil, {message = "Clean!", colour = G.C.ORANGE})
                    end
                    
                    return true
                end
            }))
            
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.2,
                func = function()
                    for _, c in ipairs(G.hand.cards) do
                        c:flip()
                        c:juice_up(0.3, 0.3)
                    end
                    play_sound('tarot2', 1, 0.6)
                    return true
                end
            }))
        end
    end,
    
    can_use = function(self, card)
        return G.hand and #G.hand.cards > 0
    end
}