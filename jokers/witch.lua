SMODS.Joker {
    key = 'witch',
    atlas = 'CustomJokers',
    pos = { x = 08, y = 012 },
    rarity = 3,
    cost = 8,
    unlocked = false,
    discovered = false,
    blueprint_compat = false,
    
    check_for_unlock = function(self, args)
        if args.type == 'win' then
            -- Pozo Negro = stake >= 4
            if G.GAME.selected_back.effect.center.key == 'b_kranlaxs_evil_deck' and G.GAME.stake >= 4 then
                return true
            end
        end
        return false
    end,

    loc_vars = function(self, info_queue, card)
        -- Añade el globo de información explicativo de la edición Maldita
        if G.P_CENTERS and G.P_CENTERS.e_kranlaxs_cursed then
            info_queue[#info_queue + 1] = G.P_CENTERS.e_kranlaxs_cursed
        end
        return { vars = {} }
    end,
    
    in_pool = function(self, args)
        -- Bloqueo por Joker Sagrado
        if G.GAME and G.FUNCS.has_holy_joker and G.FUNCS.has_holy_joker() then 
            return false 
        end
        
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
    end
}

-- ==========================================
-- HOOK: Forzar edición Maldita al obtener un nuevo Joker
-- ==========================================
if not SMODS.kranlaxs_witch_hook then
    local orig_add_to_deck = Card.add_to_deck
    function Card:add_to_deck(from_debuff)
        -- Guardamos si la carta ya estaba en el mazo (vital para no maldecir al cargar un save)
        local was_added = self.added_to_deck
        
        if orig_add_to_deck then orig_add_to_deck(self, from_debuff) end
        
        -- Si es la primera vez que se añade a tu área, es un Joker, y no tiene edición:
        if not was_added and not from_debuff and self.ability and self.ability.set == 'Joker' and not self.edition then
            if G.jokers and G.jokers.cards then
                local witch_card = nil
                -- Buscamos si ya poseemos una Bruja activa
                for _, j in ipairs(G.jokers.cards) do
                    if j.config and j.config.center and j.config.center.key == 'j_kranlaxs_witch' and not j.debuff and j ~= self then
                        witch_card = j
                        break
                    end
                end
                
                -- Si tenemos una Bruja activa, aplicamos la maldición
                if witch_card then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.2,
                        func = function()
                            self:set_edition({kranlaxs_cursed = true}, true, true)
                            witch_card:juice_up(0.3, 0.3)
                            play_sound('kranlaxs_eviledition', 1, 1)
                            card_eval_status_text(self, 'extra', nil, nil, nil, {message = "¡Maldición!", colour = G.C.RED})
                            return true
                        end
                    }))
                end
            end
        end
    end
    SMODS.kranlaxs_witch_hook = true
end