SMODS.Consumable {
    key = 'turquoisequartz',
    set = 'Quartz',
    pos = { x = 12, y = 0 }, 
    cost = 6,
    unlocked = false, 
    discovered = false,
    unlock_condition = {type = '', extra = ''},
    atlas = 'QuartzConsumables',

    in_pool = function(self, args)
        if SMODS.showman and SMODS.showman('c_kranlaxs_' .. self.key) then return true end
        if not G.consumeables or not G.consumeables.cards then return true end
        for _, v in ipairs(G.consumeables.cards) do
            if v.config.center.key == 'c_kranlaxs_' .. self.key then return false end
        end
        return true
    end,
    
    can_use = function(self, card)
        return false 
    end,

    calculate = function(self, card, context)
        
        if context.retrigger_joker_check and not context.retrigger_joker and context.other_joker then
            if G.jokers and G.jokers.cards and G.jokers.cards[1] == context.other_joker then
                return {
                    message = '¡Reactivado!',
                    repetitions = 2,
                    card = context.other_joker
                }
            end
        end
    end,

    
    check_for_unlock = function(self, args)
        if args.type == 'win' then
            
            if G.GAME.selected_back.effect.center.key == 'b_zodiac' and G.GAME.stake == 'kranlaxs_turquoise' then
                return true 
            end
        end
        return false
    end
}





if not SMODS.turquoise_hooked then
    local original_set_debuff = Card.set_debuff
    function Card:set_debuff(card)
        original_set_debuff(self, card)
        
        
        if self.area == G.jokers and G.consumeables then
            local has_turq = false
            for _, c in ipairs(G.consumeables.cards) do
                if c.config.center.key == 'c_kranlaxs_turquoisequartz' then 
                    has_turq = true 
                    break 
                end
            end
            
            
            if has_turq then
                if self ~= G.jokers.cards[1] then
                    self.debuff = true
                end
            end
        end
    end
    SMODS.turquoise_hooked = true
end