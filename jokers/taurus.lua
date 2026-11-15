SMODS.Joker{
    key = "taurus",
    config = { extra = { target_money = 10, odds = 3 } }, -- Actualizado a $10
    pos = { x = 01, y = 011 }, 
    display_size = { w = 71, h = 95 },
    cost = 6,
    rarity = 3, 
    blueprint_compat = false, -- Incompatible
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',
    is_constellation = true, 

    check_for_unlock = function(self, args)
        if args.type == 'win' then
            -- Nivel 1 = Pozo Blanco
            if G.GAME.selected_back.effect.center.key == 'b_kranlaxs_catalog_deck' and G.GAME.stake >= 1 then
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
    
    set_badges = function(self, card, badges)
        local badge_text = "Constellation"
        if G.localization and G.localization.misc and G.localization.misc.dictionary and G.localization.misc.dictionary.k_constellation then
            badge_text = G.localization.misc.dictionary.k_constellation
        else
            if G.SETTINGS.language == 'es_419' or G.SETTINGS.language == 'es_ES' then badge_text = "Constelación" end
        end
        badges[#badges + 1] = create_badge(badge_text, HEX('3D266B'), G.C.WHITE, 1.2)
    end,
    
    loc_vars = function(self, info_queue, card)
        return {vars = {G.GAME.probabilities.normal, card.ability.extra.odds, card.ability.extra.target_money}}
    end,

    calculate = function(self, card, context)
        if context.ending_shop then
            if G.GAME.dollars < card.ability.extra.target_money then
                if pseudorandom('taurus') < G.GAME.probabilities.normal / card.ability.extra.odds then
                    local difference = card.ability.extra.target_money - G.GAME.dollars
                    ease_dollars(difference)
                    return {
                        message = "$" .. card.ability.extra.target_money,
                        colour = G.C.MONEY,
                        card = card
                    }
                end
            end
        end
    end
}