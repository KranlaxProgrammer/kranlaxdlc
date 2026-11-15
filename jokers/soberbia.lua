-- Hook global robusto para el sistema de Rachas
if not SMODS.kranlaxs_win_streak_hook then
    
    local orig_update = Game.update
    function Game:update(dt)
        if orig_update then orig_update(self, dt) end
        
        if G.GAME then
            -- 1. Victoria: Usamos la bandera nativa de Balatro (G.GAME.won)
            -- Esto se activa EXACTAMENTE cuando vences al jefe final de la run, sin importar si es el pozo 8, 9 o si usas retos.
            if G.GAME.won and not G.GAME.kranlaxs_streak_win_counted then
                G.GAME.kranlaxs_streak_win_counted = true
                if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
                    G.PROFILES[G.SETTINGS.profile].kranlaxs_win_streak = (G.PROFILES[G.SETTINGS.profile].kranlaxs_win_streak or 0) + 1
                    G:save_progress()
                end
            end
            
            -- 2. Derrota (Pantalla de Game Over natural):
            if G.STATE == G.STATES.GAME_OVER and not G.GAME.kranlaxs_streak_loss_counted then
                G.GAME.kranlaxs_streak_loss_counted = true
                -- Evitamos castigar al jugador si pierde en el modo Libre/Endless (después de ya haber ganado)
                if not G.GAME.won then
                    if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
                        G.PROFILES[G.SETTINGS.profile].kranlaxs_win_streak = 0
                        G:save_progress()
                    end
                end
            end
        end
    end

    -- 3. Reinicio Manual o Abandono (Mantener la tecla R o empezar nueva run desde el menú)
    local orig_start_run = Game.start_run
    function Game:start_run(args)
        -- Si ya había una partida a medias (G.GAME existe), no estás cargando un save, y NO habías ganado la run
        if G.GAME and not args.savetext and not G.GAME.won then
            if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
                G.PROFILES[G.SETTINGS.profile].kranlaxs_win_streak = 0
                G:save_progress()
            end
        end
        orig_start_run(self, args)
    end

    SMODS.kranlaxs_win_streak_hook = true
end

SMODS.Joker{
    key = "soberbia",
    config = { extra = { mult_per_win = 5 } },
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

    loc_vars = function(self, info_queue, card)
        local streak = (G.PROFILES and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].kranlaxs_win_streak) or 0
        local total = streak * card.ability.extra.mult_per_win
        return { vars = { card.ability.extra.mult_per_win, total, streak } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local streak = (G.PROFILES and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].kranlaxs_win_streak) or 0
            if streak > 0 then
                return {
                    mult_mod = streak * card.ability.extra.mult_per_win,
                    message = "+" .. (streak * card.ability.extra.mult_per_win) .. " Mult"
                }
            end
        end
    end
}