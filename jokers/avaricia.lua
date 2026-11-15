-- Función blindada contra Amulet/Talisman
local function get_safe_dollars()
    if not G.GAME or not G.GAME.dollars then return 0 end
    local d = G.GAME.dollars
    if type(d) == 'number' then return d end
    local ok, val = pcall(function() return d:to_number() end)
    if ok and type(val) == 'number' then return val end
    ok, val = pcall(function() return d:toNumber() end)
    if ok and type(val) == 'number' then return val end
    ok, val = pcall(function() return tonumber(d) end)
    if ok and type(val) == 'number' then return val end
    return 0
end

SMODS.Joker{
    key = "avaricia",
    config = { extra = { req = 10, payout = 1 } },
    pos = { x = 0, y = 0 },
    cost = 20,
    bm_cost = 7,
    rarity = "kranlaxs_zenith",
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    loc_vars = function(self, info_queue, card)
        local dollars = get_safe_dollars()
        local cap = G.GAME and G.GAME.interest_cap or 25
        local excess = math.max(0, dollars - cap)
        local gain = math.floor(excess / card.ability.extra.req) * card.ability.extra.payout
        
        return { vars = { card.ability.extra.req, card.ability.extra.payout, cap, gain } }
    end,

    calc_dollar_bonus = function(self, card)
        if card.debuff then return 0 end
        
        local dollars = get_safe_dollars()
        local cap = G.GAME and G.GAME.interest_cap or 25
        local excess = math.max(0, dollars - cap)
        local gain = math.floor(excess / card.ability.extra.req) * card.ability.extra.payout
        
        if gain > 0 then
            return gain
        end
        return 0
    end
}