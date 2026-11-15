SMODS.Joker{
    key = "littlebro",
    config = { extra = { x_mult = 1, gain = 0.2, target_rank = 'Ace' } },
    pos = { x = 6, y = 4 },
    display_size = { w = 71, h = 95 },
    cost = 4,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false, 
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    check_for_unlock = function(self, args)
        if G.GAME and G.GAME.hands and G.GAME.hands['High Card'] then
            if G.GAME.hands['High Card'].played >= 30 then return true end
        end
        return false
    end,

    locked_loc_vars = function(self, info_queue, card)
        local played = (G.GAME and G.GAME.hands and G.GAME.hands['High Card']) and G.GAME.hands['High Card'].played or 0
        return { vars = { played } }
    end,

    loc_vars = function(self, info_queue, card)
        local target_rank = card and card.ability and card.ability.extra and card.ability.extra.target_rank or self.config.extra.target_rank
        local rank_str = localize(target_rank, 'ranks')
        local played = (G.GAME and G.GAME.hands and G.GAME.hands['High Card']) and G.GAME.hands['High Card'].played or 0
        local unbal = SMODS.Mods["kranlaxs"] and SMODS.Mods["kranlaxs"].config.unbalanced_mode
        local gain = card and card.ability and card.ability.extra and card.ability.extra.gain or self.config.extra.gain
        local x_mult = card and card.ability and card.ability.extra and card.ability.extra.x_mult or self.config.extra.x_mult
        local m_gain = unbal and 0.25 or gain
        
        return { vars = { played, x_mult, rank_str, m_gain } }
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
        if context.setting_blind and not context.blueprint then
            local valid_cards = {}
            for _, v in ipairs(G.playing_cards) do
                if v.ability.effect ~= 'Stone Card' and v.base.value then
                    valid_cards[#valid_cards+1] = v
                end
            end
            if #valid_cards > 0 then
                local target = pseudorandom_element(valid_cards, pseudoseed('littlebro'))
                card.ability.extra.target_rank = target.base.value
                
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize(card.ability.extra.target_rank, 'ranks'), colour = G.C.GREEN})
                        return true
                    end
                }))
            end
        end

        if context.joker_main then
            if context.scoring_name == "High Card" then
                local match = false
                for _, v in ipairs(context.scoring_hand) do
                    if v.base.value == card.ability.extra.target_rank then match = true break end
                end
                
                if match and not context.blueprint then
                    local unbal = SMODS.Mods["kranlaxs"] and SMODS.Mods["kranlaxs"].config.unbalanced_mode
                    local m_gain = unbal and 0.25 or card.ability.extra.gain
                    card.ability.extra.x_mult = card.ability.extra.x_mult + m_gain
                    
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Upgraded!", colour = G.C.MULT})
                            return true
                        end
                    }))
                end
            end
            
            if card.ability.extra.x_mult > 1 then
                return { message = "X" .. card.ability.extra.x_mult, Xmult_mod = card.ability.extra.x_mult, colour = G.C.MULT }
            end
        end
    end
}