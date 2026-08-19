-- ==============================================================================
-- EL INTERCEPTOR: Detecta cualquier etiqueta obtenida en cualquier parte del juego
-- ==============================================================================
if not SMODS.kranlaxs_tagger_hook then
    local orig_add_tag = add_tag
    function add_tag(tag)
        local ret = orig_add_tag(tag)
        
        if G.jokers and G.jokers.cards then
            for _, v in ipairs(G.jokers.cards) do
                if v.config.center.key == 'j_kranlaxs_tagger' and not v.debuff then
                    v.ability.extra.mult = v.ability.extra.mult + v.ability.extra.mult_mod
                    
                    v:juice_up(0.3, 0.4)
                    card_eval_status_text(v, 'extra', nil, nil, nil, {
                        message = "+"..tostring(v.ability.extra.mult_mod).." Mult", 
                        colour = G.C.MULT
                    })
                end
            end
        end
        return ret
    end
    SMODS.kranlaxs_tagger_hook = true
end

-- ==============================================================================
-- JOKER: TAGGER (Etiquetador)
-- ==============================================================================
SMODS.Joker{
    key = "tagger",
    config = { 
        extra = { 
            mult = 0, 
            mult_mod = 10 
        } 
    },
    pos = { x = 0, y = 7 }, 
    display_size = { w = 71, h = 95 },
    cost = 5,
    rarity = 2, 
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    check_for_unlock = function(self, args)
        if G.GAME and G.GAME.used_vouchers then
            if G.GAME.used_vouchers['v_clearance_sale'] and G.GAME.used_vouchers['v_liquidation'] then
                return true
            end
        end
        return false
    end,

    in_pool = function(self, args)
        if not G.jokers or not G.jokers.cards then return true end
        for _, v in ipairs(G.jokers.cards) do
            if v.config.center.key == 'j_kranlaxs_' .. self.key then return false end
        end
        return true
    end,
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult_mod, card.ability.extra.mult } }
    end,

    calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.mult > 0 then
            return {
                message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
                mult_mod = card.ability.extra.mult,
                colour = G.C.MULT
            }
        end
    end
}