SMODS.Joker{
    key = "couponstrip",
    config = { extra = { purchases = 10 } },
    pos = { x = 0, y = 0 },
    cost = 15,
    bm_cost = 5,
    rarity = "kranlaxs_zenith",
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',
    
    check_for_unlock = function(self, args)
        if G.GAME and G.GAME.kranlaxs_run_rerolls and G.GAME.kranlaxs_run_rerolls >= 30 then return true end
        return false
    end,

    locked_loc_vars = function(self, info_queue, card)
        local rr = G.GAME and G.GAME.kranlaxs_run_rerolls or 0
        return { vars = { rr } }
    end,

    loc_vars = function(self, info_queue, card)
        local rr = G.GAME and G.GAME.kranlaxs_run_rerolls or 0
        local purchases = card and card.ability and card.ability.extra and card.ability.extra.purchases or self.config.extra.purchases
        return { vars = { rr, purchases } }
    end,

    add_to_deck = function(self, card, from_debuff)
        calculate_reroll_cost(true)
    end,
    
    remove_from_deck = function(self, card, from_debuff)
        calculate_reroll_cost(true)
    end,

    calculate = function(self, card, context)
        if context.buying_card and not context.blueprint then
            card.ability.extra.purchases = card.ability.extra.purchases - 1
            
            if card.ability.extra.purchases <= 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.getting_sliced = true
                        card:start_dissolve()
                        
                        -- BANDERA DE EXTINCIÓN: Una vez destruido, jamás vuelve al Mercado Negro
                        if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
                            G.PROFILES[G.SETTINGS.profile].kranlaxs_coupon_dead = true
                            G:save_progress()
                        end
                        return true
                    end
                }))
            else
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = card.ability.extra.purchases .. " usos", colour = G.C.GREEN})
                        return true
                    end
                }))
            end
        end
    end
}

if not SMODS.kranlaxs_coupon_hook then
    -- EVITAR VENTA: Prohíbe al jugador vender el comodín
    local orig_can_sell = Card.can_sell_card
    function Card:can_sell_card(context)
        if self.config and self.config.center and self.config.center.key == 'j_kranlaxs_couponstrip' then
            return false
        end
        if orig_can_sell then return orig_can_sell(self, context) end
        return true
    end

    local alias_calc_reroll = calculate_reroll_cost
    function calculate_reroll_cost(skip_increment)
        local coupon = SMODS.find_card('j_kranlaxs_couponstrip')
        
        if coupon and #coupon > 0 then
            local prev_cost = G.GAME.starting_params.reroll_cost
            local prev_mult = G.GAME.starting_params.reroll_cost_mult
            
            G.GAME.starting_params.reroll_cost = 0
            G.GAME.starting_params.reroll_cost_mult = 0
            
            alias_calc_reroll(skip_increment)
            
            G.GAME.starting_params.reroll_cost = prev_cost
            G.GAME.starting_params.reroll_cost_mult = prev_mult
            
            if G.GAME.current_round then G.GAME.current_round.reroll_cost = 0 end
        else
            alias_calc_reroll(skip_increment)
        end
    end
    
    local orig_reroll = G.FUNCS.reroll_shop
    G.FUNCS.reroll_shop = function(e)
        if G.GAME then G.GAME.kranlaxs_run_rerolls = (G.GAME.kranlaxs_run_rerolls or 0) + 1 end
        orig_reroll(e)
    end
    SMODS.kranlaxs_coupon_hook = true
end