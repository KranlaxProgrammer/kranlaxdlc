SMODS.Joker{
    key = 'clerigo',
    config = { extra = { mult_add = 2, mult_sub = 2, current_mult = 0 } },
    rarity = 2,
    atlas = 'CustomJokers',
    pos = { x = 4, y = 8 },
    cost = 6,
    blueprint_compat = true,
    unlocked = false,
    discovered = false,
    unlock_condition = {type = '', extra = ''},
    
    check_for_unlock = function(self, args)
        if G and G.PROFILES and G.PROFILES[G.SETTINGS.profile] then
            if G.PROFILES[G.SETTINGS.profile].all_unlocked then return true end
            if G.PROFILES[G.SETTINGS.profile].challenge_progress and G.PROFILES[G.SETTINGS.profile].challenge_progress.completed then
                -- Requiere: Receta Familiar
                if G.PROFILES[G.SETTINGS.profile].challenge_progress.completed.c_kranlaxs_reto_abuela then return true end
            end
        end
        return false
    end,
    
    update = function(self, card, dt)
        if G.playing_cards then
            local totales = #G.playing_cards
            local modificadas = 0
            for _, v in ipairs(G.playing_cards) do
                if (v.config.center and v.config.center.key ~= 'c_base') or v.edition or v.seal then
                    modificadas = modificadas + 1
                end
            end
            card.ability.extra.current_mult = (totales * card.ability.extra.mult_add) - (modificadas * card.ability.extra.mult_sub)
        end
    end,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult_add, card.ability.extra.mult_sub, card.ability.extra.current_mult } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            if card.ability.extra.current_mult > 0 then
                return {
                    mult_mod = card.ability.extra.current_mult,
                    message = localize{type='variable',key='a_mult',vars={card.ability.extra.current_mult}}
                }
            end
        end
    end
}