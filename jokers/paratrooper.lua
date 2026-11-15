SMODS.Joker {
    key = 'paratrooper',
    atlas = 'CustomJokers',
    pos = { x = 06, y = 10 },
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = false,
    blueprint_compat = true, -- Solo fichas compatible
    config = { extra = { chips = 200, timer = 0 } },
    
    loc_vars = function(self, info_queue, card)
        -- Si llega a 20 o menos, envía la clave "_min" para que cargue la descripción oculta sin la resta de fichas
        local loc_key = self.key
        if card and card.ability and card.ability.extra.chips <= 20 then
            loc_key = self.key .. "_min"
        end
        return { key = loc_key, vars = { card.ability.extra.chips } }
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
    
    update = function(self, card, dt)
        if G.GAME and card.area == G.jokers then
            if card.ability.extra.chips > 20 then
                card.ability.extra.timer = card.ability.extra.timer + dt
                if card.ability.extra.timer >= 2 then
                    local drops = math.floor(card.ability.extra.timer / 2)
                    card.ability.extra.chips = math.max(20, card.ability.extra.chips - drops)
                    card.ability.extra.timer = card.ability.extra.timer - (drops * 2)
                end
            end
        end
    end,
    
    calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.chips > 0 then
            return {
                chips = card.ability.extra.chips,
                colour = G.C.CHIPS
            }
        end
    end
}