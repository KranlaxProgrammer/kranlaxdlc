SMODS.Joker{
    key = "regift",
    config = {
        extra = {}
    },
    pos = { x = 1, y = 2 },
    display_size = { w = 71, h = 95 },
    cost = 0,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    
    -- ===================================================
    -- SISTEMA DE DESBLOQUEO
    -- ===================================================
    unlocked = false,
    discovered = false,
    
    check_for_unlock = function(self, args)
        -- Balatro ya cuenta cuántos jokers has vendido en tu perfil, solo leemos ese dato global
        if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].career_stats then
            local sold_jokers = G.PROFILES[G.SETTINGS.profile].career_stats.c_jokers_sold or 0
            if sold_jokers >= 50 then
                return true
            end
        end
        return false
    end,

    locked_loc_vars = function(self, info_queue, card)
        local sold_jokers = 0
        if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].career_stats then
            sold_jokers = G.PROFILES[G.SETTINGS.profile].career_stats.c_jokers_sold or 0
        end
        return {vars = {sold_jokers}}
    end,
    -- ===================================================

    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    in_pool = function(self, args)
        if not args then return true end
        
        -- Regla 1: No aparecer en la tienda ni en sobres de bufón
        if args.source == 'sho' or args.source == 'buf' then return false end
        
        -- Regla 2: No duplicarse si ya lo tienes en la barra
        if G.jokers and G.jokers.cards then
            for _, v in ipairs(G.jokers.cards) do
                if v.config.center.key == 'j_kranlaxs_' .. self.key then
                    return false 
                end
            end
        end
        
        return true
    end,
    
    calculate = function(self, card, context)
        if context.selling_self and not context.blueprint then
            local is_leg = false
            local r_val = 1
            
            local b_key = (G.GAME.blind and G.GAME.blind.config and G.GAME.blind.config.blind and G.GAME.blind.config.blind.key) or ""
            
            if b_key == 'bl_final_acorn' or b_key == 'bl_final_leaf' or b_key == 'bl_final_heart' or b_key == 'bl_final_vessel' or b_key == 'bl_final_bell' then
                is_leg = true
                r_val = 4 -- Legendario
            elseif G.GAME.blind and G.GAME.blind.boss then
                r_val = 3 -- Raro
            elseif G.GAME.blind and G.GAME.blind.get_type and G.GAME.blind:get_type() == 'Big' then
                r_val = 2 -- Inusual (Uncommon)
            else
                r_val = 1 -- Común (Small)
            end
            
            -- Usamos "<=" en vez de "<" porque en este preciso momento, este comodín sigue ocupando un espacio
            if #G.jokers.cards + G.GAME.joker_buffer <= G.jokers.config.card_limit then
                G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                
                G.E_MANAGER:add_event(Event({
                    func = function()
                        -- Usamos el generador nativo de Balatro para máxima compatibilidad y evitar crasheos
                        local new_card = create_card('Joker', G.jokers, is_leg, r_val, nil, nil, nil, 'regift')
                        new_card:add_to_deck()
                        G.jokers:emplace(new_card)
                        G.GAME.joker_buffer = 0
                        return true
                    end
                }))
                
                return {
                    message = localize('k_plus_joker'),
                    colour = G.C.BLUE
                }
            end
        end
    end
}