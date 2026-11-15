SMODS.Joker{
    key = "aries",
    pos = { x = 0, y = 011 }, 
    display_size = { w = 71, h = 95 },
    cost = 8,
    rarity = 3, 
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',

    
    is_constellation = true, 

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
    
    
    set_badges = function(self, card, badges)
        local badge_text = "Constellation"
        
        
        if G.localization and G.localization.misc and G.localization.misc.dictionary and G.localization.misc.dictionary.k_constellation then
            badge_text = G.localization.misc.dictionary.k_constellation
        else
            
            if G.SETTINGS.language == 'es_419' or G.SETTINGS.language == 'es_ES' then
                badge_text = "Constelación"
            end
        end
        
        badges[#badges + 1] = create_badge(badge_text, HEX('3D266B'), G.C.WHITE, 1.2)
    end,
    
    loc_vars = function(self, info_queue, card) return {vars = {}} end
}




if not SMODS.kranlaxs_aries_hook then
    local orig_calculate_joker = Card.calculate_joker
    
    function Card:calculate_joker(context)
        
        if self.config.center.key == 'j_kranlaxs_aries' or self.debuff then
            return orig_calculate_joker(self, context)
        end
        
        
        local is_last_hand = G.GAME and G.GAME.current_round and G.GAME.current_round.hands_left == 0
        
        
        local aries_count = 0
        if is_last_hand and G.jokers and G.jokers.cards then
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].config.center.key == 'j_kranlaxs_aries' and not G.jokers.cards[i].debuff then
                    aries_count = aries_count + 1
                end
            end
        end
        
        
        if aries_count == 0 then
            return orig_calculate_joker(self, context)
        end
        
        
        local b_mult = self.ability.mult or 0
        local b_xmult = self.ability.x_mult or 1
        local b_ex_chips = (type(self.ability.extra) == 'table' and type(self.ability.extra.chips) == 'number') and self.ability.extra.chips or 0
        local b_ex_mult = (type(self.ability.extra) == 'table' and type(self.ability.extra.mult) == 'number') and self.ability.extra.mult or 0
        local b_ex_xmult = (type(self.ability.extra) == 'table' and type(self.ability.extra.Xmult) == 'number') and self.ability.extra.Xmult or 1
        
        
        local ret = orig_calculate_joker(self, context)
        
        
        local a_mult = self.ability.mult or 0
        local a_xmult = self.ability.x_mult or 1
        local a_ex_chips = (type(self.ability.extra) == 'table' and type(self.ability.extra.chips) == 'number') and self.ability.extra.chips or 0
        local a_ex_mult = (type(self.ability.extra) == 'table' and type(self.ability.extra.mult) == 'number') and self.ability.extra.mult or 0
        local a_ex_xmult = (type(self.ability.extra) == 'table' and type(self.ability.extra.Xmult) == 'number') and self.ability.extra.Xmult or 1
        
        local scaled = false
        
        
        if a_mult > b_mult then 
            self.ability.mult = self.ability.mult + ((a_mult - b_mult) * aries_count)
            scaled = true 
        end
        if a_xmult > b_xmult then 
            self.ability.x_mult = self.ability.x_mult + ((a_xmult - b_xmult) * aries_count)
            scaled = true 
        end
        if a_ex_chips > b_ex_chips then 
            self.ability.extra.chips = self.ability.extra.chips + ((a_ex_chips - b_ex_chips) * aries_count)
            scaled = true 
        end
        if a_ex_mult > b_ex_mult then 
            self.ability.extra.mult = self.ability.extra.mult + ((a_ex_mult - b_ex_mult) * aries_count)
            scaled = true 
        end
        if a_ex_xmult > b_ex_xmult then 
            self.ability.extra.Xmult = self.ability.extra.Xmult + ((a_ex_xmult - b_ex_xmult) * aries_count)
            scaled = true 
        end
        
        
        if scaled then
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].config.center.key == 'j_kranlaxs_aries' and not G.jokers.cards[i].debuff then
                    G.jokers.cards[i]:juice_up(0.3, 0.3)
                end
            end
        end
        
        return ret
    end
    
    SMODS.kranlaxs_aries_hook = true
end