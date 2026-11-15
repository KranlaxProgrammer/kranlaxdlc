SMODS.Joker{
    key = "russianroulette",
    config = { extra = { GunIncrease = 1, odds = 6 } },
    pos = { x = 9, y = 0 },
    display_size = { w = 71, h = 95 },
    cost = 5,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    
    unlocked = false,
    discovered = false,
    unlock_condition = {type = '', extra = ''},
    
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    check_for_unlock = function(self, args)
        if args.type == 'win' then
            if G.GAME.selected_back.effect.center.key == 'b_kranlaxs_space_deck' and G.GAME.stake == 'black' then
                return true
            end
        end
        return false
    end,

    in_pool = function(self, args)
        if SMODS.showman and SMODS.showman('j_kranlaxs_' .. self.key) then return true end
        
        local areas_to_check = {G.jokers, G.shop_jokers, G.pack_cards}
        for _, area in ipairs(areas_to_check) do
            if area and area.cards then
                for _, v in ipairs(area.cards) do
                    if v.config and v.config.center and v.config.center.key == 'j_kranlaxs_' .. self.key then return false end
                end
            end
        end
        return true
    end,
    
    loc_vars = function(self, info_queue, card)
        local new_numerator, new_denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'russian_roulette') 
        return {vars = {new_numerator, new_denominator, card.ability.extra.GunIncrease}}
    end,
    
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            if SMODS.pseudorandom_probability(card, 'russian_roulette', 1, card.ability.extra.odds) then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('kranlaxs_shot', 1.0, 1.0)
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = "BANG!", colour = G.C.WHITE})
                        return true
                    end
                }))
                
                G.E_MANAGER:add_event(Event({
                    delay = 1.0,
                    func = function()
                        local saved = false
                        if G.jokers and G.jokers.cards then
                            for _, jkr in ipairs(G.jokers.cards) do
                                if jkr.config.center.key == 'j_kranlaxs_lifeassurance' and not jkr.debuff then
                                    if G.GAME.dollars >= jkr.ability.extra.seguro then
                                        local cost = jkr.ability.extra.seguro
                                        jkr.ability.extra.seguro = jkr.ability.extra.seguro * 2
                                        ease_dollars(-cost)
                                        card_eval_status_text(jkr, 'extra', nil, nil, nil, {message = "-$" .. tostring(cost), colour = G.C.MONEY})
                                        jkr:juice_up()
                                        saved = true
                                        break
                                    end
                                end
                            end
                        end

                        if saved then
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = "¡Salvado!", colour = G.C.GREEN})
                        else
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Oops...", colour = G.C.RED})
                            if G.STAGE == G.STAGES.RUN then 
                                G.STATE = G.STATES.GAME_OVER
                                G.STATE_COMPLETE = false
                            end
                        end
                        return true
                    end
                }))
            else
                card.ability.extra.GunIncrease = card.ability.extra.GunIncrease + 3
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('kranlaxs_click', 1.0, 1.0)
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Click...", colour = G.C.GREEN})
                        return true
                    end
                }))
            end
        end

        if context.joker_main then
            if card.ability.extra.GunIncrease > 1 then
                local ret = {
                    message = "X" .. card.ability.extra.GunIncrease,
                    Xmult_mod = card.ability.extra.GunIncrease,
                    colour = G.C.DARK_EDITION,
                    sound = 'kranlaxs_multiplicativechips'
                }
                if not context.blueprint then
                    ret.x_chips = card.ability.extra.GunIncrease
                end
                return ret
            end
        end
    end
}