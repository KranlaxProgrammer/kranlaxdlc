-- ========================================================
-- HELPER: VERIFICADOR DE CONTRASEÑA MEJORADO
-- ========================================================
kranlaxs_passcode_cache = { hash = "", is_match = false, first_card = nil }

function kranlaxs_update_passcode_cache(self_card)
    local target_list = nil
    
    -- 1. Verificamos si la carta es parte de las 5 cartas que se están jugando
    if G.play and G.play.cards and #G.play.cards == 5 then
        for i=1, 5 do
            if G.play.cards[i] == self_card then
                target_list = G.play.cards
                break
            end
        end
    end
    
    -- 2. Si no se están jugando, verificamos si es parte de las 5 cartas resaltadas en la mano (Para actualizar la UI)
    if not target_list and G.hand and G.hand.highlighted and #G.hand.highlighted == 5 then
        for i=1, 5 do
            if G.hand.highlighted[i] == self_card then
                target_list = G.hand.highlighted
                break
            end
        end
    end
    
    -- Si la carta no pertenece a un grupo de 5, ignoramos
    if not target_list then return false, nil end

    -- Creamos un hash rápido para no gastar recursos
    local hash = ""
    for i=1, 5 do hash = hash .. tostring(target_list[i].unique_val) end
    
    if kranlaxs_passcode_cache.hash == hash then
        return kranlaxs_passcode_cache.is_match, kranlaxs_passcode_cache.first_card
    end

    -- Reseteamos la caché
    kranlaxs_passcode_cache.hash = hash
    kranlaxs_passcode_cache.is_match = false
    kranlaxs_passcode_cache.first_card = target_list[1]

    local passcodes = SMODS.find_card("j_kranlaxs_passcode")
    if not next(passcodes) then 
        return false, target_list[1] 
    end

    local rank_map = {
        ['2']='2', ['3']='3', ['4']='4', ['5']='5', ['6']='6', ['7']='7', ['8']='8', ['9']='9',
        ['10']='T', ['Jack']='J', ['Queen']='Q', ['King']='K', ['Ace']='A'
    }

    -- Revisamos si el orden coincide con alguna contraseña
    for _, joker in ipairs(passcodes) do
        if joker.ability and joker.ability.extra and joker.ability.extra.seqs then
            for _, seq in ipairs(joker.ability.extra.seqs) do
                local match = true
                for i = 1, 5 do
                    local card = target_list[i]
                    if not card or not card.base or not card.base.value or rank_map[card.base.value] ~= seq[i] then
                        match = false
                        break
                    end
                end
                if match then
                    kranlaxs_passcode_cache.is_match = true
                    return true, target_list[1]
                end
            end
        end
    end

    return false, target_list[1]
end

-- ========================================================
-- OVERRIDES GLOBALES (A prueba de animaciones)
-- ========================================================
local original_get_id = Card.get_id
function Card:get_id()
    local id = original_get_id(self)
    
    -- Seguro anti-bucles infinitos
    if self.kranlaxs_fetching_id then return id end
    
    local is_match, first_card = kranlaxs_update_passcode_cache(self)
    if is_match and first_card and first_card ~= self then
        self.kranlaxs_fetching_id = true
        local new_id = original_get_id(first_card)
        self.kranlaxs_fetching_id = false
        return new_id
    end
    
    return id
end

local original_is_suit = Card.is_suit
function Card:is_suit(suit, bypass_debuff, flush_calc)
    -- Seguro anti-bucles infinitos
    if self.kranlaxs_fetching_suit then return original_is_suit(self, suit, bypass_debuff, flush_calc) end
    
    local is_match, first_card = kranlaxs_update_passcode_cache(self)
    if is_match and first_card and first_card ~= self then
        self.kranlaxs_fetching_suit = true
        local new_suit = original_is_suit(first_card, suit, bypass_debuff, flush_calc)
        self.kranlaxs_fetching_suit = false
        return new_suit
    end
    
    return original_is_suit(self, suit, bypass_debuff, flush_calc)
end

-- ========================================================
-- EL JOKER PASSCODE
-- ========================================================
SMODS.Joker{
    key = "passcode",
    config = {
        extra = { seqs = nil }
    },
    pos = { x = 8, y = 7 },
    display_size = { w = 71, h = 95 },
    cost = 8,
    rarity = 3,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    
    unlocked = false, -- ¡Cambiado a false para activar el candado!
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    -- Función que atrapa la victoria en Pozo Negro
    check_for_unlock = function(self, args)
        if args and args.type == 'win' then
            -- Verificamos Pozo Negro (stake == 4) y la baraja Reto Semanal
            if G.GAME and G.GAME.stake == 4 and G.GAME.selected_back and G.GAME.selected_back.effect.center.key == 'b_kranlaxs_week_challenge' then
                return true
            end
        end
        return false
    end,

    in_pool = function(self, args)
        if not G.jokers or not G.jokers.cards then return true end
        for _, v in ipairs(G.jokers.cards) do
            if v.config.center.key == 'j_kranlaxs_' .. self.key then
                return false 
            end
        end
        return true
    end,

    set_ability = function(self, card, initial, delay_sprites)
        if initial and not card.ability.extra.seqs then
            card.ability.extra.seqs = {}
            
            for s = 1, 3 do
                local ranks = {'2','3','4','5','6','7','8','9','T','J','Q','K','A'}
                local seq = {}
                for i = 1, 5 do
                    local r = pseudorandom('enigma_seq' .. s .. i, 1, #ranks)
                    table.insert(seq, ranks[r])
                    table.remove(ranks, r)
                end
                table.insert(card.ability.extra.seqs, seq)
            end
        end
    end,

    loc_vars = function(self, info_queue, card)
        local seqs = card.ability.extra.seqs
        if not seqs or #seqs < 3 then return {vars = {"-", "-", "-"}} end
        
        local function fmt_seq(seq)
            local res = {}
            for _, v in ipairs(seq) do
                table.insert(res, v == 'T' and '10' or v)
            end
            return table.concat(res, " - ")
        end
        
        return {vars = {fmt_seq(seqs[1]), fmt_seq(seqs[2]), fmt_seq(seqs[3])}}
    end,

    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            if context.full_hand and #context.full_hand == 5 then
                local is_match, _ = kranlaxs_update_passcode_cache(context.full_hand[1])
                if is_match then
                    return {
                        message = "¡Acceso Concedido!",
                        colour = G.C.GOLD
                    }
                end
            end
        end
    end
}