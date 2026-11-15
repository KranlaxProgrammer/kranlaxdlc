SMODS.Consumable {
    key = 'blackquartz',
    set = 'Quartz',
    pos = { x = 0, y = 0 },
    cost = 4,
    unlocked = false,
    discovered = false,
    unlock_condition = {type = '', extra = ''},
    atlas = 'QuartzConsumables',

    in_pool = function(self, args)
        if SMODS.showman and SMODS.showman('c_kranlaxs_' .. self.key) then return true end
        if not G.consumeables or not G.consumeables.cards then return true end
        for _, v in ipairs(G.consumeables.cards) do
            if v.config.center.key == 'c_kranlaxs_' .. self.key then return false end
        end
        return true
    end,
    
    can_use = function(self, card)
        return true 
    end,
    
    use = function(self, card, area, copier)
        local used_card = copier or card
        
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                local has_jokers = G.jokers and #G.jokers.cards > 0
                
                local function create_bq_button(label_text, choice_id, color, disabled)
                    local btn_config = {
                        align = "cm", minw = 4.5, minh = 1, padding = 0.1, r = 0.1, 
                        hover = not disabled, 
                        colour = disabled and G.C.UI.BACKGROUND_INACTIVE or color, 
                        button = disabled and nil or "black_quartz_apply",
                        id = choice_id, 
                        shadow = true
                    }
                    return {n=G.UIT.C, config={align="cm", padding=0.1}, nodes={
                        {n=G.UIT.C, config=btn_config, nodes={
                            {n=G.UIT.T, config={text=label_text, scale=0.35, colour=disabled and G.C.UI.TEXT_INACTIVE or G.C.WHITE}}
                        }}
                    }}
                end

                local t = {n=G.UIT.ROOT, config={align="cm", colour=G.C.CLEAR}, nodes={
                    {n=G.UIT.C, config={align="cm", r=0.2, colour=G.C.BLACK, padding=0.3, shadow=true}, nodes={
                        {n=G.UIT.R, config={align="cm", padding=0.2}, nodes={
                            {n=G.UIT.T, config={text="Elige un Beneficio", scale=0.6, colour=G.C.WHITE, shadow=true}}
                        }},
                        {n=G.UIT.R, config={align="cm", padding=0.1}, nodes={
                            create_bq_button("+ 1 mano", "hand", G.C.BLUE, false),
                            create_bq_button("+ 1 descarte", "discard", G.C.RED, false)
                        }},
                        {n=G.UIT.R, config={align="cm", padding=0.1}, nodes={
                            create_bq_button("+ 20$", "money", G.C.MONEY, false),
                            create_bq_button("+ 1 slot de consumible", "con_slot", G.C.PURPLE, false)
                        }},
                        {n=G.UIT.R, config={align="cm", padding=0.1}, nodes={
                            create_bq_button("+ 5 tags random", "tags", G.C.ORANGE, false),
                            create_bq_button("+ 1 slot de jokers", "joker_slot", G.C.DARK_EDITION, false)
                        }},
                        {n=G.UIT.R, config={align="cm", padding=0.1}, nodes={
                            create_bq_button("+ 1 tamaño de mano", "hand_size", G.C.GREEN, false),
                            create_bq_button("+ 1 copia negativa", "neg_joker", G.C.FILTER, not has_jokers)
                        }},
                        -- Nuevas opciones añadidas
                        {n=G.UIT.R, config={align="cm", padding=0.1}, nodes={
                            create_bq_button("+ 10 Tokens", "tokens", G.C.GOLD, false),
                            create_bq_button("Apuesta a 1", "ante", G.C.IMPORTANT, false)
                        }}
                    }}
                }}
                
                G.OVERLAY_MENU = UIBox{
                    definition = t,
                    config = {align="cm", offset = {x=0,y=0}, major = G.ROOM_ATTACH}
                }
                return true
            end
        }))
    end,

    check_for_unlock = function(self, args)
        if args.type == 'win' then
            if G.GAME.selected_back.effect.center.key == 'b_magic' and G.GAME.modifiers.TU_MODIFICADOR_MARRON_AQUI then
                return true
            end
        end
        return false
    end
}

G.FUNCS.black_quartz_apply = function(e)
    local choice = e.config.id
    
    if G.OVERLAY_MENU then
        G.OVERLAY_MENU:remove()
        G.OVERLAY_MENU = nil
    end
    
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.2,
        func = function()
            if choice == 'hand' then
                G.GAME.round_resets.hands = G.GAME.round_resets.hands + 1
                ease_hands_played(1)
            elseif choice == 'discard' then
                G.GAME.round_resets.discards = G.GAME.round_resets.discards + 1
                ease_discard(1)
            elseif choice == 'money' then
                ease_dollars(20)
            elseif choice == 'con_slot' then
                G.consumeables.config.card_limit = G.consumeables.config.card_limit + 1
            elseif choice == 'tags' then
                for i = 1, 5 do
                    local tag = Tag(get_next_tag_key('black_quartz_tags'))
                    add_tag(tag)
                end
                play_sound('generic1', 0.9, 1.5)
            elseif choice == 'joker_slot' then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            elseif choice == 'hand_size' then
                G.hand.config.card_limit = G.hand.config.card_limit + 1
                G.GAME.starting_params.hand_size = G.GAME.starting_params.hand_size + 1
            elseif choice == 'neg_joker' then
                if G.jokers and #G.jokers.cards > 0 then
                    local joker_to_copy = pseudorandom_element(G.jokers.cards, pseudoseed('bq_copy'))
                    local copied_joker = copy_card(joker_to_copy, nil, nil, nil, false)
                    copied_joker:start_materialize()
                    copied_joker:add_to_deck()
                    G.jokers:emplace(copied_joker)
                    copied_joker:set_edition('e_negative', true)
                end
            elseif choice == 'tokens' then
                -- Asume que la variable es kranlaxs_tokens. Cambialo si usas otra.
                G.GAME.kranlaxs_tokens = (G.GAME.kranlaxs_tokens or 0) + 10
            elseif choice == 'ante' then
                ease_ante(1 - G.GAME.round_resets.ante)
                G.GAME.round_resets.ante = 1
            end
            
            play_sound('tarot1')
            return true
        end
    }))
end