SMODS.Joker{
    key = "beachday",
    config = { extra = { x_chips = 3, min_level = 15 } },
    pos = { x = 10, y = 8 }, 
    display_size = { w = 71, h = 95 },
    cost = 6,
    rarity = 3, 
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    check_for_unlock = function(self, args)
        if args.type == 'win' then
            -- Pozo Carmesí = Stake 12
            if G.GAME.selected_back.effect.center.key == 'b_kranlaxs_ash_deck' and G.GAME.stake >= 12 then
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
        return {vars = {card.ability.extra.x_chips, card.ability.extra.min_level}}
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local hand_name = context.scoring_name
            local lvl = 1
            if G.GAME and G.GAME.hands and G.GAME.hands[hand_name] then
                lvl = G.GAME.hands[hand_name].level
            end
            
            if lvl >= card.ability.extra.min_level then
                return {
                    message = "X" .. card.ability.extra.x_chips .. " Fichas",
                    Xchip_mod = card.ability.extra.x_chips,
                    colour = G.C.CHIPS
                }
            end
        end
    end
}