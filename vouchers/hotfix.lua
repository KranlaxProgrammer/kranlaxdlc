SMODS.Voucher {
    key = 'hotfix',
    atlas = 'CustomVouchers',
    pos = { x = 2, y = 0 }, 
    cost = 15,
    unlocked = true,
    discovered = false,
    in_pool = function(self) return not G.GAME.used_vouchers[self.key] end,
    loc_txt = {
        name = 'Hotfix',
        text = {
            "Hacer {C:attention}Reroll{} en la tienda",
            "también actualiza los {C:attention}Vales{}",
            "y los {C:attention}Paquetes{}"
        }
    }
}

-- ==============================================================================
-- HOOK: Reroll de Vales y Boosters
-- ==============================================================================
if not SMODS.kranlaxs_hotfix_hook then
    local orig_reroll = G.FUNCS.reroll_shop
    G.FUNCS.reroll_shop = function(e)
        orig_reroll(e)
        
        if G.GAME and G.GAME.used_vouchers and G.GAME.used_vouchers['v_kranlaxs_hotfix'] then
            
            -- Reroll de Vales
            if G.shop_vouchers and G.shop_vouchers.cards then
                -- Borrado limpio para proteger los FPS
                for i = #G.shop_vouchers.cards, 1, -1 do
                    local c = G.shop_vouchers.cards[i]
                    c:remove()
                end
                
                local v_key = get_next_voucher_key()
                local v = create_card('Voucher', G.shop_vouchers, nil, nil, nil, nil, v_key)
                
                -- ¡LA MAGIA AQUÍ! Construye el precio y el botón de compra
                create_shop_card_ui(v, 'Voucher', G.shop_vouchers)
                
                v:add_to_deck()
                G.shop_vouchers:emplace(v)
            end
            
            -- Reroll de Paquetes
            if G.shop_booster and G.shop_booster.cards then
                -- Borrado limpio para proteger los FPS
                for i = #G.shop_booster.cards, 1, -1 do
                    local c = G.shop_booster.cards[i]
                    c:remove()
                end
                
                for i = 1, (G.GAME.shop.booster_max or 2) do
                    local b = create_card('Booster', G.shop_booster)
                    
                    -- ¡LA MAGIA AQUÍ! Construye el precio y el botón de compra
                    create_shop_card_ui(b, 'Booster', G.shop_booster)
                    
                    b:add_to_deck()
                    G.shop_booster:emplace(b)
                end
            end
        end
    end
    SMODS.kranlaxs_hotfix_hook = true
end