if not SMODS.kranlaxs_whiteseal_hooks then
    
    local orig_set_debuff = Card.set_debuff
    function Card:set_debuff(should_debuff, ...)
        if self.seal == 'whiteseal' or self.seal == 'kranlaxs_whiteseal' then
            should_debuff = false
        end
        return orig_set_debuff(self, should_debuff, ...)
    end

    local orig_get_poker_hand_info = G.FUNCS.get_poker_hand_info
    G.FUNCS.get_poker_hand_info = function(_cards)
        local text, loc_disp_text, poker_hands, scoring_hand, disp_text = orig_get_poker_hand_info(_cards)
        
        if scoring_hand and type(scoring_hand) == 'table' then
            local modified = false
            for i = 1, #_cards do
                local c = _cards[i]
                if (c.seal == 'whiteseal' or c.seal == 'kranlaxs_whiteseal') and not c.debuff then
                    local in_scoring = false
                    for j = 1, #scoring_hand do
                        if scoring_hand[j] == c then 
                            in_scoring = true
                            break 
                        end
                    end
                    if not in_scoring then
                        scoring_hand[#scoring_hand + 1] = c
                        modified = true
                    end
                end
            end
            if modified then
                table.sort(scoring_hand, function(a, b) return a.T.x < b.T.x end)
            end
        end
        return text, loc_disp_text, poker_hands, scoring_hand, disp_text
    end

    local orig_eval_card_white = eval_card
    function eval_card(card, context, ...)
        local r1, r2, r3, r4, r5, r6 = orig_eval_card_white(card, context, ...)
        if r1 and type(r1) == 'table' and (card.seal == 'whiteseal' or card.seal == 'kranlaxs_whiteseal') then
            if r1.shatter or r1.destroyed then
                r1.shatter = nil
                r1.destroyed = nil
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = function()
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = "¡Protegido!", colour = G.C.WHITE})
                        return true
                    end
                }))
            end
        end
        return r1, r2, r3, r4, r5, r6
    end

    local orig_start_dissolve = Card.start_dissolve
    function Card:start_dissolve(dissolve_colours, silent, zoom_in, custom_margin, ...)
        if self.seal == 'whiteseal' or self.seal == 'kranlaxs_whiteseal' then
            self:juice_up(0.5, 0.5)
            card_eval_status_text(self, 'extra', nil, nil, nil, {message = "¡Inmune!", colour = G.C.WHITE})
            return 
        end
        return orig_start_dissolve(self, dissolve_colours, silent, zoom_in, custom_margin, ...)
    end

    local orig_set_seal = Card.set_seal
    function Card:set_seal(_seal, silent, immediate, ...)
        local r1, r2, r3, r4, r5, r6 = orig_set_seal(self, _seal, silent, immediate, ...)
        if self.seal == 'whiteseal' or self.seal == 'kranlaxs_whiteseal' then
            local cured = false
            
            if self.debuff then
                self:set_debuff(false)
                cured = true
            end
            
            if self.facing == 'back' then
                self:flip()
                cured = true
            end
            
            if cured and not silent then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after', delay = 0.2,
                    func = function()
                        self:juice_up(0.4, 0.4)
                        card_eval_status_text(self, 'extra', nil, nil, nil, {message = "¡Purificado!", colour = G.C.WHITE})
                        return true
                    end
                }))
            end
        end
        return r1, r2, r3, r4, r5, r6
    end

    local orig_flip = Card.flip
    function Card:flip(scroll, forced)
        if (self.seal == 'whiteseal' or self.seal == 'kranlaxs_whiteseal') and self.facing == 'front' then
            return
        end
        return orig_flip(self, scroll, forced)
    end

    SMODS.kranlaxs_whiteseal_hooks = true
end

SMODS.Seal {
    key = 'whiteseal',
    pos = { x = 5, y = 0 },
    badge_colour = HEX('FFFFFF'), 
    atlas = 'CustomSeals',
    unlocked = true,
    discovered = true,
    no_collection = false,
    calculate = function(self, card, context)
    end
}