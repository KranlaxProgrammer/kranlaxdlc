SMODS.Joker{
    key = "gula",
    config = { extra = {} },
    pos = { x = 0, y = 0 },
    cost = 20,
    bm_cost = 7,
    rarity = "kranlaxs_zenith",
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and not context.repetition and not context.individual then
            
            local food_pool = {
                "j_gros_michel", "j_egg", "j_ice_cream", "j_cavendish", "j_turtle_bean", "j_diet_cola", 
                "j_popcorn", "j_ramen", "j_selzer", "j_kranlaxs_birthdaycake", "j_kranlaxs_colasoda", 
                "j_kranlaxs_icecreamsandwich", "j_kranlaxs_bottledwater", "j_kranlaxs_sushi", 
                "j_kranlaxs_grapesoda", "j_kranlaxs_potatobag", "j_kranlaxs_galletas"
            }
            local key = pseudorandom_element(food_pool, pseudoseed('gula_gen'))
            
            return {
                message = "¡Comida!",
                colour = G.C.GREEN,
                func = function()
                    if #G.jokers.cards < G.jokers.config.card_limit then
                        local new_joker = create_card('Joker', G.jokers, nil, nil, nil, nil, key, 'gula')
                        new_joker:add_to_deck()
                        G.jokers:emplace(new_joker)
                    end
                    return true
                end
            }
        end
    end
}