SMODS.Joker{
    key = "tsunami",
    config = { extra = { x_chips = 4 } },
    pos = { x = 11, y = 1 }, 
    display_size = { w = 71, h = 95 },
    cost = 8,
    rarity = 3, 
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    check_for_unlock = function(self, args)
        if G.hand and G.hand.config and G.hand.config.card_limit >= 12 then
            return true
        end
        return false
    end,

    locked_loc_vars = function(self, info_queue, card)
        local current_hand_size = (G.hand and G.hand.config and G.hand.config.card_limit) or 0
        -- Pasamos el valor XChips como el primer slot, y el tamaño de mano como el segundo
        return {vars = {self.config.extra.x_chips, current_hand_size}}
    end,

    in_pool = function(self, args)
        if not G.hand or G.hand.config.card_limit < 12 then 
            return false 
        end

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
        return {vars = {card.ability.extra.x_chips}}
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = "X" .. card.ability.extra.x_chips .. " Fichas",
                Xchip_mod = card.ability.extra.x_chips,
                colour = G.C.CHIPS
            }
        end
    end
}