SMODS.Consumable{
    key = 'misery',
    set = 'UNOCards',
    cost = 4,
    unlocked = true,
    discovered = false,
    atlas = 'CustomConsumables', 
    pos = { x = 4, y = 3 }, 

    in_pool = function(self, args)
        if SMODS.showman and SMODS.showman('c_kranlaxs_' .. self.key) then return true end
        if not G.consumeables or not G.consumeables.cards then return true end
        for _, v in ipairs(G.consumeables.cards) do
            if v.config.center.key == 'c_kranlaxs_' .. self.key then return false end
        end
        return true
    end,
    
    can_use = function(self, card)
        
        if G.STATE ~= G.STATES.SELECTING_HAND then return false end
        if G.deck and #G.deck.cards > 0 then return true end
        return false
    end,
    
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                
                
                local function create_suit_button(label_text, choice_id, color)
                    local btn_config = {
                        align = "cm", minw = 4.5, minh = 1, padding = 0.1, r = 0.1, 
                        hover = true, 
                        colour = color, 
                        button = "misery_apply", 
                        id = choice_id, 
                        shadow = true
                    }
                    return {n=G.UIT.C, config={align="cm", padding=0.1}, nodes={
                        {n=G.UIT.C, config=btn_config, nodes={
                            {n=G.UIT.T, config={text=label_text, scale=0.4, colour=G.C.WHITE}}
                        }}
                    }}
                end

                
                local t = {n=G.UIT.ROOT, config={align="cm", colour=G.C.CLEAR}, nodes={
                    {n=G.UIT.C, config={align="cm", r=0.2, colour=G.C.BLACK, padding=0.3, shadow=true}, nodes={
                        {n=G.UIT.R, config={align="cm", padding=0.2}, nodes={
                            {n=G.UIT.T, config={text="Elige el Palo a buscar", scale=0.5, colour=G.C.WHITE, shadow=true}}
                        }},
                        {n=G.UIT.R, config={align="cm", padding=0.1}, nodes={
                            create_suit_button("Picas", "Spades", G.C.BLUE),
                            create_suit_button("Corazones", "Hearts", G.C.RED)
                        }},
                        {n=G.UIT.R, config={align="cm", padding=0.1}, nodes={
                            create_suit_button("Tréboles", "Clubs", G.C.GREEN),
                            create_suit_button("Diamantes", "Diamonds", G.C.ORANGE)
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
    end
}




G.FUNCS.misery_apply = function(e)
    local choice = e.config.id
    
    
    if G.OVERLAY_MENU then
        G.OVERLAY_MENU:remove()
        G.OVERLAY_MENU = nil
    end
    
    
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.2,
        func = function()
            local cards_to_draw = 0
            
            
            for i = #G.deck.cards, 1, -1 do
                cards_to_draw = cards_to_draw + 1
                if G.deck.cards[i]:is_suit(choice) then
                    break
                end
            end
            
            
            for i = 1, cards_to_draw do
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.15,
                    func = function()
                        if G.deck.cards[#G.deck.cards] then
                            draw_card(G.deck, G.hand, i * 100 / cards_to_draw, 'up', true)
                        end
                        return true
                    end
                }))
            end
            
            
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.3,
                func = function()
                    G.hand:sort()
                    return true
                end
            }))
            
            play_sound('tarot1')
            return true
        end
    }))
end