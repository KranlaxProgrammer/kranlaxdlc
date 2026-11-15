SMODS.Joker{
    key = "gigachad",
    config = {
        extra = {
            giga = 0,
            gain = 0.2
        }
    },
    pos = { x = 5, y = 3 },
    display_size = { w = 71, h = 95 },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    
    unlocked = false, 
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    
    check_for_unlock = function(self, args)
        if args and args.type == 'win' then
            
            if G.GAME and G.GAME.stake == 1 and G.GAME.selected_back and G.GAME.selected_back.effect.center.key == 'b_kranlaxs_week_challenge' then
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
        
        local current_giga = string.format("%.1f", card.ability.extra.giga):gsub("%.?0+$", "")
        if current_giga == "" then current_giga = "0" end
        local gain = string.format("%.1f", card.ability.extra.gain):gsub("%.?0+$", "")
        
        return {vars = {current_giga, gain}}
    end,
    
    calculate = function(self, card, context)
        
        local player_action = context.reroll_shop or context.buying_card or context.selling_card or 
                              context.ending_shop or context.starting_shop or context.ending_booster or 
                              context.skipping_booster or context.open_booster or context.skip_blind or 
                              context.before or context.pre_discard or context.setting_blind or 
                              context.using_consumeable

        if player_action and not context.blueprint then
            card.ability.extra.giga = card.ability.extra.giga + card.ability.extra.gain
            G.E_MANAGER:add_event(Event({
                func = function()
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = "+" .. card.ability.extra.gain, colour = G.C.CHIPS})
                    return true
                end
            }))
        end

        
        if context.individual and context.cardarea == G.play and not context.blueprint then
            card.ability.extra.giga = card.ability.extra.giga + card.ability.extra.gain
            return {
                message = "+" .. card.ability.extra.gain,
                colour = G.C.CHIPS,
                card = card
            }
        end

        
        if context.joker_main then
            local rounded_chips = math.floor(card.ability.extra.giga)
            if rounded_chips > 0 then
                return {
                    message = "+" .. rounded_chips,
                    chip_mod = rounded_chips,
                    colour = G.C.CHIPS
                }
            end
        end
    end
}