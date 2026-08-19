if not SMODS.kranlaxs_thefixer_hooked then
    local original_sell_card = Card.sell_card
    function Card:sell_card()
        if self.ability and self.ability.set == 'Joker' then
            if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
                local profile = G.PROFILES[G.SETTINGS.profile]
                profile.kranlaxs_sold_rarities = profile.kranlaxs_sold_rarities or {
                    Common = 0,
                    Uncommon = 0,
                    Rare = 0,
                    Legendary = 0
                }
                
                if self:is_rarity("Common") then 
                    profile.kranlaxs_sold_rarities.Common = profile.kranlaxs_sold_rarities.Common + 1
                elseif self:is_rarity("Uncommon") then 
                    profile.kranlaxs_sold_rarities.Uncommon = profile.kranlaxs_sold_rarities.Uncommon + 1
                elseif self:is_rarity("Rare") then 
                    profile.kranlaxs_sold_rarities.Rare = profile.kranlaxs_sold_rarities.Rare + 1
                elseif self:is_rarity("Legendary") then 
                    profile.kranlaxs_sold_rarities.Legendary = profile.kranlaxs_sold_rarities.Legendary + 1
                end
            end
        end
        original_sell_card(self)
    end
    SMODS.kranlaxs_thefixer_hooked = true
end

SMODS.Joker{ 
    key = "thefixer",
    config = {
        extra = {
            blind_size0 = 0.9,
            blind_size02 = 0.7,
            blind_size03 = 0.35,
            blind_size04 = 0.05
        }
    },
    pos = { x = 3, y = 0 },
    display_size = { w = 71, h = 95 },
    cost = 10,
    rarity = 3,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_mycustom_jokers"] = true },

    check_for_unlock = function(self, args)
        if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
            local sold = G.PROFILES[G.SETTINGS.profile].kranlaxs_sold_rarities
            if sold and sold.Common >= 2 and sold.Uncommon >= 2 and sold.Rare >= 2 and sold.Legendary >= 2 then
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
    
    set_ability = function(self, card, initial)
        if initial and G.STAGE == G.STAGES.RUN then
            card:set_eternal(true)
            card:add_sticker('rental', true)
            card:set_edition("e_negative", true)
        end
    end,
    
    calculate = function(self, card, context)
        if context.selling_card and context.card.ability.set == 'Joker' and not context.blueprint then
            if G.GAME.blind and G.GAME.blind.in_blind then
                local mult = 1
                
                if context.card:is_rarity("Common") then mult = card.ability.extra.blind_size0
                elseif context.card:is_rarity("Uncommon") then mult = card.ability.extra.blind_size02
                elseif context.card:is_rarity("Rare") then mult = card.ability.extra.blind_size03
                elseif context.card:is_rarity("Legendary") then mult = card.ability.extra.blind_size04
                end

                if mult < 1 then
                    return {
                        func = function()
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = "-" .. (100 - (mult * 100)) .. "% Blind Size", colour = G.C.GREEN})
                            G.GAME.blind.chips = math.floor(G.GAME.blind.chips * mult)
                            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                            G.HUD_blind:recalculate()
                            return true
                        end
                    }
                end
            end
        end
    end
}