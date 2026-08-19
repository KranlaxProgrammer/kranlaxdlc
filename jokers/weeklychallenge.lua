SMODS.Joker{
    key = "weeklychallenge",
    config = {
        extra = {
            challenge = 0,
            TotHands = 50,
            TotDisc = 50
        }
    },
    pos = { x = 6, y = 1 },
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
    pools = { ["kranlaxs_kranlaxs_weekcha"] = true },

    -- ¡EL CANDADO MAESTRO!
    in_pool = function(self, args)
        -- Permitimos que la carta exista en el menú de Colección (cuando args es nil)
        if not args then return true end
        
        -- Bloqueamos absolutamente cualquier intento del juego de generarla al azar
        -- (Tiendas, sobres, tags, tarots, comodines que crean comodines, etc.)
        return false
    end,

    loc_vars = function(self, info_queue, card)
        local current_ch = card.ability.extra.challenge == 0 and "?" or tostring(card.ability.extra.challenge)
        return {vars = {current_ch, card.ability.extra.TotHands, card.ability.extra.TotDisc}}
    end,

    set_ability = function(self, card, initial)
        card:set_eternal(true)
        card:set_edition("e_negative", true)
    end,

    calculate = function(self, card, context)
        if context.setting_blind and card.ability.extra.challenge == 0 and not context.blueprint then
            local ch = pseudorandom('weekly_challenge', 1, 7)
            card.ability.extra.challenge = ch
            
            if ch == 1 then
                ease_dollars(-100)
            elseif ch == 2 then
                G.GAME.banned_keys['v_overstock_norm'] = true
                G.GAME.banned_keys['v_overstock_plus'] = true
            elseif ch == 3 then
                G.GAME.banned_keys['v_grabber'] = true
                G.GAME.banned_keys['v_nacho_tong'] = true
            elseif ch == 6 then
                G.GAME.banned_keys['v_antimatter'] = true
                G.jokers.config.card_limit = 3
                for i = 1, 3 do
                    local j = SMODS.add_card({set = 'Joker', key = 'j_triboulet'})
                    if j then j:add_sticker('eternal', true) end
                end
            end
            
            G.E_MANAGER:add_event(Event({
                func = function()
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Challenge #" .. ch .. "!"})
                    return true
                end
            }))
        end

        local ch = card.ability.extra.challenge

        if context.setting_blind and not context.blueprint then
            if ch == 3 then 
                G.GAME.current_round.hands_left = 1
                G.GAME.current_round.discards_left = 20 
            elseif ch == 4 then 
                G.GAME.current_round.hands_left = card.ability.extra.TotHands
                G.GAME.current_round.discards_left = card.ability.extra.TotDisc
            end
        end

        if context.starting_shop and ch == 2 and not context.blueprint then
            if G.GAME.shop then
                G.GAME.shop.joker_max = 1
            end
        end

        if context.end_of_round and context.main_eval and not context.blueprint then
            if ch == 4 then
                card.ability.extra.TotHands = G.GAME.current_round.hands_left
                card.ability.extra.TotDisc = G.GAME.current_round.discards_left
            end

            local lost = false
            
            if ch == 1 and G.GAME.round_resets.ante >= 8 and G.GAME.dollars < 0 then 
                lost = true 
            end
            
            if ch == 7 and G.GAME.round_resets.ante >= 8 then 
                lost = true 
            end
            
            if lost then 
                G.E_MANAGER:add_event(Event({ func = function() G.STATE = G.STATES.GAME_OVER; G.STATE_COMPLETE = false; return true end }))
            elseif ch == 7 then
                if pseudorandom('win_run_chance') < 0.166666 then
                    G.E_MANAGER:add_event(Event({ 
                        func = function() 
                            G.STATE = G.STATES.VICTORY
                            G.STATE_COMPLETE = false
                            return true 
                        end 
                    }))
                end
            end

            if ch == 6 and G.GAME.blind.boss then
                if G.GAME.round_resets.ante < 8 then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            ease_ante(1)
                            G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante + 1
                            return true
                        end
                    }))
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Ante +1!", colour = G.C.RED})
                end
            end
        end

        if ch == 5 then 
            G.SETTINGS.GAMESPEED = 0.5 
        end
    end
}