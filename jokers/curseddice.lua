SMODS.Joker {
    key = 'curseddice',
    atlas = 'CustomJokers',
    pos = { x = 10, y = 7 },
    rarity = "kranlaxs_zenith",
    cost = 8,
    bm_cost = 9,
    unlocked = false,
    discovered = false,
    blueprint_compat = false, 
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },
    
    check_for_unlock = function(self, args)
        if args.type == 'win' and G.GAME.stake >= 12 then
            local p = G.PROFILES[G.SETTINGS.profile]
            p.kranlaxs_crimson_wins_decks = p.kranlaxs_crimson_wins_decks or {}
            p.kranlaxs_crimson_wins_decks[G.GAME.selected_back.effect.center.key] = true
            G:save_progress()
        end
        local count = 0
        if G.PROFILES and G.PROFILES[G.SETTINGS.profile].kranlaxs_crimson_wins_decks then
            for k, v in pairs(G.PROFILES[G.SETTINGS.profile].kranlaxs_crimson_wins_decks) do count = count + 1 end
        end
        return count >= 7
    end,

    locked_loc_vars = function(self, info_queue, card)
        local count = 0
        if G.PROFILES and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].kranlaxs_crimson_wins_decks then
            for k, v in pairs(G.PROFILES[G.SETTINGS.profile].kranlaxs_crimson_wins_decks) do count = count + 1 end
        end
        return {vars = {count}}
    end,

    loc_vars = function(self, info_queue, card)
        return { vars = {} }
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

    calculate = function(self, card, context)
        if context.reroll_shop and not context.blueprint then
            local my_pos = 0
            if G.jokers and G.jokers.cards then
                for i = 1, #G.jokers.cards do
                    if G.jokers.cards[i] == card then my_pos = i; break end
                end
            end
            
            if my_pos > 1 then
                local left_joker = G.jokers.cards[my_pos - 1]
                local current_key = left_joker.config.center.key
                
                local pool_index = 1
                for i, center in ipairs(G.P_CENTER_POOLS.Joker) do
                    if center.key == current_key then
                        pool_index = i
                        break
                    end
                end
                
                local new_index = pool_index
                local new_center = nil
                
                repeat
                    new_index = new_index - 1
                    if new_index < 1 then new_index = #G.P_CENTER_POOLS.Joker end
                    new_center = G.P_CENTER_POOLS.Joker[new_index]
                until new_center.unlocked ~= false
                
                G.E_MANAGER:add_event(Event({
                    func = function()
                        left_joker:set_ability(new_center, true)
                        left_joker:juice_up(0.5, 0.5)
                        card:juice_up(0.5, 0.5)
                        play_sound('tarot1')
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = "-1 ID", colour = G.C.PURPLE})
                        return true
                    end
                }))
            end
        end
    end
}