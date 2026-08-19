SMODS.Consumable {
    key = 'thewheeloffortune',
    set = 'InverseTarot',
    pos = { x = 6, y = 1 },
    config = { 
        extra = {
            odds = 4,
            copy_amount = 1   
        } 
    },
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
    
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'c_kranlaxs_thewheeloffortune')
        return {vars = {numerator, denominator}}
    end,
    
    use = function(self, card, area, copier)
        local used_card = copier or card
        if #G.jokers.cards >= 1 then
            if SMODS.pseudorandom_probability(card, 'wheel_inverse', 1, card.ability.extra.odds) then
                
                local random_joker_to_copy = pseudorandom_element(G.jokers.cards, pseudoseed('wheel_copy'))
                
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
            else
                G.E_MANAGER:add_event(Event({
                    trigger = 'after', delay = 0.4,
                    func = function()
                        play_sound('tarot1')
                        used_card:juice_up(0.3, 0.5)
                        card_eval_status_text(used_card, 'extra', nil, nil, nil, {message = localize('k_nope_ex'), colour = G.C.RED})
                        return true
                    end
                }))
            end
        end
    end,
    
    can_use = function(self, card)
        return #G.jokers.cards >= 1
    end
}