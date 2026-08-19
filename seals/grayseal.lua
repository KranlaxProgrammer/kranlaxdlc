if not SMODS.kranlaxs_grayseal_hooked then
    local original_eval_card = eval_card
    function eval_card(card, context, ...)
        if card.seal == 'grayseal' or card.seal == 'kranlaxs_grayseal' then
            if context.main_scoring then
                local play_pool = {'m_lucky', 'm_bonus', 'm_mult', 'm_glass', 'm_stone'}
                local enh = pseudorandom_element(play_pool, pseudoseed('gray_seal_play'))
                
                if G.P_CENTERS[enh] then
                    card:set_ability(G.P_CENTERS[enh])
                    G.E_MANAGER:add_event(Event({
                        trigger = 'immediate',
                        func = function()
                            card:juice_up(0.3, 0.3)
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Shift!", colour = G.C.ORANGE})
                            return true
                        end
                    }))
                end
                
            elseif context.cardarea == G.hand and (context.main_eval or context.end_of_round) then
                local hand_pool = {'m_steel', 'm_gold'}
                local enh = pseudorandom_element(hand_pool, pseudoseed('gray_seal_hand'))
                
                if G.P_CENTERS[enh] then
                    card:set_ability(G.P_CENTERS[enh])
                    G.E_MANAGER:add_event(Event({
                        trigger = 'immediate',
                        func = function()
                            card:juice_up(0.3, 0.3)
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Shift!", colour = G.C.ORANGE})
                            return true
                        end
                    }))
                end
            end
        end
        
        return original_eval_card(card, context, ...)
    end
    SMODS.kranlaxs_grayseal_hooked = true
end

SMODS.Seal {
    key = 'grayseal',
    pos = { x = 1, y = 0 },
    badge_colour = HEX('808080'),

    atlas = 'CustomSeals',
    unlocked = true,
    discovered = true,
    no_collection = false,
    calculate = function(self, card, context)
    end
}