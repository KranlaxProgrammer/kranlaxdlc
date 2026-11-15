SMODS.Consumable{
    key = 'customdraw',
    set = 'UNOCards',
    cost = 4,
    unlocked = true,
    discovered = false,
    atlas = 'CustomConsumables',
    pos = { x = 2, y = 3 },

    in_pool = function(self, args)
        if SMODS.showman and SMODS.showman('c_kranlaxs_' .. self.key) then return true end
        if not G.consumeables or not G.consumeables.cards then return true end
        for _, v in ipairs(G.consumeables.cards) do
            if v.config.center.key == 'c_kranlaxs_' .. self.key then return false end
        end
        return true
    end,
    
    loc_vars = function(self, info_queue, card)
        return {vars = {}}
    end,

    update = function(self, card, dt)
        if G.shop_jokers and G.shop_jokers.config.highlighted_limit == 0 then
            G.shop_jokers.config.highlighted_limit = 1
        end
    end,
    
    can_use = function(self, card)
        if G.STATE ~= G.STATES.SHOP then return false end
        if G.shop_jokers and G.shop_jokers.highlighted and #G.shop_jokers.highlighted == 1 then
            local target = G.shop_jokers.highlighted[1]
            -- FIX: Validar que la carta siga FÍSICAMENTE en la tienda y sea un Joker
            if target and target.area == G.shop_jokers and (target.ability.set == 'Joker' or target.config.center.set == 'Joker') then
                return true
            end
        end
        return false
    end,
    
    use = function(self, card, area, copier)
        local target = G.shop_jokers.highlighted[1]
        
        -- Doble validación de seguridad antes de moverla
        if target and target.area == G.shop_jokers then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.2,
                func = function()
                    target.highlighted = false
                    
                    -- Limpiamos etiquetas de precio y botones
                    if target.children.price then target.children.price:remove(); target.children.price = nil end
                    if target.children.buy_button then target.children.buy_button:remove(); target.children.buy_button = nil end
                    
                    G.shop_jokers:remove_card(target)
                    target:add_to_deck()
                    G.jokers:emplace(target)
                    
                    play_sound('tarot1')
                    target:juice_up(0.3, 0.5)
                    
                    return true
                end
            }))
        end
    end
}