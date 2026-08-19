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
                if pseudorandom('cheater_spawn') < 0.35 then
                    type = pseudorandom_element({'Voucher', 'Booster'}, pseudoseed('cheater_type'))
                    is_cheated = true
                end
            end
        end
        
        local card = orig_create_card(type, area, legendary, rarity, skip_materialize, soulable, forced_key, key_append)
        
        -- Si la carta fue forzada por el tramposo, le aumentamos el precio un 75%
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
    unlock_condition = {type = '', extra = ''},
    
    check_for_unlock = function(self, args)
        if G and G.PROFILES and G.PROFILES[G.SETTINGS.profile] then
            if G.PROFILES[G.SETTINGS.profile].all_unlocked then return true end
            if G.PROFILES[G.SETTINGS.profile].challenge_progress and G.PROFILES[G.SETTINGS.profile].challenge_progress.completed then
                -- Requiere: Gachapón
                if G.PROFILES[G.SETTINGS.profile].challenge_progress.completed.c_kranlaxs_reto_gachapon then return true end
            end
        end
        return false
    end,
    
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
    calculate = function(self, card, context) end
}