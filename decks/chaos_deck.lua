SMODS.Back {
    key = 'chaos_deck',
    pos = { x = 0, y = 0 }, 
    unlocked = false,
    discovered = false,
    atlas = 'CustomDecks',
    
    -- Configuración inicial (+1 mano = 5, +2 descartes = 5, +21$ = 25$)
    config = {
        hands = 1, 
        discards = 2, 
        dollars = 21
    },
    
    check_for_unlock = function(self, args)
        for k, v in pairs(G.P_CENTERS) do
            if v.unlocked == false and k ~= 'b_kranlaxs_chaos_deck' and k ~= 'b_chaos_deck' then
                local s = v.set
                if s == 'Joker' or s == 'Voucher' or s == 'Tarot' or s == 'Planet' or s == 'Spectral' or s == 'Back' then
                    return false
                end
            end
        end
        return true
    end,

    apply = function(self, back)
        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.1,
            func = function()
                -- Aplica los 8 Vales iniciales del mod
                local vouchers_to_apply = {
                    'v_kranlaxs_more_stock', 'v_kranlaxs_even_more_stock', 
                    'v_kranlaxs_shiny_appearance', 'v_kranlaxs_common_shinys',
                    'v_kranlaxs_stickerfever', 'v_kranlaxs_stickeralbum', 
                    'v_kranlaxs_hotfix', 'v_kranlaxs_version2'
                }
                
                for _, v_key in ipairs(vouchers_to_apply) do
                    if G.P_CENTERS[v_key] then
                        G.GAME.used_vouchers[v_key] = true
                        local v_card = Card(G.play.T.x, G.play.T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, G.P_CENTERS[v_key])
                        v_card:apply_to_run()
                        v_card:remove()
                    end
                end
                return true
            end
        }))
    end
}

-- Hook global e infalible para la mecánica de "Conjurar" (Compatible con Táctil y Ratón)
if not SMODS.kranlaxs_chaos_conjure_hook then
    local orig_click = Card.click
    function Card:click()
        if orig_click then orig_click(self) end
        
        -- Verifica que estemos jugando con la Baraja del Caos
        if G.GAME and G.GAME.selected_back and G.GAME.selected_back.effect.center.key == 'b_kranlaxs_chaos_deck' then
            
            -- Verifica la bandera de uso por run
            if not G.GAME.kranlaxs_chaos_conjured then
                
                -- Verifica que sea un Joker y no esté en nuestras áreas de juego/tienda (es decir, está en la Colección)
                if self.config and self.config.center and self.config.center.set == 'Joker' then
                    if self.area ~= G.jokers and self.area ~= G.shop_jokers and self.area ~= G.pack_cards and self.area ~= G.hand and self.area ~= G.discard and self.area ~= G.deck then
                        
                        -- Sistema de Doble Toque/Clic para evitar accidentes al hacer scroll en móvil
                        if not self.kranlaxs_last_click or (G.TIMERS.REAL - self.kranlaxs_last_click) > 0.5 then
                            self.kranlaxs_last_click = G.TIMERS.REAL
                            
                            -- Feedback de advertencia al primer toque
                            attention_text({
                                text = "¡Toca de nuevo!",
                                scale = 0.4, 
                                hold = 1,
                                colour = G.C.ORANGE,
                                align = 'cm',
                                offset = {x = 0, y = -1.5},
                                major = self
                            })
                        else
                            -- ¡Segundo toque confirmado! Conjuramos el Comodín si hay espacio
                            if G.jokers and #G.jokers.cards < G.jokers.config.card_limit then
                                local new_joker = create_card('Joker', G.jokers, nil, nil, nil, nil, self.config.center.key, 'chaos_spawn')
                                new_joker:add_to_deck()
                                G.jokers:emplace(new_joker)
                                play_sound('tarot1')
                                self:juice_up(0.5, 0.5)
                                
                                -- Bloquea la mecánica por el resto de la partida
                                G.GAME.kranlaxs_chaos_conjured = true
                                
                                -- Feedback visual de éxito
                                attention_text({
                                    text = "¡Conjurado!",
                                    scale = 0.5, 
                                    hold = 2,
                                    colour = G.C.PURPLE,
                                    align = 'cm',
                                    offset = {x = 0, y = -1.5},
                                    major = self
                                })
                            end
                        end
                        
                    end
                end
            end
        end
    end
    SMODS.kranlaxs_chaos_conjure_hook = true
end