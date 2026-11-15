SMODS.Joker{
    key = "caridad",
    config = { extra = { cost = 5, cards = 5, x_gain = 0.1 }, holy = true },
    pos = { x = 0, y = 0 },
    cost = 8,
    rarity = 3,
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
        return { vars = { card.ability.extra.cost, card.ability.extra.x_gain, card.ability.extra.cards } }
    end,

    calculate = function(self, card, context)
        if context.end_of_round and not context.repetition and not context.individual then
            -- Extracción segura de dinero
            local dollars = 0
            if G.GAME and G.GAME.dollars then
                local d = G.GAME.dollars
                if type(d) == 'cdata' or type(d) == 'userdata' then dollars = tonumber(d) or 0
                elseif type(d) == 'table' then dollars = (d.to_number and d:to_number()) or (d.toNumber and d:toNumber()) or tonumber(d) or 0
                else dollars = tonumber(d) or 0 end
            end

            -- Solo aplica si tienes MÁS de 5$
            if dollars > card.ability.extra.cost then
                ease_dollars(-card.ability.extra.cost)
                
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local deck = G.deck.cards
                        if #deck > 0 then
                            -- Clonamos la lista de la baraja para no elegir la misma carta dos veces
                            local temp_deck = {}
                            for _, c in ipairs(deck) do table.insert(temp_deck, c) end
                            
                            for i = 1, card.ability.extra.cards do
                                if #temp_deck > 0 then
                                    local idx = pseudorandom('caridad_buff', 1, #temp_deck)
                                    local target = temp_deck[idx]
                                    table.remove(temp_deck, idx)
                                    
                                    -- Aumento permanente
                                    target.ability.x_mult = (target.ability.x_mult or 1) + card.ability.extra.x_gain
                                    target:juice_up(0.5, 0.5)
                                end
                            end
                            play_sound('tarot1')
                        end
                        return true
                    end
                }))
                
                return {
                    message = "¡Caridad!",
                    colour = G.C.MONEY
                }
            end
        end
    end
}