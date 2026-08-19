SMODS.Joker{
    key = "thecousin",
    config = { extra = { cousin = 0 } },
    pos = { x = 6, y = 2 },
    display_size = { w = 71, h = 95 },
    cost = 7,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    
    -- Empieza bloqueado
    unlocked = false,
    discovered = false,
    unlock_condition = {type = '', extra = ''},
    
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    check_for_unlock = function(self, args)
        if args.type == 'win' then
            if G.GAME.selected_back.effect.center.key == 'b_kranlaxs_space_deck' and G.GAME.stake == 'kranlaxs_turquoise' then
                return true
            end
        end
        return false
    end,

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
        return {vars = {card.ability.extra.cousin}}
    end,
    
    calculate = function(self, card, context)
        -- Aumentar las fichas al puntuar un número primo
        if context.individual and context.cardarea == G.play and not context.blueprint then
            local id = context.other_card:get_id()
            if id == 2 or id == 3 or id == 5 or id == 7 or id == 14 then
                card.ability.extra.cousin = card.ability.extra.cousin + 13
                return {
                    message = 'Upgrade!',
                    colour = G.C.CHIPS,
                    card = card
                }
            end
        end

        -- Entregar las fichas acumuladas al evaluar la mano
        if context.joker_main then
            if card.ability.extra.cousin > 0 then
                return {
                    message = "+" .. card.ability.extra.cousin,
                    chip_mod = card.ability.extra.cousin,
                    colour = G.C.CHIPS
                }
            end
        end
    end
}