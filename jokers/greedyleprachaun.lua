local sug = SMODS.Mods["kranlaxs"].config.suggestive_sprites
SMODS.Joker{ 
    key = "greedyleprachaun",
    config = { extra = { card_draw = 3 } },
    pos = { x = 7, y = 0 },
    display_size = { w = 71, h = 95 },
    cost = 5,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },
    in_pool = function(self, args)
        if not G.jokers or not G.jokers.cards then return true end
        for _, v in ipairs(G.jokers.cards) do
            if v.config.center.key == 'j_kranlaxs_' .. self.key then return false end
        end
        return true
    end,
    loc_vars = function(self, info_queue, card) return {vars = {card.ability.extra.card_draw}} end,
    set_ability = function(self, card, initial)
        if initial and G.STAGE == G.STAGES.RUN then card:set_perishable(true) end
    end,
    
    calculate = function(self, card, context)
        -- Ojo: Verificamos que discards_used sea 0 (primer descarte de la ronda)
        if context.pre_discard and G.GAME.current_round.discards_used == 0 then
            
            local state_changed = false
            
            -- Añadimos un evento condicional que se queda vigilando en el fondo
            G.E_MANAGER:add_event(Event({
                trigger = 'condition',
                condition = function()
                    -- Detectamos cuando el juego entra en la fase de descartar/robar
                    if G.STATE ~= G.STATES.SELECTING_HAND then
                        state_changed = true
                    end
                    -- Esperamos pacientemente a que termine y nos devuelva el control
                    return state_changed and G.STATE == G.STATES.SELECTING_HAND
                end,
                func = function()
                    -- ¡Ahora sí, forzamos el robo extra por encima del límite!
                    SMODS.draw_cards(card.ability.extra.card_draw)
                    return true
                end
            }))
            
            return {
                message = "+" .. card.ability.extra.card_draw .. " Cartas",
                colour = G.C.CHIPS,
                card = card
            }
        end
    end
}