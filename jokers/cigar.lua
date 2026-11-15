SMODS.Joker{
    key = "cigar",
    config = { extra = { remaining = 3 } },
    pos = { x = 0, y = 0 }, 
    cost = 5,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = false,
    atlas = 'CustomJokers',
    
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.remaining } }
    end,

    calculate = function(self, card, context)
        -- Si se vende antes de que se agoten las cargas
        if context.selling_self and not context.blueprint then
            if card.ability.extra.remaining > 0 then
                G.GAME.cigarro_penalty = true 
            end
            return
        end

        if context.setting_blind and not context.blueprint then
            -- Añadida la comprobación para asegurar que no gaste cargas en un jefe que YA esté deshabilitado
            if G.GAME.blind and G.GAME.blind.boss and not G.GAME.blind.disabled then
                card.ability.extra.remaining = card.ability.extra.remaining - 1
                
                -- CORRECCIÓN: La función nativa en Balatro es disable(), no disable_boss()
                G.GAME.blind:disable()
                
                if card.ability.extra.remaining <= 0 then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound('tarot1')
                            card:start_dissolve()
                            G.GAME.cigarro_penalty = true 
                            return true
                        end
                    }))
                    return {
                        message = '¡Agotado!',
                        colour = G.C.RED
                    }
                else
                    return {
                        message = '¡Bloqueado! (' .. card.ability.extra.remaining .. ')',
                        colour = G.C.GREEN
                    }
                end
            end
        end
    end
}

-- Alterar la probabilidad para que salga 4 veces más si el castigo está activo
local id = 'j_kranlaxs_cigar'
if SMODS.Centers[id] then
    local orig_get_weight = SMODS.Centers[id].get_weight
    SMODS.Centers[id].get_weight = function(self)
        if G.GAME and G.GAME.cigarro_penalty then
            return (G.GAME.edition_rate or 1) * self.weight * 4
        end
        if orig_get_weight then return orig_get_weight(self) end
        return (G.GAME.edition_rate or 1) * self.weight
    end
end

if not SMODS.kranlaxs_cigar_hooks then
    -- Hook por si se destruye (Locura, oveja, hex)
    local orig_start_dissolve = Card.start_dissolve
    function Card:start_dissolve(color, silent, time, no_juice)
        if self.config and self.config.center and self.config.center.key == 'j_kranlaxs_cigar' then
            if self.ability and self.ability.extra and self.ability.extra.remaining > 0 then
                if G.GAME then G.GAME.cigarro_penalty = true end
            end
        end
        if orig_start_dissolve then orig_start_dissolve(self, color, silent, time, no_juice) end
    end

    local alias_set_blind = Blind.set_blind
    function Blind.set_blind(self, blind, reset, silent)
        alias_set_blind(self, blind, reset, silent)
        if G.GAME and G.GAME.cigarro_penalty then
            self.chips = math.floor(self.chips * 1.3)
            self.chip_text = number_format(self.chips)
        end
    end
    SMODS.kranlaxs_cigar_hooks = true
end