SMODS.Back {
    key = 'space_deck',
    -- ¡OJO! Ajusta 'x' y 'y' a la posición correcta de tu atlas CustomDecks.png
    pos = { x = 3, y = 0 }, 
    atlas = 'CustomDecks',
    
    -- Empieza bloqueada
    unlocked = false,
    discovered = false,
    unlock_condition = {type = '', extra = ''}, 
    
    config = {
        joker_slot = -5, 
        consumable_slot = 3, 
    },

    
    -- Verificamos si cumpliste el reto al final de una partida
    check_for_unlock = function(self, args)
        if args and args.type == 'win' then
            -- Función auxiliar para buscar victorias en Pozo Verde (3) o superior
            local function has_green_win(deck_key)
                -- Primero intentamos usar la función nativa de Balatro
                if get_deck_win_stake and get_deck_win_stake(deck_key) >= 3 then return true end
                
                -- Si no funciona, escarbamos directamente en el archivo de guardado
                local p = G.PROFILES[G.SETTINGS.profile]
                if p and p.deck_usage and p.deck_usage[deck_key] and p.deck_usage[deck_key].wins_by_key then
                    local stakes = {'stake_green', 'stake_blue', 'stake_black', 'stake_magic', 'stake_ante', 'stake_purple', 'stake_orange', 'stake_gold', 'stake_kranlaxs_magenta', 'stake_kranlaxs_brown', 'stake_kranlaxs_turquoise', 'stake_kranlaxs_platinum'}
                    for _, s in ipairs(stakes) do
                        if p.deck_usage[deck_key].wins_by_key[s] and p.deck_usage[deck_key].wins_by_key[s] > 0 then return true end
                    end
                end
                return false
            end
            
            -- Revisamos las 3 barajas (b_magic, b_nebula, b_zodiac)
            if has_green_win('b_magic') and has_green_win('b_nebula') and has_green_win('b_zodiac') then
                return true
            end
        end
        return false
    end,
    
    apply = function(self, back)
        G.GAME.win_ante = 10
        
        -- =======================================================
        -- BANEOS ESTRICTOS DE VALES Y PAQUETES
        -- =======================================================
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

-- ==============================================================================
-- HOOKS DE LA BARAJA ESPACIAL
-- ==============================================================================
if not SMODS.kranlaxs_spacedeck_hooks then
    
    -- HOOK 1: Descuento matemático en las ciegas
    local orig_set_blind = Blind.set_blind
    function Blind:set_blind(blind, reset, silent)
        orig_set_blind(self, blind, reset, silent)
        
        if G.GAME and G.GAME.selected_back and G.GAME.selected_back.effect.center.key == 'b_kranlaxs_space_deck' then
            if self.chips then
                self.chips = math.floor(self.chips * 0.925)
                self.chip_text = number_format(self.chips)
            end
        end
    end
    
    -- HOOK 2: Invasión de Cuarzos en la tienda
    local orig_create_card = create_card
    function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
        if G.GAME and G.GAME.selected_back and G.GAME.selected_back.effect.center.key == 'b_kranlaxs_space_deck' then
            if area == G.shop_jokers and not forced_key then
                local quartz_pool = {
                    'c_kranlaxs_blackquartz', 'c_kranlaxs_whitequartz', 'c_kranlaxs_pinkquartz', 
                    'c_kranlaxs_bluequartz', 'c_kranlaxs_lilacquartz', 'c_kranlaxs_grayquartz', 
                    'c_kranlaxs_transparentquartz', 'c_kranlaxs_redquartz', 'c_kranlaxs_celestequartz', 
                    'c_kranlaxs_yellowquartz', 'c_kranlaxs_greenquartz', 'c_kranlaxs_brownquartz', 
                    'c_kranlaxs_turquoisequartz', 'c_kranlaxs_orangequartz', 'c_kranlaxs_lapislazuli', 
                    'c_kranlaxs_cinnabar', 'c_kranlaxs_graphite', 'c_kranlaxs_uranium'
                }
                forced_key = pseudorandom_element(quartz_pool, pseudoseed('space_deck_quartz'))
                _type = 'Consumeables'
            end
        end
        return orig_create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
    end
    
    SMODS.kranlaxs_spacedeck_hooks = true
end