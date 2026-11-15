SMODS.Joker{
    key = 'overpopulation',
    config = { extra = { mult = 2, base_faces = 12, current_mult = 0 } },
    rarity = 1,
    atlas = 'CustomJokers',
    pos = { x = 5, y = 7 },
    cost = 6,
    blueprint_compat = true,
    
    
    unlocked = false,
    discovered = false,
    unlock_condition = {type = '', extra = ''},

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

    check_for_unlock = function(self, args)
        if args.type == 'win' then
            
            if G.GAME.selected_back.effect.center.key == 'b_kranlaxs_space_deck' and G.GAME.stake == 'green' then
                return true
            end
        end
        return false
    end,
    
    
    update = function(self, card, dt)
        if G.playing_cards then
            local faces = 0
            for _, v in ipairs(G.playing_cards) do
                
                
                if v:is_face() then
                    faces = faces + 1
                end
            end
            
            local extra = math.max(0, faces - card.ability.extra.base_faces)
            
            card.ability.extra.current_mult = extra * card.ability.extra.mult
        end
    end,
    
    loc_vars = function(self, info_queue, card)
        
        return { vars = { card.ability.extra.mult, card.ability.extra.base_faces, card.ability.extra.current_mult } }
    end,
    
    calculate = function(self, card, context)
        if context.joker_main then
            if card.ability.extra.current_mult > 0 then
                return {
                    mult_mod = card.ability.extra.current_mult,
                    message = localize{type='variable',key='a_mult',vars={card.ability.extra.current_mult}}
                }
            end
        end
    end
}