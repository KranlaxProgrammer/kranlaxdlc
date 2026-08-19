-- ========================================================
-- Funciones Globales para el Mazo del Caos
-- ========================================================
function kranlaxs_randomize_chaos_vouchers()
    G.GAME.round_resets.hands = 4
    G.GAME.round_resets.discards = 3
    G.hand.config.card_limit = 10
    G.jokers.config.card_limit = 6
    G.consumeables.config.card_limit = 3
    
    G.GAME.used_vouchers = {}
    
    local valid_vouchers = {}
    for k, v in pairs(G.P_CENTERS) do
        if v.set == 'Voucher' and v.unlocked and k ~= 'v_antimatter' and k ~= 'v_kranlaxs_even_more_stock' and k ~= 'v_hieroglyph' and k ~= 'v_petroglyph' and k ~= 'v_kranlaxs_more_stock' and k ~= 'v_overstock_norm' then
            table.insert(valid_vouchers, k)
        end
    end

    local picked = {}
    for i = 1, 6 do
        if #valid_vouchers > 0 then
            local idx = pseudorandom('chaos_v', 1, #valid_vouchers)
            picked[valid_vouchers[idx]] = true
            table.remove(valid_vouchers, idx)
        end
    end

    for k, _ in pairs(picked) do
        local v_center = G.P_CENTERS[k]
        G.GAME.used_vouchers[k] = true
        local fake_card = Card(0, 0, G.CARD_W, G.CARD_H, G.P_CARDS.empty, v_center)
        fake_card:apply_to_run()
        fake_card:remove()
    end
    
    if G.hand then G.hand:change_size(0) end
end

function kranlaxs_trigger_chaos_deck()
    play_sound('tarot2', 1.2, 1.0)

    if G.GAME.round_resets.ante > 1 then
        G.GAME.starting_params.ante_scaling = 4
    else
        G.GAME.starting_params.ante_scaling = 2
    end

    -- A. ALEATORIZAR JOKERS (SOLO DESBLOQUEADOS)
    local joker_count = (G.jokers and G.jokers.cards) and #G.jokers.cards or 0
    if joker_count > 0 then
        for i = joker_count, 1, -1 do
            G.jokers.cards[i]:start_dissolve(nil, true)
        end
        
        local valid_jokers = {}
        for k, v in pairs(G.P_CENTERS) do
            if v.set == 'Joker' and v.unlocked and not v.no_pool_flag and k ~= 'j_kranlaxs_vipsuscription' and k ~= 'j_kranlaxs_weeklychallenge' and k ~= 'j_kranlaxs_sundaycheckpoint' then
                table.insert(valid_jokers, k)
            end
        end

        if #valid_jokers > 0 then
            for i = 1, joker_count do
                local forced_key = pseudorandom_element(valid_jokers, pseudoseed('chaos_joker_'..i))
                local new_joker = create_card('Joker', G.jokers, nil, nil, nil, nil, forced_key, 'chaos_joker')
                new_joker:add_to_deck()
                G.jokers:emplace(new_joker)
                
                local ed_keys = {'none', 'foil', 'holo', 'polychrome'}
                if SMODS.Editions then
                    for k, _ in pairs(SMODS.Editions) do table.insert(ed_keys, k) end
                end
                local r_ed = pseudorandom_element(ed_keys, pseudoseed('chaos_j_ed'))
                if r_ed ~= 'none' then new_joker:set_edition({[r_ed] = true}, true, true) end
                
                local st_keys = {'none', 'eternal', 'perishable', 'rental'}
                if SMODS.Stickers then
                    for k, _ in pairs(SMODS.Stickers) do
                        if k ~= 'fat' and k ~= 'overweight' and k ~= 'massive' then table.insert(st_keys, k) end
                    end
                end
                local r_st = pseudorandom_element(st_keys, pseudoseed('chaos_j_st'))
                if r_st ~= 'none' then
                    new_joker.ability[r_st] = true
                    if r_st == 'perishable' then new_joker.ability.perish_tally = G.GAME.perishable_jokers_tally or 5 end
                    new_joker:set_cost()
                end
            end
        end
    end

    -- B. ALEATORIZAR CONSUMIBLES (SOLO DESBLOQUEADOS)
    local cons_count = (G.consumeables and G.consumeables.cards) and #G.consumeables.cards or 0
    if cons_count > 0 then
        for i = cons_count, 1, -1 do
            G.consumeables.cards[i]:start_dissolve(nil, true)
        end
        
        local valid_cons = {}
        for k, v in pairs(G.P_CENTERS) do
            if (v.set == 'Tarot' or v.set == 'Planet' or v.set == 'Spectral' or (SMODS.ConsumableTypes and SMODS.ConsumableTypes[v.set])) and v.unlocked then
                table.insert(valid_cons, k)
            end
        end

        if #valid_cons > 0 then
            for i = 1, cons_count do
                local forced_key = pseudorandom_element(valid_cons, pseudoseed('chaos_cons_type' .. i))
                local new_cons = create_card('Consumeables', G.consumeables, nil, nil, nil, nil, forced_key, 'chaos_cons')
                new_cons:add_to_deck()
                G.consumeables:emplace(new_cons)
            end
        end
    end

    -- C. ALEATORIZAR CARTAS DE LA BARAJA (RANGO, PALO, MEJORA, EDICIÓN, SELLO)
    if G.playing_cards then
        local valid_bases = {}
        for _, v in pairs(G.P_CARDS) do
            if v.suit and v.value then table.insert(valid_bases, v) end
        end

        for _, card in ipairs(G.playing_cards) do
            local r_base = pseudorandom_element(valid_bases, pseudoseed('chaos_c_base'))
            card:set_base(r_base)

            local centers = {G.P_CENTERS['c_base']}
            for _, v in pairs(G.P_CENTERS) do if v.set == 'Enhanced' then table.insert(centers, v) end end
            
            local r_enh = pseudorandom_element(centers, pseudoseed('chaos_c_enh'))
            if r_enh.key == 'm_stone' and pseudorandom('stone_nerf') < 0.80 then
                r_enh = G.P_CENTERS['c_base']
            end
            card:set_ability(r_enh, true, false)
            
            local ed_keys2 = {'none', 'foil', 'holo', 'polychrome'}
            if SMODS.Editions then
                for k, _ in pairs(SMODS.Editions) do table.insert(ed_keys2, k) end
            end
            local r_ed2 = pseudorandom_element(ed_keys2, pseudoseed('chaos_c_ed'))
            if r_ed2 == 'none' then card:set_edition(nil, true, true) else card:set_edition({[r_ed2] = true}, true, true) end
            
            local seals = {'none', 'Red', 'Blue', 'Purple', 'Gold'}
            if SMODS.Seals then
                for k, _ in pairs(SMODS.Seals) do table.insert(seals, k) end
            end
            local r_seal = pseudorandom_element(seals, pseudoseed('chaos_c_seal'))
            
            if r_seal == 'pinkseal' and pseudorandom('pink_nerf') < 0.60 then
                r_seal = 'none'
            end

            if r_seal == 'none' then card:set_seal(nil, true, true) else card:set_seal(r_seal, true, true) end
        end
    end

    -- D. ALEATORIZAR VALES
    kranlaxs_randomize_chaos_vouchers()
end

-- =========================================================
-- DEFINICIÓN DEL MAZO
-- =========================================================
SMODS.Back {
    key = 'chaos_deck',
    pos = { x = 0, y = 0 }, 
    unlocked = false,
    discovered = false,
    atlas = 'CustomDecks',
    
    config = {
        joker_slot = 1, 
        consumable_slot = 1, 
        hand_size = 2, 
    },
    
    check_for_unlock = function(self, args)
        for k, v in pairs(G.P_CENTERS) do
            if v.unlocked == false and k ~= 'b_kranlaxs_chaos_deck' and k ~= 'b_chaos_deck' then
                local s = v.set
                if s == 'Joker' or s == 'Voucher' or s == 'Tarot' or s == 'Planet' or s == 'Spectral' or s == 'Back' then
                    return false
                end
            end
        end
        return true
    end,

    apply = function(self, back)
        G.GAME.banned_keys['j_kranlaxs_vipsuscription'] = true
        G.GAME.banned_keys['j_kranlaxs_suscripcionvip'] = true
        G.GAME.banned_keys['v_more_stock'] = true
        G.GAME.banned_keys['v_overstock_norm'] = true

        for k, v in pairs(G.P_CENTERS) do
            if v.set == 'Voucher' and k ~= 'v_blank' then
                G.GAME.banned_keys[k] = true
            end
        end

        G.GAME.starting_params.ante_scaling = 2
        G.GAME.modifiers.booster_slots = (G.GAME.modifiers.booster_slots or 0) - 2

        G.E_MANAGER:add_event(Event({
            func = function()
                local valid_jokers_init = {}
                local valid_cons_init = {}
                
                for k, v in pairs(G.P_CENTERS) do
                    if v.unlocked then
                        if v.set == 'Joker' and not v.no_pool_flag and k ~= 'j_kranlaxs_vipsuscription' and k ~= 'j_kranlaxs_weeklychallenge' and k ~= 'j_kranlaxs_sundaycheckpoint' then
                            table.insert(valid_jokers_init, k)
                        elseif v.set == 'Tarot' or v.set == 'Planet' or v.set == 'Spectral' or (SMODS.ConsumableTypes and SMODS.ConsumableTypes[v.set]) then
                            table.insert(valid_cons_init, k)
                        end
                    end
                end

                if #valid_jokers_init > 0 then
                    local new_joker = create_card('Joker', G.jokers, nil, nil, nil, nil, pseudorandom_element(valid_jokers_init, pseudoseed('start_j')), 'chaos_start')
                    new_joker:add_to_deck()
                    G.jokers:emplace(new_joker)
                end
                
                if #valid_cons_init > 0 then
                    local new_cons = create_card('Consumeables', G.consumeables, nil, nil, nil, nil, pseudorandom_element(valid_cons_init, pseudoseed('start_c')), 'chaos_start')
                    new_cons:add_to_deck()
                    G.consumeables:emplace(new_cons)
                end

                kranlaxs_randomize_chaos_vouchers()
                return true
            end
        }))
    end,
    
    calculate = function(self, back, context)
        if context.end_of_round and not context.blueprint then
            if G.GAME.chaos_last_round ~= G.GAME.round then
                G.GAME.chaos_last_round = G.GAME.round
                
                G.E_MANAGER:add_event(Event({
                    trigger = 'condition',
                    blocking = false,
                    condition = function()
                        return G.STATE_COMPLETE and (G.STATE == G.STATES.SHOP or G.STATE == G.STATES.BLIND_SELECT) and not G.overlay_menu
                    end,
                    func = function()
                        kranlaxs_trigger_chaos_deck()
                        return true
                    end
                }))
            end
        end

        if context.ending_shop and not context.blueprint then
            local voucher_count = 0
            if G.GAME.used_vouchers then
                for k, v in pairs(G.GAME.used_vouchers) do
                    voucher_count = voucher_count + 1
                end
            end
            
            if voucher_count > 6 then
                G.E_MANAGER:add_event(Event({
                    trigger = 'condition',
                    blocking = false,
                    condition = function()
                        return G.STATE_COMPLETE and G.STATE == G.STATES.BLIND_SELECT
                    end,
                    func = function()
                        play_sound('tarot2', 0.8, 1.2)
                        kranlaxs_randomize_chaos_vouchers()
                        return true
                    end
                }))
            end
        end
    end
}

-- ==============================================================================
-- HOOK: BARAJA DEL CAOS - TIENDA Y SOBRES 100% RANDOMIZADOS
-- ==============================================================================
if not SMODS.kranlaxs_chaos_shop_hook then
    local orig_create_card = create_card
    function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
        
        -- Detectamos si la Baraja del Caos está activa y si NO es una carta forzada (como el comodín de inicio)
        if G.GAME and G.GAME.selected_back and G.GAME.selected_back.effect.center.key == 'b_kranlaxs_chaos_deck' and not forced_key then
            
            -- Aplicamos el caos si la carta va a aparecer en la tienda O dentro de un sobre
            if area == G.shop_jokers or area == G.shop_booster or area == G.shop_vouchers or area == G.pack_cards then
                
                -- Lista base de posibilidades (Base = Cartas de póker normales)
                local caos_types = {'Joker', 'Tarot', 'Planet', 'Spectral', 'Voucher', 'Base'}
                
                -- Agregamos dinámicamente tus tipos de consumibles personalizados (Quartz, UNO, InverseTarot)
                if SMODS.ConsumableTypes then
                    for k, _ in pairs(SMODS.ConsumableTypes) do
                        table.insert(caos_types, k)
                    end
                end
                
                -- EXCEPCIÓN DE SEGURIDAD: Los paquetes de mejora (Booster) solo pueden salir en la tienda.
                -- Si los permitimos dentro de G.pack_cards, abrir un sobre dentro de otro sobre crashearía el juego.
                if area ~= G.pack_cards then
                    table.insert(caos_types, 'Booster')
                end
                
                -- Randomización con lógica Seeded
                _type = pseudorandom_element(caos_types, pseudoseed('caos_shop_rand'))
            end
        end
        
        -- Ejecutamos la creación de la carta con el tipo adulterado
        local card = orig_create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
        
        return card
    end
    SMODS.kranlaxs_chaos_shop_hook = true
end