local function calculate_collector_xmult(self_card)
    local x_mult = 1
    local unique_editions = {}
    local unique_enhancements = {}
    local unique_seals = {}
    local has_rarity = {false, false, false, false}

    if G.playing_cards then
        for _, c in ipairs(G.playing_cards) do
            if c.edition then 
                local ed_name = c.edition.type or c.edition.key
                if not ed_name then
                    if c.edition.foil then ed_name = 'foil'
                    elseif c.edition.holographic then ed_name = 'holo'
                    elseif c.edition.polychrome then ed_name = 'poly'
                    elseif c.edition.negative then ed_name = 'negative'
                    else ed_name = 'unknown' end
                end
                unique_editions[ed_name] = true 
            end
            if c.config and c.config.center and c.config.center.effect ~= 'Base' then 
                unique_enhancements[c.config.center.key] = true 
            end
            if c.seal then unique_seals[c.seal] = true end
        end
    end
    
    if G.jokers and G.jokers.cards then
        for _, c in ipairs(G.jokers.cards) do
            if c ~= self_card then
                if c.edition then 
                    local ed_name = c.edition.type or c.edition.key
                    if not ed_name then
                        if c.edition.foil then ed_name = 'foil'
                        elseif c.edition.holographic then ed_name = 'holo'
                        elseif c.edition.polychrome then ed_name = 'poly'
                        elseif c.edition.negative then ed_name = 'negative'
                        else ed_name = 'unknown' end
                    end
                    unique_editions[ed_name] = true 
                end
                if c.config and c.config.center then
                    local r = c.config.center.rarity
                    if r == 1 or r == 'Common' or r == 'kranlaxs_common' then has_rarity[1] = true
                    elseif r == 2 or r == 'Uncommon' or r == 'kranlaxs_uncommon' then has_rarity[2] = true
                    elseif r == 3 or r == 'Rare' or r == 'kranlaxs_rare' then has_rarity[3] = true
                    elseif r == 4 or r == "Legendary" or r == 'kranlaxs_legendary' or r == 'zenith' or r == 'kranlaxs_zenith' then has_rarity[4] = true end
                end
            end
        end
    end
    
    for k,v in pairs(unique_editions) do x_mult = x_mult + 0.25 end
    for k,v in pairs(unique_enhancements) do x_mult = x_mult + 0.20 end
    for k,v in pairs(unique_seals) do x_mult = x_mult + 0.20 end
    if has_rarity[1] then x_mult = x_mult + 0.25 end
    if has_rarity[2] then x_mult = x_mult + 0.50 end
    if has_rarity[3] then x_mult = x_mult + 1.00 end
    if has_rarity[4] then x_mult = x_mult + 2.00 end
    
    return x_mult
end

SMODS.Joker {
    key = 'collector',
    atlas = 'CustomJokers',
    pos = { x = 7, y = 9 },
    rarity = 3,
    cost = 8,
    unlocked = false,
    discovered = false,
    blueprint_compat = true,
    
    check_for_unlock = function(self, args)
        local count = 0
        if G.P_CENTERS then
            for k, v in pairs(G.P_CENTERS) do
                if v.set == 'Joker' and v.discovered then count = count + 1 end
            end
        end
        if count >= 100 then return true end
        return false
    end,

    locked_loc_vars = function(self, info_queue, card)
        local count = 0
        if G.P_CENTERS then
            for k, v in pairs(G.P_CENTERS) do
                if v.set == 'Joker' and v.discovered then count = count + 1 end
            end
        end
        return { vars = { count } }
    end,

    loc_vars = function(self, info_queue, card)
        local count = 0
        if G.P_CENTERS then
            for k, v in pairs(G.P_CENTERS) do
                if v.set == 'Joker' and v.discovered then count = count + 1 end
            end
        end
        -- Usa la funcion externa local ya existente en tu archivo
        return { vars = { count, calculate_collector_xmult(card) } }
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
    
    calculate = function(self, card, context)
        if context.joker_main then
            local dynamic_xmult = calculate_collector_xmult(card)
            if dynamic_xmult > 1 then
                return { message = "X" .. dynamic_xmult .. " Mult", Xmult_mod = dynamic_xmult, colour = G.C.DARK_EDITION }
            end
        end
    end
}