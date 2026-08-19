SMODS.Seal {
    key = 'pinkseal',
    pos = { x = 0, y = 0 },
    config = {
        extra = {
            emult0 = 1.75
        }
    },
    badge_colour = HEX('FF66CC'),

    atlas = 'CustomSeals',
    unlocked = true,
    discovered = true,
    no_collection = false,
    calculate = function(self, card, context)
        -- EL ARREGLO: Agregamos "context.cardarea == G.play"
        if context.main_scoring and context.cardarea == G.play then
            return {
                e_mult = 1.75,
                message = "^1.75 Mult"
            }
        end
    end
}