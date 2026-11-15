SMODS.Joker{
    key = "medusa",
    config = { extra = {} },
    pos = { x = 8, y = 4 },
    display_size = { w = 71, h = 95 },
    cost = 7,
    rarity = 3,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    
    
    unlocked = false,
    discovered = false,
    unlock_condition = {type = '', extra = ''},
    
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    check_for_unlock = function(self, args)
        if args.type == 'win' then
            if G.GAME.selected_back.effect.center.key == 'b_kranlaxs_space_deck' and G.GAME.stake == 'kranlaxs_brown' then
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
    
    calculate = function(self, card, context)
        
        if context.after and not context.blueprint then
            local petrified = false
            
            
            for _, v in ipairs(context.full_hand) do
                if v.config.center.key ~= 'm_stone' then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            
                            v:set_ability(G.P_CENTERS.m_stone, nil, true)
                            v:juice_up()
                            return true
                        end
                    }))
                    petrified = true
                end
            end
            
            if petrified then
                return {
                    message = "Petrified!",
                    colour = G.C.UI.TEXT_DARK
                }
            end
        end
    end
}