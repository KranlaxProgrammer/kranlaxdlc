SMODS.Joker{
    key = "scarf",
    config = { extra = { mult = 0, gain = 2 } },
    pos = { x = 011, y = 011 }, 
    cost = 5,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true, 
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    loc_vars = function(self, info_queue, card)
        local current_mult = card and card.ability.extra.mult or self.config.extra.mult
        local gain = card and card.ability.extra.gain or self.config.extra.gain
        return { vars = { current_mult, gain } }
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
        if context.before and not context.blueprint then
            if context.poker_hands and next(context.poker_hands['Flush']) then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.gain
                return { message = "¡Tejido!", colour = G.C.MULT, card = card }
            end
        end
        
        if context.joker_main and card.ability.extra.mult > 0 then
            return {
                message = "+" .. card.ability.extra.mult .. " Mult",
                mult_mod = card.ability.extra.mult,
                colour = G.C.MULT
            }
        end
    end
}