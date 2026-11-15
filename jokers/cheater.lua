if not SMODS.kranlaxs_cheater_hook then
    local orig_create_card = create_card
    function create_card(type, area, legendary, rarity, skip_materialize, soulable, forced_key, key_append)
        local is_cheated = false
        if area == G.shop_jokers and G.GAME and G.jokers and G.jokers.cards then
            local has_cheater = false
            for _, v in ipairs(G.jokers.cards) do
                if v.config.center.key == 'j_kranlaxs_cheater' and not v.debuff then
                    has_cheater = true; break
                end
            end
            
            if has_cheater and not forced_key then
                local unbal = SMODS.Mods["kranlaxs"] and SMODS.Mods["kranlaxs"].config.unbalanced_mode
                local roll = pseudorandom('cheater_spawn')
                
                if unbal then
                    if roll < 0.15 then
                        type = 'Booster' 
                        is_cheated = true
                    elseif roll < 0.30 then
                        type = 'Voucher'
                        is_cheated = true
                    end
                else
                    if roll < 0.1 then
                        type = 'Booster' 
                        is_cheated = true
                    end
                end
            end
        end
        
        local card = orig_create_card(type, area, legendary, rarity, skip_materialize, soulable, forced_key, key_append)
        
        if is_cheated and card then
            card.cost = math.ceil(card.cost * 1.75)
        end
        
        return card
    end
    SMODS.kranlaxs_cheater_hook = true
end

SMODS.Joker{
    key = 'cheater',
    config = { extra = {} },
    rarity = 3,
    atlas = 'CustomJokers',
    pos = { x = 5, y = 8 },
    cost = 8,
    blueprint_compat = false,
    unlocked = false,
    discovered = false,

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
    
    check_for_unlock = function(self, args)
        if G and G.PROFILES and G.PROFILES[G.SETTINGS.profile] then
            if G.PROFILES[G.SETTINGS.profile].all_unlocked then return true end
            if G.PROFILES[G.SETTINGS.profile].challenge_progress and G.PROFILES[G.SETTINGS.profile].challenge_progress.completed then
                if G.PROFILES[G.SETTINGS.profile].challenge_progress.completed.c_kranlaxs_reto_gachapon then return true end
            end
        end
        return false
    end,
    
    loc_vars = function(self, info_queue, card)
        -- AÑADIDO: Texto dinámico según el modo desbalance
        local unbal = SMODS.Mods["kranlaxs"] and SMODS.Mods["kranlaxs"].config.unbalanced_mode
        local txt = unbal and " o {C:attention}Vales{}" or ""
        return { vars = { txt } }
    end,
    
    calculate = function(self, card, context) end
}