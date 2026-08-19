-- ==============================================================================
-- JOKER: LITTLE BRO (Hermanito)
-- ==============================================================================
SMODS.Joker{
    key = "littlebro",
    config = {
        extra = {
            x_mult = 1,
            gain = 0.25,
            target_rank = 'Ace' -- Empieza pidiendo un As por defecto
        }
    },
    pos = { x = 6, y = 4 },
    display_size = { w = 71, h = 95 },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    
    unlocked = false, -- ¡Cambiado a false para activar el candado!
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    -- Evaluación nativa amplia: Sin restricciones de 'args.type'
    check_for_unlock = function(self, args)
        -- Al no poner restricciones, el juego evalúa esto constantemente.
        -- En el momento en que el contador interno llegue a 30, se desbloqueará de inmediato.
        if G.GAME and G.GAME.hands and G.GAME.hands['High Card'] then
            if G.GAME.hands['High Card'].played >= 30 then
                return true
            end
        end
        return false
    end,

    in_pool = function(self, args)
        if not G.jokers or not G.jokers.cards then return true end
        for _, v in ipairs(G.jokers.cards) do
            if v.config.center.key == 'j_kranlaxs_' .. self.key then
                return false 
            end
        end
        return true
    end,
    
    loc_vars = function(self, info_queue, card)
        local rank_str = localize(card.ability.extra.target_rank, 'ranks')
        return {vars = {card.ability.extra.x_mult, rank_str, card.ability.extra.gain}}
    end,
    
    calculate = function(self, card, context)
        -- Al seleccionar ciega: Escoger un nuevo rango basado en tu baraja (como el Ídolo)
        if context.setting_blind and not context.blueprint then
            local valid_cards = {}
            for _, v in ipairs(G.playing_cards) do
                if v.ability.effect ~= 'Stone Card' and v.base.value then
                    valid_cards[#valid_cards+1] = v
                end
            end
            if #valid_cards > 0 then
                local target = pseudorandom_element(valid_cards, pseudoseed('littlebro'))
                card.ability.extra.target_rank = target.base.value
                
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize(card.ability.extra.target_rank, 'ranks'), colour = G.C.GREEN})
                        return true
                    end
                }))
            end
        end

        -- Al puntuar: Comprobar si es Carta Alta y coincide
        if context.joker_main then
            if context.scoring_name == "High Card" then
                local match = false
                for _, v in ipairs(context.scoring_hand) do
                    if v.base.value == card.ability.extra.target_rank then
                        match = true
                        break
                    end
                end
                
                -- Si coincide, aumenta permanentemente el Multi
                if match and not context.blueprint then
                    card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.gain
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Upgraded!", colour = G.C.MULT})
                            return true
                        end
                    }))
                end
            end
            
            -- Entregar el XMulti acumulado
            if card.ability.extra.x_mult > 1 then
                return {
                    message = "X" .. card.ability.extra.x_mult,
                    Xmult_mod = card.ability.extra.x_mult,
                    colour = G.C.MULT
                }
            end
        end
    end
}