SMODS.Voucher {
    key = 'version2',
    requires = {'v_kranlaxs_hotfix'}, 
    atlas = 'CustomVouchers',
    pos = { x = 3, y = 0 },
    cost = 15,
    unlocked = true,
    discovered = false,

    -- Candado para que no vuelva a salir si ya lo compraste
    in_pool = function(self) return not G.GAME.used_vouchers[self.key] end,
    loc_txt = {
        name = 'Versión 2.0',
        text = {
            "Saltar ciegas te",
            "otorga {C:money}$5{}.",
            "Requisito de ciegas {C:attention}-15%{}"
        }
    }
}

-- ==============================================================================
-- HOOKS: Salto de Ciega y Reducción de Puntos (REPARADO PARA CRASHEOS)
-- ==============================================================================
if not SMODS.kranlaxs_version2_hook then
    
    local orig_skip = G.FUNCS.skip_blind
    G.FUNCS.skip_blind = function(e)
        if G.GAME and G.GAME.used_vouchers and G.GAME.used_vouchers['v_kranlaxs_version2'] then
            ease_dollars(5) -- Método seguro a prueba de fallos
        end
        orig_skip(e)
    end

    local orig_set_blind = Blind.set_blind
    function Blind:set_blind(blind, reset, silent)
        orig_set_blind(self, blind, reset, silent)
        if G.GAME and G.GAME.used_vouchers and G.GAME.used_vouchers['v_kranlaxs_version2'] then
            if self.chips then
                self.chips = math.floor(self.chips * 0.85)
                self.chip_text = number_format(self.chips)
            end
        end
    end
    
    SMODS.kranlaxs_version2_hook = true
end