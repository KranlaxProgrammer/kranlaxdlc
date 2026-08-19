SMODS.Joker{
    key = "anonymousjoker",
    config = { extra = {} },
    
    -- Apuntamos a la primera posición de tu atlas animado
    pos = { x = 0, y = 0 }, 
    
    display_size = { w = 71, h = 95 },
    cost = 5,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    discovered = false,
    
    -- El atlas principal ahora es el fondo animado (que ya incluye la cara)
    atlas = 'anonback', 
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    check_for_unlock = function(self, args)
        -- Evaluamos si ganamos la partida (Ante 8) o vencemos la ciega actual
        if args and (args.type == 'win' or args.type == 'win_blind') then
            if G.GAME.blind and G.GAME.blind.config and G.GAME.blind.config.blind then
                if G.GAME.blind.config.blind.key == 'bl_final_acorn' then
                    if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
                        G.PROFILES[G.SETTINGS.profile].kranlaxs_acorn_killed = true
                    end
                    return true
                end
            end
        end
        
        if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
            -- Checamos la nueva variable (1 sola victoria) o la vieja por si llegó a sumar algo antes
            if G.PROFILES[G.SETTINGS.profile].kranlaxs_acorn_killed or (G.PROFILES[G.SETTINGS.profile].kranlaxs_acorn_kills and G.PROFILES[G.SETTINGS.profile].kranlaxs_acorn_kills >= 1) then
                return true
            end
        end
        return false
    end,

    in_pool = function(self, args)
        if not G.jokers or not G.jokers.cards then return true end
        for _, v in ipairs(G.jokers.cards) do
            if v.config.center.key == 'j_kranlaxs_' .. self.key then
                return false 
            end
        end
        return true
    end,
    
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            if card.facing == 'front' then
                card:flip()
            end
            return { message = "Flip!" }
        end

        if context.joker_main then
            if card.facing == 'back' or context.blueprint then
                local secret_mult = (pseudorandom('anon_mult') * 2.5) + 1.5
                secret_mult = math.floor(secret_mult * 100) / 100

                return {
                    message = "?!?", 
                    Xmult_mod = secret_mult,
                    colour = G.C.MULT
                }
            end
        end

        if context.end_of_round and context.main_eval and not context.blueprint then
            if card.facing == 'back' then
                card:flip()
            end
        end
    end
}