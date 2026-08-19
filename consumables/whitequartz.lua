SMODS.Consumable {
    key = 'whitequartz',
    set = 'Quartz',
    pos = { x = 1, y = 0 }, 
    cost = 3,
    unlocked = false, -- ¡Cambiado a false para que inicie bloqueado!
    discovered = false,
    unlock_condition = {type = '', extra = ''},
    atlas = 'QuartzConsumables', 
    -- La Perla nace con la memoria en blanco
    config = { extra = { saved_card = 'none' } }, 
    
    loc_vars = function(self, info_queue, card)
        -- Leemos la memoria de ESTA Perla en específico
        local saved_key = card.ability.extra and card.ability.extra.saved_card
        local card_name = '?'
        
        -- Si hay una carta en la memoria (y no está en blanco), buscamos su nombre
        if saved_key and saved_key ~= 'none' and G.P_CENTERS[saved_key] then
            card_name = localize{type = 'name_text', key = saved_key, set = G.P_CENTERS[saved_key].set}
        end
        
        return {vars = {card_name}}
    end,
    
    can_use = function(self, card)
        local saved_key = card.ability.extra and card.ability.extra.saved_card
        
        -- Solo se puede usar si: Hay espacio Y la memoria NO está en blanco
        return #G.consumeables.cards < G.consumeables.config.card_limit and 
               saved_key and saved_key ~= 'none'
    end,
    
    use = function(self, card, area, copier)
        local used_card = copier or card
        local saved_key = card.ability.extra and card.ability.extra.saved_card
        
        if saved_key and saved_key ~= 'none' then
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.4,
                func = function()
                    play_sound('timpani')
                    used_card:juice_up(0.3, 0.5)
                    return true
                end
            }))
            
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.4,
                func = function()
                    -- Creamos la carta exacta que la Perla tenía en su memoria
                    local new_card = create_card('Consumeables', G.consumeables, nil, nil, nil, nil, saved_key, 'white_quartz')
                    new_card:add_to_deck()
                    G.consumeables:emplace(new_card)
                    return true
                end
            }))
        end
    end,

    -- Función nativa para gestionar el desbloqueo
    check_for_unlock = function(self, args)
        if args.type == 'win' then
            -- Comprueba que la baraja sea la Fantasma ('b_ghost') y el pozo sea tu Pozo Marrón
            if G.GAME.selected_back.effect.center.key == 'b_ghost' and G.GAME.stake == 'kranlaxs_brown' then
                return true -- ¡Desbloqueado!
            end
        end
        return false
    end
}

-- ====================================================================================
-- EL ESCUCHADOR DE CONSUMIBLES
-- Detecta cuando usas CUALQUIER consumible en el juego y se lo enseña a la Perla
-- ====================================================================================
if not SMODS.whitequartz_hooked then
    local original_use_consumeable = Card.use_consumeable
    
    function Card:use_consumeable(area, copier)
        -- Capturamos qué carta estás a punto de usar
        local key = self.config.center.key
        
        -- Ejecuta el uso normal de la carta
        original_use_consumeable(self, area, copier)
        
        -- Si la carta que acabas de usar NO es una Perla...
        if key ~= 'c_kranlaxs_whitequartz' then
            
            -- Buscamos en tus consumibles actuales
            if G.consumeables and G.consumeables.cards then
                for _, v in ipairs(G.consumeables.cards) do
                    -- Si tienes una Perla guardada...
                    if v.config.center.key == 'c_kranlaxs_whitequartz' then
                        -- ¡Le grabamos la carta que acabas de usar en su memoria!
                        v.ability.extra = v.ability.extra or {}
                        v.ability.extra.saved_card = key
                    end
                end
            end
        end
    end
    
    SMODS.whitequartz_hooked = true
end