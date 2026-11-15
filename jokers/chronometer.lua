SMODS.Joker{
    key = "chronometer",
    config = { extra = { ante_paid = 0 } },
    pos = { x = 4, y = 2 },
    display_size = { w = 71, h = 95 },
    cost = 8,
    rarity = "kranlaxs_zenith",
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    bm_cost = 8,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    check_for_unlock = function(self, args)
        if args.type == 'win' then
            -- Gold Stake original equivale al nivel 8
            if G.GAME.selected_back.effect.center.key == 'b_kranlaxs_space_deck' and G.GAME.stake >= 8 then
                return true
            end
        end
        return false
    end,

    locked_loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
    
    loc_vars = function(self, info_queue, card)
        local t = os.date("*t")
        return {vars = {t.sec, t.min, t.hour}}
    end,


    
    calculate = function(self, card, context)
        if context.joker_main then
            local t = os.date("*t")
            local unbal = SMODS.Mods["kranlaxs"] and SMODS.Mods["kranlaxs"].config.unbalanced_mode
            local pay = false
            
            if unbal then
                pay = true
            else
                -- Bloqueo para que solo pague una vez por Ante
                if card.ability.extra.ante_paid ~= G.GAME.round_resets.ante then
                    card.ability.extra.ante_paid = G.GAME.round_resets.ante
                    pay = true
                end
            end

            if pay and t.hour > 0 then
                ease_dollars(t.hour)
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = "+$"..t.hour, colour = G.C.MONEY})
                        return true
                    end
                }))
            end
            
            return {
                chips = t.sec,
                mult = t.min,
                message = string.format("%02d:%02d:%02d", t.hour, t.min, t.sec),
                colour = G.C.ORANGE
            }
        end
    end
}