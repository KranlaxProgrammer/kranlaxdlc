-- Función blindada para extraer dinero sin importar qué mod de números uses
local function get_safe_dollars()
    if not G.GAME or not G.GAME.dollars then return 0 end
    local d = G.GAME.dollars
    
    -- Si es un número normal de Balatro
    if type(d) == 'number' then return d end
    
    -- Si es de Amulet/Talisman, probamos sus métodos internos de forma segura
    local ok, val = pcall(function() return d:to_number() end)
    if ok and type(val) == 'number' then return val end
    
    ok, val = pcall(function() return d:toNumber() end)
    if ok and type(val) == 'number' then return val end
    
    ok, val = pcall(function() return tonumber(d) end)
    if ok and type(val) == 'number' then return val end
    
    return 0
end

SMODS.Joker{
    key = "silkgloves",
    config = { extra = { provided_h_size = 0, dollars_req = 100 } },
    pos = { x = 11, y = 7 },
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
        local current_bonus = math.floor(math.max(0, dollars) / card.ability.extra.dollars_req)
        return { vars = { card.ability.extra.dollars_req, current_bonus } }
    end,

    update = function(self, card, dt)
        if G.hand and card.added_to_deck and not card.debuff then
            local dollars = get_safe_dollars()
            local target_h_size = math.floor(math.max(0, dollars) / card.ability.extra.dollars_req)
            
            if card.ability.extra.provided_h_size ~= target_h_size then
                local diff = target_h_size - card.ability.extra.provided_h_size
                G.hand:change_size(diff)
                card.ability.extra.provided_h_size = target_h_size
            end
        elseif G.hand and card.ability.extra.provided_h_size > 0 then
            G.hand:change_size(-card.ability.extra.provided_h_size)
            card.ability.extra.provided_h_size = 0
        end
    end,

    remove_from_deck = function(self, card, from_debuff)
        if G.hand and card.ability.extra.provided_h_size > 0 then
            G.hand:change_size(-card.ability.extra.provided_h_size)
            card.ability.extra.provided_h_size = 0
        end
    end
}