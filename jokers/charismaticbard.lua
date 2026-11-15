SMODS.Joker{
    key = "charismaticbard",
    config = {
        extra = {
            reduction_pct = 0,
            blind_mult = 1
        }
    },
    pos = { x = 8, y = 0 },
    display_size = { w = 71, h = 95 },
    cost = 20,
    bm_cost = 7,
    rarity = "kranlaxs_zenith",
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_prey"] = true },
    
    can_repeat_soul = false,
    
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.reduction_pct}}
    end,
    
    calculate = function(self, card, context)
        local is_most_played = function(scoring_name)
            local current_played = G.GAME.hands[scoring_name].played or 0
            for handname, values in pairs(G.GAME.hands) do
                if handname ~= scoring_name and values.visible and values.played > current_played then
                    return false
                end
            end
            return true
        end

        if context.before and not context.blueprint then
            if not is_most_played(context.scoring_name) then
                if card.ability.extra.reduction_pct > 0 then
                    card.ability.extra.reduction_pct = 0
                    card.ability.extra.blind_mult = 1
                    return {
                        message = "Reset!",
                        colour = G.C.RED
                    }
                end
            else
                if card.ability.extra.reduction_pct < 90 then
                    card.ability.extra.reduction_pct = card.ability.extra.reduction_pct + 2
                    card.ability.extra.blind_mult = math.max(0.1, 1 - (card.ability.extra.reduction_pct / 100))
                    return {
                        message = "Upgrade!",
                        colour = G.C.GREEN
                    }
                end
            end
        end

        if context.setting_blind then
            if G.GAME.blind and G.GAME.blind.in_blind and card.ability.extra.blind_mult < 1 then
                return {
                    func = function()
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "-" .. card.ability.extra.reduction_pct .. "% Blind Size", colour = G.C.GREEN})
                        G.GAME.blind.chips = math.floor(G.GAME.blind.chips * card.ability.extra.blind_mult)
                        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                        G.HUD_blind:recalculate()
                        return true
                    end
                }
            end
        end
    end
}