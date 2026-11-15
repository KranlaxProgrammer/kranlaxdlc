SMODS.Joker{
    key = "pisces",
    config = { extra = { x_money = 1, gain = 0.05, unbalanced_gain = 0.1, target_hand = nil, fails = 0, banned_hands = {} } },
    pos = { x = 03, y = 012 }, 
    display_size = { w = 71, h = 95 },
    cost = 10,
    bm_cost = 12,
    rarity = "kranlaxs_zenith",
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',

    is_constellation = true, 

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
    
    set_badges = function(self, card, badges)
        local badge_text = "Constellation"
        if G.localization and G.localization.misc and G.localization.misc.dictionary and G.localization.misc.dictionary.k_constellation then
            badge_text = G.localization.misc.dictionary.k_constellation
        else
            if G.SETTINGS.language == 'es_419' or G.SETTINGS.language == 'es_ES' then badge_text = "Constelación" end
        end
        badges[#badges + 1] = create_badge(badge_text, HEX('3D266B'), G.C.WHITE, 1.2)
    end,

    update = function(self, card, dt)
        if G.GAME and G.GAME.hands and not card.ability.extra.target_hand then
            local valid_hands = {}
            for k, v in pairs(G.GAME.hands) do
                if v.visible then table.insert(valid_hands, k) end
            end
            if #valid_hands == 0 then table.insert(valid_hands, 'High Card') end
            card.ability.extra.target_hand = pseudorandom_element(valid_hands, pseudoseed('pisces_start' .. (G.GAME.round or 1)))
        end
    end,

    loc_vars = function(self, info_queue, card)
        local target = card.ability.extra.target_hand or "High Card"
        local unbal = SMODS.Mods["kranlaxs"] and SMODS.Mods["kranlaxs"].config.unbalanced_mode
        local display_gain = unbal and card.ability.extra.unbalanced_gain or card.ability.extra.gain
        
        return {vars = {card.ability.extra.x_money, display_gain, localize(target, 'poker_hands')}}
    end,

    calculate = function(self, card, context)
        if context.joker_main and not context.blueprint then
            card.ability.extra.banned_hands = card.ability.extra.banned_hands or {}
            local unbal = SMODS.Mods["kranlaxs"] and SMODS.Mods["kranlaxs"].config.unbalanced_mode
            local current_gain = unbal and card.ability.extra.unbalanced_gain or card.ability.extra.gain

            if card.ability.extra.target_hand and context.scoring_name == card.ability.extra.target_hand then
                card.ability.extra.x_money = card.ability.extra.x_money + current_gain
                card.ability.extra.fails = 0 
                
                local valid_hands = {}
                for k, v in pairs(G.GAME.hands) do
                    if v.visible then
                        local is_banned = false
                        for _, b in ipairs(card.ability.extra.banned_hands) do
                            if b == k then is_banned = true; break end
                        end
                        if not is_banned then table.insert(valid_hands, k) end
                    end
                end
                
                if #valid_hands == 0 then 
                    card.ability.extra.banned_hands = {}
                    for k, v in pairs(G.GAME.hands) do
                        if v.visible then table.insert(valid_hands, k) end
                    end
                    if #valid_hands == 0 then table.insert(valid_hands, 'High Card') end
                end
                
                card.ability.extra.target_hand = pseudorandom_element(valid_hands, pseudoseed('pisces_next' .. G.GAME.round))
                
                return {
                    message = "X" .. card.ability.extra.x_money .. " Dinero",
                    colour = G.C.MONEY
                }
            else
                card.ability.extra.fails = (card.ability.extra.fails or 0) + 1
                
                if card.ability.extra.fails >= 10 then
                    table.insert(card.ability.extra.banned_hands, card.ability.extra.target_hand)
                    card.ability.extra.fails = 0
                    
                    local valid_hands = {}
                    for k, v in pairs(G.GAME.hands) do
                        if v.visible then
                            local is_banned = false
                            for _, b in ipairs(card.ability.extra.banned_hands) do
                                if b == k then is_banned = true; break end
                            end
                            if not is_banned then table.insert(valid_hands, k) end
                        end
                    end
                    
                    if #valid_hands == 0 then 
                        card.ability.extra.banned_hands = {}
                        for k, v in pairs(G.GAME.hands) do
                            if v.visible then table.insert(valid_hands, k) end
                        end
                        if #valid_hands == 0 then table.insert(valid_hands, 'High Card') end
                    end
                    
                    card.ability.extra.target_hand = pseudorandom_element(valid_hands, pseudoseed('pisces_tired' .. G.GAME.round))
                    
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            card:juice_up(0.5, 0.5)
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = "¡Aburrido!", colour = G.C.RED})
                            return true
                        end
                    }))
                end
            end
        end
    end,

    calc_dollar_bonus = function(self, card)
        if card.ability.extra.x_money > 1 and G.GAME.dollars > 0 then
            local earned = math.floor(G.GAME.dollars * card.ability.extra.x_money) - G.GAME.dollars
            if earned > 0 then return earned end
        end
        return 0
    end
}