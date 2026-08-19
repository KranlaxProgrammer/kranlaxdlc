SMODS.Joker{
    key = 'deranged',
    config = { extra = { mode = 'mult', mult = 25, chips = 50 } },
    rarity = 1,
    atlas = 'CustomJokers',
    pos = { x = 2, y = 8 }, 
    cost = 4,
    blueprint_compat = true,
    unlocked = false,
    discovered = false,
    unlock_condition = {type = '', extra = ''},
    
    check_for_unlock = function(self, args)
        if G and G.PROFILES and G.PROFILES[G.SETTINGS.profile] then
            if G.PROFILES[G.SETTINGS.profile].all_unlocked then return true end
            if G.PROFILES[G.SETTINGS.profile].challenge_progress and G.PROFILES[G.SETTINGS.profile].challenge_progress.completed then
                if G.PROFILES[G.SETTINGS.profile].challenge_progress.completed.c_kranlaxs_reto_doppelganger then return true end
            end
        end
        return false
    end,

    update = function(self, card, dt)
        if card.config.center.unlocked and card.config.center.discovered then
            if card.children.center then
                local target_x = (card.ability.extra.mode == 'mult') and 2 or 3
                if card.children.center.sprite_pos.x ~= target_x or card.children.center.sprite_pos.y ~= 8 then
                    card.children.center:set_sprite_pos({x = target_x, y = 8}) 
                end
            end
        end
    end,

    -- AQUÍ OCURRE LA MAGIA (Corregida para el candado)
    loc_vars = function(self, info_queue, card)
        -- 1. Usamos valores por defecto seguros desde la raíz para evitar los "+nil"
        local mult_val = self.config.extra.mult
        local chips_val = self.config.extra.chips
        local is_mult = true

        -- 2. Verificamos si la carta existe físicamente en el juego
        if card and card.ability and card.ability.extra then
            mult_val = card.ability.extra.mult
            chips_val = card.ability.extra.chips
            is_mult = (card.ability.extra.mode == 'mult')
            
            -- ¡EL SEGURO!: Si la carta está bloqueada o sin descubrir en la colección, 
            -- abortamos el cambio dinámico. Dejamos que Balatro ponga su candado normal.
            if not card.config.center.unlocked or not card.config.center.discovered then
                return { vars = { mult_val, chips_val } }
            end
        end
        
        -- 3. Si ya está desbloqueada y en partida, aplicamos el texto dinámico
        local current_key = is_mult and 'j_kranlaxs_deranged_mult' or 'j_kranlaxs_deranged_chips'
        
        return { 
            key = current_key, 
            vars = { mult_val, chips_val } 
        }
    end,
    
    calculate = function(self, card, context)
        if context.joker_main then
            if card.ability.extra.mode == 'mult' then
                return { mult_mod = card.ability.extra.mult, message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}} }
            else
                return { chip_mod = card.ability.extra.chips, message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}} }
            end
        end
        if context.after and not context.blueprint then
            card.ability.extra.mode = card.ability.extra.mode == 'mult' and 'chips' or 'mult'
            G.E_MANAGER:add_event(Event({func = function()
                card:juice_up(0.5, 0.5)
                return true
            end}))
            return { message = localize('k_reset'), colour = G.C.PURPLE }
        end
    end
}