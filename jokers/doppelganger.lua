SMODS.Joker{
    key = "doppelganger",
    config = { extra = { copied_joker = 'j_joker' } },
    pos = { x = 5, y = 6 },
    cost = 7,
    rarity = 3,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    check_for_unlock = function(self, args)
        if args and args.type == 'win' then
            if G.GAME and G.GAME.stake == 8 and G.GAME.selected_back and G.GAME.selected_back.effect.center.key == 'b_kranlaxs_week_challenge' then
                return true
            end
        end
        return false
    end,

    loc_vars = function(self, info_queue, card)
        local copied_name = "???"
        
        if card and card.ability and card.ability.extra and card.ability.extra.copied_joker then
            local center = G.P_CENTERS[card.ability.extra.copied_joker]
            if center then
                copied_name = localize{type='name_text', key=center.key, set='Joker'}
            end
        end
        return {vars = {copied_name}}
    end,

    set_ability = function(self, card, initial)
        local valid_jokers = {}
        for k, v in pairs(G.P_CENTERS) do
            -- Solo copia Jokers que tengas Desbloqueados y Descubiertos en tu perfil
            if v.set == 'Joker' and v.blueprint_compat and k ~= 'j_kranlaxs_doppelganger' then
                if v.unlocked and v.discovered then
                    table.insert(valid_jokers, k)
                end
            end
        end
        if #valid_jokers > 0 then
            card.ability.extra.copied_joker = pseudorandom_element(valid_jokers, pseudoseed('doppel_init'))
        else
            -- Respaldo de seguridad por si es una partida nueva al 0%
            card.ability.extra.copied_joker = 'j_joker'
        end
    end,

    update = function(self, card, dt)
        -- Candado de Área: Solo cambia la textura si el Joker está en una run activa (Tienda, Barra o Paquete)
        if card.area and (card.area == G.shop_jokers or card.area == G.jokers or card.area == G.pack_cards) then
            if card.ability and card.ability.extra and card.ability.extra.copied_joker then
                if card.doppel_visual_synced ~= card.ability.extra.copied_joker then
                    local copied_center = G.P_CENTERS[card.ability.extra.copied_joker]
                    if copied_center and card.children.center then
                        local atlas_key = copied_center.atlas or 'Joker'
                        
                        if G.ASSET_ATLAS[atlas_key] then
                            -- 1. Clonar el cuerpo base
                            card.children.center.atlas = G.ASSET_ATLAS[atlas_key]
                            card.children.center:set_sprite_pos(copied_center.pos)
                            
                            -- 2. Clonar el "alma" (Rostro flotante de los Legendarios)
                            if copied_center.soul_pos then
                                if not card.children.floating_sprite then
                                    card.children.floating_sprite = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, G.ASSET_ATLAS[atlas_key], copied_center.soul_pos)
                                    card.children.floating_sprite.role.draw_major = card
                                    card.children.floating_sprite.states.hover.can = false
                                    card.children.floating_sprite.states.click.can = false
                                else
                                    card.children.floating_sprite.atlas = G.ASSET_ATLAS[atlas_key]
                                    card.children.floating_sprite:set_sprite_pos(copied_center.soul_pos)
                                end
                            else
                                -- Si muta de vuelta a un joker normal, destruimos la cara legendaria
                                if card.children.floating_sprite then
                                    card.children.floating_sprite:remove()
                                    card.children.floating_sprite = nil
                                end
                            end
                            
                            card.doppel_visual_synced = card.ability.extra.copied_joker
                        end
                    end
                end
            end
        end
    end,

    calculate = function(self, card, context)
        if not card.custom_dummy or card.custom_dummy.config.center.key ~= card.ability.extra.copied_joker then
            if card.custom_dummy then card.custom_dummy:remove() end
            card.custom_dummy = Card(card.T.x, card.T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, G.P_CENTERS[card.ability.extra.copied_joker])
            card.custom_dummy.states.visible = false
        end

        context.blueprint = (context.blueprint or 0) + 1
        context.blueprint_card = context.blueprint_card or card
        
        local ret = card.custom_dummy:calculate_joker(context)
        
        context.blueprint = context.blueprint - 1
        if context.blueprint == 0 then 
            context.blueprint = nil 
            context.blueprint_card = nil 
        end

        if context.setting_blind and not context.blueprint then
            local valid_jokers = {}
            for k, v in pairs(G.P_CENTERS) do
                -- Mismo filtro aquí para cuando rota de Joker en cada ciega nueva
                if v.set == 'Joker' and v.blueprint_compat and k ~= 'j_kranlaxs_doppelganger' then
                    if v.unlocked and v.discovered then
                        table.insert(valid_jokers, k)
                    end
                end
            end
            
            local new_joker = 'j_joker'
            if #valid_jokers > 0 then
                new_joker = pseudorandom_element(valid_jokers, pseudoseed('doppel_shift' .. G.GAME.round))
            end
            
            card.ability.extra.copied_joker = new_joker
            
            if card.custom_dummy then card.custom_dummy:remove() end
            card.custom_dummy = Card(card.T.x, card.T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, G.P_CENTERS[new_joker])
            card.custom_dummy.states.visible = false

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    card:juice_up(0.5, 0.5)
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Mutación!", colour = G.C.PURPLE})
                    return true
                end
            }))
        end

        return ret
    end,

    remove_from_deck = function(self, card, from_debuff)
        if card.custom_dummy then
            card.custom_dummy:remove()
            card.custom_dummy = nil
        end
    end
}