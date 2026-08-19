SMODS.Joker{
    key = "painterjoker",
    config = {
        extra = {
            cost = 4,
            queued_tags = 0 -- Añadimos el contador a la memoria de la carta
        }
    },
    pos = { x = 3, y = 2 },
    display_size = { w = 71, h = 95 },
    cost = 5,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    check_for_unlock = function(self, args)
        if args and args.type == 'win' then
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
        info_queue[#info_queue+1] = {set = 'Tag', key = 'tag_juggle'}
        local cost = (type(card.ability.extra.cost) == 'number') and card.ability.extra.cost or 4
        return {vars = {cost}}
    end,
    
    calculate = function(self, card, context)
        -- Limpiamos las deducciones de dinero al inicio de cada mano jugada
        if context.before then
            G.GAME.painter_deductions = 0
        end

        -- TRAS JUGAR LA MANO: Escaneamos, cobramos y "Encolamos"
        if context.after and not context.blueprint_card then
            local cost = (type(card.ability.extra.cost) == 'number') and card.ability.extra.cost or 4
            
            local wild_count = 0
            if G.hand and G.hand.cards then
                for _, c in ipairs(G.hand.cards) do
                    local is_wild = (c.ability.effect == 'Wild Card') or 
                                    (c.ability.name == 'Wild Card') or 
                                    (c.ability.name == 'Carta Versátil') or 
                                    (c.config.center.key == 'm_wild')
                    
                    if SMODS.has_enhancement then
                        is_wild = is_wild or SMODS.has_enhancement(c, 'm_wild')
                    end
                    
                    if is_wild then
                        wild_count = wild_count + 1
                    end
                end
            end
            
            if wild_count > 0 then
                local tags_to_create = 0
                local total_cost = 0
                
                G.GAME.painter_deductions = G.GAME.painter_deductions or 0
                local _to_big = to_big or function(x) return tonumber(x) or 0 end
                
                local current_dollars = _to_big(G.GAME.dollars or 0)
                local deductions = _to_big(G.GAME.painter_deductions)
                local big_cost = _to_big(cost)
                
                for i = 1, wild_count do
                    if current_dollars >= (deductions + big_cost) then
                        tags_to_create = tags_to_create + 1
                        deductions = deductions + big_cost
                        total_cost = total_cost + cost
                    else
                        break 
                    end
                end
                
                if tags_to_create > 0 then
                    G.GAME.painter_deductions = G.GAME.painter_deductions + total_cost
                    
                    -- GUARDAMOS LAS ETIQUETAS EN MEMORIA
                    card.ability.extra.queued_tags = (card.ability.extra.queued_tags or 0) + tags_to_create
                    
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            ease_dollars(-total_cost)
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = "-$" .. total_cost, colour = G.C.MONEY})
                            return true
                        end
                    }))
                    
                    return {
                        message = "+" .. tags_to_create .. " Queued!",
                        colour = G.C.ORANGE,
                        card = card
                    }
                end
            end
        end
        
        -- SOPORTE PARA BLUEPRINT EN LA FASE DE COBRO
        if context.after and context.blueprint_card then
            local cost = (type(card.ability.extra.cost) == 'number') and card.ability.extra.cost or 4
            local wild_count = 0
            if G.hand and G.hand.cards then
                for _, c in ipairs(G.hand.cards) do
                    local is_wild = (c.ability.effect == 'Wild Card') or (c.ability.name == 'Wild Card') or (c.ability.name == 'Carta Versátil') or (c.config.center.key == 'm_wild')
                    if SMODS.has_enhancement then is_wild = is_wild or SMODS.has_enhancement(c, 'm_wild') end
                    if is_wild then wild_count = wild_count + 1 end
                end
            end
            
            if wild_count > 0 then
                local tags_to_create = 0
                local total_cost = 0
                G.GAME.painter_deductions = G.GAME.painter_deductions or 0
                local _to_big = to_big or function(x) return tonumber(x) or 0 end
                
                local current_dollars = _to_big(G.GAME.dollars or 0)
                local deductions = _to_big(G.GAME.painter_deductions)
                local big_cost = _to_big(cost)
                
                for i = 1, wild_count do
                    if current_dollars >= (deductions + big_cost) then
                        tags_to_create = tags_to_create + 1
                        deductions = deductions + big_cost
                        total_cost = total_cost + cost
                    else
                        break
                    end
                end
                
                if tags_to_create > 0 then
                    G.GAME.painter_deductions = G.GAME.painter_deductions + total_cost
                    -- Lo encolamos en el Joker original para concentrar las recompensas
                    card.ability.extra.queued_tags = (card.ability.extra.queued_tags or 0) + tags_to_create
                    
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            ease_dollars(-total_cost)
                            card_eval_status_text(context.blueprint_card, 'extra', nil, nil, nil, {message = "-$" .. total_cost, colour = G.C.MONEY})
                            return true
                        end
                    }))
                    
                    return {
                        message = "+" .. tags_to_create .. " Queued!",
                        colour = G.C.ORANGE,
                        card = context.blueprint_card
                    }
                end
            end
        end

        -- AL FINAL DE LA RONDA: ENTREGAMOS TODOS LOS TAGS ACUMULADOS
        if context.end_of_round and not context.blueprint_card and not context.individual and not context.repetition then
            if card.ability.extra.queued_tags and card.ability.extra.queued_tags > 0 then
                local tags_to_give = card.ability.extra.queued_tags
                card.ability.extra.queued_tags = 0 -- Vaciamos la reserva
                
                G.E_MANAGER:add_event(Event({
                    func = function()
                        for i = 1, tags_to_give do
                            add_tag(Tag("tag_juggle"))
                        end
                        play_sound('generic1', 0.9 + math.random() * 0.2, 0.8)
                        play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                        return true
                    end
                }))
                
                return {
                    message = tags_to_give .. (tags_to_give == 1 and " Tag!" or " Tags!"),
                    colour = G.C.ORANGE,
                    card = card
                }
            end
        end

    end
}