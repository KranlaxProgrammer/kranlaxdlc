local my_mod = SMODS.current_mod
my_mod.config = my_mod.config or {free_weekly_deck=false, suggestive_sprites=false, sort_collection=1, unbalanced_mode=false}

if type(my_mod.config.sort_collection) == "boolean" then
    my_mod.config.sort_collection = my_mod.config.sort_collection and 4 or 1
    if SMODS.save_mod_config then SMODS.save_mod_config(my_mod) end
end
local sug = my_mod.config.suggestive_sprites

local lang = G.SETTINGS.language or 'en-us'
local is_es = (lang == 'es_419' or lang == 'es_ES')

if is_es then
    my_mod.description = "ADVERTENCIAS:\n1. Los sprites sugestivos al destruirse/venderse pueden causar tripofobia debido al escalado del shader en alta resolución.\n2. Los Jokers desbloqueados mediante retos requieren reiniciar el juego para aparecer.\n3. Puedes mandar feedback y reportes de bugs a: furrogenerico777@gmail.com"
elseif lang == 'pt_BR' then
    my_mod.description = "AVISOS:\n1. Os sprites sugestivos podem causar tripofobia ao serem destruídos ou vendidos devido ao redimensionamento do shader.\n2. Os Jokers desbloqueados por desafios exigem que você reinicie o jogo para aparecerem.\n3. Envie seus comentários e relatórios de bugs para: furrogenerico777@gmail.com"
else
    my_mod.description = "WARNINGS:\n1. Suggestive sprites may trigger trypophobia when destroyed/sold due to shader scaling on high-res textures.\n2. Jokers unlocked via challenges require a game restart to appear in the collection.\n3. Send feedback and bug reports to: furrogenerico777@gmail.com"
end

if G and G.PROFILES then for _,profile in pairs(G.PROFILES) do if profile.joker_usage then for _,usage in pairs(profile.joker_usage) do if type(usage)=='table' then usage.wins=usage.wins or {} usage.wins_by_key=usage.wins_by_key or {} usage.losses=usage.losses or {} usage.losses_by_key=usage.losses_by_key or {} end end end end end

SMODS.Atlas({key="modicon",path="ModIcon.png",px=34,py=34,atlas_table="ASSET_ATLAS"})
SMODS.Atlas({key="balatro",path="balatro.png",px=333,py=216,prefix_config={key=false},atlas_table="ASSET_ATLAS"})
SMODS.Atlas({key="CustomJokers",path="CustomJokers.png",px=71,py=95,atlas_table="ASSET_ATLAS"})
SMODS.Atlas({key="CustomConsumables",path="CustomConsumables.png",px=71,py=95,atlas_table="ASSET_ATLAS"})
SMODS.Atlas({key="CustomBoosters",path="CustomBoosters.png",px=71,py=95,atlas_table="ASSET_ATLAS"})
SMODS.Atlas({key="CustomSeals",path="CustomSeals.png",px=71,py=95,atlas_table="ASSET_ATLAS"}):register()
SMODS.Atlas({key="CustomVouchers",path="CustomVouchers.png",px=71,py=95,atlas_table="ASSET_ATLAS"})
SMODS.Atlas({key="CustomDecks",path="CustomDecks.png",px=71,py=95,atlas_table="ASSET_ATLAS"})
SMODS.Atlas({key="CustomStickers",path="CustomStickers.png",px=71,py=95,atlas_table="ASSET_ATLAS"})
SMODS.Atlas({key="QuartzConsumables",path="QuartzConsumables.png",px=71,py=95,atlas_table="ASSET_ATLAS"})
SMODS.Atlas({key="CustomStakes",path="CustomStakes.png",px=29,py=29,atlas_table="ASSET_ATLAS"})
SMODS.Atlas({key="ErraticAnimation",path="ErraticAnimation.png",px=71,py=95,atlas_table="ANIMATION_ATLAS",frames=10})
SMODS.Atlas({key="CustomCompletation",path="CustomCompletation.png",px=71,py=95,atlas_table="ASSET_ATLAS"})
SMODS.Atlas({key="CustomTags",path="CustomTags.png",px=34,py=34,atlas_table="ASSET_ATLAS"})
SMODS.Atlas({key="anonback",path="anonback.png",px=71,py=95,atlas_table="ANIMATION_ATLAS",frames=10})
SMODS.Atlas({key="corruptedjoker",path="corruptedjoker.png",px=71,py=95,atlas_table="ASSET_ATLAS"})
SMODS.Shader({key = 'underwater', path = 'underwater.fs'})
SMODS.Shader({key = 'cosmic', path = 'cosmic.fs'})
SMODS.Shader({key = 'cursed', path = 'cursed.fs'})
SMODS.Shader({key = 'monochrome', path = 'monochrome.fs'})
SMODS.Shader({key = 'sepia', path = 'sepia.fs'})


if sug then
    local sug_w,sug_h=266,332 
    SMODS.Atlas({key="sug_sheep",path="baal1.png",px=sug_w,py=sug_h,atlas_table="ASSET_ATLAS"})
    SMODS.Atlas({key="sug_fat",path="baal2.png",px=sug_w,py=sug_h,atlas_table="ASSET_ATLAS"})
    SMODS.Atlas({key="sug_overweight",path="baal3.png",px=sug_w,py=sug_h,atlas_table="ASSET_ATLAS"})
    SMODS.Atlas({key="sug_massive",path="baal4.png",px=sug_w,py=sug_h,atlas_table="ASSET_ATLAS"})
    SMODS.Atlas({key="sug_panda",path="baal5.png",px=244,py=296,atlas_table="ASSET_ATLAS"})
end

SMODS.Sound({key="deathzombie1",path="deathzombie1.ogg"})
SMODS.Sound({key="deathzombie2",path="deathzombie2.ogg"})
SMODS.Sound({key="bell",path="bell.ogg"})
SMODS.Sound({key="click",path="gun_click.ogg"})
SMODS.Sound({key="shot",path="shotgun.ogg"})
SMODS.Sound({key="cosmicedition",path="cosmicedition.ogg"})
SMODS.Sound({key="eviledition",path="eviledition.ogg"})
SMODS.Sound({key="monochromeedition",path="monochromeedition.ogg"})
SMODS.Sound({key="sepiaedition",path="sepiaedition.ogg"})
SMODS.Sound({key="underwateredition",path="underwateredition.ogg"})
SMODS.Sound({key="exponentialmultsound",path="exponentialmultsound.ogg"})
SMODS.Sound({key="berserker",path="berserker.ogg"})
SMODS.Sound({key="berserkertimer",path="berserkertimer.ogg"})
SMODS.Sound({key="exponentialchips",path="exponentialchips.ogg"})
SMODS.Sound({key="multiplicativechips",path="multiplicativechips.ogg"})
SMODS.Sound({key="pop",path="shieldpop.ogg"})

SMODS.Sound({
    key = "music_uno",
    path = "uno.ogg",
    select_music_track = function()
        if G.pack_cards and G.pack_cards.cards and #G.pack_cards.cards > 0 then
            local first_card = G.pack_cards.cards[1]
            if first_card and first_card.config and first_card.config.center and first_card.config.center.set == "UNOCards" then
                return true
            end
        end
        return false
    end
})

SMODS.Sound({
    key = "music_inverse",
    path = "inverse.ogg",
    select_music_track = function()
        if G.pack_cards and G.pack_cards.cards and #G.pack_cards.cards > 0 then
            local first_card = G.pack_cards.cards[1]
            if first_card and first_card.config and first_card.config.center and first_card.config.center.set == "InverseTarot" then
                return true
            end
        end
        return false
    end
})

SMODS.Rarity {
    key = "zenith",
    loc_txt = { name = "Zenith" },
    badge_colour = HEX("8A2BE2"), 
    weight = 0, 
    pool = true, 
    price_mult = 4 
}

SMODS.Sticker{key='fat',loc_txt={label='Fat',name='Fat',text={}},atlas=sug and 'sug_fat' or 'CustomStickers',pos={x=0,y=0},badge_colour=HEX('c75d32'),prefix_config={key=false},no_collection=true}
SMODS.Sticker{key='overweight',loc_txt={label='Overweight',name='Overweight',text={}},atlas=sug and 'sug_overweight' or 'CustomStickers',pos=sug and {x=0,y=0} or {x=1,y=0},badge_colour=HEX('a83e1c'),prefix_config={key=false},no_collection=true}
SMODS.Sticker{
    key='clover',
    loc_txt={label='Maligno',name='Sticker Maligno',text={"{C:green}#1# en 4{} de probabilidad de","otorgar {C:purple}1 Token{} al","finalizar la ronda"}},
    atlas='CustomStickers',
    pos={x=2,y=0},
    badge_colour=HEX('2C2C2C'),
    prefix_config={key=false},
    loc_vars = function(self, info_queue, card)
        return {vars = {G.GAME and G.GAME.probabilities.normal or 1}}
    end
}
SMODS.Sticker{
    key='massive',
    loc_txt={label='Massive',name='Massive',text={}},
    atlas=sug and 'sug_massive' or 'CustomStickers',
    pos=sug and {x=0,y=0} or {x=3,y=0},
    badge_colour=HEX('6b170c'),
    prefix_config={key=false},
    no_collection=true
}
SMODS.Sticker{
    key='cegado',
    loc_txt={label='Cegado',name='Cegado',text={"{C:green}#1# en 4{} prob. de ser","{C:red}deshabilitado{} permanentemente","al terminar la ronda"}},
    atlas='CustomStickers',
    pos={x=3,y=0},
    badge_colour=HEX('444444'),
    prefix_config={key=false},
    loc_vars = function(self, info_queue, card)
        return {vars = {G.GAME and G.GAME.probabilities.normal or 1}}
    end
}

to_big=to_big or function(a) return a end
lenient_bignum=lenient_bignum or function(a) return a end

if not SMODS.kranlaxs_collection_sort_hook then
    local orig_collection = create_UIBox_your_collection_jokers
    function create_UIBox_your_collection_jokers()
        local kranlaxs_mod = SMODS.Mods and SMODS.Mods["kranlaxs"]
        local sort_opt = (kranlaxs_mod and kranlaxs_mod.config and kranlaxs_mod.config.sort_collection) or 1

        if sort_opt > 1 and G.P_CENTER_POOLS and G.P_CENTER_POOLS.Joker then
            local vanilla_jokers = {}
            local modded_jokers = {}
            
            for i, v in ipairs(G.P_CENTER_POOLS.Joker) do
                local is_vanilla = (not v.mod) or (v.mod and v.mod.id == "Balatro")
                if is_vanilla then
                    table.insert(vanilla_jokers, v)
                else
                    table.insert(modded_jokers, v)
                end
            end

            table.sort(modded_jokers, function(a, b)
                local mod_a = a.mod and a.mod.id or "ZZZ"
                local mod_b = b.mod and b.mod.id or "ZZZ"
                local name_a = (a.loc_txt and a.loc_txt.name) or a.key or ""
                local name_b = (b.loc_txt and b.loc_txt.name) or b.key or ""
                
                local function get_rarity_weight(v)
                    if not v or not v.rarity then return 999, "zzz" end
                    local r = v.rarity
                    if type(r) == 'table' then r = r.key or r.id end
                    
                    if r == 1 or r == 'Common' or r == 'kranlaxs_common' then return 1, tostring(r)
                    elseif r == 2 or r == 'Uncommon' or r == 'kranlaxs_uncommon' then return 2, tostring(r)
                    elseif r == 3 or r == 'Rare' or r == 'kranlaxs_rare' then return 3, tostring(r)
                    elseif r == 'zenith' or r == 'kranlaxs_zenith' then return 4, tostring(r)
                    elseif r == 4 or r == 'Legendary' or r == 'kranlaxs_legendary' then return 5, tostring(r)
                    else return 999, tostring(r) end 
                end

                if sort_opt == 2 then
                    return name_a < name_b
                elseif sort_opt == 3 then
                    if mod_a ~= mod_b then return mod_a < mod_b end
                    return name_a < name_b
                elseif sort_opt == 4 then
                    local rA_w, rA_s = get_rarity_weight(a)
                    local rB_w, rB_s = get_rarity_weight(b)
                    if rA_w ~= rB_w then return rA_w < rB_w end
                    if rA_w == 999 and rA_s ~= rB_s then return rA_s < rB_s end
                    return name_a < name_b
                elseif sort_opt == 5 then
                    if mod_a ~= mod_b then return mod_a < mod_b end
                    local rA_w, rA_s = get_rarity_weight(a)
                    local rB_w, rB_s = get_rarity_weight(b)
                    if rA_w ~= rB_w then return rA_w < rB_w end
                    if rA_w == 999 and rA_s ~= rB_s then return rA_s < rB_s end
                    return name_a < name_b
                end
                
                return name_a < name_b
            end)

            for i = 1, #vanilla_jokers do
                G.P_CENTER_POOLS.Joker[i] = vanilla_jokers[i]
            end
            local offset = #vanilla_jokers
            for i = 1, #modded_jokers do
                G.P_CENTER_POOLS.Joker[offset + i] = modded_jokers[i]
            end
        end
        return orig_collection()
    end
    SMODS.kranlaxs_collection_sort_hook = true
end

SMODS.ConsumableType{key='InverseTarot',primary_colour=G.C.PURPLE,secondary_colour=G.C.DARK_EDITION,loc_txt={name='Inverse Tarot',collection='Inverse Tarot Cards',undiscovered={name='Not Discovered',text={'Find this card in a run','to unlock it'}}},shop_rate=0.0,default='c_kranlaxs_thefool'}
SMODS.ConsumableType{key='UNOCards',primary_colour=G.C.RED,secondary_colour=G.C.YELLOW,loc_txt={name='UNO Card',collection='UNO Cards',undiscovered={name='Not Discovered',text={'Find this card in a run','to unlock it'}}},shop_rate=0.0,default='c_kranlaxs_draw4'}
SMODS.ConsumableType{key='Quartz',primary_colour=HEX('FFC0CB'),secondary_colour=HEX('FFC0CB'),loc_txt={name='Quartz',collection='Quartz stones',undiscovered={name='Not Discovered',text={'Find this stone in a run','to unlock it'}}},shop_rate=0.45,default='c_kranlaxs_blackquartz'}

local NFS = require("nativefs")
local mod_path = SMODS.current_mod.path

local function load_folder(path)
    local files = NFS.getDirectoryItemsInfo(mod_path .. path)
    if files then
        for i = 1, #files do
            local file_name = files[i].name
            if string.sub(file_name, -4) == ".lua" then
                assert(SMODS.load_file(path .. file_name))()
            end
        end
    end
end

assert(SMODS.load_file("tags/tags.lua"))()
load_folder("jokers/")
load_folder("consumables/")
load_folder("editions/")
load_folder("seals/")
load_folder("decks/")
local vouchers_ordenados = {
    "vouchers/more_stock.lua", "vouchers/even_more_stock.lua", "vouchers/stickerfever.lua", 
    "vouchers/stickeralbum.lua", "vouchers/hotfix.lua", "vouchers/version2.lua", 
    "vouchers/shiny_appearance.lua", "vouchers/common_shinys.lua"
}
for _, v in ipairs(vouchers_ordenados) do assert(SMODS.load_file(v))() end
assert(SMODS.load_file("boosters.lua"))()

if not SMODS.kranlaxs_edition_sounds_hook then
    local orig_set_edition = Card.set_edition
    function Card.set_edition(self, edition, immediate, silent)
        orig_set_edition(self, edition, immediate, silent)
        if not silent and edition then
            if edition.kranlaxs_cosmic then play_sound('kranlaxs_cosmicedition', 1, 1)
            elseif edition.kranlaxs_cursed then play_sound('kranlaxs_eviledition', 1, 1)
            elseif edition.kranlaxs_monochrome then play_sound('kranlaxs_monochromeedition', 1, 1)
            elseif edition.kranlaxs_sepia then play_sound('kranlaxs_sepiaedition', 1, 1)
            elseif edition.kranlaxs_underwater then play_sound('kranlaxs_underwateredition', 1, 1)
            end
        end
    end
    SMODS.kranlaxs_edition_sounds_hook = true
end

if not SMODS.kranlaxs_shiny_vouchers_hook then
    local orig_create_card = create_card
    function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
        
        if G.GAME and G.GAME.challenge == 'c_kranlaxs_reto_gachapon' and area == G.shop_jokers then
            _type = 'Booster'
        end

        if _type == 'Joker' and not forced_key and not legendary then
            local unlocked = false
            if G.PROFILES and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].challenge_progress and G.PROFILES[G.SETTINGS.profile].challenge_progress.completed then
                if G.PROFILES[G.SETTINGS.profile].challenge_progress.completed.c_kranlaxs_reto_doppelganger then 
                    unlocked = true 
                end
            end
            if unlocked and pseudorandom('tmtrainer_spawn') < 0.10 then
                forced_key = 'j_kranlaxs_tmtrainer'
            end
        end

        local has_v1,has_v2=G.GAME and G.GAME.used_vouchers and G.GAME.used_vouchers['v_kranlaxs_shiny_appearance'],G.GAME and G.GAME.used_vouchers and G.GAME.used_vouchers['v_kranlaxs_common_shinys']
        if (has_v1 or has_v2) and not forced_key and (area==G.shop_jokers or area==G.shop_booster) then
            local prob_leg,prob_tarot,prob_planet=has_v2 and 0.09 or 0.05,has_v2 and 0.18 or 0.10,has_v2 and 0.18 or 0.10    
            if _type=='Joker' and not legendary and pseudorandom('shiny_leg')<prob_leg then legendary, _rarity=true, 4
            elseif _type=='Tarot' and pseudorandom('shiny_tarot')<prob_tarot then _type=pseudorandom('shiny_tarot_type')<0.5 and 'InverseTarot' or 'UNOCards'
            elseif _type=='Planet' and pseudorandom('shiny_planet')<prob_planet then _type='Quartz' end
        end
        
        local card = orig_create_card(_type,area,legendary,_rarity,skip_materialize,soulable,forced_key,key_append)
        
        if G.GAME and G.GAME.challenge == 'c_kranlaxs_reto_fijado' and card and card.ability and card.ability.set == 'Joker' then
            card.pinned = true
        end

        if card and card.config.center.key == 'c_kranlaxs_blackquartz' and card.config.center.unlocked == false then
            local fallback_pool = get_current_pool('Tarot')
            if fallback_pool and #fallback_pool > 0 then
                local fallback_key = pseudorandom_element(fallback_pool, pseudoseed('fallback_bq'))
                if fallback_key == 'UNAVAILABLE' or not G.P_CENTERS[fallback_key] then fallback_key = 'c_fool' end
                card:set_ability(G.P_CENTERS[fallback_key], true)
            end
        end

        if card and not card.edition then
            if _type == 'Joker' and (area == G.shop_jokers or area == G.pack_cards) then
                local roll = pseudorandom('kranlaxs_joker_ed')
                if roll < 0.01 and not G.FUNCS.has_holy_joker() then card:set_edition({kranlaxs_cursed = true}, true, true)
                elseif roll < 0.02 then card:set_edition({kranlaxs_underwater = true}, true, true)
                elseif roll < 0.03 then card:set_edition({kranlaxs_monochrome = true}, true, true)
                end
            elseif _type == 'Base' and (area == G.shop_jokers or area == G.pack_cards) then
                local roll = pseudorandom('kranlaxs_base_ed')
                if roll < 0.0025 then card:set_edition({kranlaxs_sepia = true}, true, true)
                elseif roll < 0.0050 then card:set_edition({kranlaxs_monochrome = true}, true, true)
                elseif roll < 0.0075 then card:set_edition({kranlaxs_underwater = true}, true, true)
                elseif roll < 0.0100 and not G.FUNCS.has_holy_joker() then card:set_edition({kranlaxs_cursed = true}, true, true)
                elseif roll < 0.0125 then card:set_edition({kranlaxs_cosmic = true}, true, true)
                end
            end
        end
        
        if G.GAME and G.GAME.modifiers then
            if G.GAME.modifiers.kranlaxs_magenta_pinned and area == G.shop_jokers then
                if card and card.ability and (card.ability.set == 'Joker' or card.ability.consumeable) then
                    if pseudorandom('magenta_pinned') < 0.3 then card.pinned = true end
                end
            end
            if G.GAME.modifiers.kranlaxs_glass_stickers and card and card.ability and card.ability.set == 'Joker' then
                if area == G.shop_jokers or area == G.pack_cards then
                    if pseudorandom('glass_cegado') < 0.25 then card.ability.cegado = true end
                end
            end
        end
        return card
    end
    SMODS.kranlaxs_shiny_vouchers_hook=true
end

SMODS.ObjectType({key="kranlaxs_food",cards={["j_gros_michel"]=true,["j_egg"]=true,["j_ice_cream"]=true,["j_cavendish"]=true,["j_turtle_bean"]=true,["j_diet_cola"]=true,["j_popcorn"]=true,["j_ramen"]=true,["j_selzer"]=true,["j_kranlaxs_birthdaycake"]=true,["j_kranlaxs_colasoda"]=true,["j_kranlaxs_icecreamsandwich"]=true,["j_kranlaxs_bottledwater"]=true,["j_kranlaxs_sushi"]=true,["j_kranlaxs_grapesoda"]=true,["j_kranlaxs_potatobag"]=true,["j_kranlaxs_galletas"]=true}})
SMODS.ObjectType({key="kranlaxs_mycustom_jokers",cards={["j_kranlaxs_cashback"]=true,["j_kranlaxs_underratedjoker"]=true,["j_kranlaxs_facelessaccountant"]=true,["j_kranlaxs_thefixer"]=true,["j_kranlaxs_mysteriousgeode"]=true,["j_kranlaxs_benchwarmer"]=true,["j_kranlaxs_entropy2"]=true}})

my_mod.optional_features=function() return{cardareas={}} end

if not SMODS.kranlaxs_joker_select_hooked then
    local orig_update=Game.update
    function Game:update(dt) 
        orig_update(self,dt) 
        if G.jokers and G.jokers.config.highlighted_limit==0 then G.jokers.config.highlighted_limit=1 end 
        if G.GAME and G.GAME.selected_back and G.GAME.selected_back.effect.center.key=='b_kranlaxs_week_challenge' then
            if G.GAME.modifiers.kranlaxs_week_ch == 5 and G.SETTINGS.GAMESPEED ~= 0.5 then
                G.SETTINGS.GAMESPEED = 0.5
            end
        end
    end
    SMODS.kranlaxs_joker_select_hooked=true
end

if not SMODS.clover_sticker_hooked then
    local original_calculate_joker = Card.calculate_joker
    function Card.calculate_joker(self, context, ...)
        local rets = {original_calculate_joker(self, context, ...)}
        if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
            if self.ability and self.ability.clover then
                if pseudorandom('kranlaxs_clover_sticker') < (G.GAME.probabilities.normal or 1) / 4 then
                    G.GAME.kranlaxs_dark_coins = (G.GAME.kranlaxs_dark_coins or 0) + 1
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            self:juice_up(0.5, 0.5)
                            card_eval_status_text(self, 'extra', nil, nil, nil, {message = "+1 Token", colour = HEX('8b008b')})
                            return true
                        end
                    }))
                end
            end
            if self.ability and self.ability.cegado and not self.ability.cegado_debuffed then
                if pseudorandom('kranlaxs_cegado_sticker') < (G.GAME.probabilities.normal or 1) / 4 then
                    self.ability.cegado_debuffed = true
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            self:set_debuff(true)
                            self:juice_up(0.5, 0.5)
                            play_sound('tarot1')
                            card_eval_status_text(self, 'extra', nil, nil, nil, {message = "¡Cegado!", colour = G.C.DARK_EDITION})
                            return true
                        end
                    }))
                end
            end
        end
        return unpack(rets)
    end
    SMODS.clover_sticker_hooked = true
end

local original_shop_setup=G.FUNCS.shop_setup
G.FUNCS.shop_setup=function(e)
    if G.GAME and G.GAME.selected_back and G.GAME.shop then
        if G.GAME.selected_back.effect.center.key=='b_kranlaxs_week_challenge' then
            if G.GAME.modifiers.kranlaxs_week_ch == 2 then G.GAME.shop.joker_max=1 end
        end
    end
    original_shop_setup(e)
end

G.FUNCS.kranlaxs_update_sort_text = function(e, dir)
    local mod = SMODS.Mods["kranlaxs"]
    if not mod then return end
    local val = (mod.config.sort_collection or 1) + dir
    if val > 5 then val = 1 end
    if val < 1 then val = 5 end
    mod.config.sort_collection = val
    if SMODS.save_mod_config then SMODS.save_mod_config(mod) end
    local text_node = e.UIBox:get_UIE_by_ID("kranlaxs_sort_text")
    if text_node then
        local sort_opts = {"Default", "Alphabetical 1", "Alphabetical 2", "Rarity 1", "Rarity 2"}
        if is_es then sort_opts = {"Por Defecto", "Alfabético 1", "Alfabético 2", "Rareza 1", "Rareza 2"} end
        if lang == 'pt_BR' then sort_opts = {"Padrão", "Alfabética 1", "Alfabética 2", "Raridade 1", "Raridade 2"} end
        text_node.config.text = sort_opts[val]
        text_node.UIBox:recalculate()
    end
end
G.FUNCS.kranlaxs_sort_left = function(e) play_sound('button', 0.9, 0.2); G.FUNCS.kranlaxs_update_sort_text(e, -1) end
G.FUNCS.kranlaxs_sort_right = function(e) play_sound('button', 1.1, 0.2); G.FUNCS.kranlaxs_update_sort_text(e, 1) end

my_mod.config_tab = function()
    local t_free = "Unlock Weekly Challenge deck freely"
    local t_sug = "Enable Suggestive Sprites"
    local t_sort_label = "Modded Jokers Sorting (Req. Restart)"
    local sort_opts = {"Default", "Alphabetical 1", "Alphabetical 2", "Rarity 1", "Rarity 2"}
    local t_unbal = "Enable Unbalanced Mode"
    local t_warn1 = "1. Suggestive sprites may trigger trypophobia when destroyed/sold"
    local t_warn2 = "   due to shader scaling on high-res textures."
    local t_warn3 = "2. Jokers unlocked via challenges require a game restart."
    local t_warn4 = "3. Send feedback and bugs to: furrogenerico777@gmail.com"

    if is_es then
        t_free = "Desbloquear baraja Reto Semanal libremente"
        t_sug = "Habilitar Sprites Sugestivos"
        t_sort_label = "Orden de Jokers del Mod (Req. Reinicio)"
        sort_opts = {"Por Defecto", "Alfabético 1", "Alfabético 2", "Rareza 1", "Rareza 2"}
        t_unbal = "Habilitar Modo Desbalance"
        t_warn1 = "1. Los sprites sugestivos al destruirse/venderse pueden causar"
        t_warn2 = "   tripofobia debido al escalado del shader en alta resolución."
        t_warn3 = "2. Los Jokers desbloqueados por retos requieren reiniciar el juego."
        t_warn4 = "3. Manda feedback y reportes de bugs a: furrogenerico777@gmail.com"
    elseif lang == 'pt_BR' then
        t_free = "Desbloquear baralho Desafio Semanal livremente"
        t_sug = "Ativar Sprites Sugestivos"
        t_sort_label = "Ordem dos Jokers de Mods (Req. Reiniciar)"
        sort_opts = {"Padrão", "Alfabética 1", "Alfabética 2", "Raridade 1", "Raridade 2"}
        t_unbal = "Ativar Modo Desbalanceado"
        t_warn1 = "1. Sprites sugestivos destruídos/vendidos podem causar tripofobia"
        t_warn2 = "   devido ao redimensionamento do shader em alta resolução."
        t_warn3 = "2. Jokers desbloqueados por desafios exigem reiniciar o jogo."
        t_warn4 = "3. Envie bugs e comentários para: furrogenerico777@gmail.com"
    end

    local current_sort = SMODS.Mods["kranlaxs"].config.sort_collection or 1

    return {n=G.UIT.ROOT, config={align="cm", padding=0.05, colour={0,0,0,0}}, nodes={
        {n=G.UIT.R, config={align="cm", padding=0.1}, nodes={create_toggle({label=t_free, ref_table=my_mod.config, ref_value="free_weekly_deck"})}},
        {n=G.UIT.R, config={align="cm", padding=0.1}, nodes={create_toggle({label=t_sug, ref_table=my_mod.config, ref_value="suggestive_sprites"})}},
        {n=G.UIT.R, config={align="cm", padding=0.1}, nodes={
            {n=G.UIT.C, config={align="cr", minw=4.8}, nodes={{n=G.UIT.T, config={text=t_sort_label .. "  ", scale=0.35, colour=G.C.UI.TEXT_LIGHT}}}},
            {n=G.UIT.C, config={align="cm", minw=0.4, minh=0.6, button="kranlaxs_sort_left", hover=true, colour=G.C.BLUE, r=0.1, shadow=true}, nodes={{n=G.UIT.T, config={text="<", scale=0.4, colour=G.C.WHITE}}}},
            {n=G.UIT.C, config={align="cm", minw=2.6, minh=0.6, colour=G.C.BLACK, r=0.1}, nodes={{n=G.UIT.T, config={id="kranlaxs_sort_text", text=sort_opts[current_sort], scale=0.35, colour=G.C.WHITE}}}},
            {n=G.UIT.C, config={align="cm", minw=0.4, minh=0.6, button="kranlaxs_sort_right", hover=true, colour=G.C.BLUE, r=0.1, shadow=true}, nodes={{n=G.UIT.T, config={text=">", scale=0.4, colour=G.C.WHITE}}}},
        }},
        {n=G.UIT.R, config={align="cm", padding=0.1}, nodes={create_toggle({label=t_unbal, ref_table=my_mod.config, ref_value="unbalanced_mode"})}},
        {n=G.UIT.R, config={align="cm", padding=0.02}, nodes={{n=G.UIT.T, config={text=t_warn1, scale=0.32, colour={0.8, 0.2, 0.2, 1}}}}},
        {n=G.UIT.R, config={align="cm", padding=0.02}, nodes={{n=G.UIT.T, config={text=t_warn2, scale=0.32, colour={0.8, 0.2, 0.2, 1}}}}},
        {n=G.UIT.R, config={align="cm", padding=0.02}, nodes={{n=G.UIT.T, config={text=t_warn3, scale=0.32, colour={0.8, 0.2, 0.2, 1}}}}},
        {n=G.UIT.R, config={align="cm", padding=0.02}, nodes={{n=G.UIT.T, config={text=t_warn4, scale=0.32, colour={0.8, 0.2, 0.2, 1}}}}}
    }}
end

if not SMODS.kranlaxs_os_date_hooked then
    local orig_os_date=os.date
    os.date=function(format,time)
        if format=="%w" and SMODS.Mods and SMODS.Mods["kranlaxs"] and SMODS.Mods["kranlaxs"].config and SMODS.Mods["kranlaxs"].config.free_weekly_deck then return "0" end
        return time and orig_os_date(format,time) or orig_os_date(format)
    end
    SMODS.kranlaxs_os_date_hooked=true
end

if not SMODS.kranlaxs_replay_hooks then
    local orig_play_cards = G.FUNCS.play_cards_from_highlighted
    G.FUNCS.play_cards_from_highlighted = function(e)
        if G.GAME then
            G.GAME.kranlaxs_replay_memory = {}
            if G.hand and G.hand.highlighted then
                for i = 1, #G.hand.highlighted do
                    table.insert(G.GAME.kranlaxs_replay_memory, G.hand.highlighted[i])
                end
            end
        end
        orig_play_cards(e)
    end

    local orig_cash_out = G.FUNCS.cash_out
    G.FUNCS.cash_out = function(e)
        if G.GAME then G.GAME.kranlaxs_replay_memory = {} end
        orig_cash_out(e)
    end
    
    local orig_set_blind = Blind.set_blind
    function Blind:set_blind(blind, reset, silent)
        orig_set_blind(self, blind, reset, silent)
        if G.GAME then G.GAME.kranlaxs_replay_memory = {} end
        
        if G.GAME and G.GAME.selected_back and G.GAME.selected_back.effect.center.key == 'b_kranlaxs_week_challenge' then
            local ch = G.GAME.modifiers.kranlaxs_week_ch
            if ch == 3 then
                G.GAME.current_round.hands_left = 1
                G.GAME.current_round.discards_left = 20
            elseif ch == 4 then
                G.GAME.current_round.hands_left = G.GAME.modifiers.kranlaxs_week_TotHands or 50
                G.GAME.current_round.discards_left = G.GAME.modifiers.kranlaxs_week_TotDisc or 50
            end
        end
    end
    SMODS.kranlaxs_replay_hooks = true
end

if not SMODS.kranlaxs_customdraw_hook then
    local orig_discard = G.FUNCS.discard_cards_from_highlighted
    G.FUNCS.discard_cards_from_highlighted = function(e, hook)
        if G.GAME and G.hand and G.hand.highlighted and #G.hand.highlighted > 0 and G.GAME.current_round.discards_left > 0 then
            G.GAME.kranlaxs_custom_draw_tally = (G.GAME.kranlaxs_custom_draw_tally or 0) + 1
        end
        orig_discard(e, hook)
    end
    SMODS.kranlaxs_customdraw_hook = true
end

local function req_reto(id)
    if G and G.PROFILES and G.PROFILES[G.SETTINGS.profile] then
        if G.PROFILES[G.SETTINGS.profile].all_unlocked then return true end
        if G.PROFILES[G.SETTINGS.profile].challenge_progress and G.PROFILES[G.SETTINGS.profile].challenge_progress.completed then return G.PROFILES[G.SETTINGS.profile].challenge_progress.completed[id] end
    end return false
end

SMODS.Challenge{key='reto_fijado',unlocked=function() return true end,rules={custom={{id='kran_fijado_1'}},modifiers={}},jokers={},deck={type='Challenge Deck'},restrictions={banned_cards={},banned_tags={},banned_other={}}}

-- LISTA COMPLETA DE BANEOS (RECETA FAMILIAR)
local receta_banned_jokers = {
    -- Vanilla
    {id='j_joker'}, {id='j_loyalty_card'}, {id='j_steel_joker'}, {id='j_blackboard'}, {id='j_constellation'},
    {id='j_cavendish'}, {id='j_madness'}, {id='j_vampire'}, {id='j_hologram'}, {id='j_baron'}, {id='j_obelisk'},
    {id='j_photograph'}, {id='j_baseball'}, {id='j_ancient'}, {id='j_ramen'}, {id='j_campfire'}, {id='j_acrobat'},
    {id='j_throwback'}, {id='j_bloodstone'}, {id='j_glass'}, {id='j_flower_pot'}, {id='j_idol'}, {id='j_seeing_double'},
    {id='j_hit_the_road'}, {id='j_duo'}, {id='j_trio'}, {id='j_family'}, {id='j_order'}, {id='j_tribe'},
    {id='j_drivers_license'}, {id='j_caino'}, {id='j_triboulet'}, {id='j_yorick'},
    
    -- Kranlax
    {id='j_kranlaxs_battlecard'}, {id='j_kranlaxs_burrow'}, {id='j_kranlaxs_rose'}, {id='j_kranlaxs_alienjoker'},
    {id='j_kranlaxs_anonymousjoker'}, {id='j_kranlaxs_belt'}, {id='j_kranlaxs_bingocard'}, {id='j_kranlaxs_bottledwater'},
    {id='j_kranlaxs_chainreaction'}, {id='j_kranlaxs_entrenador'}, {id='j_kranlaxs_footballstamp'}, {id='j_kranlaxs_grannyjoker'},
    {id='j_kranlaxs_hippodrome'}, {id='j_kranlaxs_humildad'}, {id='j_kranlaxs_lifeoftheparty'}, {id='j_kranlaxs_littlebro'},
    {id='j_kranlaxs_monk'}, {id='j_kranlaxs_paciencia'}, {id='j_kranlaxs_potatobag'}, {id='j_kranlaxs_professor'},
    {id='j_kranlaxs_russianroulette'}, {id='j_kranlaxs_simonsays'}, {id='j_kranlaxs_taco'}, {id='j_kranlaxs_underratedjoker'},
    {id='j_kranlaxs_yakuza'}, {id='j_kranlaxs_birthdaycake'}, {id='j_kranlaxs_caridad'}, {id='j_kranlaxs_castidad'},
    {id='j_kranlaxs_collector'}, {id='j_kranlaxs_depression'}, {id='j_kranlaxs_devioussheep'}, {id='j_kranlaxs_facelessaccountant'},
    {id='j_kranlaxs_investor'}, {id='j_kranlaxs_licenseplate'}, {id='j_kranlaxs_mandalajoker'}, {id='j_kranlaxs_prosopagnosia'},
    {id='j_kranlaxs_salsadancers'}, {id='j_kranlaxs_soap'}, {id='j_kranlaxs_speedrunner'}, {id='j_kranlaxs_tmtrainer'},
    {id='j_kranlaxs_tsunami'}, {id='j_kranlaxs_american'}, {id='j_kranlaxs_berserker'}, {id='j_kranlaxs_colasoda'},
    {id='j_kranlaxs_entropy2'}, {id='j_kranlaxs_envidia'}, {id='j_kranlaxs_furioso'}, {id='j_kranlaxs_leo'},
    {id='j_kranlaxs_mysteriousgeode'}, {id='j_kranlaxs_pisces'}, {id='j_kranlaxs_platanito'}, {id='j_kranlaxs_scorpio'},
    {id='j_kranlaxs_the'}, {id='j_kranlaxs_cyanuro'}, {id='c_kranlaxs_blackquartz'}, -- Mercado Negro baneado
    
    -- Warp Zone
    {id='j_warpzone_angel'}, {id='j_warpzone_cyberjoker'}, {id='j_warpzone_devildeal'}, {id='j_warpzone_druidjoker'},
    {id='j_warpzone_fakir'}, {id='j_warpzone_firefighter'}, {id='j_warpzone_graffiti'}, {id='j_warpzone_ghost_joker'},
    {id='j_warpzone_grasslands'}, {id='j_warpzone_harlequin'}, {id='j_warpzone_lucky_7'}, {id='j_warpzone_metalhead'},
    {id='j_warpzone_mosaicjoker'}, {id='j_warpzone_sectarian_joker'}, {id='j_warpzone_silent_film'}, {id='j_warpzone_solar_flare'},
    {id='j_warpzone_soldier'}, {id='j_warpzone_stiltd_joker'}, {id='j_warpzone_telepath'}, {id='j_warpzone_wizard'},
    {id='j_warpzone_woodenjoker'}, {id='j_warpzone_ace_of_cups'}, {id='j_warpzone_brimstone'}, {id='j_warpzone_carolinareaper'},
    {id='j_warpzone_countess'}, {id='j_warpzone_cursed_rune'}, {id='j_warpzone_highway_to_hell'}, {id='j_warpzone_porcelain'},
    {id='j_warpzone_self_portrait'}, {id='j_warpzone_soccer_card'}, {id='j_warpzone_stairway_to_heaven'}, {id='j_warpzone_superhero'},
    {id='j_warpzone_dagonet'}, {id='j_warpzone_lakosta'}, {id='j_warpzone_lucretia'}, {id='j_warpzone_panasco'}
}

SMODS.Challenge{key='reto_abuela',unlocked=function() return req_reto('c_kranlaxs_reto_fijado') end,rules={custom={{id='kran_abuela_1'}},modifiers={{id='hand_size',value=10}}},jokers={{id='j_kranlaxs_grannyjoker',eternal=true},{id='j_shortcut',eternal=true}},deck={type='Challenge Deck'},restrictions={banned_cards=receta_banned_jokers,banned_tags={},banned_other={}}}

local mazo_crisis={}
for _,palo in ipairs({'S','H','C','D'}) do for i=1,13 do table.insert(mazo_crisis,{s=palo,r='A'}) end end

SMODS.Challenge{key='crisis_economica',unlocked=function() return req_reto('c_kranlaxs_reto_abuela') end,rules={custom={{id='kran_crisis_1'},{id='kran_crisis_2'},{id='kran_crisis_3'}},modifiers={{id='joker_slots',value=3},{id='hand_size',value=12}}},jokers={{id='j_kranlaxs_nft',eternal=true,pinned=true},{id='j_kranlaxs_nft',eternal=true,pinned=true}},deck={type='Challenge Deck',cards=mazo_crisis},restrictions={banned_cards={{id='c_ectoplasm'}},banned_tags={},banned_other={}}}

if not SMODS.kranlaxs_crisis_cost_hooked then
    local orig_get_cost=Card.get_cost
    function Card:get_cost() local costo=orig_get_cost(self);if G.GAME and G.GAME.challenge=='c_kranlaxs_crisis_economica' and costo>0 then costo=math.ceil(costo*1.2) end return costo end
    SMODS.kranlaxs_crisis_cost_hooked=true
end
if not SMODS.kranlaxs_crisis_pay_hooked then
    local orig_set_blind=Blind.set_blind
    function Blind:set_blind(blind,reset,silent) orig_set_blind(self,blind,reset,silent);if G.GAME and G.GAME.challenge=='c_kranlaxs_crisis_economica' and self.dollars then self.dollars=math.max(0,self.dollars-2) end end
    SMODS.kranlaxs_crisis_pay_hooked=true
end

SMODS.Challenge{key='reto_doppelganger',unlocked=function() return req_reto('c_kranlaxs_crisis_economica') end,rules={custom={{id='kran_doppel_1'}},modifiers={{id='joker_slots',value=5}}},jokers={{id='j_kranlaxs_doppelganger',eternal=true},{id='j_kranlaxs_doppelganger',eternal=true},{id='j_kranlaxs_doppelganger',eternal=true},{id='j_kranlaxs_doppelganger',eternal=true},{id='j_kranlaxs_doppelganger',eternal=true}},deck={type='Challenge Deck'},restrictions={banned_cards={{id='v_antimatter'},{id='c_ectoplasm'}},banned_tags={{id='tag_negative'}},banned_other={}}}

SMODS.Challenge{key='reto_anonimo',unlocked=function() return req_reto('c_kranlaxs_reto_doppelganger') end,rules={custom={{id='kran_anonimo_1'}},modifiers={}},jokers={{id='j_kranlaxs_anonymousjoker',eternal=true}},deck={type='Challenge Deck'},restrictions={banned_cards={{id='c_kranlaxs_thestars'}},banned_tags={},banned_other={}}}

if not SMODS.kranlaxs_anonymous_flip_hooked then
    local orig_card_update=Card.update
    function Card:update(dt) 
        orig_card_update(self,dt)
        if G.GAME and G.GAME.challenge=='c_kranlaxs_reto_anonimo' and self.ability and self.ability.set == 'Joker' then 
            if self.facing~='back' then self.facing='back' end 
            if self.sprite_facing~='back' then self.sprite_facing='back' end 
        end 
    end
    SMODS.kranlaxs_anonymous_flip_hooked=true
end

SMODS.Challenge{key='reto_jefes',unlocked=function() return req_reto('c_kranlaxs_reto_anonimo') end,rules={custom={{id='kran_jefes_1'}},modifiers={}},jokers={},deck={type='Challenge Deck'},restrictions={banned_cards={{id='j_chicot'}, {id='j_luchador'}, {id='c_kranlaxs_shield'}, {id='j_kranlaxs_knight'}},banned_tags={},banned_other={}}}

if not SMODS.kranlaxs_all_bosses_hooked then
    local orig_update=Game.update
    function Game:update(dt) orig_update(self,dt);if G.GAME and G.GAME.challenge=='c_kranlaxs_reto_jefes' and G.GAME.round_resets and G.GAME.round_resets.blind_choices then if G.GAME.round_resets.blind_choices.Small=='bl_small' then G.GAME.round_resets.blind_choices.Small=get_new_boss() end if G.GAME.round_resets.blind_choices.Big=='bl_big' then G.GAME.round_resets.blind_choices.Big=get_new_boss() end end end
    local orig_start_run=Game.start_run
    function Game:start_run(args) orig_start_run(self,args);if G.GAME and G.GAME.challenge=='c_kranlaxs_reto_jefes' and G.GAME.round_resets and G.GAME.round_resets.blind_choices then if G.GAME.round_resets.blind_choices.Small=='bl_small' then G.GAME.round_resets.blind_choices.Small=get_new_boss() end if G.GAME.round_resets.blind_choices.Big=='bl_big' then G.GAME.round_resets.blind_choices.Big=get_new_boss() end end end
    SMODS.kranlaxs_all_bosses_hooked=true
end

SMODS.Challenge{key='reto_premonisiones',unlocked=function() return req_reto('c_kranlaxs_reto_jefes') end,rules={custom={{id='kran_premon_1'}},modifiers={}},jokers={{id='j_kranlaxs_philosopher',eternal=true,pinned=true}},deck={type='Challenge Deck'},restrictions={banned_cards={},banned_tags={},banned_other={}}}
if not SMODS.kranlaxs_premoniciones_flip_hooked then
    local orig_card_update=Card.update
    function Card:update(dt) orig_card_update(self,dt);if G.GAME and G.GAME.challenge=='c_kranlaxs_reto_premonisiones' and self.area==G.hand then if self.facing~='back' then self.facing='back' end if self.sprite_facing~='back' then self.sprite_facing='back' end end end
    SMODS.kranlaxs_premoniciones_flip_hooked=true
end

SMODS.Challenge{key='reto_tallo',unlocked=function() return req_reto('c_kranlaxs_reto_premonisiones') end,rules={custom={{id='kran_tallo_1'}},modifiers={}},jokers={{id='j_kranlaxs_beanstalk'},{id='j_kranlaxs_beanstalk'}},deck={type='Challenge Deck'},restrictions={banned_cards={},banned_tags={{id='tag_buffoon'},{id='tag_rare'},{id='tag_uncommon'},{id='tag_foil'},{id='tag_holographic'},{id='tag_polychrome'},{id='tag_negative'},{id='tag_top_hat'}},banned_other={}}}
if not SMODS.kranlaxs_ban_tallo_hooked then
    local orig_start_run=Game.start_run
    function Game:start_run(args)
        local reto=G.CHALLENGES and G.CHALLENGES['c_kranlaxs_reto_tallo']
        if reto and G.GAME and G.GAME.challenge=='c_kranlaxs_reto_tallo' then
            reto.restrictions.banned_cards=reto.restrictions.banned_cards or {}
            for k,v in pairs(G.P_CENTERS) do
                if v.set=='Booster' and string.match(k,'buffoon') then table.insert(reto.restrictions.banned_cards,{id=k}) end
                if v.set=='Joker' and k~='j_kranlaxs_beanstalk' and k~='j_kranlaxs_suspiciousbeanstalk' and k~='j_kranlaxs_epicbeanstalk' and k~='j_kranlaxs_zenithbeanstalk' and k~='j_kranlaxs_commonseed' and k~='j_kranlaxs_weirdlookingseed' and k~='j_kranlaxs_magnificentseed' and k~='j_kranlaxs_godseed' then
                    local already_banned=false
                    for _,banned_item in ipairs(reto.restrictions.banned_cards) do if banned_item.id==k then already_banned=true;break end end
                    if not already_banned then table.insert(reto.restrictions.banned_cards,{id=k}) end
                end
            end
        end
        orig_start_run(self,args)
    end
    SMODS.kranlaxs_ban_tallo_hooked=true
end

SMODS.Challenge{key='reto_gachapon',unlocked=function() return req_reto('c_kranlaxs_reto_tallo') end,rules={custom={{id='gacha_rule_1'}},modifiers={{id='dollars',value=14}}},jokers={},vouchers={{id='v_reroll_surplus'},{id='v_reroll_glut'}},deck={type='Challenge Deck'},restrictions={banned_cards={},banned_tags={{id='tag_buffoon'},{id='tag_rare'},{id='tag_uncommon'},{id='tag_foil'},{id='tag_holographic'},{id='tag_polychrome'},{id='tag_negative'},{id='tag_top_hat'}},banned_other={}}}

SMODS.Challenge{key='reto_pobreza',unlocked=function() return req_reto('c_kranlaxs_reto_gachapon') end,rules={custom={{id='kran_pobreza_1'},{id='kran_pobreza_2'}},modifiers={}},jokers={{id='j_kranlaxs_monk',eternal=true,pinned=true},{id='j_cartomancer',eternal=true,pinned=true,edition='negative'},{id='j_kranlaxs_solarsystem',eternal=true,pinned=true,edition='negative'}},vouchers={{id='v_overstock_norm'},{id='v_overstock_plus'},{id='v_clearance_sale'},{id='v_liquidation'},{id='v_crystal_ball'},{id='v_seed_money'},{id='v_money_tree'}},deck={type='Challenge Deck'},restrictions={banned_cards={},banned_tags={},banned_other={}}}

G.FUNCS.has_holy_joker = function()
    if not G.jokers or not G.jokers.cards then return false end
    for _, j in ipairs(G.jokers.cards) do
        if j.config and j.config.center and j.config.center.holy then 
            return true 
        end
    end
    return false
end

SMODS.Stake{key='magenta',name='Magenta Stake',above_stake='stake_gold',applied_stakes={'stake_gold'},prefix_config={above_stake={mod=false},applied_stakes={mod=false}},pos={x=0,y=0},atlas='CustomStakes',sticker_atlas='CustomCompletation',sticker_pos={x=1,y=0},colour=HEX("FF00FF"),modifiers=function() G.GAME.modifiers.kranlaxs_magenta_pinned=true end}
SMODS.Stake{key='brown',name='Brown Stake',above_stake='kranlaxs_magenta',applied_stakes={'kranlaxs_magenta'},pos={x=1,y=1},atlas='CustomStakes',sticker_atlas='CustomCompletation',sticker_pos={x=2,y=0},colour=HEX("883200"),modifiers=function() G.E_MANAGER:add_event(Event({func=function() SMODS.change_booster_limit(-1);return true end,})) end}
SMODS.Stake{key='turquoise',name='Turquoise Stake',above_stake='kranlaxs_brown',applied_stakes={'kranlaxs_brown'},pos={x=2,y=0},atlas='CustomStakes',sticker_atlas='CustomCompletation',sticker_pos={x=3,y=0},colour=HEX("40E0D0"),modifiers=function() G.GAME.modifiers.kranlaxs_turquoise_noskip=true end}
SMODS.Stake{key='crimson',name='Crimson Stake',above_stake='kranlaxs_turquoise',applied_stakes={'kranlaxs_turquoise'},pos={x=0,y=1},atlas='CustomStakes',sticker_atlas='CustomCompletation',sticker_pos={x=1,y=1},colour=HEX("8B0000"),modifiers=function() G.GAME.modifiers.kranlaxs_crimson_evil_nerf=true end}
SMODS.Stake{key='glass',name='Glass Stake',above_stake='kranlaxs_crimson',applied_stakes={'kranlaxs_crimson'},pos={x=3,y=1},atlas='CustomStakes',sticker_atlas='CustomCompletation',sticker_pos={x=0,y=1},colour=HEX("A6F2ED"),shiny=true,modifiers=function() G.GAME.modifiers.kranlaxs_glass_stickers=true end}
SMODS.Stake{key='mustard',name='Mustard Stake',above_stake='kranlaxs_glass',applied_stakes={'kranlaxs_glass'},pos={x=1,y=0},atlas='CustomStakes',sticker_atlas='CustomCompletation',sticker_pos={x=2,y=1},colour=HEX("FFDB58"),modifiers=function() G.GAME.modifiers.kranlaxs_mustard_nerf=true end}
SMODS.Stake{key='platinum',name='Platinum Stake',above_stake='kranlaxs_mustard',applied_stakes={'kranlaxs_mustard'},pos={x=4,y=0},atlas='CustomStakes',sticker_atlas='CustomCompletation',sticker_pos={x=4,y=0},colour=HEX("E5E4E2"),shiny=true,modifiers=function() G.GAME.win_ante=(G.GAME.win_ante or 8)+2 end}

if not SMODS.kranlaxs_turquoise_hook then
    local orig_skip_blind=G.FUNCS.skip_blind
    G.FUNCS.skip_blind=function(e)
        if G.GAME and G.GAME.modifiers.kranlaxs_turquoise_noskip then
            local current_seed='turq_skip_'..G.GAME.round_resets.ante..'_'..G.GAME.round
            if pseudorandom(current_seed)<0.25 then
                play_sound('timpani');if e.config and e.config.ref_table then e.config.ref_table:juice_up() end
                attention_text({text="¡Bloqueado!",scale=0.9,hold=1.5,colour=G.C.RED,align='cm',offset={x=0,y=-1.5},major=e})
                return
            end
        end
        orig_skip_blind(e)
    end
    SMODS.kranlaxs_turquoise_hook=true
end

local function get_bm_loc(key)
    local dict = {
        ['bm_title']  = { ['es_419'] = "Mercado Negro", ['es_ES'] = "Mercado Negro", ['pt_BR'] = "Mercado Negro", ['en-us'] = "Black Market" },
        ['bm_coins']  = { ['es_419'] = "Tokens: ", ['es_ES'] = "Tokens: ", ['pt_BR'] = "Tokens: ", ['en-us'] = "Tokens: " },
        ['bm_close']  = { ['es_419'] = "Cerrar Mercado", ['es_ES'] = "Cerrar Mercado", ['pt_BR'] = "Fechar Mercado", ['en-us'] = "Close Market" },
        ['bm_nospace']= { ['es_419'] = "¡Sin espacio!", ['es_ES'] = "¡Sin espacio!", ['pt_BR'] = "Sem espaço!", ['en-us'] = "No space!" },
        ['bm_notoken']= { ['es_419'] = "¡Faltan Tokens!", ['es_ES'] = "¡Faltan Tokens!", ['pt_BR'] = "Faltam Tokens!", ['en-us'] = "Not enough Tokens!" },
        ['bm_evil']   = { ['es_419'] = "Maldad: ", ['es_ES'] = "Maldad: ", ['pt_BR'] = "Maldade: ", ['en-us'] = "Evil: " }
    }
    return dict[key][lang] or dict[key]['en-us']
end

local function get_bm_reroll_cost()
    if not G.GAME then return 1 end
    local cost = 1 + (G.GAME.kranlaxs_bm_rerolls or 0)
    
    if G.jokers and G.jokers.cards then
        for _, j in ipairs(G.jokers.cards) do
            if j.config.center.key == 'j_kranlaxs_contrabandista' and not j.debuff then
                cost = math.max(0, cost - 1)
            end
        end
    end
    return cost
end

local orig_init_game_object = Game.init_game_object
function Game:init_game_object()
    local ret = orig_init_game_object(self)
    ret.kranlaxs_dark_coins = 0 
    ret.kranlaxs_bm_stock = {}
    ret.kranlaxs_evil_meter = -2 
    ret.kranlaxs_first_boss_defeated = false
    ret.kranlaxs_bm_has_spawned = false
    ret.kranlaxs_bm_spawn_this_shop = false
    ret.kranlaxs_bm_last_eval_round = 0 
    ret.kranlaxs_bm_rerolls = 0 
    ret.kranlaxs_bm_base_items = 0 
    return ret
end

local orig_start_run_bm = Game.start_run
function Game:start_run(args)
    orig_start_run_bm(self, args)
    if G.GAME and not args.savetext then
        local roll = pseudorandom('bm_init_coins' .. (G.GAME.seed or ''))
        if roll < 0.20 then G.GAME.kranlaxs_dark_coins = 1  
        elseif roll < 0.40 then G.GAME.kranlaxs_dark_coins = 2  
        elseif roll < 0.60 then G.GAME.kranlaxs_dark_coins = 3  
        elseif roll < 0.80 then G.GAME.kranlaxs_dark_coins = 4  
        else G.GAME.kranlaxs_dark_coins = 5  end
        
        if G.GAME.modifiers.kranlaxs_mustard_nerf then
            G.GAME.dollars = (G.GAME.dollars or 0) - 2
            G.GAME.kranlaxs_dark_coins = math.max(0, (G.GAME.kranlaxs_dark_coins or 0) - 1)
        end
    end
end

local function is_bm_unlocked()
    if not G.PROFILES or not G.SETTINGS or not G.PROFILES[G.SETTINGS.profile] then return false end
    
    if G.GAME and G.GAME.challenge == 'c_kranlaxs_reto_abuela' then return false end

    local p = G.PROFILES[G.SETTINGS.profile]
    if p.kranlaxs_bm_unlocked then return true end

    local count = 0
    if G.P_CENTERS then
        for k, v in pairs(G.P_CENTERS) do
            if v.discovered then count = count + 1 end
        end
    end
    
    if count >= 450 then
        p.kranlaxs_bm_unlocked = true
        G:save_progress()
        return true
    end
    return false
end

if not SMODS.kranlaxs_dissolve_hooked then
    local orig_start_dissolve = Card.start_dissolve
    function Card:start_dissolve(color, silent, dissolve_time_fac, no_juice)
        if G.GAME and is_bm_unlocked() then
            local evil_gain = 0
            if self.ability and self.ability.set == 'Joker' then
                evil_gain = 4
            elseif self.base and self.base.suit and self.base.value then
                evil_gain = 2
            end
            if evil_gain > 0 then
                G.GAME.kranlaxs_evil_meter = math.min(100, (G.GAME.kranlaxs_evil_meter or -2) + evil_gain)
            end
        end
        if orig_start_dissolve then orig_start_dissolve(self, color, silent, dissolve_time_fac, no_juice) end
    end
    SMODS.kranlaxs_dissolve_hooked = true
end

if not SMODS.kranlaxs_blind_defeat_hooked then
    local orig_blind_defeat = Blind.defeat
    function Blind:defeat(force)
        local pre_defeated = self.defeated
        if self.boss and G.GAME and is_bm_unlocked() then
            local is_finisher = (G.GAME.round_resets.ante % 8 == 0)
            if is_finisher then
                G.GAME.kranlaxs_dark_coins = (G.GAME.kranlaxs_dark_coins or 0) + 4
                G.GAME.kranlaxs_evil_meter = 100
            else
                local p_seed = pseudoseed('bm_boss_tokens_' .. (G.GAME.round or 1))
                local tokens = pseudorandom_element({1, 2}, p_seed)
                G.GAME.kranlaxs_dark_coins = (G.GAME.kranlaxs_dark_coins or 0) + tokens
                
                local evil_reward = 15
                if G.GAME.modifiers and G.GAME.modifiers.kranlaxs_crimson_evil_nerf then evil_reward = 7 end
                G.GAME.kranlaxs_evil_meter = (G.GAME.kranlaxs_evil_meter or -2) + evil_reward
                
                if not G.GAME.kranlaxs_first_boss_defeated then G.GAME.kranlaxs_first_boss_defeated = true end
            end
            G.GAME.kranlaxs_evil_meter = math.min(100, G.GAME.kranlaxs_evil_meter)
        end
        if orig_blind_defeat then return orig_blind_defeat(self, force) end
    end
    SMODS.kranlaxs_blind_defeat_hooked = true
end

local function generate_bm_stock(is_reroll)
    G.GAME.kranlaxs_bm_stock = {}
    local zenith_pool = {}
    local quartz_pool = {}
    
    for k, v in pairs(G.P_CENTERS) do
        if v.set == 'Joker' and v.unlocked ~= false then
            local is_zenith = false
            if v.rarity == 'kranlaxs_zenith' or v.rarity == 'zenith' then is_zenith = true 
            elseif type(v.rarity) == 'table' and (v.rarity.key == 'kranlaxs_zenith' or v.rarity.key == 'zenith') then is_zenith = true 
            elseif type(v.rarity) == 'number' then
                local r_obj = SMODS.Rarities['kranlaxs_zenith'] or SMODS.Rarities['zenith']
                if r_obj and v.rarity == r_obj.id then is_zenith = true end
            end
            
            if k == 'j_kranlaxs_beanstalk' or k == 'j_kranlaxs_zenithbeanstalk' or k == 'j_kranlaxs_supremeseed' or k == 'j_kranlaxs_ascendedbeanstalk' then
                is_zenith = false
            end
            if k == 'j_kranlaxs_leo' and not (G.GAME and G.GAME.modifiers and G.GAME.modifiers.enable_eternals_in_shop) then
                is_zenith = false
            end
            
            if is_zenith then 
                local can_add = true
                local evil_jokers = {
                    j_kranlaxs_witch = true, j_kranlaxs_bloodymoney = true,
                    j_kranlaxs_thepact = true, j_kranlaxs_contrabandista = true
                }
                if G.FUNCS.has_holy_joker() and evil_jokers[k] then can_add = false end

                if k == 'j_kranlaxs_couponstrip' and G.PROFILES and G.PROFILES[G.SETTINGS.profile] and G.PROFILES[G.SETTINGS.profile].kranlaxs_coupon_dead then
                    can_add = false
                end
                
                if can_add and G.GAME.banned_keys and G.GAME.banned_keys[k] then
                    can_add = false
                end

                if can_add and not (SMODS.showman and SMODS.showman(k)) then
                    if G.jokers and G.jokers.cards then
                        for _, j in ipairs(G.jokers.cards) do
                            if j.config.center.key == k then can_add = false; break end
                        end
                    end
                end
                if can_add then table.insert(zenith_pool, k) end
            end
        elseif v.set == 'Quartz' and v.unlocked ~= false then
            local can_add = true
            if not (SMODS.showman and SMODS.showman(k)) then
                if G.consumeables and G.consumeables.cards then
                    for _, c in ipairs(G.consumeables.cards) do
                        if c.config.center.key == k then can_add = false; break end
                    end
                end
            end
            if can_add then table.insert(quartz_pool, k) end
        end
    end

    if not is_reroll then
        local seed_str = 'bm_shop_qty' .. (G.GAME.round or 1)
        G.GAME.kranlaxs_bm_base_items = pseudorandom_element({1, 2, 3, 4}, pseudoseed(seed_str))
    end

    local num_items = G.GAME.kranlaxs_bm_base_items or 1

    if G.jokers and G.jokers.cards then
        for _, j in ipairs(G.jokers.cards) do
            if j.config.center.key == 'j_kranlaxs_contrabandista' and not j.debuff then
                num_items = num_items + 1
            end
        end
    end

    local roll_seed_str = 'bm_shop_roll_' .. (G.GAME.round or 1) .. '_' .. (G.GAME.kranlaxs_bm_rerolls or 0)

    for i = 1, num_items do
        local use_quartz = false
        if #quartz_pool > 0 and #zenith_pool > 0 then
            use_quartz = pseudorandom(roll_seed_str .. 'type_' .. i) < 0.30 
        elseif #quartz_pool > 0 then
            use_quartz = true
        end
        
        local active_pool = use_quartz and quartz_pool or zenith_pool

        if #active_pool > 0 then
            local p_seed = pseudoseed(roll_seed_str .. i)
            local idx = pseudorandom(p_seed, 1, #active_pool)
            local chosen = active_pool[idx]
            table.insert(G.GAME.kranlaxs_bm_stock, chosen)
            
            if not (SMODS.showman and SMODS.showman(chosen)) then table.remove(active_pool, idx) end
        end
    end
end

local orig_shop_setup = G.FUNCS.shop_setup
G.FUNCS.shop_setup = function(e)
    orig_shop_setup(e)
end

local orig_update_bm = Game.update
function Game:update(dt)
    orig_update_bm(self, dt)
    
    if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
        local p = G.PROFILES[G.SETTINGS.profile]
        if not p.kranlaxs_bm_unlocked then is_bm_unlocked() end
        
        if p.kranlaxs_bm_unlocked and not p.kranlaxs_bm_notified then
            p.kranlaxs_bm_notified = true
            G:save_progress()
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 1,
                func = function()
                    local warning = UIBox{
                        definition = {n = G.UIT.ROOT, config = {align = "cm", colour = G.C.BLACK, r = 0.1, padding = 0.3, outline = 2, outline_colour = G.C.PURPLE}, nodes = {
                            {n = G.UIT.R, config={align="cm", padding=0.1}, nodes={{n = G.UIT.T, config = {text = "¡MERCADO NEGRO DESBLOQUEADO!", scale = 0.6, colour = G.C.RED, shadow=true}}}},
                            {n = G.UIT.R, config={align="cm", padding=0.1}, nodes={{n = G.UIT.T, config = {text = "Has descubierto 300 objetos...", scale = 0.45, colour = G.C.WHITE}}}}
                        }},
                        config = {align = "cm", offset = {x = 0, y = -1}, major = G.ROOM_ATTACH}
                    }
                    play_sound('timpani')
                    G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 4.5, func = function() warning:remove(); return true end }))
                    return true
                end
            }))
        end
    end

    if G.GAME and is_bm_unlocked() and G.jokers then
        local current_evil = math.floor(G.GAME.kranlaxs_evil_meter or -2)
        local current_tokens = G.GAME.kranlaxs_dark_coins or 0
        
        if G.kranlaxs_debug_evil_meter and (G.kranlaxs_debug_evil_meter.last_val ~= current_evil or G.kranlaxs_debug_evil_meter.last_tokens ~= current_tokens) then
            G.kranlaxs_debug_evil_meter:remove()
            G.kranlaxs_debug_evil_meter = nil
        end
        
        if not G.kranlaxs_debug_evil_meter then
            G.kranlaxs_debug_evil_meter = UIBox{
                definition = { n = G.UIT.ROOT, config = {align = "cm", colour = {0,0,0,0.8}, padding = 0.1, r=0.1}, nodes = { 
                    {n = G.UIT.R, config = {align = "cm", padding = 0.05}, nodes = {
                        {n = G.UIT.T, config = {text = get_bm_loc('bm_evil') .. current_evil .. "%", scale = 0.4, colour = G.C.RED}}
                    }},
                    {n = G.UIT.R, config = {align = "cm", padding = 0.05}, nodes = {
                        {n = G.UIT.T, config = {text = get_bm_loc('bm_coins') .. current_tokens, scale = 0.35, colour = {0.8, 0.4, 0.9, 1}}}
                    }}
                } },
                config = {align = "tr", offset = {x = -0.5, y = 3}, major = G.ROOM_ATTACH}
            }
            G.kranlaxs_debug_evil_meter.alignment.z = 100 
            G.kranlaxs_debug_evil_meter.last_val = current_evil
            G.kranlaxs_debug_evil_meter.last_tokens = current_tokens
        end
    else
        if G.kranlaxs_debug_evil_meter then 
            G.kranlaxs_debug_evil_meter:remove() 
            G.kranlaxs_debug_evil_meter = nil 
        end
    end

    if G.STATE == G.STATES.SHOP then
        if G.GAME and G.GAME.kranlaxs_bm_last_eval_round ~= G.GAME.round then
            G.GAME.kranlaxs_bm_last_eval_round = G.GAME.round
            G.GAME.kranlaxs_bm_rerolls = 0 
            
            if is_bm_unlocked() then
                local rng_chance = pseudorandom('bm_spawn' .. G.GAME.round) * 100
                if rng_chance <= (G.GAME.kranlaxs_evil_meter or -2) then
                    G.GAME.kranlaxs_bm_spawn_this_shop = true
                    G.GAME.kranlaxs_bm_has_spawned = true
                    generate_bm_stock(false)
                else
                    G.GAME.kranlaxs_bm_spawn_this_shop = false
                end
            end
        end

        if G.GAME and G.GAME.kranlaxs_bm_spawn_this_shop then
            if not G.kranlaxs_bm_btn_uibox then
                G.kranlaxs_bm_btn_uibox = UIBox{
                    definition = {
                        n = G.UIT.ROOT, config = {align = "cm", colour = {0,0,0,0}}, nodes = {
                            {n = G.UIT.C, config = {align = "cm"}, nodes = {
                                {n = G.UIT.R, config = {align = "cm", padding = 0.05}, nodes = {
                                    {n=G.UIT.C, config={align="cm", padding=0.10, r=0.1, hover=true, colour={0.08, 0.08, 0.1, 1}, button="kranlaxs_open_bm", shadow=true, minw=3.2, minh=0.9}, nodes={
                                        {n=G.UIT.T, config={text=get_bm_loc('bm_title'), scale=0.6, colour={0.86, 0.08, 0.24, 1}, shadow=true}}
                                    }}
                                }}
                            }}
                        }
                    },
                    config = {align="bl", offset={x=4.9, y=-1.05}, major=G.ROOM_ATTACH}
                }
            end
        end
    else
        if G.kranlaxs_bm_btn_uibox then
            G.kranlaxs_bm_btn_uibox:remove()
            G.kranlaxs_bm_btn_uibox = nil
        end
        if G.kranlaxs_bm_area then
            G.kranlaxs_bm_area:remove()
            G.kranlaxs_bm_area = nil
        end
    end
end

G.FUNCS.kranlaxs_open_bm = function(e)
    local is_reroll = (e == 'reroll')
    if G.kranlaxs_bm_area and not is_reroll then return end

    if not is_reroll and G.GAME then G.GAME.kranlaxs_evil_meter = 5 end

    if G.OVERLAY_MENU then G.OVERLAY_MENU:remove() end
    if G.kranlaxs_bm_area then G.kranlaxs_bm_area:remove() end

    if not G.GAME.kranlaxs_bm_stock or #G.GAME.kranlaxs_bm_stock == 0 then generate_bm_stock(false) end

    G.kranlaxs_bm_area = CardArea(0, 0, 5 * G.CARD_W, 1.15 * G.CARD_H, {card_limit = 4, type = 'shop', highlight_limit = 1})

    if G.GAME.kranlaxs_bm_stock then
        for i, card_key in ipairs(G.GAME.kranlaxs_bm_stock) do
            if card_key ~= 'SOLD' then
                local center = G.P_CENTERS[card_key]
                local is_consumable = (center.set == 'Quartz' or center.consumeable)
                local c_type = is_consumable and center.set or 'Joker'
                if not center.discovered then center.discovered = true end
                
                local card = create_card(c_type, G.kranlaxs_bm_area, nil, nil, nil, nil, card_key, 'bm_shop')
                card:set_sprites(center)
                
                local t_cost = center.bm_cost or (center.config and center.config.bm_cost)
                if center.set == 'Quartz' then t_cost = 1 elseif not t_cost then t_cost = 5 end 
                card.kranlaxs_bm_cost = t_cost     
                card.bm_index = i             
                card.cost = 0 
                
                create_shop_card_ui(card, is_consumable and 'Consumeables' or 'Joker', G.kranlaxs_bm_area)
                card.states.visible = true

                card.children.kranlaxs_bm_price = UIBox{
                    definition = {
                        n = G.UIT.ROOT, config = {align = "cm", padding = 0.05, colour = HEX("3D266B"), r = 0.1}, nodes = {
                            {n = G.UIT.T, config = {text = t_cost .. " Tokens", scale = 0.35, colour = G.C.WHITE, shadow = true}}
                        }
                    },
                    config = {align = "bc", offset = {x = 0, y = 0.8}, parent = card}
                }

                local orig_card_update = card.update
                card.update = function(self, dt)
                    if orig_card_update then orig_card_update(self, dt) end
                    if self.children.price then self.children.price.states.visible = false end
                    if self.children.buy_button then
                        if (G.GAME.kranlaxs_dark_coins or 0) >= self.kranlaxs_bm_cost then
                            self.children.buy_button.config.colour = G.C.GREEN
                            self.children.buy_button.config.button = 'buy_from_shop'
                        else
                            self.children.buy_button.config.colour = G.C.UI.BACKGROUND_INACTIVE
                            self.children.buy_button.config.button = nil
                        end
                    end
                end
                G.kranlaxs_bm_area:emplace(card)
            end
        end
    end

    local current_reroll_cost = get_bm_reroll_cost()
    local reroll_str = "Renovar (" .. current_reroll_cost .. " Token" .. (current_reroll_cost ~= 1 and "s" or "") .. ")"
    if G.SETTINGS.language == 'en-us' then reroll_str = "Reroll (" .. current_reroll_cost .. " Token" .. (current_reroll_cost ~= 1 and "s" or "") .. ")" end

    local t = {
        n = G.UIT.ROOT, config = {align = "cm", colour = {0,0,0,0}}, nodes = {
            {n = G.UIT.C, config = {align = "cm", padding = 0.5, r = 0.2, colour = {0.05, 0.05, 0.08, 0.98}, outline = 1, outline_colour = {0.86, 0.08, 0.24, 1}, minw = 12, minh = 6.5}, nodes = {
                {n = G.UIT.R, config = {align = "cm", padding = 0.2}, nodes = {{n = G.UIT.T, config = {text = get_bm_loc('bm_title'), scale = 0.7, colour = {0.86, 0.08, 0.24, 1}, shadow = true}}}},
                {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {{n = G.UIT.T, config = {id = 'bm_window_coin_text', text = get_bm_loc('bm_coins') .. (G.GAME.kranlaxs_dark_coins or 0), scale = 0.45, colour = {0.8, 0.4, 0.9, 1}}}}},
                {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {{n = G.UIT.O, config = {object = G.kranlaxs_bm_area}}}},
                {n = G.UIT.R, config = {align = "cm", padding = 0.5}, nodes = {
                    {n=G.UIT.C, config={align="cm", padding=0.1, r=0.1, hover=true, colour={0.3, 0.1, 0.4, 1}, button="kranlaxs_bm_reroll", shadow=true, minw=3.5, minh=0.7}, nodes={{n=G.UIT.T, config={text=reroll_str, scale=0.4, colour={1, 1, 1, 1}}}}},
                    {n=G.UIT.C, config={minw=1.5}, nodes={}}, 
                    {n=G.UIT.C, config={align="cm", padding=0.1, r=0.1, hover=true, colour={0.8, 0.2, 0.2, 1}, button="kranlaxs_close_bm", shadow=true, minw=3.5, minh=0.7}, nodes={{n=G.UIT.T, config={text=get_bm_loc('bm_close'), scale=0.4, colour={1, 1, 1, 1}}}}}
                }}
            }}
        }
    }
    G.OVERLAY_MENU = UIBox{definition = t, config = {align="cm", offset={x=1,y=2}, major=G.ROOM_ATTACH}}

    if not is_reroll then
        local start_y_win = G.OVERLAY_MENU.alignment.offset.y + 2
        local end_y_win = G.OVERLAY_MENU.alignment.offset.y
        G.OVERLAY_MENU.alignment.offset.y = start_y_win
        local start_time_win = G.TIMERS.REAL 
        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0,
            func = function()
                if not G.OVERLAY_MENU then return true end
                local prog = math.min(1, (G.TIMERS.REAL - start_time_win) / 0.4)
                local ease = 1 - (1 - prog) ^ 3
                G.OVERLAY_MENU.alignment.offset.y = start_y_win + (end_y_win - start_y_win) * ease
                G.OVERLAY_MENU:recalculate()
                return prog >= 1
            end
        }))
    end
end

if not SMODS.kranlaxs_bm_esc_hook then
    local orig_exit_overlay_menu = G.FUNCS.exit_overlay_menu
    G.FUNCS.exit_overlay_menu = function()
        if G.kranlaxs_bm_area then G.kranlaxs_bm_area:remove(); G.kranlaxs_bm_area = nil end
        if orig_exit_overlay_menu then orig_exit_overlay_menu() end
    end
    SMODS.kranlaxs_bm_esc_hook = true
end

G.FUNCS.kranlaxs_bm_reroll = function(e)
    local reroll_cost = get_bm_reroll_cost()
    if (G.GAME.kranlaxs_dark_coins or 0) >= reroll_cost then
        G.GAME.kranlaxs_dark_coins = G.GAME.kranlaxs_dark_coins - reroll_cost
        G.GAME.kranlaxs_bm_rerolls = (G.GAME.kranlaxs_bm_rerolls or 0) + 1
        if reroll_cost > 0 then play_sound('coin6') else play_sound('chips1') end
        generate_bm_stock(true) 
        G.FUNCS.kranlaxs_open_bm('reroll') 
    else
        play_sound('cancel'); if e.config.ref_table then e.config.ref_table:juice_up(0.3, 0.3) end
    end
end

G.FUNCS.kranlaxs_close_bm = function(e)
    if not G.OVERLAY_MENU then return end
    local menu_to_remove = G.OVERLAY_MENU
    local area_to_remove = G.kranlaxs_bm_area
    G.OVERLAY_MENU = nil; G.kranlaxs_bm_area = nil

    local start_y_win = menu_to_remove.alignment.offset.y
    local end_y_win = start_y_win + 10 
    local start_time_win = G.TIMERS.REAL 

    G.E_MANAGER:add_event(Event({
        trigger = 'after', delay = 0,
        func = function()
            local prog = math.min(1, (G.TIMERS.REAL - start_time_win) / 0.3)
            local ease = prog ^ 3
            menu_to_remove.alignment.offset.y = start_y_win + (end_y_win - start_y_win) * ease
            menu_to_remove:recalculate()
            if prog >= 1 then
                menu_to_remove:remove()
                if area_to_remove then area_to_remove:remove() end
                return true
            end
            return false
        end
    }))
end

local orig_buy = G.FUNCS.buy_from_shop
G.FUNCS.buy_from_shop = function(e)
    local card = e.config.ref_table
    if card and card.kranlaxs_bm_cost ~= nil then
        if (G.GAME.kranlaxs_dark_coins or 0) >= card.kranlaxs_bm_cost then
            local is_consumable = card.ability.consumeable or (card.config.center.set ~= 'Joker')
            local dest_area = is_consumable and G.consumeables or G.jokers
            if #dest_area.cards < dest_area.config.card_limit or (card.edition and card.edition.negative) then
                G.GAME.kranlaxs_dark_coins = G.GAME.kranlaxs_dark_coins - card.kranlaxs_bm_cost
                if card.bm_index then G.GAME.kranlaxs_bm_stock[card.bm_index] = 'SOLD' end
                G.kranlaxs_bm_area:remove_card(card)
                if card.children.price then card.children.price:remove(); card.children.price = nil end
                if card.children.kranlaxs_bm_price then card.children.kranlaxs_bm_price:remove(); card.children.kranlaxs_bm_price = nil end
                if card.children.buy_button then card.children.buy_button:remove(); card.children.buy_button = nil end
                card:add_to_deck(); dest_area:emplace(card)
                if G.PROFILES and G.SETTINGS and G.PROFILES[G.SETTINGS.profile] then
                    G.PROFILES[G.SETTINGS.profile].kranlaxs_bm_purchases = (G.PROFILES[G.SETTINGS.profile].kranlaxs_bm_purchases or 0) + 1
                    G:save_progress()
                end
                if not card.config.center.discovered then card.config.center.discovered = true end
                if set_discover_tallies then set_discover_tallies() end
                play_sound('tarot1'); play_sound('coin3')
                if G.OVERLAY_MENU then 
                    local coin_node = G.OVERLAY_MENU:get_UIE_by_ID('bm_window_coin_text')
                    if coin_node then
                        coin_node.config.text = get_bm_loc('bm_coins') .. (G.GAME.kranlaxs_dark_coins or 0)
                        coin_node.UIBox:recalculate()
                    end
                end
            else
                play_sound('cancel'); card:juice_up(0.3, 0.3)
                attention_text({text=get_bm_loc('bm_nospace'), scale=0.6, hold=1.5, colour=G.C.RED, align='cm', offset={x=0,y=-1}, major=card})
            end
        else
            play_sound('cancel'); card:juice_up(0.3, 0.3)
            attention_text({text=get_bm_loc('bm_notoken') .. " (" .. card.kranlaxs_bm_cost .. ")", scale=0.6, hold=1.5, colour=G.C.RED, align='cm', offset={x=0,y=-1}, major=card})
        end
    else
        orig_buy(e)
    end
end

if not SMODS.kranlaxs_global_draw_hook then
    local orig_draw_from_play = G.FUNCS.draw_from_play_to_discard
    G.FUNCS.draw_from_play_to_discard = function(e)
        if G.GAME and G.GAME.current_round and G.GAME.current_round.hands_played >= 1 then G.GAME.potencial_tag_active = 0 end
        if orig_draw_from_play then orig_draw_from_play(e) end
    end
    SMODS.kranlaxs_global_draw_hook = true
end

if not SMODS.kranlaxs_debuff_manager_hook then
    local orig_set_debuff = Card.set_debuff
    function Card:set_debuff(should_debuff)
        if self.base and self:is_face() and G.jokers and G.jokers.cards then
            if self.area == G.hand or self.area == G.play or self.area == G.discard or self.area == G.deck then
                for _, j in ipairs(G.jokers.cards) do
                    if j.config.center.key == 'j_kranlaxs_prosopagnosia' and not j.debuff then
                        should_debuff = true; break
                    end
                end
            end
        end
        if self.ability and self.ability.cegado and self.ability.cegado_debuffed then should_debuff = true end
        if self.area == G.jokers and self.config and self.config.center and self.config.center.key ~= 'j_kranlaxs_envidia' then
            if G.jokers and G.jokers.cards then
                for _, j in ipairs(G.jokers.cards) do
                    if j.config.center.key == 'j_kranlaxs_envidia' and not j.debuff then
                        should_debuff = true; break
                    end
                end
            end
        end
        if orig_set_debuff then orig_set_debuff(self, should_debuff) end
    end
    SMODS.kranlaxs_debuff_manager_hook = true
end

if not SMODS.kranlaxs_cdata_patch_v4 then
    local function clean_num(val)
        if type(val) == 'cdata' then return tonumber(val) or 0 end
        if type(val) == 'table' then
            if val.to_number then return val:to_number() end
            if val.toNumber then return val:toNumber() end
        end
        return val
    end
    local orig_draw_shader = Sprite.draw_shader
    function Sprite:draw_shader(_shader, _shadow_height, _send, _no_tilt, other_obj, ms, mr, mx, my, custom_shader, tilt_shadow)
        if _send and type(_send) == 'table' then
            for k, v in pairs(_send) do
                if type(v) == 'table' and v.val ~= nil then
                    if type(v.val) == 'cdata' or (type(v.val) == 'table' and (v.val.to_number or v.val.toNumber)) then v.val = clean_num(v.val)
                    elseif type(v.val) == 'table' then
                        for idx, inner_v in pairs(v.val) do v.val[idx] = clean_num(inner_v) end
                    end
                end
            end
        end
        if self.T then
            self.T.x = clean_num(self.T.x); self.T.y = clean_num(self.T.y); self.T.w = clean_num(self.T.w)
            self.T.h = clean_num(self.T.h); self.T.scale = clean_num(self.T.scale); self.T.r = clean_num(self.T.r)
        end
        if self.VT then
            self.VT.x = clean_num(self.VT.x); self.VT.y = clean_num(self.VT.y); self.VT.w = clean_num(self.VT.w)
            self.VT.h = clean_num(self.VT.h); self.VT.scale = clean_num(self.VT.scale); self.VT.r = clean_num(self.VT.r)
        end
        ms = clean_num(ms); mr = clean_num(mr); mx = clean_num(mx); my = clean_num(my)
        return orig_draw_shader(self, _shader, _shadow_height, _send, _no_tilt, other_obj, ms, mr, mx, my, custom_shader, tilt_shadow)
    end
    SMODS.kranlaxs_cdata_patch_v4 = true
end

if not SMODS.kranlaxs_amulet_nil_patch then
    local orig_cardarea_draw = CardArea.draw
    function CardArea:draw(...)
        if not self.cards then self.cards = {} end
        if orig_cardarea_draw then return orig_cardarea_draw(self, ...) end
    end
    SMODS.kranlaxs_amulet_nil_patch = true
end
