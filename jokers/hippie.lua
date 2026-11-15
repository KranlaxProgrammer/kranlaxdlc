SMODS.Joker{
    key = "hippie",
    config = { extra = { mult = 0, gain = 3 } },
    pos = { x = 09, y = 012 }, 
    display_size = { w = 71, h = 95 },
    cost = 4,
    rarity = 1, 
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',

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
        return {vars = {card.ability.extra.gain, card.ability.extra.mult}}
    end,

    calculate = function(self, card, context)
        
        if context.using_consumeable and not context.blueprint then
            local c_set = context.consumeable.ability.set
            
            
            if c_set == 'InverseTarot' or c_set == 'UNOCards' or c_set == 'Quartz' then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.gain
                
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card:juice_up(0.5, 0.5)
                        return true
                    end
                }))
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = "+" .. card.ability.extra.gain .. " Mult", colour = G.C.RED})
            end
        end

        
        if context.joker_main then
            if card.ability.extra.mult > 0 then
                return {
                    message = "+" .. card.ability.extra.mult,
                    mult_mod = card.ability.extra.mult,
                    colour = G.C.RED
                }
            end
        end
    end
}