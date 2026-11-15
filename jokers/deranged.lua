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

    in_pool = function(self, args)
        if SMODS.showman and SMODS.showman('j_kranlaxs_' .. self.key) then return true end
        local areas_to_check = {G.jokers, G.shop_jokers, G.pack_cards}
        for _, area in ipairs(areas_to_check) do
            if area and area.cards then
                for _, v in ipairs(area.cards) do
                    if v.config and v.config.center and v.config.center.key == 'j_kranlaxs_' .. self.key then return false end
                end
            end
        end
        return true
    end,
    
    check_for_unlock = function(self, args)
        if G and G.PROFILES and G.PROFILES[G.SETTINGS.profile] then
            if G.PROFILES[G.SETTINGS.profile].all_unlocked then return true end
            if G.PROFILES[G.SETTINGS.profile].challenge_progress and G.PROFILES[G.SETTINGS.profile].challenge_progress.completed then
                if G.PROFILES[G.SETTINGS.profile].challenge_progress.completed.c_kranlaxs_reto_doppelganger then return true end
            end
        end
        return false
    end,

    -- (UPDATE VACÍO: Dejamos de forzar el sprite en cada milisegundo)
    update = function(self, card, dt) end,
    
    loc_vars = function(self, info_queue, card)
        local mult_val = self.config.extra.mult
        local chips_val = self.config.extra.chips
        local is_mult = true

        if card and card.ability and card.ability.extra then
            mult_val = card.ability.extra.mult
            chips_val = card.ability.extra.chips
            is_mult = (card.ability.extra.mode == 'mult')
            if not card.config.center.unlocked or not card.config.center.discovered then
                return { vars = { mult_val, chips_val } }
            end
        end
        
        local current_key = is_mult and 'j_kranlaxs_deranged_mult' or 'j_kranlaxs_deranged_chips'
        return { key = current_key, vars = { mult_val, chips_val } }
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
            -- Rework: Cambia la lógica y el Sprite DESPUÉS de puntuar en un bloque unificado
            G.E_MANAGER:add_event(Event({func = function()
                card.ability.extra.mode = card.ability.extra.mode == 'mult' and 'chips' or 'mult'
                if card.children.center then
                    local target_x = (card.ability.extra.mode == 'mult') and 2 or 3
                    card.children.center:set_sprite_pos({x = target_x, y = 8}) 
                end
                card:juice_up(0.5, 0.5)
                return true
            end}))
            return { message = localize('k_reset'), colour = G.C.PURPLE }
        end
    end
}