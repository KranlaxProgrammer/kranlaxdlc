SMODS.Consumable {
    key = 'cinnabar',
    set = 'Quartz',
    pos = { x = 15, y = 0 },
    cost = 5,
    unlocked = false,
    discovered = false,
    unlock_condition = {type = '', extra = ''},
    atlas = 'QuartzConsumables',
    config = { extra = { mult = 40, mult_mod = 5 } },

    in_pool = function(self, args)
        if SMODS.showman and SMODS.showman('c_kranlaxs_' .. self.key) then return true end
        if not G.consumeables or not G.consumeables.cards then return true end
        for _, v in ipairs(G.consumeables.cards) do
            if v.config.center.key == 'c_kranlaxs_' .. self.key then return false end
        end
        return true
    end,
    
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult, card.ability.extra.mult_mod}}
    end,
    
    can_use = function(self, card)
        return false 
    end,
    
    calculate = function(self, card, context)
        -- Cambiado a context.before
        if context.before and context.scoring_hand and #context.scoring_hand > 0 and not context.blueprint then
            if card.ability.extra.mult > 0 then
                local target = context.scoring_hand[1]
                local gain = card.ability.extra.mult_mod
                
                -- Suma permanente nativa ANTES de que la carta sea evaluada
                target.ability.perma_mult = (target.ability.perma_mult or 0) + gain
                card.ability.extra.mult = card.ability.extra.mult - gain
                
                G.E_MANAGER:add_event(Event({
                    func = function()
                        target:juice_up()
                        card_eval_status_text(target, 'extra', nil, nil, nil, {message = "+"..gain, colour = G.C.MULT})
                        
                        -- Se destruye si llega a 0
                        if card.ability.extra.mult <= 0 then
                            play_sound('tarot1')
                            card:start_dissolve()
                        else
                            card:juice_up()
                        end
                        return true
                    end
                }))
            end
        end
    end,

    check_for_unlock = function(self, args)
        if args.type == 'win' then
            if G.GAME.selected_back.effect.center.key == 'b_abandoned' and G.GAME.stake == 'kranlaxs_brown' then
                return true
            end
        end
        return false
    end
}