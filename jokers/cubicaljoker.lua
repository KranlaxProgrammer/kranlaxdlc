SMODS.Joker{
    key = "cubicaljoker",
    config = {
        extra = {
            mult_base = 2
        }
    },
    pos = { x = 1, y = 6 },
    display_size = { w = 71, h = 95 },
    cost = 20,
    rarity = 4, -- Legendary
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },
    in_pool = function(self, args)
        if not args then return true end
        -- Se excluye de la tienda y paquetes normales (solo obtenible por "The Soul" u otros medios)
        if args.source == 'sho' or args.source == 'buf' then return false end
        return true
    end,
    
    loc_vars = function(self, info_queue, card)
        -- Usar formato seguro por si el número se vuelve demasiado grande
        local current_mult = number_format(card.ability.extra.mult_base)
        return {vars = {current_mult}}
    end,
    
    calculate = function(self, card, context)
        -- 1. Dar el Multiplicador Base durante la puntuación
        if context.joker_main then
            if to_big(card.ability.extra.mult_base) > to_big(0) then
                return {
                    message = "+" .. number_format(card.ability.extra.mult_base),
                    mult_mod = card.ability.extra.mult_base,
                    colour = G.C.MULT
                }
            end
        end

        -- 2. Elevar al cubo al derrotar a un Jefe Ciega
        if context.end_of_round and context.main_eval and G.GAME.blind.boss and not context.blueprint then
            card.ability.extra.mult_base = card.ability.extra.mult_base ^ 3
            return {
                message = "^3 Mult!",
                colour = G.C.DARK_EDITION
            }
        end
    end
}