-- ==============================================================================
-- EL INTERCEPTOR: Vigila el uso de planetas para el desbloqueo
-- ==============================================================================
if not SMODS.kranlaxs_solarsystem_hook then
    local orig_use_consumeable = Card.use_consumeable
    function Card:use_consumeable(area, copier)
        -- 1. Ejecutamos la función original para que el juego registre el uso de la carta
        orig_use_consumeable(self, area, copier)
        
        -- 2. Revisamos si ya usamos los 12 planetas en esta run
        if G.GAME and G.GAME.consumeable_usage then
            local planets = {
                'c_ceres', 'c_eris', 'c_planet_x', 'c_neptune', 'c_mars', 'c_earth', 
                'c_jupiter', 'c_saturn', 'c_venus', 'c_uranus', 'c_mercury', 'c_pluto'
            }
            local all_used = true
            
            for _, p in ipairs(planets) do
                -- ¡CORRECCIÓN: Tenemos que leer el campo '.count' de la tabla!
                if not G.GAME.consumeable_usage[p] or G.GAME.consumeable_usage[p].count < 1 then
                    all_used = false
                    break
                end
            end
            
            -- Si el ciclo terminó y 'all_used' sigue siendo true, activamos la señal
            if all_used then
                G.GAME.kranlaxs_solarsystem_unlocked = true
            end
        end
    end
    SMODS.kranlaxs_solarsystem_hook = true
end

-- ==============================================================================
-- JOKER: SOLAR SYSTEM
-- ==============================================================================
SMODS.Joker{
    key = "solarsystem",
    config = {
        extra = {
            current_index = 1
        }
    },
    pos = { x = 7, y = 4 },
    display_size = { w = 71, h = 95 },
    cost = 6,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    -- Atrapamos la señal del interceptor
    check_for_unlock = function(self, args)
        if G.GAME and G.GAME.kranlaxs_solarsystem_unlocked then
            return true
        end
        return false
    end,

    locked_loc_vars = function(self, info_queue, card)
        local used_count = 0
        if G.GAME and G.GAME.consumeable_usage then
            local planets = {
                'c_ceres', 'c_eris', 'c_planet_x', 'c_neptune', 'c_mars', 'c_earth', 
                'c_jupiter', 'c_saturn', 'c_venus', 'c_uranus', 'c_mercury', 'c_pluto'
            }
            for _, p in ipairs(planets) do
                if G.GAME.consumeable_usage[p] and G.GAME.consumeable_usage[p].count >= 1 then
                    used_count = used_count + 1
                end
            end
        end
        return {vars = {used_count}}
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
        -- La secuencia completa de planetas desde Repóquer hasta Carta Alta
        local sequence = {'c_ceres', 'c_eris', 'c_planet_x', 'c_neptune', 'c_mars', 'c_earth', 'c_jupiter', 'c_saturn', 'c_venus', 'c_uranus', 'c_mercury', 'c_pluto'}
        local current_planet = sequence[card.ability.extra.current_index]
        
        -- Muestra el planeta en la ventana emergente al pasar el ratón
        if G.P_CENTERS[current_planet] then info_queue[#info_queue+1] = G.P_CENTERS[current_planet] end
        
        -- Obtiene el nombre traducido del planeta
        local planet_name = localize{type = 'name_text', set = 'Planet', key = current_planet}
        return {vars = {planet_name}}
    end,
    
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and not context.blueprint then
            local sequence = {'c_ceres', 'c_eris', 'c_planet_x', 'c_neptune', 'c_mars', 'c_earth', 'c_jupiter', 'c_saturn', 'c_venus', 'c_uranus', 'c_mercury', 'c_pluto'}
            local planet_to_create = sequence[card.ability.extra.current_index]

            -- Calcular cuál será el siguiente (Si llega a 12, vuelve a 1)
            local next_index = card.ability.extra.current_index + 1
            if next_index > 12 then next_index = 1 end

            -- Crear el Planeta si hay espacio
            if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = function()
                        SMODS.add_card({set = 'Planet', key = planet_to_create})
                        G.GAME.consumeable_buffer = 0
                        return true
                    end
                }))
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = "+1 Planet", colour = G.C.SECONDARY_SET.Planet})
            end
            
            -- Actualizar el índice para la próxima ronda
            card.ability.extra.current_index = next_index
        end
    end
}