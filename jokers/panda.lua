local sug = SMODS.Mods["kranlaxs"].config.suggestive_sprites
SMODS.Joker{
    key = "panda",
    config = { extra = { chips = 500 } },
    pos = sug and {x=0, y=0} or {x=7, y=1},
    display_size = { w = 71, h = 95 },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = sug and 'sug_panda' or 'CustomJokers',
    pools = { ["kranlaxs_prey"] = true },

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
    
    loc_vars = function(self, info_queue, card) return {vars = {card.ability.extra.chips}} end,
    calculate = function(self, card, context)
        if context.joker_main then return { message = "+" .. card.ability.extra.chips, chip_mod = card.ability.extra.chips, colour = G.C.CHIPS } end
    end,
    add_to_deck = function(self, card, from_debuff) G.jokers.config.card_limit = G.jokers.config.card_limit - 1 end,
    remove_from_deck = function(self, card, from_debuff) G.jokers.config.card_limit = G.jokers.config.card_limit + 1 end
}