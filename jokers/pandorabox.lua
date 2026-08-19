SMODS.Joker{
    key = "pandorabox",
    config = { extra = {} },
    pos = { x = 4, y = 6 },
    display_size = { w = 71, h = 95 },
    cost = 20,
    rarity = 4, -- Legendary
    blueprint_compat = false, -- ¡Hecho! Ya no se puede copiar
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    in_pool = function(self, args)
        if not args then return true end
        -- Excluido de la tienda y paquetes regulares (Legendario)
        if args.source == 'sho' or args.source == 'buf' then return false end
        return true
    end,
    
    calculate = function(self, card, context)
        -- Candado de Blueprint: Solo se activa si es la carta original y es al final de una Boss Blind
        if context.end_of_round and context.main_eval and G.GAME.blind.boss and not context.blueprint then
            
            local current_deck = G.GAME.selected_back.effect.center.key
            local joker_to_create = nil
            local seed = pseudoseed('pandora_box' .. G.GAME.round_resets.ante)
            
            -- Asignación dependiendo del mazo
            if current_deck == 'b_red' then joker_to_create = 'j_burnt'
            elseif current_deck == 'b_blue' then joker_to_create = 'j_card_sharp'
            elseif current_deck == 'b_yellow' then joker_to_create = 'j_chaos'
            elseif current_deck == 'b_green' then joker_to_create = pseudorandom_element({'j_delayed_grat', 'j_rocket', 'j_golden', 'j_satellite'}, seed)
            elseif current_deck == 'b_black' then joker_to_create = 'j_stencil'
            elseif current_deck == 'b_magic' then joker_to_create = 'j_fortune_teller'
            elseif current_deck == 'b_nebula' then joker_to_create = 'j_kranlaxs_telescope'
            elseif current_deck == 'b_ghost' then joker_to_create = pseudorandom_element({'j_perkeo', 'j_kranlaxs_mandalajoker'}, seed)
            elseif current_deck == 'b_abandoned' then joker_to_create = 'j_kranlaxs_facelessaccountant'
            elseif current_deck == 'b_zodiac' then joker_to_create = 'j_kranlaxs_Cashback' -- Minúscula corregida
            elseif current_deck == 'b_checkered' then joker_to_create = pseudorandom_element({'j_bloodstone', 'j_arrowhead'}, seed)
            elseif current_deck == 'b_painted' then joker_to_create = 'j_obelisk'
            elseif current_deck == 'b_anaglyph' then joker_to_create = 'j_diet_cola'
            elseif current_deck == 'b_plasma' then joker_to_create = 'j_stuntman'
            elseif current_deck == 'b_erratic' then joker_to_create = 'j_kranlaxs_nft'
            elseif current_deck == 'b_kranlaxs_chaos_deck' then
                -- EL NUEVO MAZO CAÓTICO: Un Joker 100% Aleatorio (Respeta Raras, Comunes, etc.)
                local random_pool = pseudorandom_element(G.P_CENTER_POOLS.Joker, seed)
                joker_to_create = random_pool.key
            else
                -- Fallback: Si usas un mazo moddeado que no está en la lista, da Blueprint
                joker_to_create = 'j_blueprint' 
            end
            
            -- Si definimos un Joker y hay espacio en la barra
            if joker_to_create and (#G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit) then
                G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                
                G.E_MANAGER:add_event(Event({
                    func = function()
                        -- SMODS.add_card crea el Joker forzadamente sin importar si está bloqueado o no
                        SMODS.add_card({ set = 'Joker', key = joker_to_create })
                        G.GAME.joker_buffer = 0
                        return true
                    end
                }))
                
                return {
                    message = "Useful Joker!",
                    colour = G.C.BLUE,
                    card = card
                }
            end
        end
    end
}