-- =====================================================================
-- FUNCIONES DEL MENÚ INTERACTIVO DEL CUARZO TRANSPARENTE
-- =====================================================================
if not SMODS.kranlaxs_transparent_menu_hooked then
    -- Opción 1: Remover Edición ($5)
    G.FUNCS.kranlaxs_remove_edition = function(e)
        local target = e.config.ref_table.target
        local was_removed = false

        if target.edition then
            target:set_edition(nil, true)
            was_removed = true
        end

        -- Cierra el menú
        if G.OVERLAY_MENU then G.OVERLAY_MENU:remove(); G.OVERLAY_MENU = nil end

        if was_removed then
            ease_dollars(5)
            card_eval_status_text(target, 'extra', nil, nil, nil, {message = "+$5", colour = G.C.MONEY})
        else
            card_eval_status_text(target, 'extra', nil, nil, nil, {message = "Sin Edición", colour = G.C.RED})
        end
    end

    -- Opción 2: Remover Stickers (Sin recompensa)
    G.FUNCS.kranlaxs_remove_stickers = function(e)
        local target = e.config.ref_table.target
        local was_removed = false

        -- Limpia Vanilla
        if target.ability.eternal or target.ability.perishable or target.ability.rental then
            target.ability.eternal = nil; target.ability.perishable = nil; target.ability.rental = nil
            target.ability.perish_tally = G.GAME.perishable_jokers_tally or 5
            was_removed = true
        end

        -- Limpia SMODS
        if SMODS.Stickers then
            for k, _ in pairs(SMODS.Stickers) do
                if k ~= 'fat' and k ~= 'overweight' and k ~= 'pinned' and target.ability[k] then
                    target.ability[k] = nil
                    was_removed = true
                end
            end
        end

        -- Cierra el menú
        if G.OVERLAY_MENU then G.OVERLAY_MENU:remove(); G.OVERLAY_MENU = nil end

        if was_removed then
            target:set_cost()
            card_eval_status_text(target, 'extra', nil, nil, nil, {message = "Stickers Limpios", colour = G.C.GREEN})
        else
            card_eval_status_text(target, 'extra', nil, nil, nil, {message = "Sin Stickers", colour = G.C.RED})
        end
    end

    -- Opción 3: Remover Sellos ($5)
    G.FUNCS.kranlaxs_remove_seal = function(e)
        local target = e.config.ref_table.target
        local was_removed = false

        if target.seal then
            target:set_seal(nil, true)
            was_removed = true
        end

        -- Cierra el menú
        if G.OVERLAY_MENU then G.OVERLAY_MENU:remove(); G.OVERLAY_MENU = nil end

        if was_removed then
            ease_dollars(5)
            card_eval_status_text(target, 'extra', nil, nil, nil, {message = "+$5", colour = G.C.MONEY})
        else
            card_eval_status_text(target, 'extra', nil, nil, nil, {message = "Sin Sello", colour = G.C.RED})
        end
    end

    SMODS.kranlaxs_transparent_menu_hooked = true
end

SMODS.Consumable {
    key = 'transparentquartz',
    set = 'Quartz',
    pos = { x = 6, y = 0 }, 
    cost = 4,
    unlocked = false, -- ¡Cambiado a false!
    discovered = false,
    unlock_condition = {type = '', extra = ''},
    atlas = 'QuartzConsumables',
    
    can_use = function(self, card)
        local j_high = G.jokers and G.jokers.highlighted and #G.jokers.highlighted or 0
        local h_high = G.hand and G.hand.highlighted and #G.hand.highlighted or 0
        
        if j_high == 1 and h_high == 0 then return true end
        if h_high == 1 and j_high == 0 then return true end
        return false
    end,
    
    use = function(self, card, area, copier)
        local used_card = copier or card
        local target_card = nil
        local is_joker = false

        if G.jokers and G.jokers.highlighted and #G.jokers.highlighted == 1 then
            target_card = G.jokers.highlighted[1]
            is_joker = true
        elseif G.hand and G.hand.highlighted and #G.hand.highlighted == 1 then
            target_card = G.hand.highlighted[1]
            is_joker = false
        end

        if target_card then
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.2,
                func = function()
                    play_sound('tarot1')
                    used_card:juice_up(0.3, 0.5)
                    if is_joker then G.jokers:unhighlight_all() else G.hand:unhighlight_all() end
                    return true
                end
            }))
            
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.1,
                func = function()
                    local t = {n=G.UIT.ROOT, config={align="cm", colour=G.C.CLEAR}, nodes={
                        {n=G.UIT.C, config={align="cm", colour=G.C.BLACK, r=0.1, padding=0.2, outline=1, outline_colour=G.C.WHITE}, nodes={
                            {n=G.UIT.R, config={align="cm", padding=0.2}, nodes={
                                {n=G.UIT.T, config={text="¿Qué deseas remover?", scale=0.5, colour=G.C.WHITE}}
                            }},
                            {n=G.UIT.R, config={align="cm", padding=0.1}, nodes={
                                UIBox_button({button="kranlaxs_remove_edition", label={"Edición"}, colour=G.C.ORANGE, minw=4, ref_table={target=target_card}}),
                            }},
                            {n=G.UIT.R, config={align="cm", padding=0.1}, nodes={
                                UIBox_button({
                                    button=is_joker and "kranlaxs_remove_stickers" or "kranlaxs_remove_seal", 
                                    label={is_joker and "Stickers" or "Sellos"}, 
                                    colour=G.C.BLUE, 
                                    minw=4, 
                                    ref_table={target=target_card}
                                })
                            }}
                        }}
                    }}
                    G.OVERLAY_MENU = UIBox{
                        definition = t,
                        config = {align="cm", offset = {x=0,y=0}, major = G.ROOM_ATTACH}
                    }
                    return true
                end
            }))
        end
    end,

    -- Validación de desbloqueo: Baraja de Mazmorra en Pozo de Platino
    check_for_unlock = function(self, args)
        if args.type == 'win' then
            if G.GAME.selected_back.effect.center.key == 'b_kranlaxs_dungeon_deck' and G.GAME.stake == 'kranlaxs_platinum' then
                return true
            end
        end
        return false
    end
}