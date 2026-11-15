


if not SMODS.kranlaxs_coronation_hook then
    local orig_play = G.FUNCS.play_cards_from_highlighted
    G.FUNCS.play_cards_from_highlighted = function(e, hook)
        
        if G.GAME and G.hand and G.hand.highlighted then
            
            if #G.hand.highlighted == 5 then
                local valid_kings = 0
                
                
                for _, card in ipairs(G.hand.highlighted) do
                    
                    
                    
                    if card.base.id == 13 and card.seal == 'Red' and card.config.center.key == 'm_steel' then
                        valid_kings = valid_kings + 1
                    end
                end
                
                
                if valid_kings == 5 then
                    G.GAME.kranlaxs_coronation_unlocked = true
                end
            end
        end
        
        
        orig_play(e, hook)
    end
    SMODS.kranlaxs_coronation_hook = true
end




SMODS.Joker{
    key = "coronation",
    config = { extra = {} },
    pos = { x = 7, y = 6 },
    display_size = { w = 71, h = 95 },
    cost = 6,
    rarity = 3,
    blueprint_compat = false, 
    eternal_compat = true,
    perishable_compat = true,
    
    unlocked = false, 
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    
    check_for_unlock = function(self, args)
        if G.GAME and G.GAME.kranlaxs_coronation_unlocked then
            return true
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
    
    calculate = function(self, card, context)
        
        
        if context.before and not context.blueprint then
            
            
            local has_low_cards = false
            if G.playing_cards then
                for _, c in ipairs(G.playing_cards) do
                    
                    
                    if c.base.id >= 2 and c.base.id <= 10 then
                        has_low_cards = true
                        break
                    end
                end
            end

            
            if has_low_cards then
                local lowest_card = nil
                local lowest_val = 99

                
                for _, sc in ipairs(context.scoring_hand) do
                    if sc.base.id >= 2 and sc.base.id <= 10 then
                        if sc.base.id < lowest_val then
                            lowest_val = sc.base.id
                            lowest_card = sc
                        end
                    end
                end

                if lowest_card then
                    
                    local suit_prefix = string.sub(lowest_card.base.suit, 1, 1)
                    local new_code = suit_prefix .. '_K'
                    
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            lowest_card:juice_up()
                            lowest_card:set_base(G.P_CARDS[new_code]) 
                            return true
                        end
                    }))
                    
                    return {
                        message = "¡Coronación!",
                        colour = G.C.ORANGE,
                        card = card
                    }
                end

            
            else
                local first_king = nil
                
                for _, sc in ipairs(context.scoring_hand) do
                    if sc.base.id == 13 then
                        first_king = sc
                        break
                    end
                end

                if first_king then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            first_king:juice_up()
                            first_king:set_seal('Red', true, true)
                            return true
                        end
                    }))
                    
                    return {
                        message = "¡Poder Real!",
                        colour = G.C.RED,
                        card = card
                    }
                end
            end
        end
    end
}