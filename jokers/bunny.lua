SMODS.Joker{
    key = "bunny",
    config = {
        extra = {
            x_bonus = 0.5
        }
    },
    pos = { x = 2, y = 3 },
    display_size = { w = 71, h = 95 },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    no_collection = true,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_prey"] = true },

    -- ==========================================
    -- REGLAS DE APARICIÓN UNIFICADAS
    -- ==========================================
    in_pool = function(self, args)
        if not args then return true end
        
        -- Regla 1: Mantenemos la restricción para que no salga en tiendas o paquetes normales
        if args.source == 'sho' or args.source == 'buf' then return false end
        
        -- Regla 2: Escanear tu barra de Jokers para evitar duplicados idénticos
        if G.jokers and G.jokers.cards then
            for _, v in ipairs(G.jokers.cards) do
                if v.config.center.key == 'j_kranlaxs_' .. self.key then
                    return false 
                end
            end
        end
        
        return true
    end,
    
    loc_vars = function(self, info_queue, card)
        local bunny_count = 0
        if G.jokers and G.jokers.cards then
            for _, v in ipairs(G.jokers.cards) do
                if v.config.center.key == 'j_kranlaxs_bunny' then
                    bunny_count = bunny_count + 1
                end
            end
        end
        
        -- Calculamos el total actual: Base 1 + (0.5 * Número de conejos)
        local current_xmult = 1 + (bunny_count * card.ability.extra.x_bonus)
        
        return {vars = {card.ability.extra.x_bonus, current_xmult}}
    end,
    
    calculate = function(self, card, context)
        if context.joker_main then
            local bunny_count = 0
            
            -- Contamos cuántos conejos hay en el área de comodines
            if G.jokers and G.jokers.cards then
                for _, v in ipairs(G.jokers.cards) do
                    if v.config.center.key == 'j_kranlaxs_bunny' then
                        bunny_count = bunny_count + 1
                    end
                end
            end
            
            -- ¡Corregido! Debe comenzar a sumar desde 1, ya que el multiplicador base es X1
            local final_xmult = 1 + (bunny_count * card.ability.extra.x_bonus)
            
            -- Entregamos el multiplicador si es mayor a 1
            if final_xmult > 1 then
                return {
                    message = "X" .. final_xmult,
                    Xmult_mod = final_xmult,
                    colour = G.C.MULT
                }
            end
        end
    end
}