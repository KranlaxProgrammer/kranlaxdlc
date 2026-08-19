if not SMODS.kranlaxs_potato_hook then
    local orig_mod_chips = mod_chips
    function mod_chips(val)
        if G.GAME then
            G.GAME.kranlaxs_last_hand_chips = val
        end
        return orig_mod_chips(val)
    end
    SMODS.kranlaxs_potato_hook = true
end

SMODS.Joker{
    key = 'potatobag',
    config = { extra = { accumulated = 0, target = 4000, xmult = 5, ready = false } },
    rarity = 1,
    atlas = 'CustomJokers',
    pos = { x = 3, y = 7 },
    cost = 4,
    blueprint_compat = true,
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.target, card.ability.extra.xmult, card.ability.extra.accumulated } }
    end,
    
    calculate = function(self, card, context)
        if context.joker_main then
            if card.ability.extra.ready then
                card.ability.extra.ready = false
                card.ability.extra.accumulated = 0
                return {
                    Xmult_mod = card.ability.extra.xmult,
                    message = localize{type='variable',key='a_xmult',vars={card.ability.extra.xmult}}
                }
            end
        end
        
        if context.after and not context.blueprint then
            if not card.ability.extra.ready then
                local raw_chips = G.GAME.kranlaxs_last_hand_chips or 0
                local final_chips = type(raw_chips) == 'table' and (tonumber(tostring(raw_chips)) or 0) or raw_chips
                
                card.ability.extra.accumulated = card.ability.extra.accumulated + final_chips
                
                if card.ability.extra.accumulated >= card.ability.extra.target then
                    card.ability.extra.ready = true
                    return { message = localize('k_active_ex'), colour = G.C.FILTER }
                else
                    return { message = card.ability.extra.accumulated .. '/' .. card.ability.extra.target, colour = G.C.CHIPS }
                end
            end
        end
    end
}