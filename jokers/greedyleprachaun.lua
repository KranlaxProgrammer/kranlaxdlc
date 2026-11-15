local sug = SMODS.Mods["kranlaxs"].config.suggestive_sprites
SMODS.Joker{ 
    key = "greedyleprachaun",
    config = { extra = { card_draw = 4, shake_timer = 0 } },
    pos = { x = 7, y = 0 },
    display_size = { w = 71, h = 95 },
    cost = 5,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },
    
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
    
    loc_vars = function(self, info_queue, card) return {vars = {card.ability.extra.card_draw}} end,
    
    update = function(self, card, dt)
        if card.area == G.jokers and G.GAME and G.GAME.current_round and G.GAME.current_round.discards_used == 0 then
            card.ability.extra.shake_timer = (card.ability.extra.shake_timer or 0) + dt
            if card.ability.extra.shake_timer > 1.2 then
                card:juice_up(0.04, 0.04) 
                card.ability.extra.shake_timer = 0
            end
        end
    end,
    
    calculate = function(self, card, context)
        if context.pre_discard and G.GAME.current_round.discards_used == 0 then
            
            local draw_count = card.ability.extra.card_draw
            local state_changed = false
            
            G.E_MANAGER:add_event(Event({
                trigger = 'condition',
                condition = function()
                    if G.STATE ~= G.STATES.SELECTING_HAND then
                        state_changed = true
                    end
                    return state_changed and G.STATE == G.STATES.SELECTING_HAND
                end,
                func = function()
                    for i = 1, draw_count do
                        if G.deck and G.deck.cards and #G.deck.cards > 0 then
                            draw_card(G.deck, G.hand, i * 100 / draw_count, 'up', true)
                        end
                    end
                    return true
                end
            }))
            
            return {
                message = "+" .. draw_count .. " Cartas",
                colour = G.C.CHIPS,
                card = card
            }
        end
    end
}