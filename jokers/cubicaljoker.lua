SMODS.Joker{
    key = "cubicaljoker",
    config = {
        extra = {
            mult_base = 2
        }
    },
    pos = { x = 1, y = 6 },
    display_size = { w = 71, h = 95 },
    cost = 20,
    bm_cost = 15,
    rarity = "kranlaxs_zenith",
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },
    
    check_for_unlock = function(self, args)
        if args.type == 'win' and G.GAME.stake >= 8 then
            local p = G.PROFILES[G.SETTINGS.profile]
            p.kranlaxs_gold_wins_decks = p.kranlaxs_gold_wins_decks or {}
            p.kranlaxs_gold_wins_decks[G.GAME.selected_back.effect.center.key] = true
            G:save_progress()
        end
        local count = 0
        if G.PROFILES and G.PROFILES[G.SETTINGS.profile].kranlaxs_gold_wins_decks then
            for k, v in pairs(G.PROFILES[G.SETTINGS.profile].kranlaxs_gold_wins_decks) do count = count + 1 end
        end
        return count >= 12
    end,

    locked_loc_vars = function(self, info_queue, card)
        local count = 0
        if G.PROFILES and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].kranlaxs_gold_wins_decks then
            for k, v in pairs(G.PROFILES[G.SETTINGS.profile].kranlaxs_gold_wins_decks) do count = count + 1 end
        end
        return {vars = {count}}
    end,

    loc_vars = function(self, info_queue, card)
        local current_mult = number_format(to_big(card.ability.extra.mult_base))
        return {vars = {current_mult}}
    end,
    
    calculate = function(self, card, context)
        if context.joker_main then
            if to_big(card.ability.extra.mult_base) > to_big(0) then
                return {
                    message = "+" .. number_format(to_big(card.ability.extra.mult_base)),
                    mult_mod = card.ability.extra.mult_base,
                    colour = G.C.MULT
                }
            end
        end

        if context.end_of_round and context.main_eval and G.GAME.blind.boss and not context.blueprint then
            card.ability.extra.mult_base = to_big(card.ability.extra.mult_base) ^ to_big(3)
            
            return {
                message = "^3 Mult!",
                colour = G.C.DARK_EDITION
            }
        end
    end
}