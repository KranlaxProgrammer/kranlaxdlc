SMODS.Joker {
    key = 'luckyseven',
    atlas = 'CustomJokers',
    pos = { x = 8, y = 5 },
    rarity = 1,
    cost = 4,
    unlocked = false,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = { extra = { chips = 0, mult = 0, gain = 7, sevens_played = 0 } },
    
    check_for_unlock = function(self, args)
        if G.playing_cards then
            local sevens_count = 0
            for _, card in ipairs(G.playing_cards) do
                if card:get_id() == 7 then
                    sevens_count = sevens_count + 1
                end
            end
            if sevens_count >= 10 then return true end
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
        return { vars = { card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.sevens_played } }
    end,
    
    calculate = function(self, card, context)
        if context.joker_main then
            if card.ability.extra.chips > 0 or card.ability.extra.mult > 0 then
                return {
                    message = "¡Suerte!",
                    chips = card.ability.extra.chips > 0 and card.ability.extra.chips or nil,
                    mult = card.ability.extra.mult > 0 and card.ability.extra.mult or nil,
                    colour = G.C.ORANGE
                }
            end
        end

        if context.before and not context.blueprint then
            local sevens_in_hand = 0
            for _, v in ipairs(context.full_hand) do
                if v:get_id() == 7 then
                    sevens_in_hand = sevens_in_hand + 1
                end
            end

            if sevens_in_hand > 0 then
                card.ability.extra.sevens_played = card.ability.extra.sevens_played + sevens_in_hand
                local upgrades = 0
                
                while card.ability.extra.sevens_played >= 7 do
                    card.ability.extra.sevens_played = card.ability.extra.sevens_played - 7
                    card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.gain
                    card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.gain
                    upgrades = upgrades + 1
                end

                if upgrades > 0 then
                    local unbal = SMODS.Mods["kranlaxs"] and SMODS.Mods["kranlaxs"].config.unbalanced_mode
                    if unbal then ease_dollars(7 * upgrades) end
                    
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            card:juice_up(0.5, 0.5)
                            local msg = "+" .. (7 * upgrades) .. " fichas / +" .. (7 * upgrades) .. " multi"
                            if unbal then msg = msg .. " / +$" .. (7 * upgrades) end
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = msg, colour = G.C.ORANGE})
                            return true
                        end
                    }))
                end
            end
        end
    end
}