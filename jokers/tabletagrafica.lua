SMODS.Joker {
    key = 'tabletagrafica',
    atlas = 'CustomJokers',
    pos = { x = 0, y = 0 }, -- Ajusta la posición de tu atlas
    rarity = 3,
    cost = 8,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },
    config = { extra = { added_slots = 0, threshold = 75, odds = 6 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.threshold, G.GAME.probabilities.normal, card.ability.extra.odds, card.ability.extra.added_slots } }
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

    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN and card.area == G.jokers then
            -- Previene errores matemáticos si el jugador tiene deudas (dinero negativo)
            local current_dollars = math.max(0, G.GAME.dollars or 0)
            local expected_slots = math.floor(current_dollars / card.ability.extra.threshold)
            
            if card.ability.extra.added_slots ~= expected_slots then
                local diff = expected_slots - card.ability.extra.added_slots
                if G.jokers and G.jokers.config then
                    G.jokers.config.card_limit = G.jokers.config.card_limit + diff
                end
                card.ability.extra.added_slots = expected_slots
            end
        end
    end,

    remove_from_deck = function(self, card, from_debuff)
        -- Restaura el límite si el comodín se vende o se destruye
        if card.ability.extra.added_slots > 0 then
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - card.ability.extra.added_slots)
            end
            card.ability.extra.added_slots = 0
        end
    end,

    calculate = function(self, card, context)
        if context.end_of_round and not context.blueprint and not context.individual and not context.repetition and context.main_eval then
            if pseudorandom('tabletagrafica') < G.GAME.probabilities.normal / card.ability.extra.odds then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('glass1')
                        card:start_dissolve({G.C.RED}, nil, 1.6)
                        return true
                    end
                }))
                return {
                    message = "¡Rota!",
                    colour = G.C.RED
                }
            end
        end
    end
}