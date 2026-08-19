SMODS.Joker{
    key = 'overpopulation',
    config = { extra = { mult = 2, base_faces = 12, current_mult = 0 } },
    rarity = 2,
    atlas = 'CustomJokers',
    pos = { x = 5, y = 7 },
    cost = 6,
    blueprint_compat = true,
    
    -- Empieza bloqueado
    unlocked = false,
    discovered = false,
    unlock_condition = {type = '', extra = ''},

    check_for_unlock = function(self, args)
        if args.type == 'win' then
            -- El pozo verde usa el ID base 'green'
            if G.GAME.selected_back.effect.center.key == 'b_kranlaxs_space_deck' and G.GAME.stake == 'green' then
                return true
            end
        end
        return false
    end,
    
    -- El motor evalúa esto en segundo plano, sin saturar la interfaz
    update = function(self, card, dt)
        if G.playing_cards then
            local faces = 0
            for _, v in ipairs(G.playing_cards) do
                -- v:is_face() es el método nativo y blindado de Balatro.
                -- ¡Además, le da sinergia automática con el Joker Pareidolia!
                if v:is_face() then
                    faces = faces + 1
                end
            end
            
            local extra = math.max(0, faces - card.ability.extra.base_faces)
            -- Guardamos el resultado en la memoria del Joker
            card.ability.extra.current_mult = extra * card.ability.extra.mult
        end
    end,
    
    loc_vars = function(self, info_queue, card)
        -- Simplemente leemos el valor que ya calculó "update" de forma ultrarrápida
        return { vars = { card.ability.extra.mult, card.ability.extra.base_faces, card.ability.extra.current_mult } }
    end,
    
    calculate = function(self, card, context)
        if context.joker_main then
            if card.ability.extra.current_mult > 0 then
                return {
                    mult_mod = card.ability.extra.current_mult,
                    message = localize{type='variable',key='a_mult',vars={card.ability.extra.current_mult}}
                }
            end
        end
    end
}