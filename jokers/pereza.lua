SMODS.Joker{
    key = "pereza",
    config = { extra = {} },
    pos = { x = 0, y = 0 },
    cost = 20,
    bm_cost = 7,
    rarity = "kranlaxs_zenith",
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },
    
    calculate = function(self, card, context)
        -- Activar exactamente al robar tu mano inicial contra la ciega
        if context.first_hand_drawn then
            local blind_req = G.GAME.blind.chips or 0
            local free_score = math.floor(blind_req * 0.5)
            
            if free_score > 0 then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.2,
                    func = function()
                        -- Agrega el puntaje directamente a la base de datos de la partida
                        G.GAME.chips = G.GAME.chips + free_score
                        card:juice_up(0.5, 0.5)
                        play_sound('chips1', 1, 0.8)
                        return true
                    end
                }))
                
                return {
                    message = "Mitad Lista",
                    colour = G.C.CHIPS
                }
            end
        end
    end
}