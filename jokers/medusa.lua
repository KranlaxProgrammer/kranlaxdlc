SMODS.Joker{
    key = "medusa",
    config = { extra = {} },
    pos = { x = 8, y = 4 },
    display_size = { w = 71, h = 95 },
    cost = 7,
    rarity = 3,
    blueprint_compat = false,
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
            if G.GAME.selected_back.effect.center.key == 'b_kranlaxs_space_deck' and G.GAME.stake == 'kranlaxs_brown' then
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
        -- Ejecutar justo DESPUÉS de puntuar, para que no pierdas el valor de tu mano actual
        if context.after and not context.blueprint then
            local petrified = false
            
            -- context.full_hand incluye TODO lo que seleccionaste y jugaste
            for _, v in ipairs(context.full_hand) do
                if v.config.center.key ~= 'm_stone' then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            -- Transformar en Carta de Piedra
                            v:set_ability(G.P_CENTERS.m_stone, nil, true)
                            v:juice_up()
                            return true
                        end
                    }))
                    petrified = true
                end
            end
            
            if petrified then
                return {
                    message = "Petrified!",
                    colour = G.C.UI.TEXT_DARK
                }
            end
        end
    end
}