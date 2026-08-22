SMODS.Edition {
    key = 'sepia',
    shader = 'sepia',
    config = {
        extra = {
            odds = 2
        }
    },
    in_shop = false,
    loc_vars = function(self, info_queue, card)
        return {vars = {G.GAME.probabilities.normal or 1, self.config.extra.odds}}
    end,
    loc_txt = {
        name = 'Sepia',
        label = 'Sepia',
        text = {
            "{C:green}#1# en #2#{} prob. de",
            "crear una {C:attention}Etiqueta{}",
            "si está en mano al puntuar"
        }
    },
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    
    calculate = function(self, card, context)
        if context.cardarea == G.hand and context.main_scoring and not context.blueprint then
            if pseudorandom('sepia_tag') < G.GAME.probabilities.normal / self.config.extra.odds then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local selected_tag = pseudorandom_element(G.P_TAGS, pseudoseed("create_tag")).key
                        local tag = Tag(selected_tag)
                        if tag.name == "Orbital Tag" then
                            local _poker_hands = {}
                            for k, v in pairs(G.GAME.hands) do
                                if v.visible then
                                    _poker_hands[#_poker_hands + 1] = k
                                end
                            end
                            tag.ability.orbital_hand = pseudorandom_element(_poker_hands, "jokerforge_orbital")
                        end
                        tag:set_ability()
                        add_tag(tag)
                        play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                        return true
                    end
                }))
                return {
                    message = "¡Etiqueta!",
                    colour = G.C.ORANGE
                }
            end
        end
    end
}