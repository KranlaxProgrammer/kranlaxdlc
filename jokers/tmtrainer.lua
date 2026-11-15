SMODS.Joker{
    key = "tmtrainer",
    config = { extra = { conds = {}, effs = {}, stats = { m = 0, xm = 1, pm = 1, c = 0, xc = 1, pc = 1, dec = 0 }, gains = { m = 0, xm = 0, c = 0, xc = 0 }, sprite_x = 0, is_scaling = false, has_death = false } },
    pos = { x = 0, y = 0 },
    display_size = { w = 71, h = 95 },
    cost = 8,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    unlocked = false,
    discovered = false,
    unlock_condition = {type = '', extra = ''},
    atlas = 'corruptedjoker',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    check_for_unlock = function(self, args)
        if G.PROFILES and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].challenge_progress and G.PROFILES[G.SETTINGS.profile].challenge_progress.completed then
            if G.PROFILES[G.SETTINGS.profile].challenge_progress.completed.c_kranlaxs_reto_doppelganger then 
                return true 
            end
        end
        return false
    end,

    in_pool = function(self, args)
        return pseudorandom('tm_pool') < 0.05
    end,

    set_sprites = function(self, card, front)
        if not card.config.center.discovered or not card.config.center.unlocked then return end
        if card.ability and card.ability.extra and type(card.ability.extra.sprite_x) == 'number' then
            if card.children.center then
                card.children.center:set_sprite_pos({x = card.ability.extra.sprite_x, y = 0})
            end
        end
    end,

    set_ability = function(self, card, initial, delay_sprites)
        if initial then
            local unique_str = 'tmtrainer' .. tostring(card.T.x) .. tostring(card.T.y)
            card.ability.extra.sprite_x = math.floor(pseudorandom(pseudoseed(unique_str)) * 22)
            
            if card.config.center.discovered and card.config.center.unlocked then
                if card.children.center then
                    card.children.center:set_sprite_pos({x = card.ability.extra.sprite_x, y = 0})
                end
            end
            
            if card.children.center then
                card.children.center:set_sprite_pos({x = card.ability.extra.sprite_x, y = 0})
            end

            if pseudorandom('tm_edition') < 0.15 and not card.edition then
                local eds = {'foil', 'holo', 'polychrome', 'negative'}
                card:set_edition({[(pseudorandom_element(eds, pseudoseed('tm_ed')))] = true}, true)
            end

            local c_pool = {
                'discard', 'buy', 'sell', 'skip', 'boss', 'reroll', 'level_up', 'booster',
                'even_minute', 'play_card', 'destroy_card', 'score_card', 'blind_select',
                'round_end', 'first_hand', 'last_hand', 'use_consumable',
                'play_spade', 'play_heart', 'play_diamond', 'play_club', 'no_pair', 'only_numbers', 
                'has_stone', 'not_most_played', 'exactly_one_heart', 'has_straight', 'has_flush',
                'play_prime', 'sell_joker', 'buy_voucher', 'play_wild', 'have_negative_money',
                'play_five_of_a_kind', 'last_discard', 'skip_booster',
                'first_card_scored', 'play_zero_discards', 'play_enhanced', 'defeat_boss', 'retrigger'
            }

            local e_pool = {
                'scale_m', 'scale_c', 'scale_xm', 'scale_xc',
                't_enh', 'r_enh', 't_seal', 'r_seal', 't_ed', 'r_ed',
                'add_deck', 'dest_deck', 'time_var', 'rarity_count', 'copy_cons',
                'dis_boss', 'on_sell_fx', 'sp_tag', 'sp_cons', 'sp_jok', 'size_up', 'size_down',
                'swap_mc', 'bal_mc', 'dec_dest', 'smear', 'merge', 'flip', 'unflip', 'copy_play',
                'crash', 'sp_uno', 'sp_quartz', 'dr_money', 'gv_money', 'ls_money', 'add_hand', 
                'add_disc', 'sub_hand', 'sub_disc', 'lvl_rand', 'retrig', 'remove_stickers', 'mult_per_card_in_hand', 
                'add_red_seal_to_kings', 'add_glass_on_blind', 'extra_consumable_slot',
                'gain_joker_slot', 'lose_joker_slot', 'force_boss', 'add_perishable', 'add_rental', 'lvl_down',
                'consume_joker', 'random_enhance_played', 'add_random_edition_played', 'spawn_food',
                'absorb_sell', 'clone_played', 'add_seal_hand', 'lose_run_chance', 'evolve_joker', 'gain_token',
                'add_perma_xmult', 'lvl_up_played', 'spawn_spectral', 'double_chips', 'destroy_unscored', 'give_money_per_card_in_hand'
            }

            local num_c = math.floor(pseudorandom(pseudoseed('tm_num_c')) * 3)
            for i = 1, num_c do table.insert(card.ability.extra.conds, (pseudorandom_element(c_pool, pseudoseed('tm_c_el'..i)))) end

            local r = pseudorandom(pseudoseed('tm_num_e')) * 100
            local num_e = 2
            if r > 98 then num_e = 8 elseif r > 94 then num_e = 7 elseif r > 85 then num_e = 5 elseif r > 65 then num_e = 4 elseif r > 40 then num_e = 3 end
            
            for i = 1, num_e do table.insert(card.ability.extra.effs, (pseudorandom_element(e_pool, pseudoseed('tm_e_el'..i)))) end
            
            for _, e in ipairs(card.ability.extra.effs) do
                if e == 'scale_m' then
                    card.ability.extra.gains.m = (pseudorandom(pseudoseed('tm_sm')) < 0.25 and -1 or 1) * math.floor(pseudorandom(pseudoseed('tm_sm2')) * 15 + 5)
                    card.ability.extra.is_scaling = true
                elseif e == 'scale_c' then
                    card.ability.extra.gains.c = (pseudorandom(pseudoseed('tm_sc')) < 0.25 and -1 or 1) * math.floor(pseudorandom(pseudoseed('tm_sc2')) * 40 + 10)
                    card.ability.extra.is_scaling = true
                elseif e == 'scale_xm' then
                    card.ability.extra.gains.xm = (pseudorandom(pseudoseed('tm_sxm')) < 0.25 and -0.1 or 0.25)
                    card.ability.extra.is_scaling = true
                elseif e == 'scale_xc' then
                    card.ability.extra.gains.xc = (pseudorandom(pseudoseed('tm_sxc')) < 0.25 and -0.1 or 0.25)
                    card.ability.extra.is_scaling = true
                elseif e == 'lose_run_chance' or e == 'crash' then
                    card.ability.extra.has_death = true
                end
            end
            
            card.ability.extra.stats.dec = math.floor(pseudorandom(pseudoseed('tm_dec')) * 45) + 15
        end
    end, -- ¡AQUÍ ESTÁ LA COMITA DE LA SALVACIÓN!

    loc_vars = function(self, info_queue, card)
        local seed = card.T.x + card.T.y + (card.ability.extra.stats.m or 0)
        local is_es = (G.SETTINGS.language == 'es_419' or G.SETTINGS.language == 'es_ES')
        
        local function gl(len, salt)
            local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@#$%&*!?<>~[]{}+-"
            local res = ""
            for i = 1, len do 
                local idx = math.floor(pseudorandom(pseudoseed('tm_gl'..salt..seed..i)) * #chars) + 1
                res = res .. chars:sub(idx, idx) 
            end
            return res
        end
        
        local function corrupt_text(str)
            local res = ""
            local glchars = "!@#$%&*?+-"
            for i = 1, #str do
                local c = str:sub(i, i)
                local l = c:lower()
                local rng = pseudorandom(pseudoseed('tm_cr'..i..seed))
                if rng < 0.25 then
                    if l == "a" then c = (pseudorandom(pseudoseed('tm_cra'..i..seed))<0.5) and "4" or "@"
                    elseif l == "e" then c = "3"
                    elseif l == "i" then c = "1"
                    elseif l == "o" then c = "0"
                    elseif l == "s" then c = "$"
                    elseif l == "t" then c = "7"
                    end
                elseif rng < 0.35 then c = c:upper()
                elseif rng < 0.38 then
                    local rand_char = math.floor(pseudorandom(pseudoseed('tm_crg'..i..seed)) * #glchars) + 1
                    c = glchars:sub(rand_char, rand_char)
                end
                res = res .. c
            end
            return res
        end

        local c_dict = {
            discard = is_es and "Descartar" or "Discard",
            buy = is_es and "Comprar" or "Buy",
            sell = is_es and "Vender" or "Sell",
            skip = is_es and "Saltar ciega" or "Skip blind",
            boss = is_es and "Ciega Jefe" or "Boss Blind",
            reroll = is_es and "Renovar" or "Reroll",
            level_up = is_es and "Subir nivel" or "Level up",
            booster = is_es and "Paquete" or "Booster",
            even_minute = is_es and "Min Par" or "Even Min",
            play_card = is_es and "Jugar mano" or "Play hand",
            destroy_card = is_es and "Destruir" or "Destroy",
            score_card = is_es and "Puntuar" or "Score",
            blind_select = is_es and "Elegir ciega" or "Select blind",
            round_end = is_es and "Fin ronda" or "Round end",
            first_hand = is_es and "1ra mano" or "1st hand",
            last_hand = is_es and "Ult mano" or "Last hand",
            use_consumable = is_es and "Consumible" or "Consumable",
            play_spade = is_es and "Picas" or "Spades",
            play_heart = is_es and "Corazones" or "Hearts",
            play_diamond = is_es and "Diamantes" or "Diamonds",
            play_club = is_es and "Treboles" or "Clubs",
            no_pair = is_es and "Sin Par" or "No Pair",
            only_numbers = is_es and "Numeros" or "Numbers",
            has_stone = is_es and "Piedra" or "Stone",
            not_most_played = is_es and "No favorita" or "Not fav",
            exactly_one_heart = is_es and "1 Corazon" or "1 Heart",
            has_straight = is_es and "Escalera" or "Straight",
            has_flush = is_es and "Color" or "Flush",
            play_prime = is_es and "Jugar Primo" or "Play Prime",
            sell_joker = is_es and "Vender Comodin" or "Sell Joker",
            buy_voucher = is_es and "Comprar Vale" or "Buy Voucher",
            play_wild = is_es and "Carta Versatil" or "Wild Card",
            have_negative_money = is_es and "En Deuda" or "In Debt",
            play_five_of_a_kind = is_es and "Quintilla" or "5 of a Kind",
            last_discard = is_es and "Ultimo Descarte" or "Last Discard",
            skip_booster = is_es and "Omitir Paquete" or "Skip Booster",
            first_card_scored = is_es and "1ra Carta" or "1st Card",
            play_zero_discards = is_es and "0 Descartes" or "0 Discards",
            play_enhanced = is_es and "Carta Mejorada" or "Enhanced Card",
            defeat_boss = is_es and "Vencer Jefe" or "Defeat Boss",
            retrigger = is_es and "Reactivar" or "Retrigger"
        }
        
        local cond_str_clear = ""
        for i, c in ipairs(card.ability.extra.conds) do
            cond_str_clear = cond_str_clear .. (c_dict[c] or c) .. (i < #card.ability.extra.conds and " & " or "")
        end
        if #card.ability.extra.conds == 0 then cond_str_clear = is_es and "Azar" or "Random" end

        local cond_str = (is_es and "Condicion: " or "Condition: ") .. cond_str_clear

        local display_lines = {}
        
        if card.ability.extra.is_scaling then
            if card.ability.extra.gains.m ~= 0 then table.insert(display_lines, (is_es and "Acumulado: " or "Stored: ") .. card.ability.extra.stats.m .. " Mult (" .. (card.ability.extra.gains.m > 0 and "+" or "") .. card.ability.extra.gains.m .. ")") end
            if card.ability.extra.gains.c ~= 0 then table.insert(display_lines, (is_es and "Acumulado: " or "Stored: ") .. card.ability.extra.stats.c .. " Fichas (" .. (card.ability.extra.gains.c > 0 and "+" or "") .. card.ability.extra.gains.c .. ")") end
            if card.ability.extra.gains.xm ~= 0 then table.insert(display_lines, (is_es and "Acumulado: X" or "Stored: X") .. string.format("%.2f", card.ability.extra.stats.xm) .. " Mult (" .. (card.ability.extra.gains.xm > 0 and "+" or "") .. card.ability.extra.gains.xm .. ")") end
            if card.ability.extra.gains.xc ~= 0 then table.insert(display_lines, (is_es and "Acumulado: X" or "Stored: X") .. string.format("%.2f", card.ability.extra.stats.xc) .. " Fichas (" .. (card.ability.extra.gains.xc > 0 and "+" or "") .. card.ability.extra.gains.xc .. ")") end
        end
        
        if card.ability.extra.has_death then
            table.insert(display_lines, (is_es and "¡MUERTE si: " or "DEATH if: ") .. cond_str_clear .. "!")
        end
        
        local final_lines = {}
        for i = 1, 3 do
            if display_lines[i] then final_lines[i] = display_lines[i]
            else final_lines[i] = gl(math.floor(pseudorandom(pseudoseed('ln'..i..seed))*8)+5, tostring(i)) end
        end
        
        return {vars = {final_lines[1], final_lines[2], final_lines[3], corrupt_text(cond_str)}}
    end,

    calculate = function(self, card, context)
        local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@#$%&*!?<>~[]{}+-"
        local function gl(len)
            local res = ""
            for i = 1, len do 
                local idx = math.floor(pseudorandom(pseudoseed('tm_cg'..G.TIMERS.REAL..i)) * #chars) + 1
                res = res .. chars:sub(idx, idx) 
            end
            return res
        end

        local trg = false
        local cnds = card.ability.extra.conds
        local efs = card.ability.extra.effs
        local sts = card.ability.extra.stats
        local gns = card.ability.extra.gains

        if #cnds == 0 then
            if context.joker_main or (context.end_of_round and context.main_eval) then trg = true end
        else
            for _, c in ipairs(cnds) do
                if c == 'discard' and context.pre_discard and not context.blueprint then trg = true end
                if c == 'buy' and context.buying_card and not context.blueprint then trg = true end
                if c == 'sell' and context.selling_card and not context.blueprint then trg = true end
                if c == 'skip' and context.skip_blind and not context.blueprint then trg = true end
                if c == 'boss' and context.setting_blind and G.GAME.blind and G.GAME.blind.boss and not context.blueprint then trg = true end
                if c == 'reroll' and context.reroll_shop and not context.blueprint then trg = true end
                if c == 'level_up' and context.level_up and not context.blueprint then trg = true end
                if c == 'booster' and context.open_booster and not context.blueprint then trg = true end
                if c == 'even_minute' and context.joker_main and os.date("*t").min % 2 == 0 then trg = true end
                if c == 'play_card' and context.joker_main then trg = true end
                if c == 'destroy_card' and context.remove_playing_cards and not context.blueprint then trg = true end
                if c == 'score_card' and context.individual and context.cardarea == G.play then trg = true end
                if c == 'blind_select' and context.setting_blind and not context.blueprint then trg = true end
                if c == 'round_end' and context.end_of_round and context.main_eval and not context.blueprint then trg = true end
                if c == 'first_hand' and context.joker_main and G.GAME.current_round.hands_played == 0 then trg = true end
                if c == 'last_hand' and context.joker_main and G.GAME.current_round.hands_left == 0 then trg = true end
                if c == 'use_consumable' and context.using_consumeable and not context.blueprint then trg = true end
                if c == 'play_spade' and context.individual and context.cardarea == G.play and context.other_card:is_suit('Spades') then trg = true end
                if c == 'play_heart' and context.individual and context.cardarea == G.play and context.other_card:is_suit('Hearts') then trg = true end
                if c == 'play_diamond' and context.individual and context.cardarea == G.play and context.other_card:is_suit('Diamonds') then trg = true end
                if c == 'play_club' and context.individual and context.cardarea == G.play and context.other_card:is_suit('Clubs') then trg = true end
                if c == 'no_pair' and context.joker_main and next(context.poker_hands['Pair']) == nil then trg = true end
                if c == 'only_numbers' and context.joker_main then 
                    local only_num = true
                    for _, v in ipairs(context.full_hand) do if v:is_face() then only_num = false end end
                    if only_num then trg = true end 
                end
                if c == 'has_stone' and context.joker_main then 
                    for _, v in ipairs(context.full_hand) do if v.config.center.key == 'm_stone' then trg = true end end
                end
                if c == 'not_most_played' and context.joker_main and G.GAME.current_round.current_hand.handname ~= G.GAME.current_round.most_played_poker_hand then trg = true end
                if c == 'exactly_one_heart' and context.joker_main then 
                    local heart_count = 0
                    for _, v in ipairs(context.full_hand) do if v:is_suit('Hearts') then heart_count = heart_count + 1 end end
                    if heart_count == 1 then trg = true end
                end
                if c == 'has_straight' and context.joker_main and next(context.poker_hands['Straight']) then trg = true end
                if c == 'has_flush' and context.joker_main and next(context.poker_hands['Flush']) then trg = true end
                if c == 'play_prime' and context.individual and context.cardarea == G.play then
                    local id = context.other_card:get_id()
                    if id == 2 or id == 3 or id == 5 or id == 7 or id == 14 then trg = true end
                end
                if c == 'sell_joker' and context.selling_card and context.card.ability.set == 'Joker' and not context.blueprint then trg = true end
                if c == 'buy_voucher' and context.buying_card and context.card.ability.set == 'Voucher' and not context.blueprint then trg = true end
                if c == 'play_wild' and context.individual and context.cardarea == G.play and (context.other_card.ability.name == 'Wild Card' or context.other_card.config.center.key == 'm_wild') then trg = true end
                if c == 'have_negative_money' and G.GAME.dollars < 0 then trg = true end
                if c == 'play_five_of_a_kind' and context.joker_main and (context.scoring_name == 'Five of a Kind' or context.scoring_name == 'Flush Five') then trg = true end
                if c == 'last_discard' and context.pre_discard and G.GAME.current_round.discards_left == 0 then trg = true end
                if c == 'skip_booster' and context.skip_booster and not context.blueprint then trg = true end
                if c == 'first_card_scored' and context.individual and context.cardarea == G.play and context.scoring_hand and context.other_card == context.scoring_hand[1] then trg = true end
                if c == 'play_zero_discards' and context.joker_main and G.GAME.current_round.discards_left == 0 then trg = true end
                if c == 'play_enhanced' and context.individual and context.cardarea == G.play and context.other_card.config.center.effect ~= 'Base' then trg = true end
                if c == 'defeat_boss' and context.end_of_round and context.main_eval and G.GAME.blind and G.GAME.blind.boss and not context.blueprint then trg = true end
                if c == 'retrigger' and context.repetition and context.cardarea == G.play then trg = true end
            end
        end

        local txt = {}

        if context.selling_self and not context.blueprint then
            for _, e in ipairs(efs) do
                if e == 'on_sell_fx' then
                    if #G.jokers.cards < G.jokers.config.card_limit then
                        local c = create_card('Joker', G.jokers, nil, nil, nil, nil, nil, 'tmtrainer')
                        c:set_edition({negative = true}, true); c:add_to_deck(); G.jokers:emplace(c)
                    end
                end
            end
        end

        if trg then
            local get_seed = function(salt) return pseudoseed('tm_eff'..salt..(G.GAME.round or 0)) end
            for _, e in ipairs(efs) do
                if e == 'scale_m' then sts.m = sts.m + gns.m; table.insert(txt, (gns.m >= 0 and "+" or "") .. gns.m .. " Mult") end
                if e == 'scale_c' then sts.c = sts.c + gns.c; table.insert(txt, (gns.c >= 0 and "+" or "") .. gns.c .. " Chips") end
                if e == 'scale_xm' then sts.xm = math.max(0.01, sts.xm + gns.xm); table.insert(txt, (gns.xm >= 0 and "+" or "") .. gns.xm .. " XMult") end
                if e == 'scale_xc' then sts.xc = math.max(0.01, sts.xc + gns.xc); table.insert(txt, (gns.xc >= 0 and "+" or "") .. gns.xc .. " XChips") end

                if e == 't_enh' and G.hand and #G.hand.cards > 0 then G.hand.cards[math.floor(pseudorandom(get_seed('e1'))*#G.hand.cards)+1]:set_ability(G.P_CENTERS[(pseudorandom_element({'m_stone','m_gold','m_glass','m_steel','m_lucky','m_wild','m_mult','m_bonus'}, get_seed('e1a')))], nil, true); table.insert(txt, gl(4)) end
                if e == 'r_enh' and G.hand and #G.hand.cards > 0 then G.hand.cards[math.floor(pseudorandom(get_seed('e2'))*#G.hand.cards)+1]:set_ability(G.P_CENTERS.c_base, nil, true); table.insert(txt, gl(4)) end
                if e == 't_seal' and G.hand and #G.hand.cards > 0 then G.hand.cards[math.floor(pseudorandom(get_seed('e3'))*#G.hand.cards)+1]:set_seal((pseudorandom_element({'Red','Blue','Gold','Purple'}, get_seed('e3a'))), true, true); table.insert(txt, gl(4)) end
                if e == 'r_seal' and G.hand and #G.hand.cards > 0 then G.hand.cards[math.floor(pseudorandom(get_seed('e4'))*#G.hand.cards)+1]:set_seal(nil, true, true); table.insert(txt, gl(4)) end
                if e == 't_ed' and G.hand and #G.hand.cards > 0 then G.hand.cards[math.floor(pseudorandom(get_seed('e5'))*#G.hand.cards)+1]:set_edition({[(pseudorandom_element({'foil','holo','polychrome','negative'}, get_seed('e5a')))] = true}, true, true); table.insert(txt, gl(4)) end
                if e == 'r_ed' and G.hand and #G.hand.cards > 0 then G.hand.cards[math.floor(pseudorandom(get_seed('e6'))*#G.hand.cards)+1]:set_edition(nil, true, true); table.insert(txt, gl(4)) end
                if e == 'add_deck' and G.hand and #G.hand.cards > 0 then local cp = copy_card(G.hand.cards[math.floor(pseudorandom(get_seed('e9'))*#G.hand.cards)+1], nil, nil, G.playing_card); cp:add_to_deck(); table.insert(G.playing_cards, cp); G.deck.config.card_limit = G.deck.config.card_limit + 1; table.insert(txt, gl(4)) end
                if e == 'dest_deck' and G.hand and #G.hand.cards > 0 then G.hand.cards[math.floor(pseudorandom(get_seed('e10'))*#G.hand.cards)+1]:start_dissolve({G.C.RED}); table.insert(txt, gl(4)) end
                if e == 'copy_cons' and G.consumeables and #G.consumeables.cards > 0 and #G.consumeables.cards < G.consumeables.config.card_limit then local cp = copy_card(G.consumeables.cards[math.floor(pseudorandom(get_seed('e11'))*#G.consumeables.cards)+1]); cp:add_to_deck(); G.consumeables:emplace(cp); table.insert(txt, gl(4)) end
                if e == 'dis_boss' and G.GAME.blind and G.GAME.blind.boss then G.GAME.blind:disable(); table.insert(txt, gl(4)) end
                if e == 'sp_tag' then add_tag(Tag((pseudorandom_element(G.P_TAGS, get_seed('e12'))).key)); table.insert(txt, gl(4)) end
                if e == 'sp_cons' and #G.consumeables.cards < G.consumeables.config.card_limit then local c = create_card((pseudorandom_element({'Tarot','Planet','Spectral'}, get_seed('e13'))), G.consumeables, nil, nil, nil, nil, nil, 'tm'); c:add_to_deck(); G.consumeables:emplace(c); table.insert(txt, gl(4)) end
                if e == 'sp_jok' and #G.jokers.cards < G.jokers.config.card_limit then local c = create_card('Joker', G.jokers, nil, nil, nil, nil, nil, 'tm'); c:add_to_deck(); G.jokers:emplace(c); table.insert(txt, gl(4)) end
                if e == 'size_up' and G.GAME.blind then G.GAME.blind.chips = math.floor(G.GAME.blind.chips * 1.5); G.GAME.blind.chip_text = number_format(G.GAME.blind.chips); if G.HUD_blind then G.HUD_blind:recalculate() end; table.insert(txt, gl(4)) end
                if e == 'size_down' and G.GAME.blind then G.GAME.blind.chips = math.max(1, math.floor(G.GAME.blind.chips * 0.8)); G.GAME.blind.chip_text = number_format(G.GAME.blind.chips); if G.HUD_blind then G.HUD_blind:recalculate() end; table.insert(txt, gl(4)) end
                if e == 'dec_dest' then sts.dec = sts.dec - 1; if sts.dec <= 0 then card:start_dissolve({G.C.RED}) end; table.insert(txt, gl(4)) end
                if e == 'merge' and G.hand and #G.hand.cards > 0 then local tgt = G.hand.cards[math.floor(pseudorandom(get_seed('e14'))*#G.hand.cards)+1]; local suits = {'Spades','Hearts','Clubs','Diamonds'}; tgt:change_suit(suits[math.floor(pseudorandom(get_seed('e15'))*4)+1]); table.insert(txt, gl(4)) end
                if e == 'flip' and G.hand and #G.hand.cards > 0 then for _, c in ipairs(G.hand.cards) do c.facing = 'back'; c.sprite_facing = 'back'; c:flip() end; table.insert(txt, gl(4)) end
                if e == 'unflip' and G.hand and #G.hand.cards > 0 then for _, c in ipairs(G.hand.cards) do c.facing = 'front'; c.sprite_facing = 'front'; c:flip() end; table.insert(txt, gl(4)) end
                if e == 'crash' and pseudorandom(get_seed('e16')) < 0.01 then G.STATE = G.STATES.GAME_OVER; G.STATE_COMPLETE = false end
                if e == 'sp_uno' and #G.consumeables.cards < G.consumeables.config.card_limit then local ks = {"c_kranlaxs_skip", "c_kranlaxs_stacking", "c_kranlaxs_draw2", "c_kranlaxs_draw4", "c_kranlaxs_reverse", "c_kranlaxs_wildcard", "c_kranlaxs_replay", "c_kranlaxs_discardall", "c_kranlaxs_shield", "c_kranlaxs_misery", "c_kranlaxs_gift", "c_kranlaxs_customdraw"}; local c = create_card('UNOCards', G.consumeables, nil, nil, nil, nil, ks[math.floor(pseudorandom(get_seed('e17'))*#ks)+1], 'tm'); c:add_to_deck(); G.consumeables:emplace(c); table.insert(txt, gl(4)) end
                if e == 'sp_quartz' and #G.consumeables.cards < G.consumeables.config.card_limit then local ks = {"c_kranlaxs_blackquartz", "c_kranlaxs_whitequartz", "c_kranlaxs_pinkquartz", "c_kranlaxs_bluequartz", "c_kranlaxs_lilacquartz", "c_kranlaxs_grayquartz", "c_kranlaxs_transparentquartz", "c_kranlaxs_redquartz", "c_kranlaxs_celestequartz", "c_kranlaxs_yellowquartz", "c_kranlaxs_greenquartz", "c_kranlaxs_brownquartz", "c_kranlaxs_turquoisequartz", "c_kranlaxs_orangequartz", "c_kranlaxs_lapislazuli", "c_kranlaxs_cinnabar", "c_kranlaxs_graphite", "c_kranlaxs_uranium"}; local c = create_card('Quartz', G.consumeables, nil, nil, nil, nil, ks[math.floor(pseudorandom(get_seed('e18'))*#ks)+1], 'tm'); c:add_to_deck(); G.consumeables:emplace(c); table.insert(txt, gl(4)) end
                if e == 'dr_money' then ease_dollars(-G.GAME.dollars); table.insert(txt, gl(4)) end
                if e == 'gv_money' then ease_dollars(math.floor(pseudorandom(get_seed('e19'))*12)+3); table.insert(txt, gl(4)) end
                if e == 'ls_money' then ease_dollars(-(math.floor(pseudorandom(get_seed('e20'))*8)+2)); table.insert(txt, gl(4)) end
                if e == 'add_hand' then ease_hands_played(1); table.insert(txt, gl(4)) end
                if e == 'add_disc' then ease_discard(1); table.insert(txt, gl(4)) end
                if e == 'sub_hand' then ease_hands_played(-1); table.insert(txt, "-1 Hand") end
                if e == 'sub_disc' then ease_discard(-1); table.insert(txt, "-1 Discard") end
                if e == 'lvl_rand' then local hnds = {}; for k, v in pairs(G.GAME.hands) do if v.visible then table.insert(hnds, k) end end; if #hnds > 0 then level_up_hand(card, hnds[math.floor(pseudorandom(get_seed('e21'))*#hnds)+1], true, 1); table.insert(txt, gl(4)) end end
                if e == 'lvl_down' then local hnds = {}; for k, v in pairs(G.GAME.hands) do if v.visible then table.insert(hnds, k) end end; if #hnds > 0 then level_up_hand(card, hnds[math.floor(pseudorandom(get_seed('e21b'))*#hnds)+1], true, -1); table.insert(txt, gl(4)) end end
                if e == 'retrig' and context.repetition and context.other_card then return { message = gl(4), repetitions = math.floor(pseudorandom(get_seed('e22'))*3)+1, card = context.other_card } end
                if e == 'remove_stickers' and G.jokers and G.jokers.cards then
                    for _, j in ipairs(G.jokers.cards) do j.ability.eternal = false; j.ability.perishable = false; j.ability.rental = false end
                    table.insert(txt, gl(4))
                end
                if e == 'add_red_seal_to_kings' and context.individual and context.cardarea == G.play and context.other_card:get_id() == 13 then
                    context.other_card:set_seal('Red', true, true); table.insert(txt, gl(4))
                end
                if e == 'add_glass_on_blind' and context.setting_blind and not context.blueprint then
                    local front = (pseudorandom_element(G.P_CARDS, get_seed('e23')))
                    local glass_card = create_card('Base', G.deck, nil, nil, nil, nil, front.key, 'tm')
                    glass_card:set_ability(G.P_CENTERS.m_glass, nil, true)
                    glass_card:add_to_deck(); table.insert(G.playing_cards, glass_card)
                    G.deck.config.card_limit = G.deck.config.card_limit + 1
                    table.insert(txt, gl(4))
                end
                if e == 'extra_consumable_slot' and G.consumeables then G.consumeables.config.card_limit = G.consumeables.config.card_limit + 1; table.insert(txt, gl(4)) end
                if e == 'gain_joker_slot' and G.jokers then G.jokers.config.card_limit = G.jokers.config.card_limit + 1; table.insert(txt, gl(4)) end
                if e == 'lose_joker_slot' and G.jokers then G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1); table.insert(txt, gl(4)) end
                if e == 'force_boss' and G.GAME.blind then G.GAME.blind.chips = G.GAME.blind.chips * 2; G.GAME.blind.chip_text = number_format(G.GAME.blind.chips); if G.HUD_blind then G.HUD_blind:recalculate() end; table.insert(txt, gl(4)) end
                if e == 'add_perishable' and G.jokers and #G.jokers.cards > 0 then G.jokers.cards[math.floor(pseudorandom(get_seed('e24'))*#G.jokers.cards)+1].ability.perishable = true; table.insert(txt, gl(4)) end
                if e == 'add_rental' and G.jokers and #G.jokers.cards > 0 then G.jokers.cards[math.floor(pseudorandom(get_seed('e25'))*#G.jokers.cards)+1].ability.rental = true; table.insert(txt, gl(4)) end

                if e == 'consume_joker' and G.jokers and #G.jokers.cards > 1 then
                    local valid = {}
                    for _, j in ipairs(G.jokers.cards) do if j ~= card and not j.getting_sliced then table.insert(valid, j) end end
                    if #valid > 0 then
                        local tgt = (pseudorandom_element(valid, get_seed('e_n1')))
                        tgt.getting_sliced = true
                        tgt:start_dissolve({G.C.RED}, nil, 1.6)
                        sts.m = sts.m + math.floor(pseudorandom(get_seed('e_n1_2'))*20) + 15
                        table.insert(txt, gl(4))
                    end
                end
                
                if e == 'random_enhance_played' and context.full_hand then
                    local enhs = {'m_stone','m_gold','m_glass','m_steel','m_lucky','m_wild','m_mult','m_bonus'}
                    for _, v in ipairs(context.full_hand) do v:set_ability(G.P_CENTERS[(pseudorandom_element(enhs, get_seed('e_n8')))], nil, true) end
                    table.insert(txt, gl(4))
                end
                
                if e == 'add_random_edition_played' and context.scoring_hand and #context.scoring_hand > 0 then
                    local eds = {'foil','holo','polychrome','negative','kranlaxs_cosmic','kranlaxs_underwater','kranlaxs_sepia','kranlaxs_monochrome'}
                    context.scoring_hand[1]:set_edition({[(pseudorandom_element(eds, get_seed('e_n2')))] = true}, true, true)
                    table.insert(txt, gl(4))
                end
                if e == 'spawn_food' and #G.jokers.cards < G.jokers.config.card_limit then
                    local food = {}
                    for k,v in pairs(G.P_CENTERS) do if v.pools and v.pools["kranlaxs_food"] then table.insert(food, k) end end
                    if #food > 0 then
                        local c = create_card('Joker', G.jokers, nil, nil, nil, nil, (pseudorandom_element(food, get_seed('e_n3'))), 'tm')
                        c:add_to_deck(); G.jokers:emplace(c)
                        table.insert(txt, gl(4))
                    end
                end
                if e == 'absorb_sell' and context.selling_card and context.card.sell_cost then
                    sts.m = sts.m + (context.card.sell_cost * 2)
                    table.insert(txt, gl(4))
                end
                if e == 'clone_played' and context.full_hand then
                    for _, v in ipairs(context.full_hand) do
                        local cp = copy_card(v, nil, nil, G.playing_card)
                        cp.T.x = G.deck.T.x; cp.T.y = G.deck.T.y
                        cp:add_to_deck(); table.insert(G.playing_cards, cp); G.deck.config.card_limit = G.deck.config.card_limit + 1
                    end
                    table.insert(txt, gl(4))
                end
                if e == 'add_seal_hand' and G.hand and #G.hand.cards > 0 then
                    local seals = {'Red','Blue','Gold','Purple','kranlaxs_orangeseal','kranlaxs_pinkseal','kranlaxs_whiteseal','kranlaxs_brownseal','kranlaxs_grayseal','kranlaxs_mintseal'}
                    for _, v in ipairs(G.hand.cards) do
                        v:set_seal((pseudorandom_element(seals, get_seed('e_n4'))), true, true)
                    end
                    table.insert(txt, gl(4))
                end
                if e == 'lose_run_chance' and pseudorandom(get_seed('e_n5')) < 0.01 then
                    G.STATE = G.STATES.GAME_OVER; G.STATE_COMPLETE = false
                end
                if e == 'evolve_joker' and G.jokers and #G.jokers.cards > 0 then
                    local tgt = G.jokers.cards[math.floor(pseudorandom(get_seed('e_n6'))*#G.jokers.cards)+1]
                    local tgt_rarity = 2
                    if tgt.config.center.rarity == 1 then tgt_rarity = 2
                    elseif tgt.config.center.rarity == 2 then tgt_rarity = 3
                    elseif tgt.config.center.rarity == 3 then tgt_rarity = 'kranlaxs_zenith'
                    elseif tgt.config.center.rarity == 'kranlaxs_zenith' then tgt_rarity = 4 end
                    local valid_new = {}
                    for k, v in pairs(G.P_CENTERS) do
                        if v.set == 'Joker' and not v.no_pool and v.unlocked and v.rarity == tgt_rarity then table.insert(valid_new, k) end
                    end
                    if #valid_new > 0 then
                        tgt:set_ability(G.P_CENTERS[(pseudorandom_element(valid_new, get_seed('e_n7')))], true, true)
                        table.insert(txt, gl(4))
                    end
                end
                if e == 'gain_token' and G.GAME then
                    G.GAME.kranlaxs_dark_coins = (G.GAME.kranlaxs_dark_coins or 0) + 1
                    table.insert(txt, gl(4))
                end
                if e == 'add_perma_xmult' and context.other_card then
                    context.other_card.ability.perma_x_mult = (context.other_card.ability.perma_x_mult or 0) + 0.5
                    table.insert(txt, gl(4))
                end
                if e == 'lvl_up_played' and context.scoring_name then
                    level_up_hand(card, context.scoring_name, true, 1)
                    table.insert(txt, gl(4))
                end
                if e == 'spawn_spectral' and G.consumeables and #G.consumeables.cards < G.consumeables.config.card_limit then
                    local cp = create_card('Spectral', G.consumeables, nil, nil, nil, nil, nil, 'tm_spec')
                    cp:add_to_deck(); G.consumeables:emplace(cp); table.insert(txt, gl(4))
                end
                if e == 'double_chips' then
                    sts.c = (sts.c == 0 and 10 or sts.c) * 2
                    table.insert(txt, gl(4))
                end
                if e == 'destroy_unscored' and context.full_hand and context.scoring_hand then
                    for _, v in ipairs(context.full_hand) do
                        local is_scoring = false
                        for _, sc in ipairs(context.scoring_hand) do if v == sc then is_scoring = true break end end
                        if not is_scoring and not v.destroyed then
                            v.destroyed = true
                            v:start_dissolve()
                            table.insert(txt, gl(4))
                        end
                    end
                end
                if e == 'give_money_per_card_in_hand' and G.hand and #G.hand.cards > 0 then
                    ease_dollars(#G.hand.cards)
                    table.insert(txt, gl(4))
                end
            end
        end

        if context.joker_main then
            for _, e in ipairs(efs) do
                if e == 'time_var' then sts.c = sts.c + os.date("*t").sec end
                if e == 'rarity_count' then for _, j in ipairs(G.jokers.cards) do if j.config.center.rarity > 1 then sts.m = sts.m + 5 end end end
                if e == 'mult_per_card_in_hand' and G.hand and #G.hand.cards > 0 then sts.m = sts.m + (#G.hand.cards * (math.floor(pseudorandom(pseudoseed('tm_hnd'))*4)+2)) end
            end

            local ret = {}
            if sts.m ~= 0 then ret.mult_mod = sts.m end
            if sts.c ~= 0 then ret.chip_mod = sts.c end
            if sts.xm ~= 1 then ret.Xmult_mod = sts.xm end
            if sts.xc ~= 1 then ret.Xchip_mod = sts.xc end
            if sts.pm > 1 then ret.pow_mult = sts.pm; ret.message = "^"..string.format("%.2f", sts.pm).." M" end
            if sts.pc > 1 then ret.pow_chips = sts.pc; ret.message = "^"..string.format("%.2f", sts.pc).." C" end
            
            for _, e in ipairs(efs) do if e == 'swap_mc' then ret.swap = true end end

            if next(ret) then
                ret.colour = G.C.DARK_EDITION
                ret.message = ret.message or gl(6)
                return ret
            end
        end

        if #txt > 0 and not context.joker_main and not context.individual and not context.repetition then
            G.E_MANAGER:add_event(Event({ func = function() card:juice_up(0.5, 0.5); card_eval_status_text(card, 'extra', nil, nil, nil, {message = txt[math.floor(pseudorandom(pseudoseed('tm_txt_c'))*#txt)+1], colour = G.C.DARK_EDITION}); return true end }))
        end
    end
}