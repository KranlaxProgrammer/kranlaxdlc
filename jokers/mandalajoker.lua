SMODS.Joker{
    key = "mandalajoker",
    config = {
        extra = {
            espectralmult = 1
        }
    },
    pos = { x = 9, y = 1 },
    display_size = { w = 71, h = 95 },
    cost = 8,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    
    
    
    
    unlocked = false,
    discovered = false,
    
    check_for_unlock = function(self, args)
        local spectral_count = 0
        if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].consumeable_usage then
            for k, v in pairs(G.PROFILES[G.SETTINGS.profile].consumeable_usage) do
                if v.set == 'Spectral' then
                    spectral_count = spectral_count + v.count
                end
            end
        end
        if spectral_count >= 20 then return true end
        return false
    end,

    locked_loc_vars = function(self, info_queue, card)
        local spectral_count = 0
        if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].consumeable_usage then
            for k, v in pairs(G.PROFILES[G.SETTINGS.profile].consumeable_usage) do
                if v.set == 'Spectral' then
                    spectral_count = spectral_count + v.count
                end
            end
        end
        return {vars = {spectral_count}}
    end,
    

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
    
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.espectralmult}}
    end,
    
    calculate = function(self, card, context)
        if context.using_consumeable and not context.blueprint then
            if context.consumeable.ability.set == 'Spectral' then
                card.ability.extra.espectralmult = card.ability.extra.espectralmult + 0.5
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Upgrade!", colour = G.C.MULT})
                        return true
                    end
                }))
            end
        end
        
        if context.joker_main then
            if card.ability.extra.espectralmult > 1 then
                return {
                    message = "X" .. card.ability.extra.espectralmult,
                    Xmult_mod = card.ability.extra.espectralmult,
                    colour = G.C.MULT
                }
            end
        end
    end
}