SMODS.Consumable {
    key = 'uranium',
    set = 'Quartz',
    pos = { x = 17, y = 0 }, -- <-- Ajusta a tu Atlas
    cost = 8,
    unlocked = false, -- ¡Cambiado a false para que inicie bloqueado!
    discovered = false,
    unlock_condition = {type = '', extra = ''},
    atlas = 'QuartzConsumables',
    config = { extra = { current_effect = 1, used_this_round = false } },
    
    loc_vars = function(self, info_queue, card)
        -- Magia oscura: Generador de texto basura (¡Hemos quitado la "¡" para evitar el crasheo de UTF-8!)
        local chars = "~!@#$%^&*()_+{}[]|:;<>?/ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
        local glitch = ""
        for i = 1, 28 do
            local r = math.random(1, #chars)
            glitch = glitch .. chars:sub(r, r)
        end
        return {vars = {glitch}}
    end,
    
    can_use = function(self, card)
        return false -- Es pasivo
    end,

    set_ability = function(self, card, initial)
        -- Candado de seguridad para que no crashee al verse en la colección
        if card.ability and card.ability.extra then
            card.ability.extra.current_effect = math.random(1, 19)
            card.ability.extra.used_this_round = false
        end
    end,
    
    calculate = function(self, card, context)
        -- 1) Al inicio de cada ciega, seleccionamos su ÚNICO efecto para toda esa ronda
        if context.setting_blind and not context.blueprint then
            card.ability.extra.current_effect = math.random(1, 19)
            card.ability.extra.used_this_round = false
        end

        local ef = card.ability.extra.current_effect

        -- 2) EFECTOS DE PUNTUACIÓN (1 al 4) -> Ocurren en la primera mano que juegues
        if context.joker_main and not context.blueprint and not card.ability.extra.used_this_round then
            if ef >= 1 and ef <= 4 then
                card.ability.extra.used_this_round = true
                card:juice_up(0.5, 0.5)

                if ef == 1 then
                    local val = math.random() * 1.99 + 1.01
                    return { message = "X"..string.format("%.2f", val).." Mult", Xmult_mod = val, colour = G.C.MULT }
                elseif ef == 2 then
                    local val = math.random() * 0.99 + 1.01
                    return { message = "X"..string.format("%.2f", val).." Fichas", Xchip_mod = val, colour = G.C.CHIPS }
                elseif ef == 3 then
                    local val = math.random(0, 100)
                    return { message = "+"..val.." Mult", mult_mod = val, colour = G.C.MULT }
                elseif ef == 4 then
                    local val = math.random(0, 500)
                    return { message = "+"..val.." Fichas", chip_mod = val, colour = G.C.CHIPS }
                end
            end
        end

        -- 3) EFECTOS MACRO (5 al 19) -> Ocurren exactamente al finalizar la ronda (después de la victoria)
        if context.end_of_round and context.main_eval and not context.blueprint then
            if ef >= 5 and ef <= 19 then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after', delay = 0.5,
                    func = function()
                        card:juice_up(0.8, 0.8)
                        
                        if ef == 5 then
                            local mult = math.random() * 1.0 + 1.0
                            local gain = math.floor(G.GAME.dollars * mult) - G.GAME.dollars
                            if gain > 0 then
                                ease_dollars(gain)
                                card_eval_status_text(card, 'extra', nil, nil, nil, {message = "+$"..gain, colour = G.C.MONEY})
                            end
                        elseif ef == 6 then
                            local count = math.random(1, 3)
                            for i=1, count do
                                if #G.playing_cards > 0 then
                                    local c = G.playing_cards[math.random(#G.playing_cards)]
                                    local suit_map = {Spades = 'S', Hearts = 'H', Diamonds = 'D', Clubs = 'C'}
                                    local r_map = {[2]='2',[3]='3',[4]='4',[5]='5',[6]='6',[7]='7',[8]='8',[9]='9',[10]='T',[11]='J',[12]='Q',[13]='K',[14]='A'}
                                    local new_rank = math.max(2, c.base.id - 1)
                                    local sk = suit_map[c.base.suit] or 'S'
                                    local rk = r_map[new_rank] or '2'
                                    c:set_base(G.P_CARDS[sk..'_'..rk])
                                    c:juice_up()
                                end
                            end
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Cartas Degradadas!", colour = G.C.RED})
                        elseif ef == 7 then
                            if G.jokers.cards and #G.jokers.cards > 0 then
                                local j = G.jokers.cards[math.random(#G.jokers.cards)]
                                local copy = copy_card(j, nil, nil, nil, j.edition and j.edition.key)
                                copy:add_to_deck()
                                G.jokers:emplace(copy)
                                card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Joker Copiado!", colour = G.C.BLUE})
                            end
                        elseif ef == 8 then
                            if G.consumeables.cards and #G.consumeables.cards > 0 then
                                local c = G.consumeables.cards[math.random(#G.consumeables.cards)]
                                local copy = copy_card(c, nil, nil, nil, c.edition and c.edition.key)
                                copy:add_to_deck()
                                G.consumeables:emplace(copy)
                                card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Consumible Copiado!", colour = G.C.PURPLE})
                            end
                        elseif ef == 9 then
                            local centers = {}
                            for _, v in pairs(G.P_CENTERS) do if v.set == 'Enhanced' then table.insert(centers, v) end end
                            for i=1, 5 do
                                if #G.playing_cards > 0 then
                                    local c = G.playing_cards[math.random(#G.playing_cards)]
                                    c:set_ability(centers[math.random(#centers)])
                                    c:juice_up()
                                end
                            end
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Mejoras Mágicas!", colour = G.C.ORANGE})
                        elseif ef == 10 then
                            local tags = {}
                            for k, v in pairs(G.P_TAGS) do table.insert(tags, k) end
                            add_tag(Tag(tags[math.random(#tags)]))
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Etiqueta Aleatoria!", colour = G.C.DARK_EDITION})
                        elseif ef == 11 then
                            local types = {'Tarot', 'Planet', 'Spectral'}
                            if SMODS.ConsumableTypes then
                                for k, _ in pairs(SMODS.ConsumableTypes) do table.insert(types, k) end
                            end
                            local new_cons = create_card(types[math.random(#types)], G.consumeables, nil, nil, nil, nil, nil, 'uranio')
                            new_cons:add_to_deck()
                            G.consumeables:emplace(new_cons)
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Consumible Creado!", colour = G.C.GREEN})
                        elseif ef == 12 then
                            local amt = math.random(1, 4)
                            for _, c in ipairs(G.playing_cards) do c.ability.perma_bonus = (c.ability.perma_bonus or 0) + amt end
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Fichas Permanentes!", colour = G.C.CHIPS})
                        elseif ef == 13 then
                            local amt = math.random(1, 3)
                            for _, c in ipairs(G.playing_cards) do c.ability.perma_mult = (c.ability.perma_mult or 0) + amt end
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Mult Permanente!", colour = G.C.MULT})
                        elseif ef == 14 then
                            local amt = math.random(1, 6)
                            for _, c in ipairs(G.playing_cards) do c.ability.perma_bonus = (c.ability.perma_bonus or 0) - amt end
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Fichas Perdidas...", colour = G.C.RED})
                        elseif ef == 15 then
                            local amt = math.random(1, 8)
                            for _, c in ipairs(G.playing_cards) do c.ability.perma_mult = (c.ability.perma_mult or 0) - amt end
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Mult Perdido...", colour = G.C.RED})
                        elseif ef == 16 then
                            local amt = math.random(1, 3)
                            for i=1, amt do
                                if #G.playing_cards > 0 then
                                    local c = G.playing_cards[math.random(#G.playing_cards)]
                                    c:start_dissolve()
                                end
                            end
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Destrucción de Mazo!", colour = G.C.BLACK})
                        elseif ef == 17 then
                            local hands = {}
                            for k, v in pairs(G.GAME.hands) do table.insert(hands, k) end
                            local hand = hands[math.random(#hands)]
                            level_up_hand(card, hand, true, -1)
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Mano Degradada!", colour = G.C.RED})
                        elseif ef == 18 then
                            error("URANIUM MELTDOWN: CRASH FORZADO POR EL CUARZO URANIO")
                        elseif ef == 19 then
                            if G.jokers.cards and #G.jokers.cards > 0 then
                                local j = G.jokers.cards[math.random(#G.jokers.cards)]
                                if j.ability.eternal then
                                    j:set_ability(G.P_CENTERS.j_misprint)
                                    card_eval_status_text(j, 'extra', nil, nil, nil, {message = "Corrupto!", colour = G.C.DARK_EDITION})
                                else
                                    j:start_dissolve()
                                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Joker Eliminado!", colour = G.C.RED})
                                end
                            end
                        end
                        
                        return true
                    end
                }))
            end
        end
    end,

    -- Función nativa para gestionar el desbloqueo
    check_for_unlock = function(self, args)
        if args.type == 'win' then
            -- Comprueba que la baraja sea la Errática ('b_erratic') y el pozo sea tu Pozo de Platino
            if G.GAME.selected_back.effect.center.key == 'b_erratic' and G.GAME.stake == 'kranlaxs_platinum' then
                return true -- ¡Desbloqueado!
            end
        end
        return false
    end
}