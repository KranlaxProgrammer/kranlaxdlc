SMODS.Voucher {
    key = 'hotfix',
    atlas = 'CustomVouchers',
    pos = { x = 2, y = 0 }, 
    cost = 20,
    unlocked = true,
    discovered = false,
    in_pool = function(self) return not G.GAME.used_vouchers[self.key] end
}

if not SMODS.kranlaxs_hotfix_hook then
    local orig_reroll = G.FUNCS.reroll_shop
    G.FUNCS.reroll_shop = function(e)
        orig_reroll(e)
        
        if G.GAME and G.GAME.used_vouchers and G.GAME.used_vouchers['v_kranlaxs_hotfix'] then
            -- Reabastecer solo Paquetes Potenciadores (Boosters)
            if G.shop_booster and G.shop_booster.cards then
                for i = #G.shop_booster.cards, 1, -1 do
                    local c = G.shop_booster.cards[i]
                    c:remove()
                end
                
                local b_limit = G.shop_booster.config.card_limit or 2
                for i = 1, b_limit do
                    local b = create_card('Booster', G.shop_booster)
                    create_shop_card_ui(b, 'Booster', G.shop_booster)
                    b:add_to_deck()
                    G.shop_booster:emplace(b)
                end
            end
        end
    end
    SMODS.kranlaxs_hotfix_hook = true
end