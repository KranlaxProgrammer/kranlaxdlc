SMODS.Joker {
    key = 'eugenizer',
    atlas = 'CustomJokers', 
    pos = { x = 0, y = 9 },
    rarity = 3,
    cost = 8,
    unlocked = false,
    discovered = false,
    blueprint_compat = false,
    config = { extra = { odds = 4 } },
    
    check_for_unlock = function(self, args)
        if args.type == 'win' then
            if G.GAME.selected_back.effect.center.key == 'b_kranlaxs_evil_deck' and G.GAME.stake >= 11 then
                return true
            end
        end
        return false
    end,

    loc_vars = function(self, info_queue, card)
        return { vars = { G.GAME.probabilities.normal or 1, card.ability.extra.odds } }
    end,
    
    in_pool = function(self, args)
        if SMODS.showman and SMODS.showman('j_kranlaxs_' .. self.key) then return true end
        local areas_to_check = {G.jokers, G.shop_jokers, G.pack_cards}
        for _, area in ipairs(areas_to_check) do
            if area and area.cards then
                for _, v in ipairs(area.cards) do
                    if v.config and v.config.center and v.config.center.key == 'j_kranlaxs_' .. self.key then return false end
                end
            end
        end
        return true
    end,
    
    calculate = function(self, card, context)
        if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
            local my_index = 0
            if G.jokers and G.jokers.cards then
                for i = 1, #G.jokers.cards do
                    if G.jokers.cards[i] == card then my_index = i; break end
                end
            end
            
            -- Revisa si hay un Joker a la izquierda
            local left_joker = my_index > 1 and G.jokers.cards[my_index - 1] or nil
            
            if left_joker then
                local r = left_joker.config.center.rarity
                local can_upgrade = (r == 1 or r == 2 or r == 3 or r == 'kranlaxs_zenith')
                
                if can_upgrade and pseudorandom('eugenizer') < (G.GAME.probabilities.normal or 1) / card.ability.extra.odds then
                    
                    local target_rarity = 2
                    if r == 1 then target_rarity = 2
                    elseif r == 2 then target_rarity = 3
                    elseif r == 3 then target_rarity = 'kranlaxs_zenith'
                    elseif r == 'kranlaxs_zenith' then target_rarity = 4
                    end
                    
                    local valid_new_jokers = {}
                    for k, v in pairs(G.P_CENTERS) do
                        if v.set == 'Joker' and not v.no_pool and v.unlocked and v.rarity == target_rarity then
                            table.insert(valid_new_jokers, k)
                        end
                    end
                    
                    if #valid_new_jokers > 0 then
                        local new_joker_key = pseudorandom_element(valid_new_jokers, pseudoseed('eugenizer_upgrade_left'))
                        
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.2,
                            func = function()
                                left_joker:set_ability(G.P_CENTERS[new_joker_key], true, true)
                                left_joker:juice_up(1.0, 1.0)
                                play_sound('tarot1')
                                card:juice_up(0.5, 0.5)
                                return true
                            end
                        }))
                        return {
                            message = "¡Evolución!",
                            colour = G.C.ORANGE
                        }
                    end
                end
            end
        end
    end
}