SMODS.Joker{
    key = "grapesoda",
    config = { extra = {} },
    pos = { x = 2, y = 6 },
    display_size = { w = 71, h = 95 },
    cost = 6,
    rarity = 3,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    
    -- Empieza bloqueado
    unlocked = false,
    discovered = false,
    unlock_condition = {type = '', extra = ''},
    
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true, ["kranlaxs_food"] = true },

    check_for_unlock = function(self, args)
        if args.type == 'win' then
            if G.GAME.selected_back.effect.center.key == 'b_kranlaxs_space_deck' and G.GAME.stake == 'kranlaxs_magenta' then
                return true
            end
        end
        return false
    end,

    in_pool = function(self, args)
        -- Si el juego apenas está cargando y no hay barra de jokers, permitir que exista en la pool
        if not G.jokers or not G.jokers.cards then return true end
        
        -- Escanear tu barra de Jokers
        for _, v in ipairs(G.jokers.cards) do
            -- Si ya tienes una copia exacta de esta carta, bloquear su aparición
            if v.config.center.key == 'j_kranlaxs_' .. self.key then
                return false 
            end
        end
        
        return true
    end,
    
    calculate = function(self, card, context)
        -- Generar Espectral Negativa al Venderse
        if context.selling_self and not context.blueprint then
            -- Como es negativa, ignora el límite de consumibles, así que la generamos de inmediato
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound('timpani')
                    SMODS.add_card({ set = 'Spectral', edition = 'e_negative' })
                    return true
                end
            }))
            return {
                message = localize('k_plus_spectral'),
                colour = G.C.SECONDARY_SET.Spectral
            }
        end
    end
}