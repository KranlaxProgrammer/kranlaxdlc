SMODS.Joker{
    key = 'entrenador',
    config = { extra = { xmult_alto = 3, xmult_bajo = 2, umbral = 9 } },
    rarity = 3,
    atlas = 'CustomJokers',
    pos = { x = 1, y = 7 },
    cost = 8,
    blueprint_compat = true,
    unlocked = false,
    discovered = false,
    unlock_condition = {type = '', extra = ''},
    
    check_for_unlock = function(self, args)
        if G and G.PROFILES and G.PROFILES[G.SETTINGS.profile] then
            if G.PROFILES[G.SETTINGS.profile].all_unlocked then return true end
            if G.PROFILES[G.SETTINGS.profile].challenge_progress and G.PROFILES[G.SETTINGS.profile].challenge_progress.completed then
                -- Requiere: Crisis Económica
                if G.PROFILES[G.SETTINGS.profile].challenge_progress.completed.c_kranlaxs_crisis_economica then return true end
            end
        end
        return false
    end,
    
    loc_vars = function(self, info_queue, card)
        local cur_xmult = (G.GAME and G.GAME.round_resets and G.GAME.round_resets.ante < card.ability.extra.umbral) and card.ability.extra.xmult_alto or card.ability.extra.xmult_bajo
        return { vars = { card.ability.extra.xmult_alto, card.ability.extra.xmult_bajo, card.ability.extra.umbral, cur_xmult } }
    end,
    
    calculate = function(self, card, context)
        if context.joker_main then
            local cur_xmult = (G.GAME.round_resets.ante < card.ability.extra.umbral) and card.ability.extra.xmult_alto or card.ability.extra.xmult_bajo
            return {
                Xmult_mod = cur_xmult,
                message = localize{type='variable',key='a_xmult',vars={cur_xmult}}
            }
        end
    end
}