SMODS.Voucher {
    key = 'stickerfever',
    atlas = 'CustomVouchers',
    pos = { x = 0, y = 0 }, -- Cambia estas coordenadas a las de tu atlas
    cost = 15,
    unlocked = true,
    discovered = false,

    in_pool = function(self) return not G.GAME.used_vouchers[self.key] end,

    loc_txt = {
        name = 'Sticker Fever',
        text = {
            "Cada vez que obtienes",
            "una {C:attention}Tag{}, obtienes",
            "{C:attention}1{} copia adicional"
        }
    }
}

-- ==============================================================================
-- HOOK MAESTRO: Clonación de Tags
-- ==============================================================================
if not SMODS.kranlaxs_tag_hook then
    local orig_add_tag = add_tag
    function add_tag(tag)
        -- 1. Identificamos si esta Tag ya es un clon creado por nosotros
        local is_cloned = tag.kranlaxs_cloned
        
        -- 2. Dejamos que Balatro haga lo suyo y añada la Tag a la pantalla
        orig_add_tag(tag)
        
        -- 3. Si no es un clon, verificamos cuántas copias debemos darle al jugador
        if not is_cloned and G.GAME and G.GAME.used_vouchers then
            local copies = 0
            if G.GAME.used_vouchers['v_kranlaxs_stickerfever'] then copies = copies + 1 end
            if G.GAME.used_vouchers['v_kranlaxs_stickeralbum'] then copies = copies + 1 end
            
            -- 4. Invocamos las copias con un pequeño retraso para que se vea animado
            if copies > 0 then
                G.E_MANAGER:add_event(Event({
                    delay = 0.4,
                    func = function()
                        for i = 1, copies do
                            -- Creamos una copia exacta de la Tag obtenida
                            local new_tag = Tag(tag.key)
                            -- Le ponemos un candado para que esta copia no genere MÁS copias
                            new_tag.kranlaxs_cloned = true
                            
                            -- La añadimos al juego
                            add_tag(new_tag)
                            play_sound('generic1', 0.9 + (i * 0.1), 1.5)
                        end
                        return true
                    end
                }))
            end
        end
    end
    SMODS.kranlaxs_tag_hook = true
end