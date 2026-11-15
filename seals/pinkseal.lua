SMODS.Seal {
    key = 'pinkseal',
    pos = { x = 0, y = 0 },
    config = {
        extra = {
            emult0 = 1.1
        }
    },
    badge_colour = HEX('FF66CC'),

    atlas = 'CustomSeals',
    unlocked = true,
    discovered = true,
    no_collection = false,
    
    loc_vars = function(self, info_queue, card)
        local unbal = SMODS.Mods["kranlaxs"] and SMODS.Mods["kranlaxs"].config.unbalanced_mode
        local e_m = unbal and 1.75 or self.config.extra.emult0
        
        return { vars = { e_m } }
    end,

    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            local unbal = SMODS.Mods["kranlaxs"] and SMODS.Mods["kranlaxs"].config.unbalanced_mode
            local e_m = unbal and 1.75 or self.config.extra.emult0
            
            return {
                e_mult = e_m,
                message = "^" .. e_m .. " Mult",
                colour = G.C.DARK_EDITION
            }
        end
    end
}