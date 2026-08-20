
SMODS.Edition {
    key = 'cosmic',
    shader = 'foil',
    prefix_config = {
        -- This allows using the vanilla shader
        -- Not needed when using your own
        shader = false
    },
    config = {
        extra = {
            levels0 = 1
        }
    },
    in_shop = false,
    apply_to_float = false,
    disable_shadow = false,
    disable_base_shader = false,
    loc_txt = {
        name = 'Cosmic',
        label = 'Cosmic',
        text = {
            [1] = 'A {C:blue}custom{} edition with {C:red}unique{} effects.'
        }
    },
    unlocked = true,
    discovered = true,
    no_collection = false,
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    
    calculate = function(self, card, context)
        if context.discard and context.other_card == card then
            local target_hand
            target_hand = context.scoring_name or "High Card"
            return {
                level_up = 1,
                level_up_hand = target_hand,
                message = localize('k_level_up_ex')
            }
        end
    end
}