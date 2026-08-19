SMODS.Joker{
    key = "thethreers",
    config = { extra = {} },
    pos = { x = 3, y = 5 },
    display_size = { w = 71, h = 95 },
    cost = 4,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    
    unlocked = false, -- ¡Cambiado a false para activar el candado!
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    -- Función que atrapa la victoria en Pozo Dorado
    check_for_unlock = function(self, args)
        if args and args.type == 'win' then
            -- Verificamos Pozo Dorado (stake == 8) y la baraja Reto Semanal
            if G.GAME and G.GAME.stake == 8 and G.GAME.selected_back and G.GAME.selected_back.effect.center.key == 'b_kranlaxs_week_challenge' then
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
    
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local copies_made = false
            for _, v in ipairs(context.full_hand) do
                local copy = copy_card(v, nil, nil, nil, true)
                copy:add_to_deck()
                G.deck.config.card_limit = G.deck.config.card_limit + 1
                
                table.insert(G.playing_cards, copy)
                G.deck:emplace(copy)
                
                copy.playing_card = G.playing_cards[#G.playing_cards]
                copies_made = true
            end
            
            if copies_made then
                return {
                    message = "Copied!",
                    colour = G.C.GREEN
                }
            end
        end

        if context.destroying_card and not context.blueprint then
            local is_scored = false
            for _, v in ipairs(context.scoring_hand) do
                if v == context.destroying_card then
                    is_scored = true
                    break
                end
            end
            
            if is_scored then
                return true
            end
        end
    end
}