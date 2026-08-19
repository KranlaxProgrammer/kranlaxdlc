SMODS.Consumable {
    key = 'turquoisequartz',
    set = 'Quartz',
    pos = { x = 12, y = 0 }, -- Ajusta la posición de tu Sprite Sheet
    cost = 6,
    unlocked = false, -- ¡Cambiado a false para que inicie bloqueado!
    discovered = false,
    unlock_condition = {type = '', extra = ''},
    atlas = 'QuartzConsumables',
    
    can_use = function(self, card)
        return false -- Es totalmente pasivo
    end,

    calculate = function(self, card, context)
        -- Reactiva el primer comodín exactamente 2 veces
        if context.retrigger_joker_check and not context.retrigger_joker and context.other_joker then
            if G.jokers and G.jokers.cards and G.jokers.cards[1] == context.other_joker then
                return {
                    message = '¡Reactivado!',
                    repetitions = 2,
                    card = context.other_joker
                }
            end
        end
    end,

    -- Función nativa para gestionar el desbloqueo
    check_for_unlock = function(self, args)
        if args.type == 'win' then
            -- Comprueba que la baraja sea la Zodiacal ('b_zodiac') y el pozo sea tu Pozo Turquesa
            if G.GAME.selected_back.effect.center.key == 'b_zodiac' and G.GAME.stake == 'kranlaxs_turquoise' then
                return true -- ¡Desbloqueado!
            end
        end
        return false
    end
}

-- ====================================================================================
-- ESCUCHADOR DE DESVENTAJA (DEBUFF)
-- Apaga todos los comodines excepto el primero mientras tengas este cuarzo
-- ====================================================================================
if not SMODS.turquoise_hooked then
    local original_set_debuff = Card.set_debuff
    function Card:set_debuff(card)
        original_set_debuff(self, card)
        
        -- Si esta carta es un Joker y tienes consumibles...
        if self.area == G.jokers and G.consumeables then
            local has_turq = false
            for _, c in ipairs(G.consumeables.cards) do
                if c.config.center.key == 'c_kranlaxs_turquoisequartz' then 
                    has_turq = true 
                    break 
                end
            end
            
            -- Si tienes el cuarzo turquesa y este NO es el primer Joker, apágalo
            if has_turq then
                if self ~= G.jokers.cards[1] then
                    self.debuff = true
                end
            end
        end
    end
    SMODS.turquoise_hooked = true
end