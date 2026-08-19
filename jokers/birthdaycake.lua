SMODS.Joker{
    key = "birthdaycake",
    config = {
        extra = {
            cakemult = 2.5
        }
    },
    pos = { x = 0, y = 2 },
    display_size = { w = 71, h = 95 },
    cost = 8,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    
    unlocked = false, -- ¡Cambiado a false para activar el candado!
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_food"] = true },

    -- Función que atrapa la victoria en Pozo Azul
    check_for_unlock = function(self, args)
        if args and args.type == 'win' then
            if G.GAME and G.GAME.stake == 5 and G.GAME.selected_back and G.GAME.selected_back.effect.center.key == 'b_kranlaxs_week_challenge' then
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
        return {vars = {card.ability.extra.cakemult}}
    end,
    
    calculate = function(self, card, context)
        if context.joker_main then
            if card.ability.extra.cakemult > 1 then
                return {
                    message = "^" .. card.ability.extra.cakemult,
                    e_mult = card.ability.extra.cakemult,
                    colour = G.C.DARK_EDITION
                }
            end
        end

        if context.after and not context.blueprint then
            if card.ability.extra.cakemult > 1 then
                card.ability.extra.cakemult = card.ability.extra.cakemult - 0.25
                
                if card.ability.extra.cakemult <= 1 then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            if #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
                                G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                                local joker_card = SMODS.add_card({ set = 'Joker', key = 'j_kranlaxs_regift' })
                                G.GAME.joker_buffer = 0
                                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_plus_joker'), colour = G.C.BLUE})
                            end
                            
                            card.getting_sliced = true
                            card:start_dissolve({G.C.RED}, nil, 1.6)
                            return true
                        end
                    }))
                else
                    return {
                        message = "-0.25",
                        colour = G.C.RED
                    }
                end
            end
        end
    end
}