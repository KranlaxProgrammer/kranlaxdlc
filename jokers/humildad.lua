SMODS.Joker{
    key = "humildad",
    config = { extra = { x_mult = 3 }, holy = true },
    pos = { x = 0, y = 0 }, 
    cost = 5,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    set_badges = function(self, card, badges)
        local badge_text = (G.SETTINGS.language == 'es_419' or G.SETTINGS.language == 'es_ES') and "Sagrada" or "Holy"
        badges[#badges + 1] = create_badge(badge_text, HEX('FFD700'), G.C.WHITE, 1.2)
    end,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local is_humble = true
            if G.jokers and G.jokers.cards then
                for _, j in ipairs(G.jokers.cards) do
                    if j ~= card then
                        local r = j.config.center.rarity
                        if type(r) == 'table' then r = r.key or r.id end
                        -- Si algún comodín NO es Común (1) ni Inusual (2), perdemos la humildad
                        if r ~= 1 and r ~= 2 and r ~= 'Common' and r ~= 'Uncommon' and r ~= 'kranlaxs_common' and r ~= 'kranlaxs_uncommon' then
                            is_humble = false
                            break
                        end
                    end
                end
            end
            
            if is_humble then
                return {
                    message = "X" .. card.ability.extra.x_mult .. " Mult",
                    Xmult_mod = card.ability.extra.x_mult,
                    colour = G.C.MULT
                }
            end
        end
    end
}