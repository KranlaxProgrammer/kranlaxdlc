SMODS.Joker{
    key = "tagger",
    config = { extra = { mult = 0, mult_mod = 5 } },
    pos = { x = 0, y = 7 }, 
    display_size = { w = 71, h = 95 },
    cost = 5,
    rarity = 2, 
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',

    check_for_unlock = function(self, args)
        if G.GAME and G.GAME.used_vouchers then
            if G.GAME.used_vouchers['v_clearance_sale'] and G.GAME.used_vouchers['v_liquidation'] then
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
        local unbal = SMODS.Mods["kranlaxs"] and SMODS.Mods["kranlaxs"].config.unbalanced_mode
        local m_mod = unbal and 20 or card.ability.extra.mult_mod
        return { vars = { m_mod, card.ability.extra.mult } }
    end,

    calculate = function(self, card, context)
        -- Escala únicamente cuando se añade una etiqueta nueva en partida
        if context.tag_added and not context.blueprint then
            local unbal = SMODS.Mods["kranlaxs"] and SMODS.Mods["kranlaxs"].config.unbalanced_mode
            local m_mod = unbal and 20 or card.ability.extra.mult_mod
            
            card.ability.extra.mult = card.ability.extra.mult + m_mod
            
            return {
                message = "+" .. tostring(m_mod) .. " Mult",
                colour = G.C.MULT,
                card = card
            }
        end

        if context.joker_main and card.ability.extra.mult > 0 then
            return {
                message = localize{type='variable', key='a_mult', vars={card.ability.extra.mult}},
                mult_mod = card.ability.extra.mult,
                colour = G.C.MULT
            }
        end
    end
}