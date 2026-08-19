if not SMODS.kranlaxs_pyromaniac_hooked then
    -- 1. Interceptar cuando una carta se disuelve (Cartas de Tarot, Inmolación, Piromaníaco, etc.)
    local original_start_dissolve = Card.start_dissolve
    function Card:start_dissolve(dissolve_colours, silent, dissolve_time_fac, no_juice)
        -- Asegurarnos de que es una carta de la baraja y no una figura
        if self.base and self.base.suit and not self:is_face() then
            -- Asegurarnos de que estamos en una partida activa (evita que cuente en el menú)
            if G.GAME and G.GAME.round_resets then
                if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
                    G.PROFILES[G.SETTINGS.profile].kranlaxs_non_face_destroyed = (G.PROFILES[G.SETTINGS.profile].kranlaxs_non_face_destroyed or 0) + 1
                end
            end
        end
        return original_start_dissolve(self, dissolve_colours, silent, dissolve_time_fac, no_juice)
    end

    -- 2. Interceptar cuando una carta se hace añicos (Cartas de Cristal rompiéndose)
    local original_shatter = Card.shatter
    function Card:shatter()
        if self.base and self.base.suit and not self:is_face() then
            if G.GAME and G.GAME.round_resets then
                if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
                    G.PROFILES[G.SETTINGS.profile].kranlaxs_non_face_destroyed = (G.PROFILES[G.SETTINGS.profile].kranlaxs_non_face_destroyed or 0) + 1
                end
            end
        end
        return original_shatter(self)
    end
    
    SMODS.kranlaxs_pyromaniac_hooked = true
end

SMODS.Joker{
    key = "pyromaniac",
    config = {
        extra = {}
    },
    pos = { x = 1, y = 1 },
    display_size = { w = 71, h = 95 },
    cost = 6,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    check_for_unlock = function(self, args)
        if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
            local destroyed = G.PROFILES[G.SETTINGS.profile].kranlaxs_non_face_destroyed or 0
            if destroyed >= 100 then
                return true
            end
        end
        return false
    end,

    locked_loc_vars = function(self, info_queue, card)
        local destroyed = 0
        if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
            destroyed = G.PROFILES[G.SETTINGS.profile].kranlaxs_non_face_destroyed or 0
        end
        return {vars = {destroyed}}
    end,

    in_pool = function(self, args)
        if not G.jokers or not G.jokers.cards then return true end
        for _, v in ipairs(G.jokers.cards) do
            if v.config.center.key == 'j_kranlaxs_' .. self.key then
                return false 
            end
        end
        return true
    end,
    
    calculate = function(self, card, context)
        if context.destroy_card and context.destroy_card.should_destroy and not context.blueprint then
            return { remove = true }
        end
        
        if context.individual and context.cardarea == G.hand and not context.end_of_round and not context.blueprint then
            context.other_card.should_destroy = false
            
            local enh = SMODS.get_enhancements(context.other_card) or {}
            local is_protected = context.other_card:is_face() or enh["m_gold"] or enh["m_glass"] or enh["m_steel"]
            
            if not is_protected then
                context.other_card.should_destroy = true
                return {
                    message = "Burned!",
                    colour = G.C.RED
                }
            end
        end
    end
}