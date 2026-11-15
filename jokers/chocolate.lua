SMODS.Joker {
    key = 'chocolate',
    atlas = 'CustomJokers',
    pos = { x = 011, y = 04 },
    rarity = 1,
    cost = 4,
    eternal_compat = false,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    config = { extra = { x_mult = 1.5, hands = 10 } },
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult, card.ability.extra.hands } }
    end,
    
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
    
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = "X" .. card.ability.extra.x_mult .. " Mult",
                Xmult_mod = card.ability.extra.x_mult,
                colour = G.C.DARK_EDITION
            }
        end
        
        if context.after and not context.blueprint then
            card.ability.extra.hands = card.ability.extra.hands - 1
            if card.ability.extra.hands <= 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.collide.can = false
                        card.states.drag.can = false
                        card:start_dissolve()
                        return true
                    end
                }))
                return { message = "Agotado" }
            else
                return { message = card.ability.extra.hands .. " Manos" }
            end
        end
    end
}