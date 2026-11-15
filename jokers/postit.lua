SMODS.Joker{
    key = "postit",
    config = { extra = { odds = 4, current_state = "", is_active = false } },
    pos = { x = 10, y = 06 }, 
    display_size = { w = 71, h = 95 },
    cost = 5,
    rarity = 2, 
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    check_for_unlock = function(self, args)
        if args.type == 'win' then
            if G.GAME.selected_back.effect.center.key == 'b_kranlaxs_catalog_deck' and G.GAME.stake >= 8 then return true end
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
        local target_joker = nil
        if G.jokers and G.jokers.cards then
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    -- Busca a la izquierda saltándose otras copias de Post-it
                    for j = i - 1, 1, -1 do
                        if G.jokers.cards[j].config.center.key ~= 'j_kranlaxs_postit' then
                            target_joker = G.jokers.cards[j]
                            break
                        end
                    end
                    break
                end
            end
        end
        
        local is_compat = false
        if target_joker and target_joker.config.center.blueprint_compat then 
            is_compat = true 
        end
        
        local compat_str = is_compat and localize('k_compatible') or localize('k_incompatible')
        
        -- main_end genera la etiqueta visual (verde/roja) nativa del juego
        return {
            vars = {G.GAME and G.GAME.probabilities.normal or 1, card.ability.extra.odds, compat_str},
            main_end = {
                {n=G.UIT.C, config={align="bm", minh=0.4}, nodes={
                    {n=G.UIT.C, config={ref_table=self, align="m", colour=is_compat and G.C.GREEN or G.C.RED, r=0.05, padding=0.06}, nodes={
                        {n=G.UIT.T, config={text=' '..compat_str..' ', colour=G.C.UI.TEXT_LIGHT, scale=0.32*0.8}}
                    }}
                }}
            }
        }
    end,
    
    calculate = function(self, card, context)
        if context.blueprint then return end

        local target_joker = nil
        if G.jokers and G.jokers.cards then
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    -- Busca a la izquierda saltándose otras copias de Post-it
                    for j = i - 1, 1, -1 do
                        if G.jokers.cards[j].config.center.key ~= 'j_kranlaxs_postit' then
                            target_joker = G.jokers.cards[j]
                            break
                        end
                    end
                    break
                end
            end
        end
        
        if target_joker and target_joker.config.center.blueprint_compat then
            
            local hash = tostring(G.GAME.round or 0) .. '_' .. tostring(G.STATE)
            if G.GAME.current_round then
                hash = hash .. '_' .. tostring(G.GAME.current_round.hands_played or 0) .. '_' .. tostring(G.GAME.current_round.discards_used or 0)
            end
            if context.end_of_round then hash = hash .. '_eor' end
            if context.setting_blind then hash = hash .. '_sb' end
            if context.skip_blind then hash = hash .. '_skip' end
            if context.reroll_shop then hash = hash .. '_reroll_' .. tostring(G.GAME.current_round.reroll_cost or 0) end
            
            if card.ability.extra.current_state ~= hash then
                card.ability.extra.current_state = hash
                card.ability.extra.is_active = (pseudorandom('postit') < (G.GAME.probabilities.normal or 1) / card.ability.extra.odds)
            end

            if card.ability.extra.is_active then
                context.blueprint = (context.blueprint or 0) + 1
                context.blueprint_card = context.blueprint_card or card
                
                local ret, ret2, ret3 = target_joker:calculate_joker(context)
                
                context.blueprint = context.blueprint - 1
                if context.blueprint == 0 then
                    context.blueprint = nil
                    context.blueprint_card = nil
                end
                
                if ret then
                    ret.card = card
                    return ret, ret2, ret3
                end
            end
        end
    end
}