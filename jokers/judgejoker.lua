SMODS.Joker {
    key = 'judgejoker',
    atlas = 'CustomJokers',
    pos = { x = 10, y = 03 },
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    
    loc_vars = function(self, info_queue, card) return { vars = { G.GAME.probabilities.normal or 1 } } end,
    
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
    
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            if G.GAME.blind and G.GAME.blind.boss then
                if pseudorandom('judgeboss') < (G.GAME.probabilities.normal or 1) / 10 then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.GAME.blind:disable()
                            play_sound('timpani')
                            card:juice_up(0.5, 0.5)
                            return true
                        end
                    }))
                    return { message = "¡Juicio!", colour = G.C.FILTER }
                end
            end
        end
        
        if context.game_over and not context.blueprint then
            if pseudorandom('judgesave') < (G.GAME.probabilities.normal or 1) / 20 then
                return {
                    message = "¡Salvado!",
                    saved = 'ph_kranlaxs_judge',
                    colour = G.C.FILTER
                }
            end
        end
    end
}