SMODS.Joker{
    key = "vikingo",
    config = { extra = { picks = 1 } }, -- Ahora solo aumenta la selección
    pos = { x = 07, y = 012 },
    display_size = { w = 71, h = 95 },
    cost = 6,
    rarity = 3,
    blueprint_compat = false, -- Incompatible con plano
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',

    check_for_unlock = function(self, args)
        if args.type == 'win' then
            if G.GAME.selected_back.effect.center.key == 'b_kranlaxs_dungeon_deck' and G.GAME.stake >= 10 then
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
        return {vars = {card.ability.extra.picks}}
    end,
    
    add_to_deck = function(self, card, from_debuff)
        -- Cuando compras al Vikingo o se añade a la baraja
        G.GAME.modifiers.booster_choice_mod = (G.GAME.modifiers.booster_choice_mod or 0) + card.ability.extra.picks
    end,
    
    remove_from_deck = function(self, card, from_debuff)
        -- Cuando lo vendes o se destruye
        G.GAME.modifiers.booster_choice_mod = (G.GAME.modifiers.booster_choice_mod or 0) - card.ability.extra.picks
    end
}