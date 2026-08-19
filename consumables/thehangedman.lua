SMODS.Consumable {
    key = 'thehangedman',
    set = 'InverseTarot',
    pos = { x = 8, y = 1 },
    cost = 5,
    unlocked = true,
    discovered = false,
    hidden = false,
    can_repeat_soul = false,
    atlas = 'CustomConsumables',

    in_pool = function(self, args)
        -- Si el juego apenas está cargando y no hay barra de consumibles, lo permite
        if not G.consumeables or not G.consumeables.cards then return true end
        
        -- Escanea los consumibles que tienes guardados actualmente
        for _, v in ipairs(G.consumeables.cards) do
            -- Revisa si ya posees esta carta (usando el prefijo c_)
            if v.config.center.key == 'c_kranlaxs_' .. self.key then
                return false 
            end
        end
        
        return true
    end,
    
    use = function(self, card, area, copier)
        local used_card = copier or card
        if G.hand and #G.hand.cards > 0 then
            
            -- Seleccionar hasta 2 cartas al azar de la mano
            local temp_hand = {}
            for _, playing_card in ipairs(G.hand.cards) do temp_hand[#temp_hand + 1] = playing_card end
            pseudoshuffle(temp_hand, pseudoseed('hanged_random'))
            
            local affected_cards = {}
            for i = 1, math.min(2, #temp_hand) do 
                affected_cards[#affected_cards + 1] = temp_hand[i] 
            end
            
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.4,
                func = function()
                    play_sound('tarot1')
                    used_card:juice_up(0.3, 0.5)
                    for _, c in ipairs(affected_cards) do
                        c:flip()
                    end
                    play_sound('card1', 1)
                    return true
                end
            }))
            
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.3,
                func = function()
                    for _, c in ipairs(affected_cards) do
                        -- Rangos y Palos
                        local _rank = pseudorandom_element(SMODS.Ranks, pseudoseed('h_rank'))
                        local _suit = pseudorandom_element(SMODS.Suits, pseudoseed('h_suit'))
                        SMODS.change_base(c, _suit.key, _rank.key)
                        
                        -- Edición
                        local edition = pseudorandom_element({'e_foil','e_holo','e_polychrome','e_negative'}, pseudoseed('h_ed'))
                        c:set_edition(edition, true, true)
                        
                        -- Sello
                        local seal_pool = {'Gold','Red','Blue','Purple','kranlaxs_pinkseal','kranlaxs_grayseal'}
                        c:set_seal(pseudorandom_element(seal_pool, pseudoseed('h_seal')), true, true)
                        
                        -- Mejora (Evitamos Piedra para no borrar el palo/rango generado)
                        local cen_pool = {}
                        for _, enh in pairs(G.P_CENTER_POOLS["Enhanced"]) do
                            if enh.key ~= 'm_stone' then cen_pool[#cen_pool + 1] = enh end
                        end
                        c:set_ability(pseudorandom_element(cen_pool, pseudoseed('h_enh')), true, nil)
                    end
                    return true
                end
            }))
            
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.2,
                func = function()
                    for _, c in ipairs(affected_cards) do
                        c:flip()
                        c:juice_up(0.3, 0.3)
                    end
                    play_sound('tarot2', 1, 0.6)
                    return true
                end
            }))
        end
    end,
    
    can_use = function(self, card)
        return G.hand and #G.hand.cards > 0
    end
}