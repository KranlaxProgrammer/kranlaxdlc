SMODS.Joker{
    key = "fidelitycard",
    config = {
        extra = {
            muchBought = 0
        }
    },
    pos = { x = 0, y = 1 },
    display_size = { w = 71, h = 95 },
    cost = 4,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

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
        local total_sell = 0
        if G.jokers and G.jokers.cards then
            for _, j in ipairs(G.jokers.cards) do
                total_sell = total_sell + (j.sell_cost or 0)
            end
        end
        return {vars = {card.ability.extra.muchBought, total_sell}}
    end,
    
    calculate = function(self, card, context)
        if context.buying_card and not context.blueprint then
            if card.ability.extra.muchBought < 6 then
                card.ability.extra.muchBought = card.ability.extra.muchBought + 1
                return {
                    message = card.ability.extra.muchBought .. "/6",
                    colour = G.C.ORANGE,
                    card = card
                }
            elseif card.ability.extra.muchBought >= 6 then
                local total_sell = 0
                if G.jokers and G.jokers.cards then
                    for _, j in ipairs(G.jokers.cards) do
                        total_sell = total_sell + (j.sell_cost or 0)
                    end
                end
                
                card.ability.extra.muchBought = 0
                
                if total_sell > 0 then
                    ease_dollars(total_sell)
                    return {
                        message = "+$" .. total_sell,
                        colour = G.C.MONEY,
                        card = card
                    }
                else
                    return {
                        message = "Free!",
                        colour = G.C.MONEY,
                        card = card
                    }
                end
            end
        end
    end
}