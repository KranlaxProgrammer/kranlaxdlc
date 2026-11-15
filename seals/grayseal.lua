if not SMODS.kranlaxs_grayseal_hook then
    local orig_play_cards = G.FUNCS.play_cards_from_highlighted
    G.FUNCS.play_cards_from_highlighted = function(e)
        
        -- ANTES de que el juego ponga en cola la puntuación, mutamos instantáneamente
        -- las cartas con Sello Gris que decidiste dejar en tu mano.
        if G.hand and G.hand.cards then
            local mutated_any = false
            for _, card in ipairs(G.hand.cards) do
                -- Si tiene el sello y NO está resaltada (es decir, se quedará en la mano)
                if card.seal == 'kranlaxs_grayseal' and not card.highlighted then
                    
                    local valid_enh = {}
                    for k, v in pairs(G.P_CENTERS) do
                        if v.set == 'Enhanced' and not v.no_pool then
                            table.insert(valid_enh, k)
                        end
                    end
                    if #valid_enh == 0 then table.insert(valid_enh, 'm_bonus') end
                    
                    local enh = pseudorandom_element(valid_enh, pseudoseed('gray_seal_hand'))
                    if G.P_CENTERS[enh] then
                        -- El cambio de habilidad es instantáneo en la base de datos
                        card:set_ability(G.P_CENTERS[enh])
                        card:juice_up(0.3, 0.3)
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = "¡Mutación!", colour = G.C.ORANGE})
                        mutated_any = true
                    end
                end
            end
            if mutated_any then play_sound('tarot1') end
        end
        
        -- Ahora sí, ejecutamos la jugada original. La carta en mano ya tiene 
        -- su nueva mejora lista para ser puntuada en este mismo turno.
        orig_play_cards(e)
    end
    SMODS.kranlaxs_grayseal_hook = true
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
        -- Ya no procesamos la mutación aquí porque la acción fue interceptada y 
        -- resuelta instantáneamente por nuestro Hook global (arriba).
    end
}
