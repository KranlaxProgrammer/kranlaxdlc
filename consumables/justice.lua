SMODS.Consumable {
    key = 'justice',
    set = 'InverseTarot',
    pos = { x = 4, y = 1 },
    config = { extra = { odds = 4 } },
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
    
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'c_kranlaxs_justice')
        return {vars = {numerator, denominator}}
    end,
    
    use = function(self, card, area, copier)
        local used_card = copier or card
        if #G.hand.highlighted == 1 then
            local target = G.hand.highlighted[1]
            
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.4,
                func = function()
                    play_sound('tarot1')
                    used_card:juice_up(0.3, 0.5)
                    return true
                end
            }))
            
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.15,
                func = function()
                    target:flip()
                    play_sound('card1', 1)
                    target:juice_up(0.3, 0.3)
                    return true
                end
            }))
            
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.1,
                func = function()
                    target.ability.perma_x_mult = (target.ability.perma_x_mult or 0) + 2
                    return true
                end
            }))
            
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.15,
                func = function()
                    target:flip()
                    play_sound('tarot2', 1, 0.6)
                    target:juice_up(0.3, 0.3)
                    return true
                end
            }))
            
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.2,
                func = function()
                    G.hand:unhighlight_all()
                    
                    -- Lógica de destrucción
                    if SMODS.pseudorandom_probability(card, 'justice_destroy', 1, card.ability.extra.odds) then
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after', delay = 0.4,
                            func = function()
                                play_sound('tarot1')
                                target:start_dissolve({G.C.RED}, nil, 1.6)
                                return true
                            end
                        }))
                    end
                    return true
                end
            }))
        end
    end,
    
    can_use = function(self, card)
        return #G.hand.highlighted == 1
    end
}