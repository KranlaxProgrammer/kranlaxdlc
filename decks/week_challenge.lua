SMODS.Back {
    key = 'week_challenge',
    pos = { x = 1, y = 0 },
    unlocked = false,
    discovered = false,
    atlas = 'CustomDecks',
    
    check_for_unlock = function(self, args)
        local free_play = SMODS.Mods["kranlaxs"].config.free_weekly_deck
        local day = os.date("%w")
        if free_play or day == "0" or day == "6" then return true end
        return false
    end,
    
    loc_vars = function(self, info_queue, card)
        local free_play = SMODS.Mods["kranlaxs"].config.free_weekly_deck
        local d = os.date("*t").wday
        local is_weekend = free_play or (d == 1 or d == 7)
        
        if G.PROFILES and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].deck_usage then
            local deck_data = G.PROFILES[G.SETTINGS.profile].deck_usage['b_kranlaxs_week_challenge']
            if deck_data then deck_data.unlocked = is_weekend end
        end
        return {vars = {}}
    end,
    
    apply = function(self, back)
        local free_play = SMODS.Mods["kranlaxs"].config.free_weekly_deck
        local d = os.date("*t").wday
        local is_weekend = free_play or (d == 1 or d == 7)

        if not is_weekend then
            G.E_MANAGER:add_event(Event({
                delay = 1.0,
                func = function()
                    attention_text({text="¡No es fin de semana!", scale=0.9, hold=1.5, colour=G.C.RED, align='cm', offset={x=0,y=-1.5}})
                    if G.STAGE == G.STAGES.RUN then 
                        G.STATE = G.STATES.GAME_OVER
                        G.STATE_COMPLETE = false
                    end
                    return true
                end
            }))
            return
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.1,
            func = function()
                -- 1. Otorgar Vales Vainilla de Renovar (Surplus y Glut) y de Inventario (Overstock y Overstock Plus)
                local vouchers_to_apply = {'v_reroll_surplus', 'v_reroll_glut', 'v_overstock_norm', 'v_overstock_plus'}
                for _, v_key in ipairs(vouchers_to_apply) do
                    if G.P_CENTERS[v_key] then
                        G.GAME.used_vouchers[v_key] = true
                        local v_card = Card(G.play.T.x, G.play.T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, G.P_CENTERS[v_key])
                        v_card:apply_to_run()
                        v_card:remove()
                    end
                end
                
                -- 2. Otorgar 2 Cartas Espectrales 'El Juicio' (Vanilla)
                for i = 1, 2 do
                    local card = create_card('Spectral', G.consumeables, nil, nil, nil, nil, 'c_judgement', 'week_start')
                    card:add_to_deck()
                    G.consumeables:emplace(card)
                end
                
                -- 3. Inicializar la memoria del loadout inactivo
                G.GAME.kranlaxs_week_loadout = {}
                G.GAME.week_shop_swapped = false
                
                return true
            end
        }))
    end
}

-- Hook global exclusivo para el Loadout de la Baraja Semanal
if not SMODS.kranlaxs_week_loadout_hook then
    local orig_update = Game.update
    function Game:update(dt)
        if orig_update then orig_update(self, dt) end
        
        if G.GAME and G.GAME.selected_back and G.GAME.selected_back.effect.center.key == 'b_kranlaxs_week_challenge' then
            
            -- ¡Clave de la solución! Reiniciamos la bandera SÓLO cuando pasamos a la siguiente ciega o mano.
            if G.STATE == G.STATES.BLIND_SELECT or G.STATE == G.STATES.DRAW_TO_HAND then
                G.GAME.week_shop_swapped = false
            end
            
            -- Detectamos cuando el estado principal del juego es la Tienda
            if G.STATE == G.STATES.SHOP then
                -- Aseguramos que el swap se haga estrictamente 1 vez
                if not G.GAME.week_shop_swapped then
                    G.GAME.week_shop_swapped = true
                    
                    G.GAME.kranlaxs_week_loadout = G.GAME.kranlaxs_week_loadout or {}
                    
                    -- A. Guardar y Remover Comodines Actuales
                    local temp_serialized = {}
                    if G.jokers and G.jokers.cards then
                        for i = #G.jokers.cards, 1, -1 do
                            local j = G.jokers.cards[i]
                            table.insert(temp_serialized, j:save())
                            j:remove() -- Se destruye silenciosamente sin activar efectos
                        end
                    end
                    
                    -- B. Cargar y Crear Comodines del otro Loadout
                    for i = 1, #G.GAME.kranlaxs_week_loadout do
                        local saved_data = G.GAME.kranlaxs_week_loadout[i]
                        local center = G.P_CENTERS[saved_data.center] or G.P_CENTERS['j_joker']
                        local new_joker = Card(G.jokers.T.x, G.jokers.T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, center)
                        
                        new_joker:load(saved_data)
                        new_joker:add_to_deck()
                        G.jokers:emplace(new_joker)
                    end
                    
                    -- C. Guardar el grupo actual como el nuevo loadout inactivo
                    G.GAME.kranlaxs_week_loadout = temp_serialized
                    
                    -- Feedback visual
                    play_sound('cardSlide1', 1.0, 1.0)
                    play_sound('tarot1')
                    
                    if G.jokers then
                        attention_text({
                            text = "¡Loadout Cambiado!",
                            scale = 0.5, 
                            hold = 2,
                            colour = G.C.PURPLE,
                            align = 'cm',
                            offset = {x = 0, y = -2},
                            major = G.jokers
                        })
                    end
                end
            end
        end
    end
    SMODS.kranlaxs_week_loadout_hook = true
end