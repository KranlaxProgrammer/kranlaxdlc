SMODS.Joker{
    key = "soap",
    config = { extra = { x_mult = 5, drop = 0.25 } },
    pos = { x = 011, y = 05 },
    cost = 8,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult, card.ability.extra.drop } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            if card.ability.extra.x_mult > 1 then
                return {
                    message = "X" .. card.ability.extra.x_mult .. " Mult",
                    Xmult_mod = card.ability.extra.x_mult,
                    colour = G.C.RED
                }
            end
        end

        if context.individual and context.cardarea == G.play then
            local c = context.other_card
            local has_mod = false
            
            if c.edition then has_mod = true end
            if c.seal then has_mod = true end
            if c.config.center.effect ~= 'Base' then has_mod = true end
            
            if has_mod and not context.blueprint then
                card.ability.extra.x_mult = math.max(1, card.ability.extra.x_mult - card.ability.extra.drop)
                
                G.E_MANAGER:add_event(Event({
                    func = function()
                        c:set_ability(G.P_CENTERS.c_base, nil, true)
                        c:set_edition(nil, true, true)
                        c:set_seal(nil, true, true)
                        c:juice_up(0.5, 0.5)
                        card:juice_up(0.5, 0.5)
                        return true
                    end
                }))

                return {
                    extra = {message = "¡Limpiado!", colour = G.C.BLUE},
                    card = card
                }
            end
        end
    end
}