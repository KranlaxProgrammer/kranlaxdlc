SMODS.Edition {
    key = 'underwater',
    shader = 'underwater',
    config = {
        extra = {
            xchips0 = 2
        }
    },
    in_shop = false,
    loc_vars = function(self, info_queue, card)
        return {vars = {self.config.extra.xchips0}}
    end,
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    
    calculate = function(self, card, context)
        if (context.edition and context.cardarea == G.jokers and card.config.trigger) or (context.main_scoring and context.cardarea == G.play) then
            return {
                x_chips = self.config.extra.xchips0
            }
        end
        
        if context.joker_main then card.config.trigger = true end
        if context.after then card.config.trigger = nil end
    end
}