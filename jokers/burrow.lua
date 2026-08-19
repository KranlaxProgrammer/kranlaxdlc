SMODS.Joker{
    key = "burrow",
    config = {
        extra = {
            conejos = 0
        }
    },
    pos = { x = 1, y = 3 },
    display_size = { w = 71, h = 95 },
    cost = 4,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
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
        -- Se extrae el objeto completo del Conejo desde G.P_CENTERS
        if G.P_CENTERS.j_kranlaxs_bunny then
            info_queue[#info_queue+1] = G.P_CENTERS.j_kranlaxs_bunny
        end
        return {vars = {card.ability.extra.conejos}}
    end,
    
    calculate = function(self, card, context)
        -- Acumular conejos al superar la ciega
        if context.end_of_round and context.main_eval and not context.blueprint then
            card.ability.extra.conejos = card.ability.extra.conejos + 1
            return {
                message = "+1 Bunny",
                colour = G.C.ORANGE
            }
        end

        -- Generar los conejos al vender el comodín (AHORA IGNORA LOS LÍMITES)
        if context.selling_self and not context.blueprint then
            if card.ability.extra.conejos > 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        for i = 1, card.ability.extra.conejos do
                            -- Ya no verificamos el límite, forzamos la creación
                            G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    SMODS.add_card({ set = 'Joker', key = 'j_kranlaxs_bunny' })
                                    G.GAME.joker_buffer = 0
                                    return true
                                end
                            }))
                        end
                        return true
                    end
                }))
                
                return {
                    message = localize('k_plus_joker'),
                    colour = G.C.BLUE
                }
            end
        end
    end
}