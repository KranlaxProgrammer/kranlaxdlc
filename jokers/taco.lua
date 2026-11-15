if not SMODS.kranlaxs_taco_hook then
    local orig_start_dissolve = Card.start_dissolve
    function Card:start_dissolve(color, silent, dissolve_time_fac, no_juice)
        if self.base and self.base.suit and self.base.value and G.jokers and G.jokers.cards then
            for _, v in ipairs(G.jokers.cards) do
                if v.config.center.key == 'j_kranlaxs_taco' and not v.debuff then
                    -- Rework: La mecánica original fue eliminada. Solo ocurre en Modo Desbalance.
                    local unbal = SMODS.Mods["kranlaxs"] and SMODS.Mods["kranlaxs"].config.unbalanced_mode
                    if unbal then
                        v.ability.extra.x_mult = v.ability.extra.x_mult + 0.5
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after', delay = 0.1,
                            func = function()
                                v:juice_up(0.3, 0.3)
                                card_eval_status_text(v, 'extra', nil, nil, nil, {message = "+0.5 XMult", colour = G.C.RED})
                                return true
                            end
                        }))
                    end
                end
            end
        end
        if orig_start_dissolve then orig_start_dissolve(self, color, silent, dissolve_time_fac, no_juice) end
    end
    SMODS.kranlaxs_taco_hook = true
end

SMODS.Joker{
    key = "taco",
    -- Rework: Gain removido de los extras base
    config = { extra = { x_mult = 3, loss = 0.25 } },
    pos = { x = 012, y = 03 }, 
    display_size = { w = 71, h = 95 },
    cost = 6,
    rarity = 2, 
    blueprint_compat = true,
    eternal_compat = false, 
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    
    pools = { ["kranlaxs_kranlaxs_jokers"] = true, ["kranlaxs_food"] = true },

    in_pool = function(self, args)
        if SMODS.showman and SMODS.showman('j_kranlaxs_' .. self.key) then return true end
        local areas_to_check = {G.jokers, G.shop_jokers, G.pack_cards}
        for _, area in ipairs(areas_to_check) do
            if area and area.cards then
                for _, v in ipairs(area.cards) do
                    if v.config and v.config.center and v.config.center.key == 'j_kranlaxs_' .. self.key then return false end
                end
            end
        end
        return true
    end,
    
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.x_mult, card.ability.extra.loss}}
    end,
    
    calculate = function(self, card, context)
        if context.joker_main then
            if card.ability.extra.x_mult > 1 then
                return {
                    message = "X" .. card.ability.extra.x_mult .. " Mult",
                    Xmult_mod = card.ability.extra.x_mult,
                    colour = G.C.RED
                }
            end
        end

        if context.after and not context.blueprint then
            card.ability.extra.x_mult = card.ability.extra.x_mult - card.ability.extra.loss
            
            if card.ability.extra.x_mult <= 1 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.collide.can = false
                        card.states.drag.can = false
                        card:start_dissolve({G.C.RED}, nil, 1.6)
                        return true
                    end
                }))
                return {
                    message = "¡Comido!",
                    colour = G.C.RED
                }
            else
                return {
                    message = "-" .. card.ability.extra.loss .. " XMult",
                    colour = G.C.RED
                }
            end
        end
    end
}