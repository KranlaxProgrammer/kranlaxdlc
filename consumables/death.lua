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
        if SMODS.showman and SMODS.showman('c_kranlaxs_' .. self.key) then return true end
        if not G.consumeables or not G.consumeables.cards then return true end
        for _, v in ipairs(G.consumeables.cards) do
            if v.config.center.key == 'c_kranlaxs_' .. self.key then return false end
        end
        return true
    end,
    
    use = function(self, card, area, copier)
        local used_card = copier or card
        if #G.jokers.cards >= 1 then
            
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
            
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.4,
                func = function()
                    local unperishable_jokers = {}
                    for _, j in ipairs(G.jokers.cards) do
                        if not j.ability.perishable then
                            table.insert(unperishable_jokers, j)
                        end
                    end
                    
                    if #unperishable_jokers > 0 then
                        local target_joker = pseudorandom_element(unperishable_jokers, pseudoseed('death_perish'))
                        
                        target_joker:flip()
                        play_sound('card1', 1.15)
                        target_joker:juice_up(0.3, 0.3)
                        
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