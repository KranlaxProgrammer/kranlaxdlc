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
    
    unlocked = false, 
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    
    check_for_unlock = function(self, args)
        if args and args.type == 'win' then
            
            if G.GAME and G.GAME.stake == 3 and G.GAME.selected_back and G.GAME.selected_back.effect.center.key == 'b_kranlaxs_week_challenge' then
                return true
            end
        end
        return false
    end,

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
                        
                        local saved = false
                        if G.jokers and G.jokers.cards then
                            for _, jkr in ipairs(G.jokers.cards) do
                                if jkr.config.center.key == 'j_kranlaxs_lifeassurance' and not jkr.debuff then
                                    if G.GAME.dollars >= jkr.ability.extra.seguro then
                                        local cost = jkr.ability.extra.seguro
                                        jkr.ability.extra.seguro = jkr.ability.extra.seguro * 2
                                        ease_dollars(-cost)
                                        G.E_MANAGER:add_event(Event({
                                            func = function()
                                                card_eval_status_text(jkr, 'extra', nil, nil, nil, {message = "-$" .. tostring(cost), colour = G.C.MONEY})
                                                jkr:juice_up()
                                                return true
                                            end
                                        }))
                                        saved = true
                                        break
                                    end
                                end
                            end
                        end

                        if saved then
                            card.ability.extra.time_left = 9.0
                            card.ability.extra.last_sec = 10
                            card.ability.extra.killed = false
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = "¡Tiempo Extra!", colour = G.C.GREEN})
                                    return true
                                end
                            }))
                        else
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