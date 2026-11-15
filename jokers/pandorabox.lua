SMODS.Joker{
    key = "pandorabox",
    config = { extra = {} },
    pos = { x = 4, y = 6 },
    display_size = { w = 71, h = 95 },
    cost = 20,
    rarity = "kranlaxs_zenith",
    blueprint_compat = false,
    eternal_compat = true,
    bm_cost = 10,
    perishable_compat = true,
    unlocked = false,
    discovered = false,
    atlas = 'CustomJokers',
    pools = { ["kranlaxs_kranlaxs_jokers"] = true },
    
    check_for_unlock = function(self, args)
        if args.type == 'win' then
            -- Nivel 9 = Pozo Magenta
            if G.GAME.selected_back.effect.center.key == 'b_kranlaxs_dungeon_deck' and G.GAME.stake >= 9 then
                return true
            end
        end
        return false
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and G.GAME.blind.boss and not context.blueprint then
            local current_deck = G.GAME.selected_back.effect.center.key
            local joker_to_create = nil
            local seed = pseudoseed('pandora_box' .. G.GAME.round_resets.ante)
            
            if current_deck == 'b_red' then joker_to_create = 'j_burnt'
            elseif current_deck == 'b_blue' then joker_to_create = 'j_card_sharp'
            elseif current_deck == 'b_yellow' then joker_to_create = 'j_chaos'
            elseif current_deck == 'b_green' then joker_to_create = pseudorandom_element({'j_delayed_grat', 'j_rocket', 'j_golden', 'j_satellite'}, seed)
            elseif current_deck == 'b_black' then joker_to_create = 'j_stencil'
            elseif current_deck == 'b_magic' then joker_to_create = 'j_fortune_teller'
            elseif current_deck == 'b_nebula' then joker_to_create = 'j_kranlaxs_telescope'
            elseif current_deck == 'b_ghost' then joker_to_create = pseudorandom_element({'j_perkeo', 'j_kranlaxs_mandalajoker'}, seed)
            elseif current_deck == 'b_abandoned' then joker_to_create = 'j_kranlaxs_facelessaccountant'
            elseif current_deck == 'b_zodiac' then joker_to_create = 'j_kranlaxs_Cashback'
            elseif current_deck == 'b_checkered' then joker_to_create = pseudorandom_element({'j_bloodstone', 'j_arrowhead'}, seed)
            elseif current_deck == 'b_painted' then joker_to_create = 'j_obelisk'
            elseif current_deck == 'b_anaglyph' then joker_to_create = 'j_diet_cola'
            elseif current_deck == 'b_plasma' then joker_to_create = 'j_stuntman'
            elseif current_deck == 'b_erratic' then joker_to_create = 'j_kranlaxs_nft'
            elseif current_deck == 'b_kranlaxs_week_challenge' then joker_to_create = 'j_kranlaxs_sundaycheckpoint'
            elseif current_deck == 'b_kranlaxs_dungeon_deck' then joker_to_create = 'j_kranlaxs_knight'
            elseif current_deck == 'b_kranlaxs_space_deck' then joker_to_create = 'j_kranlaxs_hippie'
            elseif current_deck == 'b_kranlaxs_bugged_deck' then joker_to_create = 'j_kranlaxs_tmtrainer'
            elseif current_deck == 'b_warpzone_encadenada' then joker_to_create = 'j_warpzone_melancholic_joker'
            elseif current_deck == 'b_warpzone_morada' then joker_to_create = 'j_cartomancer'
            elseif current_deck == 'b_warpzone_calico' then joker_to_create = 'j_hologram'
            elseif current_deck == 'b_warpzone_ebony_deck' then joker_to_create = 'j_warpzone_silent_film'
            elseif current_deck == 'b_warpzone_dimensional_deck' then joker_to_create = 'j_warpzone_philosophers_stone'
            elseif current_deck == 'b_warpzone_radioactive_deck' then joker_to_create = 'j_warpzone_sectarian_joker'
            elseif current_deck == 'b_warpzone_stamped_deck' then joker_to_create = 'j_credit_card'
            elseif current_deck == 'b_warpzone_rooted_deck' then joker_to_create = 'j_erosion'
            elseif current_deck == 'b_warpzone_orange_deck' then joker_to_create = 'j_bull'
            elseif current_deck == 'b_warpzone_psychedelic_deck' then joker_to_create = 'j_warpzone_ghost_joker'
            elseif current_deck == 'b_warpzone_gravity_deck' then joker_to_create = 'j_acrobat'
            elseif current_deck == 'b_warpzone_onirica' then joker_to_create = 'j_warpzone_harlequin'
            elseif current_deck == 'b_warpzone_runica' then joker_to_create = 'j_warpzone_porcelain'
            elseif current_deck == 'b_warpzone_draconiana' then joker_to_create = 'j_chicot'
            elseif current_deck == 'b_warpzone_infernal' then joker_to_create = pseudorandom_element({'j_vampire', 'j_warpzone_cyberjoker'}, seed)
            elseif current_deck == 'b_kranlaxs_chaos_deck' then
                local random_pool = pseudorandom_element(G.P_CENTER_POOLS.Joker, seed)
                joker_to_create = random_pool.key
            else
                joker_to_create = 'j_blueprint' 
            end
            
            if joker_to_create and (#G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit) then
                G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = function()
                        if G.P_CENTERS[joker_to_create] then
                            SMODS.add_card({ set = 'Joker', key = joker_to_create })
                        else
                            SMODS.add_card({ set = 'Joker', key = 'j_joker' })
                        end
                        G.GAME.joker_buffer = 0
                        return true
                    end
                }))
                
                return {
                    message = "¡Joker Útil!",
                    colour = G.C.BLUE,
                    card = card
                }
            end
        end
    end
}