SMODS.Joker{
    key = "the",
    config = { extra = { shake_timer = 0 } },
    pos = { x = 4, y = 5 },
    display_size = { w = 71, h = 95 },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    
    unlocked = false,
    discovered = false,
    
    check_for_unlock = function(self, args)
        if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
            G.PROFILES[G.SETTINGS.profile].kranlaxs_one_hand_wins = G.PROFILES[G.SETTINGS.profile].kranlaxs_one_hand_wins or 0
            
            if args and args.type == 'round_win' then
                if G.GAME and G.GAME.current_round and G.GAME.current_round.hands_played == 1 then
                    G.PROFILES[G.SETTINGS.profile].kranlaxs_one_hand_wins = G.PROFILES[G.SETTINGS.profile].kranlaxs_one_hand_wins + 1
                end
            end
            
            if G.PROFILES[G.SETTINGS.profile].kranlaxs_one_hand_wins >= 5 then
                return true
            end
        end
        return false
    end,

    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

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
        local status = (G.GAME and G.GAME.current_round and G.GAME.current_round.hands_played == 0) and "Active" or "Inactive"
        return {vars = {status}}
    end,

    update = function(self, card, dt)
        -- Añadimos 'card.area == G.jokers' para verificar que ya es tuyo
        if card.area == G.jokers and G.GAME and G.GAME.current_round and G.GAME.current_round.hands_played == 0 then
            card.ability.extra.shake_timer = (card.ability.extra.shake_timer or 0) + dt
            
            if card.ability.extra.shake_timer > 2.5 then
                card:juice_up(0.1, 0.1) 
                card.ability.extra.shake_timer = 0
            end
        end
    end,
    
    calculate = function(self, card, context)
        if context.joker_main then
            if G.GAME.current_round.hands_played == 0 then
                
                -- 1. Forzamos manualmente el mensaje ROJO primero (Multiplicador)
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = "X2", colour = G.C.MULT})
                
                -- 2. Enviamos los datos. Talisman secuestrará este mensaje y lo pintará de AZUL (Fichas)
                return {
                    message = "X2",
                    Xmult_mod = 2,
                    Xchip_mod = 2, 
                    colour = G.C.CHIPS
                }
            end
        end
    end
}