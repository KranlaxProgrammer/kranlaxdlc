SMODS.Consumable {
    key = 'lilacquartz',
    set = 'Quartz',
    pos = { x = 4, y = 0 }, 
    cost = 4,
    unlocked = false, -- ¡Cambiado a false para que inicie bloqueado!
    discovered = false,
    unlock_condition = {type = '', extra = ''},
    atlas = 'QuartzConsumables',
    
    can_use = function(self, card)
        local hand_selected = (G.hand and G.hand.highlighted) and #G.hand.highlighted or 0
        local joker_selected = (G.jokers and G.jokers.highlighted) and #G.jokers.highlighted or 0
        
        return (hand_selected + joker_selected) == 1
    end,
    
    use = function(self, card, area, copier)
        local used_card = copier or card
        local target_card = nil
        
        if G.hand and G.hand.highlighted and #G.hand.highlighted == 1 then
            target_card = G.hand.highlighted[1]
        elseif G.jokers and G.jokers.highlighted and #G.jokers.highlighted == 1 then
            target_card = G.jokers.highlighted[1]
        end
        
        if target_card then
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.4,
                func = function()
                    play_sound('tarot1')
                    used_card:juice_up(0.3, 0.5)
                    return true
                end
            }))
            
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.2,
                func = function()
                    target_card:juice_up(0.3, 0.5)
                    play_sound('holo1', 1.2, 1.4)
                    -- Edición Holográfico (Holo)
                    target_card:set_edition({holo = true}, true, true)
                    return true
                end
            }))
        end
    end,

    -- Función nativa para gestionar el desbloqueo
    check_for_unlock = function(self, args)
        if args.type == 'win' then
            -- Comprueba que la baraja sea Nébula ('b_nebula') y el pozo sea tu Pozo Marrón
            if G.GAME.selected_back.effect.center.key == 'b_nebula' and G.GAME.stake == 'kranlaxs_brown' then
                return true -- ¡Desbloqueado!
            end
        end
        return false
    end
}