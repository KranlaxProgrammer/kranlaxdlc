SMODS.Joker{
    key = 'monk',
    config = { extra = { xchips = 1, xchips_add = 0.1, money_entered = 0, in_shop = false } },
    rarity = 1, -- Común
    atlas = 'CustomJokers',
    pos = { x = 0, y = 0 },
    cost = 4,
    blueprint_compat = true,
    
    loc_vars = function(self, info_queue, card)
        -- #1# = Aumento (0.1), #2# = Fichas Totales
        return { vars = { card.ability.extra.xchips_add, card.ability.extra.xchips } }
    end,
    
    update = function(self, card, dt)
        -- Detectamos el momento exacto en el que la tienda se genera y tomamos la "foto" del dinero
        if G.STATE == G.STATES.SHOP and not card.ability.extra.in_shop then
            card.ability.extra.in_shop = true
            card.ability.extra.money_entered = G.GAME.dollars
        end
        
        -- Limpieza de seguridad: si salimos de la tienda, reseteamos el estado para la siguiente ronda
        if G.STATE ~= G.STATES.SHOP and card.ability.extra.in_shop then
            card.ability.extra.in_shop = false
        end
    end,

    calculate = function(self, card, context)
        -- 1. Aplicar los XChips al puntuar la mano
        if context.joker_main then
            if card.ability.extra.xchips > 1 then
                return {
                    message = 'X' .. card.ability.extra.xchips,
                    x_chips = card.ability.extra.xchips,
                    Xchip_mod = card.ability.extra.xchips, -- Doble declaración para seguridad con Talisman
                    colour = G.C.CHIPS
                }
            end
        end
        
        -- 2. Evaluar la billetera justo al darle al botón de "Siguiente Ciega" o "Saltar"
        if context.ending_shop and not context.blueprint then
            local money_left = G.GAME.dollars
            local money_start = card.ability.extra.money_entered or 0
            
            -- Apagamos el candado
            card.ability.extra.in_shop = false
            
            if money_left >= money_start then
                -- El monje está en paz: No gastaste (o saliste con más dinero del que entraste)
                card.ability.extra.xchips = card.ability.extra.xchips + card.ability.extra.xchips_add
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.CHIPS
                }
            else
                -- El monje se decepciona: Tu dinero bajó
                if card.ability.extra.xchips > 1 then
                    card.ability.extra.xchips = 1
                    return {
                        message = localize('k_reset'),
                        colour = G.C.RED
                    }
                end
            end
        end
    end
}