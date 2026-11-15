SMODS.Joker{
    key = "rottenapple",
    config = { extra = { slots = 3, hands = -1, discards = -1, hand_size = -1 } },
    pos = { x = 10, y = 10 }, 
    display_size = { w = 71, h = 95 },
    cost = 6,
    rarity = 2, 
    blueprint_compat = false, 
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    check_for_unlock = function(self, args)
        if args.type == 'win' then
            -- Nivel 4 = Pozo Negro
            if G.GAME.selected_back.effect.center.key == 'b_kranlaxs_ash_deck' and G.GAME.stake >= 4 then
                return true
            end
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
        return {vars = {card.ability.extra.slots, math.abs(card.ability.extra.hands), math.abs(card.ability.extra.discards), math.abs(card.ability.extra.hand_size)}}
    end,

    add_to_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.slots
        G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
        ease_hands_played(card.ability.extra.hands)
        G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.discards
        ease_discard(card.ability.extra.discards)
        G.hand:change_size(card.ability.extra.hand_size)
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.slots
        G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hands
        ease_hands_played(-card.ability.extra.hands)
        G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.discards
        ease_discard(-card.ability.extra.discards)
        G.hand:change_size(-card.ability.extra.hand_size)
    end
}