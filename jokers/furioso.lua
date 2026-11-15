SMODS.Joker{
    key = "furioso",
    config = { extra = { x_mult = 5 } },
    pos = { x = 0, y = 0 }, -- Cambia las coordenadas según tu atlas
    cost = 20,
    bm_cost = 7,
    rarity = "kranlaxs_zenith",
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult } }
    end,

    calculate = function(self, card, context)
        -- 1. Aplicar X5 a la primera carta de la mano (Compatible con Copias)
        if context.individual and context.cardarea == G.play then
            if context.other_card == context.scoring_hand[1] then
                return {
                    x_mult = card.ability.extra.x_mult,
                    card = context.other_card
                }
            end
        end
        
        -- 2. Destruir la primera carta al final del cálculo (No compatible con Copias)
        if context.destroying_card and not context.blueprint then
            if context.destroying_card == context.scoring_hand[1] then
                return true -- Le dice al motor que desintegre esta carta
            end
        end
    end
}