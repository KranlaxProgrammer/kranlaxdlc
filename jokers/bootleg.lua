SMODS.Joker{
    key = "scalper",
    config = { extra = { options = 2 } }, -- Da +2 opciones extra
    pos = { x = 0, y = 10 }, 
    cost = 4,
    rarity = 2,
    blueprint_compat = false, -- Incompatible con plano
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    check_for_unlock = function(self, args)
        if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
            if (G.PROFILES[G.SETTINGS.profile].kranlaxs_packs_opened or 0) >= 100 then return true end
        end
        return false
    end,

    locked_loc_vars = function(self, info_queue, card)
        local count = G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].kranlaxs_packs_opened or 0
        return { vars = { count } }
    end,
    
    loc_vars = function(self, info_queue, card)
        local count = G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].kranlaxs_packs_opened or 0
        local options = card and card.ability and card.ability.extra and card.ability.extra.options or self.config.extra.options
        return { vars = { count, options } }
    end,
    
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
    end
}

-- Gancho unificado y seguro para opciones de Paquetes
if not SMODS.shared_booster_options_hook then
    local orig_update = Card.update
    function Card:update(dt)
        if orig_update then orig_update(self, dt) end
        if self.ability and self.ability.set == 'Booster' and self.config and self.config.center and self.config.center.config then
            -- 1. Leemos el valor base intocable (evita el bug de 512)
            self.ability.extra = self.config.center.config.extra or 3
            
            -- 2. Sumamos el bonus de Scalper
            if G.jokers and G.jokers.cards then
                for _, v in ipairs(G.jokers.cards) do
                    if v.config.center.key == 'j_kranlaxs_scalper' and not v.debuff then
                        self.ability.extra = self.ability.extra + (v.ability.extra.options or 2)
                    end
                end
            end
            
            -- 3. Sumamos el bonus de Spoon Bender
            if G.GAME and G.GAME.used_vouchers and G.GAME.used_vouchers.v_warpzone_spoon_bender then
                self.ability.extra = self.ability.extra + 1
            end
        end
    end

    local orig_open = Card.open
    function Card:open()
        if self.ability and self.ability.set == 'Booster' then
            -- Actualizar progreso de paquetes abiertos
            if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
                G.PROFILES[G.SETTINGS.profile].kranlaxs_packs_opened = (G.PROFILES[G.SETTINGS.profile].kranlaxs_packs_opened or 0) + 1
                G:save_progress()
            end
            -- Animación del Joker Scalper al abrir
            if G.jokers and G.jokers.cards then
                for _, v in ipairs(G.jokers.cards) do
                    if v.config.center.key == 'j_kranlaxs_scalper' and not v.debuff then
                        v:juice_up(0.5, 0.5)
                    end
                end
            end
        end
        if orig_open then return orig_open(self) end
    end
    SMODS.shared_booster_options_hook = true
end