SMODS.Joker{
    key = "chronometer",
    config = { extra = {} },
    pos = { x = 4, y = 2 },
    display_size = { w = 71, h = 95 },
    cost = 8,
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
            -- En el juego base, el pozo dorado usa el ID 'gold'
            if G.GAME.selected_back.effect.center.key == 'b_kranlaxs_space_deck' and G.GAME.stake == 'gold' then
                return true
            end
        end
        return false
    end,

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
        local t = os.date("*t")
        return {vars = {t.sec, t.min, t.hour}}
    end,
    
    -- NUEVA FUNCIÓN: Se activa automáticamente en la pantalla de cobro de fin de ronda
    calc_dollar_bonus = function(self, card)
        local t = os.date("*t")
        if t.hour > 0 then
            return t.hour
        end
    end,
    
    calculate = function(self, card, context)
        if context.joker_main then
            -- Toma el tiempo EXACTO en el milisegundo en el que la mano se evalúa
            local t = os.date("*t")
            
            -- Solo devuelve Multi, Fichas y el mensaje de texto
            return {
                chips = t.sec,
                mult = t.min,
                message = string.format("%02d:%02d:%02d", t.hour, t.min, t.sec),
                colour = G.C.ORANGE
            }
        end
    end
}