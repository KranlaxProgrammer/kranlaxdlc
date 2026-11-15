SMODS.Joker{
    key = "salsadancers",
    config = { extra = { x_mult = 1.5 } },
    pos = { x = 011, y = 012 }, 
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
        if args.type == 'hand_played' and args.poker_hands and next(args.poker_hands['Pair']) then
            G.GAME.kranlaxs_salsa_pairs = (G.GAME.kranlaxs_salsa_pairs or 0) + 1
            if G.GAME.kranlaxs_salsa_pairs >= 20 then return true end
        end
        return false
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
    
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.x_mult}}
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            -- Solo activa si la mano CONTIENE un par
            if context.poker_hands and next(context.poker_hands['Pair']) then
                return {
                    x_mult = card.ability.extra.x_mult,
                    card = card
                }
            end
        end
    end
}