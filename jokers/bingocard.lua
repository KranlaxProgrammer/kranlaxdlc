local function init_bingo(card)
    card.ability.extra.grid = {}
    local pool = {}
    local ranks = { {id=14, s='A'}, {id=13, s='K'}, {id=12, s='Q'}, {id=11, s='J'}, {id=10, s='10'}, {id=9, s='9'}, {id=8, s='8'}, {id=7, s='7'}, {id=6, s='6'}, {id=5, s='5'}, {id=4, s='4'}, {id=3, s='3'}, {id=2, s='2'} }
    local suits = { {name='Hearts', s='H'}, {name='Diamonds', s='D'}, {name='Clubs', s='C'}, {name='Spades', s='S'} }
    
    -- Llenamos la bolsa con las 52 cartas posibles de una baraja inglesa
    for _, r in ipairs(ranks) do
        for _, s in ipairs(suits) do
            table.insert(pool, {rank_id = r.id, suit_name = s.name, symbol = r.s .. " " .. s.s})
        end
    end
    
    -- Sacamos 25 cartas únicas al azar para el cartón
    for i = 1, 25 do
        local idx = math.max(1, math.ceil(pseudorandom('bingo_cell'..i) * #pool))
        local el = table.remove(pool, idx)
        table.insert(card.ability.extra.grid, { rank_id = el.rank_id, suit_name = el.suit_name, symbol = el.symbol, done = false })
    end
    
    card.ability.extra.lines = 0
    card.ability.extra.xmult = 1
end

local function check_bingo_lines(card)
    local g = card.ability.extra.grid
    local lines = 0
    for r = 0, 4 do
        if g[r*5+1].done and g[r*5+2].done and g[r*5+3].done and g[r*5+4].done and g[r*5+5].done then lines = lines + 1 end
    end
    for c = 1, 5 do
        if g[c].done and g[c+5].done and g[c+10].done and g[c+15].done and g[c+20].done then lines = lines + 1 end
    end
    if g[1].done and g[7].done and g[13].done and g[19].done and g[25].done then lines = lines + 1 end
    if g[5].done and g[9].done and g[13].done and g[17].done and g[21].done then lines = lines + 1 end
    card.ability.extra.lines = lines
    card.ability.extra.xmult = 1 + (lines * 0.25)
end

SMODS.Joker{
    key = 'bingocard',
    config = { extra = { lines = 0, xmult = 1 } },
    rarity = 2,
    atlas = 'CustomJokers',
    pos = { x = 6, y = 8 },
    cost = 6,
    blueprint_compat = true,
    unlocked = false,
    discovered = false,
    unlock_condition = {type = '', extra = ''},
    
    check_for_unlock = function(self, args)
        if G and G.PROFILES and G.PROFILES[G.SETTINGS.profile] then
            if G.PROFILES[G.SETTINGS.profile].all_unlocked then return true end
            if G.PROFILES[G.SETTINGS.profile].challenge_progress and G.PROFILES[G.SETTINGS.profile].challenge_progress.completed then
                -- Requiere: Anonimato Total
                if G.PROFILES[G.SETTINGS.profile].challenge_progress.completed.c_kranlaxs_reto_anonimo then return true end
            end
        end
        return false
    end,
    
    loc_vars = function(self, info_queue, card)
        if not card.ability.extra.grid then init_bingo(card) end
        local g = card.ability.extra.grid
        local r1, r2, r3, r4, r5 = "", "", "", "", ""
        for i=1,5 do r1 = r1 .. (g[i].done and "[X]" or "["..g[i].symbol.."]") .. " " end
        for i=6,10 do r2 = r2 .. (g[i].done and "[X]" or "["..g[i].symbol.."]") .. " " end
        for i=11,15 do r3 = r3 .. (g[i].done and "[X]" or "["..g[i].symbol.."]") .. " " end
        for i=16,20 do r4 = r4 .. (g[i].done and "[X]" or "["..g[i].symbol.."]") .. " " end
        for i=21,25 do r5 = r5 .. (g[i].done and "[X]" or "["..g[i].symbol.."]") .. " " end
        return { vars = { card.ability.extra.lines, card.ability.extra.xmult, r1, r2, r3, r4, r5 } }
    end,
    
    calculate = function(self, card, context)
        if not card.ability.extra.grid then init_bingo(card) end
        if context.joker_main and card.ability.extra.xmult > 1 then
            return {
                Xmult_mod = card.ability.extra.xmult,
                message = localize{type='variable',key='a_xmult',vars={card.ability.extra.xmult}}
            }
        end
        if context.individual and context.cardarea == G.play and not context.blueprint then
            local c = context.other_card
            local hit = false
            for _, cell in ipairs(card.ability.extra.grid) do
                if not cell.done then
                    if c:get_id() == cell.rank_id and c:is_suit(cell.suit_name) then 
                        cell.done = true
                        hit = true 
                    end
                end
            end
            if hit then
                check_bingo_lines(card)
                return { message = "¡Bingo!", colour = G.C.GREEN }
            end
        end
    end
}