SMODS.Joker{
    key = "galletas",
    config = { extra = { chips = 200, loss = 20, time_added = 0, ready_time = 120, is_ready = false } },
    pos = { x = 0, y = 0 }, 
    display_size = { w = 71, h = 95 },
    cost = 4,
    rarity = 1, 
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',

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
    
    add_to_deck = function(self, card, from_debuff)
        if card.ability.extra.time_added == 0 then
            card.ability.extra.time_added = os.time()
        end
    end,

    update = function(self, card, dt)
        if card.ability.extra.time_added > 0 and not card.ability.extra.is_ready then
            if (os.time() - card.ability.extra.time_added) >= card.ability.extra.ready_time then
                card.ability.extra.is_ready = true
                
                if card.children.center then
                    card.children.center:set_sprite_pos({x = 1, y = 0}) 
                end

                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.2,
                    func = function()
                        -- SE CORRIGIÓ EL NOMBRE DEL SONIDO AQUÍ
                        play_sound('kranlaxs_bell') 
                        card:juice_up(0.6, 0.6)
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = "DING!", colour = G.C.ORANGE})
                        return true
                    end
                }))
            end
        end
    end,

    loc_vars = function(self, info_queue, card)
        if card.ability.extra.is_ready then
            return {key = 'j_kranlaxs_galletas_ready', vars = {card.ability.extra.chips, card.ability.extra.loss}}
        else
            return {key = 'j_kranlaxs_galletas', vars = {}}
        end
    end,

    calculate = function(self, card, context)
        -- Esto previene que Blueprint (Plano) actúe si el temporizador sigue activo
        if not card.ability.extra.is_ready then return end

        if context.joker_main then
            if card.ability.extra.chips > 0 then
                return {
                    message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
                    chip_mod = card.ability.extra.chips,
                    colour = G.C.CHIPS
                }
            end
        end

        if context.after and context.cardarea == G.jokers and not context.blueprint then
            card.ability.extra.chips = card.ability.extra.chips - card.ability.extra.loss
            if card.ability.extra.chips <= 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.collide.can = false
                        card.states.drag.can = false
                        card:start_dissolve()
                        return true
                    end
                }))
                return { message = '¡Comidas!', colour = G.C.CHIPS }
            else
                return { message = '-' .. card.ability.extra.loss, colour = G.C.CHIPS }
            end
        end
    end
}