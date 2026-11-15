SMODS.Consumable{
    key = 'gift',
    set = 'UNOCards',
    cost = 4,
    unlocked = true,
    discovered = false,
    atlas = 'CustomConsumables', 
    pos = { x = 1, y = 3 }, 

    in_pool = function(self, args)
        if SMODS.showman and SMODS.showman('c_kranlaxs_' .. self.key) then return true end
        if not G.consumeables or not G.consumeables.cards then return true end
        for _, v in ipairs(G.consumeables.cards) do
            if v.config.center.key == 'c_kranlaxs_' .. self.key then return false end
        end
        return true
    end,
    
    can_use = function(self, card)
        return true
    end,
    
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                card:juice_up(0.3, 0.5)

                -- Solo iniciamos con la opción 3 (Consumible garantizado si no hay espacio o no estamos en ciega)
                local options = {3}
                
                -- Agregamos la opción 1 (Joker) solo si hay espacio
                if G.jokers and #G.jokers.cards < G.jokers.config.card_limit then
                    table.insert(options, 1)
                end

                -- Agregamos la opción 2 (Carta de Juego) SÓLO si estamos dentro de una Ciega
                if G.STATE == G.STATES.SELECTING_HAND then
                    table.insert(options, 2)
                end

                local choice = pseudorandom_element(options, pseudoseed('uno_gift_choice'))

                if choice == 1 then
                    local valid_jokers = {}
                    for k, v in pairs(G.P_CENTERS) do
                        if v.set == 'Joker' and v.unlocked and not v.no_collection and not v.hidden then
                            table.insert(valid_jokers, k)
                        end
                    end
                    local forced_key = pseudorandom_element(valid_jokers, pseudoseed('uno_gift_joker'))
                    
                    local new_card = create_card('Joker', G.jokers, nil, nil, nil, nil, forced_key, 'uno_gift')
                    local edition = poll_edition('gift_ed', nil, true, true)
                    new_card:set_edition(edition, true)
                    
                    new_card:add_to_deck()
                    G.jokers:emplace(new_card)

                elseif choice == 2 then
                    local front = pseudorandom_element(G.P_CARDS, pseudoseed('gift_front'))
                    local new_card = Card(G.play.T.x, G.play.T.y, G.CARD_W, G.CARD_H, front, G.P_CENTERS.c_base, {playing_card = G.playing_card})
                    
                    local edition = poll_edition('gift_ed2', nil, true, true)
                    new_card:set_edition(edition, true)
                    
                    local enh = SMODS.poll_enhancement({key = 'gift_enh', guaranteed = true})
                    new_card:set_ability(G.P_CENTERS[enh])
                    
                    local seal = SMODS.poll_seal({key = 'gift_seal', guaranteed = true})
                    new_card:set_seal(seal)
                    
                    new_card:start_materialize()
                    table.insert(G.playing_cards, new_card)
                    
                    if G.hand then
                        G.hand:emplace(new_card)
                        G.hand:sort()
                    end

                elseif choice == 3 then
                    local valid_consumables = {}
                    for k, v in pairs(G.P_CENTERS) do
                        if v.consumeable and v.unlocked and not v.no_collection and not v.hidden then
                            table.insert(valid_consumables, k)
                        end
                    end
                    local forced_key = pseudorandom_element(valid_consumables, pseudoseed('uno_gift_cons'))
                    
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