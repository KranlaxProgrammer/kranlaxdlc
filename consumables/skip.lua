SMODS.Consumable {
    key = 'skip',
    set = 'UNOCards',
    pos = { x = 2, y = 0 }, 
    cost = 3,
    unlocked = true,
    discovered = false,
    hidden = false,
    can_repeat_soul = false,
    atlas = 'CustomConsumables',

    in_pool = function(self, args)
        if SMODS.showman and SMODS.showman('c_kranlaxs_' .. self.key) then return true end
        if not G.consumeables or not G.consumeables.cards then return true end
        for _, v in ipairs(G.consumeables.cards) do
            if v.config.center.key == 'c_kranlaxs_' .. self.key then return false end
        end
        return true
    end,
    
    can_use = function(self, card)
        -- Habilitado solo si exactamente 1 Joker está seleccionado
        if G.jokers and G.jokers.highlighted and #G.jokers.highlighted == 1 then
            local target = G.jokers.highlighted[1]
            
            -- Verifica si tiene algún sticker removible normal o custom
            if target.ability and (target.ability.eternal or target.ability.perishable or target.ability.rental or target.ability.cegado or target.ability.clover) then
                return true
            end
            
            -- Verifica el sticker fijado vanilla (solo si NO estamos en un reto)
            if target.pinned and not G.GAME.challenge then
                return true
            end
        end
        return false
    end,
    
    use = function(self, card, area, copier)
        local used_card = copier or card
        local target = G.jokers.highlighted[1]
        
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                used_card:juice_up(0.3, 0.5)
                
                -- Limpieza de Stickers Vanilla y Custom
                if target.ability then
                    target.ability.eternal = nil
                    target.ability.perishable = nil
                    target.ability.rental = nil
                    target.ability.cegado = nil
                    target.ability.cegado_debuffed = nil
                    target.ability.clover = nil
                end
                
                -- Limpieza del sticker Fijado vanilla condicional
                if not G.GAME.challenge then
                    target.pinned = false 
                end
                
                target:juice_up(0.5, 0.5)
                play_sound('tarot2')
                card_eval_status_text(target, 'extra', nil, nil, nil, {message = "¡Limpiado!", colour = G.C.ORANGE})
                
                return true
            end
        }))
    end
}