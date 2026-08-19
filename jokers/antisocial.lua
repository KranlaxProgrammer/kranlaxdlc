SMODS.Joker{
    key = 'antisocial',
    config = { extra = { mult = 0, mult_add = 4 } },
    rarity = 1,
    atlas = 'CustomJokers',
    pos = { x = 7, y = 8 },
    cost = 4,
    blueprint_compat = true,
    unlocked = false,
    discovered = false,
    unlock_condition = {type = '', extra = ''},
    
    check_for_unlock = function(self, args)
        if G and G.PROFILES and G.PROFILES[G.SETTINGS.profile] then
            if G.PROFILES[G.SETTINGS.profile].all_unlocked then return true end
            if G.PROFILES[G.SETTINGS.profile].challenge_progress and G.PROFILES[G.SETTINGS.profile].challenge_progress.completed then
                -- Requiere: Fijación Total
                if G.PROFILES[G.SETTINGS.profile].challenge_progress.completed.c_kranlaxs_reto_fijado then return true end
            end
        end
        return false
    end,
    
    -- ¡ESTO ES LO QUE FALTABA! 
    -- Envía los valores extra a la descripción visual de la carta
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult_add, card.ability.extra.mult } }
    end,
    
    calculate = function(self, card, context)
        if context.joker_main then
            if card.ability.extra.mult > 0 then
                return {
                    mult_mod = card.ability.extra.mult,
                    message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}}
                }
            end
        end
        if context.before and not context.blueprint then
            if #context.full_hand == 1 then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_add
                return { message = localize('k_upgrade_ex'), colour = G.C.MULT }
            elseif #context.full_hand > 1 and card.ability.extra.mult > 0 then
                card.ability.extra.mult = 0
                return { message = localize('k_reset'), colour = G.C.RED }
            end
        end
    end
}