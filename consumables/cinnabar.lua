SMODS.Consumable {
    key = 'cinnabar',
    set = 'Quartz',
    pos = { x = 15, y = 0 }, -- Ajusta a tu Atlas
    cost = 5,
    unlocked = false, -- ¡Cambiado a false para que inicie bloqueado!
    discovered = false,
    unlock_condition = {type = '', extra = ''},
    atlas = 'QuartzConsumables',
    config = { extra = { mult = 40, mult_mod = 5 } },
    
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult, card.ability.extra.mult_mod}}
    end,
    
    can_use = function(self, card)
        return false -- Es pasivo
    end,
    
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.blueprint then
            if context.other_card == context.scoring_hand[1] then
                if card.ability.extra.mult > 0 then
                    local mult_to_give = card.ability.extra.mult
                    
                    -- Decrementa el multiplicador
                    card.ability.extra.mult = card.ability.extra.mult - card.ability.extra.mult_mod
                    card:juice_up()

                    return {
                        mult = mult_to_give,
                        card = card,
                        colour = G.C.MULT
                    }
                end
            end
        end
    end,

    -- Función nativa para gestionar el desbloqueo
    check_for_unlock = function(self, args)
        if args.type == 'win' then
            -- Comprueba que la baraja sea la Abandonada ('b_abandoned') y el pozo sea tu Pozo Marrón
            if G.GAME.selected_back.effect.center.key == 'b_abandoned' and G.GAME.stake == 'kranlaxs_brown' then
                return true -- ¡Desbloqueado!
            end
        end
        return false
    end
}