SMODS.Joker{
    key = "telescope",
    config = {
        extra = {
            target_planet = 'c_pluto' -- Empieza pidiendo Plutón por defecto
        }
    },
    pos = { x = 3, y = 6 },
    display_size = { w = 71, h = 95 },
    cost = 5,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    
    unlocked = false, -- ¡Cambiado a false para activar el candado!
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    -- Función que atrapa la victoria en Pozo Rojo
    check_for_unlock = function(self, args)
        if args and args.type == 'win' then
            -- Verificamos Pozo Rojo (stake == 2) y la baraja Reto Semanal
            if G.GAME and G.GAME.stake == 2 and G.GAME.selected_back and G.GAME.selected_back.effect.center.key == 'b_kranlaxs_week_challenge' then
                return true
            end
        end
        return false
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
        local planet_to_hand = {
            c_pluto = 'High Card', c_mercury = 'Pair', c_uranus = 'Two Pair',
            c_venus = 'Three of a Kind', c_saturn = 'Straight', c_jupiter = 'Flush',
            c_earth = 'Full House', c_mars = 'Four of a Kind', c_neptune = 'Five of a Kind',
            c_planet_x = 'Five of a Kind', c_ceres = 'Flush House', c_eris = 'Flush Five'
        }
        
        local hand_name = planet_to_hand[card.ability.extra.target_planet]
        local hand_translated = localize(hand_name, 'poker_hands')
        
        if G.P_CENTERS[card.ability.extra.target_planet] then 
            info_queue[#info_queue+1] = G.P_CENTERS[card.ability.extra.target_planet] 
        end
        
        return {vars = {hand_translated}}
    end,
    
    calculate = function(self, card, context)
        if context.using_consumeable then
            if context.consumeable.ability.set == 'Planet' and context.consumeable.config.center.key == card.ability.extra.target_planet then
                local planet_to_hand = {
                    c_pluto = 'High Card', c_mercury = 'Pair', c_uranus = 'Two Pair',
                    c_venus = 'Three of a Kind', c_saturn = 'Straight', c_jupiter = 'Flush',
                    c_earth = 'Full House', c_mars = 'Four of a Kind', c_neptune = 'Five of a Kind',
                    c_planet_x = 'Five of a Kind', c_ceres = 'Flush House', c_eris = 'Flush Five'
                }
                local target_hand = planet_to_hand[card.ability.extra.target_planet]
                
                level_up_hand(card, target_hand, true, 1)
                
                return {
                    message = localize('k_level_up_ex'),
                    colour = G.C.SECONDARY_SET.Planet
                }
            end
        end

        if context.end_of_round and context.main_eval and not context.blueprint then
            local planet_keys = {'c_pluto', 'c_mercury', 'c_uranus', 'c_venus', 'c_saturn', 'c_jupiter', 'c_earth', 'c_mars', 'c_neptune', 'c_planet_x', 'c_ceres', 'c_eris'}
            card.ability.extra.target_planet = pseudorandom_element(planet_keys, pseudoseed('telescope'))
            
            return {
                message = "New target!",
                colour = G.C.ORANGE
            }
        end
    end
}