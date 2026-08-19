SMODS.Joker{
    key = 'knight',
    config = { extra = { count = 0, target = 10, active = false, shake_timer = 0 } },
    rarity = 3,
    atlas = 'CustomJokers',
    pos = { x = 9, y = 7 },
    cost = 8,
    blueprint_compat = true,
    unlocked = false,
    discovered = false,
    unlock_condition = {type = '', extra = ''},
    
    check_for_unlock = function(self, args)
        if G and G.PROFILES and G.PROFILES[G.SETTINGS.profile] then
            if G.PROFILES[G.SETTINGS.profile].all_unlocked then return true end
            if G.PROFILES[G.SETTINGS.profile].challenge_progress and G.PROFILES[G.SETTINGS.profile].challenge_progress.completed then
                -- Requiere: Sindicato de Jefes
                if G.PROFILES[G.SETTINGS.profile].challenge_progress.completed.c_kranlaxs_reto_jefes then return true end
            end
        end
        return false
    end,
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.target, card.ability.extra.count } }
    end,
    
    update = function(self, card, dt)
        if card.ability.extra.active then
            card.ability.extra.shake_timer = (card.ability.extra.shake_timer or 0) + dt
            if card.ability.extra.shake_timer > 2.5 then
                card:juice_up(0.08, 0.04)
                card.ability.extra.shake_timer = 0
            end
        end
    end,
    
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card.ability.name == 'Steel Card' and not card.ability.extra.active and not context.blueprint then
                card.ability.extra.count = card.ability.extra.count + 1
                if card.ability.extra.count >= card.ability.extra.target then
                    card.ability.extra.active = true
                    return { extra = {focus = card, message = localize('k_active_ex')}, card = card, colour = G.C.FILTER }
                else
                    return { extra = {focus = card, message = card.ability.extra.count .. '/' .. card.ability.extra.target}, card = card, colour = G.C.FILTER }
                end
            end
        end
        if context.setting_blind and not context.blueprint then
            if G.GAME.blind and G.GAME.blind.boss and card.ability.extra.active then
                card.ability.extra.active = false
                card.ability.extra.count = 0
                G.E_MANAGER:add_event(Event({func = function()
                    G.GAME.blind:disable()
                    play_sound('timpani')
                    card:juice_up(0.8, 0.8)
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_disabled_ex'), colour = G.C.GREEN})
                    return true
                end}))
            end
        end
    end
}