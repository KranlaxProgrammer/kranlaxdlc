SMODS.Back {
    key = 'week_challenge',
    pos = { x = 1, y = 0 },
    unlocked = false,
    discovered = false,
    
    -- ¡EL FIX DEL CANDADO!
    unlock_condition = {type = '', extra = ''}, 
    
    atlas = 'CustomDecks',
    
    check_for_unlock = function(self, args)
        local free_play = SMODS.Mods["kranlaxs"].config.free_weekly_deck
        local day = os.date("%w")
        if free_play or day == "0" or day == "6" then
            return true
        end
        return false
    end,
    
    -- TRUCO DE MAGIA: Forzamos al juego a desbloquear/bloquear la baraja en TIEMPO REAL 
    -- si cambias la configuración en el menú principal
    loc_vars = function(self, info_queue, card)
        local free_play = SMODS.Mods["kranlaxs"].config.free_weekly_deck
        local day = os.date("%w")
        local is_weekend = (free_play or day == "0" or day == "6")
        
        if G.PROFILES and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].deck_usage then
            local deck_data = G.PROFILES[G.SETTINGS.profile].deck_usage['b_kranlaxs_week_challenge']
            if deck_data then
                deck_data.unlocked = is_weekend
            end
        end
        
        return {vars = {}}
    end,
    
    apply = function(self, back)
        G.E_MANAGER:add_event(Event({
            func = function()
                play_sound('timpani')
                if #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
                    G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                    
                    SMODS.add_card({ set = 'Joker', key = 'j_kranlaxs_sundaycheckpoint' })
                    
                    G.GAME.joker_buffer = 0
                end
                return true
            end
        }))
    end
}