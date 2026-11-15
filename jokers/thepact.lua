SMODS.Joker {
    key = 'thepact',
    atlas = 'CustomJokers',
    pos = { x = 09, y = 08 },
    rarity = "kranlaxs_zenith",
    bm_cost = 3,
    cost = 4,
    unlocked = false,
    discovered = false,
    blueprint_compat = false, -- Incompatible con Plano
    config = { extra = { scale = 0, gain = 0.05 } },
    
    check_for_unlock = function(self, args)
        if args.type == 'win' then
            if G.GAME.selected_back.effect.center.key == 'b_kranlaxs_evil_deck' and G.GAME.stake >= 3 then
                return true
            end
        end
        return false
    end,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.gain * 100, card.ability.extra.scale * 100 } }
    end,
    
    in_pool = function(self, args)
        -- Bloqueo por Joker Sagrado
        if G.GAME and G.FUNCS.has_holy_joker and G.FUNCS.has_holy_joker() then 
            return false 
        end
        
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

    add_to_deck = function(self, card, from_debuff)
        G.GAME.discount_percent = (G.GAME.discount_percent or 0) + 100
        for _, area in ipairs({G.shop_jokers, G.shop_booster, G.shop_vouchers}) do
            if area and area.cards then
                for _, c in ipairs(area.cards) do c:set_cost() end
            end
        end
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.GAME.discount_percent = (G.GAME.discount_percent or 0) - 100
        for _, area in ipairs({G.shop_jokers, G.shop_booster, G.shop_vouchers}) do
            if area and area.cards then
                for _, c in ipairs(area.cards) do c:set_cost() end
            end
        end
    end,
    
    calculate = function(self, card, context)
        -- Atrapamos compras normales Y apertura de Booster Packs
        if (context.buying_card or context.open_booster) and not context.blueprint and card.area == G.jokers then
            -- Evita que se active a sí mismo cuando se compra
            if not context.card or context.card ~= card then
                card.ability.extra.scale = card.ability.extra.scale + card.ability.extra.gain
                card.ability.eternal = true 
                
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card:juice_up(0.5, 0.5)
                        return true
                    end
                }))
            end
        end
        
        if context.setting_blind and not context.blueprint then
            if card.ability.extra.scale > 0 then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.2,
                    func = function()
                        G.GAME.blind.chips = math.floor(G.GAME.blind.chips * (1 + card.ability.extra.scale))
                        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                        card:juice_up(0.5, 0.5)
                        play_sound('tarot1')
                        return true
                    end
                }))
            end
        end
    end
}