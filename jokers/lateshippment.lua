SMODS.Joker{
    key = "lateshippment",
    config = { extra = { retrigg = 0 } },
    pos = { x = 1, y = 5 },
    display_size = { w = 71, h = 95 },
    cost = 5,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    
    unlocked = false,
    discovered = false,
    unlock_condition = {type = '', extra = ''},
    
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    check_for_unlock = function(self, args)
        if args.type == 'win' then
            if G.GAME.selected_back.effect.center.key == 'b_kranlaxs_space_deck' and G.GAME.stake == 'orange' then
                return true
            end
        end
        return false
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
    
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.retrigg}}
    end,
    
    calculate = function(self, card, context)
        
        if context.repetition and context.cardarea == G.play then
            if card.ability.extra.retrigg > 0 then
                return {
                    message = localize('k_again_ex'),
                    repetitions = card.ability.extra.retrigg,
                    card = card
                }
            end
        end
        
        
        if context.after and not context.blueprint then
            local hands_played = G.GAME.current_round.hands_played
            return {
                message = "Guardadas: " .. hands_played,
                colour = G.C.BLUE
            }
        end
        
        
        if context.end_of_round and context.main_eval and not context.blueprint then
            local hands_played = G.GAME.current_round.hands_played
            card.ability.extra.retrigg = hands_played
            
            return {
                message = "¡" .. hands_played .. " Listas!",
                colour = G.C.BLUE
            }
        end
    end
}