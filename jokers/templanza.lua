SMODS.Joker{
    key = "templanza",
    config = { extra = { dollars_per_match = 10, matched_this_round = 0 }, holy = true },
    pos = { x = 0, y = 0 },
    cost = 4,
    rarity = 1,
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
        return { vars = { card.ability.extra.dollars_per_match, card.ability.extra.matched_this_round * card.ability.extra.dollars_per_match } }
    end,

    -- Función nativa que Balatro llama al final de la ronda para dar dinero extra
    calc_dollar_bonus = function(self, card)
        local payout = card.ability.extra.matched_this_round * card.ability.extra.dollars_per_match
        if payout > 0 then return payout end
        return 0
    end,

    calculate = function(self, card, context)
        -- Reiniciamos el contador de la ronda al entrar a una nueva ciega
        if context.setting_blind and not context.blueprint then
            card.ability.extra.matched_this_round = 0
        end

        if context.joker_main and not context.blueprint then
            -- Algoritmo para encontrar el Nivel de tu mano más jugada
            local max_played = -1
            local max_level = 1
            for k, v in pairs(G.GAME.hands) do
                if v.played > max_played then
                    max_played = v.played
                    max_level = v.level
                elseif v.played == max_played and v.level > max_level then
                    max_level = v.level
                end
            end
            
            -- Si el nivel de la mano actual empata con ese nivel máximo
            local current_hand_level = G.GAME.hands[context.scoring_name].level
            if current_hand_level == max_level then
                card.ability.extra.matched_this_round = card.ability.extra.matched_this_round + 1
                return {
                    message = "¡Equilibrio!",
                    colour = G.C.MONEY
                }
            end
        end
    end
}