SMODS.Joker{
    key = "lateshippment",
    config = { extra = { retrigg = 0 } },
    pos = { x = 1, y = 5 },
    display_size = { w = 71, h = 95 },
    cost = 5,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    
    -- Empieza bloqueado
    unlocked = false,
    discovered = false,
    unlock_condition = {type = '', extra = ''},
    
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    check_for_unlock = function(self, args)
        if args.type == 'win' then
            -- En el juego base, el pozo naranja usa el ID 'orange'
            if G.GAME.selected_back.effect.center.key == 'b_kranlaxs_space_deck' and G.GAME.stake == 'orange' then
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
        return {vars = {card.ability.extra.retrigg}}
    end,
    
    calculate = function(self, card, context)
        -- Reactiva TODAS las cartas jugadas
        if context.repetition and context.cardarea == G.play then
            if card.ability.extra.retrigg > 0 then
                return {
                    message = localize('k_again_ex'),
                    repetitions = card.ability.extra.retrigg,
                    card = card
                }
            end
        end
        
        -- Al final de la ronda, guarda las manos jugadas para usarlas en la siguiente
        if context.end_of_round and context.main_eval and not context.blueprint then
            local hands_played = G.GAME.current_round.hands_played
            card.ability.extra.retrigg = hands_played
            
            return {
                message = "Stored: " .. hands_played,
                colour = G.C.BLUE
            }
        end
    end
}