SMODS.Consumable {
    key = 'thehangedman',
    set = 'InverseTarot',
    pos = { x = 8, y = 1 },
    cost = 5,
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
    
    use = function(self, card, area, copier)
        local used_card = copier or card
        
        
        local affected_cards = {}
        for i = 1, #G.hand.highlighted do
            affected_cards[#affected_cards + 1] = G.hand.highlighted[i]
        end
        
        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.4,
            func = function()
                play_sound('tarot1')
                used_card:juice_up(0.3, 0.5)
                for _, c in ipairs(affected_cards) do
                    c:flip()
                end
                play_sound('card1', 1)
                return true
            end
        }))
        
        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.3,
            func = function()
                
                local ed_pool = {}
                for k, v in pairs(G.P_CENTERS) do
                    if v.set == 'Edition' then
                        
                        local short_key = string.gsub(k, "^e_", "")
                        table.insert(ed_pool, short_key)
                    end
                end
                
                local seal_pool = {}
                for k, v in pairs(G.P_SEALS) do
                    table.insert(seal_pool, k)
                end
                
                local enh_pool = {}
                for _, v in ipairs(G.P_CENTER_POOLS.Enhanced) do
                    table.insert(enh_pool, v)
                end

                for _, c in ipairs(affected_cards) do
                    
                    local _rank = pseudorandom_element(SMODS.Ranks, pseudoseed('h_rank'))
                    local _suit = pseudorandom_element(SMODS.Suits, pseudoseed('h_suit'))
                    SMODS.change_base(c, _suit.key, _rank.key)
                    
                    
                    if #ed_pool > 0 then
                        c:set_edition({[pseudorandom_element(ed_pool, pseudoseed('h_ed'))] = true}, true, true)
                    end
                    
                    
                    if #seal_pool > 0 then
                        c:set_seal(pseudorandom_element(seal_pool, pseudoseed('h_seal')), true, true)
                    end
                    
                    
                    if #enh_pool > 0 then
                        c:set_ability(pseudorandom_element(enh_pool, pseudoseed('h_enh')), true, nil)
                    end
                end
                return true
            end
        }))
        
        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.2,
            func = function()
                for _, c in ipairs(affected_cards) do
                    c:flip()
                    c:juice_up(0.3, 0.3)
                end
                play_sound('tarot2', 1, 0.6)
                return true
            end
        }))
    end,
    
    can_use = function(self, card)
        
        return G.hand and G.hand.highlighted and #G.hand.highlighted >= 1 and #G.hand.highlighted <= 2
    end
}