SMODS.Voucher {
    key = 'stickeralbum',
    requires = {'v_kranlaxs_stickerfever'},
    atlas = 'CustomVouchers',
    pos = { x = 1, y = 0 }, -- Cambia estas coordenadas a las de tu atlas
    cost = 15,
    unlocked = true,
    discovered = false,

    in_pool = function(self) return not G.GAME.used_vouchers[self.key] end,

    loc_txt = {
        name = 'Sticker Album',
        text = {
            "Cada vez que obtienes",
            "una {C:attention}Tag{}, obtienes",
            "{C:attention}1{} copia adicional más",
            "{C:inactive}(Se acumula con Sticker Fever)"
        }
    }
}