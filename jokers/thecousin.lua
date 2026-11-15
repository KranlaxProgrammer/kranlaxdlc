SMODS.Joker{
    key = "thecousin",
    config = { extra = { cousin = 0 } },
    pos = { x = 6, y = 2 },
    display_size = { w = 71, h = 95 },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    check_for_unlock = function(self, args)
        if args.type == 'win' then
            if G.GAME.selected_back.effect.center.key == 'b_kranlaxs_space_deck' and G.GAME.stake == 'kranlaxs_turquoise' then
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
        return {vars = {card.ability.extra.cousin}}
    end,
    
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.blueprint then
            local id = context.other_card:get_id()
            if id == 2 or id == 3 or id == 5 or id == 7 or id == 14 then
                
                -- Detecta Modo Desbalance para otorgar +13 en vez de +7
                local unbal = SMODS.Mods["kranlaxs"] and SMODS.Mods["kranlaxs"].config.unbalanced_mode
                local gain = unbal and 13 or 7
                
                card.ability.extra.cousin = card.ability.extra.cousin + gain
                return {
                    message = 'Upgrade!',
                    colour = G.C.CHIPS,
                    card = card
                }
            end
        end

        if context.joker_main then
            if card.ability.extra.cousin > 0 then
                return {
                    message = "+" .. card.ability.extra.cousin,
                    chip_mod = card.ability.extra.cousin,
                    colour = G.C.CHIPS
                }
            end
        end
    end
}