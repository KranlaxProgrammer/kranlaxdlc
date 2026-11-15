SMODS.Voucher {
    key = 'stickerfever',
    atlas = 'CustomVouchers',
    pos = { x = 0, y = 0 }, 
    cost = 20,
    unlocked = true,
    discovered = false,

    in_pool = function(self) return not G.GAME.used_vouchers[self.key] end
}

if not SMODS.kranlaxs_tag_hook then
    
    local orig_start_run = Game.start_run
    function Game:start_run(args)
        if args and args.savetext then
            G.kranlaxs_is_loading_save = true
        end
        orig_start_run(self, args)
        G.kranlaxs_is_loading_save = false
    end

    local orig_add_tag = add_tag
    function add_tag(tag)
        
        local is_cloned = tag.kranlaxs_cloned
        
        orig_add_tag(tag)
        
        if G.kranlaxs_is_loading_save then return end
        
        if not is_cloned and G.GAME and G.GAME.used_vouchers then
            local attempts = 0
            if G.GAME.used_vouchers['v_kranlaxs_stickerfever'] then attempts = attempts + 1 end
            if G.GAME.used_vouchers['v_kranlaxs_stickeralbum'] then attempts = attempts + 1 end
            
            if attempts > 0 then
                local copies_to_add = 0
                -- Lanzamos una moneda por cada Vale que tengamos (50% puro, sin afectar por suerte)
                for i = 1, attempts do
                    -- math.random() nos da un número puro entre 0 y 1 ignorando G.GAME.probabilities
                    if math.random() < 0.5 then
                        copies_to_add = copies_to_add + 1
                    end
                end
                
                if copies_to_add > 0 then
                    G.E_MANAGER:add_event(Event({
                        delay = 0.4,
                        func = function()
                            for i = 1, copies_to_add do
                                local new_tag = Tag(tag.key)
                                new_tag.kranlaxs_cloned = true -- Marcamos para evitar el bucle infinito
                                
                                add_tag(new_tag)
                                play_sound('generic1', 0.9 + (i * 0.1), 1.5)
                            end
                            return true
                        end
                    }))
                end
            end
        end
    end
    SMODS.kranlaxs_tag_hook = true
end