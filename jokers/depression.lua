SMODS.Joker{
    key = "depression",
    config = {
        extra = {
            increment = 0.4,
            base_mult = 1
        }
    },
    pos = { x = 2, y = 5 },
    display_size = { w = 71, h = 95 },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    
    -- ===================================================
    -- SISTEMA DE DESBLOQUEO
    -- ===================================================
    unlocked = false,
    discovered = false,
    
    check_for_unlock = function(self, args)
        -- Si ganamos la ronda (estamos por entrar a la tienda) o el dinero acaba de cambiar
        if args and (args.type == 'round_win' or args.type == 'money') then
            -- Comprobamos si el jugador tiene una deuda de 25 o peor (-25, -26, -30...)
            if G.GAME and G.GAME.dollars and to_number(G.GAME.dollars) <= -25 then
                return true
            end
        end
        return false
    end,
    -- ===================================================

    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    in_pool = function(self, args)
        -- Si el juego apenas está cargando y no hay barra de jokers, permitir que exista en la pool
        if not G.jokers or not G.jokers.cards then return true end
        
        -- Escanear tu barra de Jokers
        for _, v in ipairs(G.jokers.cards) do
            -- Si ya tienes una copia exacta de esta carta, bloquear su aparición
            if v.config.center.key == 'j_kranlaxs_' .. self.key then
                return false 
            end
        end
        
        return true
    end,
    
    loc_vars = function(self, info_queue, card)
        local debt = 0
        -- Detectar si hay deuda de forma segura
        if G.GAME and G.GAME.dollars and to_big(G.GAME.dollars) < to_big(0) then
            debt = to_number(G.GAME.dollars) * -1 
        end
        
        local current_mult = card.ability.extra.base_mult + (debt * card.ability.extra.increment)
        return {vars = {card.ability.extra.increment, current_mult}}
    end,
    
    calculate = function(self, card, context)
        if context.joker_main then
            local debt = 0
            if G.GAME and G.GAME.dollars and to_big(G.GAME.dollars) < to_big(0) then
                debt = to_number(G.GAME.dollars) * -1
            end
            
            local current_mult = card.ability.extra.base_mult + (debt * card.ability.extra.increment)
            
            -- Solo aplica si es mayor a ^1 para no afectar la puntuación normal
            if current_mult > 1 then
                return {
                    message = "^" .. current_mult .. " Mult",
                    e_mult = current_mult,
                    colour = G.C.DARK_EDITION
                }
            end
        end
    end
}