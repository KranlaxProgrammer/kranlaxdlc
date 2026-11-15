SMODS.Joker{
    key = "burrow",
    config = {
        extra = {
            conejos = 0
        }
    },
    pos = { x = 1, y = 3 },
    display_size = { w = 71, h = 95 },
    cost = 4,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

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
        
        if G.P_CENTERS.j_kranlaxs_bunny then
            info_queue[#info_queue+1] = G.P_CENTERS.j_kranlaxs_bunny
        end
        return {vars = {card.ability.extra.conejos}}
    end,
    
    calculate = function(self, card, context)
        
        if context.end_of_round and context.main_eval and not context.blueprint then
            card.ability.extra.conejos = card.ability.extra.conejos + 1
            return {
                message = "+1 Bunny",
                colour = G.C.ORANGE
            }
        end

        
        if context.selling_self and not context.blueprint then
            if card.ability.extra.conejos > 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        for i = 1, card.ability.extra.conejos do
                            
                            G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    SMODS.add_card({ set = 'Joker', key = 'j_kranlaxs_bunny' })
                                    G.GAME.joker_buffer = 0
                                    return true
                                end
                            }))
                        end
                        return true
                    end
                }))
                
                return {
                    message = localize('k_plus_joker'),
                    colour = G.C.BLUE
                }
            end
        end
    end
}