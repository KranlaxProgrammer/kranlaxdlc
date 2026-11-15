SMODS.Joker {
    key = 'crayonbox',
    atlas = 'CustomJokers',
    pos = { x = 02, y = 10 },
    rarity = 2,
    cost = 6,
    unlocked = false,
    discovered = false,
    blueprint_compat = true,
    config = { extra = { suit = 'Hearts' } },
    
    check_for_unlock = function(self, args)
        local count = 0
        if G.PROFILES and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].consumeable_usage and G.PROFILES[G.SETTINGS.profile].consumeable_usage['c_lovers'] then
            count = G.PROFILES[G.SETTINGS.profile].consumeable_usage['c_lovers'].count or 0
        end
        return count >= 10
    end,

    locked_loc_vars = function(self, info_queue, card)
        local count = 0
        if G.PROFILES and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].consumeable_usage and G.PROFILES[G.SETTINGS.profile].consumeable_usage['c_lovers'] then
            count = G.PROFILES[G.SETTINGS.profile].consumeable_usage['c_lovers'].count or 0
        end
        return {vars = {count}}
    end,

    get_valid_suits = function()
        local valid_suits = {}
        if G.playing_cards and #G.playing_cards > 0 then
            local suit_map = {}
            for _, v in ipairs(G.playing_cards) do
                if v.base and v.base.suit then suit_map[v.base.suit] = true end
            end
            for k, _ in pairs(suit_map) do table.insert(valid_suits, k) end
        end
        if #valid_suits == 0 then valid_suits = {'Hearts', 'Diamonds', 'Spades', 'Clubs'} end
        return valid_suits
    end,
    
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.extra.suit = pseudorandom_element(self.get_valid_suits(), pseudoseed('crayonbox_seed'))
    end,
    
    loc_vars = function(self, info_queue, card)
        local dict = {Hearts = 'Corazones', Diamonds = 'Diamantes', Spades = 'Picas', Clubs = 'Tréboles'}
        local loc_suit = dict[card.ability.extra.suit] or card.ability.extra.suit
        return { vars = { loc_suit } }
    end,
    
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local target_card = context.other_card
            if target_card:is_suit(card.ability.extra.suit) and target_card.config.center.effect == 'Base' then
                target_card:set_ability(G.P_CENTERS.m_wild, nil, true)
                G.E_MANAGER:add_event(Event({
                    func = function()
                        if target_card then target_card:juice_up() end
                        return true
                    end
                }))
                return {
                    extra = {colour = G.C.SUITS[card.ability.extra.suit]},
                    card = card
                }
            end
        end
        
        if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
            card.ability.extra.suit = pseudorandom_element(self.get_valid_suits(), pseudoseed('crayonbox_change'))
        end
    end
}