SMODS.Joker {
    key = 'investor',
    atlas = 'CustomJokers',
    pos = { x = 2, y = 9 },
    rarity = 3,
    cost = 6,
    unlocked = false,
    discovered = false,
    blueprint_compat = true,
    config = { extra = { multiplier = 0.05, x_mult = 1, saved_money = nil } },
    
    check_for_unlock = function(self, args)
        if args.type == 'win' then
            -- Nivel 14 = Pozo Mostaza (Mustard Stake)
            if G.GAME.selected_back.effect.center.key == 'b_kranlaxs_catalog_deck' and G.GAME.stake >= 14 then
                return true
            end
        end
        return false
    end,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.multiplier, card.ability.extra.x_mult } }
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
    
    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN and card.area == G.jokers and not card.debuff then
            if card.ability.extra.saved_money == nil then
                card.ability.extra.saved_money = G.GAME.dollars or 0
            end
            
            local unbal = SMODS.Mods["kranlaxs"] and SMODS.Mods["kranlaxs"].config.unbalanced_mode
            
            if G.GAME.dollars and G.GAME.dollars > card.ability.extra.saved_money then
                if not unbal then
                    local excess = G.GAME.dollars - card.ability.extra.saved_money
                    card.ability.extra.x_mult = card.ability.extra.x_mult + (excess * card.ability.extra.multiplier)
                    
                    local removed = math.floor(excess / 2)
                    G.GAME.dollars = G.GAME.dollars - removed
                    card.ability.extra.saved_money = G.GAME.dollars
                    
                    if G.HUD_vars and G.HUD_vars.dollars then G.HUD_vars.dollars = G.GAME.dollars end
                    card:juice_up(0.2, 0.2)
                else
                    -- En Desbalance, simplemente ajusta el límite más alto sin robar dinero
                    card.ability.extra.saved_money = G.GAME.dollars
                end
            elseif G.GAME.dollars and G.GAME.dollars < card.ability.extra.saved_money then
                if unbal then
                    -- En Desbalance, otorga X0.01 por cada $1 perdido o gastado
                    local lost = card.ability.extra.saved_money - G.GAME.dollars
                    card.ability.extra.x_mult = card.ability.extra.x_mult + (lost * 0.01)
                    card:juice_up(0.2, 0.2)
                end
                card.ability.extra.saved_money = G.GAME.dollars
            end
        elseif card.area ~= G.jokers then
            card.ability.extra.saved_money = nil
        end
    end,
    
    calculate = function(self, card, context)
        if context.joker_main then
            if card.ability.extra.x_mult > 1 then
                return {
                    message = "X" .. card.ability.extra.x_mult .. " multi",
                    Xmult_mod = card.ability.extra.x_mult,
                    colour = G.C.DARK_EDITION
                }
            end
        end
    end
}