SMODS.Joker{
    key = "grannyjoker_alt",
    config = {
        extra = {
            e_chips = 3,
            e_mult = 3
        }
    },
    pos = { x = 0, y = 5 }, -- Reutiliza la textura de la abuela original
    display_size = { w = 71, h = 95 },
    cost = 12,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true, -- Debe estar desbloqueado para que el reto te lo pueda dar
    discovered = true,
    atlas = 'CustomJokers',
    no_collection = true, -- Oculto del libro de colección

    in_pool = function(self, args)
        -- Magia oscura: jamás aparecerá en tiendas, ni boosters, ni conjurado
        return false 
    end,
    
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                e_chips = card.ability.extra.e_chips,
                extra = {
                    e_mult = card.ability.extra.e_mult,
                    colour = G.C.DARK_EDITION
                }
            }
        end

        if context.before and not context.blueprint then
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