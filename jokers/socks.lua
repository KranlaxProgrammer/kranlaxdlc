SMODS.Joker {
    key = 'socks',
    atlas = 'CustomJokers',
    pos = { x = 03, y = 10 },
    rarity = 2,
    cost = 6,
    unlocked = false,
    discovered = false,
    blueprint_compat = true,
    config = { extra = { chips = 0, chip_gain = 4 } },
    
    check_for_unlock = function(self, args)
        if args.type == 'win' then
            -- Verifica que en toda la run actual no se haya jugado el Doble Par
            if G.GAME and G.GAME.hands and G.GAME.hands["Two Pair"] and G.GAME.hands["Two Pair"].played == 0 then
                return true
            end
        end
        return false
    end,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chip_gain, card.ability.extra.chips } }
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
            if next(context.poker_hands['Two Pair']) then
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
                return { colour = G.C.CHIPS }
            end
        end
        
        if context.joker_main and card.ability.extra.chips > 0 then
            return {
                chips = card.ability.extra.chips,
                colour = G.C.CHIPS
            }
        end
    end
}