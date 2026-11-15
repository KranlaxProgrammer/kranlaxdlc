SMODS.Joker{
    key = "libidinoso",
    config = { extra = {} },
    pos = { x = 0, y = 0 },
    cost = 20,
    bm_cost = 7,
    rarity = "kranlaxs_zenith",
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.blueprint then
            -- Buscar la posición de la carta actual en la mano
            local curr_idx = 0
            for i, c in ipairs(context.scoring_hand) do
                if c == context.other_card then curr_idx = i; break end
            end
            
            -- Si no es la primera carta, le inyectamos el poder de la anterior
            if curr_idx > 1 then
                local prev = context.scoring_hand[curr_idx - 1]
                
                local chips = prev.base.nominal > 0 and prev.base.nominal or 0
                local mult = 0
                local x_mult = 1
                
                -- Extraer Mejoras
                if prev.ability.effect ~= 'Base' then
                    chips = chips + (prev.ability.bonus or 0)
                    mult = mult + (prev.ability.mult or 0)
                    if prev.ability.x_mult then x_mult = x_mult * prev.ability.x_mult end
                end
                
                -- Extraer Ediciones
                if prev.edition then
                    if prev.edition.chips then chips = chips + prev.edition.chips end
                    if prev.edition.mult then mult = mult + prev.edition.mult end
                    if prev.edition.x_mult then x_mult = x_mult * prev.edition.x_mult end
                end
                
                local rets = {}
                if chips > 0 then rets.chips = chips end
                if mult > 0 then rets.mult = mult end
                if x_mult > 1 then rets.x_mult = x_mult end
                
                if next(rets) then
                    rets.card = context.other_card
                    return rets
                end
            end
        end
    end
}