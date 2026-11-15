SMODS.Joker{
    key = "chainreaction",
    config = {
        extra = {
            x_chips = 1,
            current_index = 1
        }
    },
    pos = { x = 5, y = 5 },
    display_size = { w = 71, h = 95 },
    cost = 5,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    check_for_unlock = function(self, args)
        if G.GAME and G.GAME.hands then
            local sequence = {'High Card', 'Pair', 'Two Pair', 'Three of a Kind', 'Straight', 'Flush', 'Full House', 'Four of a Kind', 'Five of a Kind', 'Straight Flush', 'Flush House', 'Flush Five'}
            local all_played = true
            
            for _, hand in ipairs(sequence) do
                if not G.GAME.hands[hand] or not G.GAME.hands[hand].played or G.GAME.hands[hand].played <= 0 then
                    all_played = false
                    break
                end
            end
            
            if all_played then
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
        local sequence = {'High Card', 'Pair', 'Two Pair', 'Three of a Kind', 'Straight', 'Flush', 'Full House', 'Four of a Kind', 'Five of a Kind', 'Straight Flush', 'Flush House', 'Flush Five'}
        local current_hand = sequence[card.ability.extra.current_index]
        return {vars = {card.ability.extra.x_chips, localize(current_hand, 'poker_hands')}}
    end,
    
    calculate = function(self, card, context)
        if context.joker_main and not context.blueprint then
            local sequence = {'High Card', 'Pair', 'Two Pair', 'Three of a Kind', 'Straight', 'Flush', 'Full House', 'Four of a Kind', 'Five of a Kind', 'Straight Flush', 'Flush House', 'Flush Five'}
            local required_hand = sequence[card.ability.extra.current_index]

            if context.scoring_name == required_hand then
                card.ability.extra.x_chips = card.ability.extra.x_chips + 0.5
                card.ability.extra.current_index = card.ability.extra.current_index + 1
                
                if card.ability.extra.current_index > 12 then
                    card.ability.extra.current_index = 1
                end

                G.E_MANAGER:add_event(Event({
                    func = function()
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Chain!", colour = G.C.CHIPS})
                        return true
                    end
                }))
            else
                if card.ability.extra.x_chips > 1 or card.ability.extra.current_index > 1 then
                    card.ability.extra.x_chips = 1
                    card.ability.extra.current_index = 1
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Reset", colour = G.C.RED})
                            return true
                        end
                    }))
                end
            end
        end
        
        if context.joker_main then
            if card.ability.extra.x_chips > 1 then
                return {
                    message = "X" .. card.ability.extra.x_chips,
                    Xchips = card.ability.extra.x_chips,
                    colour = G.C.CHIPS,
                    sound = 'kranlaxs_multiplicativechips'
                }
            end
        end
    end
}