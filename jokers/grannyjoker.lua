SMODS.Joker {
    key = "grannyjoker",
    atlas = 'CustomJokers',
    pos = { x = 0, y = 5 },
    rarity = 2,
    cost = 5,
    unlocked = false,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = { extra = { x_mult = 3, e_mult = 3 } },

    check_for_unlock = function(self, args)
        if args and args.type == 'round_win' then
            if G.SETTINGS and G.SETTINGS.GAMESPEED == 0.5 then
                if G.PROFILES and G.PROFILES[G.SETTINGS.profile] then
                    G.PROFILES[G.SETTINGS.profile].kranlaxs_slow_blinds_defeated = (G.PROFILES[G.SETTINGS.profile].kranlaxs_slow_blinds_defeated or 0) + 1
                end
            end
        end
        if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
            if (G.PROFILES[G.SETTINGS.profile].kranlaxs_slow_blinds_defeated or 0) >= 12 then return true end
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
        if SMODS.Mods["kranlaxs"] and SMODS.Mods["kranlaxs"].config.unbalanced_mode then
            return { vars = { card.ability.extra.e_mult } }
        else
            return { vars = { card.ability.extra.x_mult } }
        end
    end,
    
    calculate = function(self, card, context)
        if context.joker_main then
            if SMODS.Mods["kranlaxs"] and SMODS.Mods["kranlaxs"].config.unbalanced_mode then
                return { message = "^" .. card.ability.extra.e_mult .. " Mult", e_mult = card.ability.extra.e_mult, colour = G.C.DARK_EDITION }
            else
                return { message = "X" .. card.ability.extra.x_mult .. " Mult", Xmult_mod = card.ability.extra.x_mult, colour = G.C.MULT }
            end
        end

        if context.before and not context.blueprint then
            if context.scoring_name == "Straight" or context.scoring_name == "Straight Flush" then
                local saved = false
                if G.jokers and G.jokers.cards then
                    for _, jkr in ipairs(G.jokers.cards) do
                        if jkr.config.center.key == 'j_kranlaxs_lifeassurance' and not jkr.debuff then
                            if G.GAME.dollars >= jkr.ability.extra.seguro then
                                local cost = jkr.ability.extra.seguro
                                jkr.ability.extra.seguro = jkr.ability.extra.seguro * 2
                                ease_dollars(-cost)
                                G.E_MANAGER:add_event(Event({
                                    func = function()
                                        card_eval_status_text(jkr, 'extra', nil, nil, nil, {message = "-$" .. tostring(cost), colour = G.C.MONEY})
                                        jkr:juice_up()
                                        return true
                                    end
                                }))
                                saved = true
                                break
                            end
                        end
                    end
                end

                if saved then
                    return { message = "¡Salvada!", colour = G.C.GREEN }
                else
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound('glass1')
                            card.getting_sliced = true
                            card:shatter()
                            -- FIX RECETA FAMILIAR: Termina la partida si es destruida en el reto
                            if G.GAME and G.GAME.challenge == 'c_kranlaxs_reto_abuela' then
                                G.STATE = G.STATES.GAME_OVER
                                G.STATE_COMPLETE = false
                            end
                            return true
                        end
                    }))
                    return { message = "¡Destruida!" }
                end
            end
        end
    end
}
