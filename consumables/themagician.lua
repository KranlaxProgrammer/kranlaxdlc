SMODS.Consumable {
    key = 'themagician',
    set = 'InverseTarot',
    pos = { x = 7, y = 0 },
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
        
        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.4,
            func = function()
                play_sound('tarot1')
                used_card:juice_up(0.3, 0.5)
                return true
            end
        }))

        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.2,
            func = function()
                local cards = {}
                for i = 1, 2 do
                    local _rank = pseudorandom_element(SMODS.Ranks, 'add_random_rank').card_key
                    local new_card = SMODS.add_card({
                        set = "Base",
                        rank = _rank,
                        enhancement = 'm_lucky'
                    })
                    cards[i] = new_card
                end
                SMODS.calculate_context({ playing_card_added = true, cards = cards })
                return true
            end
        }))
    end,
    
    can_use = function(self, card)
        -- Ahora se puede usar en la partida, en paquetes de cartas y en la tienda
        if G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SHOP then
            return true
        end
        return false
    end
}