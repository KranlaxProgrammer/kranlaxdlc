SMODS.Seal {
    key = 'mintseal',
    badge_colour = HEX('2C2C2C'), -- Color Negro/Gris oscuro
    atlas = 'CustomSeals',
    pos = { x = 2, y = 0 },
    unlocked = true,
    discovered = true,
    no_collection = false,
    
    loc_vars = function(self, info_queue, card)
        return {vars = {G.GAME and G.GAME.probabilities.normal or 1}}
    end,
    
    calculate = function(self, card, context)
        -- Solo se activa al puntuar la carta
        if context.main_scoring then
            if pseudorandom('kranlaxs_mintseal') < (G.GAME.probabilities.normal or 1) / 4 then
                G.GAME.kranlaxs_dark_coins = (G.GAME.kranlaxs_dark_coins or 0) + 1
                return {
                    message = "+1 Token",
                    colour = HEX('8b008b') -- Color Morado del Mercado Negro
                }
            end
        end
    end
}