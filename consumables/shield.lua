SMODS.Consumable{
    key = 'shield',
    set = 'UNOCards',
    cost = 4,
    unlocked = true,
    discovered = false,
    atlas = 'CustomConsumables', 
    pos = { x = 0, y = 3 }, 

    in_pool = function(self, args)
        if SMODS.showman and SMODS.showman('c_kranlaxs_' .. self.key) then return true end
        if not G.consumeables or not G.consumeables.cards then return true end
        for _, v in ipairs(G.consumeables.cards) do
            if v.config.center.key == 'c_kranlaxs_' .. self.key then return false end
        end
        return true
    end,
    
    can_use = function(self, card)
        -- Función Activa: Anular Ciegas Jefe (Por Uso)
        if G.GAME and G.GAME.blind and G.GAME.blind.boss and not G.GAME.blind.disabled then
            if G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.DRAW_TO_HAND or G.STATE == G.STATES.PLAY_TAROT then
                return true
            end
        end
        return false
    end,
    
    use = function(self, card, area, copier)
        -- Al usarse manualmente, desactiva la Ciega Jefe actual
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                if G.GAME.blind then G.GAME.blind:juice_up() end
                G.GAME.blind:disable()
                return true
            end
        }))
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.game_over and not context.blueprint then
            if G.GAME.chips < G.GAME.blind.chips then
                
                local anim_started = false
                local anim_done = false

                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0,
                    func = function()
                        if not anim_started then
                            anim_started = true

                            -- 1. Liberamos la carta del área de consumibles
                            if card.area then
                                card.area:remove_card(card)
                            end
                            card.getting_sliced = true
                            card.states.hover.can = false
                            card.states.drag.can = false

                            local start_x = card.VT.x
                            local start_y = card.VT.y
                            local center_x = G.play and (G.play.T.x + (G.play.T.w / 2) - (G.CARD_W / 2)) or ((G.ROOM.T.w / 2) - (G.CARD_W / 2))
                            local center_y = G.play and (G.play.T.y + (G.play.T.h / 2) - (G.CARD_H / 2)) or ((G.ROOM.T.h / 2) - (G.CARD_H / 2))

                            local target_scale = 1.35
                            local dur_phase1 = 0.60 -- Viaje al centro creciendo y volteándose (Flip 3D)
                            local dur_phase2 = 1.00 -- Explosión de partículas en el centro
                            local dur_phase3 = 0.50 -- Encogimiento volteándose (Flip 3D) y destrucción
                            local total_dur = dur_phase1 + dur_phase2 + dur_phase3

                            local start_time = G.TIMERS.REAL
                            local pop_triggered = false
                            local shrink_triggered = false
                            local totem_particles = nil

                            local orig_move = card.move
                            card.move = function(self, dt)
                                local elapsed = G.TIMERS.REAL - start_time
                                local flip_width_factor = 1
                                local current_facing = 'front'

                                if elapsed < dur_phase1 then
                                    -- FASE 1: Ir al centro + Crecer + Flip 3D (2 vueltas completas mostrando el reverso)
                                    local p1 = math.min(1, elapsed / dur_phase1)
                                    local ease = 1 - (1 - p1) ^ 3

                                    self.T.x = start_x + (center_x - start_x) * ease
                                    self.T.y = start_y + (center_y - start_y) * ease
                                    self.T.scale = 1 + (target_scale - 1) * ease
                                    self.T.r = 0

                                    local flip_cos = math.cos(ease * math.pi * 4)
                                    flip_width_factor = math.max(0.03, math.abs(flip_cos))
                                    current_facing = (flip_cos >= 0) and 'front' or 'back'

                                elseif elapsed < (dur_phase1 + dur_phase2) then
                                    -- FASE 2: Explosión estilo Tótem en el centro
                                    if not pop_triggered then
                                        pop_triggered = true
                                        play_sound('kranlaxs_pop', 1, 1)
                                        G.ROOM.jiggle = (G.ROOM.jiggle or 0) + 5
                                        if G.hand_text_area then
                                            if G.hand_text_area.blind_chips then G.hand_text_area.blind_chips:juice_up() end
                                            if G.hand_text_area.game_chips then G.hand_text_area.game_chips:juice_up() end
                                        end

                                        totem_particles = Particles(0, 0, 0, 0, {
                                            timer = 0.012,
                                            scale = 0.3,
                                            initialize = true,
                                            lifespan = 1.1,
                                            speed = 5.5,
                                            padding = -1,
                                            attach = self,
                                            colours = {
                                                HEX('55FF55'),
                                                HEX('FFD700'),
                                                HEX('ADFF2F'),
                                                G.C.GOLD
                                            },
                                            fill = true
                                        })
                                    end

                                    local p2 = (elapsed - dur_phase1) / dur_phase2
                                    self.T.x = center_x
                                    self.T.y = center_y
                                    self.T.scale = target_scale + math.sin(p2 * math.pi) * 0.15
                                    self.T.r = math.sin(p2 * math.pi * 6) * 0.12 * (1 - p2)
                                    flip_width_factor = 1
                                    current_facing = 'front'

                                elseif elapsed < total_dur then
                                    -- FASE 3: Encogerse haciendo Flip 3D rápido hasta desaparecer
                                    if not shrink_triggered then
                                        shrink_triggered = true
                                        if totem_particles then
                                            totem_particles.timer = 999
                                            totem_particles.max = 0
                                        end
                                    end

                                    local p3 = (elapsed - dur_phase1 - dur_phase2) / dur_phase3
                                    local ease_in = p3 ^ 2

                                    self.T.x = center_x
                                    self.T.y = center_y
                                    self.T.scale = math.max(0.001, target_scale * (1 - ease_in))
                                    self.T.r = 0

                                    local flip_cos = math.cos(p3 * math.pi * 6)
                                    flip_width_factor = math.max(0.03, math.abs(flip_cos))
                                    current_facing = (flip_cos >= 0) and 'front' or 'back'

                                else
                                    if not anim_done then
                                        anim_done = true
                                        if totem_particles then totem_particles:remove() end
                                        self:remove()
                                        return
                                    end
                                end

                                if orig_move then orig_move(self, dt) end

                                -- Aplicamos el estado de volteo (frente/reverso) y el ancho 3D (VT.w)
                                self.facing = current_facing
                                self.sprite_facing = current_facing
                                self.velocity.x = 0
                                self.velocity.y = 0
                                self.velocity.r = 0
                                self.VT.x = self.T.x
                                self.VT.y = self.T.y
                                self.VT.w = self.T.w * flip_width_factor
                                self.VT.h = self.T.h
                                self.VT.scale = self.T.scale
                                self.VT.r = self.T.r

                                if self.children then
                                    for _, child in pairs(self.children) do
                                        if child.align_to_major then
                                            child:align_to_major()
                                        end
                                    end
                                end
                            end
                        end

                        return anim_done
                    end
                }))

                return {
                    saved = 'ph_kranlaxs_shield'
                }
            end
        end
    end
}