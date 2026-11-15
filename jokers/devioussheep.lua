local sug = SMODS.Mods["kranlaxs"].config.suggestive_sprites

local function loc(str)
    local lang = G.SETTINGS.language or 'en-us'
    local dict = {
        ["No food?..."] = {en="No food?...", es="¿Sin comida?...", pt="Sem comida?..."},
        ["Too bad~"] = {en="Too bad~", es="Qué mal~", pt="Que pena~"},
        ["You know the deal~..."] = {en="You know the deal~...", es="Ya sabes cómo es esto~...", pt="Você sabe como é~..."},
        ["too bad you haven't enough"] = {en="too bad you haven't enough", es="qué mal que no tienes suficiente", pt="que pena que não tem o bastante"},
        ["to keep feeding me~"] = {en="to keep feeding me~", es="para seguir alimentándome~", pt="para continuar me alimentando~"},
        ["a shame..."] = {en="a shame...", es="una lástima...", pt="uma pena..."},
        ["but it's over~..."] = {en="but it's over~...", es="pero se acabó~...", pt="mas acabou~..."},
        ["Satisfied... for now"] = {en="Satisfied... for now", es="Satisfecha... por ahora", pt="Satisfeita... por enquanto"},
        ["GULP!"] = {en="GULP!", es="¡GULP!", pt="GULP!"},
        ["BURP °.⋆•˚"] = {en="BURP °.⋆•˚", es="BURP °.⋆•˚", pt="BURP °.⋆•˚"},
        ["she tasted better than i expected~"] = {en="she tasted better than i expected~", es="sabía mejor de lo que esperaba~", pt="teve um gosto melhor do que eu esperava~"},
        ["sorry"] = {en="sorry", es="perdón", pt="desculpa"},
        ["he looked tasty..."] = {en="he looked tasty...", es="se veía sabroso...", pt="ele parecia saboroso..."},
        ["someone tell his job..."] = {en="someone tell his job...", es="que alguien avise a su trabajo...", pt="alguém avise no trabalho dele..."},
        ["that they'll need a new delivery guy~"] = {en="that they'll need a new delivery guy~", es="que necesitarán un nuevo repartidor~", pt="que vão precisar de um novo entregador~"},
        ["i hope you got a great view~"] = {en="i hope you got a great view~", es="espero que hayas tenido una gran vista~", pt="espero que tenha tido uma ótima visão~"},
        ["meh..."] = {en="meh...", es="meh...", pt="meh..."},
        ["i expected a larger meal..."] = {en="i expected a larger meal...", es="esperaba una comida más grande...", pt="esperava uma refeição maior..."},
        ["Special delivery!"] = {en="Special delivery!", es="¡Entrega especial!", pt="Entrega especial!"},
        ["Colorful taste..."] = {en="Colorful taste...", es="Sabor colorido...", pt="Sabor colorido..."},
        ["I expected a larger meal"] = {en="I expected a larger meal", es="Esperaba una comida más grande", pt="Esperava uma refeição maior"},
        ["good~"] = {en="good~", es="bien~", pt="bom~"},
        ["Yummy food!"] = {en="Yummy food!", es="¡Comida deliciosa!", pt="Comida gostosa!"},
        ["A zenith meal... amazing!!"] = {en="A zenith meal... amazing!!", es="Una comida cenit... ¡¡increíble!!", pt="Uma refeição zênite... incrível!!"},
        ["A legendary feast!!"] = {en="A legendary feast!!", es="¡Un banquete legendario!", pt="Um banquete lendário!"},
        ["Exquisite taste~"] = {en="Exquisite taste~", es="Gusto exquisito~", pt="Gosto requintado~"},
        ["A decent meal."] = {en="A decent meal.", es="Una comida decente.", pt="Uma refeição decente."},
        ["Bland, but filling."] = {en="Bland, but filling.", es="Soso, pero llena.", pt="Sem graça, mas enche."},
        ["Devoured!"] = {en="Devoured!", es="¡Devorado!", pt="Devorado!"},
        ["meeeeh"] = {en="meeeeh", es="meeeeh", pt="meeeeh"},
        ["more..."] = {en="more...", es="más...", pt="mais..."},
        ["thank goodness..."] = {en="thank goodness...", es="gracias a dios...", pt="graças a deus..."},
        ["be happy i'm in a good mood"] = {en="be happy i'm in a good mood", es="agradece que estoy de buen humor", pt="agradeça que estou de bom humor"},
        ["or you'd have ended up as a meal"] = {en="or you'd have ended up as a meal", es="o ya habrías terminado como comida", pt="ou já teria terminado como refeição"},
        ["just because you're still useful..."] = {en="just because you're still useful...", es="solo porque sigues siendo útil...", pt="só porque você ainda é útil..."},
        ["i f*cking hate to wait for you"] = {en="i f*cking hate to wait for you", es="odio jodidamente esperarte", pt="eu odeio pra caralho te esperar"},
        ["i hope you give me a big meal in the next blind"] = {en="i hope you give me a big meal in the next blind", es="espero que me des una gran comida en la próxima ciega", pt="espero que me dê uma grande refeição no próximo blind"},
        ["my gut is killing me, it's heavy asf"] = {en="my gut is killing me, it's heavy asf", es="mi panza me está matando, pesa demasiado", pt="minha barriga tá me matando, tá pesada demais"},
        ["are you done?... finally"] = {en="are you done?... finally", es="¿terminaste?... al fin", pt="terminou?... finalmente"},
        ["It took you long enough..."] = {en="It took you long enough...", es="Te tomaste tu tiempo...", pt="Você demorou bastante..."},
        ["finally..."] = {en="finally...", es="finalmente...", pt="finalmente..."},
        ["it ended..."] = {en="it ended...", es="se acabó...", pt="acabou..."},
        ["A large meal awaits..."] = {en="A large meal awaits...", es="Una gran comida aguarda...", pt="Uma grande refeição aguarda..."},
        ["Finally, a real challenge for my gut."] = {en="Finally, a real challenge for my gut.", es="Al fin, un verdadero reto para mi panza.", pt="Finalmente, um verdadeiro desafio pra minha barriga."},
        ["Time to feast."] = {en="Time to feast.", es="Hora del banquete.", pt="Hora do banquete."},
        ["do i look fat?~"] = {en="do i look fat?~", es="¿me veo gorda?~", pt="eu pareço gorda?~"},
        ["i don't fit in the sprite anymore~"] = {en="i don't fit in the sprite anymore~", es="ya no quepo en el sprite~", pt="já não caibo mais no sprite~"},
        ["i'm getting hungrier and hungrier..."] = {en="i'm getting hungrier and hungrier...", es="cada vez tengo más y más hambre...", pt="cada vez estou com mais fome..."},
        ["suddenly"] = {en="suddenly", es="de repente", pt="de repente"},
        ["i feel so much room in here~"] = {en="i feel so much room in here~", es="siento mucho espacio aquí adentro~", pt="sinto muito espaço aqui dentro~"},
        ["keep going..."] = {en="keep going...", es="sigue...", pt="continue..."},
        ["i still have room for more~"] = {en="i still have room for more~", es="aún tengo espacio para más~", pt="ainda tenho espaço pra mais~"},
        ["am craving for more..."] = {en="am craving for more...", es="ansío más...", pt="anseio por mais..."},
        ["CAN YOU HURRY?..."] = {en="CAN YOU HURRY?...", es="¿PUEDES APRESURARTE?...", pt="PODE SE APRESSAR?..."},
        ["i'm getting so damn fat~"] = {en="i'm getting so damn fat~", es="me estoy poniendo tan jodidamente gorda~", pt="estou ficando tão gorda~"},
        ["Can you rush it?..."] = {en="Can you rush it?...", es="¿Puedes apresurarte?...", pt="Pode se apressar?..."},
        ["Keep going, you're doing good~"] = {en="Keep going, you're doing good~", es="Sigue, vas bien~", pt="Continue, você vai bem~"},
        ["Everyone here is so filling..."] = {en="Everyone here is so filling...", es="Todos aquí llenan tanto...", pt="Todos aqui enchem tanto..."},
        ["my gut is so damn empty...."] = {en="my gut is so damn empty....", es="mi panza está tan jodidamente vacía...", pt="minha barriga tá tão vazia..."},
        ["am starving ughhh....."] = {en="am starving ughhh.....", es="muero de hambre ughhh...", pt="morrendo de fome ughhh..."},
        ["BURP"] = {en="BURP", es="BURP", pt="BURP"}
    }
    if lang == 'es_419' or lang == 'es_ES' then return dict[str] and dict[str].es or str end
    if lang == 'pt_BR' then return dict[str] and dict[str].pt or str end
    return dict[str] and dict[str].en or str
end

SMODS.Joker{ 
    key = "devioussheep",
    config = { extra = { voremult = 1 } },
    pos = sug and {x=0, y=0} or { x = 2, y = 1 },
    display_size = { w = 71, h = 95 },
    cost = 2,
    rarity = 3,
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = sug and 'sug_sheep' or 'CustomJokers',
    
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
            
            local target_count = card.ability.massive and 2 or 1
            
            if #edible_jokers < target_count then
                local first_msg = loc("meeeeh")
                local go_msgs = {}
                
                if sug then
                    if card.ability.massive then 
                        first_msg = loc("You know the deal~...")
                        go_msgs = {loc("too bad you haven't enough"), loc("to keep feeding me~")}
                    elseif card.ability.overweight then 
                        first_msg = loc("a shame...")
                        go_msgs = {loc("BURP"), loc("but it's over~...")}
                    else 
                        first_msg = loc("No food?...")
                        go_msgs = {loc("Too bad~")}
                    end
                end
                
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
                    local saved = false
                    if G.jokers and G.jokers.cards then
                        for _, jkr in ipairs(G.jokers.cards) do
                            if jkr.config.center.key == 'j_kranlaxs_lifeassurance' and not jkr.debuff then
                                if G.GAME.dollars >= jkr.ability.extra.seguro then
                                    local cost = jkr.ability.extra.seguro
                                    jkr.ability.extra.seguro = jkr.ability.extra.seguro * 2
                                    ease_dollars(-cost)
                                    card_eval_status_text(jkr, 'extra', nil, nil, nil, {message = "-$" .. tostring(cost), colour = G.C.MONEY})
                                    jkr:juice_up()
                                    saved = true
                                    break
                                end
                            end
                        end
                    end

                    if saved then
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = loc("Satisfied... for now"), colour = G.C.GREEN})
                    else
                        if G.STAGE == G.STAGES.RUN then G.STATE = G.STATES.GAME_OVER; G.STATE_COMPLETE = false end
                    end
                    return true
                end}))
                
                return
            end
            
            local meals = {}
            local is_fat_or_more = card.ability.fat or card.ability.overweight or card.ability.massive
            
            for i = 1, target_count do
                local victim = nil
                local mult_gained = 0
                local dialogues = {}
                
                local priorities = {
                    {key = "j_kranlaxs_panda", mult = 4, msgs = {loc("GULP!"), loc("BURP °.⋆•˚"), loc("she tasted better than i expected~")}},
                    {key = "j_kranlaxs_charismaticbard", mult = 3, msgs = {loc("GULP!"), loc("BURP °.⋆•˚"), loc("sorry"), loc("he looked tasty...")}}
                }
                
                if is_fat_or_more then
                    table.insert(priorities, {key = "j_kranlaxs_lateshippment", mult = 2, msgs = {loc("GULP!"), loc("BURP °.⋆•˚"), loc("someone tell his job..."), loc("that they'll need a new delivery guy~")}})
                    table.insert(priorities, {key = "j_kranlaxs_painterjoker", mult = 2, msgs = {loc("GULP!"), loc("BURP °.⋆•˚"), loc("i hope you got a great view~")}})
                    table.insert(priorities, {key = "j_kranlaxs_bunny", mult = 1, msgs = {loc("GULP!"), loc("BURP °.⋆•˚"), loc("meh..."), loc("i expected a larger meal...")}})
                else
                    table.insert(priorities, {key = "j_kranlaxs_lateshippment", mult = 2, msgs = {loc("GULP!"), loc("BURP °.⋆•˚"), loc("Special delivery!")}})
                    table.insert(priorities, {key = "j_kranlaxs_painterjoker", mult = 2, msgs = {loc("GULP!"), loc("BURP °.⋆•˚"), loc("Colorful taste...")}})
                    table.insert(priorities, {key = "j_kranlaxs_bunny", mult = 1, msgs = {loc("GULP!"), loc("BURP °.⋆•˚"), loc("I expected a larger meal")}})
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
                            dialogues = is_fat_or_more and {loc("GULP!"), loc("BURP °.⋆•˚"), loc("good~")} or {loc("GULP!"), loc("BURP °.⋆•˚"), loc("Yummy food!")}
                            table.remove(edible_jokers, idx)
                            break 
                        end
                    end
                end

                if not victim then
                    local rarity_buckets = { [5] = {}, [4] = {}, [3] = {}, [2] = {}, [1] = {} }
                    for idx, j in ipairs(edible_jokers) do
                        local r = j.config.center.rarity
                        
                        -- Se añaden todos los posibles identificadores Zenith a la máxima prioridad
                        if r == 'kranlaxs_zenith' or r == 'zenith' or (type(r) == 'table' and (r.key == 'kranlaxs_zenith' or r.key == 'zenith')) or (type(r) == 'number' and SMODS.Rarities['kranlaxs_zenith'] and r == SMODS.Rarities['kranlaxs_zenith'].id) or (type(r) == 'number' and SMODS.Rarities['zenith'] and r == SMODS.Rarities['zenith'].id) then
                            table.insert(rarity_buckets[5], {joker=j, index=idx})
                        elseif r == 'Legendary' or r == 4 then 
                            table.insert(rarity_buckets[4], {joker=j, index=idx})
                        elseif r == 3 then 
                            table.insert(rarity_buckets[3], {joker=j, index=idx})
                        elseif r == 2 then 
                            table.insert(rarity_buckets[2], {joker=j, index=idx})
                        else 
                            table.insert(rarity_buckets[1], {joker=j, index=idx}) 
                        end
                    end
                    
                    local chosen = nil
                    if #rarity_buckets[5] > 0 then chosen = pseudorandom_element(rarity_buckets[5], pseudoseed('sheep_zen')); mult_gained = 3.0; dialogues = {loc("GULP!"), loc("BURP °.⋆•˚"), loc("A zenith meal... amazing!!")}
                    elseif #rarity_buckets[4] > 0 then chosen = pseudorandom_element(rarity_buckets[4], pseudoseed('sheep_leg')); mult_gained = 1.5; dialogues = {loc("GULP!"), loc("BURP °.⋆•˚"), loc("A legendary feast!!")}
                    elseif #rarity_buckets[3] > 0 then chosen = pseudorandom_element(rarity_buckets[3], pseudoseed('sheep_rar')); mult_gained = 1.0; dialogues = {loc("GULP!"), loc("BURP °.⋆•˚"), loc("Exquisite taste~")}
                    elseif #rarity_buckets[2] > 0 then chosen = pseudorandom_element(rarity_buckets[2], pseudoseed('sheep_unc')); mult_gained = 0.6; dialogues = {loc("GULP!"), loc("BURP °.⋆•˚"), loc("A decent meal.")}
                    elseif #rarity_buckets[1] > 0 then chosen = pseudorandom_element(rarity_buckets[1], pseudoseed('sheep_com')); mult_gained = 0.3; dialogues = {loc("GULP!"), loc("BURP °.⋆•˚"), loc("Bland, but filling.")}
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
                        final_dialogues = {loc("meeeeh")}
                    elseif card.ability.massive then
                        final_dialogues = {loc("more...")}
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
                            
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = sug and loc("Devoured!") or loc("meeeeh"), colour = G.C.RED})
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
        
        if context.joker_main then
            if card.ability.extra.voremult > 1 then return { message = 'X' .. card.ability.extra.voremult, Xmult_mod = card.ability.extra.voremult, colour = G.C.MULT } end
        end
        
        if context.end_of_round and context.main_eval and not context.blueprint then
            local msgs = {loc("meeeeh")}
            
            if sug then
                if G.GAME.blind.boss then
                    if card.ability.massive then
                        msgs = pseudorandom_element({
                            {loc("thank goodness...")},
                            {loc("be happy i'm in a good mood"), loc("or you'd have ended up as a meal")},
                            {loc("just because you're still useful...")}
                        }, pseudoseed('sheep_boss'))
                    elseif card.ability.overweight then
                        msgs = pseudorandom_element({
                            {loc("i f*cking hate to wait for you")}, 
                            {loc("i hope you give me a big meal in the next blind")}, 
                            {loc("my gut is killing me, it's heavy asf")}, 
                            {loc("are you done?... finally")}
                        }, pseudoseed('sheep_boss'))
                    elseif card.ability.fat then
                        msgs = pseudorandom_element({
                            {loc("It took you long enough...")}, 
                            {loc("finally..."), loc("it ended...")}, 
                            {loc("i f*cking hate to wait for you")}, 
                            {loc("i hope you give me a big meal in the next blind")}
                        }, pseudoseed('sheep_boss'))
                    else
                        msgs = pseudorandom_element({
                            {loc("A large meal awaits...")}, 
                            {loc("Finally, a real challenge for my gut.")}, 
                            {loc("Time to feast.")}
                        }, pseudoseed('sheep_boss'))
                    end
                else
                    if card.ability.massive then
                        msgs = pseudorandom_element({
                            {loc("do i look fat?~")}, 
                            {loc("i don't fit in the sprite anymore~")}, 
                            {loc("i'm getting hungrier and hungrier...")}, 
                            {loc("suddenly"), loc("i feel so much room in here~")}, 
                            {loc("keep going...")}
                        }, pseudoseed('sheep_norm'))
                    elseif card.ability.overweight then
                        msgs = pseudorandom_element({
                            {loc("i still have room for more~")}, 
                            {loc("am craving for more...")}, 
                            {loc("CAN YOU HURRY?...?")}, 
                            {loc("i'm getting so damn fat~")}, 
                            {loc("Can you rush it?...?")}, 
                            {loc("Keep going, you're doing good~")}, 
                            {loc("Everyone here is so filling...")}
                        }, pseudoseed('sheep_norm'))
                    elseif card.ability.fat then
                        msgs = pseudorandom_element({
                            {loc("i'm getting so damn fat~")}, 
                            {loc("i still have room for more~")}, 
                            {loc("Keep going, you're doing good~")}, 
                            {loc("Everyone here is so filling...")}
                        }, pseudoseed('sheep_norm'))
                    else
                        msgs = pseudorandom_element({
                            {loc("my gut is so damn empty....")}, 
                            {loc("am craving for more...")}, 
                            {loc("CAN YOU HURRY?...?")}, 
                            {loc("am starving ughhh.....")}, 
                            {loc("Can you rush it?...?")}
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