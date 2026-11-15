SMODS.Joker {
    key = "painterjoker",
    atlas = 'CustomJokers',
    pos = { x = 3, y = 2 },
    rarity = "kranlaxs_zenith",
    cost = 5,
    unlocked = false,
    discovered = false,
    bm_cost = 8,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    
    config = { extra = { queued_tags = 0, cost = 5, is_processing = false } },
    
    check_for_unlock = function(self, args)
        if args and args.type == 'win' then
            if G.GAME and G.GAME.stake == 7 and G.GAME.selected_back and G.GAME.selected_back.effect.center.key == 'b_kranlaxs_week_challenge' then
                return true
            end
        end
        return false
    end,
    
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {set = 'Tag', key = 'tag_juggle'}
        return { vars = { card.ability.extra.queued_tags, card.ability.extra.cost } }
    end,

    
    update = function(self, card, dt)
        if G.STATE == G.STATES.SHOP then
            
            if card.ability.extra.queued_tags > 0 and G.GAME.dollars >= card.ability.extra.cost then
                if not card.ability.extra.is_processing then
                    card.ability.extra.is_processing = true
                    
                    local current_money = 0
                    if type(G.GAME.dollars) == 'table' and G.GAME.dollars.to_number then
                        current_money = G.GAME.dollars:to_number()
                    else
                        current_money = tonumber(G.GAME.dollars) or 0
                    end
                    
                    local tags_to_create = 0
                    local total_cost = 0
                    local initial_queued = card.ability.extra.queued_tags
                    local tag_price = card.ability.extra.cost
                    
                    
                    for i = 1, initial_queued do
                        if (current_money - total_cost) >= tag_price then
                            tags_to_create = tags_to_create + 1
                            total_cost = total_cost + tag_price
                            card.ability.extra.queued_tags = card.ability.extra.queued_tags - 1
                        else
                            break
                        end
                    end
                    
                    
                    if tags_to_create > 0 then
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.2,
                            func = function()
                                ease_dollars(-total_cost)
                                for i = 1, tags_to_create do
                                    add_tag(Tag('tag_juggle'))
                                end
                                card:juice_up(0.5, 0.5)
                                play_sound('coin1')
                                card_eval_status_text(card, 'extra', nil, nil, nil, {message = "-$" .. total_cost, colour = G.C.MONEY})
                                card.ability.extra.is_processing = false
                                return true
                            end
                        }))
                    else
                        card.ability.extra.is_processing = false
                    end
                end
            end
        else
            
            card.ability.extra.is_processing = false
        end
    end,
    
    
    calculate = function(self, card, context)
        if context.before then
            local wild_played = 0
            for _, c in ipairs(context.full_hand) do
                
                local is_wild = (c.ability.effect == 'Wild Card') or (c.ability.name == 'Wild Card') or (c.ability.name == 'Carta Versátil') or (c.config.center.key == 'm_wild')
                if SMODS.has_enhancement then is_wild = is_wild or SMODS.has_enhancement(c, 'm_wild') end
                
                if is_wild then wild_played = wild_played + 1 end
            end
            
            if wild_played > 0 then
                card.ability.extra.queued_tags = (card.ability.extra.queued_tags or 0) + wild_played
                return {
                    message = "+" .. wild_played .. " en cola",
                    colour = G.C.ORANGE,
                    card = card
                }
            end
        end
    end
}