SMODS.Joker{
    key = "guardianangel",
    config = { extra = {}, holy = true },
    pos = { x = 012, y = 10 },
    cost = 8,
    rarity = 3,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },

    check_for_unlock = function(self, args)
        if args.type == 'win' then
            if not G.GAME.kranlaxs_bm_opened then
                return true
            end
        end
        return false
    end,

    set_badges = function(self, card, badges)
        local badge_text = "Holy"
        if G.localization and G.localization.misc and G.localization.misc.dictionary and G.localization.misc.dictionary.k_holy then
            badge_text = G.localization.misc.dictionary.k_holy
        else
            if G.SETTINGS.language == 'es_419' or G.SETTINGS.language == 'es_ES' then
                badge_text = "Sagrada"
            end
        end
        badges[#badges + 1] = create_badge(badge_text, HEX('FFD700'), G.C.WHITE, 1.2)
    end,

    loc_vars = function(self, info_queue, card)
        local status_text = (G.GAME and G.GAME.kranlaxs_bm_opened) and "Inactivo" or "Activo"
        if G.SETTINGS.language == 'en-us' then
            status_text = (G.GAME and G.GAME.kranlaxs_bm_opened) and "Inactive" or "Active"
        end
        return { vars = { status_text } }
    end,

    calculate = function(self, card, context)
        -- FIX: Usamos el gancho nativo de Steamodded para bloquear
        -- exclusivamente los ataques de las Ciegas que voltean cartas.
        if context.stay_flipped and not G.GAME.kranlaxs_bm_opened then
            return true
        end
    end
}

local function is_guardian_angel_active()
    if G.GAME and G.GAME.kranlaxs_bm_opened then return false end
    if G.jokers and G.jokers.cards then
        for _, j in ipairs(G.jokers.cards) do
            if j.config.center.key == 'j_kranlaxs_guardianangel' and not j.debuff and j.added_to_deck then
                return true
            end
        end
    end
    return false
end

local function is_playing_card(card)
    return card.ability and (card.ability.set == 'Default' or card.ability.set == 'Enhanced')
end

if not SMODS.kranlaxs_guardianangel_hooks then
    local orig_open_bm = G.FUNCS.kranlaxs_open_bm
    G.FUNCS.kranlaxs_open_bm = function(e)
        if G.GAME then G.GAME.kranlaxs_bm_opened = true end
        if orig_open_bm then orig_open_bm(e) end
    end

    local orig_set_debuff = Card.set_debuff
    function Card.set_debuff(self, should_debuff, ...)
        orig_set_debuff(self, should_debuff, ...)
        
        -- Mantenemos la protección global sin límite de área para 
        -- escudar también a las cartas mientras siguen en la baraja
        if self.debuff and is_guardian_angel_active() and is_playing_card(self) then
            self.debuff = false
        end
    end

    -- (El Card.flip ha sido eliminado gracias a context.stay_flipped)

    local orig_start_dissolve = Card.start_dissolve
    function Card.start_dissolve(self, ...)
        if is_guardian_angel_active() and is_playing_card(self) then
            self.shattered = false
            self.destroyed = false
            self.getting_sliced = false
            
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    card_eval_status_text(self, 'extra', nil, nil, nil, {message = "¡Salvada!", colour = HEX('FFD700')})
                    self:juice_up(0.3, 0.5)
                    return true
                end
            }))
            
            if self.area == G.play then
                draw_card(G.play, G.discard, 0, 'up', nil, self)
            end
            return 
        end
        if orig_start_dissolve then orig_start_dissolve(self, ...) end
    end
    
    local orig_shatter = Card.shatter
    function Card.shatter(self, ...)
        if is_guardian_angel_active() and is_playing_card(self) then
            self.shattered = false
            self.destroyed = false
            self.getting_sliced = false
            
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    card_eval_status_text(self, 'extra', nil, nil, nil, {message = "¡Salvada!", colour = HEX('FFD700')})
                    self:juice_up(0.3, 0.5)
                    return true
                end
            }))
            
            if self.area == G.play then
                draw_card(G.play, G.discard, 0, 'up', nil, self)
            end
            return
        end
        if orig_shatter then orig_shatter(self, ...) end
    end
    SMODS.kranlaxs_guardianangel_hooks = true
end
