SMODS.Joker{
    key = "castidad",
    config = { extra = { x_mult = 1, x_gain = 0.01 }, holy = true },
    pos = { x = 0, y = 0 },
    cost = 8,
    rarity = 3,
    blueprint_compat = true, -- Es compatible para dar el XMult, pero Blueprint no hará que escale doble
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
        return { vars = { card.ability.extra.x_gain, card.ability.extra.x_mult } }
    end,

    calculate = function(self, card, context)
        -- 1. Otorgar el XMult acumulado
        if context.joker_main then
            if card.ability.extra.x_mult > 1 then
                return {
                    message = "X" .. card.ability.extra.x_mult .. " Mult",
                    Xmult_mod = card.ability.extra.x_mult,
                    colour = G.C.MULT
                }
            end
        end

        -- 2. Escalar cuando puntúa una carta Pura
        if context.individual and context.cardarea == G.play and not context.blueprint then
            local is_pure = true
            local other = context.other_card
            
            -- Detectamos cualquier impureza
            if other.ability.effect and other.ability.effect ~= 'Base' then is_pure = false end
            if other.edition then is_pure = false end
            if other.seal then is_pure = false end
            
            if is_pure then
                card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_gain
                return {
                    extra = {message = "¡Pura!", colour = G.C.MULT},
                    card = card
                }
            end
        end
    end
}