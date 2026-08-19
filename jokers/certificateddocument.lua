SMODS.Joker{
    key = "certificateddocument",
    config = { extra = {} },
    pos = { x = 9, y = 5 },
    display_size = { w = 71, h = 95 },
    cost = 6,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    
    unlocked = false, -- ¡Cambiado a false para activar el candado!
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    -- Función que atrapa la victoria en Pozo Morado
    check_for_unlock = function(self, args)
        if args and args.type == 'win' then
            -- Verificamos Pozo Morado (stake == 6) y la baraja Reto Semanal
            if G.GAME and G.GAME.stake == 6 and G.GAME.selected_back and G.GAME.selected_back.effect.center.key == 'b_kranlaxs_week_challenge' then
                return true
            end
        end
        return false
    end,

    in_pool = function(self, args)
        if not G.jokers or not G.jokers.cards then return true end
        for _, v in ipairs(G.jokers.cards) do
            if v.config.center.key == 'j_kranlaxs_' .. self.key then
                return false 
            end
        end
        return true
    end,
    
    calculate = function(self, card, context)
        if context.repetition then
            if context.other_card and context.other_card.seal then
                return {
                    message = localize('k_again_ex'),
                    repetitions = 1,
                    card = card
                }
            end
        end

        if context.discard and not context.blueprint then
            if context.other_card and context.other_card.seal == 'Purple' then
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        func = (function()
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    local tarot = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'purp_seal')
                                    tarot:add_to_deck()
                                    G.consumeables:emplace(tarot)
                                    G.GAME.consumeable_buffer = 0
                                    return true
                                end}))
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Extra Tarot!", colour = G.C.PURPLE})
                            return true
                        end)
                    }))
                end
            end
        end
    end
}