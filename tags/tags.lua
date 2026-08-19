SMODS.Tag {
    key = 'mega_invtarot',
    atlas = 'CustomTags', -- Recuerda cambiar esto por el atlas donde tengas el sprite de la etiqueta
    pos = { x = 0, y = 0 },       -- Coordenadas de tu sprite
    config = { type = 'new_blind_choice' }, -- Se activa al saltar una ciega
    
    loc_vars = function(self, info_queue)
        -- Esto asegura que al pasar el cursor sobre la etiqueta, 
        -- el jugador pueda leer la descripción del paquete que va a recibir
        info_queue[#info_queue + 1] = G.P_CENTERS.p_kranlaxs_invtarot_instant_5_2
        return { vars = {} }
    end,
    
    apply = function(self, tag, context)
        if context.type == 'new_blind_choice' then
            -- 1. BLOQUEO: Pausa el juego para que otras etiquetas esperen su turno
            local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
            
            -- 2. ANIMACIÓN: La etiqueta hace su animación de "¡Sí!" y reproduce el sonido
            tag:yep("+", G.C.PURPLE, function()
                local key = "p_kranlaxs_invtarot_instant_5_2"
                
                -- 3. CARTA VIRTUAL: Crea el paquete físicamente pero de forma automatizada
                local card = Card(
                    G.play.T.x + G.play.T.w / 2 - G.CARD_W * 1.27 / 2,
                    G.play.T.y + G.play.T.h / 2 - G.CARD_H * 1.27 / 2,
                    G.CARD_W * 1.27,
                    G.CARD_H * 1.27,
                    G.P_CARDS.empty,
                    G.P_CENTERS[key],
                    { bypass_discovery_center = true, bypass_discovery_ui = true }
                )
                card.cost = 0
                card.from_tag = true
                
                -- 4. APERTURA NATIVA: Le dice al juego "Abre esta carta como si el jugador la hubiera usado"
                G.FUNCS.use_card({ config = { ref_table = card } })
                
                -- Genera las partículas y muestra el paquete
                card:start_materialize()
                
                -- 5. DESBLOQUEO: Libera la pausa para que el juego continúe con normalidad
                G.CONTROLLER.locks[lock] = nil
                return true
            end)
            
            tag.triggered = true
            return true
        end
    end
}

-- ============================================================================
-- ETIQUETA: PAQUETE UNO JUMBO
-- ============================================================================
SMODS.Tag {
    key = 'mega_uno',
    atlas = 'CustomTags', 
    pos = { x = 1, y = 0 }, -- Cambia la coordenada X/Y según tu Sprite Sheet
    config = { type = 'new_blind_choice' },
    
    loc_vars = function(self, info_queue)
        info_queue[#info_queue + 1] = G.P_CENTERS.p_kranlaxs_uno_store_5
        return { vars = {} }
    end,
    
    apply = function(self, tag, context)
        if context.type == 'new_blind_choice' then
            local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
            
            -- Color rojo para la animación de UNO
            tag:yep("+", G.C.RED, function()
                local key = "p_kranlaxs_uno_store_5"
                
                local card = Card(
                    G.play.T.x + G.play.T.w / 2 - G.CARD_W * 1.27 / 2,
                    G.play.T.y + G.play.T.h / 2 - G.CARD_H * 1.27 / 2,
                    G.CARD_W * 1.27,
                    G.CARD_H * 1.27,
                    G.P_CARDS.empty,
                    G.P_CENTERS[key],
                    { bypass_discovery_center = true, bypass_discovery_ui = true }
                )
                card.cost = 0
                card.from_tag = true
                
                G.FUNCS.use_card({ config = { ref_table = card } })
                card:start_materialize()
                
                G.CONTROLLER.locks[lock] = nil
                return true
            end)
            
            tag.triggered = true
            return true
        end
    end
}

-- ============================================================================
-- ETIQUETA: MEGA PAQUETE TAROT INVERSO (GUARDADO)
-- ============================================================================
SMODS.Tag {
    key = 'mega_invtarot_store',
    atlas = 'CustomTags', 
    pos = { x = 2, y = 0 }, -- Cambia la coordenada X/Y según tu Sprite Sheet
    config = { type = 'new_blind_choice' },
    
    loc_vars = function(self, info_queue)
        info_queue[#info_queue + 1] = G.P_CENTERS.p_kranlaxs_invtarot_store_5_2
        return { vars = {} }
    end,
    
    apply = function(self, tag, context)
        if context.type == 'new_blind_choice' then
            local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
            
            tag:yep("+", G.C.PURPLE, function()
                local key = "p_kranlaxs_invtarot_store_5_2"
                
                local card = Card(
                    G.play.T.x + G.play.T.w / 2 - G.CARD_W * 1.27 / 2,
                    G.play.T.y + G.play.T.h / 2 - G.CARD_H * 1.27 / 2,
                    G.CARD_W * 1.27,
                    G.CARD_H * 1.27,
                    G.P_CARDS.empty,
                    G.P_CENTERS[key],
                    { bypass_discovery_center = true, bypass_discovery_ui = true }
                )
                card.cost = 0
                card.from_tag = true
                
                G.FUNCS.use_card({ config = { ref_table = card } })
                card:start_materialize()
                
                G.CONTROLLER.locks[lock] = nil
                return true
            end)
            
            tag.triggered = true
            return true
        end
    end
}

-- ============================================================================
-- ETIQUETA: CUARZO ALEATORIO (Desde Apuesta 2)
-- ============================================================================
SMODS.Tag {
    key = 'quartz_tag',
    atlas = 'CustomTags',
    pos = { x = 3, y = 0 }, -- Cambia la coordenada X/Y según tu Sprite Sheet
    min_ante = 2,
    config = { type = 'immediate' },
    
    -- 1. RESTRICCIÓN DE APARICIÓN: La etiqueta no aparece si no tienes cuarzos
    in_pool = function(self, args)
        local unlocked_quartzes = 0
        if G.P_CENTERS then
            for k, v in pairs(G.P_CENTERS) do
                if v.set == 'Quartz' and not v.no_pool and v.unlocked then
                    unlocked_quartzes = unlocked_quartzes + 1
                end
            end
        end
        return unlocked_quartzes > 0
    end,
    
    loc_vars = function(self, info_queue)
        return { vars = {} }
    end,
    
    apply = function(self, tag, context)
        if context.type == 'immediate' then
            -- 2. VERIFICACIÓN DE ESPACIO (El código que ya tenías está perfecto)
            if G.consumeables and #G.consumeables.cards < G.consumeables.config.card_limit then
                local lock = tag.ID
                G.CONTROLLER.locks[lock] = true
                
                tag:yep("+", G.C.PURPLE, function()
                    local valid_cards = {}
                    
                    -- 3. FILTRO DE DESBLOQUEO: Solo agrega a la ruleta los cuarzos que sí tengas desbloqueados
                    for k, v in pairs(G.P_CENTERS) do
                        if v.set == 'Quartz' and not v.no_pool and v.unlocked then
                            table.insert(valid_cards, k)
                        end
                    end
                    
                    -- Seguro por si acaso la lista se filtra correctamente
                    if #valid_cards > 0 then
                        local c_key = pseudorandom_element(valid_cards, pseudoseed('quartz_tag_gen'))
                        local card = create_card('Consumeables', G.consumeables, nil, nil, nil, nil, c_key, 'quartz_tag')
                        card:add_to_deck()
                        G.consumeables:emplace(card)
                    end
                    
                    G.CONTROLLER.locks[lock] = nil
                    return true
                end)
                
                tag.triggered = true
                return true
            else
                -- Si no hay espacio, la etiqueta hace la animación de "Nope" y se gasta
                tag:nope()
                tag.triggered = true
                return true
            end
        end
    end
}

-- ============================================================================
-- ETIQUETA: LIMPIADOR DE STICKERS (Desde Apuesta 3)
-- ============================================================================
SMODS.Tag {
    key = 'sticker_remover',
    atlas = 'CustomTags',
    pos = { x = 4, y = 0 }, 
    min_ante = 3,
    config = { type = 'immediate' },
    
    loc_vars = function(self, info_queue)
        return { vars = {} }
    end,
    
    apply = function(self, tag, context)
        if context.type == 'immediate' then
            local eligible_jokers = {}
            
            if G.jokers and G.jokers.cards then
                for _, v in ipairs(G.jokers.cards) do
                    if v.ability.eternal or v.ability.perishable or v.ability.rental then
                        table.insert(eligible_jokers, v)
                    end
                end
            end
            
            if #eligible_jokers > 0 then
                local lock = tag.ID
                G.CONTROLLER.locks[lock] = true
                
                tag:yep("- Sticker", G.C.ATTENTION, function()
                    local card = pseudorandom_element(eligible_jokers, pseudoseed('cleanser_joker'))
                    
                    local stickers = {}
                    if card.ability.eternal then table.insert(stickers, 'eternal') end
                    if card.ability.perishable then table.insert(stickers, 'perishable') end
                    if card.ability.rental then table.insert(stickers, 'rental') end
                    
                    local picked = pseudorandom_element(stickers, pseudoseed('cleanser_sticker'))
                    
                    -- Aplicamos exactamente tu método de limpieza (con nil)
                    if picked == 'eternal' then
                        card.ability.eternal = nil
                    elseif picked == 'perishable' then
                        card.ability.perishable = nil
                        card.ability.perish_tally = G.GAME.perishable_jokers_tally or 5
                        card.debuff = false 
                    elseif picked == 'rental' then
                        card.ability.rental = nil
                    end
                    
                    -- Forzamos la actualización visual usando tu método
                    card:set_cost()
                    
                    card:juice_up(0.3, 0.5)
                    play_sound('tarot1')
                    G.CONTROLLER.locks[lock] = nil
                    return true
                end)
                tag.triggered = true
                return true
            else
                local lock = tag.ID
                G.CONTROLLER.locks[lock] = true
                tag:yep("+$5", G.C.MONEY, function()
                    ease_dollars(5)
                    G.CONTROLLER.locks[lock] = nil
                    return true
                end)
                tag.triggered = true
                return true
            end
        end
    end
}

-- ============================================================================
-- ETIQUETA: LEGENDARIA GRATIS EN TIENDA (Desde Apuesta 8)
-- ============================================================================
SMODS.Tag {
    key = 'legendary',
    atlas = 'CustomTags',
    pos = { x = 5, y = 0 }, -- Cambia la coordenada X/Y según tu Sprite Sheet
    min_ante = 8,
    config = { type = 'store_joker_create' },
    
    loc_vars = function(self, info_queue)
        return { vars = {} }
    end,
    
    apply = function(self, tag, context)
        -- Usamos el evento de inyección de la tienda
        if context.type == 'store_joker_create' then
            -- El tercer argumento en create_card ("true") fuerza la creación de un Comodín Legendario (Alma)
            local card = create_card("Joker", context.area, true, nil, nil, nil, nil, "legendary_tag")
            create_shop_card_ui(card, "Joker", context.area)
            card.states.visible = false
            
            tag:yep("Legendaria", G.C.RARITY[4], function()
                card:start_materialize()
                card.ability.couponed = true -- Le aplica el aspecto visual de "Gratis"
                card:set_cost()
                card.cost = 0 -- Fuerza el precio a 0
                return true
            end)
            
            tag.triggered = true
            return card -- Retornamos la carta para que la tienda la muestre en el mostrador
        end
    end
}