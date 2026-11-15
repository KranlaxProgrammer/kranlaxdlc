SMODS.Joker{
    key = "cyanuro",
    config = { extra = {} },
    pos = { x = 0, y = 0 }, 
    soul_pos = { x = 1, y = 0 }, 
    display_size = { w = 71, h = 95 },
    cost = 20,
    rarity = 4, 
    blueprint_compat = true,
    eternal_compat = true,
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
        local hand_name = 'High Card'
        
        
        if G.hand and G.hand.highlighted and #G.hand.highlighted > 0 then
            local text, _, _, _, _ = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
            if text and text ~= 'Nothing' then
                hand_name = text
            end
        end
        
        local lvl = 1
        if G.GAME and G.GAME.hands and G.GAME.hands[hand_name] then
            lvl = G.GAME.hands[hand_name].level
        end
        
        
        local x_mult = math.max(1, lvl)
        
        return {vars = {x_mult}}
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            
            local hand_name = context.scoring_name
            local lvl = 1
            if G.GAME and G.GAME.hands and G.GAME.hands[hand_name] then
                lvl = G.GAME.hands[hand_name].level
            end
            
            local x_mult = math.max(1, lvl)
            
            if x_mult > 1 then
                return {
                    message = "X" .. x_mult .. " Mult",
                    Xmult_mod = x_mult,
                    colour = G.C.RED
                }
            end
        end
    end
}