SMODS.Consumable {
    key = 'greenquartz',
    set = 'Quartz',
    pos = { x = 10, y = 0 }, 
    cost = 5,
    unlocked = false, 
    discovered = false,
    unlock_condition = {type = '', extra = ''},
    atlas = 'QuartzConsumables',
    config = { extra = { tags_created = 0, max_tags = 5 } },

    in_pool = function(self, args)
        if SMODS.showman and SMODS.showman('c_kranlaxs_' .. self.key) then return true end
        if not G.consumeables or not G.consumeables.cards then return true end
        for _, v in ipairs(G.consumeables.cards) do
            if v.config.center.key == 'c_kranlaxs_' .. self.key then return false end
        end
        return true
    end,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.tags_created, card.ability.extra.max_tags}}
    end,

    can_use = function(self, card)
        
        return false
    end,

    calculate = function(self, card, context)
        
        if context.end_of_round and context.main_eval and not context.blueprint then
            G.E_MANAGER:add_event(Event({
                func = function()
                    local tag = Tag(get_next_tag_key('g_quartz'))
                    add_tag(tag)
                    play_sound('generic1', 0.9, 1.5)
                    card.ability.extra.tags_created = card.ability.extra.tags_created + 1
                    card:juice_up(0.3, 0.5)
                    
                    
                    if card.ability.extra.tags_created >= card.ability.extra.max_tags then
                        card:start_dissolve()
                    end
                    return true
                end
            }))
            return {
                message = "¡Etiqueta!",
                colour = G.C.GREEN
            }
        end
    end,

    
    check_for_unlock = function(self, args)
        if args.type == 'win' then
            
            if G.GAME.selected_back.effect.center.key == 'b_green' and G.GAME.modifiers.kranlaxs_magenta_pinned then
                return true 
            end
        end
        return false
    end
}