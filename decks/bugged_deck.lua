SMODS.Back {
    key = 'bugged_deck',
    pos = { x = 4, y = 0 }, 
    atlas = 'CustomDecks',
    
    unlocked = false,
    discovered = false,
    unlock_condition = {type = '', extra = ''},
    
    check_for_unlock = function(self, args)
        if G.PROFILES and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].kranlaxs_tmtrainer_bought then
            return true
        end
        return false
    end,
    
    apply = function(self, back)
    end
}

if not SMODS.kranlaxs_bugged_deck_hooks then
    
    local orig_add_to_deck = Card.add_to_deck
    function Card:add_to_deck(from_debuff)
        orig_add_to_deck(self, from_debuff)
        if self.config.center.key == 'j_kranlaxs_tmtrainer' then
            G.PROFILES[G.SETTINGS.profile].kranlaxs_tmtrainer_bought = true
        end
    end
    
    local orig_create_card = create_card
    function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
        if G.GAME and G.GAME.selected_back and G.GAME.selected_back.effect.center.key == 'b_kranlaxs_bugged_deck' then
            
            if _type == 'Joker' then
                forced_key = 'j_kranlaxs_tmtrainer'
                
                _rarity = nil 
                legendary = nil
            end
        end
        
        return orig_create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
    end
    
    SMODS.kranlaxs_bugged_deck_hooks = true
end