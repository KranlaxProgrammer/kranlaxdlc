SMODS.Joker{
    key = "grannyjoker",
    config = {
        extra = {
            e_chips = 3,
            e_mult = 3,
            saved_speed = 1
        }
    },
    pos = { x = 0, y = 5 },
    display_size = { w = 71, h = 95 },
    cost = 12,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    check_for_unlock = function(self, args)
        if args and args.type == 'round_win' then
            if G.SETTINGS and G.SETTINGS.GAMESPEED == 0.5 then
                if G.PROFILES and G.PROFILES[G.SETTINGS.profile] then
                    G.PROFILES[G.SETTINGS.profile].kranlaxs_slow_blinds_defeated = (G.PROFILES[G.SETTINGS.profile].kranlaxs_slow_blinds_defeated or 0) + 1
                end
            end
        end
        
        if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
            if (G.PROFILES[G.SETTINGS.profile].kranlaxs_slow_blinds_defeated or 0) >= 12 then
                return true
            end
        end
        return false
    end,

    in_pool = function(self, args)
        if not G.jokers or not G.jokers.cards then return true end
        for _, v in ipairs(G.jokers.cards) do
            if v.config.center.key == 'j_kranlaxs_' .. self.key then
                return false 
            end
        end
        return true
    end,

    add_to_deck = function(self, card, from_debuff)
        if not from_debuff and G.SETTINGS then
            if G.SETTINGS.GAMESPEED ~= 0.5 then
                card.ability.extra.saved_speed = G.SETTINGS.GAMESPEED
            end
            G.SETTINGS.GAMESPEED = 0.5
        end
    end,

    remove_from_deck = function(self, card, from_debuff)
        if not from_debuff and G.SETTINGS then
            G.SETTINGS.GAMESPEED = card.ability.extra.saved_speed or 1
        end
    end,

    update = function(self, card, dt)
        if card.area and card.area == G.jokers then
            if G.SETTINGS and G.SETTINGS.GAMESPEED ~= 0.5 then
                G.SETTINGS.GAMESPEED = 0.5
            end
        end
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