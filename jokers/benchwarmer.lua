SMODS.Joker{
    key = "benchwarmer",
    config = {
        extra = { }
    },
    pos = { x = 5, y = 0 },
    display_size = { w = 71, h = 95 },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_mycustom_jokers"] = true },

    in_pool = function(self, args)
        -- Si el juego apenas está cargando y no hay barra de jokers, permitir que exista en la pool
        if not G.jokers or not G.jokers.cards then return true end
        
        -- Escanear tu barra de Jokers
        for _, v in ipairs(G.jokers.cards) do
            -- Si ya tienes una copia exacta de esta carta, bloquear su aparición
            if v.config.center.key == 'j_kranlaxs_' .. self.key then
                return false 
            end
        end
        
        return true
    end,
    
    loc_vars = function(self, info_queue, card)
        local max_chips = 0
        if G.hand and G.hand.cards then
            for _, c in ipairs(G.hand.cards) do
                if c.base and c.base.nominal and not c.debuff then
                    if c.base.nominal > max_chips then
                        max_chips = c.base.nominal
                    end
                end
            end
        end
        return { vars = { max_chips * 4 } }
    end,
    
    calculate = function(self, card, context)
        if context.joker_main then
            local max_chips = 0
            
            if G.hand and G.hand.cards then
                for _, c in ipairs(G.hand.cards) do
                    if c.base and c.base.nominal and not c.debuff then
                        if c.base.nominal > max_chips then
                            max_chips = c.base.nominal
                        end
                    end
                end
            end
            
            local total_bonus = max_chips * 4
            
            if total_bonus > 0 then
                return {
                    message = localize{type='variable',key='a_chips',vars={total_bonus}},
                    chip_mod = total_bonus
                }
            end
        end
    end
}