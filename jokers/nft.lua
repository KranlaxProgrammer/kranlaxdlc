local function loc(str)
    local lang = G.SETTINGS.language or 'en-us'
    local dict = {
        ["Downgraded!"] = {es="¡Degradada!", pt="Rebaixada!"}
    }
    if lang == 'es_419' or lang == 'es_ES' then return dict[str] and dict[str].es or str end
    if lang == 'pt_BR' then return dict[str] and dict[str].pt or str end
    return str
end

SMODS.Joker{
    key = "nft",
    config = {
        extra = {}
    },
    pos = { x = 6, y = 3 },
    display_size = { w = 71, h = 95 },
    cost = 5,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

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
        if context.individual and context.cardarea == G.hand and not context.end_of_round and not context.blueprint then
            
            local target_card = context.other_card
            local id = target_card:get_id()
            
            if id > 2 and id <= 14 then
                
                local rank_map = {
                    [14] = "King", [13] = "Queen", [12] = "Jack", [11] = "10",
                    [10] = "9", [9] = "8", [8] = "7", [7] = "6",
                    [6] = "5", [5] = "4", [4] = "3", [3] = "2"
                }
                
                G.E_MANAGER:add_event(Event({
                    func = function()
                        SMODS.change_base(target_card, nil, rank_map[id])
                        play_sound('tarot1', 0.9, 0.6) 
                        return true
                    end
                }))
                
                return {
                    message = loc("Downgraded!"),
                    colour = G.C.RED,
                    card = card
                }
            end
        end
    end
}