SMODS.Joker{
    key = "telescope",
    config = {
        extra = {
            target_planet = 'c_pluto'
        }
    },
    pos = { x = 3, y = 6 },
    display_size = { w = 71, h = 95 },
    cost = 5,
    bm_cost = 6,
    rarity = "kranlaxs_zenith",
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    check_for_unlock = function(self, args)
        if args and args.type == 'win' then
            if G.GAME and G.GAME.stake == 2 and G.GAME.selected_back and G.GAME.selected_back.effect.center.key == 'b_kranlaxs_week_challenge' then
                return true
            end
        end
        return false
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
            local hand_to_planet = {
                ['High Card'] = 'c_pluto', ['Pair'] = 'c_mercury', ['Two Pair'] = 'c_uranus',
                ['Three of a Kind'] = 'c_venus', ['Straight'] = 'c_saturn', ['Flush'] = 'c_jupiter',
                ['Full House'] = 'c_earth', ['Four of a Kind'] = 'c_mars', ['Five of a Kind'] = 'c_neptune',
                ['Flush House'] = 'c_ceres', ['Flush Five'] = 'c_eris'
            }
            
            local most_played = 'High Card'
            local max_played = -1
            local level_gt_1 = {}
            local level_1 = {}
            
            if G.GAME.hands then
                for k, v in pairs(G.GAME.hands) do
                    if v.played > max_played then
                        max_played = v.played
                        most_played = k
                    end
                    if v.level > 1 then table.insert(level_gt_1, k)
                    else table.insert(level_1, k) end
                end
            end
            
            local roll = pseudorandom('telescope' .. (G.GAME.round or 1))
            local target_hand = most_played
            
            if #level_1 > 0 then
                if roll < 0.5 then target_hand = most_played
                elseif roll < 0.8 then target_hand = (#level_gt_1 > 0) and pseudorandom_element(level_gt_1, pseudoseed('tel_1')) or most_played
                else target_hand = pseudorandom_element(level_1, pseudoseed('tel_2')) end
            else
                -- Si no hay nivel 1, se reparte 50/50
                if roll < 0.5 then target_hand = most_played
                else target_hand = (#level_gt_1 > 0) and pseudorandom_element(level_gt_1, pseudoseed('tel_1')) or most_played end
            end
            
            card.ability.extra.target_planet = hand_to_planet[target_hand] or 'c_pluto'
            
            return {
                message = "¡Nuevo Objetivo!",
                colour = G.C.ORANGE
            }
        end
    end
}