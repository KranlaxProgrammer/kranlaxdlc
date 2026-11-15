SMODS.Joker{
    key = "rosary",
    config = { extra = {}, holy = true },
    pos = { x = 012, y = 02 }, 
    cost = 8,
    rarity = 3,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    check_for_unlock = function(self, args)
        if args.type == 'win' then
            local bm_opened = G.GAME.kranlaxs_bm_opened
            local reroll1 = G.GAME.used_vouchers and G.GAME.used_vouchers['v_reroll_surplus']
            local reroll2 = G.GAME.used_vouchers and G.GAME.used_vouchers['v_reroll_glut']
            
            -- Gana si el mercado negro no se abrió Y si no compraste ninguno de los dos Vouchers
            if not bm_opened and not reroll1 and not reroll2 then
                return true
            end
        end
        return false
    end,

    set_badges = function(self, card, badges)
        local badge_text = "Holy"
        if G.localization and G.localization.misc and G.localization.misc.dictionary and G.localization.misc.dictionary.k_holy then
            badge_text = G.localization.misc.dictionary.k_holy
        else
            if G.SETTINGS.language == 'es_419' or G.SETTINGS.language == 'es_ES' then
                badge_text = "Sagrada"
            end
        end
        badges[#badges + 1] = create_badge(badge_text, HEX('FFD700'), G.C.WHITE, 1.2)
    end,

    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,

    update = function(self, card, dt)
        if card.area == G.jokers and not card.debuff then
            if G.GAME and G.GAME.kranlaxs_evil_meter then
                G.GAME.kranlaxs_evil_meter = 0
            end
        end
    end
}

if not SMODS.kranlaxs_rosario_reroll_hook then
    local orig_update_reroll_cost = update_reroll_cost
    function update_reroll_cost()
        if orig_update_reroll_cost then orig_update_reroll_cost() end
        if G.GAME and G.GAME.round_resets then
            local count = 0
            if G.jokers and G.jokers.cards then
                for _, j in ipairs(G.jokers.cards) do
                    if j.config.center.key == 'j_kranlaxs_rosario' and not j.debuff then
                        count = count + 1
                    end
                end
            end
            if count > 0 then
                G.GAME.round_resets.reroll_cost = math.max(0, G.GAME.round_resets.reroll_cost - (2 * count))
            end
        end
    end
    SMODS.kranlaxs_rosario_reroll_hook = true
end