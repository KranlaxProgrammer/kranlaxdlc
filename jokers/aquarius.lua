SMODS.Joker{
    key = "aquarius",
    config = { extra = { round_triggered = 0, ante_triggered = 0, shake_timer = 0 } },
    pos = { x = 1, y = 12 }, 
    display_size = { w = 71, h = 95 },
    cost = 6,
    rarity = 3, 
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',
    is_constellation = true, 

    check_for_unlock = function(self, args)
        if args.type == 'win' then
            if G.GAME.selected_back.effect.center.key == 'b_kranlaxs_dungeondeck' and G.GAME.stake >= 6 then
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
    
    set_badges = function(self, card, badges)
        local badge_text = "Constellation"
        if G.localization and G.localization.misc and G.localization.misc.dictionary and G.localization.misc.dictionary.k_constellation then
            badge_text = G.localization.misc.dictionary.k_constellation
        else
            if G.SETTINGS.language == 'es_419' or G.SETTINGS.language == 'es_ES' then badge_text = "Constelación" end
        end
        badges[#badges + 1] = create_badge(badge_text, HEX('3D266B'), G.C.WHITE, 1.2)
    end,

    loc_vars = function(self, info_queue, card) return {vars = {}} end,

    update = function(self, card, dt)
        if G.STAGE == G.STAGES.RUN and card.area == G.jokers and not card.debuff then
            local unbal = SMODS.Mods["kranlaxs"] and SMODS.Mods["kranlaxs"].config.unbalanced_mode
            local is_active = false
            if unbal then
                is_active = (card.ability.extra.round_triggered ~= G.GAME.round)
            else
                is_active = (card.ability.extra.ante_triggered ~= G.GAME.round_resets.ante)
            end
            
            if is_active then
                card.ability.extra.shake_timer = (card.ability.extra.shake_timer or 0) + dt
                if card.ability.extra.shake_timer > 1.2 then
                    card.ability.extra.shake_timer = 0
                    card:juice_up(0.04, 0.04)
                end
            end
        end
    end,

    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local unbal = SMODS.Mods["kranlaxs"] and SMODS.Mods["kranlaxs"].config.unbalanced_mode
            local can_trigger = false
            
            if unbal then
                if card.ability.extra.round_triggered ~= G.GAME.round then can_trigger = true end
            else
                if card.ability.extra.ante_triggered ~= G.GAME.round_resets.ante then can_trigger = true end
            end

            if can_trigger then
                if unbal then card.ability.extra.round_triggered = G.GAME.round else card.ability.extra.ante_triggered = G.GAME.round_resets.ante end
                
                if context.scoring_hand and #context.scoring_hand > 0 then
                    local target = context.scoring_hand[1]
                    
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            target:set_edition({kranlaxs_underwater = true}, true, true)
                            play_sound('kranlaxs_underwateredition', 1, 1)
                            target:juice_up(0.5, 0.5)
                            return true
                        end
                    }))
                    
                    return {
                        message = "¡Bautizada!",
                        colour = G.C.BLUE,
                        card = card
                    }
                end
            end
        end
    end
}