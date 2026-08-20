
SMODS.Edition {
    key = 'cursed',
    shader = 'foil',
    prefix_config = {
        -- This allows using the vanilla shader
        -- Not needed when using your own
        shader = false
    },
    config = {
        extra = {
            odds = 4
        }
    },
    in_shop = false,
    apply_to_float = false,
    disable_shadow = false,
    disable_base_shader = false,
    loc_txt = {
        name = 'Cursed',
        label = 'Cursed',
        text = {
            [1] = 'A {C:blue}custom{} edition with {C:red}unique{} effects.'
        }
    },
    unlocked = true,
    discovered = true,
    no_collection = false,
    loc_vars = function(self, info_queue, card)
        return {vars = {}}
    end,
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    
    calculate = function(self, card, context)
        if (context.pre_joker or (context.main_scoring and context.cardarea == G.play)) then
            card.should_destroy = false
            SMODS.calculate_effect({balance = true}, card)
            if SMODS.pseudorandom_probability(card, 'group_0_06b9afdf', 1, card.ability.extra.odds, 'j_mycustom_cursed', false) then
                context.other_card.should_destroy = true
                card.should_destroy = true
                
            end
        end
    end
}