local function get_weighted_pack_card(i, keys, weights, seed)
    if i == 1 then G.GAME.kranlaxs_current_pack_used = {} end
    G.GAME.kranlaxs_current_pack_used = G.GAME.kranlaxs_current_pack_used or {}
    local available_keys = {}
    local available_weights = {}
    local total_weight = 0
    for j, k in ipairs(keys) do
        local can_add = true
        if G.GAME.kranlaxs_current_pack_used[k] then can_add = false end
        if can_add and G.consumeables and G.consumeables.cards then
            for _, v in ipairs(G.consumeables.cards) do
                if v.config.center.key == k then can_add = false break end
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
            if not G.GAME.kranlaxs_current_pack_used[k] then
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

-- ==========================================
-- TRADUCTOR DINÁMICO DE PAQUETES
-- ==========================================
local is_es = (G.SETTINGS.language == 'es_419' or G.SETTINGS.language == 'es_ES')

local function get_booster_loc(name_es, name_en, type_es, type_en)
    return {
        name = is_es and name_es or name_en,
        text = {
            is_es and "Elige {C:attention}#1#{} de hasta" or "Choose {C:attention}#1#{} of up to",
            is_es and ("{C:attention}#2#{} cartas de {C:attention}" .. type_es .. "{} para") or ("{C:attention}#2#{C:attention} " .. type_en .. "{} cards to"),
            is_es and "añadir a tus consumibles" or "add to your consumable area"
        }
    }
end

-- ==========================================
-- PAQUETES DE UNO
-- ==========================================
SMODS.Booster {
    key = 'uno_store_3',
    config = { extra = 3, choose = 1 },
    kind = "UNO",
    cost = 4, atlas = "CustomBoosters", pos = { x = 6, y = 0 },
    draw_hand = true, select_card = "consumeables", discovered = false,
    loc_txt = get_booster_loc("Paquete UNO", "UNO Pack", "UNO", "UNO"),
    loc_vars = function(self, info_queue, card) return { vars = { (card and card.ability) and card.ability.choose or self.config.choose, (card and card.ability) and card.ability.extra or self.config.extra } } end,
    create_card = function(self, card, i)
        local weights = { 2, 2.2, 2.25, 2.25, 2.35, 2.6 }
        local keys = { "c_kranlaxs_skip", "c_kranlaxs_reverse", "c_kranlaxs_draw4", "c_kranlaxs_draw2", "c_kranlaxs_wildcard", "c_kranlaxs_stacking" }
        local key = get_weighted_pack_card(i, keys, weights, 'uno_store_3_card')
        return { key = key, set = "UNOCards", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "uno_store_3" }
    end,
    particles = function(self) G.booster_pack_sparkles = Particles(1, 1, 0, 0, { timer = 0.015, scale = 0.2, initialize = true, lifespan = 1, speed = 1.1, padding = -1, attach = G.ROOM_ATTACH, colours = { G.C.WHITE, lighten(G.C.RED, 0.4), lighten(G.C.YELLOW, 0.2) }, fill = true }) G.booster_pack_sparkles.fade_alpha = 1 G.booster_pack_sparkles:fade(1, 0) end,
    particles_bg = 'music_uno'
}

SMODS.Booster {
    key = 'uno_store_5',
    config = { extra = 5, choose = 1 },
    kind = "UNO",
    cost = 6, atlas = "CustomBoosters", pos = { x = 7, y = 0 },
    draw_hand = true, select_card = "consumeables", discovered = false,
    loc_txt = get_booster_loc("Paquete UNO Jumbo", "Jumbo UNO Pack", "UNO", "UNO"),
    loc_vars = function(self, info_queue, card) return { vars = { (card and card.ability) and card.ability.choose or self.config.choose, (card and card.ability) and card.ability.extra or self.config.extra } } end,
    create_card = function(self, card, i)
        local weights = { 2, 2.2, 2.25, 2.25, 2.35, 2.6 }
        local keys = { "c_kranlaxs_skip", "c_kranlaxs_reverse", "c_kranlaxs_draw4", "c_kranlaxs_draw2", "c_kranlaxs_wildcard", "c_kranlaxs_stacking" }
        local key = get_weighted_pack_card(i, keys, weights, 'uno_store_5_card')
        return { key = key, set = "UNOCards", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "uno_store_5" }
    end,
    particles = function(self) G.booster_pack_sparkles = Particles(1, 1, 0, 0, { timer = 0.015, scale = 0.2, initialize = true, lifespan = 1, speed = 1.1, padding = -1, attach = G.ROOM_ATTACH, colours = { G.C.WHITE, lighten(G.C.RED, 0.4), lighten(G.C.YELLOW, 0.2) }, fill = true }) G.booster_pack_sparkles.fade_alpha = 1 G.booster_pack_sparkles:fade(1, 0) end,
    particles_bg = 'music_uno'
}

-- ==========================================
-- PAQUETES DE TAROT INVERSO (INSTANT)
-- ==========================================
SMODS.Booster {
    key = 'invtarot_instant_3_1',
    config = { extra = 3, choose = 1 },
    cost = 4, atlas = "CustomBoosters", pos = { x = 0, y = 0 },
    draw_hand = true, kind = "InverseTarot", discovered = false,
    loc_txt = get_booster_loc("Paquete Tarot Inverso", "Inverse Tarot Pack", "Tarot Inverso", "Inverse Tarot"),
    loc_vars = function(self, info_queue, card) return { vars = { (card and card.ability) and card.ability.choose or self.config.choose, (card and card.ability) and card.ability.extra or self.config.extra } } end,
    create_card = function(self, card, i)
        local weights = { 2.3, 2.6, 2.85, 2.25, 2.55, 2.65, 2.65, 2.5, 2.5, 2.45, 2.4, 2.45, 2.5, 2.45, 2.25, 2.25, 2.6, 2.35, 2.35, 2.85, 2.6 }
        local keys = { "c_kranlaxs_thefool", "c_kranlaxs_themagician", "c_kranlaxs_thehighpriestess", "c_kranlaxs_theempress", "c_kranlaxs_theemperor", "c_kranlaxs_thehierophant", "c_kranlaxs_thelovers", "c_kranlaxs_thechariot", "c_kranlaxs_justice", "c_kranlaxs_thehermit", "c_kranlaxs_thewheeloffortune", "c_kranlaxs_strenght", "c_kranlaxs_thehangedman", "c_kranlaxs_death", "c_kranlaxs_thedevil", "c_kranlaxs_thetower", "c_kranlaxs_thestars", "c_kranlaxs_themoon", "c_kranlaxs_theworld", "c_kranlaxs_thesun", "c_kranlaxs_judgement" }
        local key = get_weighted_pack_card(i, keys, weights, 'invtarot_inst31_card')
        return { key = key, set = "InverseTarot", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "invtarot_inst31" }
    end,
    particles = function(self) G.booster_pack_sparkles = Particles(1, 1, 0, 0, { timer = 0.015, scale = 0.2, initialize = true, lifespan = 1, speed = 1.1, padding = -1, attach = G.ROOM_ATTACH, colours = { G.C.WHITE, lighten(G.C.PURPLE, 0.4), lighten(G.C.PURPLE, 0.2) }, fill = true }) G.booster_pack_sparkles.fade_alpha = 1 G.booster_pack_sparkles:fade(1, 0) end,
    particles_bg = 'music_inverse'
}

SMODS.Booster {
    key = 'invtarot_instant_5_1',
    config = { extra = 5, choose = 1 },
    cost = 6, atlas = "CustomBoosters", pos = { x = 2, y = 0 },
    draw_hand = true, kind = "InverseTarot", discovered = false,
    loc_txt = get_booster_loc("Paquete Tarot Inverso Jumbo", "Jumbo Inverse Tarot Pack", "Tarot Inverso", "Inverse Tarot"),
    loc_vars = function(self, info_queue, card) return { vars = { (card and card.ability) and card.ability.choose or self.config.choose, (card and card.ability) and card.ability.extra or self.config.extra } } end,
    create_card = function(self, card, i)
        local weights = { 2.3, 2.6, 2.85, 2.25, 2.55, 2.65, 2.65, 2.5, 2.5, 2.45, 2.4, 2.45, 2.5, 2.45, 2.25, 2.25, 2.6, 2.35, 2.35, 2.85, 2.6 }
        local keys = { "c_kranlaxs_thefool", "c_kranlaxs_themagician", "c_kranlaxs_thehighpriestess", "c_kranlaxs_theempress", "c_kranlaxs_theemperor", "c_kranlaxs_thehierophant", "c_kranlaxs_thelovers", "c_kranlaxs_thechariot", "c_kranlaxs_justice", "c_kranlaxs_thehermit", "c_kranlaxs_thewheeloffortune", "c_kranlaxs_strenght", "c_kranlaxs_thehangedman", "c_kranlaxs_death", "c_kranlaxs_thedevil", "c_kranlaxs_thetower", "c_kranlaxs_thestars", "c_kranlaxs_themoon", "c_kranlaxs_theworld", "c_kranlaxs_thesun", "c_kranlaxs_judgement" }
        local key = get_weighted_pack_card(i, keys, weights, 'invtarot_inst51_card')
        return { key = key, set = "InverseTarot", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "invtarot_inst51" }
    end,
    particles = function(self) G.booster_pack_sparkles = Particles(1, 1, 0, 0, { timer = 0.015, scale = 0.2, initialize = true, lifespan = 1, speed = 1.1, padding = -1, attach = G.ROOM_ATTACH, colours = { G.C.WHITE, lighten(G.C.PURPLE, 0.4), lighten(G.C.PURPLE, 0.2) }, fill = true }) G.booster_pack_sparkles.fade_alpha = 1 G.booster_pack_sparkles:fade(1, 0) end,
    particles_bg = 'music_inverse'
}

SMODS.Booster {
    key = 'invtarot_instant_5_2',
    config = { extra = 5, choose = 2 },
    cost = 8, atlas = "CustomBoosters", pos = { x = 4, y = 0 },
    draw_hand = true, kind = "InverseTarot", discovered = false,
    loc_txt = get_booster_loc("Paquete Tarot Inverso Mega", "Mega Inverse Tarot Pack", "Tarot Inverso", "Inverse Tarot"),
    loc_vars = function(self, info_queue, card) return { vars = { (card and card.ability) and card.ability.choose or self.config.choose, (card and card.ability) and card.ability.extra or self.config.extra } } end,
    create_card = function(self, card, i)
        local weights = { 2.3, 2.6, 2.85, 2.25, 2.55, 2.65, 2.65, 2.5, 2.5, 2.45, 2.4, 2.45, 2.5, 2.45, 2.25, 2.25, 2.6, 2.35, 2.35, 2.85, 2.6 }
        local keys = { "c_kranlaxs_thefool", "c_kranlaxs_themagician", "c_kranlaxs_thehighpriestess", "c_kranlaxs_theempress", "c_kranlaxs_theemperor", "c_kranlaxs_thehierophant", "c_kranlaxs_thelovers", "c_kranlaxs_thechariot", "c_kranlaxs_justice", "c_kranlaxs_thehermit", "c_kranlaxs_thewheeloffortune", "c_kranlaxs_strenght", "c_kranlaxs_thehangedman", "c_kranlaxs_death", "c_kranlaxs_thedevil", "c_kranlaxs_thetower", "c_kranlaxs_thestars", "c_kranlaxs_themoon", "c_kranlaxs_theworld", "c_kranlaxs_thesun", "c_kranlaxs_judgement" }
        local key = get_weighted_pack_card(i, keys, weights, 'invtarot_inst52_card')
        return { key = key, set = "InverseTarot", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "invtarot_inst52" }
    end,
    particles = function(self) G.booster_pack_sparkles = Particles(1, 1, 0, 0, { timer = 0.015, scale = 0.2, initialize = true, lifespan = 1, speed = 1.1, padding = -1, attach = G.ROOM_ATTACH, colours = { G.C.WHITE, lighten(G.C.PURPLE, 0.4), lighten(G.C.PURPLE, 0.2) }, fill = true }) G.booster_pack_sparkles.fade_alpha = 1 G.booster_pack_sparkles:fade(1, 0) end,
    particles_bg = 'music_inverse'
}

-- ==========================================
-- PAQUETES DE TAROT INVERSO (STORE)
-- ==========================================
SMODS.Booster {
    key = 'invtarot_store_3_1',
    config = { extra = 3, choose = 1 },
    cost = 4, atlas = "CustomBoosters", pos = { x = 1, y = 0 },
    draw_hand = true, select_card = "consumeables", discovered = false,
    loc_txt = get_booster_loc("Paquete Tarot Inverso", "Inverse Tarot Pack", "Tarot Inverso", "Inverse Tarot"),
    loc_vars = function(self, info_queue, card) return { vars = { (card and card.ability) and card.ability.choose or self.config.choose, (card and card.ability) and card.ability.extra or self.config.extra } } end,
    create_card = function(self, card, i)
        local weights = { 2.3, 2.6, 2.85, 2.25, 2.55, 2.65, 2.65, 2.5, 2.5, 2.45, 2.4, 2.45, 2.5, 2.45, 2.25, 2.25, 2.6, 2.35, 2.35, 2.85, 2.6 }
        local keys = { "c_kranlaxs_thefool", "c_kranlaxs_themagician", "c_kranlaxs_thehighpriestess", "c_kranlaxs_theempress", "c_kranlaxs_theemperor", "c_kranlaxs_thehierophant", "c_kranlaxs_thelovers", "c_kranlaxs_thechariot", "c_kranlaxs_justice", "c_kranlaxs_thehermit", "c_kranlaxs_thewheeloffortune", "c_kranlaxs_strenght", "c_kranlaxs_thehangedman", "c_kranlaxs_death", "c_kranlaxs_thedevil", "c_kranlaxs_thetower", "c_kranlaxs_thestars", "c_kranlaxs_themoon", "c_kranlaxs_theworld", "c_kranlaxs_thesun", "c_kranlaxs_judgement" }
        local key = get_weighted_pack_card(i, keys, weights, 'invtarot_store31_card')
        return { key = key, set = "InverseTarot", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "invtarot_store31" }
    end,
    particles = function(self) G.booster_pack_sparkles = Particles(1, 1, 0, 0, { timer = 0.015, scale = 0.2, initialize = true, lifespan = 1, speed = 1.1, padding = -1, attach = G.ROOM_ATTACH, colours = { G.C.WHITE, lighten(G.C.PURPLE, 0.4), lighten(G.C.PURPLE, 0.2) }, fill = true }) G.booster_pack_sparkles.fade_alpha = 1 G.booster_pack_sparkles:fade(1, 0) end,
    particles_bg = 'music_inverse'
}

SMODS.Booster {
    key = 'invtarot_store_5_1',
    config = { extra = 5, choose = 1 },
    cost = 6, atlas = "CustomBoosters", pos = { x = 3, y = 0 },
    draw_hand = true, select_card = "consumeables", discovered = false,
    loc_txt = get_booster_loc("Paquete Tarot Inverso Jumbo", "Jumbo Inverse Tarot Pack", "Tarot Inverso", "Inverse Tarot"),
    loc_vars = function(self, info_queue, card) return { vars = { (card and card.ability) and card.ability.choose or self.config.choose, (card and card.ability) and card.ability.extra or self.config.extra } } end,
    create_card = function(self, card, i)
        local weights = { 2.3, 2.6, 2.85, 2.25, 2.55, 2.65, 2.65, 2.5, 2.5, 2.45, 2.4, 2.45, 2.5, 2.45, 2.25, 2.25, 2.6, 2.35, 2.35, 2.85, 2.6 }
        local keys = { "c_kranlaxs_thefool", "c_kranlaxs_themagician", "c_kranlaxs_thehighpriestess", "c_kranlaxs_theempress", "c_kranlaxs_theemperor", "c_kranlaxs_thehierophant", "c_kranlaxs_thelovers", "c_kranlaxs_thechariot", "c_kranlaxs_justice", "c_kranlaxs_thehermit", "c_kranlaxs_thewheeloffortune", "c_kranlaxs_strenght", "c_kranlaxs_thehangedman", "c_kranlaxs_death", "c_kranlaxs_thedevil", "c_kranlaxs_thetower", "c_kranlaxs_thestars", "c_kranlaxs_themoon", "c_kranlaxs_theworld", "c_kranlaxs_thesun", "c_kranlaxs_judgement" }
        local key = get_weighted_pack_card(i, keys, weights, 'invtarot_store51_card')
        return { key = key, set = "InverseTarot", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "invtarot_store51" }
    end,
    particles = function(self) G.booster_pack_sparkles = Particles(1, 1, 0, 0, { timer = 0.015, scale = 0.2, initialize = true, lifespan = 1, speed = 1.1, padding = -1, attach = G.ROOM_ATTACH, colours = { G.C.WHITE, lighten(G.C.PURPLE, 0.4), lighten(G.C.PURPLE, 0.2) }, fill = true }) G.booster_pack_sparkles.fade_alpha = 1 G.booster_pack_sparkles:fade(1, 0) end,
    particles_bg = 'music_inverse'
}

SMODS.Booster {
    key = 'invtarot_store_5_2',
    config = { extra = 5, choose = 2 },
    cost = 8, atlas = "CustomBoosters", pos = { x = 5, y = 0 },
    draw_hand = true, select_card = "consumeables", discovered = false,
    loc_txt = get_booster_loc("Paquete Tarot Inverso Mega", "Mega Inverse Tarot Pack", "Tarot Inverso", "Inverse Tarot"),
    loc_vars = function(self, info_queue, card) return { vars = { (card and card.ability) and card.ability.choose or self.config.choose, (card and card.ability) and card.ability.extra or self.config.extra } } end,
    create_card = function(self, card, i)
        local weights = { 2.3, 2.6, 2.85, 2.25, 2.55, 2.65, 2.65, 2.5, 2.5, 2.45, 2.4, 2.45, 2.5, 2.45, 2.25, 2.25, 2.6, 2.35, 2.35, 2.85, 2.6 }
        local keys = { "c_kranlaxs_thefool", "c_kranlaxs_themagician", "c_kranlaxs_thehighpriestess", "c_kranlaxs_theempress", "c_kranlaxs_theemperor", "c_kranlaxs_thehierophant", "c_kranlaxs_thelovers", "c_kranlaxs_thechariot", "c_kranlaxs_justice", "c_kranlaxs_thehermit", "c_kranlaxs_thewheeloffortune", "c_kranlaxs_strenght", "c_kranlaxs_thehangedman", "c_kranlaxs_death", "c_kranlaxs_thedevil", "c_kranlaxs_thetower", "c_kranlaxs_thestars", "c_kranlaxs_themoon", "c_kranlaxs_theworld", "c_kranlaxs_thesun", "c_kranlaxs_judgement" }
        local key = get_weighted_pack_card(i, keys, weights, 'invtarot_store52_card')
        return { key = key, set = "InverseTarot", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "invtarot_store52" }
    end,
    particles = function(self) G.booster_pack_sparkles = Particles(1, 1, 0, 0, { timer = 0.015, scale = 0.2, initialize = true, lifespan = 1, speed = 1.1, padding = -1, attach = G.ROOM_ATTACH, colours = { G.C.WHITE, lighten(G.C.PURPLE, 0.4), lighten(G.C.PURPLE, 0.2) }, fill = true }) G.booster_pack_sparkles.fade_alpha = 1 G.booster_pack_sparkles:fade(1, 0) end,
    particles_bg = 'music_inverse'
}

-- ============================================================================
-- REPRODUCTOR DE MÚSICA PERSONALIZADA PARA PAQUETES
-- ============================================================================
if not SMODS.kranlaxs_bgm_hook then
    local orig_update_bgm = Game.update_bgm
    function Game:update_bgm(self)
        -- G.STATES.TAROT_PACK es el estado universal que usa Balatro al abrir CUALQUIER paquete
        if G.STATE == G.STATES.TAROT_PACK and G.GAME.pack_choices then
            
            -- Si es un paquete de UNO
            if G.GAME.pack_choices.kind == 'UNO' then
                -- Verificamos que la pista no esté sonando ya para no reiniciarla
                if self.BGM.current ~= 'kranlaxs_music_uno' then
                    self.BGM:set_music('kranlaxs_music_uno')
                end
                return -- ¡Cortamos la función aquí para que el juego base no ponga su música!
            end
            
            -- Si es un paquete de Tarot Inverso
            if G.GAME.pack_choices.kind == 'InverseTarot' then
                if self.BGM.current ~= 'kranlaxs_music_inverse' then
                    self.BGM:set_music('kranlaxs_music_inverse')
                end
                return -- Cortamos la función
            end
        end
        
        -- Si no estamos en tus paquetes (tienda, menú, juego normal), dejamos que Balatro decida
        orig_update_bgm(self)
    end
    SMODS.kranlaxs_bgm_hook = true
end