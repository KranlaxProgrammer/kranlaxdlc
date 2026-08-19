SMODS.Joker{
    key = "vipsuscription",
    config = {
        extra = {
            suscription = 10,
            extraslots = 1,
            applied_slots = 0, -- ¡NUEVO! Rastrea cuántos espacios se han añadido realmente a la tienda
            activo = 0
        }
    },
    pos = { x = 2, y = 2 },
    display_size = { w = 71, h = 95 },
    cost = 4,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    
    unlocked = false, -- ¡Cambiado a false para activar el candado!
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    -- Función que atrapa la victoria en Pozo Naranja
    check_for_unlock = function(self, args)
        if args and args.type == 'win' then
            -- Verificamos Pozo Naranja (stake == 7) y la baraja Reto Semanal
            if G.GAME and G.GAME.stake == 7 and G.GAME.selected_back and G.GAME.selected_back.effect.center.key == 'b_kranlaxs_week_challenge' then
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
        return {vars = {card.ability.extra.suscription, card.ability.extra.extraslots}}
    end,

    -- ¡EFECTOS PASIVOS AL OBTENER LA CARTA!
    add_to_deck = function(self, card, from_debuff)
        -- Otorga exactamente +1 permanente mientras tengas la carta
        SMODS.change_voucher_limit(1)
        SMODS.change_booster_limit(1)
    end,

    -- ¡REVERSIÓN DE EFECTOS AL VENDER/PERDER LA CARTA!
    remove_from_deck = function(self, card, from_debuff)
        -- Quita el +1 de Vouchers y Boosters
        SMODS.change_voucher_limit(-1)
        SMODS.change_booster_limit(-1)
        
        -- Quita exactamente la cantidad de espacios de tienda que esta carta añadió
        if card.ability.extra.applied_slots > 0 then
            change_shop_size(-card.ability.extra.applied_slots)
        end
    end,
    
    calculate = function(self, card, context)
        -- Cobrar suscripción y dar los espacios al entrar a la tienda
        if context.starting_shop and not context.blueprint then
            if card.ability.extra.activo == 0 then
                local cost = card.ability.extra.suscription
                -- Calculamos solo la diferencia a añadir (ej: si tenías +1 y pasas a +2, solo añade 1)
                local slots_to_add = card.ability.extra.extraslots - card.ability.extra.applied_slots
                
                G.E_MANAGER:add_event(Event({
                    func = function()
                        ease_dollars(-cost)
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = "-$" .. cost, colour = G.C.MONEY})
                        return true
                    end
                }))
                
                G.E_MANAGER:add_event(Event({
                    delay = 0.5,
                    func = function()
                        -- Solo ajustamos el tamaño si hay espacios nuevos que agregar
                        if slots_to_add > 0 then
                            change_shop_size(slots_to_add)
                            -- Guardamos en la memoria que ya aplicamos estos espacios
                            card.ability.extra.applied_slots = card.ability.extra.extraslots
                        end
                        
                        card.ability.extra.activo = 1
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Upgraded!", colour = G.C.BLUE})
                        return true
                    end
                }))
            end
        end

        -- Renovar la suscripción tras vencer al Jefe Ciega
        if context.end_of_round and context.main_eval and not context.blueprint then
            if G.GAME.blind and G.GAME.blind.boss then
                if to_big(G.GAME.dollars) >= to_big(card.ability.extra.suscription) then
                    card.ability.extra.suscription = math.floor(card.ability.extra.suscription * 1.5)
                    card.ability.extra.extraslots = card.ability.extra.extraslots + 1
                    card.ability.extra.activo = 0
                    
                    return {
                        message = "Renewed!",
                        colour = G.C.GREEN
                    }
                end
            end
        end
    end
}