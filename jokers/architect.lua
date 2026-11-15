SMODS.Joker {
    key = 'charlatan',
    atlas = 'CustomJokers',
    pos = { x = 05, y = 10 },
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    config = { extra = { h_size = 2, active = false } },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.h_size } }
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
    
    add_to_deck = function(self, card, from_debuff)
        if G.GAME and G.GAME.blind and G.GAME.blind.boss and not card.ability.extra.active then
            card.ability.extra.active = true
            G.hand:change_size(card.ability.extra.h_size)
        end
    end,

    remove_from_deck = function(self, card, from_debuff)
        if card.ability.extra.active then
            card.ability.extra.active = false
            G.hand:change_size(-card.ability.extra.h_size)
        end
    end,
    
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            if G.GAME and G.GAME.blind and G.GAME.blind.boss and not card.ability.extra.active then
                card.ability.extra.active = true
                G.hand:change_size(card.ability.extra.h_size)
            end
        end
        
        if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
            if card.ability.extra.active then
                card.ability.extra.active = false
                G.hand:change_size(-card.ability.extra.h_size)
            end
        end
    end
}