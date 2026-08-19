SMODS.Consumable{
    key = 'gift',
    set = 'UNOCards',
    cost = 4,
    unlocked = true,
    discovered = false,
    atlas = 'CustomConsumables', -- Ajusta a tu atlas de UNO
    pos = { x = 1, y = 3 }, -- Ajusta a la coordenada de la carta Gift
    
    can_use = function(self, card)
        -- Siempre la puedes usar, ya que la carta de póker y los consumibles 
        -- negativos siempre tienen espacio
        return true
    end,
    
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                card:juice_up(0.3, 0.5)

                local options = {2, 3}
                -- Solo agregamos la opción del Joker (1) a la ruleta si hay espacio en tu inventario
                if G.jokers and #G.jokers.cards < G.jokers.config.card_limit then
                    table.insert(options, 1)
                end

                local choice = pseudorandom_element(options, pseudoseed('uno_gift_choice'))

                if choice == 1 then
                    -- ====================================================
                    -- PREMIO 1: Joker aleatorio con edición garantizada
                    -- ====================================================
                    
                    -- Filtramos para que solo salgan Jokers desbloqueados, visibles y de la colección
                    local valid_jokers = {}
                    for k, v in pairs(G.P_CENTERS) do
                        if v.set == 'Joker' and v.unlocked and not v.no_collection and not v.hidden then
                            table.insert(valid_jokers, k)
                        end
                    end
                    local forced_key = pseudorandom_element(valid_jokers, pseudoseed('uno_gift_joker'))
                    
                    -- Forzamos la creación exacta de la carta que elegimos
                    local new_card = create_card('Joker', G.jokers, nil, nil, nil, nil, forced_key, 'uno_gift')
                    local edition = poll_edition('gift_ed', nil, true, true)
                    new_card:set_edition(edition, true)
                    
                    new_card:add_to_deck()
                    G.jokers:emplace(new_card)

                elseif choice == 2 then
                    -- ====================================================
                    -- PREMIO 2: Carta de póker con Edición, Mejora y Sello
                    -- ====================================================
                    local front = pseudorandom_element(G.P_CARDS, pseudoseed('gift_front'))
                    local new_card = Card(G.play.T.x, G.play.T.y, G.CARD_W, G.CARD_H, front, G.P_CENTERS.c_base, {playing_card = G.playing_card})
                    
                    -- Le aplicamos la Edición (Foil, Holográfico, etc)
                    local edition = poll_edition('gift_ed2', nil, true, true)
                    new_card:set_edition(edition, true)
                    
                    -- Le aplicamos la Mejora (Cristal, Acero, Oro, etc)
                    local enh = SMODS.poll_enhancement({key = 'gift_enh', guaranteed = true})
                    new_card:set_ability(G.P_CENTERS[enh])
                    
                    -- Le aplicamos el Sello (Rojo, Azul, etc)
                    local seal = SMODS.poll_seal({key = 'gift_seal', guaranteed = true})
                    new_card:set_seal(seal)
                    
                    new_card:start_materialize()
                    table.insert(G.playing_cards, new_card)
                    
                    -- La enviamos directo a la mano actual
                    if G.hand then
                        G.hand:emplace(new_card)
                        G.hand:sort()
                    end

                elseif choice == 3 then
                    -- ====================================================
                    -- PREMIO 3: Consumible aleatorio Negativo
                    -- ====================================================
                    
                    -- Filtramos para evitar consumibles ocultos, bloqueados o no coleccionables
                    local valid_consumables = {}
                    for k, v in pairs(G.P_CENTERS) do
                        if v.consumeable and v.unlocked and not v.no_collection and not v.hidden then
                            table.insert(valid_consumables, k)
                        end
                    end
                    local forced_key = pseudorandom_element(valid_consumables, pseudoseed('uno_gift_cons'))
                    
                    -- Forzamos la creación exacta de ese consumible
                    local new_card = create_card('Consumeables', G.consumeables, nil, nil, nil, nil, forced_key, 'uno_gift')
                    new_card:set_edition({negative = true}, true)
                    
                    new_card:add_to_deck()
                    G.consumeables:emplace(new_card)
                end
                
                return true
            end
        }))
    end
}