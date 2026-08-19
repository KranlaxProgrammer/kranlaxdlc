SMODS.Consumable{
    key = 'misery',
    set = 'UNOCards',
    cost = 4,
    unlocked = true,
    discovered = false,
    atlas = 'CustomConsumables', -- Ajusta a tu atlas de UNO
    pos = { x = 4, y = 3 }, -- Coordenadas de tu carta
    
    can_use = function(self, card)
        -- Solo se usa si estamos seleccionando mano y hay cartas en el mazo
        if G.STATE ~= G.STATES.SELECTING_HAND then return false end
        if G.deck and #G.deck.cards > 0 then return true end
        return false
    end,
    
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                
                -- FUNCIÓN CONSTRUCTORA DE BOTONES
                local function create_suit_button(label_text, choice_id, color)
                    local btn_config = {
                        align = "cm", minw = 4.5, minh = 1, padding = 0.1, r = 0.1, 
                        hover = true, 
                        colour = color, 
                        button = "misery_apply", -- Vincula con la función de abajo
                        id = choice_id, 
                        shadow = true
                    }
                    return {n=G.UIT.C, config={align="cm", padding=0.1}, nodes={
                        {n=G.UIT.C, config=btn_config, nodes={
                            {n=G.UIT.T, config={text=label_text, scale=0.4, colour=G.C.WHITE}}
                        }}
                    }}
                end

                -- CONSTRUCCIÓN DE LA VENTANA (UI)
                local t = {n=G.UIT.ROOT, config={align="cm", colour=G.C.CLEAR}, nodes={
                    {n=G.UIT.C, config={align="cm", r=0.2, colour=G.C.BLACK, padding=0.3, shadow=true}, nodes={
                        {n=G.UIT.R, config={align="cm", padding=0.2}, nodes={
                            {n=G.UIT.T, config={text="Elige el Palo a buscar", scale=0.5, colour=G.C.WHITE, shadow=true}}
                        }},
                        {n=G.UIT.R, config={align="cm", padding=0.1}, nodes={
                            create_suit_button("Picas", "Spades", G.C.BLUE),
                            create_suit_button("Corazones", "Hearts", G.C.RED)
                        }},
                        {n=G.UIT.R, config={align="cm", padding=0.1}, nodes={
                            create_suit_button("Tréboles", "Clubs", G.C.GREEN),
                            create_suit_button("Diamantes", "Diamonds", G.C.ORANGE)
                        }}
                    }}
                }}
                
                -- Despliega el menú en pantalla
                G.OVERLAY_MENU = UIBox{
                    definition = t,
                    config = {align="cm", offset = {x=0,y=0}, major = G.ROOM_ATTACH}
                }
                return true
            end
        }))
    end
}

-- ============================================================================
-- EL MOTOR DEL BOTÓN: Roba cartas hasta encontrar el palo
-- ============================================================================
G.FUNCS.misery_apply = function(e)
    local choice = e.config.id
    
    -- 1. Cerramos la ventana del menú para limpiar la pantalla
    if G.OVERLAY_MENU then
        G.OVERLAY_MENU:remove()
        G.OVERLAY_MENU = nil
    end
    
    -- 2. Ejecutamos el robo masivo
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.2,
        func = function()
            local cards_to_draw = 0
            
            -- Calculamos cuántas cartas necesitamos robar desde el tope del mazo
            for i = #G.deck.cards, 1, -1 do
                cards_to_draw = cards_to_draw + 1
                if G.deck.cards[i]:is_suit(choice) then
                    break
                end
            end
            
            -- Encolamos el robo carta por carta para no crashear las animaciones
            for i = 1, cards_to_draw do
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.15,
                    func = function()
                        if G.deck.cards[#G.deck.cards] then
                            draw_card(G.deck, G.hand, i * 100 / cards_to_draw, 'up', true)
                        end
                        return true
                    end
                }))
            end
            
            -- Ordenamos la mano visualmente al terminar de robar todo
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.3,
                func = function()
                    G.hand:sort()
                    return true
                end
            }))
            
            play_sound('tarot1')
            return true
        end
    }))
end