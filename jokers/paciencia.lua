SMODS.Joker{
    key = "paciencia",
    config = { extra = { x_chips = 1, x_gain = 0.25 }, holy = true },
    pos = { x = 0, y = 0 },
    cost = 6,
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
        return { vars = { card.ability.extra.x_gain, card.ability.extra.x_chips } }
    end,

    calculate = function(self, card, context)
        -- 1. Otorgar bono
        if context.joker_main then
            if card.ability.extra.x_chips > 1 then
                return {
                    message = "X" .. card.ability.extra.x_chips .. " Fichas",
                    x_chips = card.ability.extra.x_chips,
                    Xchips = card.ability.extra.x_chips,
                    colour = G.C.CHIPS,
                    sound = 'kranlaxs_multiplicativechips' -- Aquí aplica tu sonido especial
                }
            end
        end

        -- 2. Escalar al saltar ciega
        if context.skip_blind and not context.blueprint then
            card.ability.extra.x_chips = card.ability.extra.x_chips + card.ability.extra.x_gain
            return {
                message = "¡Paciencia!",
                colour = G.C.CHIPS
            }
        end

        -- 3. Reiniciar si caes en la tentación (Consumibles)
        if context.using_consumeable and not context.blueprint then
            if card.ability.extra.x_chips > 1 then
                card.ability.extra.x_chips = 1
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card:juice_up(0.5, 0.5)
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = "¡Reinicio!", colour = G.C.RED})
                        return true
                    end
                }))
            end
        end
    end
}