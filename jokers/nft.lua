SMODS.Joker{
    key = "nft",
    config = {
        extra = {}
    },
    pos = { x = 6, y = 3 },
    display_size = { w = 71, h = 95 },
    cost = 4,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    in_pool = function(self, args)
        if not G.jokers or not G.jokers.cards then return true end
        
        for _, v in ipairs(G.jokers.cards) do
            if v.config.center.key == 'j_kranlaxs_' .. self.key then
                return false 
            end
        end
        
        return true
    end,
    
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand and not context.end_of_round and not context.blueprint then
            
            -- ¡LA SOLUCIÓN! Guardamos la carta en una variable local fija
            local target_card = context.other_card
            local id = target_card:get_id()
            
            if id > 2 and id <= 14 then
                
                local rank_map = {
                    [14] = "King", [13] = "Queen", [12] = "Jack", [11] = "10",
                    [10] = "9", [9] = "8", [8] = "7", [7] = "6",
                    [6] = "5", [5] = "4", [4] = "3", [3] = "2"
                }
                
                G.E_MANAGER:add_event(Event({
                    func = function()
                        -- Ahora usamos 'target_card' en lugar de 'context.other_card'
                        SMODS.change_base(target_card, nil, rank_map[id])
                        target_card:juice_up(0.3, 0.3)
                        card_eval_status_text(target_card, 'extra', nil, nil, nil, {message = "Downgraded!", colour = G.C.RED})
                        return true
                    end
                }))
                
                card:juice_up(0.3, 0.3)
            end
        end
    end
}