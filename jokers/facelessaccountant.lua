if not SMODS.kranlaxs_faceless_hooked then
    local original_evaluate_play = G.FUNCS.evaluate_play
    G.FUNCS.evaluate_play = function(e)
        if G.play and G.play.cards then
            for _, v in ipairs(G.play.cards) do
                if v:is_face() then
                    G.GAME.kranlaxs_face_played_this_run = true
                end
            end
        end
        original_evaluate_play(e)
    end
    SMODS.kranlaxs_faceless_hooked = true
end

SMODS.Joker{
    key = "facelessaccountant",
    config = {
        extra = {
            jokermultichips = 1,
            target_id = 2,
            target_name = '2'
        }
    },
    pos = { x = 2, y = 0 },
    display_size = { w = 71, h = 95 },
    cost = 10,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_mycustom_jokers"] = true },

    check_for_unlock = function(self, args)
        if args and args.type == 'win' then
            if not G.GAME.kranlaxs_face_played_this_run then
                local has_face = false
                if G.playing_cards then
                    for _, v in ipairs(G.playing_cards) do
                        if v:is_face() then
                            has_face = true
                            break
                        end
                    end
                end
                
                if has_face then
                    return true
                end
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
        return {vars = {card.ability.extra.jokermultichips, localize(card.ability.extra.target_name, 'ranks')}}
    end,
    
    set_ability = function(self, card, initial)
        if initial then
            local valid_ids = {2, 3, 4, 5, 6, 7, 8, 9, 10, 14}
            local valid_names = {'2', '3', '4', '5', '6', '7', '8', '9', '10', 'Ace'}
            local idx = pseudorandom('faceless_init', 1, #valid_ids)
            
            card.ability.extra.target_id = valid_ids[idx]
            card.ability.extra.target_name = valid_names[idx]
        end
    end,
    
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            local valid_ids = {2, 3, 4, 5, 6, 7, 8, 9, 10, 14}
            local valid_names = {'2', '3', '4', '5', '6', '7', '8', '9', '10', 'Ace'}
            local idx = pseudorandom('faceless_blind', 1, #valid_ids)
            
            card.ability.extra.target_id = valid_ids[idx]
            card.ability.extra.target_name = valid_names[idx]
            
            return {
                message = localize(card.ability.extra.target_name, 'ranks'),
                colour = G.C.BLUE
            }
        end

        if context.individual and context.cardarea == G.play then
            if context.other_card:get_id() == card.ability.extra.target_id then
                card.ability.extra.jokermultichips = card.ability.extra.jokermultichips + 0.1
                return {
                    extra = {focus = card, message = 'Upgrade!'},
                    card = card,
                    colour = G.C.CHIPS
                }
            end
        end

        if context.joker_main then
            if card.ability.extra.jokermultichips > 1 then
                return {
                    message = 'X' .. card.ability.extra.jokermultichips,
                    x_chips = card.ability.extra.jokermultichips,
                    colour = G.C.CHIPS
                }
            end
        end
    end
}