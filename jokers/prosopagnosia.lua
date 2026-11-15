SMODS.Joker{
    key = "prosopagnosia",
    config = { extra = { x_mult = 1.5 } },
    pos = { x = 012, y = 05 }, 
    display_size = { w = 71, h = 95 },
    cost = 8,
    rarity = 3, 
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',

    check_for_unlock = function(self, args)
        if args.type == 'win' then
            -- Nivel 16 = Pozo Cósmico (Ajusta el número si tu ID es diferente)
            if G.GAME.stake >= 16 then
                -- La variable 'kranlaxs_face_played_this_run' se registra gracias a tu Contador Descarado
                if not G.GAME.kranlaxs_face_played_this_run then
                    return true
                end
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
        local x_m = unbal and 2 or card.ability.extra.x_mult
        return {vars = {x_m}}
    end,

    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN and card.area == G.jokers and not card.debuff then
            if G.playing_cards then
                for _, v in ipairs(G.playing_cards) do
                    if v.base and v:is_face() and not v.debuff then
                        v:set_debuff(true)
                    end
                end
            end
        end
    end,

    remove_from_deck = function(self, card, from_debuff)
        if G.playing_cards then
            for _, v in ipairs(G.playing_cards) do
                if v.base and v:is_face() then
                    v.debuff = false
                    v:set_debuff() 
                end
            end
        end
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if not context.other_card:is_face() then
                local unbal = SMODS.Mods["kranlaxs"] and SMODS.Mods["kranlaxs"].config.unbalanced_mode
                local x_m = unbal and 2 or card.ability.extra.x_mult
                return {
                    x_mult = x_m,
                    colour = G.C.RED,
                    card = card
                }
            end
        end
    end
}