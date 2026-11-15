SMODS.Back {
    key = 'catalog_deck',
    atlas = 'CustomDecks',
    pos = { x = 9, y = 0 }, 
    unlocked = false,
    discovered = false,
    
    check_for_unlock = function(self, args)
        if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
            if (G.PROFILES[G.SETTINGS.profile].kranlaxs_jokers_bought or 0) >= 200 then return true end
        end
        return false
    end,

    locked_loc_vars = function(self, info_queue, card)
        local count = G.PROFILES and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].kranlaxs_jokers_bought or 0
        return { vars = { count } }
    end,

    loc_vars = function(self, info_queue, card)
        local count = G.PROFILES and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].kranlaxs_jokers_bought or 0
        return { vars = { count } }
    end,

    apply = function(self)
        G.GAME.starting_params.dollars = 0
        G.GAME.dollars = 0
        
        G.E_MANAGER:add_event(Event({
            func = function()
                change_shop_size(2)
                SMODS.change_voucher_limit(1)
                SMODS.change_booster_limit(1)
                return true
            end
        }))
    end
}

if not SMODS.kranlaxs_catalog_unlock_hook then
    local orig_buy = G.FUNCS.buy_from_shop
    G.FUNCS.buy_from_shop = function(e)
        local card = e.config.ref_table
        
        -- Verificamos si la carta a comprar estaba en la tienda base o en el mercado negro
        local was_in_shop = card and (card.area == G.shop_jokers or card.area == G.kranlaxs_bm_area)
        
        -- Ejecuta la compra del juego base
        orig_buy(e)
        
        -- Si era un comodín y estaba en la tienda, esperamos a que termine su animación de compra
        if card and card.ability and card.ability.set == 'Joker' and was_in_shop then
            G.E_MANAGER:add_event(Event({
                func = function()
                    -- Verificamos si la compra fue exitosa (la carta llegó a tu zona de Jokers)
                    if card.area == G.jokers then
                        if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
                            G.PROFILES[G.SETTINGS.profile].kranlaxs_jokers_bought = (G.PROFILES[G.SETTINGS.profile].kranlaxs_jokers_bought or 0) + 1
                            G:save_progress()
                        end
                    end
                    return true
                end
            }))
        end
    end
    SMODS.kranlaxs_catalog_unlock_hook = true
end