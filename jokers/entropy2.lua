SMODS.Joker{
    key = "entropy2",
    config = {
        extra = {}
    },
    pos = { x = 6, y = 0 },
    display_size = { w = 71, h = 95 },
    cost = 20,
    rarity = 4,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_mycustom_jokers"] = true },
    
    in_pool = function(self, args)
        return (not args or (args.source ~= 'sho' and args.source ~= 'buf') or args.source == 'jud' or args.source == 'rif' or args.source == 'rta' or args.source == 'sou' or args.source == 'uta' or args.source == 'wra') and true
    end,
    
    loc_vars = function(self, info_queue, card)
        local deck_size = G.playing_cards and #G.playing_cards or 52
        local power = 1 + math.max(0, 52 - deck_size)
        return {vars = {power}}
    end,
    
    calculate = function(self, card, context)
        if context.joker_main then
            local deck_size = G.playing_cards and #G.playing_cards or 52
            local power = 1 + math.max(0, 52 - deck_size)
            
            if power > 1 then
                return {
                    message = "^" .. power,
                    e_chips = power,
                    e_mult = power,
                    colour = G.C.DARK_EDITION
                }
            end
        end
    end
}