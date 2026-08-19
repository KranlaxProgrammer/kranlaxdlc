SMODS.Consumable {
    key = 'thechariot',
    set = 'InverseTarot',
    pos = { x = 3, y = 1 },
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
                local _rank = pseudorandom_element(SMODS.Ranks, pseudoseed('chariot_rank')).card_key
                local new_card = SMODS.add_card({
                    set = "Base",
                    rank = _rank,
                    enhancement = 'm_steel'
                })
                if new_card then
                    new_card:set_seal('Red', true, true)
                end
                SMODS.calculate_context({ playing_card_added = true, cards = {new_card} })
                return true
            end
        }))
    end,
    
    can_use = function(self, card)
        return true
    end
}