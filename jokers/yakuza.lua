if not SMODS.kranlaxs_yakuza_hook then
    local orig_ease_dollars = ease_dollars
    function ease_dollars(mod, instant)
        if mod < 0 and G.jokers and G.jokers.cards then
            local yakuza_cards = {}
            for _, v in ipairs(G.jokers.cards) do
                if v.config.center.key == 'j_kranlaxs_yakuza' and not v.debuff then
                    table.insert(yakuza_cards, v)
                end
            end
            
            orig_ease_dollars(mod, instant)
            
            if #yakuza_cards > 0 then
                for _, card in ipairs(yakuza_cards) do
                    card.ability.extra.spent = card.ability.extra.spent + math.abs(mod)
                    local upgrades = 0
                    
                    while card.ability.extra.spent >= card.ability.extra.threshold do
                        card.ability.extra.spent = card.ability.extra.spent - card.ability.extra.threshold
                        card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.gain
                        upgrades = upgrades + 1
                    end
                    
                    if upgrades > 0 then
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after', delay = 0.2,
                            func = function()
                                card:juice_up(0.5, 0.5)
                                -- Sonido corregido a uno existente en el motor
                                play_sound('tarot1')
                                card_eval_status_text(card, 'extra', nil, nil, nil, {message = "X"..card.ability.extra.x_mult.." Mult!", colour = G.C.RED})
                                return true
                            end
                        }))
                    end
                end
            end
            return
        end
        orig_ease_dollars(mod, instant)
    end
    SMODS.kranlaxs_yakuza_hook = true
end

SMODS.Joker{
    key = "yakuza",
    config = { extra = { x_mult = 1, spent = 0, threshold = 10, gain = 0.2 } },
    pos = { x = 10, y = 2 }, 
    display_size = { w = 71, h = 95 },
    cost = 5,
    rarity = 2, 
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    check_for_unlock = function(self, args)
        if args.type == 'win' then
            -- Nivel 16 = Pozo Cósmico
            if G.GAME.selected_back.effect.center.key == 'b_kranlaxs_catalog_deck' and G.GAME.stake >= 16 then
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
    
    -- Blindaje añadido: Lee valores predeterminados si la carta aún no se genera en la colección
    loc_vars = function(self, info_queue, card)
        local gain = card and card.ability.extra.gain or self.config.extra.gain
        local threshold = card and card.ability.extra.threshold or self.config.extra.threshold
        local spent = card and card.ability.extra.spent or self.config.extra.spent
        local x_mult = card and card.ability.extra.x_mult or self.config.extra.x_mult
        return {vars = {gain, threshold, spent, x_mult}}
    end,
    
    calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.x_mult > 1 then
            return {
                message = "X" .. card.ability.extra.x_mult .. " Mult",
                Xmult_mod = card.ability.extra.x_mult,
                colour = G.C.RED
            }
        end
    end
}