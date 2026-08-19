local sug = SMODS.Mods["kranlaxs"].config.suggestive_sprites

-- ==============================================================================
-- PARCHE MÁGICO: ESCALAR STICKERS EN CARTAS HD
-- ==============================================================================
if not SMODS.kranlaxs_hd_sticker_hook then
    local orig_draw_shader = Sprite.draw_shader
    function Sprite.draw_shader(self, shader, _shadow_height, _send, _tilt, _sprite, ...)
        local using_override = false
        local temp_scale = 0
        
        -- Detectamos si el juego está dibujando un STICKER sobre nuestras cartas HD
        if _sprite and _sprite.atlas and self.atlas then
            if _sprite.atlas.name == 'sug_sheep' or _sprite.atlas.name == 'sug_panda' then
                temp_scale = _sprite.VT.scale
                
                -- Magia matemática: Multiplicamos la escala de la carta por la diferencia de resolución con el sticker.
                -- Si es un sticker vainilla (71px), crecerá a tamaño normal. 
                -- Si es tu sticker personalizado "Fat" (266px), la matemática dará 1 y se quedará del tamaño perfecto.
                _sprite.VT.scale = temp_scale * (_sprite.atlas.px / self.atlas.px)
                using_override = true
            end
        end

        orig_draw_shader(self, shader, _shadow_height, _send, _tilt, _sprite, ...)
        
        -- Restauramos la escala inmediatamente para que la oveja no se vuelva un titan de nuevo XD
        if using_override then
            _sprite.VT.scale = temp_scale
        end
    end
    SMODS.kranlaxs_hd_sticker_hook = true
end

-- ==============================================================================
-- CARTA: OVEJA DEVORADORA
-- ==============================================================================
SMODS.Joker{ 
    key = "devioussheep",
    config = { extra = { voremult = 1 } },
    pos = sug and {x=0, y=0} or { x = 2, y = 1 },
    
    -- ¡TAMAÑO RESTAURADO! Ya no tapará tu pantalla
    display_size = { w = 71, h = 95 },
    
    cost = 2,
    rarity = 3,
    blueprint_compat = false, 
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = sug and 'sug_sheep' or 'CustomJokers',
    
    in_pool = function(self, args)
        if not G.jokers or not G.jokers.cards then return true end
        for _, v in ipairs(G.jokers.cards) do
            if v.config.center.key == 'j_kranlaxs_' .. self.key then return false end
        end
        return true
    end,
    
    loc_vars = function(self, info_queue, card) return {vars = {card.ability.extra.voremult}} end,
    
    set_ability = function(self, card, initial)
        if initial and G.STAGE == G.STAGES.RUN then card:add_sticker('eternal', true) end
    end,
    
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            local edible_jokers = {}
            for _, j in ipairs(G.jokers.cards) do
                if j ~= card and not j.getting_sliced and not (j.ability and j.ability.pinned) and j.config.center.key ~= 'j_kranlaxs_devioussheep' and j.config.center.key ~= 'j_kranlaxs_sundaycheckpoint' and j.config.center.key ~= 'j_kranlaxs_weeklychallenge' then
                    table.insert(edible_jokers, j)
                end
            end
            
            -- Determinamos la cantidad de comida necesaria
            local target_count = card.ability.massive and 2 or 1
            
            -- EVENTO DE GAME OVER (Si no hay suficiente comida)
            if #edible_jokers < target_count then
                local first_msg = "meeeeh"
                local go_msgs = {}
                
                if sug then
                    if card.ability.massive then 
                        first_msg = "You know the deal~..."
                        go_msgs = {"too bad you haven't enough", "to keep feeding me~"}
                    elseif card.ability.overweight then 
                        first_msg = "a shame..."
                        go_msgs = {"BURP", "but it's over~..."}
                    else 
                        first_msg = "No food?..."
                        go_msgs = {"Too bad~"}
                    end
                end
                
                -- ENCOLADO MANUAL PARA ASEGURAR LOS DIÁLOGOS
                G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.5, func = function()
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = first_msg, colour = G.C.RED})
                    card:juice_up(0.3, 0.5)
                    return true
                end}))
                
                for _, text in ipairs(go_msgs) do
                    G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 1.0, func = function()
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = text, colour = G.C.DARK_EDITION})
                        card:juice_up(0.3, 0.5)
                        return true
                    end}))
                end
                
                G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 1.0, func = function()
                    if G.STAGE == G.STAGES.RUN then G.STATE = G.STATES.GAME_OVER; G.STATE_COMPLETE = false end
                    return true
                end}))
                
                return
            end
            
            -- FASE DE COMIDA
            local meals = {}
            local is_fat_or_more = card.ability.fat or card.ability.overweight or card.ability.massive
            
            for i = 1, target_count do
                local victim = nil
                local mult_gained = 0
                local dialogues = {}
                
                local priorities = {
                    {key = "j_kranlaxs_panda", mult = 4, msgs = {"GULP!", "BURP °.⋆•˚", "she tasted better than i expected~"}},
                    {key = "j_kranlaxs_charismaticbard", mult = 3, msgs = {"GULP!", "BURP °.⋆•˚", "sorry", "he looked tasty..."}}
                }
                
                if is_fat_or_more then
                    table.insert(priorities, {key = "j_kranlaxs_lateshippment", mult = 2, msgs = {"GULP!", "BURP °.⋆•˚", "someone tell to his job...", "that they'll need a new delivery guy~"}})
                    table.insert(priorities, {key = "j_kranlaxs_painterjoker", mult = 2, msgs = {"GULP!", "BURP °.⋆•˚", "i hope you got a great view~"}})
                    table.insert(priorities, {key = "j_kranlaxs_bunny", mult = 1, msgs = {"GULP!", "BURP °.⋆•˚", "meh...", "i expected a larger meal..."}})
                else
                    table.insert(priorities, {key = "j_kranlaxs_lateshippment", mult = 2, msgs = {"GULP!", "BURP °.⋆•˚", "Special delivery!"}})
                    table.insert(priorities, {key = "j_kranlaxs_painterjoker", mult = 2, msgs = {"GULP!", "BURP °.⋆•˚", "Colorful taste..."}})
                    table.insert(priorities, {key = "j_kranlaxs_bunny", mult = 1, msgs = {"GULP!", "BURP °.⋆•˚", "I expected a larger meal"}})
                end

                for _, p in ipairs(priorities) do
                    if not victim then
                        for idx, j in ipairs(edible_jokers) do
                            if j.config.center.key == p.key then 
                                victim = j; mult_gained = p.mult; dialogues = p.msgs
                                table.remove(edible_jokers, idx)
                                break 
                            end
                        end
                    end
                end

                local food_keys = { j_gros_michel=true, j_egg=true, j_ice_cream=true, j_cavendish=true, j_turtle_bean=true, j_diet_cola=true, j_popcorn=true, j_ramen=true, j_selzer=true, j_kranlaxs_birthdaycake=true, j_kranlaxs_colasoda=true, j_kranlaxs_icecreamsandwich=true, j_kranlaxs_bottledwater=true, j_kranlaxs_sushi=true, j_kranlaxs_grapesoda=true }
                if not victim then
                    for idx, j in ipairs(edible_jokers) do
                        if food_keys[j.config.center.key] then 
                            victim = j; mult_gained = 0.8
                            dialogues = is_fat_or_more and {"GULP!", "BURP °.⋆•˚", "good~"} or {"GULP!", "BURP °.⋆•˚", "Yummy food!"}
                            table.remove(edible_jokers, idx)
                            break 
                        end
                    end
                end

                if not victim then
                    local rarity_buckets = { [4] = {}, [3] = {}, [2] = {}, [1] = {} }
                    for idx, j in ipairs(edible_jokers) do
                        local r = j.config.center.rarity
                        if r == 'Legendary' or r == 4 then table.insert(rarity_buckets[4], {joker=j, index=idx})
                        elseif r == 3 then table.insert(rarity_buckets[3], {joker=j, index=idx})
                        elseif r == 2 then table.insert(rarity_buckets[2], {joker=j, index=idx})
                        else table.insert(rarity_buckets[1], {joker=j, index=idx}) end
                    end
                    
                    local chosen = nil
                    if #rarity_buckets[4] > 0 then chosen = pseudorandom_element(rarity_buckets[4], pseudoseed('sheep_leg')); mult_gained = 1.5; dialogues = {"GULP!", "BURP °.⋆•˚", "A legendary feast!!"}
                    elseif #rarity_buckets[3] > 0 then chosen = pseudorandom_element(rarity_buckets[3], pseudoseed('sheep_rar')); mult_gained = 1.0; dialogues = {"GULP!", "BURP °.⋆•˚", "Exquisite taste~"}
                    elseif #rarity_buckets[2] > 0 then chosen = pseudorandom_element(rarity_buckets[2], pseudoseed('sheep_unc')); mult_gained = 0.6; dialogues = {"GULP!", "BURP °.⋆•˚", "A decent meal."}
                    elseif #rarity_buckets[1] > 0 then chosen = pseudorandom_element(rarity_buckets[1], pseudoseed('sheep_com')); mult_gained = 0.3; dialogues = {"GULP!", "BURP °.⋆•˚", "Bland, but filling."}
                    end
                    
                    if chosen then
                        victim = chosen.joker
                        table.remove(edible_jokers, chosen.index)
                    end
                end

                if victim then
                    victim.getting_sliced = true
                    local final_dialogues = {}
                    if not sug then
                        final_dialogues = {"meeeeh"}
                    elseif card.ability.massive then
                        final_dialogues = {"more..."}
                    else
                        final_dialogues = dialogues
                    end
                    table.insert(meals, {victim = victim, mult = mult_gained, dialogues = final_dialogues})
                end
            end

            if #meals > 0 then
                for i, meal in ipairs(meals) do
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after', delay = 0.4,
                        func = function()
                            meal.victim:start_dissolve({G.C.RED}, nil, 1.6)
                            card.ability.extra.voremult = card.ability.extra.voremult + meal.mult
                            
                            if card.ability.extra.voremult >= 20 then
                                card.ability.fat = false; card.ability.overweight = false
                                if not card.ability.massive then card:add_sticker('massive', true) end
                            elseif card.ability.extra.voremult >= 10 then
                                card.ability.fat = false
                                if not card.ability.overweight and not card.ability.massive then card:add_sticker('overweight', true) end
                            elseif card.ability.extra.voremult >= 5 then
                                if not card.ability.fat and not card.ability.overweight and not card.ability.massive then card:add_sticker('fat', true) end
                            end
                            
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = sug and "Devoured!" or "meeeeh", colour = G.C.RED})
                            card:juice_up(0.3, 0.5)
                            return true
                        end
                    }))
                    
                    for _, msg in ipairs(meal.dialogues) do
                        G.E_MANAGER:add_event(Event({ 
                            trigger = 'after', delay = 0.8, 
                            func = function() 
                                card_eval_status_text(card, 'extra', nil, nil, nil, {message = msg, colour = G.C.RED}) 
                                card:juice_up(0.3, 0.5)
                                return true 
                            end 
                        }))
                    end
                end
                return
            end
        end
        
        -- PUNTUACIÓN
        if context.joker_main then
            if card.ability.extra.voremult > 1 then return { message = 'X' .. card.ability.extra.voremult, Xmult_mod = card.ability.extra.voremult, colour = G.C.MULT } end
        end
        
        -- EVENTO FIN DE RONDA
        if context.end_of_round and context.main_eval and not context.blueprint then
            local msgs = {"meeeeh"}
            
            if sug then
                if G.GAME.blind.boss then
                    if card.ability.massive then
                        msgs = pseudorandom_element({
                            {"thanks goodness..."},
                            {"be happy i'm in a good mood", "or you'd had ended already as a meal"},
                            {"just because you still being usefull..."}
                        }, pseudoseed('sheep_boss'))
                    elseif card.ability.overweight then
                        msgs = pseudorandom_element({
                            {"i f*cking hate to wait for you"}, 
                            {"i hope you give me a big meal in the next blind"}, 
                            {"my gut is killing me, it's heavy asf"}, 
                            {"are you done?... finally"}
                        }, pseudoseed('sheep_boss'))
                    elseif card.ability.fat then
                        msgs = pseudorandom_element({
                            {"It took you long enough..."}, 
                            {"finally...", "it ended..."}, 
                            {"i f*cking hate to wait for you"}, 
                            {"i hope you give me a big meal in the next blind"}
                        }, pseudoseed('sheep_boss'))
                    else
                        msgs = pseudorandom_element({
                            {"A large meal awaits..."}, 
                            {"Finally, a real challenge for my gut."}, 
                            {"Time to feast."}
                        }, pseudoseed('sheep_boss'))
                    end
                else
                    if card.ability.massive then
                        msgs = pseudorandom_element({
                            {"do i look fat?~"}, 
                            {"i don't fit in the sprite anymore~"}, 
                            {"i'm getting hungrier and hungrier..."}, 
                            {"suddenly", "i feel so much room in here~"}, 
                            {"keep going..."}
                        }, pseudoseed('sheep_norm'))
                    elseif card.ability.overweight then
                        msgs = pseudorandom_element({
                            {"i still have room for more~"}, 
                            {"am craving for more..."}, 
                            {"CAN YOU HURRY?..."}, 
                            {"i'm getting so damn fat~"}, 
                            {"Can you rush it?..."}, 
                            {"Keep going, you're going good~"}, 
                            {"Everyone here are so filling..."}
                        }, pseudoseed('sheep_norm'))
                    elseif card.ability.fat then
                        msgs = pseudorandom_element({
                            {"i'm getting so damn fat~"}, 
                            {"i still have room for more~"}, 
                            {"Keep going, you're going good~"}, 
                            {"Everyone here are so filling..."}
                        }, pseudoseed('sheep_norm'))
                    else
                        msgs = pseudorandom_element({
                            {"my gut is so damn empty...."}, 
                            {"am craving for more..."}, 
                            {"CAN YOU HURRY?..."}, 
                            {"am starving ughhh....."}, 
                            {"Can you rush it?..."}
                        }, pseudoseed('sheep_norm'))
                    end
                end
            end
            
            for _, text in ipairs(msgs) do
                G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 1.0, func = function()
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = text, colour = G.C.DARK_EDITION})
                    card:juice_up(0.3, 0.5)
                    return true
                end}))
            end
        end
    end
}