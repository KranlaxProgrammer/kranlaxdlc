SMODS.Joker {
    key = 'sealer',
    atlas = 'CustomJokers',
    pos = { x = 10, y = 1 },
    rarity = 3,
    cost = 8,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    
    loc_vars = function(self, info_queue, card) return { vars = {} } end,
    
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
        if context.before and G.GAME.current_round.hands_left == 0 then
            local available_seals = {}
            for k, _ in pairs(G.P_SEALS) do
                table.insert(available_seals, k)
            end
            
            local sealed_any = false
            if #available_seals > 0 then
                for _, c in ipairs(context.full_hand) do
                    if not c.seal then
                        sealed_any = true
                        local random_seal = pseudorandom_element(available_seals, pseudoseed('sealer_seal'))
                        c:set_seal(random_seal, true, true)
                        c:juice_up(0.5, 0.5)
                    end
                end
            end
            
            if sealed_any then
                return {
                    message = "¡Sellado!",
                    colour = G.C.ORANGE
                }
            end
        end
    end
}