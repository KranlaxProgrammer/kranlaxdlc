SMODS.Joker{
    key = "tmtrainer",
    config = { extra = { conds = {}, effs = {}, stats = { m = 0, xm = 1, pm = 1, c = 0, xc = 1, pc = 1, dec = 0 }, g_seed = 0, sprite_x = 0 } },
    pos = { x = 0, y = 0 },
    display_size = { w = 71, h = 95 },
    cost = 8,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    discovered = false,
    no_collection = true,
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
        return math.random() < 0.05
    end,

    set_sprites = function(self, card, front)
        if card.ability and card.ability.extra and type(card.ability.extra.sprite_x) == 'number' then
            if card.children.center then
                card.children.center:set_sprite_pos({x = card.ability.extra.sprite_x, y = 0})
            end
        end
    end,

    set_ability = function(self, card, initial, delay_sprites)
        if initial then
            local r_seed = os.time() + math.floor(G.TIMERS.REAL * 1000) + math.floor(card.T.x)
            math.randomseed(r_seed)
            card.ability.extra.g_seed = r_seed
            card.ability.extra.sprite_x = math.random(0, 21)
            
            if card.children.center then
                card.children.center:set_sprite_pos({x = card.ability.extra.sprite_x, y = 0})
            end

            if math.random() < 0.15 and not card.edition then
                local eds = {'foil', 'holo', 'polychrome', 'negative'}
                card:set_edition({[eds[math.random(#eds)]] = true}, true)
            end

            -- NUEVAS CONDICIONES AÑADIDAS AQUÍ
            local c_pool = {
                'discard', 'buy', 'sell', 'skip', 'boss', 'reroll', 'level_up', 'booster',
                'even_minute', 'play_card', 'destroy_card', 'score_card', 'blind_select',
                'round_end', 'first_hand', 'last_hand', 'draw_card', 'use_consumable',
                'play_spade', 'play_heart', 'no_pair', 'only_numbers', 'has_stone', 
                'not_most_played', 'exactly_one_heart', 'has_straight'
            }

            -- NUEVOS EFECTOS AÑADIDOS AQUÍ
            local e_pool = {
                't_enh', 'r_enh', 't_seal', 'r_seal', 't_ed', 'r_ed', 'x_m', 'x_c', 'p_m', 'p_c',
                'f_m', 'f_c', 'add_deck', 'dest_deck', 'time_var', 'rarity_count', 'copy_cons',
                'dis_boss', 'on_sell_fx', 'sp_tag', 'sp_cons', 'sp_jok', 'size_up', 'size_down',
                'swap_mc', 'bal_mc', 'dec_dest', 'smear', 'merge', 'flip', 'unflip', 'copy_play',
                'crash', 'sp_uno', 'sp_quartz', 'dr_money', 'gv_money', 'ls_money', 'add_hand', 
                'add_disc', 'lvl_rand', 'retrig', 'remove_stickers', 'mult_per_card_in_hand', 
                'add_red_seal_to_kings', 'add_glass_on_blind', 'extra_consumable_slot'
            }

            local num_c = math.random(0, 2)
            for i = 1, num_c do table.insert(card.ability.extra.conds, c_pool[math.random(#c_pool)]) end

            local r = math.random(1, 100)
            local num_e = 2
            if r > 98 then num_e = 7 elseif r > 94 then num_e = 6 elseif r > 85 then num_e = 5 elseif r > 65 then num_e = 4 elseif r > 40 then num_e = 3 end
            
            for i = 1, num_e do table.insert(card.ability.extra.effs, e_pool[math.random(#e_pool)]) end
            card.ability.extra.stats.dec = math.random(15, 60)
        end
    end,

    loc_vars = function(self, info_queue, card)
        math.randomseed(os.time() + math.floor(G.TIMERS.REAL * 100))
        local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@#$%&*!?<>~[]{}+-"
        local function gl(len)
            local res = ""
            for i = 1, len do res = res .. chars:sub(math.random(1, #chars), math.random(1, #chars)) end
            return res
        end
        return {vars = {gl(math.random(10, 18)), gl(math.random(12, 22)), gl(math.random(10, 16)), gl(math.random(12, 20))}}
    end,

    calculate = function(self, card, context)
        local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@#$%&*!?<>~[]{}+-"
        local function gl(len)
            local res = ""
            for i = 1, len do res = res .. chars:sub(math.random(1, #chars), math.random(1, #chars)) end
            return res
        end

        local trg = false
        local cnds = card.ability.extra.conds
        local efs = card.ability.extra.effs
        local sts = card.ability.extra.stats

        if #cnds == 0 then
            if context.joker_main or (context.end_of_round and context.main_eval) then trg = true end
        else
            for _, c in ipairs(cnds) do
                if c == 'discard' and context.pre_discard and not context.blueprint then trg = true end
                if c == 'buy' and context.buying_card and not context.blueprint then trg = true end
                if c == 'sell' and context.selling_card and not context.blueprint then trg = true end
                if c == 'skip' and context.skip_blind and not context.blueprint then trg = true end
                if c == 'boss' and context.setting_blind and G.GAME.blind.boss and not context.blueprint then trg = true end
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
                
                -- LÓGICA DE NUEVAS CONDICIONES
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
            for _, e in ipairs(efs) do
                if e == 't_enh' and G.hand and #G.hand.cards > 0 then G.hand.cards[math.random(#G.hand.cards)]:set_ability(G.P_CENTERS[pseudorandom_element({'m_stone','m_gold','m_glass','m_steel','m_lucky','m_wild','m_mult','m_bonus'}, pseudoseed('tm'))], nil, true); table.insert(txt, gl(4)) end
                if e == 'r_enh' and G.hand and #G.hand.cards > 0 then G.hand.cards[math.random(#G.hand.cards)]:set_ability(G.P_CENTERS.c_base, nil, true); table.insert(txt, gl(4)) end
                if e == 't_seal' and G.hand and #G.hand.cards > 0 then G.hand.cards[math.random(#G.hand.cards)]:set_seal(pseudorandom_element({'Red','Blue','Gold','Purple'}, pseudoseed('tm')), true, true); table.insert(txt, gl(4)) end
                if e == 'r_seal' and G.hand and #G.hand.cards > 0 then G.hand.cards[math.random(#G.hand.cards)]:set_seal(nil, true, true); table.insert(txt, gl(4)) end
                if e == 't_ed' and G.hand and #G.hand.cards > 0 then G.hand.cards[math.random(#G.hand.cards)]:set_edition({[pseudorandom_element({'foil','holo','polychrome','negative'}, pseudoseed('tm'))] = true}, true, true); table.insert(txt, gl(4)) end
                if e == 'r_ed' and G.hand and #G.hand.cards > 0 then G.hand.cards[math.random(#G.hand.cards)]:set_edition(nil, true, true); table.insert(txt, gl(4)) end
                if e == 'x_m' then sts.xm = sts.xm + 0.1; table.insert(txt, gl(4)) end
                if e == 'x_c' then sts.xc = sts.xc + 0.1; table.insert(txt, gl(4)) end
                if e == 'p_m' then sts.pm = sts.pm + 0.05; table.insert(txt, gl(4)) end
                if e == 'p_c' then sts.pc = sts.pc + 0.05; table.insert(txt, gl(4)) end
                if e == 'f_m' then sts.m = sts.m + math.random(5, 15); table.insert(txt, gl(4)) end
                if e == 'f_c' then sts.c = sts.c + math.random(10, 30); table.insert(txt, gl(4)) end
                if e == 'add_deck' and G.hand and #G.hand.cards > 0 then local cp = copy_card(G.hand.cards[math.random(#G.hand.cards)], nil, nil, G.playing_card); cp:add_to_deck(); table.insert(G.playing_cards, cp); G.deck.config.card_limit = G.deck.config.card_limit + 1; table.insert(txt, gl(4)) end
                if e == 'dest_deck' and G.hand and #G.hand.cards > 0 then G.hand.cards[math.random(#G.hand.cards)]:start_dissolve({G.C.RED}); table.insert(txt, gl(4)) end
                if e == 'copy_cons' and G.consumeables and #G.consumeables.cards > 0 and #G.consumeables.cards < G.consumeables.config.card_limit then local cp = copy_card(G.consumeables.cards[math.random(#G.consumeables.cards)]); cp:add_to_deck(); G.consumeables:emplace(cp); table.insert(txt, gl(4)) end
                if e == 'dis_boss' and G.GAME.blind and G.GAME.blind.boss then G.GAME.blind:disable(); table.insert(txt, gl(4)) end
                if e == 'sp_tag' then add_tag(Tag(pseudorandom_element(G.P_TAGS, pseudoseed('tm')).key)); table.insert(txt, gl(4)) end
                if e == 'sp_cons' and #G.consumeables.cards < G.consumeables.config.card_limit then local c = create_card(pseudorandom_element({'Tarot','Planet','Spectral'}, pseudoseed('tm')), G.consumeables, nil, nil, nil, nil, nil, 'tm'); c:add_to_deck(); G.consumeables:emplace(c); table.insert(txt, gl(4)) end
                if e == 'sp_jok' and #G.jokers.cards < G.jokers.config.card_limit then local c = create_card('Joker', G.jokers, nil, nil, nil, nil, nil, 'tm'); c:add_to_deck(); G.jokers:emplace(c); table.insert(txt, gl(4)) end
                if e == 'size_up' and G.GAME.blind then G.GAME.blind.chips = math.floor(G.GAME.blind.chips * 1.5); G.GAME.blind.chip_text = number_format(G.GAME.blind.chips); if G.HUD_blind then G.HUD_blind:recalculate() end; table.insert(txt, gl(4)) end
                if e == 'size_down' and G.GAME.blind then G.GAME.blind.chips = math.max(1, math.floor(G.GAME.blind.chips * 0.8)); G.GAME.blind.chip_text = number_format(G.GAME.blind.chips); if G.HUD_blind then G.HUD_blind:recalculate() end; table.insert(txt, gl(4)) end
                if e == 'dec_dest' then sts.dec = sts.dec - 1; if sts.dec <= 0 then card:start_dissolve({G.C.RED}) end; table.insert(txt, gl(4)) end
                if e == 'merge' and G.hand and #G.hand.cards > 0 then local tgt = G.hand.cards[math.random(#G.hand.cards)]; local suits = {'Spades','Hearts','Clubs','Diamonds'}; tgt:change_suit(suits[math.random(#suits)]); table.insert(txt, gl(4)) end
                if e == 'flip' and G.hand and #G.hand.cards > 0 then for _, c in ipairs(G.hand.cards) do c.facing = 'back'; c.sprite_facing = 'back'; c:flip() end; table.insert(txt, gl(4)) end
                if e == 'unflip' and G.hand and #G.hand.cards > 0 then for _, c in ipairs(G.hand.cards) do c.facing = 'front'; c.sprite_facing = 'front'; c:flip() end; table.insert(txt, gl(4)) end
                if e == 'crash' and math.random() < 0.01 then error("TMTRAINER EXCEPTION") end
                if e == 'sp_uno' and #G.consumeables.cards < G.consumeables.config.card_limit then local ks = {"c_kranlaxs_skip", "c_kranlaxs_stacking", "c_kranlaxs_draw2", "c_kranlaxs_draw4", "c_kranlaxs_reverse", "c_kranlaxs_wildcard", "c_kranlaxs_replay", "c_kranlaxs_discardall", "c_kranlaxs_shield", "c_kranlaxs_misery", "c_kranlaxs_gift", "c_kranlaxs_customdraw"}; local c = create_card('UNOCards', G.consumeables, nil, nil, nil, nil, ks[math.random(#ks)], 'tm'); c:add_to_deck(); G.consumeables:emplace(c); table.insert(txt, gl(4)) end
                if e == 'sp_quartz' and #G.consumeables.cards < G.consumeables.config.card_limit then local ks = {"c_kranlaxs_blackquartz", "c_kranlaxs_whitequartz", "c_kranlaxs_pinkquartz", "c_kranlaxs_bluequartz", "c_kranlaxs_lilacquartz", "c_kranlaxs_grayquartz", "c_kranlaxs_transparentquartz", "c_kranlaxs_redquartz", "c_kranlaxs_celestequartz", "c_kranlaxs_yellowquartz", "c_kranlaxs_greenquartz", "c_kranlaxs_brownquartz", "c_kranlaxs_turquoisequartz", "c_kranlaxs_orangequartz", "c_kranlaxs_lapislazuli", "c_kranlaxs_cinnabar", "c_kranlaxs_graphite", "c_kranlaxs_uranium"}; local c = create_card('Quartz', G.consumeables, nil, nil, nil, nil, ks[math.random(#ks)], 'tm'); c:add_to_deck(); G.consumeables:emplace(c); table.insert(txt, gl(4)) end
                if e == 'dr_money' then ease_dollars(-G.GAME.dollars); table.insert(txt, gl(4)) end
                if e == 'gv_money' then ease_dollars(math.random(3, 15)); table.insert(txt, gl(4)) end
                if e == 'ls_money' then ease_dollars(-math.random(2, 10)); table.insert(txt, gl(4)) end
                if e == 'add_hand' then ease_hands_played(1); table.insert(txt, gl(4)) end
                if e == 'add_disc' then ease_discard(1); table.insert(txt, gl(4)) end
                if e == 'lvl_rand' then local hnds = {}; for k, v in pairs(G.GAME.hands) do if v.visible then table.insert(hnds, k) end end; if #hnds > 0 then level_up_hand(card, hnds[math.random(#hnds)], true, 1); table.insert(txt, gl(4)) end end
                if e == 'retrig' and context.repetition and context.other_card then return { message = gl(4), repetitions = math.random(1,3), card = context.other_card } end
                
                -- LÓGICA DE NUEVOS EFECTOS
                if e == 'remove_stickers' and G.jokers and G.jokers.cards then
                    for _, j in ipairs(G.jokers.cards) do
                        j.ability.eternal = false
                        j.ability.perishable = false
                        j.ability.rental = false
                    end
                    table.insert(txt, gl(4))
                end
                if e == 'add_red_seal_to_kings' and context.individual and context.cardarea == G.play and context.other_card:get_id() == 13 then
                    context.other_card:set_seal('Red', true, true)
                    table.insert(txt, gl(4))
                end
                if e == 'add_glass_on_blind' and context.setting_blind and not context.blueprint then
                    local front = pseudorandom_element(G.P_CARDS, pseudoseed('tm'))
                    local glass_card = create_card('Base', G.deck, nil, nil, nil, nil, front.key, 'tm')
                    glass_card:set_ability(G.P_CENTERS.m_glass, nil, true)
                    local eds = {'foil', 'holo', 'polychrome', 'negative'}
                    glass_card:set_edition({[eds[math.random(#eds)]] = true}, true)
                    glass_card:add_to_deck()
                    table.insert(G.playing_cards, glass_card)
                    G.deck.config.card_limit = G.deck.config.card_limit + 1
                    table.insert(txt, gl(4))
                end
                if e == 'extra_consumable_slot' and G.consumeables then
                    G.consumeables.config.card_limit = G.consumeables.config.card_limit + 1
                    table.insert(txt, gl(4))
                end
            end
        end

        if context.joker_main then
            for _, e in ipairs(efs) do
                if e == 'time_var' then sts.c = sts.c + os.date("*t").sec end
                if e == 'rarity_count' then for _, j in ipairs(G.jokers.cards) do if j.config.center.rarity > 1 then sts.m = sts.m + 5 end end end
                if e == 'mult_per_card_in_hand' and G.hand and #G.hand.cards > 0 then sts.m = sts.m + (#G.hand.cards * math.random(2, 5)) end
            end

            local ret = {}
            if sts.m > 0 then ret.mult_mod = sts.m end
            if sts.c > 0 then ret.chip_mod = sts.c end
            if sts.xm > 1 then ret.Xmult_mod = sts.xm end
            if sts.xc > 1 then ret.Xchip_mod = sts.xc end
            if sts.pm > 1 then ret.pow_mult = sts.pm; ret.message = "^"..string.format("%.2f", sts.pm).." M" end
            if sts.pc > 1 then ret.pow_chips = sts.pc; ret.message = "^"..string.format("%.2f", sts.pc).." C" end
            
            for _, e in ipairs(efs) do
                if e == 'swap_mc' then ret.swap = true end
            end

            if next(ret) then
                ret.colour = G.C.DARK_EDITION
                ret.message = ret.message or gl(6)
                return ret
            end
        end

        if #txt > 0 and not context.joker_main and not context.individual and not context.repetition then
            G.E_MANAGER:add_event(Event({ func = function() card:juice_up(0.5, 0.5); card_eval_status_text(card, 'extra', nil, nil, nil, {message = txt[math.random(#txt)], colour = G.C.DARK_EDITION}); return true end }))
        end
    end
}