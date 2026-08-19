SMODS.Joker{
    key = "mandalajoker",
    config = {
        extra = {
            espectralmult = 1
        }
    },
    pos = { x = 9, y = 1 },
    display_size = { w = 71, h = 95 },
    cost = 6,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    
    -- ===================================================
    -- SISTEMA DE DESBLOQUEO
    -- ===================================================
    unlocked = false,
    discovered = false,
    
    check_for_unlock = function(self, args)
        -- G.GAME.consumeable_usage guarda TODO lo usado EN LA RUN ACTUAL
        if G.GAME and G.GAME.consumeable_usage then
            local spectral_count = 0
            
            for k, v in pairs(G.GAME.consumeable_usage) do
                -- Balatro guarda directamente el "set" (categoría) de la carta aquí
                if v.set == 'Spectral' then
                    -- Sumamos la cantidad de veces que se usó esta carta específica
                    spectral_count = spectral_count + v.count
                end
            end
            
            if spectral_count >= 20 then
                return true
            end
        end
        return false
    end,

    locked_loc_vars = function(self, info_queue, card)
        local spectral_count = 0
        if G.GAME and G.GAME.consumeable_usage then
            for k, v in pairs(G.GAME.consumeable_usage) do
                if v.set == 'Spectral' then
                    spectral_count = spectral_count + v.count
                end
            end
        end
        return {vars = {spectral_count}}
    end,
    -- ===================================================

    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    in_pool = function(self, args)
        if not G.jokers or not G.jokers.cards then return true end
        for _, v in ipairs(G.jokers.cards) do
            if v.config.center.key == 'j_kranlaxs_' .. self.key then
                return false 
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