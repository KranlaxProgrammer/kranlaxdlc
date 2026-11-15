SMODS.Joker {
    key = 'libra',
    atlas = 'CustomJokers',
    pos = { x = 04, y = 012 },
    rarity = 1,
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,

    
    is_constellation = true, 
    
    
    set_badges = function(self, card, badges)
        local badge_text = "Constellation"
        
        
        if G.localization and G.localization.misc and G.localization.misc.dictionary and G.localization.misc.dictionary.k_constellation then
            badge_text = G.localization.misc.dictionary.k_constellation
        else
            
            if G.SETTINGS.language == 'es_419' or G.SETTINGS.language == 'es_ES' then
                badge_text = "Constelación"
            end
        end
        
        badges[#badges + 1] = create_badge(badge_text, HEX('3D266B'), G.C.WHITE, 1.2)
    end,
    
    loc_vars = function(self, info_queue, card) return { vars = {} } end,
    
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
        if context.setting_blind and not context.blueprint then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.2,
                func = function()
                    -- FIX: Multiplicador base x1 para que actúe igual que la Ciega Pequeña
                    local base_amt = get_blind_amount(G.GAME.round_resets.ante)
                    local new_chips = math.floor(base_amt * 1 * G.GAME.starting_params.ante_scaling)
                    G.GAME.blind.chips = new_chips
                    G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                    card:juice_up(0.5, 0.5)
                    play_sound('tarot1')
                    return true
                end
            }))
        end
    end
}