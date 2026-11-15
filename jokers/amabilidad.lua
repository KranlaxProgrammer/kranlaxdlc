SMODS.Joker{
    key = "amabilidad",
    config = { extra = { highest_val = 0 }, holy = true },
    pos = { x = 0, y = 0 },
    cost = 6,
    rarity = 2,
    blueprint_compat = false,
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
        return { vars = {} }
    end,

    calculate = function(self, card, context)
        -- 1. Truco de Inyección: Forzar que las cartas bajas entren a la tabla de puntuación
        if context.before and not context.blueprint then
            local highest_nominal = 0
            for _, c in ipairs(context.full_hand) do
                if c.base.nominal > highest_nominal then
                    highest_nominal = c.base.nominal
                end
            end
            card.ability.extra.highest_val = highest_nominal

            -- Forzamos a que las cartas pequeñas (2 al 6) siempre se unan a la fiesta
            for _, c in ipairs(context.full_hand) do
                if c.base.nominal >= 2 and c.base.nominal <= 6 then
                    local in_scoring = false
                    for _, sc in ipairs(context.scoring_hand) do
                        if c == sc then in_scoring = true; break end
                    end
                    -- Si la carta fue ignorada por la mano de póker, la forzamos a entrar
                    if not in_scoring then
                        table.insert(context.scoring_hand, c)
                    end
                end
            end
        end
        
        -- 2. El pago: Dar doble valor a todas las cartas bajas puntuadas
        if context.individual and context.cardarea == G.play and not context.blueprint then
            local nominal = context.other_card.base.nominal
            if nominal >= 2 and nominal <= 6 then
                return {
                    chips = card.ability.extra.highest_val * 2,
                    card = context.other_card,
                    message = "Amabilidad"
                }
            end
        end
    end
}