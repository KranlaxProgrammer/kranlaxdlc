SMODS.Joker{ 
    key = "underratedjoker",
    config = { extra = { MostplayedChip = 1 } },
    pos = { x = 1, y = 0 },
    display_size = { w = 71, h = 95 },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    
    
    unlocked = false,
    discovered = false,
    unlock_condition = {type = '', extra = ''},
    
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_mycustom_jokers"] = true },

    check_for_unlock = function(self, args)
        if args.type == 'win' then
            
            if G.GAME.selected_back.effect.center.key == 'b_kranlaxs_space_deck' and G.GAME.stake == 'blue' then
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
        return {vars = {card.ability.extra.MostplayedChip}}
    end,
    
    calculate = function(self, card, context)
        
        
        local is_most_played = function(scoring_name)
            local current_played = G.GAME.hands[scoring_name].played or 0
            for handname, values in pairs(G.GAME.hands) do
                if handname ~= scoring_name and values.visible and values.played > current_played then
                    return false 
                end
            end
            return true 
        end

        
        if context.before and not context.blueprint then
            if is_most_played(context.scoring_name) then
                
                if card.ability.extra.MostplayedChip > 1 then
                    card.ability.extra.MostplayedChip = 1
                    return {
                        message = "Reset!",
                        colour = G.C.RED
                    }
                end
            else
                
                card.ability.extra.MostplayedChip = card.ability.extra.MostplayedChip + 0.2
                return {
                    message = "Upgrade!",
                    colour = G.C.CHIPS
                }
            end
        end

        
        if context.joker_main then
            if card.ability.extra.MostplayedChip > 1 then
                return {
                    message = "X" .. card.ability.extra.MostplayedChip,
                    x_chips = card.ability.extra.MostplayedChip,
                    colour = G.C.CHIPS
                }
            end
        end
        
    end
}