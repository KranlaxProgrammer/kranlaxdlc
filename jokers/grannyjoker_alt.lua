SMODS.Joker{
    key = "grannyjoker_alt",
    config = {
        extra = {
            e_chips = 3,
            e_mult = 3
        }
    },
    pos = { x = 0, y = 5 }, 
    display_size = { w = 71, h = 95 },
    cost = 12,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true, 
    discovered = true,
    atlas = 'CustomJokers',
    no_collection = true, 

    in_pool = function(self, args)
        return false 
    end,
    
    -- ¡EL TRUCO DE QoL!
    -- Redirigimos la traducción para que use el texto exacto de la abuela original.
    loc_vars = function(self, info_queue, card)
        -- Nota: Basado en tu código del reto, asumo que el ID original es 'j_kranlaxs_grannyjoker'.
        -- Si en realidad tu prefijo principal es 'mycustom', cámbialo a 'j_mycustom_grannyjoker'.
        return { key = 'j_kranlaxs_grannyjoker' } 
    end,
    
    calculate = function(self, card, context)
        -- 1. PRIMERO da la puntuación de forma normal
        if context.joker_main then
            return {
                e_chips = card.ability.extra.e_chips,
                extra = {
                    e_mult = card.ability.extra.e_mult,
                    colour = G.C.DARK_EDITION
                }
            }
        end

        -- 2. DESPUÉS de puntuar (context.after), verifica si debe destruirse
        if context.after and not context.blueprint then
            if context.scoring_name == "Straight" or context.scoring_name == "Straight Flush" then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('glass1')
                        card:shatter()
                        return true
                    end
                }))
                return { message = "Shattered!" }
            end
        end
    end
}