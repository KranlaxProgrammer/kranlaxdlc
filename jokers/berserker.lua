SMODS.Joker{
    key = "berserker",
    config = { extra = { x_mult = 4, time_left = 0, active = false, played_warning = false } },
    pos = { x = 011, y = 10 }, 
    display_size = { w = 71, h = 95 },
    cost = 20,
    bm_cost = 6,
    rarity = "kranlaxs_zenith", 
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },
    
    loc_vars = function(self, info_queue, card)
        local time_left = math.max(0, math.floor(card and card.ability.extra.time_left or self.config.extra.time_left))
        local x_mult = card and card.ability.extra.x_mult or self.config.extra.x_mult
        return {vars = {x_mult, time_left}}
    end,

    update = function(self, card, dt)
        if card.ability.extra.active then
            local real_dt = dt / G.SETTINGS.GAMESPEED
            card.ability.extra.time_left = card.ability.extra.time_left - real_dt

            if card.ability.extra.time_left <= 3 and not card.ability.extra.played_warning then
                play_sound('kranlaxs_berserkertimer', 1, 0.6)
                card.ability.extra.played_warning = true
            end

            if card.ability.extra.time_left <= 0 then
                card.ability.extra.time_left = 0
                card.ability.extra.active = false
                card.ability.extra.played_warning = false
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = "¡Agotado!", colour = G.C.RED})
            end
        end
    end,
    
    calculate = function(self, card, context)
        if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
            if G.GAME.blind.boss then
                if not card.ability.extra.active then
                    card.ability.extra.time_left = 60
                    card.ability.extra.active = true
                else
                    card.ability.extra.time_left = card.ability.extra.time_left + 60
                end
                card.ability.extra.played_warning = false
                play_sound('kranlaxs_berserker', 1, 1)
                return { message = "+60s!", colour = G.C.RED, card = card }
            else
                if card.ability.extra.active then
                    card.ability.extra.time_left = card.ability.extra.time_left + 30
                    card.ability.extra.played_warning = false
                    return { message = "+30s!", colour = G.C.RED, card = card }
                end
            end
        end

        if context.joker_main then
            if card.ability.extra.active then
                return {
                    message = "X" .. card.ability.extra.x_mult .. " Mult",
                    Xmult_mod = card.ability.extra.x_mult,
                    colour = G.C.MULT
                }
            end
        end
    end
}