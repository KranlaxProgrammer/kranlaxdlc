SMODS.Joker{
    key = "speedrunner",
    config = {
        extra = {
            Xmult = 5,
            time_left = 9.0, 
            killed = false,
            last_sec = 10 
        }
    },
    pos = { x = 6, y = 6 }, 
    display_size = { w = 71, h = 95 },
    cost = 7,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    
    unlocked = false, -- ¡Cambiado a false para activar el candado!
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    -- Función que atrapa la victoria en Pozo Verde
    check_for_unlock = function(self, args)
        if args and args.type == 'win' then
            -- Verificamos Pozo Verde (stake == 3) y la baraja Reto Semanal
            if G.GAME and G.GAME.stake == 3 and G.GAME.selected_back and G.GAME.selected_back.effect.center.key == 'b_kranlaxs_week_challenge' then
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

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.Xmult, string.format("%.1f", card.ability.extra.time_left)}}
    end,

    update = function(self, card, dt)
        if card.area == G.jokers and not card.debuff then
            if G.STATE == G.STATES.SELECTING_HAND then
                if not G.overlay_menu then
                    card.ability.extra.time_left = card.ability.extra.time_left - dt
                    
                    local current_sec = math.ceil(card.ability.extra.time_left)
                    if current_sec ~= card.ability.extra.last_sec and current_sec > 0 and current_sec <= 9 then
                        card.ability.extra.last_sec = current_sec
                        
                        if current_sec <= 3 then
                            play_sound('timpani', 0.8 + (4 - current_sec) * 0.15, 0.6)
                            card:juice_up(0.5, 0.5)
                        end
                    end
                    
                    if card.ability.extra.time_left <= 0 and not card.ability.extra.killed then
                        card.ability.extra.killed = true
                        
                        G.E_MANAGER:add_event(Event({
                            trigger = 'immediate',
                            func = function()
                                G.STATE = G.STATES.GAME_OVER
                                G.STATE_COMPLETE = false
                                return true
                            end
                        }))
                    end
                end
            else
                card.ability.extra.time_left = 9.0 
                card.ability.extra.last_sec = 10
                card.ability.extra.killed = false
            end
        end
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = "X" .. card.ability.extra.Xmult .. " Mult",
                Xmult_mod = card.ability.extra.Xmult,
                colour = G.C.MULT
            }
        end
    end
}