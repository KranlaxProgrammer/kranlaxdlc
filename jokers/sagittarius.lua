SMODS.Joker{
    key = "sagittarius",
    -- Rework: Ganancia reducida a 4
    config = { extra = { mult = 0, gain = 4 } },
    pos = { x = 0, y = 012 }, 
    display_size = { w = 71, h = 95 },
    cost = 4,
    rarity = 1, 
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',
    is_constellation = true, 
    
    check_for_unlock = function(self, args)
        if args.type == 'win' then
            -- Verifica que los saltos de la run sigan en cero
            if (G.GAME.skips or 0) == 0 then
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
        return {vars = {card.ability.extra.gain, card.ability.extra.mult}}
    end,

    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.gain
            return {
                message = "+" .. card.ability.extra.gain .. " Mult",
                colour = G.C.RED,
                card = card
            }
        end
        
        if context.skip_blind and not context.blueprint then
            if card.ability.extra.mult > 0 then
                card.ability.extra.mult = 0
                return {
                    message = "¡Reinicio!",
                    colour = G.C.RED,
                    card = card
                }
            end
        end

        if context.joker_main then
            if card.ability.extra.mult > 0 then
                return {
                    message = "+" .. card.ability.extra.mult,
                    mult_mod = card.ability.extra.mult,
                    colour = G.C.RED
                }
            end
        end
    end
}