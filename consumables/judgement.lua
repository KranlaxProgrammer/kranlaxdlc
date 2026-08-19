SMODS.Consumable {
    key = 'judgement',
    set = 'InverseTarot',
    pos = { x = 2, y = 2 },
    config = { extra = { hand_size0 = 1 } },
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
        local voucher_key = pseudorandom_element(G.P_CENTER_POOLS.Voucher, pseudoseed('judgement_voucher')).key
        local voucher_card = SMODS.create_card{area = G.play, key = voucher_key}
        
        voucher_card:start_materialize()
        voucher_card.cost = 0
        G.play:emplace(voucher_card)
        
        -- Canjea el Voucher
        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.8,
            func = function()
                voucher_card:redeem()
                return true
            end
        }))
        
        -- Destruye la carta visual del Voucher y aplica el debuff
        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.5,
            func = function()
                voucher_card:start_dissolve()
                card_eval_status_text(used_card, 'extra', nil, nil, nil, {message = "-1 Hand Limit", colour = G.C.BLUE})
                G.hand:change_size(-1)
                return true
            end
        }))
    end,
    
    can_use = function(self, card)
        return true
    end
}