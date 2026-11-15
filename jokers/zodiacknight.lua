local function get_weighted_zodiac(seed_string)
    local valid_jokers = {}
    local total_weight = 0
    
    for k, v in pairs(G.P_CENTERS) do
        if v.set == 'Joker' and v.is_constellation and k ~= 'j_kranlaxs_constellation' then
            local weight = 10
            local r = v.rarity
            if r == 1 or r == 'Common' or r == 'kranlaxs_common' then weight = 40
            elseif r == 2 or r == 'Uncommon' or r == 'kranlaxs_uncommon' then weight = 30
            elseif r == 3 or r == 'Rare' or r == 'kranlaxs_rare' then weight = 15
            elseif r == 'zenith' or r == 'kranlaxs_zenith' then weight = 5 end
            
            table.insert(valid_jokers, {key = k, weight = weight})
            total_weight = total_weight + weight
        end
    end
    
    if total_weight == 0 then return 'j_joker' end 
    local roll = pseudorandom(pseudoseed(seed_string)) * total_weight
    local current_weight = 0
    
    for _, item in ipairs(valid_jokers) do
        current_weight = current_weight + item.weight
        if roll <= current_weight then return item.key end
    end
    return valid_jokers[#valid_jokers].key
end

SMODS.Joker{
    key = "constellation",
    config = { extra = { 
        copied_joker = 'j_joker',
        sag_mult = 0,
        pisces_xmoney = 1,
        pisces_hand = nil,
        aqua_round = 0,
        aqua_ante = 0,
        aqua_shake = 0
    } },
    pos = { x = 011, y = 09 }, 
    display_size = { w = 71, h = 95 },
    cost = 6,
    rarity = 3, 
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',

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

    loc_vars = function(self, info_queue, card)
        local c_joker = card.ability.extra.copied_joker or 'j_joker'
        local copied_name = "???"
        
        if c_joker ~= 'j_joker' and G.P_CENTERS[c_joker] then
            copied_name = localize{type='name_text', key=c_joker, set='Joker'}
            info_queue[#info_queue+1] = G.P_CENTERS[c_joker]
        end
        return {vars = {copied_name}}
    end,

    set_ability = function(self, card, initial)
        if initial then
            card.ability.extra.copied_joker = get_weighted_zodiac('constellation_init')
        end
    end,

    update = function(self, card, dt)
        local compat_map = {
            j_kranlaxs_taurus = false,
            j_kranlaxs_scorpio = true,
            j_kranlaxs_sagittarius = true,
            j_kranlaxs_capricorn = false,
            j_kranlaxs_pisces = false,
            j_kranlaxs_aquarius = false,
            j_kranlaxs_libra = false,
            j_kranlaxs_leo = true,
            j_kranlaxs_virgo = true,
            j_kranlaxs_gemini = true,
            j_kranlaxs_cancer = false,
            j_kranlaxs_aries = false
        }

        if card.ability and card.ability.extra and card.ability.extra.copied_joker then
            card.blueprint_compat = compat_map[card.ability.extra.copied_joker] or false
        end

        if card.area == G.jokers and not card.debuff then
            local c_joker = card.ability.extra.copied_joker

            if c_joker == 'j_kranlaxs_capricorn' then
                if G.GAME and G.GAME.kranlaxs_evil_meter and G.GAME.kranlaxs_evil_meter < 20 then
                    G.GAME.kranlaxs_evil_meter = 20
                end
            end

            if c_joker == 'j_kranlaxs_pisces' then
                if G.GAME and G.GAME.hands and not card.ability.extra.pisces_hand then
                    local valid_hands = {}
                    for k, v in pairs(G.GAME.hands) do
                        if v.visible then table.insert(valid_hands, k) end
                    end
                    if #valid_hands == 0 then table.insert(valid_hands, 'High Card') end
                    card.ability.extra.pisces_hand = pseudorandom_element(valid_hands, pseudoseed('pisces_start_const' .. (G.GAME.round or 1)))
                end
            end

            if c_joker == 'j_kranlaxs_aquarius' then
                local unbal = SMODS.Mods["kranlaxs"] and SMODS.Mods["kranlaxs"].config.unbalanced_mode
                local is_active = false
                if unbal then
                    is_active = (card.ability.extra.aqua_round ~= G.GAME.round)
                else
                    is_active = (card.ability.extra.aqua_ante ~= G.GAME.round_resets.ante)
                end
                
                if is_active then
                    card.ability.extra.aqua_shake = (card.ability.extra.aqua_shake or 0) + dt
                    if card.ability.extra.aqua_shake > 0.6 then
                        card.ability.extra.aqua_shake = 0
                        card:juice_up(0.06, 0.02)
                    end
                end
            end
        end
    end,

    calc_dollar_bonus = function(self, card)
        if card.ability.extra.copied_joker == 'j_kranlaxs_pisces' then
            if card.ability.extra.pisces_xmoney and card.ability.extra.pisces_xmoney > 1 and G.GAME.dollars > 0 then
                local earned = math.floor(G.GAME.dollars * card.ability.extra.pisces_xmoney) - G.GAME.dollars
                if earned > 0 then return earned end
            end
        end
        return 0
    end,

    calculate = function(self, card, context)
        local c_joker = card.ability.extra.copied_joker
        local unbal = SMODS.Mods["kranlaxs"] and SMODS.Mods["kranlaxs"].config.unbalanced_mode
        local ret = nil

        if c_joker == 'j_kranlaxs_taurus' then
            if context.ending_shop then
                if G.GAME.dollars < 10 then
                    if pseudorandom('taurus_const') < (G.GAME.probabilities.normal or 1) / 3 then
                        local difference = 10 - G.GAME.dollars
                        ease_dollars(difference)
                        ret = { message = "$10", colour = G.C.MONEY, card = card }
                    end
                end
            end

        elseif c_joker == 'j_kranlaxs_scorpio' then
            if context.individual and context.cardarea == G.play then
                ret = { e_mult = (unbal and 1.75 or 1.1), colour = G.C.DARK_EDITION, card = card }
            end

        elseif c_joker == 'j_kranlaxs_sagittarius' then
            if context.setting_blind and not context.blueprint then
                card.ability.extra.sag_mult = (card.ability.extra.sag_mult or 0) + 4
                ret = { message = "+4 Mult", colour = G.C.RED, card = card }
            end
            if context.skip_blind and not context.blueprint then
                if (card.ability.extra.sag_mult or 0) > 0 then
                    card.ability.extra.sag_mult = 0
                    ret = { message = "¡Reinicio!", colour = G.C.RED, card = card }
                end
            end
            if context.joker_main then
                if (card.ability.extra.sag_mult or 0) > 0 then
                    ret = { message = "+" .. card.ability.extra.sag_mult, mult_mod = card.ability.extra.sag_mult, colour = G.C.RED }
                end
            end

        elseif c_joker == 'j_kranlaxs_pisces' then
            if context.joker_main and not context.blueprint then
                if card.ability.extra.pisces_hand and context.scoring_name == card.ability.extra.pisces_hand then
                    card.ability.extra.pisces_xmoney = (card.ability.extra.pisces_xmoney or 1) + 0.1
                    local valid_hands = {}
                    for k, v in pairs(G.GAME.hands) do
                        if v.visible then table.insert(valid_hands, k) end
                    end
                    if #valid_hands == 0 then table.insert(valid_hands, 'High Card') end
                    card.ability.extra.pisces_hand = pseudorandom_element(valid_hands, pseudoseed('pisces_next_const' .. G.GAME.round))
                    ret = { message = "X" .. card.ability.extra.pisces_xmoney .. " Dinero", colour = G.C.MONEY }
                end
            end

        elseif c_joker == 'j_kranlaxs_libra' then
            if context.setting_blind and not context.blueprint then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after', delay = 0.2,
                    func = function()
                        local base_amt = get_blind_amount(G.GAME.round_resets.ante)
                        local new_chips = math.floor(base_amt * 1.5 * G.GAME.starting_params.ante_scaling)
                        G.GAME.blind.chips = new_chips
                        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                        card:juice_up(0.5, 0.5)
                        play_sound('tarot1')
                        return true
                    end
                }))
            end

        elseif c_joker == 'j_kranlaxs_leo' then
            if context.joker_main then
                local eternal_count = 0
                if G.jokers and G.jokers.cards then
                    for _, j in ipairs(G.jokers.cards) do
                        if j.ability and j.ability.eternal then eternal_count = eternal_count + 1 end
                    end
                end
                local final_xmult = 2 + (eternal_count * 1)
                if final_xmult > 1 then
                    ret = { message = "X" .. final_xmult .. " Mult", Xmult_mod = final_xmult, colour = G.C.RED }
                end
            end

        elseif c_joker == 'j_kranlaxs_gemini' then
            if context.end_of_round and not context.individual and not context.repetition then
                if G.GAME.blind.boss then
                    local odds = unbal and 6 or 8
                    if pseudorandom('gemini_const') < (G.GAME.probabilities.normal or 1) / odds then
                        if G.jokers and #G.jokers.cards < G.jokers.config.card_limit then
                            local valid_jokers = {}
                            for _, j in ipairs(G.jokers.cards) do
                                if j ~= card then table.insert(valid_jokers, j) end
                            end
                            if #valid_jokers > 0 then
                                local chosen = pseudorandom_element(valid_jokers, pseudoseed('gemini_choice_const'))
                                local copy = copy_card(chosen, nil, nil, nil, chosen.playing_card)
                                copy:add_to_deck()
                                G.jokers:emplace(copy)
                                ret = { message = "¡Gemelo!", colour = G.C.BLUE }
                            end
                        end
                    end
                end
            end

        elseif c_joker == 'j_kranlaxs_cancer' then
            if context.game_over and not context.blueprint then
                local ante = G.GAME and G.GAME.round_resets and G.GAME.round_resets.ante or 1
                local current_odds = 4 + math.max(0, 9 - ante)
                if pseudorandom('cancer_save_const') < (1 / current_odds) then
                    ret = { message = "¡Salvado!", saved = true, colour = G.C.RED }
                end
            end

        elseif c_joker == 'j_kranlaxs_aquarius' then
            if context.before and not context.blueprint then
                local can_trigger = false
                if unbal then
                    if card.ability.extra.aqua_round ~= G.GAME.round then can_trigger = true end
                else
                    if card.ability.extra.aqua_ante ~= G.GAME.round_resets.ante then can_trigger = true end
                end

                if can_trigger then
                    if unbal then card.ability.extra.aqua_round = G.GAME.round else card.ability.extra.aqua_ante = G.GAME.round_resets.ante end
                    if context.scoring_hand and #context.scoring_hand > 0 then
                        local target = context.scoring_hand[1]
                        target:set_edition({kranlaxs_underwater = true}, true, true)
                        play_sound('kranlaxs_underwateredition', 1, 1)
                        ret = { message = "¡Bautizada!", colour = G.C.BLUE, card = card }
                    end
                end
            end

        elseif c_joker == 'j_kranlaxs_virgo' then
            if context.joker_main then
                local clean_count = 0
                if G.jokers and G.jokers.cards then
                    for _, j in ipairs(G.jokers.cards) do
                        if not j.ability.eternal and not j.ability.perishable and not j.ability.rental and not j.pinned then
                            clean_count = clean_count + 1
                        end
                    end
                end
                local final_chips = clean_count * 25
                if final_chips > 0 then
                    ret = { message = "+" .. final_chips, chip_mod = final_chips, colour = G.C.CHIPS }
                end
            end
        end

        if context.setting_blind and not context.blueprint then
            local new_joker = get_weighted_zodiac('constellation_shift' .. G.GAME.round)
            card.ability.extra.copied_joker = new_joker
            
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.4,
                func = function()
                    card:juice_up(0.5, 0.5)
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = "¡Mutación!", colour = G.C.PURPLE})
                    return true
                end
            }))
        end

        return ret
    end
}

if not SMODS.kranlaxs_aries_hook then
    local orig_calculate_joker = Card.calculate_joker
    function Card:calculate_joker(context)
        if self.config.center.key == 'j_kranlaxs_aries' or (self.config.center.key == 'j_kranlaxs_constellation' and self.ability.extra.copied_joker == 'j_kranlaxs_aries') or self.debuff then
            return orig_calculate_joker(self, context)
        end
        
        local is_last_hand = G.GAME and G.GAME.current_round and G.GAME.current_round.hands_left == 0
        local aries_count = 0
        
        if is_last_hand and G.jokers and G.jokers.cards then
            for i = 1, #G.jokers.cards do
                local j = G.jokers.cards[i]
                if not j.debuff then
                    if j.config.center.key == 'j_kranlaxs_aries' or (j.config.center.key == 'j_kranlaxs_constellation' and j.ability.extra.copied_joker == 'j_kranlaxs_aries') then
                        aries_count = aries_count + 1
                    end
                end
            end
        end
        
        if aries_count == 0 then
            return orig_calculate_joker(self, context)
        end
        
        local b_mult = self.ability.mult or 0
        local b_xmult = self.ability.x_mult or 1
        local b_ex_chips = (type(self.ability.extra) == 'table' and type(self.ability.extra.chips) == 'number') and self.ability.extra.chips or 0
        local b_ex_mult = (type(self.ability.extra) == 'table' and type(self.ability.extra.mult) == 'number') and self.ability.extra.mult or 0
        local b_ex_xmult = (type(self.ability.extra) == 'table' and type(self.ability.extra.Xmult) == 'number') and self.ability.extra.Xmult or 1
        
        local ret = orig_calculate_joker(self, context)
        
        local a_mult = self.ability.mult or 0
        local a_xmult = self.ability.x_mult or 1
        local a_ex_chips = (type(self.ability.extra) == 'table' and type(self.ability.extra.chips) == 'number') and self.ability.extra.chips or 0
        local a_ex_mult = (type(self.ability.extra) == 'table' and type(self.ability.extra.mult) == 'number') and self.ability.extra.mult or 0
        local a_ex_xmult = (type(self.ability.extra) == 'table' and type(self.ability.extra.Xmult) == 'number') and self.ability.extra.Xmult or 1
        
        local scaled = false
        
        if a_mult > b_mult then self.ability.mult = self.ability.mult + ((a_mult - b_mult) * aries_count); scaled = true end
        if a_xmult > b_xmult then self.ability.x_mult = self.ability.x_mult + ((a_xmult - b_xmult) * aries_count); scaled = true end
        if a_ex_chips > b_ex_chips then self.ability.extra.chips = self.ability.extra.chips + ((a_ex_chips - b_ex_chips) * aries_count); scaled = true end
        if a_ex_mult > b_ex_mult then self.ability.extra.mult = self.ability.extra.mult + ((a_ex_mult - b_ex_mult) * aries_count); scaled = true end
        if a_ex_xmult > b_ex_xmult then self.ability.extra.Xmult = self.ability.extra.Xmult + ((a_ex_xmult - b_ex_xmult) * aries_count); scaled = true end
        
        if scaled then
            for i = 1, #G.jokers.cards do
                local j = G.jokers.cards[i]
                if not j.debuff and (j.config.center.key == 'j_kranlaxs_aries' or (j.config.center.key == 'j_kranlaxs_constellation' and j.ability.extra.copied_joker == 'j_kranlaxs_aries')) then
                    j:juice_up(0.3, 0.3)
                end
            end
        end
        
        return ret
    end
    SMODS.kranlaxs_aries_hook = true
end