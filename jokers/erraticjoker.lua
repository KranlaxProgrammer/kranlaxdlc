SMODS.Joker{
    key = "erraticjoker",
    config = { extra = {} },
    pos = { x = 0, y = 0 },
    display_size = { w = 71, h = 95 },
    cost = 4,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    
    -- Empieza bloqueado
    unlocked = false,
    discovered = false,
    unlock_condition = {type = '', extra = ''},
    
    atlas = 'ErraticAnimation',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    check_for_unlock = function(self, args)
        if args.type == 'win' then
            -- El pozo blanco (dificultad inicial) usa el ID base 'white'
            if G.GAME.selected_back.effect.center.key == 'b_kranlaxs_space_deck' and G.GAME.stake == 'white' then
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
    
    calculate = function(self, card, context)
        -- Si la carta puntuada es Versátil, mandamos la señal de "swap"
        if context.individual and context.cardarea == G.play and not context.blueprint then
            -- Verificación nativa y segura para cartas versátiles
            if context.other_card.config.center.key == 'm_wild' or SMODS.has_enhancement(context.other_card, 'm_wild') then
                return {
                    swap = true,
                    message = "Swapped!",
                    colour = G.C.ORANGE
                }
            end
        end
    end
}