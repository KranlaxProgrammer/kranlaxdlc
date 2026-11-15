SMODS.Joker{
    key = 'philosopher',
    config = { extra = { next_cards_str = "" } },
    rarity = 3,
    atlas = 'CustomJokers',
    pos = { x = 4, y = 7 },
    cost = 8,
    blueprint_compat = false,
    unlocked = false,
    discovered = false,
    unlock_condition = {type = '', extra = ''},

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
    
    check_for_unlock = function(self, args)
        if G and G.PROFILES and G.PROFILES[G.SETTINGS.profile] then
            if G.PROFILES[G.SETTINGS.profile].all_unlocked then return true end
            if G.PROFILES[G.SETTINGS.profile].challenge_progress and G.PROFILES[G.SETTINGS.profile].challenge_progress.completed then
                if G.PROFILES[G.SETTINGS.profile].challenge_progress.completed.c_kranlaxs_reto_premonisiones then return true end
            end
        end
        return false
    end,
    
    update = function(self, card, dt)
        if G.GAME and G.GAME.round_resets then
            local next_cards = ""
            local unbal = SMODS.Mods["kranlaxs"] and SMODS.Mods["kranlaxs"].config.unbalanced_mode
            
            -- Rework: Solo predecir si hay MÁS de 4 cartas
            if G.deck and G.deck.cards and #G.deck.cards > 4 then
                local count = 0
                local lang = G.SETTINGS.language
                
                local connector = (lang == 'en-us') and " of " or " de "
                
                local suit_names = {
                    Spades = {['en-us'] = "Spades", ['es_419'] = "Picas", ['es_ES'] = "Picas", ['pt_BR'] = "Espadas"},
                    Hearts = {['en-us'] = "Hearts", ['es_419'] = "Corazones", ['es_ES'] = "Corazones", ['pt_BR'] = "Copas"},
                    Clubs = {['en-us'] = "Clubs", ['es_419'] = "Tréboles", ['es_ES'] = "Tréboles", ['pt_BR'] = "Paus"},
                    Diamonds = {['en-us'] = "Diamonds", ['es_419'] = "Diamantes", ['es_ES'] = "Diamantes", ['pt_BR'] = "Ouros"}
                }
                
                local val_names = {
                    Ace = {['en-us'] = "A", ['es_419'] = "As", ['es_ES'] = "As", ['pt_BR'] = "Ás"},
                    Jack = {['en-us'] = "J", ['es_419'] = "J", ['es_ES'] = "J", ['pt_BR'] = "J"},
                    Queen = {['en-us'] = "Q", ['es_419'] = "Q", ['es_ES'] = "Q", ['pt_BR'] = "Q"},
                    King = {['en-us'] = "K", ['es_419'] = "K", ['es_ES'] = "K", ['pt_BR'] = "K"}
                }

                for i = #G.deck.cards, 1, -1 do
                    if count >= 5 then break end
                    local c = G.deck.cards[i]
                    if c and c.base and c.base.suit and c.base.value then
                        
                        -- Modo Desbalance remueve permanentemente la censura
                        if unbal then
                            c.philosopher_censored = false
                        elseif c.philosopher_censored == nil then
                            c.philosopher_censored = (pseudorandom('phil_censor') < 0.2)
                        end
                        
                        if c.philosopher_censored then
                            next_cards = next_cards .. (next_cards == "" and "" or ", ") .. "[?]"
                        else
                            local s_key = c.base.suit
                            local suit_str = suit_names[s_key] and (suit_names[s_key][lang] or suit_names[s_key]['en-us']) or s_key
                            
                            local v_key = tostring(c.base.value)
                            local val_str = v_key
                            if val_names[v_key] then
                                val_str = val_names[v_key][lang] or val_names[v_key]['en-us']
                            end
                            
                            next_cards = next_cards .. (next_cards == "" and "" or ", ") .. val_str .. connector .. suit_str
                        end
                        count = count + 1
                    end
                end
            end
            
            if next_cards == "" then 
                local lang = G.SETTINGS.language
                if lang == 'en-us' then next_cards = "None"
                elseif lang == 'pt_BR' then next_cards = "Nenhuma"
                else next_cards = "Ninguna" end
            end
            
            card.ability.extra.next_cards_str = next_cards
        end
    end,

    loc_vars = function(self, info_queue, card)
        local empty_str = "Ninguna"
        if G.SETTINGS and G.SETTINGS.language then
            if G.SETTINGS.language == 'en-us' then empty_str = "None"
            elseif G.SETTINGS.language == 'pt_BR' then empty_str = "Nenhuma" end
        end
        
        local cards_str = card.ability.extra.next_cards_str
        if not cards_str or cards_str == "" then cards_str = empty_str end
        
        return { vars = { cards_str } }
    end,
    
    calculate = function(self, card, context) end
}