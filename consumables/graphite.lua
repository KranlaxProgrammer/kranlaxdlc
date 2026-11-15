SMODS.Consumable {
    key = 'graphite',
    set = 'Quartz',
    pos = { x = 16, y = 0 }, 
    cost = 6,
    unlocked = false, 
    discovered = false,
    unlock_condition = {type = '', extra = ''},
    atlas = 'QuartzConsumables',
    config = { extra = { chance = 12, max_chance = 12 } },

    in_pool = function(self, args)
        if SMODS.showman and SMODS.showman('c_kranlaxs_' .. self.key) then return true end
        if not G.consumeables or not G.consumeables.cards then return true end
        for _, v in ipairs(G.consumeables.cards) do
            if v.config.center.key == 'c_kranlaxs_' .. self.key then return false end
        end
        return true
    end,
    
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.chance, card.ability.extra.max_chance}}
    end,
    
    can_use = function(self, card)
        return false 
    end,
    
    calculate = function(self, card, context)
        -- Cambiado a context.before para que ocurra ANTES de puntuar
        if context.before and not context.blueprint then
            if card.ability.extra.chance > 0 then
                if pseudorandom('graphite') < (card.ability.extra.chance / card.ability.extra.max_chance) then
                    
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after', delay = 0.2,
                        func = function()
                            play_sound('tarot1')
                            card:juice_up(0.3, 0.5)
                            return true
                        end
                    }))

                    for i = 1, #context.full_hand do
                        local copied_card = context.full_hand[i]
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                local copy = copy_card(copied_card, nil, nil, G.playing_card)
                                copy:add_to_deck()
                                G.deck.config.card_limit = G.deck.config.card_limit + 1
                                table.insert(G.playing_cards, copy)
                                G.hand:emplace(copy)
                                copy:juice_up()
                                return true
                            end
                        }))
                    end
                    
                    card.ability.extra.chance = card.ability.extra.chance - 1
                    
                    return {
                        message = "¡Copiadas!",
                        colour = G.C.DARK_EDITION
                    }
                end
            end
        end
    end,

    check_for_unlock = function(self, args)
        if args.type == 'win' then
            if G.GAME.selected_back.effect.center.key == 'b_black' and G.GAME.modifiers.kranlaxs_magenta_pinned then
                return true 
            end
        end
        return false
    end
}