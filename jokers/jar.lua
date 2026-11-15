SMODS.Joker {
    key = 'jar',
    atlas = 'CustomJokers',
    pos = { x = 09, y = 10 },
    rarity = 'kranlaxs_zenith', -- Rareza Zenith
    cost = 10,
    bm_cost = 4, -- Costo de 4 Tokens en el Mercado Negro
    unlocked = false,
    discovered = false,
    blueprint_compat = false,
    config = { extra = { max_stored = 5, stored_jokers = {} } },
    
    check_for_unlock = function(self, args)
        if args.type == 'win' and G.GAME.stake >= 13 then
            if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
                G.PROFILES[G.SETTINGS.profile].kranlaxs_glass_wins = (G.PROFILES[G.SETTINGS.profile].kranlaxs_glass_wins or 0) + 1
                G:save_progress()
            end
        end
        local count = G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].kranlaxs_glass_wins or 0
        if count >= 5 then return true end
        return false
    end,

    locked_loc_vars = function(self, info_queue, card)
        local count = G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].kranlaxs_glass_wins or 0
        return { vars = { count } }
    end,

    loc_vars = function(self, info_queue, card)
        local empty_str = "Vacío"
        if G.SETTINGS.language == 'en-us' then empty_str = "Empty" 
        elseif G.SETTINGS.language == 'pt_BR' then empty_str = "Vazio" end
        
        local stored = (card and card.ability and card.ability.extra and card.ability.extra.stored_jokers) or {}
        local names = {}
        for i = 1, 5 do
            if stored[i] then
                local center = G.P_CENTERS[stored[i]]
                names[i] = center and localize{type='name_text', key=center.key, set='Joker'} or stored[i]
                if center then info_queue[#info_queue+1] = center end
            else
                names[i] = empty_str
            end
        end

        local ante = (G.GAME and G.GAME.round_resets and G.GAME.round_resets.ante) or 1
        local pen_cost = 4 * #stored * ante

        return { vars = { #stored, card.ability.extra.max_stored, pen_cost, names[1], names[2], names[3], names[4], names[5] } }
    end,
    
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

    -- FIX: Fuerza el valor de venta del Joker permanentemente a 0$
    update = function(self, card, dt)
        if card.sell_cost ~= 0 then
            card.sell_cost = 0
        end
    end,
    
    calculate = function(self, card, context)
        if context.blueprint then return end

        -- 1. Capturar Joker vendido a la izquierda inmediata
        if context.selling_card and context.card.ability.set == 'Joker' and context.card ~= card then
            local my_pos = nil
            local sold_pos = nil
            
            if G.jokers and G.jokers.cards then
                for i = 1, #G.jokers.cards do
                    if G.jokers.cards[i] == card then my_pos = i end
                    if G.jokers.cards[i] == context.card then sold_pos = i end
                end
            end

            -- Si estaba a la izquierda inmediata
            if my_pos and sold_pos and sold_pos == (my_pos - 1) then
                local sold_key = context.card.config.center.key
                card.ability.extra.stored_jokers = card.ability.extra.stored_jokers or {}
                
                table.insert(card.ability.extra.stored_jokers, sold_key)
                
                -- Sobreescribir el más antiguo si supera el límite de 5
                if #card.ability.extra.stored_jokers > card.ability.extra.max_stored then
                    table.remove(card.ability.extra.stored_jokers, 1)
                end
                
                card:juice_up(0.3, 0.4)
                return {
                    message = "¡Registrado!",
                    colour = G.C.PURPLE
                }
            end
        end

        -- 2. Al vender la Jarra: Cobra penalización y crea los Jokers almacenados
        if context.selling_self then
            local stored = card.ability.extra.stored_jokers or {}
            local ante = (G.GAME and G.GAME.round_resets and G.GAME.round_resets.ante) or 1
            local cost_penalty = 4 * #stored * ante
            
            if cost_penalty > 0 then
                ease_dollars(-cost_penalty)
            end

            if #stored > 0 then
                for _, stored_key in ipairs(stored) do
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.2,
                        func = function()
                            play_sound('tarot1')
                            local new_joker = create_card('Joker', G.jokers, nil, nil, nil, nil, stored_key, 'jar_spawn')
                            new_joker:add_to_deck()
                            G.jokers:emplace(new_joker)
                            new_joker:juice_up(0.3, 0.5)
                            return true
                        end
                    }))
                end
            end
        end
    end
}