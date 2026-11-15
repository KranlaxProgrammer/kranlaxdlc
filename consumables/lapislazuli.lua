SMODS.Consumable {
    key = 'lapislazuli',
    set = 'Quartz',
    pos = { x = 14, y = 0 }, 
    cost = 4,
    unlocked = false, 
    discovered = false,
    unlock_condition = {type = '', extra = ''},
    atlas = 'QuartzConsumables',
    config = { extra = { chips = 40, chip_mod = 4 } },

    in_pool = function(self, args)
        if SMODS.showman and SMODS.showman('c_kranlaxs_' .. self.key) then return true end
        if not G.consumeables or not G.consumeables.cards then return true end
        for _, v in ipairs(G.consumeables.cards) do
            if v.config.center.key == 'c_kranlaxs_' .. self.key then return false end
        end
        return true
    end,
    
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.chips, card.ability.extra.chip_mod}}
    end,
    
    can_use = function(self, card)
        return false 
    end,
    
    calculate = function(self, card, context)
        -- Cambiado a context.before
        if context.before and context.scoring_hand and #context.scoring_hand > 0 and not context.blueprint then
            if card.ability.extra.chips > 0 then
                local target = context.scoring_hand[1]
                local gain = card.ability.extra.chip_mod
                
                -- Suma permanente nativa ANTES de que la carta sea evaluada
                target.ability.perma_bonus = (target.ability.perma_bonus or 0) + gain
                card.ability.extra.chips = card.ability.extra.chips - gain
                
                G.E_MANAGER:add_event(Event({
                    func = function()
                        target:juice_up()
                        card_eval_status_text(target, 'extra', nil, nil, nil, {message = "+"..gain, colour = G.C.CHIPS})
                        
                        -- Se destruye si llega a 0
                        if card.ability.extra.chips <= 0 then
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
            if G.GAME.selected_back.effect.center.key == 'b_blue' and G.GAME.modifiers.kranlaxs_magenta_pinned then
                return true 
            end
        end
        return false
    end
}