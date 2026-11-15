local function get_weighted_pack_card(i, keys, weights, seed)
    local is_calico = G.GAME and G.GAME.modifiers and G.GAME.modifiers.calico_deck
    if i == 1 then G.GAME.kranlaxs_current_pack_used = {} end
    G.GAME.kranlaxs_current_pack_used = G.GAME.kranlaxs_current_pack_used or {}
    local available_keys = {}
    local available_weights = {}
    local total_weight = 0
    for j, k in ipairs(keys) do
        local can_add = true
        local has_showman = SMODS.showman and SMODS.showman(k)
        if not is_calico and not has_showman then
            if G.GAME.kranlaxs_current_pack_used[k] then can_add = false end
            if can_add and G.consumeables and G.consumeables.cards then
                for _, v in ipairs(G.consumeables.cards) do
                    if v.config.center.key == k then can_add = false break end
                end
            end
        end
        if can_add then
            table.insert(available_keys, k)
            table.insert(available_weights, weights[j])
            total_weight = total_weight + weights[j]
        end
    end
    if #available_keys == 0 then
        total_weight = 0
        for j, k in ipairs(keys) do
            local has_showman = SMODS.showman and SMODS.showman(k)
            if is_calico or has_showman or not G.GAME.kranlaxs_current_pack_used[k] then
                table.insert(available_keys, k)
                table.insert(available_weights, weights[j])
                total_weight = total_weight + weights[j]
            end
        end
    end
    local rv = pseudorandom(seed .. i) * total_weight
    local cw = 0
    local selected_key = available_keys[1] or keys[1]
    for j, w in ipairs(available_weights) do
        cw = cw + w
        if rv <= cw then selected_key = available_keys[j] break end
    end
    G.GAME.kranlaxs_current_pack_used[selected_key] = true
    return selected_key
end

local is_es = (G.SETTINGS.language == 'es_419' or G.SETTINGS.language == 'es_ES')

local function get_booster_loc(name_es, name_en, type_es, type_en)
    return {
        name = is_es and name_es or name_en,
        text = {
            is_es and "Elige {C:attention}#1#{} de hasta" or "Choose {C:attention}#1#{} of up to",
            is_es and ("{C:attention}#2#{} cartas de {C:attention}" .. type_es .. "{} para") or ("{C:attention}#2#{C:attention} " .. type_en .. "{} cards to"),
            is_es and "añadir a tus consumibles" or "add to your consumable area"
        },
        group_name = is_es and name_es or name_en
    }
end

local function get_pool_keys_and_weights(pool_name)
    local keys = {}
    local weights = {}
    if G.P_CENTER_POOLS and G.P_CENTER_POOLS[pool_name] then
        for _, v in ipairs(G.P_CENTER_POOLS[pool_name]) do
            table.insert(keys, v.key)
            table.insert(weights, 10)
        end
    end
    return keys, weights
end

SMODS.Booster {
    key = 'uno_store_3', weight = 0.2, config = { extra = 3, choose = 1 }, kind = "UNO", cost = 4, atlas = "CustomBoosters", pos = { x = 6, y = 0 }, draw_hand = true, select_card = "consumeables", discovered = false, loc_txt = get_booster_loc("Paquete UNO", "UNO Pack", "UNO", "UNO"),
    loc_vars = function(self, info_queue, card) return { vars = { (card and card.ability) and card.ability.choose or self.config.choose, (card and card.ability) and card.ability.extra or self.config.extra } } end,
    create_card = function(self, card, i)
        local keys, weights = get_pool_keys_and_weights("UNOCards")
        return { key = get_weighted_pack_card(i, keys, weights, 'uno_store_3_card'), set = "UNOCards", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "uno_store_3" }
    end,
    particles = function(self) G.booster_pack_sparkles = Particles(1, 1, 0, 0, { timer = 0.015, scale = 0.2, initialize = true, lifespan = 1, speed = 1.1, padding = -1, attach = G.ROOM_ATTACH, colours = { G.C.WHITE, lighten(G.C.RED, 0.4), lighten(G.C.YELLOW, 0.2) }, fill = true }) G.booster_pack_sparkles.fade_alpha = 1 G.booster_pack_sparkles:fade(1, 0) end
}

SMODS.Booster {
    key = 'uno_store_5', weight = 0.15, config = { extra = 5, choose = 1 }, kind = "UNO", cost = 6, atlas = "CustomBoosters", pos = { x = 7, y = 0 }, draw_hand = true, select_card = "consumeables", discovered = false, loc_txt = get_booster_loc("Paquete UNO Jumbo", "Jumbo UNO Pack", "UNO", "UNO"),
    loc_vars = function(self, info_queue, card) return { vars = { (card and card.ability) and card.ability.choose or self.config.choose, (card and card.ability) and card.ability.extra or self.config.extra } } end,
    create_card = function(self, card, i)
        local keys, weights = get_pool_keys_and_weights("UNOCards")
        return { key = get_weighted_pack_card(i, keys, weights, 'uno_store_5_card'), set = "UNOCards", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "uno_store_5" }
    end,
    particles = function(self) G.booster_pack_sparkles = Particles(1, 1, 0, 0, { timer = 0.015, scale = 0.2, initialize = true, lifespan = 1, speed = 1.1, padding = -1, attach = G.ROOM_ATTACH, colours = { G.C.WHITE, lighten(G.C.RED, 0.4), lighten(G.C.YELLOW, 0.2) }, fill = true }) G.booster_pack_sparkles.fade_alpha = 1 G.booster_pack_sparkles:fade(1, 0) end
}

SMODS.Booster {
    key = 'invtarot_instant_3_1', weight = 0.2, config = { extra = 3, choose = 1 }, cost = 4, atlas = "CustomBoosters", pos = { x = 0, y = 0 }, draw_hand = true, kind = "InverseTarot", discovered = false, loc_txt = get_booster_loc("Paquete Tarot Inverso", "Inverse Tarot Pack", "Tarot Inverso", "Inverse Tarot"),
    loc_vars = function(self, info_queue, card) return { vars = { (card and card.ability) and card.ability.choose or self.config.choose, (card and card.ability) and card.ability.extra or self.config.extra } } end,
    create_card = function(self, card, i)
        local keys, weights = get_pool_keys_and_weights("InverseTarot")
        return { key = get_weighted_pack_card(i, keys, weights, 'invtarot_inst31_card'), set = "InverseTarot", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "invtarot_inst31" }
    end,
    particles = function(self) G.booster_pack_sparkles = Particles(1, 1, 0, 0, { timer = 0.015, scale = 0.2, initialize = true, lifespan = 1, speed = 1.1, padding = -1, attach = G.ROOM_ATTACH, colours = { G.C.WHITE, lighten(G.C.PURPLE, 0.4), lighten(G.C.PURPLE, 0.2) }, fill = true }) G.booster_pack_sparkles.fade_alpha = 1 G.booster_pack_sparkles:fade(1, 0) end
}

SMODS.Booster {
    key = 'invtarot_instant_5_1', weight = 0.15, config = { extra = 5, choose = 1 }, cost = 6, atlas = "CustomBoosters", pos = { x = 2, y = 0 }, draw_hand = true, kind = "InverseTarot", discovered = false, loc_txt = get_booster_loc("Paquete Tarot Inverso Jumbo", "Jumbo Inverse Tarot Pack", "Tarot Inverso", "Inverse Tarot"),
    loc_vars = function(self, info_queue, card) return { vars = { (card and card.ability) and card.ability.choose or self.config.choose, (card and card.ability) and card.ability.extra or self.config.extra } } end,
    create_card = function(self, card, i)
        local keys, weights = get_pool_keys_and_weights("InverseTarot")
        return { key = get_weighted_pack_card(i, keys, weights, 'invtarot_inst51_card'), set = "InverseTarot", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "invtarot_inst51" }
    end,
    particles = function(self) G.booster_pack_sparkles = Particles(1, 1, 0, 0, { timer = 0.015, scale = 0.2, initialize = true, lifespan = 1, speed = 1.1, padding = -1, attach = G.ROOM_ATTACH, colours = { G.C.WHITE, lighten(G.C.PURPLE, 0.4), lighten(G.C.PURPLE, 0.2) }, fill = true }) G.booster_pack_sparkles.fade_alpha = 1 G.booster_pack_sparkles:fade(1, 0) end
}

SMODS.Booster {
    key = 'invtarot_instant_5_2', weight = 0.1, config = { extra = 5, choose = 2 }, cost = 8, atlas = "CustomBoosters", pos = { x = 4, y = 0 }, draw_hand = true, kind = "InverseTarot", discovered = false, loc_txt = get_booster_loc("Paquete Tarot Inverso Mega", "Mega Inverse Tarot Pack", "Tarot Inverso", "Inverse Tarot"),
    loc_vars = function(self, info_queue, card) return { vars = { (card and card.ability) and card.ability.choose or self.config.choose, (card and card.ability) and card.ability.extra or self.config.extra } } end,
    create_card = function(self, card, i)
        local keys, weights = get_pool_keys_and_weights("InverseTarot")
        return { key = get_weighted_pack_card(i, keys, weights, 'invtarot_inst52_card'), set = "InverseTarot", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "invtarot_inst52" }
    end,
    particles = function(self) G.booster_pack_sparkles = Particles(1, 1, 0, 0, { timer = 0.015, scale = 0.2, initialize = true, lifespan = 1, speed = 1.1, padding = -1, attach = G.ROOM_ATTACH, colours = { G.C.WHITE, lighten(G.C.PURPLE, 0.4), lighten(G.C.PURPLE, 0.2) }, fill = true }) G.booster_pack_sparkles.fade_alpha = 1 G.booster_pack_sparkles:fade(1, 0) end
}

SMODS.Booster {
    key = 'invtarot_store_3_1', weight = 0.2, config = { extra = 3, choose = 1 }, cost = 4, atlas = "CustomBoosters", pos = { x = 1, y = 0 }, draw_hand = true, select_card = "consumeables", discovered = false, loc_txt = get_booster_loc("Paquete Tarot Inverso", "Inverse Tarot Pack", "Tarot Inverso", "Inverse Tarot"),
    loc_vars = function(self, info_queue, card) return { vars = { (card and card.ability) and card.ability.choose or self.config.choose, (card and card.ability) and card.ability.extra or self.config.extra } } end,
    create_card = function(self, card, i)
        local keys, weights = get_pool_keys_and_weights("InverseTarot")
        return { key = get_weighted_pack_card(i, keys, weights, 'invtarot_store31_card'), set = "InverseTarot", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "invtarot_store31" }
    end,
    particles = function(self) G.booster_pack_sparkles = Particles(1, 1, 0, 0, { timer = 0.015, scale = 0.2, initialize = true, lifespan = 1, speed = 1.1, padding = -1, attach = G.ROOM_ATTACH, colours = { G.C.WHITE, lighten(G.C.PURPLE, 0.4), lighten(G.C.PURPLE, 0.2) }, fill = true }) G.booster_pack_sparkles.fade_alpha = 1 G.booster_pack_sparkles:fade(1, 0) end
}

SMODS.Booster {
    key = 'invtarot_store_5_1', weight = 0.15, config = { extra = 5, choose = 1 }, cost = 6, atlas = "CustomBoosters", pos = { x = 3, y = 0 }, draw_hand = true, select_card = "consumeables", discovered = false, loc_txt = get_booster_loc("Paquete Tarot Inverso Jumbo", "Jumbo Inverse Tarot Pack", "Tarot Inverso", "Inverse Tarot"),
    loc_vars = function(self, info_queue, card) return { vars = { (card and card.ability) and card.ability.choose or self.config.choose, (card and card.ability) and card.ability.extra or self.config.extra } } end,
    create_card = function(self, card, i)
        local keys, weights = get_pool_keys_and_weights("InverseTarot")
        return { key = get_weighted_pack_card(i, keys, weights, 'invtarot_store51_card'), set = "InverseTarot", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "invtarot_store51" }
    end,
    particles = function(self) G.booster_pack_sparkles = Particles(1, 1, 0, 0, { timer = 0.015, scale = 0.2, initialize = true, lifespan = 1, speed = 1.1, padding = -1, attach = G.ROOM_ATTACH, colours = { G.C.WHITE, lighten(G.C.PURPLE, 0.4), lighten(G.C.PURPLE, 0.2) }, fill = true }) G.booster_pack_sparkles.fade_alpha = 1 G.booster_pack_sparkles:fade(1, 0) end
}

SMODS.Booster {
    key = 'invtarot_store_5_2', weight = 0.1, config = { extra = 5, choose = 2 }, cost = 8, atlas = "CustomBoosters", pos = { x = 5, y = 0 }, draw_hand = true, select_card = "consumeables", discovered = false, loc_txt = get_booster_loc("Paquete Tarot Inverso Mega", "Mega Inverse Tarot Pack", "Tarot Inverso", "Inverse Tarot"),
    loc_vars = function(self, info_queue, card) return { vars = { (card and card.ability) and card.ability.choose or self.config.choose, (card and card.ability) and card.ability.extra or self.config.extra } } end,
    create_card = function(self, card, i)
        local keys, weights = get_pool_keys_and_weights("InverseTarot")
        return { key = get_weighted_pack_card(i, keys, weights, 'invtarot_store52_card'), set = "InverseTarot", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "invtarot_store52" }
    end,
    particles = function(self) G.booster_pack_sparkles = Particles(1, 1, 0, 0, { timer = 0.015, scale = 0.2, initialize = true, lifespan = 1, speed = 1.1, padding = -1, attach = G.ROOM_ATTACH, colours = { G.C.WHITE, lighten(G.C.PURPLE, 0.4), lighten(G.C.PURPLE, 0.2) }, fill = true }) G.booster_pack_sparkles.fade_alpha = 1 G.booster_pack_sparkles:fade(1, 0) end
}