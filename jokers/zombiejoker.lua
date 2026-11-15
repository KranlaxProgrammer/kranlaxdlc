SMODS.Joker{
    key = "zombiejoker",
    config = { extra = { zombie = 0 } },
    pos = { x = 5, y = 2 },
    display_size = { w = 71, h = 95 },
    cost = 5,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    
    
    unlocked = false,
    discovered = false,
    unlock_condition = {type = '', extra = ''},
    
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    check_for_unlock = function(self, args)
        if args.type == 'win' then
            
            if G.GAME.selected_back.effect.center.key == 'b_kranlaxs_space_deck' and G.GAME.stake == 'purple' then
                return true
            end
        end
        return false
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
    
    loc_vars = function(self, info_queue, card)
        
        return {vars = {card.ability.extra.zombie}}
    end,

    
    
    
    remove_from_deck = function(self, card, from_debuff)
        if not from_debuff and G.STAGE == G.STAGES.RUN then
            if math.random(1, 2) == 1 then
                play_sound('kranlaxs_deathzombie1', 1.0, 1.0)
            else
                play_sound('kranlaxs_deathzombie2', 1.0, 1.0)
            end
        end
    end,
    
    calculate = function(self, card, context)
        
        if context.before and not context.blueprint then
            local first_card = context.full_hand[1]
            local is_scored = false
            
            for _, sc in ipairs(context.scoring_hand) do
                if first_card == sc then is_scored = true; break end
            end

            
            if not is_scored then
                first_card.zombie_destroy = true
                card.ability.extra.zombie = card.ability.extra.zombie + 15
                
                return {
                    message = "Braaains!",
                    colour = G.C.RED
                }
            end
        end

        
        if context.destroy_card and context.destroy_card.zombie_destroy and not context.blueprint then
            return { remove = true }
        end

        
        if context.joker_main then
            if card.ability.extra.zombie > 0 then
                return {
                    message = "+" .. card.ability.extra.zombie,
                    mult_mod = card.ability.extra.zombie,
                    colour = G.C.MULT
                }
            end
        end

        
        if context.end_of_round and context.main_eval and not context.blueprint then
            
            local hands_played = (G.GAME and G.GAME.current_round) and G.GAME.current_round.hands_played or 0
            local deduction = 10 * hands_played
            
            
            card.ability.extra.zombie = card.ability.extra.zombie - deduction

            
            if card.ability.extra.zombie <= 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card.getting_sliced = true
                        card:start_dissolve({G.C.RED}, nil, 1.6)
                        return true
                    end
                }))
                return {
                    message = "c murió",
                    colour = G.C.RED
                }
            else
                
                if deduction > 0 then
                    return {
                        message = "-" .. deduction .. " Mult",
                        colour = G.C.RED
                    }
                end
            end
        end
    end
}