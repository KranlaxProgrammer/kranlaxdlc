SMODS.Joker{
    key = "tribaltattoo",
    config = { extra = { perma_gain = 4 } },
    pos = { x = 10, y = 04 }, 
    display_size = { w = 71, h = 95 },
    cost = 8,
    rarity = 3, 
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    check_for_unlock = function(self, args)
        if args.type == 'win' then
            -- Nivel 2 = Pozo Azul
            if G.GAME.selected_back.effect.center.key == 'b_kranlaxs_dungeon_deck' and G.GAME.stake >= 2 then
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
        local gain = unbal and 8 or card.ability.extra.perma_gain
        return {vars = {gain}}
    end,

    calculate = function(self, card, context)
        -- FIX: Movido a context.before para que el +Mult cuente en la mano actual
        if context.before and not context.blueprint then
            local unbal = SMODS.Mods["kranlaxs"] and SMODS.Mods["kranlaxs"].config.unbalanced_mode
            local gain = unbal and 8 or card.ability.extra.perma_gain
            
            local triggered = false
            for i = 1, #context.scoring_hand do
                local target = context.scoring_hand[i]
                target.ability.perma_mult = (target.ability.perma_mult or 0) + gain
                
                G.E_MANAGER:add_event(Event({
                    func = function()
                        target:juice_up(0.5, 0.5)
                        card_eval_status_text(target, 'extra', nil, nil, nil, {message = "+" .. gain .. " Perm!", colour = G.C.MULT})
                        return true
                    end
                }))
                triggered = true
            end
            
            if triggered then
                return {
                    message = "¡Tatuadas!",
                    colour = G.C.MULT,
                    card = card
                }
            end
        end
    end
}