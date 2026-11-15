SMODS.Tag {
    key = 'mega_invtarot',
    atlas = 'CustomTags', 
    pos = { x = 0, y = 0 },       
    config = { type = 'new_blind_choice' }, 
    
    loc_vars = function(self, info_queue)
        info_queue[#info_queue + 1] = G.P_CENTERS.p_kranlaxs_invtarot_instant_5_2
        return { vars = {} }
    end,
    
    apply = function(self, tag, context)
        if context.type == 'new_blind_choice' then
            local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
            
            tag:yep("+", G.C.PURPLE, function()
                local key = "p_kranlaxs_invtarot_instant_5_2"
                local card = Card(
                    G.play.T.x + G.play.T.w / 2 - G.CARD_W * 1.27 / 2,
                    G.play.T.y + G.play.T.h / 2 - G.CARD_H * 1.27 / 2,
                    G.CARD_W * 1.27,
                    G.CARD_H * 1.27,
                    G.P_CARDS.empty,
                    G.P_CENTERS[key],
                    { bypass_discovery_center = true, bypass_discovery_ui = true }
                )
                card.cost = 0
                card.from_tag = true
                
                G.FUNCS.use_card({ config = { ref_table = card } })
                card:start_materialize()
                
                G.CONTROLLER.locks[lock] = nil
                return true
            end)
            
            tag.triggered = true
            return true
        end
    end
}

SMODS.Tag {
    key = 'mega_uno',
    atlas = 'CustomTags', 
    pos = { x = 1, y = 0 }, 
    config = { type = 'new_blind_choice' },
    
    loc_vars = function(self, info_queue)
        info_queue[#info_queue + 1] = G.P_CENTERS.p_kranlaxs_uno_store_5
        return { vars = {} }
    end,
    
    apply = function(self, tag, context)
        if context.type == 'new_blind_choice' then
            local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
            
            tag:yep("+", G.C.RED, function()
                local key = "p_kranlaxs_uno_store_5"
                local card = Card(
                    G.play.T.x + G.play.T.w / 2 - G.CARD_W * 1.27 / 2,
                    G.play.T.y + G.play.T.h / 2 - G.CARD_H * 1.27 / 2,
                    G.CARD_W * 1.27,
                    G.CARD_H * 1.27,
                    G.P_CARDS.empty,
                    G.P_CENTERS[key],
                    { bypass_discovery_center = true, bypass_discovery_ui = true }
                )
                card.cost = 0
                card.from_tag = true
                
                G.FUNCS.use_card({ config = { ref_table = card } })
                card:start_materialize()
                
                G.CONTROLLER.locks[lock] = nil
                return true
            end)
            
            tag.triggered = true
            return true
        end
    end
}

SMODS.Tag {
    key = 'mega_invtarot_store',
    atlas = 'CustomTags', 
    pos = { x = 2, y = 0 }, 
    config = { type = 'new_blind_choice' },
    
    loc_vars = function(self, info_queue)
        info_queue[#info_queue + 1] = G.P_CENTERS.p_kranlaxs_invtarot_store_5_2
        return { vars = {} }
    end,
    
    apply = function(self, tag, context)
        if context.type == 'new_blind_choice' then
            local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
            
            tag:yep("+", G.C.PURPLE, function()
                local key = "p_kranlaxs_invtarot_store_5_2"
                local card = Card(
                    G.play.T.x + G.play.T.w / 2 - G.CARD_W * 1.27 / 2,
                    G.play.T.y + G.play.T.h / 2 - G.CARD_H * 1.27 / 2,
                    G.CARD_W * 1.27,
                    G.CARD_H * 1.27,
                    G.P_CARDS.empty,
                    G.P_CENTERS[key],
                    { bypass_discovery_center = true, bypass_discovery_ui = true }
                )
                card.cost = 0
                card.from_tag = true
                
                G.FUNCS.use_card({ config = { ref_table = card } })
                card:start_materialize()
                
                G.CONTROLLER.locks[lock] = nil
                return true
            end)
            
            tag.triggered = true
            return true
        end
    end
}

SMODS.Tag {
    key = 'quartz_tag',
    atlas = 'CustomTags',
    pos = { x = 3, y = 0 }, 
    min_ante = 2,
    config = { type = 'immediate' },
    
    loc_vars = function(self, info_queue)
        return { vars = {} }
    end,
    
    apply = function(self, tag, context)
        if context.type == 'immediate' then
            if G.consumeables and #G.consumeables.cards < G.consumeables.config.card_limit then
                local valid_cards = {}
                for k, v in pairs(G.P_CENTERS) do
                    if v.set == 'Quartz' and not v.no_pool and v.unlocked then
                        table.insert(valid_cards, k)
                    end
                end
                
                local lock = tag.ID
                G.CONTROLLER.locks[lock] = true
                
                if #valid_cards > 0 then
                    tag:yep("+ Cuarzo", G.C.PURPLE, function()
                        local c_key = pseudorandom_element(valid_cards, pseudoseed('quartz_tag_gen'))
                        local card = create_card('Consumeables', G.consumeables, nil, nil, nil, nil, c_key, 'quartz_tag')
                        card:add_to_deck()
                        G.consumeables:emplace(card)
                        
                        G.CONTROLLER.locks[lock] = nil
                        return true
                    end)
                else
                    tag:yep("Nada", G.C.DARK_EDITION, function()
                        G.CONTROLLER.locks[lock] = nil
                        return true
                    end)
                end
                
                tag.triggered = true
                return true
            else
                tag:nope()
                return false
            end
        end
    end
}

SMODS.Tag {
    key = 'sticker_remover',
    atlas = 'CustomTags',
    pos = { x = 4, y = 0 }, 
    min_ante = 2, -- Ahora puede aparecer a partir de la apuesta 2
    config = { type = 'immediate' },
    
    loc_vars = function(self, info_queue)
        return { vars = {} }
    end,
    
    apply = function(self, tag, context)
        if context.type == 'immediate' then
            local eligible_jokers = {}
            
            if G.jokers and G.jokers.cards then
                for _, v in ipairs(G.jokers.cards) do
                    if v.ability.eternal or v.ability.perishable or v.ability.rental or v.ability.cegado or (v.pinned and not G.GAME.challenge) then
                        table.insert(eligible_jokers, v)
                    end
                end
            end
            
            if #eligible_jokers > 0 then
                local lock = tag.ID
                G.CONTROLLER.locks[lock] = true
                
                tag:yep("- Sticker", G.C.ATTENTION, function()
                    local card = pseudorandom_element(eligible_jokers, pseudoseed('cleanser_joker'))
                    
                    local stickers = {}
                    if card.ability.eternal then table.insert(stickers, 'eternal') end
                    if card.ability.perishable then table.insert(stickers, 'perishable') end
                    if card.ability.rental then table.insert(stickers, 'rental') end
                    if card.ability.cegado then table.insert(stickers, 'cegado') end
                    if card.pinned and not G.GAME.challenge then table.insert(stickers, 'pinned') end
                    
                    local picked = pseudorandom_element(stickers, pseudoseed('cleanser_sticker'))
                    
                    if picked == 'eternal' then
                        card.ability.eternal = nil
                    elseif picked == 'perishable' then
                        card.ability.perishable = nil
                        card.ability.perish_tally = G.GAME.perishable_jokers_tally or 5
                        card.debuff = false 
                    elseif picked == 'rental' then
                        card.ability.rental = nil
                    elseif picked == 'cegado' then
                        card.ability.cegado = nil
                        card.ability.cegado_debuffed = nil
                        card.debuff = false
                    elseif picked == 'pinned' then
                        card.pinned = false
                    end
                    
                    card:set_cost()
                    card:juice_up(0.3, 0.5)
                    play_sound('tarot1')
                    G.CONTROLLER.locks[lock] = nil
                    return true
                end)
                tag.triggered = true
                return true
            else
                -- Si no hay nada que limpiar, no se gasta la etiqueta
                tag:nope()
                return false
            end
        end
    end
}

SMODS.Tag {
    key = 'legendary',
    atlas = 'CustomTags',
    pos = { x = 5, y = 0 }, 
    min_ante = 8,
    config = { type = 'store_joker_create' },
    
    loc_vars = function(self, info_queue)
        return { vars = {} }
    end,
    
    apply = function(self, tag, context)
        if context.type == 'store_joker_create' then
            local card = create_card("Joker", context.area, true, nil, nil, nil, nil, "legendary_tag")
            create_shop_card_ui(card, "Joker", context.area)
            card.states.visible = false
            
            tag:yep("Legendaria", G.C.RARITY[4], function()
                card:start_materialize()
                card.ability.couponed = true 
                card:set_cost()
                card.cost = 0 
                return true
            end)
            
            tag.triggered = true
            return card 
        end
    end
}

SMODS.Tag {
    key = 'cosmic_tag',
    atlas = 'CustomTags',
    min_ante = 2,
    pos = { x = 0, y = 1 }, 
    config = { type = 'immediate' },
    loc_vars = function(self, info_queue) return { vars = {} } end,
    
    apply = function(self, tag, context)
        if context.type == 'immediate' then
            local valid_cards = {}
            if G.playing_cards and #G.playing_cards > 0 then
                for _, c in ipairs(G.playing_cards) do
                    if not c.edition then table.insert(valid_cards, c) end
                end
            end
            
            if #valid_cards > 0 then
                local lock = tag.ID
                G.CONTROLLER.locks[lock] = true 
                
                tag:yep("¡Cósmico!", G.C.DARK_EDITION, function()
                    local card = pseudorandom_element(valid_cards, pseudoseed('cosmic_tag'))
                    card:set_edition({kranlaxs_cosmic = true}, true, true)
                    card:juice_up()
                    play_sound('kranlaxs_cosmicedition', 1, 1)
                    G.CONTROLLER.locks[lock] = nil
                    return true
                end)
                tag.triggered = true
                return true
            else
                tag:nope()
                return false
            end
        end
    end
}

SMODS.Tag {
    key = 'yellowish_tag',
    atlas = 'CustomTags',
    min_ante = 2,
    pos = { x = 1, y = 1 }, 
    config = { type = 'immediate' },
    loc_vars = function(self, info_queue) return { vars = {} } end,
    
    apply = function(self, tag, context)
        if context.type == 'immediate' then
            local valid_cards = {}
            if G.playing_cards and #G.playing_cards > 0 then
                for _, c in ipairs(G.playing_cards) do
                    if not c.edition then table.insert(valid_cards, c) end
                end
            end
            
            if #valid_cards > 0 then
                local lock = tag.ID
                G.CONTROLLER.locks[lock] = true
                
                tag:yep("¡Sepia!", G.C.ORANGE, function()
                    local card = pseudorandom_element(valid_cards, pseudoseed('yellowish_tag'))
                    card:set_edition({kranlaxs_sepia = true}, true, true)
                    card:juice_up()
                    play_sound('kranlaxs_sepiaedition', 1, 1)
                    G.CONTROLLER.locks[lock] = nil
                    return true
                end)
                tag.triggered = true
                return true
            else
                tag:nope()
                return false
            end
        end
    end
}

SMODS.Tag {
    key = 'boring_tag',
    atlas = 'CustomTags',
    min_ante = 2,
    pos = { x = 2, y = 1 }, 
    config = { type = 'store_joker_create' },
    loc_vars = function(self, info_queue) return { vars = {} } end,
    
    apply = function(self, tag, context)
        if context.type == 'store_joker_create' then
            local card = create_card("Joker", context.area, nil, nil, nil, nil, nil, "boring_tag")
            card:set_edition({kranlaxs_monochrome = true}, true, true)
            create_shop_card_ui(card, "Joker", context.area)
            card.states.visible = false
            
            tag:yep("Monocromo", G.C.DARK_EDITION, function()
                play_sound('kranlaxs_monochromeedition', 1, 1)
                card:start_materialize()
                return true
            end)
            tag.triggered = true
            return card
        end
    end
}

SMODS.Tag {
    key = 'demonic_tag',
    atlas = 'CustomTags',
    min_ante = 2,
    pos = { x = 3, y = 1 }, 
    config = { type = 'store_joker_create' },
    
    in_pool = function(self, args)
        if G.GAME and G.FUNCS.has_holy_joker and G.FUNCS.has_holy_joker() then 
            return false 
        end
        return true
    end,
    
    loc_vars = function(self, info_queue) return { vars = {} } end,
    
    apply = function(self, tag, context)
        if context.type == 'store_joker_create' then
            local card = create_card("Joker", context.area, nil, nil, nil, nil, nil, "demonic_tag")
            card:set_edition({kranlaxs_cursed = true}, true, true)
            create_shop_card_ui(card, "Joker", context.area)
            card.states.visible = false
            
            tag:yep("Maldito", G.C.RED, function()
                play_sound('kranlaxs_eviledition', 1, 1)
                card:start_materialize()
                return true
            end)
            tag.triggered = true
            return card
        end
    end
}

SMODS.Tag {
    key = 'wet_tag',
    atlas = 'CustomTags',
    min_ante = 2,
    pos = { x = 4, y = 1 }, 
    config = { type = 'immediate' },
    loc_vars = function(self, info_queue) return { vars = {} } end,
    
    apply = function(self, tag, context)
        if context.type == 'immediate' then
            local valid_cards = {}
            if G.playing_cards and #G.playing_cards > 0 then
                for _, c in ipairs(G.playing_cards) do
                    if not c.edition then table.insert(valid_cards, c) end
                end
            end
            
            if #valid_cards > 0 then
                local lock = tag.ID
                G.CONTROLLER.locks[lock] = true
                
                tag:yep("Acuático", G.C.BLUE, function()
                    local card = pseudorandom_element(valid_cards, pseudoseed('wet_tag'))
                    card:set_edition({kranlaxs_underwater = true}, true, true)
                    card:juice_up()
                    play_sound('kranlaxs_underwateredition', 1, 1)
                    G.CONTROLLER.locks[lock] = nil
                    return true
                end)
                tag.triggered = true
                return true
            else
                tag:nope()
                return false
            end
        end
    end
}

SMODS.Tag {
    key = 'zen_tag',
    atlas = 'CustomTags',
    min_ante = 2,
    pos = { x = 5, y = 1 }, 
    config = { type = 'immediate' },
    loc_vars = function(self, info_queue) return { vars = {} } end,
    
    apply = function(self, tag, context)
        if context.type == 'immediate' then
            local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
            
            tag:yep("-1 Apuesta", G.C.BLUE, function()
                ease_ante(-1)
                play_sound('timpani')
                G.CONTROLLER.locks[lock] = nil
                return true
            end)
            tag.triggered = true
            return true
        end
    end
}