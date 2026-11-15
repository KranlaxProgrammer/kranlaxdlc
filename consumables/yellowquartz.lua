-- Helper para determinar el comodín basado en porcentajes y el Ante actual
local function get_topacio_joker()
    local r1, r2, r3, rz, r4 = {}, {}, {}, {}, {}
    for k, v in pairs(G.P_CENTERS) do
        if v.set == 'Joker' and not v.no_pool then
            if v.rarity == 1 then table.insert(r1, k)
            elseif v.rarity == 2 then table.insert(r2, k)
            elseif v.rarity == 3 then table.insert(r3, k)
            elseif v.rarity == 'kranlaxs_zenith' then table.insert(rz, k)
            elseif v.rarity == 4 or v.rarity == 'Legendary' then table.insert(r4, k)
            end
        end
    end
    
    -- Prevención de errores por si algún mod borró rarezas
    if #rz == 0 then rz = r4 end
    if #r4 == 0 then r4 = r3 end
    if #r3 == 0 then r3 = r2 end
    if #r2 == 0 then r2 = r1 end
    
    local ante = G.GAME and G.GAME.round_resets and G.GAME.round_resets.ante or 1
    local roll = math.random()
    local pool = r1
    
    if ante <= 7 then
        -- <= Ante 7: 55% Común, 30% Inusual, 15% Raro
        if roll < 0.55 then pool = r1
        elseif roll < 0.85 then pool = r2
        else pool = r3 end
    else
        -- > Ante 7: 55% Raro, 30% Zenith, 15% Legendario
        if roll < 0.55 then pool = r3
        elseif roll < 0.85 then pool = rz
        else pool = r4 end
    end
    
    if #pool > 0 then
        return pool[math.random(1, #pool)]
    end
    return 'j_joker'
end

SMODS.Consumable {
    key = 'yellowquartz',
    set = 'Quartz',
    pos = { x = 9, y = 0 }, 
    cost = 6,
    unlocked = false, 
    discovered = false,
    unlock_condition = {type = '', extra = ''},
    atlas = 'QuartzConsumables',
    config = { extra = { target_joker = nil } }, 

    in_pool = function(self, args)
        if SMODS.showman and SMODS.showman('c_kranlaxs_' .. self.key) then return true end
        if not G.consumeables or not G.consumeables.cards then return true end
        for _, v in ipairs(G.consumeables.cards) do
            if v.config.center.key == 'c_kranlaxs_' .. self.key then return false end
        end
        return true
    end,

    set_ability = function(self, card, initial, delay_sprites)
        if initial then
            card.ability.extra.target_joker = get_topacio_joker()
        end
    end,

    loc_vars = function(self, info_queue, card)
        local j_key = card.ability.extra.target_joker
        local j_name = '?'
        
        if j_key and G.P_CENTERS[j_key] then
            j_name = localize{type = 'name_text', key = j_key, set = 'Joker'}
            info_queue[#info_queue+1] = G.P_CENTERS[j_key]
        end
        return {vars = {j_name}}
    end,

    can_use = function(self, card)
        return G.jokers and #G.jokers.cards < G.jokers.config.card_limit
    end,

    use = function(self, card, area, copier)
        local used_card = copier or card
        local j_key = card.ability.extra.target_joker

        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.4,
            func = function()
                play_sound('timpani')
                used_card:juice_up(0.3, 0.5)
                return true
            end
        }))

        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.4,
            func = function()
                local new_card = create_card('Joker', G.jokers, nil, nil, nil, nil, j_key, 'y_quartz')
                new_card:add_to_deck()
                G.jokers:emplace(new_card)
                return true
            end
        }))
    end,

    calculate = function(self, card, context)
        if context.end_of_round and not context.blueprint then
            card.ability.extra.target_joker = get_topacio_joker()
            return {
                message = "¡Cambio!",
                colour = G.C.ORANGE
            }
        end
    end,

    check_for_unlock = function(self, args)
        if args.type == 'win' then
            if G.GAME.selected_back.effect.center.key == 'b_kranlaxs_dungeon_deck' and G.GAME.stake == 'blue' then
                return true
            end
        end
        return false
    end
}