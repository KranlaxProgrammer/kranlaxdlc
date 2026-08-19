if not SMODS.kranlaxs_unknownfactor_hooked then
    local original_get_id = Card.get_id
    function Card:get_id()
        local id = original_get_id(self)
        if not id then return id end

        if self.base and self.base.suit then
            if next(SMODS.find_card("j_kranlaxs_unkownfactor")) then
                if G.GAME and G.GAME.current_round and G.GAME.current_round.random_factor_card then
                    return G.GAME.current_round.random_factor_card.id
                end
            end
        end
        
        return id
    end
    SMODS.kranlaxs_unknownfactor_hooked = true
end

SMODS.Joker{
    key = "unkownfactor",
    config = {
        extra = {
            target_rank = '2',
            target_id = 2
        }
    },
    pos = { x = 9, y = 4 },
    display_size = { w = 71, h = 95 },
    cost = 6,
    rarity = 3,
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
    
    loc_vars = function(self, info_queue, card)
        local rank_str = localize(card.ability.extra.target_rank, 'ranks')
        return {vars = {rank_str}}
    end,
    
    set_ability = function(self, card, initial)
        if not G.GAME.current_round.random_factor_card then
            G.GAME.current_round.random_factor_card = { rank = '2', id = 2 }
        end
        card.ability.extra.target_rank = G.GAME.current_round.random_factor_card.rank
        card.ability.extra.target_id = G.GAME.current_round.random_factor_card.id
    end,
    
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and not context.blueprint then
            if G.playing_cards then
                local valid_cards = {}
                for _, v in ipairs(G.playing_cards) do
                    if v.ability.effect ~= 'Stone Card' and v.base.value then
                        valid_cards[#valid_cards + 1] = v
                    end
                end
                
                if #valid_cards > 0 then
                    local target = pseudorandom_element(valid_cards, pseudoseed('unknownfactor'))
                    G.GAME.current_round.random_factor_card.rank = target.base.value
                    G.GAME.current_round.random_factor_card.id = target.base.id
                    
                    card.ability.extra.target_rank = target.base.value
                    card.ability.extra.target_id = target.base.id
                    
                    return {
                        message = "Shifted!",
                        colour = G.C.ORANGE
                    }
                end
            end
        end
    end
}