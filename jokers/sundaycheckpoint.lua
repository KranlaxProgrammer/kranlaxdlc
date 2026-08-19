SMODS.Joker{
    key = "sundaycheckpoint",
    config = { extra = {} },
    pos = { x = 5, y = 1 },
    display_size = { w = 71, h = 95 },
    cost = 0,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    no_collection = true,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlax_challenge"] = true },
    
    in_pool = function(self, args)
        if not args then return true end
        return false
    end,

    loc_vars = function(self, info_queue, card)
        local d = os.date("*t").wday
        local free_play = SMODS.Mods["kranlaxs"].config.free_weekly_deck
        
        -- Si el modo libre está activo, fingimos visualmente que es Domingo en la descripción
        local day_name = (free_play or d == 1) and "Sunday" or (d == 7 and "Saturday") or "Weekday"
        return {vars = {day_name}}
    end,
    
    set_ability = function(self, card, initial)
        card:set_eternal(true)
    end,
    
    calculate = function(self, card, context)
        -- Preguntamos si el jugador encendió la opción de jugar libremente
        local free_play = SMODS.Mods["kranlaxs"].config.free_weekly_deck
        local is_weekend = free_play or (os.date("*t").wday == 1 or os.date("*t").wday == 7)

        -- Todo sucede exactamente al entrar a la ciega
        if context.setting_blind and not context.blueprint then
            
            if is_weekend then
                -- CONDICIÓN CUMPLIDA: Nos transformamos en la recompensa y desaparecemos
                G.E_MANAGER:add_event(Event({
                    func = function()
                        if #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
                            G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                            
                            local joker_card = SMODS.add_card({ set = 'Joker', key = 'j_kranlaxs_weeklychallenge' })
                            if joker_card then
                                joker_card:set_edition("e_negative", true)
                                joker_card:add_sticker('eternal', true)
                            end
                            
                            G.GAME.joker_buffer = 0
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_plus_joker'), colour = G.C.BLUE})
                        end
                        
                        card.getting_sliced = true
                        card:start_dissolve({G.C.RED}, nil, 1.6)
                        return true
                    end
                }))
            else
                -- CONDICIÓN FALLIDA: Matamos la partida
                G.E_MANAGER:add_event(Event({
                    delay = 1.0,
                    func = function()
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Not weekend!", colour = G.C.RED})
                        if G.STAGE == G.STAGES.RUN then 
                            G.STATE = G.STATES.GAME_OVER
                            G.STATE_COMPLETE = false
                        end
                        return true
                    end
                }))
            end
            
        end
    end
}