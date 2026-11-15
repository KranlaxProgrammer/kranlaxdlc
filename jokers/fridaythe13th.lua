SMODS.Joker{
    key = "fridaythe13th",
    config = { extra = { mult = 0, gain = 4 } },
    pos = { x = 0, y = 0 },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.gain, card.ability.extra.mult } }
    end,

    calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.mult > 0 then
            return {
                message = "+" .. card.ability.extra.mult .. " Mult",
                mult_mod = card.ability.extra.mult,
                colour = G.C.MULT
            }
        end
    end
}

-- Hooks para detectar destrucción de figuras en cualquier parte
if not SMODS.kranlaxs_friday13th_hook then
    local orig_start_dissolve = Card.start_dissolve
    function Card:start_dissolve(colors, silent, time, no_juice)
        if self.base and self:is_face() and G.jokers and G.jokers.cards then
            for _, jkr in ipairs(G.jokers.cards) do
                if jkr.config.center.key == 'j_kranlaxs_fridaythe13th' and not jkr.debuff then
                    jkr.ability.extra.mult = jkr.ability.extra.mult + jkr.ability.extra.gain
                    jkr:juice_up(0.5, 0.5)
                    card_eval_status_text(jkr, 'extra', nil, nil, nil, {message = "+"..jkr.ability.extra.gain.." Mult", colour = G.C.MULT})
                end
            end
        end
        if orig_start_dissolve then orig_start_dissolve(self, colors, silent, time, no_juice) end
    end

    local orig_shatter = Card.shatter
    function Card:shatter()
        if self.base and self:is_face() and G.jokers and G.jokers.cards then
            for _, jkr in ipairs(G.jokers.cards) do
                if jkr.config.center.key == 'j_kranlaxs_fridaythe13th' and not jkr.debuff then
                    jkr.ability.extra.mult = jkr.ability.extra.mult + jkr.ability.extra.gain
                    jkr:juice_up(0.5, 0.5)
                    card_eval_status_text(jkr, 'extra', nil, nil, nil, {message = "+"..jkr.ability.extra.gain.." Mult", colour = G.C.MULT})
                end
            end
        end
        if orig_shatter then orig_shatter(self) end
    end
    SMODS.kranlaxs_friday13th_hook = true
end