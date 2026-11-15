SMODS.Joker{
    key = "kranlax",
    config = { extra = {} },
    pos = { x = 0, y = 0 }, 
    soul_pos = { x = 1, y = 0 }, 
    display_size = { w = 71, h = 95 },
    cost = 20,
    rarity = 4, 
    blueprint_compat = false, 
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },
    
    update = function(self, card, dt)
        
        if G.GAME and card.area == G.jokers then
            G.GAME.kranlaxs_evil_meter = 100
        end
    end
}