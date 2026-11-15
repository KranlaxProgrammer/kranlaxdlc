SMODS.Joker{
    key = "virgo",
    config = { extra = { chips_per_clean = 25 } },
    pos = { x = 04, y = 011 }, 
    display_size = { w = 71, h = 95 },
    cost = 5,
    rarity = 2, 
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',
    is_constellation = true, 
    
    check_for_unlock = function(self, args)
        if args.type == 'win' then
            -- Nivel 4 = Pozo Negro (Black Stake)
            if G.GAME.stake >= 4 then
                local has_sticker = false
                if G.jokers and G.jokers.cards then
                    for _, j in ipairs(G.jokers.cards) do
                        -- Lee todos los stickers conocidos en tu mod y base
                        if j.ability.eternal or j.ability.perishable or j.ability.rental or j.pinned or j.ability.cegado or j.ability.clover or j.ability.fat or j.ability.overweight or j.ability.massive then
                            has_sticker = true
                            break
                        end
                    end
                end
                if not has_sticker then return true end
            end
        end
        return false
    end,
    
    set_badges = function(self, card, badges)
        local badge_text = "Constellation"
        if G.localization and G.localization.misc and G.localization.misc.dictionary and G.localization.misc.dictionary.k_constellation then
            badge_text = G.localization.misc.dictionary.k_constellation
        else
            if G.SETTINGS.language == 'es_419' or G.SETTINGS.language == 'es_ES' then
                badge_text = "Constelación"
            end
        end
        badges[#badges + 1] = create_badge(badge_text, HEX('3D266B'), G.C.WHITE, 1.2)
    end,
    
    in_pool = function(self)
        return G.GAME and G.GAME.modifiers and G.GAME.modifiers.enable_eternals_in_shop
    end,

    loc_vars = function(self, info_queue, card)
        local clean_count = 0
        if G.jokers and G.jokers.cards then
            for _, j in ipairs(G.jokers.cards) do
                if not j.ability.eternal and not j.ability.perishable and not j.ability.rental and not j.pinned then
                    clean_count = clean_count + 1
                end
            end
        end
        local current_chips = clean_count * card.ability.extra.chips_per_clean
        return {vars = {card.ability.extra.chips_per_clean, current_chips}}
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local clean_count = 0
            if G.jokers and G.jokers.cards then
                for _, j in ipairs(G.jokers.cards) do
                    if not j.ability.eternal and not j.ability.perishable and not j.ability.rental and not j.pinned then
                        clean_count = clean_count + 1
                    end
                end
            end
            
            local final_chips = clean_count * card.ability.extra.chips_per_clean
            if final_chips > 0 then
                return {
                    message = "+" .. final_chips,
                    chip_mod = final_chips,
                    colour = G.C.CHIPS
                }
            end
        end
    end
}