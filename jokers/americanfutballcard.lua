SMODS.Joker{
    key = "american",
    config = { extra = { x_mult = 2 } },
    pos = { x = 08, y = 10 }, 
    display_size = { w = 71, h = 95 },
    cost = 20,
    bm_cost = 6, 
    rarity = "kranlaxs_zenith",
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.x_mult}}
    end,

    calculate = function(self, card, context)
        if context.other_joker then
            local is_supreme = false
            local rarity = context.other_joker.config.center.rarity
            
            
            if type(rarity) == 'number' and rarity == 4 then is_supreme = true end
            if type(rarity) == 'string' and (rarity == 'Legendary' or rarity == 'kranlaxs_legendary') then is_supreme = true end
            
            
            if type(rarity) == 'string' and (rarity == 'zenith' or rarity == 'kranlaxs_zenith') then is_supreme = true end
            if type(rarity) == 'table' and (rarity.key == 'zenith' or rarity.key == 'kranlaxs_zenith') then is_supreme = true end

            if is_supreme then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        context.other_joker:juice_up(0.5, 0.5)
                        return true
                    end
                }))
                return {
                    message = "X" .. card.ability.extra.x_mult .. " Mult",
                    Xmult_mod = card.ability.extra.x_mult,
                    colour = G.C.RED
                }
            end
        end
    end
}