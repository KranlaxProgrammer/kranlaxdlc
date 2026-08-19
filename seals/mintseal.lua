SMODS.Seal {
    key = 'mintseal',
    -- ¡Eliminamos la línea prefix_config para que Steamodded le ponga el prefijo kranlaxs_ automáticamente!
    badge_colour = HEX('98ff98'),
    atlas = 'CustomSeals',
    pos = { x = 2, y = 0 },
        unlocked = true,
    discovered = true,
    no_collection = false
}

if not SMODS.mint_seal_hooked then
    local original_eval_card = eval_card
    function eval_card(card, context, ...)
        -- Como ya tiene el prefijo, solo necesitamos buscar 'kranlaxs_mintseal'
        local is_mint = card.seal == 'kranlaxs_mintseal'
        if not is_mint then
            return original_eval_card(card, context, ...)
        end
        
        local original_prob = G.GAME.probabilities.normal
        G.GAME.probabilities.normal = original_prob * 2
        
        local r1, r2, r3, r4, r5, r6 = original_eval_card(card, context, ...)
        
        G.GAME.probabilities.normal = original_prob
        return r1, r2, r3, r4, r5, r6
    end
    SMODS.mint_seal_hooked = true
end