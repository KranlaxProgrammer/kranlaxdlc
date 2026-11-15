SMODS.Joker {
    key = 'censored',
    atlas = 'CustomJokers',
    pos = { x = 5, y = 9 },
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    config = { extra = { mult = 0, mult_gain = 4, odds = 5 } },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult_gain, G.GAME.probabilities.normal or 1, card.ability.extra.odds, card.ability.extra.mult } }
    end,
    
    in_pool = function(self, args)
        if SMODS.showman and SMODS.showman('j_kranlaxs_' .. self.key) then return true end
        
        local areas_to_check = {G.jokers, G.shop_jokers, G.pack_cards}
        for _, area in ipairs(areas_to_check) do
            if area and area.cards then
                for _, v in ipairs(area.cards) do
                    if v.config and v.config.center and v.config.center.key == 'j_kranlaxs_' .. self.key then return false end
                end
            end
        end
        return true
    end,

    update = function(self, card, dt)
        if card.area == G.jokers and not card.debuff and (G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.DRAW_TO_HAND or G.STATE == G.STATES.PLAY_TAROT or G.STATE == G.STATES.HAND_PLAYED) then
            if G.hand and G.hand.cards then
                for _, c in ipairs(G.hand.cards) do
                    if not c.censored_checked then
                        c.censored_checked = true
                        if pseudorandom('censored_roll') < (G.GAME.probabilities.normal or 1) / card.ability.extra.odds then
                            c.ability.censored_debuff = true
                            c:set_debuff(true)
                            c:juice_up(0.3, 0.3)
                        end
                    end
                end
            end
        end
    end,
    
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local count = 0
            if context.scoring_hand then
                for _, c in ipairs(context.scoring_hand) do
                    if c.debuff then count = count + 1 end
                end
            end
            if count > 0 then
                card.ability.extra.mult = card.ability.extra.mult + (count * card.ability.extra.mult_gain)
                return {
                    message = "+" .. (count * card.ability.extra.mult_gain) .. " Mult",
                    colour = G.C.RED
                }
            end
        end
        
        if context.joker_main and card.ability.extra.mult > 0 then
            return {
                mult = card.ability.extra.mult,
                colour = G.C.RED
            }
        end
        
        if context.end_of_round then
            local areas = {G.deck, G.hand, G.play, G.discard}
            for _, area in ipairs(areas) do
                if area and area.cards then
                    for _, c in ipairs(area.cards) do
                        c.censored_checked = nil
                        if c.ability.censored_debuff then
                            c.ability.censored_debuff = nil
                            c:set_debuff(false)
                        end
                    end
                end
            end
        end
    end
}

-- ==========================================
-- HOOK: Proteger el debuff del Comodín Censurado
-- ==========================================
if not SMODS.kranlaxs_censored_hook then
    local orig_set_debuff = Card.set_debuff
    function Card:set_debuff(should_debuff)
        -- Si la carta tiene nuestra marca interna, forzamos el debuff a true
        if self.ability and self.ability.censored_debuff then
            should_debuff = true
        end
        if orig_set_debuff then orig_set_debuff(self, should_debuff) end
    end
    SMODS.kranlaxs_censored_hook = true
end