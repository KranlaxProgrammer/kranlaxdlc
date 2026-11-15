SMODS.Joker {
    key = 'hojadecuaderno',
    atlas = 'CustomJokers',
    pos = { x = 012, y = 011 }, -- Ajusta la posición de tu atlas
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    loc_vars = function(self, info_queue, card)
        -- Muestra el tooltip de la Carta Suerte
        info_queue[#info_queue+1] = G.P_CENTERS.m_lucky
        return { vars = {} }
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

    calculate = function(self, card, context)
        if context.setting_blind then
            G.E_MANAGER:add_event(Event({
                func = function()
                    local front = pseudorandom_element(G.P_CARDS, pseudoseed('hojacuaderno_front'))
                    
                    local new_card = create_playing_card({
                        front = front,
                        center = G.P_CENTERS.m_lucky
                    }, G.deck, nil, nil, {G.C.SECONDARY_SET.Enhanced})
                    
                    play_sound('card1')
                    card:juice_up(0.5, 0.5)
                    return true
                end
            }))
            
            return {
                message = "¡Carta Suerte!",
                colour = G.C.SECONDARY_SET.Enhanced,
                card = card
            }
        end
    end
}