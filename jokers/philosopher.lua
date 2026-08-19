SMODS.Joker{
    key = 'philosopher',
    config = { extra = { next_cards_str = "" } },
    rarity = 3,
    atlas = 'CustomJokers',
    pos = { x = 4, y = 7 },
    cost = 8,
    blueprint_compat = false,
    unlocked = false,
    discovered = false,
    unlock_condition = {type = '', extra = ''},
    
    check_for_unlock = function(self, args)
        if G and G.PROFILES and G.PROFILES[G.SETTINGS.profile] then
            if G.PROFILES[G.SETTINGS.profile].all_unlocked then return true end
            if G.PROFILES[G.SETTINGS.profile].challenge_progress and G.PROFILES[G.SETTINGS.profile].challenge_progress.completed then
                -- Requiere: Premoniciones
                if G.PROFILES[G.SETTINGS.profile].challenge_progress.completed.c_kranlaxs_reto_premonisiones then return true end
            end
        end
        return false
    end,
    
    update = function(self, card, dt)
        if G.GAME and G.GAME.round_resets then
            local next_cards = ""
            if G.deck and G.deck.cards and #G.deck.cards > 0 then
                local count = 0
                for i = #G.deck.cards, 1, -1 do
                    if count >= 5 then break end
                    local c = G.deck.cards[i]
                    if c and c.base and c.base.suit and c.base.value then
                        if c.philosopher_censored == nil then
                            c.philosopher_censored = (pseudorandom('phil_censor') < 0.2)
                        end
                        if c.philosopher_censored then
                            next_cards = next_cards .. (next_cards == "" and "" or ", ") .. "[?]"
                        else
                            local suit_str = localize(c.base.suit, 'suits_singular')
                            local val_str = c.base.value
                            local is_es = (G.SETTINGS.language == 'es_419' or G.SETTINGS.language == 'es_ES')
                            if val_str == 'Ace' then val_str = 'As'
                            elseif val_str == 'Jack' then val_str = is_es and 'Sota' or 'J'
                            elseif val_str == 'Queen' then val_str = is_es and 'Reina' or 'Q'
                            elseif val_str == 'King' then val_str = is_es and 'Rey' or 'K'
                            end
                            next_cards = next_cards .. (next_cards == "" and "" or ", ") .. val_str .. " de " .. suit_str
                        end
                        count = count + 1
                    end
                end
            end
            if next_cards == "" then next_cards = "Ninguna" end
            card.ability.extra.next_cards_str = next_cards
        end
    end,

    loc_vars = function(self, info_queue, card)
        local cards_str = card.ability.extra.next_cards_str or "Ninguna"
        return { vars = { cards_str } }
    end,
    
    calculate = function(self, card, context) end
}