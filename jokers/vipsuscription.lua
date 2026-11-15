SMODS.Joker {
    key = 'vipsuscription',
    atlas = 'CustomJokers',
    pos = { x = 2, y = 2 },
    rarity = "kranlaxs_zenith",
    cost = 8,
    bm_cost = 7,
    unlocked = false,
    discovered = false,
    blueprint_compat = false,
    config = { extra = { suscription = 10, extraslots = 1 } },

    
    
    check_for_unlock = function(self, args)
        if args and args.type == 'win' then
            if G.GAME and G.GAME.stake == 7 and G.GAME.selected_back and G.GAME.selected_back.effect.center.key == 'b_kranlaxs_week_challenge' then
                return true
            end
        end
        return false
    end,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.suscription, card.ability.extra.extraslots } }
    end,

    add_to_deck = function(self, card, from_debuff)
        SMODS.change_voucher_limit(1)
        SMODS.change_booster_limit(1)
        change_shop_size(card.ability.extra.extraslots)
    end,

    remove_from_deck = function(self, card, from_debuff)
        SMODS.change_voucher_limit(-1)
        SMODS.change_booster_limit(-1)
        change_shop_size(-card.ability.extra.extraslots)
    end,
    
    calculate = function(self, card, context)
        if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
            if G.GAME.blind and G.GAME.blind.boss then
                if (G.GAME.dollars or 0) >= card.ability.extra.suscription then
                    local cost = card.ability.extra.suscription
                    card.ability.extra.suscription = math.floor(card.ability.extra.suscription * 1.5)
                    card.ability.extra.extraslots = card.ability.extra.extraslots + 1
                    
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            ease_dollars(-cost)
                            change_shop_size(1)
                            card:juice_up(0.5, 0.5)
                            play_sound('coin1')
                            return true
                        end
                    }))
                    
                    return {
                        message = "¡Renovada!",
                        colour = G.C.MONEY
                    }
                end
            end
        end
    end
}