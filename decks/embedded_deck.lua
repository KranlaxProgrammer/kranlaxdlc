SMODS.Back {
    key = 'embedded_deck',
    pos = { x = 6, y = 0 }, 
    atlas = 'CustomDecks',
    
    unlocked = false,
    discovered = false,
    
    check_for_unlock = function(self, args)
        local count = 0
        if G.P_CENTERS then
            for k, v in pairs(G.P_CENTERS) do
                if v.set == 'Quartz' and (v.unlocked or v.discovered) then count = count + 1 end
            end
        end
        if count >= 10 then return true end
        return false
    end,

    locked_loc_vars = function(self, info_queue, card)
        local count = 0
        if G.P_CENTERS then
            for k, v in pairs(G.P_CENTERS) do
                if v.set == 'Quartz' and (v.unlocked or v.discovered) then count = count + 1 end
            end
        end
        return { vars = { count } }
    end,

    loc_vars = function(self, info_queue, card)
        local count = 0
        if G.P_CENTERS then
            for k, v in pairs(G.P_CENTERS) do
                if v.set == 'Quartz' and (v.unlocked or v.discovered) then count = count + 1 end
            end
        end
        return { vars = { count } }
    end,

    config = {
        joker_slot = -5, 
        consumable_slot = 3, 
    },
    
    apply = function(self, back)
        G.GAME.win_ante = 10
        G.GAME.banned_keys['v_antimatter'] = true
        G.GAME.banned_keys['v_blank'] = true 
        G.GAME.banned_keys['v_hone'] = true 
        G.GAME.banned_keys['v_glow_up'] = true 
        G.GAME.banned_keys['v_kranlaxs_shiny_appearance'] = true
        G.GAME.banned_keys['v_kranlaxs_common_shinys'] = true

        for k, v in pairs(G.P_CENTERS) do
            if v.set == 'Booster' and (string.match(k, 'buffoon') or string.match(k, 'spectral')) then
                G.GAME.banned_keys[k] = true
            end
        end
        
        G.E_MANAGER:add_event(Event({
            func = function()
                if G.GAME.shop then
                    G.GAME.shop.joker_max = G.GAME.shop.joker_max + 1
                else
                    G.GAME.shop = G.GAME.shop or {}
                    G.GAME.shop.joker_max = (G.GAME.shop.joker_max or 2) + 1
                end
                
                if G.jokers then G.jokers.config.card_limit = 0 end
                if G.consumeables then G.consumeables.config.card_limit = 5 end
                
                return true
            end
        }))
    end
}

if not SMODS.kranlaxs_embedded_hooks then
    local orig_set_blind = Blind.set_blind
    function Blind:set_blind(blind, reset, silent)
        orig_set_blind(self, blind, reset, silent)
        if G.GAME and G.GAME.selected_back and G.GAME.selected_back.effect.center.key == 'b_kranlaxs_embedded_deck' then
            if self.chips then
                self.chips = math.floor(self.chips * 0.925)
                self.chip_text = number_format(self.chips)
            end
        end
    end
    
    local orig_create_card = create_card
    function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
        if G.GAME and G.GAME.selected_back and G.GAME.selected_back.effect.center.key == 'b_kranlaxs_embedded_deck' then
            if area == G.shop_jokers and not forced_key then
                local quartz_pool = {
                    'c_kranlaxs_blackquartz', 'c_kranlaxs_whitequartz', 'c_kranlaxs_pinkquartz', 
                    'c_kranlaxs_bluequartz', 'c_kranlaxs_lilacquartz', 'c_kranlaxs_grayquartz', 
                    'c_kranlaxs_transparentquartz', 'c_kranlaxs_redquartz', 'c_kranlaxs_celestequartz', 
                    'c_kranlaxs_yellowquartz', 'c_kranlaxs_greenquartz', 'c_kranlaxs_brownquartz', 
                    'c_kranlaxs_turquoisequartz', 'c_kranlaxs_orangequartz', 'c_kranlaxs_lapislazuli', 
                    'c_kranlaxs_cinnabar', 'c_kranlaxs_graphite', 'c_kranlaxs_uranium'
                }
                forced_key = pseudorandom_element(quartz_pool, pseudoseed('embedded_deck_quartz'))
                _type = 'Consumeables'
            end
        end
        return orig_create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
    end
    SMODS.kranlaxs_embedded_hooks = true
end