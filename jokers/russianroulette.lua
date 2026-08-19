SMODS.Joker{
    key = "russianroulette",
    config = { extra = { GunIncrease = 1, odds = 6 } },
    pos = { x = 9, y = 0 },
    display_size = { w = 71, h = 95 },
    cost = 5,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    
    -- Empieza bloqueado
    unlocked = false,
    discovered = false,
    unlock_condition = {type = '', extra = ''},
    
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    check_for_unlock = function(self, args)
        if args.type == 'win' then
            -- El pozo negro usa el ID base 'black'
            if G.GAME.selected_back.effect.center.key == 'b_kranlaxs_space_deck' and G.GAME.stake == 'black' then
                return true
            end
        end
        return false
    end,

    in_pool = function(self, args)
        -- Si el juego apenas está cargando y no hay barra de jokers, permitir que exista en la pool
        if not G.jokers or not G.jokers.cards then return true end
        
        -- Escanear tu barra de Jokers
        for _, v in ipairs(G.jokers.cards) do
            -- Si ya tienes una copia exacta de esta carta, bloquear su aparición
            if v.config.center.key == 'j_kranlaxs_' .. self.key then
                return false 
            end
        end
        
        return true
    end,
    
    loc_vars = function(self, info_queue, card)
        local new_numerator, new_denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'russian_roulette') 
        return {vars = {new_numerator, new_denominator, card.ability.extra.GunIncrease}}
    end,
    
    set_ability = function(self, card, initial)
        if initial and G.STAGE == G.STAGES.RUN then
            card:set_eternal(true)
            card:set_edition("e_negative", true)
        end
    end,
    
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            if SMODS.pseudorandom_probability(card, 'russian_roulette', 1, card.ability.extra.odds) then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = "BANG!", colour = G.C.WHITE})
                        return true
                    end
                }))
                
                G.E_MANAGER:add_event(Event({
                    delay = 1.0,
                    func = function()
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Oops...", colour = G.C.RED})
                        if G.STAGE == G.STAGES.RUN then 
                            G.STATE = G.STATES.GAME_OVER
                            G.STATE_COMPLETE = false
                        end
                        return true
                    end
                }))
            else
                card.ability.extra.GunIncrease = card.ability.extra.GunIncrease + 3
                return {
                    message = "Click...",
                    colour = G.C.GREEN
                }
            end
        end

        if context.joker_main then
            if card.ability.extra.GunIncrease > 1 then
                return {
                    message = "X" .. card.ability.extra.GunIncrease,
                    Xmult_mod = card.ability.extra.GunIncrease,
                    x_chips = card.ability.extra.GunIncrease,
                    colour = G.C.DARK_EDITION
                }
            end
        end
    end
}