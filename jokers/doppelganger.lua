SMODS.Joker{
    key = "doppelganger",
    config = { extra = { copied_joker = 'j_joker', shop_visited = false } },
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
                info_queue[#info_queue+1] = center
            end
        end
        return {vars = {copied_name}}
    end,

    set_ability = function(self, card, initial)
        local valid_jokers = {}
        for k, v in pairs(G.P_CENTERS) do
            if v.set == 'Joker' and v.blueprint_compat and k ~= 'j_kranlaxs_doppelganger' then
                if v.unlocked and v.discovered then
                    if not G.GAME.banned_keys or not G.GAME.banned_keys[k] then
                        table.insert(valid_jokers, k)
                    end
                end
            end
        end
        if #valid_jokers > 0 then
            card.ability.extra.copied_joker = pseudorandom_element(valid_jokers, pseudoseed('doppel_init' .. (G.GAME.round or 1)))
        else
            card.ability.extra.copied_joker = 'j_joker'
        end
    end,

    update = function(self, card, dt)
        
        -- CAMBIO AL ENTRAR A LA TIENDA
        if G.STATE == G.STATES.SHOP then
            if not card.ability.extra.shop_visited then
                card.ability.extra.shop_visited = true
                
                local valid_jokers = {}
                for k, v in pairs(G.P_CENTERS) do
                    if v.set == 'Joker' and v.blueprint_compat and k ~= 'j_kranlaxs_doppelganger' then
                        if v.unlocked and v.discovered then
                            -- Evitar que copie jokers prohibidos por retos
                            if not G.GAME.banned_keys or not G.GAME.banned_keys[k] then
                                table.insert(valid_jokers, k)
                            end
                        end
                    end
                end
                
                local new_joker = 'j_joker'
                if #valid_jokers > 0 then
                    new_joker = pseudorandom_element(valid_jokers, pseudoseed('doppel_shift' .. G.GAME.round))
                end
                
                card.ability.extra.copied_joker = new_joker
                
                -- Se recrea el comodín fantasma para acarrear el nuevo efecto
                if card.custom_dummy then card.custom_dummy:remove() end
                card.custom_dummy = Card(card.T.x, card.T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, G.P_CENTERS[new_joker])
                card.custom_dummy.states.visible = false
                
                card:juice_up(0.5, 0.5)
            end
        else
            card.ability.extra.shop_visited = false
        end

        -- SINCRONIZADOR VISUAL (Reemplaza el sprite del Doppelganger por el del clonado)
        if card.ability and card.ability.extra and card.ability.extra.copied_joker then
            if card.doppel_visual_synced ~= card.ability.extra.copied_joker then
                local copied_center = G.P_CENTERS[card.ability.extra.copied_joker]
                if copied_center and card.children.center then
                    local atlas_key = copied_center.atlas or 'Joker'
                    if G.ASSET_ATLAS[atlas_key] then
                        card.children.center.atlas = G.ASSET_ATLAS[atlas_key]
                        card.children.center:set_sprite_pos(copied_center.pos)
                        card.doppel_visual_synced = card.ability.extra.copied_joker
                    end
                end
            end
        end
    end,

    calculate = function(self, card, context)
        -- Prevención de crasheos: si el fantasma no existe, se fabrica sobre la marcha
        if not card.custom_dummy or card.custom_dummy.config.center.key ~= card.ability.extra.copied_joker then
            if card.custom_dummy then card.custom_dummy:remove() end
            card.custom_dummy = Card(card.T.x, card.T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, G.P_CENTERS[card.ability.extra.copied_joker])
            card.custom_dummy.states.visible = false
        end

        -- Le decimos al fantasma que él forma parte de la zona del Doppelganger
        card.custom_dummy.area = card.area

        context.blueprint = (context.blueprint or 0) + 1
        context.blueprint_card = context.blueprint_card or card
        
        -- El fantasma efectúa el trabajo sucio por el Doppelganger
        local ret = card.custom_dummy:calculate_joker(context)
        
        context.blueprint = context.blueprint - 1
        if context.blueprint == 0 then 
            context.blueprint = nil 
            context.blueprint_card = nil 
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
