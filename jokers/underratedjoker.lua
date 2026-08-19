SMODS.Joker{ 
    key = "underratedjoker",
    config = { extra = { MostplayedChip = 1 } },
    pos = { x = 1, y = 0 },
    display_size = { w = 71, h = 95 },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    
    -- Empieza bloqueado
    unlocked = false,
    discovered = false,
    unlock_condition = {type = '', extra = ''},
    
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_mycustom_jokers"] = true },

    check_for_unlock = function(self, args)
        if args.type == 'win' then
            -- El pozo azul usa el ID base 'blue'
            if G.GAME.selected_back.effect.center.key == 'b_kranlaxs_space_deck' and G.GAME.stake == 'blue' then
                return true
            end
        end
        return false
    end,

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
        return {vars = {card.ability.extra.MostplayedChip}}
    end,
    
    calculate = function(self, card, context)
        
        -- Función auxiliar: Revisa si la mano actual es la más jugada (o está empatada en 1er lugar)
        local is_most_played = function(scoring_name)
            local current_played = G.GAME.hands[scoring_name].played or 0
            for handname, values in pairs(G.GAME.hands) do
                if handname ~= scoring_name and values.visible and values.played > current_played then
                    return false -- Encontramos una mano que se ha jugado MÁS veces
                end
            end
            return true -- Ninguna mano supera a esta (es la más jugada)
        end

        -- 1. FASE PREVIA: Evaluar si subimos el bono o lo reiniciamos
        if context.before and not context.blueprint then
            if is_most_played(context.scoring_name) then
                -- ¡Jugó la mano más jugada! Se reinicia el comodín.
                if card.ability.extra.MostplayedChip > 1 then
                    card.ability.extra.MostplayedChip = 1
                    return {
                        message = "Reset!",
                        colour = G.C.RED
                    }
                end
            else
                -- ¡Mano correcta! Aumentamos el multiplicador de fichas.
                card.ability.extra.MostplayedChip = card.ability.extra.MostplayedChip + 0.2
                return {
                    message = "Upgrade!",
                    colour = G.C.CHIPS
                }
            end
        end

        -- 2. FASE PRINCIPAL: Entregar el multiplicador de fichas
        if context.joker_main then
            if card.ability.extra.MostplayedChip > 1 then
                return {
                    message = "X" .. card.ability.extra.MostplayedChip,
                    x_chips = card.ability.extra.MostplayedChip,
                    colour = G.C.CHIPS
                }
            end
        end
        
    end
}