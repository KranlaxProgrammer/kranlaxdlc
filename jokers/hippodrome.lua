SMODS.Joker{
    key = "hippodrome",
    config = { extra = { x_mult = 1, current_time = 0 } },
    pos = { x = 10, y = 09 }, 
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
        if G.GAME and G.GAME.hands and G.GAME.hands['Flush'] and G.GAME.hands['Flush'].played >= 20 then return true end
        return false
    end,

    locked_loc_vars = function(self, info_queue, card)
        local flushes = (G.GAME and G.GAME.hands and G.GAME.hands['Flush']) and G.GAME.hands['Flush'].played or 0
        return { vars = { flushes } }
    end,

    loc_vars = function(self, info_queue, card)
        local flushes = (G.GAME and G.GAME.hands and G.GAME.hands['Flush']) and G.GAME.hands['Flush'].played or 0
        local x_mult = card and card.ability and card.ability.extra and card.ability.extra.x_mult or self.config.extra.x_mult
        local time_sec = math.floor(card and card.ability.extra.current_time or self.config.extra.current_time)
        return {vars = {flushes, x_mult, time_sec}}
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
        if G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.DRAW_TO_HAND or G.STATE == G.STATES.PLAY_TAROT then
            card.ability.extra.current_time = (card.ability.extra.current_time or 0) + (dt / G.SETTINGS.GAMESPEED)
        end
    end,

    calculate = function(self, card, context)
        if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
            local time = card.ability.extra.current_time
            local gain = 0
            
            -- FIX: Tiempos más exigentes
            if time < 15 then gain = 0.75
            elseif time < 30 then gain = 0.40
            elseif time < 60 then gain = 0.20
            else gain = 0.10 end

            card.ability.extra.x_mult = card.ability.extra.x_mult + gain
            card.ability.extra.current_time = 0 
            
            return { message = "+X" .. gain .. "!", colour = G.C.RED, card = card }
        end
        
        if context.joker_main and card.ability.extra.x_mult > 1 then
            return {
                message = "X" .. card.ability.extra.x_mult .. " Mult",
                Xmult_mod = card.ability.extra.x_mult,
                colour = G.C.RED
            }
        end
    end
}