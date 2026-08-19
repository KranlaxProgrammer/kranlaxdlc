if not SMODS.kranlaxs_geode_hooked then
    local original_evaluate_play = G.FUNCS.evaluate_play
    G.FUNCS.evaluate_play = function(e)
        if G.play and G.play.cards and #G.play.cards == 5 then
            local wild_count = 0
            for _, v in ipairs(G.play.cards) do
                if v.ability and v.ability.name == 'Wild Card' then
                    wild_count = wild_count + 1
                end
            end
            if wild_count == 5 then
                if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
                    G.PROFILES[G.SETTINGS.profile].kranlaxs_geode_unlocked = true
                end
            end
        end
        original_evaluate_play(e)
    end
    SMODS.kranlaxs_geode_hooked = true
end

SMODS.Joker{ 
    key = "mysteriousgeode",
    config = {
        extra = {
            suitref = 'Spades',
            chips = 100,
            x_mult = 2,
            dollars = 2,
            mult = 14
        }
    },
    pos = { x = 4, y = 0 },
    display_size = { w = 71, h = 95 },
    cost = 7,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_mycustom_jokers"] = true },

    check_for_unlock = function(self, args)
        if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
            if G.PROFILES[G.SETTINGS.profile].kranlaxs_geode_unlocked then
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
    
    loc_vars = function(self, info_queue, card)
        return {vars = {localize(card.ability.extra.suitref, 'suits_plural'), card.ability.extra.x_mult, card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.dollars}}
    end,
    
    set_ability = function(self, card, initial)
        if initial then
            local suits = {'Spades', 'Hearts', 'Clubs', 'Diamonds'}
            card.ability.extra.suitref = pseudorandom_element(suits, pseudoseed('geode_init'))
        end
    end,
    
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card.ability.name == 'Wild Card' then
                local suit = card.ability.extra.suitref
                if suit == 'Spades' then
                    return {
                        chips = card.ability.extra.chips,
                        card = card
                    }
                elseif suit == 'Hearts' then
                    return {
                        x_mult = card.ability.extra.x_mult,
                        card = card
                    }
                elseif suit == 'Clubs' then
                    return {
                        mult = card.ability.extra.mult,
                        card = card
                    }
                elseif suit == 'Diamonds' then
                    return {
                        dollars = card.ability.extra.dollars,
                        card = card
                    }
                end
            end
        end

        if context.after and not context.blueprint then
            local suits = {'Spades', 'Hearts', 'Clubs', 'Diamonds'}
            card.ability.extra.suitref = pseudorandom_element(suits, pseudoseed('geode_change'))
            return {
                message = localize(card.ability.extra.suitref, 'suits_plural'),
                colour = G.C.SUITS[card.ability.extra.suitref]
            }
        end
    end
}