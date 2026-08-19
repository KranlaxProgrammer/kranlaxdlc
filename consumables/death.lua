SMODS.Consumable {
    key = 'death',
    set = 'InverseTarot',
    pos = { x = 9, y = 1 },
    config = { extra = { copy_amount = 1 } },
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
        if #G.jokers.cards >= 1 then
            
            -- Copiar un Joker aleatorio y hacerlo Negativo
            local random_joker_to_copy = pseudorandom_element(G.jokers.cards, pseudoseed('death_copy'))
            
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.4,
                func = function()
                    play_sound('timpani')
                    used_card:juice_up(0.3, 0.5)
                    return true
                end
            }))
            
            G.E_MANAGER:add_event(Event({
                trigger = 'before', delay = 0.4,
                func = function()
                    local copied_joker = copy_card(random_joker_to_copy, nil, nil, nil, false)
                    copied_joker:start_materialize()
                    copied_joker:add_to_deck()
                    G.jokers:emplace(copied_joker)
                    copied_joker:set_edition('e_negative', true)
                    return true
                end
            }))
            
            -- Elegir un Joker aleatorio (que NO sea perecedero) para hacerlo Perecedero
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.4,
                func = function()
                    -- REWORK: Creamos una lista solo con los Jokers que NO tienen el sticker
                    local unperishable_jokers = {}
                    for _, j in ipairs(G.jokers.cards) do
                        if not j.ability.perishable then
                            table.insert(unperishable_jokers, j)
                        end
                    end
                    
                    -- Solo procedemos si hay al menos un Joker elegible en la nueva lista
                    if #unperishable_jokers > 0 then
                        -- Elegimos un Joker aleatorio estrictamente de la lista filtrada
                        local target_joker = pseudorandom_element(unperishable_jokers, pseudoseed('death_perish'))
                        
                        target_joker:flip()
                        play_sound('card1', 1.15)
                        target_joker:juice_up(0.3, 0.3)
                        
                        -- Aplicamos el sticker de forma directa y segura
                        target_joker.ability.perishable = true
                        target_joker.ability.perish_tally = G.GAME.perishable_jokers_tally or 5 
                        target_joker:set_cost()
                        
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after', delay = 0.25,
                            func = function()
                                target_joker:flip()
                                play_sound('tarot2', 0.85, 0.6)
                                target_joker:juice_up(0.3, 0.3)
                                return true
                            end
                        }))
                    end
                    
                    return true
                end
            }))
        end
    end,
    
    can_use = function(self, card)
        return #G.jokers.cards >= 1
    end
}