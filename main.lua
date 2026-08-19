local my_mod=SMODS.current_mod
my_mod.config=my_mod.config or {free_weekly_deck=false,suggestive_sprites=false}
local sug=my_mod.config.suggestive_sprites

-- Reparación de perfil inicial
if G and G.PROFILES then for _,profile in pairs(G.PROFILES) do if profile.joker_usage then for _,usage in pairs(profile.joker_usage) do if type(usage)=='table' then usage.wins=usage.wins or {} usage.wins_by_key=usage.wins_by_key or {} usage.losses=usage.losses or {} usage.losses_by_key=usage.losses_by_key or {} end end end end end

-- Carga de Atlas
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

-- ============================================================================
-- REGISTRO DE MÚSICA DE LOS PAQUETES
-- ============================================================================
SMODS.Sound({
    key = 'music_uno',
    path = 'uno.ogg'
})

SMODS.Sound({
    key = 'music_inverse',
    path = 'inverse.ogg'
})

-- Carga de Stickers
SMODS.Sticker{key='fat',loc_txt={label='Fat',name='Fat',text={}},atlas=sug and 'sug_fat' or 'CustomStickers',pos={x=0,y=0},badge_colour=HEX('c75d32'),prefix_config={key=false},no_collection=true}
SMODS.Sticker{key='overweight',loc_txt={label='Overweight',name='Overweight',text={}},atlas=sug and 'sug_overweight' or 'CustomStickers',pos=sug and {x=0,y=0} or {x=1,y=0},badge_colour=HEX('a83e1c'),prefix_config={key=false},no_collection=true}
SMODS.Sticker{key='clover',loc_txt={label='Clover',name='Sticker Trebolado',text={"Duplica las {C:attention}probabilidades{}","de este comodín"}},atlas='CustomStickers',pos={x=2,y=0},badge_colour=HEX('228b22'),prefix_config={key=false}}
SMODS.Sticker{key='massive',loc_txt={label='Massive',name='Massive',text={}},atlas=sug and 'sug_massive' or 'CustomStickers',pos=sug and {x=0,y=0} or {x=3,y=0},badge_colour=HEX('6b170c'),prefix_config={key=false},no_collection=true}

to_big=to_big or function(a) return a end
lenient_bignum=lenient_bignum or function(a) return a end

-- Categorías de Consumibles
SMODS.ConsumableType{key='InverseTarot',primary_colour=G.C.PURPLE,secondary_colour=G.C.DARK_EDITION,loc_txt={name='Inverse Tarot',collection='Inverse Tarot Cards',undiscovered={name='Not Discovered',text={'Find this card in a run','to unlock it'}}},shop_rate=0.0,default='c_kranlaxs_thefool'}
SMODS.ConsumableType{key='UNOCards',primary_colour=G.C.RED,secondary_colour=G.C.YELLOW,loc_txt={name='UNO Card',collection='UNO Cards',undiscovered={name='Not Discovered',text={'Find this card in a run','to unlock it'}}},shop_rate=0.0,default='c_kranlaxs_draw4'}
SMODS.ConsumableType{key='Quartz',primary_colour=HEX('FFC0CB'),secondary_colour=HEX('FFC0CB'),loc_txt={name='Quartz',collection='Quartz stones',undiscovered={name='Not Discovered',text={'Find this stone in a run','to unlock it'}}},shop_rate=0.45,default='c_kranlaxs_blackquartz'}

-- Cargar Etiquetas
assert(SMODS.load_file("tags/tags.lua"))()

-- SISTEMA DE CARGA OPTIMIZADO
local load_files={
    "jokers/benchwarmer.lua","jokers/greedyleprachaun.lua","jokers/tagger.lua","jokers/fidelitycard.lua","jokers/lifeassurance.lua",
    "jokers/thechampion.lua","jokers/panda.lua","jokers/mandalajoker.lua","jokers/regift.lua","jokers/vipsuscription.lua",
    "jokers/bottledwater.lua","jokers/burrow.lua","jokers/bunny.lua","jokers/gigachad.lua","jokers/nft.lua","jokers/beanstalk.lua",
    "jokers/littlebro.lua","jokers/depression.lua","jokers/thethreers.lua","jokers/the.lua","jokers/erraticjoker.lua","jokers/luckyseven.lua",
    "jokers/monk.lua","jokers/antisocial.lua","jokers/famous.lua","jokers/influencer.lua","jokers/deranged.lua","jokers/potatobag.lua",
    "jokers/cleric.lua","jokers/overpopulation.lua","jokers/simonsays.lua","jokers/bingocard.lua","jokers/cashback.lua","jokers/underratedjoker.lua",
    "jokers/russianroulette.lua","jokers/pyromaniac.lua","jokers/miner.lua","jokers/painterjoker.lua","jokers/zombiejoker.lua","jokers/icecreamsandwich.lua",
    "jokers/dispensermachine.lua","jokers/neverendinggambling.lua","jokers/anonymousjoker.lua","jokers/grannyjoker.lua","jokers/lateshippment.lua",
    "jokers/chainreaction.lua","jokers/platanito.lua","jokers/telescope.lua","jokers/coronation.lua","jokers/facelessaccountant.lua",
    "jokers/thefixer.lua","jokers/mysteriousgeode.lua","jokers/devioussheep.lua","jokers/birthdaycake.lua","jokers/chronometer.lua",
    "jokers/thecousin.lua","jokers/colasoda.lua","jokers/sushi.lua","jokers/solarsystem.lua","jokers/medusa.lua","jokers/unkownfactor.lua",
    "jokers/anubis.lua","jokers/certificateddocument.lua","jokers/grapesoda.lua","jokers/doppelganger.lua","jokers/speedrunner.lua",
    "jokers/passcode.lua","jokers/trainer.lua","jokers/medium.lua","jokers/knight.lua","jokers/cheater.lua","jokers/philosopher.lua",
    "jokers/entropy2.lua","jokers/charismaticbard.lua","jokers/cubicaljoker.lua","jokers/pandorabox.lua","jokers/tmtrainer.lua","jokers/sundaycheckpoint.lua",
    "jokers/weeklychallenge.lua","jokers/suspiciousbeanstalk.lua","jokers/epicbeanstalk.lua","jokers/commonseed.lua","jokers/weirdlookingseed.lua",
    "jokers/magnificentseed.lua","jokers/zenithbeanstalk.lua","jokers/godseed.lua","jokers/grannyjoker_alt.lua",
    "consumables/draw4.lua","consumables/draw2.lua","consumables/skip.lua","consumables/reverse.lua","consumables/wildcard.lua","consumables/stacking.lua",
    "consumables/thefool.lua","consumables/themagician.lua","consumables/thehighpriestess.lua","consumables/theempress.lua","consumables/theemperor.lua",
    "consumables/thehierophant.lua","consumables/thelovers.lua","consumables/thechariot.lua","consumables/justice.lua","consumables/thehermit.lua",
    "consumables/thewheeloffortune.lua","consumables/strenght.lua","consumables/thehangedman.lua","consumables/death.lua","consumables/thedevil.lua",
    "consumables/thetower.lua","consumables/judgement.lua","consumables/themoon.lua","consumables/thestars.lua","consumables/thesun.lua","consumables/theworld.lua","consumables/temperance.lua",
    "consumables/blackquartz.lua","consumables/whitequartz.lua","consumables/pinkquartz.lua","consumables/bluequartz.lua","consumables/lilacquartz.lua",
    "consumables/grayquartz.lua","consumables/transparentquartz.lua","consumables/redquartz.lua","consumables/celestequartz.lua","consumables/yellowquartz.lua",
    "consumables/greenquartz.lua","consumables/brownquartz.lua","consumables/turquoisequartz.lua","consumables/orangequartz.lua","consumables/lapislazuli.lua",
    "consumables/cinnabar.lua","consumables/graphite.lua","consumables/uranium.lua","consumables/replay.lua", "consumables/discardall.lua", "consumables/shield.lua", "consumables/misery.lua", "consumables/gift.lua", "consumables/customdraw.lua", 
    "seals/pinkseal.lua","seals/grayseal.lua","seals/mintseal.lua","seals/orangeseal.lua","seals/brownseal.lua","seals/whiteseal.lua",
    "vouchers/more_stock.lua","vouchers/even_more_stock.lua","vouchers/stickerfever.lua","vouchers/stickeralbum.lua","vouchers/hotfix.lua","vouchers/version2.lua",
    "decks/week_challenge.lua","decks/chaos_deck.lua","decks/dungeondeck.lua","decks/space_deck.lua","decks/bugged_deck.lua","boosters.lua"
}
for _,file in ipairs(load_files) do assert(SMODS.load_file(file))() end



-- Hook de Vales de aparición inusual
if not SMODS.kranlaxs_shiny_vouchers_hook then
    local orig_create_card=create_card
    function create_card(_type,area,legendary,_rarity,skip_materialize,soulable,forced_key,key_append)
        local has_v1,has_v2=G.GAME and G.GAME.used_vouchers and G.GAME.used_vouchers['v_kranlaxs_shiny_appearance'],G.GAME and G.GAME.used_vouchers and G.GAME.used_vouchers['v_kranlaxs_common_shinys']
        if (has_v1 or has_v2) and not forced_key and (area==G.shop_jokers or area==G.shop_booster) then
            local prob_leg,prob_tarot,prob_planet=has_v2 and 0.09 or 0.05,has_v2 and 0.18 or 0.10,has_v2 and 0.18 or 0.10    
            if _type=='Joker' and not legendary and pseudorandom('shiny_leg')<prob_leg then legendary, _rarity=true, 4
            elseif _type=='Tarot' and pseudorandom('shiny_tarot')<prob_tarot then _type=pseudorandom('shiny_tarot_type')<0.5 and 'InverseTarot' or 'UNOCards'
            elseif _type=='Planet' and pseudorandom('shiny_planet')<prob_planet then _type='Quartz' end
        end
        return orig_create_card(_type,area,legendary,_rarity,skip_materialize,soulable,forced_key,key_append)
    end
    SMODS.kranlaxs_shiny_vouchers_hook=true
end

-- Vales de Rareza
SMODS.Voucher{key='shiny_appearance',pos={x=2,y=0},cost=20,unlocked=true,discovered=false,atlas='CustomVouchers',loc_vars=function() return{vars={}} end}
SMODS.Voucher{key='common_shinys',pos={x=3,y=0},cost=25,unlocked=true,discovered=false,requires={'v_kranlaxs_shiny_appearance'},atlas='CustomVouchers',loc_vars=function() return{vars={}} end}

-- Categorización de Objetos
SMODS.ObjectType({key="kranlaxs_food",cards={["j_gros_michel"]=true,["j_egg"]=true,["j_ice_cream"]=true,["j_cavendish"]=true,["j_turtle_bean"]=true,["j_diet_cola"]=true,["j_popcorn"]=true,["j_ramen"]=true,["j_selzer"]=true,["j_kranlaxs_birthdaycake"]=true,["j_kranlaxs_colasoda"]=true,["j_kranlaxs_icecreamsandwich"]=true,["j_kranlaxs_bottledwater"]=true,["j_kranlaxs_sushi"]=true,["j_kranlaxs_grapesoda"]=true}})
SMODS.ObjectType({key="kranlaxs_mycustom_jokers",cards={["j_kranlaxs_cashback"]=true,["j_kranlaxs_underratedjoker"]=true,["j_kranlaxs_facelessaccountant"]=true,["j_kranlaxs_thefixer"]=true,["j_kranlaxs_mysteriousgeode"]=true,["j_kranlaxs_benchwarmer"]=true,["j_kranlaxs_entropy2"]=true}})
SMODS.ObjectType({key="kranlaxs_kranlaxs_jokers",cards={["j_kranlaxs_greedyleprachaun"]=true,["j_kranlaxs_russianroulette"]=true,["j_kranlaxs_fidelitycard"]=true,["j_kranlaxs_pyromaniac"]=true,["j_kranlaxs_devioussheep"]=true,["j_kranlaxs_lifeassurance"]=true,["j_kranlaxs_thechampion"]=true,["j_kranlaxs_miner"]=true,["j_kranlaxs_mandalajoker"]=true,["j_kranlaxs_regift"]=true,["j_kranlaxs_vipsuscription"]=true,["j_kranlaxs_painterjoker"]=true,["j_kranlaxs_chronometer"]=true,["j_kranlaxs_zombiejoker"]=true,["j_kranlaxs_thecousin"]=true,["j_kranlaxs_dispensermachine"]=true,["j_kranlaxs_burrow"]=true,["j_kranlaxs_neverendinggambling"]=true,["j_kranlaxs_gigachad"]=true,["j_kranlaxs_nft"]=true,["j_kranlaxs_beanstalk"]=true,["j_kranlaxs_suspiciousbeanstalk"]=true,["j_kranlaxs_epicbeanstalk"]=true,["j_kranlaxs_commonseed"]=true,["j_kranlaxs_weirdlookingseed"]=true,["j_kranlaxs_magnificentseed"]=true,["j_kranlaxs_zenithbeanstalk"]=true,["j_kranlaxs_godseed"]=true,["j_kranlaxs_anonymousjoker"]=true,["j_kranlaxs_littlebro"]=true,["j_kranlaxs_solarsystem"]=true,["j_kranlaxs_medusa"]=true,["j_kranlaxs_unkownfactor"]=true,["j_kranlaxs_grannyjoker"]=true,["j_kranlaxs_lateshippment"]=true,["j_kranlaxs_depression"]=true,["j_kranlaxs_thethreers"]=true,["j_kranlaxs_the"]=true,["j_kranlaxs_chainreaction"]=true,["j_kranlaxs_anubis"]=true,["j_kranlaxs_erraticjoker"]=true,["j_kranlaxs_luckyseven"]=true,["j_kranlaxs_certificateddocument"]=true,["j_kranlaxs_platanito"]=true,["j_kranlaxs_cubicaljoker"]=true,["j_kranlaxs_grapesoda"]=true,["j_kranlaxs_telescope"]=true,["j_kranlaxs_pandorabox"]=true,["j_kranlaxs_doppelganger"]=true,["j_kranlaxs_speedrunner"]=true,["j_kranlaxs_coronation"]=true,["j_kranlaxs_passcode"]=true}})
SMODS.ObjectType({key="kranlaxs_prey",cards={["j_kranlaxs_charismaticbard"]=true,["j_kranlaxs_panda"]=true,["j_kranlaxs_bunny"]=true}})
SMODS.ObjectType({key="kranlaxs_kranlax_challenge",cards={["j_kranlaxs_sundaycheckpoint"]=true}})
SMODS.ObjectType({key="kranlaxs_kranlaxs_weekcha",cards={["j_kranlaxs_weeklychallenge"]=true}})

my_mod.optional_features=function() return{cardareas={}} end

-- Utilidades Generales
if not SMODS.kranlaxs_joker_select_hooked then
    local orig_update=Game.update
    function Game:update(dt) orig_update(self,dt) if G.jokers and G.jokers.config.highlighted_limit==0 then G.jokers.config.highlighted_limit=1 end end
    SMODS.kranlaxs_joker_select_hooked=true
end

if not SMODS.clover_sticker_hooked then
    local original_calculate_joker=Card.calculate_joker
    function Card:calculate_joker(context,...)
        if not (self.ability and self.ability.clover) then return original_calculate_joker(self,context,...) end
        local original_prob=G.GAME.probabilities.normal
        G.GAME.probabilities.normal=original_prob*2
        local r1,r2,r3,r4,r5,r6=original_calculate_joker(self,context,...)
        G.GAME.probabilities.normal=original_prob
        return r1,r2,r3,r4,r5,r6
    end
    SMODS.clover_sticker_hooked=true
end

local original_shop_setup=G.FUNCS.shop_setup
G.FUNCS.shop_setup=function(e)
    if G.GAME and G.GAME.selected_back and G.GAME.selected_back.effect.center.key=='b_kranlaxs_chaos_deck' and G.GAME.shop then G.GAME.shop.voucher_max=0 end
    original_shop_setup(e)
end

my_mod.config_tab=function()
    return{n=G.UIT.ROOT,config={align="cm",padding=0.05,colour=G.C.CLEAR},nodes={
        {n=G.UIT.R,config={align="cm",padding=0.1},nodes={create_toggle({label="Unlock Weekly Challenge deck freely",ref_table=my_mod.config,ref_value="free_weekly_deck"})}},
        {n=G.UIT.R,config={align="cm",padding=0.1},nodes={create_toggle({label="Enable Suggestive Sprites",ref_table=my_mod.config,ref_value="suggestive_sprites"})}},
        {n=G.UIT.R,config={align="cm",padding=0.05},nodes={{n=G.UIT.T,config={text="(Changes require game restart to take effect)",scale=0.35,colour=G.C.RED}}}},
        {n=G.UIT.R,config={align="cm",padding=0.2},nodes={{n=G.UIT.T,config={text="Thank you for giving a chance to my mod :3",scale=0.4,colour=G.C.UI.TEXT_LIGHT}}}}
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

-- ==============================================================================
-- HOOKS: MEMORIA DE LA CARTA REPLAY (UNO)
-- ==============================================================================
if not SMODS.kranlaxs_replay_hooks then
    
    -- 1. Tomar la "foto" de las cartas al momento de jugarlas
    local orig_play_cards = G.FUNCS.play_cards_from_highlighted
    G.FUNCS.play_cards_from_highlighted = function(e)
        if G.GAME then
            G.GAME.kranlaxs_replay_memory = {}
            if G.hand and G.hand.highlighted then
                for i = 1, #G.hand.highlighted do
                    -- Guardamos la referencia exacta de cada carta seleccionada
                    table.insert(G.GAME.kranlaxs_replay_memory, G.hand.highlighted[i])
                end
            end
        end
        orig_play_cards(e)
    end

    -- 2. Limpiar la memoria al terminar la ronda (Pantalla de recompensas)
    local orig_cash_out = G.FUNCS.cash_out
    G.FUNCS.cash_out = function(e)
        if G.GAME then G.GAME.kranlaxs_replay_memory = {} end
        orig_cash_out(e)
    end
    
    -- 3. Seguro extra: Limpiar la memoria al seleccionar una nueva ciega
    local orig_set_blind = Blind.set_blind
    function Blind:set_blind(blind, reset, silent)
        orig_set_blind(self, blind, reset, silent)
        if G.GAME then G.GAME.kranlaxs_replay_memory = {} end
    end

    SMODS.kranlaxs_replay_hooks = true
end

-- ==============================================================================
-- HOOK: PROTECCIÓN PASIVA DE SHIELD (UNO)
-- ==============================================================================
if not SMODS.kranlaxs_shield_endround_hook then
    local orig_end_round = end_round
    end_round = function()
        -- Si la ronda se acaba y NO tenemos las fichas necesarias (Vamos a morir)
        if G.GAME and G.GAME.blind and G.GAME.chips < G.GAME.blind.chips then
            
            local shield_card = nil
            if G.consumeables and G.consumeables.cards then
                for _, v in ipairs(G.consumeables.cards) do
                    if v.config.center.key == 'c_kranlaxs_shield' and not v.getting_sliced then
                        shield_card = v
                        break
                    end
                end
            end
            
            if shield_card then
                -- ¡Salvación de último milisegundo!
                shield_card.getting_sliced = true
                
                -- Engañamos al juego dándote los puntos exactos para sobrevivir
                G.GAME.chips = G.GAME.blind.chips 
                
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = function()
                        shield_card:start_dissolve({G.C.BLUE}, nil, 1.6)
                        play_sound('tarot1')
                        return true
                    end
                }))
                card_eval_status_text(shield_card, 'extra', nil, nil, nil, {message = "¡Salvado!", colour = G.C.BLUE})
            end
        end
        
        -- Ejecutamos el final de ronda normal (que ahora creerá que sí ganaste)
        orig_end_round()
    end
    SMODS.kranlaxs_shield_endround_hook = true
end

-- ==============================================================================
-- HOOK: MEMORIA DE CUSTOM DRAW (UNO)
-- ==============================================================================
if not SMODS.kranlaxs_customdraw_hook then
    local orig_discard = G.FUNCS.discard_cards_from_highlighted
    G.FUNCS.discard_cards_from_highlighted = function(e, hook)
        -- Si tienes cartas seleccionadas y te quedan descartes disponibles, sumamos 1 al contador
        if G.GAME and G.hand and G.hand.highlighted and #G.hand.highlighted > 0 and G.GAME.current_round.discards_left > 0 then
            G.GAME.kranlaxs_custom_draw_tally = (G.GAME.kranlaxs_custom_draw_tally or 0) + 1
        end
        orig_discard(e, hook)
    end
    SMODS.kranlaxs_customdraw_hook = true
end

-- SISTEMA DE RETOS
local function req_reto(id)
    if G and G.PROFILES and G.PROFILES[G.SETTINGS.profile] then
        if G.PROFILES[G.SETTINGS.profile].all_unlocked then return true end
        if G.PROFILES[G.SETTINGS.profile].challenge_progress and G.PROFILES[G.SETTINGS.profile].challenge_progress.completed then return G.PROFILES[G.SETTINGS.profile].challenge_progress.completed[id] end
    end return false
end

-- 1. Fijación Total
SMODS.Challenge{key='reto_fijado',loc_txt={name='Fijación Total',text={"Todos los comodines","aparecen con el","sticker {C:attention}Fijado{}"}},unlocked=function() return true end,rules={custom={{id='kran_fijado_1'}},modifiers={}},jokers={},deck={type='Challenge Deck'},restrictions={banned_cards={},banned_tags={},banned_other={}}}
if not SMODS.kranlaxs_challenge_hooked then
    local orig_create_card=create_card
    function create_card(_type,area,legendary,_rarity,skip_materialize,soulable,forced_key,key_append)
        local card=orig_create_card(_type,area,legendary,_rarity,skip_materialize,soulable,forced_key,key_append)
        if card and card.ability and card.ability.set=='Joker' and G.GAME and G.GAME.challenge=='c_kranlaxs_reto_fijado' then card.pinned=true end
        return card
    end
    SMODS.kranlaxs_challenge_hooked=true
end

-- 2. Receta Familiar
SMODS.Challenge{key='reto_abuela',loc_txt={name='Receta Familiar',text={"Empiezas con una {C:attention}Abuela Alterna{} y","un {C:attention}Atajo{}, ambos {C:attention}Eternos{}.","Tamaño de mano aumentado a {C:attention}10{}.","Cualquier comodín que proporcione","{C:chips}Fichas{}, {C:mult}Multiplicador{} o {C:dark_edition}Poder (^){}","{C:attention}ESTÁ BANEADO{}."}},unlocked=function() return req_reto('c_kranlaxs_reto_fijado') end,rules={custom={{id='kran_abuela_1'}},modifiers={{id='hand_size',value=10}}},jokers={{id='j_kranlaxs_grannyjoker_alt',eternal=true},{id='j_shortcut',eternal=true}},deck={type='Challenge Deck'},restrictions={banned_cards={},banned_tags={},banned_other={}}}
if not SMODS.kranlaxs_ban_scoring_hooked then
    local orig_start_run=Game.start_run
    function Game:start_run(args)
        local reto=G.CHALLENGES and G.CHALLENGES['c_kranlaxs_reto_abuela']
        if reto and G.GAME and G.GAME.challenge=='c_kranlaxs_reto_abuela' then
            reto.restrictions.banned_cards=reto.restrictions.banned_cards or {}
            for k,v in pairs(G.P_CENTERS) do
                if v.set=='Joker' and k~='j_kranlaxs_grannyjoker_alt' then
                    local function check_config(t)
                        if type(t)~='table' then return false end
                        for key,val in pairs(t) do
                            if type(key)=='string' then
                                local kl=string.lower(key)
                                if kl=='mult' or kl=='xmult' or kl=='x_mult' or kl=='chips' or kl=='e_mult' or kl=='e_chips' or kl=='xchips' or kl=='x_chips' or kl=='h_mult' or kl=='h_x_mult' or kl=='h_chips' or kl=='t_mult' or kl=='t_chips' then return true end
                            end
                            if type(val)=='table' and check_config(val) then return true end
                        end return false
                    end
                    if check_config(v.config) then
                        local already_banned=false
                        for _,banned_item in ipairs(reto.restrictions.banned_cards) do if banned_item.id==k then already_banned=true;break end end
                        if not already_banned then table.insert(reto.restrictions.banned_cards,{id=k}) end
                    end
                end
            end
        end
        orig_start_run(self,args)
    end
    SMODS.kranlaxs_ban_scoring_hooked=true
end

-- 3. Crisis Económica
local mazo_crisis={}
for _,palo in ipairs({'S','H','C','D'}) do for i=1,13 do table.insert(mazo_crisis,{s=palo,r='A'}) end end
SMODS.Challenge{key='crisis_economica',loc_txt={name='Crisis Económica',text={"Empiezas con {C:attention}2 Criptoestafas{}","({C:attention}Eternos{} y {C:attention}Fijados{}).","El mazo está compuesto","únicamente de {C:attention}52 Ases{}.","Límite de {C:attention}3{} comodines.","Tamaño de mano: {C:attention}10{}.","{C:red}-1{} Mano por ronda.","La tienda es un {C:red}20% más cara{}.","Paga base de ciegas: {C:red}-$2{}."}},unlocked=function() return req_reto('c_kranlaxs_reto_abuela') end,rules={custom={{id='kran_crisis_1'},{id='kran_crisis_2'},{id='kran_crisis_3'}},modifiers={{id='joker_slots',value=3},{id='hand_size',value=2},{id='hands',value=-1}}},jokers={{id='j_kranlaxs_nft',eternal=true,pinned=true},{id='j_kranlaxs_nft',eternal=true,pinned=true}},deck={type='Challenge Deck',cards=mazo_crisis},restrictions={banned_cards={{id='c_ectoplasm'}},banned_tags={},banned_other={}}}
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

-- 4. Crisis de Identidad
SMODS.Challenge{key='reto_doppelganger',loc_txt={name='Crisis de Identidad',text={"Empiezas con {C:attention}5 Doppelgängers{}","({C:attention}Eternos{}).","Todos los comodines están","{C:attention}baneados{} de la tienda.","No puedes conseguir más","{C:attention}espacios de comodín{}."}},unlocked=function() return req_reto('c_kranlaxs_crisis_economica') end,rules={custom={{id='kran_doppel_1'}},modifiers={{id='joker_slots',value=5}}},jokers={{id='j_kranlaxs_doppelganger',eternal=true},{id='j_kranlaxs_doppelganger',eternal=true},{id='j_kranlaxs_doppelganger',eternal=true},{id='j_kranlaxs_doppelganger',eternal=true},{id='j_kranlaxs_doppelganger',eternal=true}},deck={type='Challenge Deck'},restrictions={banned_cards={{id='v_antimatter'},{id='c_ectoplasm'}},banned_tags={{id='tag_negative'}},banned_other={}}}
if not SMODS.kranlaxs_ban_all_jokers_hooked then
    local orig_start_run=Game.start_run
    function Game:start_run(args)
        local reto_doppel=G.CHALLENGES and G.CHALLENGES['c_kranlaxs_reto_doppelganger']
        if reto_doppel and G.GAME and G.GAME.challenge=='c_kranlaxs_reto_doppelganger' then
            reto_doppel.restrictions.banned_cards=reto_doppel.restrictions.banned_cards or {}
            for k,v in pairs(G.P_CENTERS) do
                if v.set=='Joker' then
                    local already_banned=false
                    for _,banned_item in ipairs(reto_doppel.restrictions.banned_cards) do if banned_item.id==k then already_banned=true;break end end
                    if not already_banned then table.insert(reto_doppel.restrictions.banned_cards,{id=k}) end
                end
            end
        end
        orig_start_run(self,args)
    end
    SMODS.kranlaxs_ban_all_jokers_hooked=true
end

-- 5. Anonimato Total
SMODS.Challenge{key='reto_anonimo',loc_txt={name='Anonimato Total',text={"Empiezas con un {C:attention}Joker Anónimo{}","({C:attention}Eterno{}).","Todas las cartas en tu mano y","tus comodines están {C:attention}boca abajo{}.","{C:tarot}Las Estrellas Inversas{} está {C:red}baneado{}."}},unlocked=function() return req_reto('c_kranlaxs_reto_doppelganger') end,rules={custom={{id='kran_anonimo_1'}},modifiers={}},jokers={{id='j_kranlaxs_anonymousjoker',eternal=true}},deck={type='Challenge Deck'},restrictions={banned_cards={{id='c_kranlaxs_thestars'}},banned_tags={},banned_other={}}}
if not SMODS.kranlaxs_anonymous_flip_hooked then
    local orig_card_update=Card.update
    function Card:update(dt) orig_card_update(self,dt);if G.GAME and G.GAME.challenge=='c_kranlaxs_reto_anonimo' and (self.area==G.hand or self.area==G.jokers) then if self.facing~='back' then self.facing='back' end if self.sprite_facing~='back' then self.sprite_facing='back' end end end
    SMODS.kranlaxs_anonymous_flip_hooked=true
end

-- 6. Sindicato de Jefes
SMODS.Challenge{key='reto_jefes',loc_txt={name='Sindicato de Jefes',text={"Las Ciegas Pequeñas y Grandes","son reemplazadas por {C:attention}Ciegas Jefe{}.","No hay rondas de descanso."}},unlocked=function() return req_reto('c_kranlaxs_reto_anonimo') end,rules={custom={{id='kran_jefes_1'}},modifiers={}},jokers={},deck={type='Challenge Deck'},restrictions={banned_cards={},banned_tags={},banned_other={}}}
if not SMODS.kranlaxs_all_bosses_hooked then
    local orig_update=Game.update
    function Game:update(dt) orig_update(self,dt);if G.GAME and G.GAME.challenge=='c_kranlaxs_reto_jefes' and G.GAME.round_resets and G.GAME.round_resets.blind_choices then if G.GAME.round_resets.blind_choices.Small=='bl_small' then G.GAME.round_resets.blind_choices.Small=get_new_boss() end if G.GAME.round_resets.blind_choices.Big=='bl_big' then G.GAME.round_resets.blind_choices.Big=get_new_boss() end end end
    local orig_start_run=Game.start_run
    function Game:start_run(args) orig_start_run(self,args);if G.GAME and G.GAME.challenge=='c_kranlaxs_reto_jefes' and G.GAME.round_resets and G.GAME.round_resets.blind_choices then if G.GAME.round_resets.blind_choices.Small=='bl_small' then G.GAME.round_resets.blind_choices.Small=get_new_boss() end if G.GAME.round_resets.blind_choices.Big=='bl_big' then G.GAME.round_resets.blind_choices.Big=get_new_boss() end end end
    SMODS.kranlaxs_all_bosses_hooked=true
end

-- 7. Premoniciones
SMODS.Challenge{key='reto_premonisiones',loc_txt={name='Premoniciones',text={"Empiezas con un {C:attention}Filósofo{}","({C:attention}Eterno{} y {C:attention}Fijado{}).","Todas las cartas en tu mano","están {C:attention}boca abajo{}."}},unlocked=function() return req_reto('c_kranlaxs_reto_jefes') end,rules={custom={{id='kran_premon_1'}},modifiers={}},jokers={{id='j_kranlaxs_philosopher',eternal=true,pinned=true}},deck={type='Challenge Deck'},restrictions={banned_cards={},banned_tags={},banned_other={}}}
if not SMODS.kranlaxs_premoniciones_flip_hooked then
    local orig_card_update=Card.update
    function Card:update(dt) orig_card_update(self,dt);if G.GAME and G.GAME.challenge=='c_kranlaxs_reto_premonisiones' and self.area==G.hand then if self.facing~='back' then self.facing='back' end if self.sprite_facing~='back' then self.sprite_facing='back' end end end
    SMODS.kranlaxs_premoniciones_flip_hooked=true
end

-- 8. El Gran Tallo
SMODS.Challenge{key='reto_tallo',loc_txt={name='El Gran Tallo',text={"Empiezas con {C:attention}2 Tallos de Frijol{}.","Todos los demás comodines y","{C:attention}Paquetes de Bufón{} están {C:red}baneados{}."}},unlocked=function() return req_reto('c_kranlaxs_reto_premonisiones') end,rules={custom={{id='kran_tallo_1'}},modifiers={}},jokers={{id='j_kranlaxs_beanstalk'},{id='j_kranlaxs_beanstalk'}},deck={type='Challenge Deck'},restrictions={banned_cards={},banned_tags={{id='tag_buffoon'},{id='tag_rare'},{id='tag_uncommon'},{id='tag_foil'},{id='tag_holographic'},{id='tag_polychrome'},{id='tag_negative'},{id='tag_top_hat'}},banned_other={}}}
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

-- 9. Gachapón
SMODS.Challenge{key='reto_gachapon',loc_txt={name='Gachapón',text={"Tu ludopatía ha","llegado a un nuevo límite.","¡Solo abre sobres y confía en tu suerte!"}},unlocked=function() return req_reto('c_kranlaxs_reto_tallo') end,rules={custom={{id='gacha_rule_1'}},modifiers={{id='dollars',value=14}}},jokers={},vouchers={{id='v_reroll_surplus'},{id='v_reroll_glut'}},deck={type='Challenge Deck'},restrictions={banned_cards={},banned_tags={{id='tag_buffoon'},{id='tag_rare'},{id='tag_uncommon'},{id='tag_foil'},{id='tag_holographic'},{id='tag_polychrome'},{id='tag_negative'},{id='tag_top_hat'}},banned_other={}}}
if not SMODS.kranlaxs_gachapon_shop_hooked then
    local orig_update=Game.update
    function Game:update(dt) orig_update(self,dt);if G.GAME and G.GAME.challenge=='c_kranlaxs_reto_gachapon' and G.GAME.shop then G.GAME.shop.joker_max=4 end end
    local orig_create_card=create_card
    function create_card(_type,area,legendary,rarity,skip_materialize,soulable,forced_key,key_append)
        if G.GAME and G.GAME.challenge=='c_kranlaxs_reto_gachapon' and area==G.shop_jokers and not forced_key then _type='Booster' end
        return orig_create_card(_type,area,legendary,rarity,skip_materialize,soulable,forced_key,key_append)
    end
    SMODS.kranlaxs_gachapon_shop_hooked=true
end

-- 10. Voto de Pobreza
SMODS.Challenge{key='reto_pobreza',loc_txt={name='Voto de Pobreza',text={"Empiezas con una economía fuerte,","gran inventario y 3 Comodines {C:attention}Eternos{}.","Los comodines {C:blue}Comunes{} en la tienda","tienen un {C:green}50%{} de ser {C:legendary}Legendarios{}.","Si tu {C:attention}Monje{} se decepciona al salir","de la tienda, es {C:red}Fin de la Partida{}."}},unlocked=function() return req_reto('c_kranlaxs_reto_gachapon') end,rules={custom={{id='kran_pobreza_1'},{id='kran_pobreza_2'}},modifiers={}},jokers={{id='j_kranlaxs_monk',eternal=true,pinned=true},{id='j_cartomancer',eternal=true,pinned=true,edition='negative'},{id='j_kranlaxs_solarsystem',eternal=true,pinned=true,edition='negative'}},vouchers={{id='v_overstock_norm'},{id='v_overstock_plus'},{id='v_clearance_sale'},{id='v_liquidation'},{id='v_crystal_ball'},{id='v_seed_money'},{id='v_money_tree'}},deck={type='Challenge Deck'},restrictions={banned_cards={},banned_tags={},banned_other={}}}
if not SMODS.kranlaxs_pobreza_legendary_hook then
    local orig_create_card=create_card
    function create_card(_type,area,legendary,_rarity,skip_materialize,soulable,forced_key,key_append)
        local card=orig_create_card(_type,area,legendary,_rarity,skip_materialize,soulable,forced_key,key_append)
        if G.GAME and G.GAME.challenge=='c_kranlaxs_reto_pobreza' and card and card.ability and card.ability.set=='Joker' and not forced_key and area==G.shop_jokers then
            if card.config.center.rarity==1 and pseudorandom('pobreza_leg')<0.5 then card:remove();card=orig_create_card('Joker',area,true,4,skip_materialize,soulable,nil,key_append) end
        end return card
    end
    SMODS.kranlaxs_pobreza_legendary_hook=true
end

-- ==============================================================================
-- NUEVA DIFICULTAD: APUESTA MAGENTA
-- ==============================================================================
SMODS.Stake{key='magenta',name='Magenta Stake',above_stake='gold',applied_stakes={'gold'},prefix_config={above_stake={mod=false},applied_stakes={mod=false}},pos={x=0,y=0},atlas='CustomStakes',sticker_atlas='CustomCompletation',sticker_pos={x=1,y=0},colour=HEX("FF00FF"),modifiers=function() G.GAME.modifiers.kranlaxs_magenta_pinned=true end}
if not SMODS.kranlaxs_magenta_pinned_hook then
    local orig_create_card=create_card
    function create_card(_type,area,legendary,_rarity,skip_materialize,soulable,forced_key,key_append)
        local card=orig_create_card(_type,area,legendary,_rarity,skip_materialize,soulable,forced_key,key_append)
        if G.GAME and G.GAME.modifiers and G.GAME.modifiers.kranlaxs_magenta_pinned then if area==G.shop_jokers then if card and card.ability and (card.ability.set=='Joker' or card.ability.consumeable) then if pseudorandom('magenta_pinned')<0.3 then card.pinned=true end end end end
        return card
    end
    SMODS.kranlaxs_magenta_pinned_hook=true
end

-- ==============================================================================
-- NUEVA DIFICULTAD: APUESTA MARRÓN
-- ==============================================================================
SMODS.Stake{key='brown',name='Brown Stake',above_stake='kranlaxs_magenta',applied_stakes={'kranlaxs_magenta'},pos={x=1,y=1},atlas='CustomStakes',sticker_atlas='CustomCompletation',sticker_pos={x=2,y=0},colour=HEX("883200"),modifiers=function() G.E_MANAGER:add_event(Event({func=function() SMODS.change_booster_limit(-1);return true end,})) end}

-- ==============================================================================
-- NUEVA DIFICULTAD: APUESTA TURQUESA
-- ==============================================================================
SMODS.Stake{key='turquoise',name='Turquoise Stake',above_stake='kranlaxs_brown',applied_stakes={'kranlaxs_brown'},pos={x=2,y=0},atlas='CustomStakes',sticker_atlas='CustomCompletation',sticker_pos={x=3,y=0},colour=HEX("40E0D0"),modifiers=function() G.GAME.modifiers.kranlaxs_turquoise_noskip=true end}
if not SMODS.kranlaxs_turquoise_hook then
    local orig_skip_blind=G.FUNCS.skip_blind
    G.FUNCS.skip_blind=function(e)
        if G.GAME and G.GAME.modifiers.kranlaxs_turquoise_noskip then
            local current_seed='turq_skip_'..G.GAME.round_resets.ante..'_'..G.GAME.round
            if pseudorandom(current_seed)<0.5 then
                play_sound('timpani');if e.config and e.config.ref_table then e.config.ref_table:juice_up() end
                attention_text({text="¡Bloqueado!",scale=0.9,hold=1.5,colour=G.C.RED,align='cm',offset={x=0,y=-1.5},major=e})
                return
            end
        end
        orig_skip_blind(e)
    end
    SMODS.kranlaxs_turquoise_hook=true
end

-- ==============================================================================
-- NUEVA DIFICULTAD: POZO DIABÓLICO
-- ==============================================================================
SMODS.Stake{
    key = 'deviled',
    name = 'Deviled Stake',
    above_stake = 'kranlaxs_turquoise',
    applied_stakes = {'kranlaxs_turquoise'},
    pos = {x = 0, y = 1},
    atlas = 'CustomStakes',
    sticker_atlas = 'CustomCompletation',
    sticker_pos = {x = 5, y = 0},
    colour = HEX("8B0000"), -- Rojo oscuro
    modifiers = function() 
        G.GAME.starting_params.joker_slots = G.GAME.starting_params.joker_slots - 1 
    end
}

-- ==============================================================================
-- NUEVA DIFICULTAD: POZO DE CRISTAL
-- ==============================================================================
SMODS.Stake{
    key = 'glass',
    name = 'Glass Stake',
    above_stake = 'kranlaxs_deviled',
    applied_stakes = {'kranlaxs_deviled'},
    pos = {x = 3, y = 1},
    atlas = 'CustomStakes',
    sticker_atlas = 'CustomCompletation',
    sticker_pos = {x = 6, y = 0},
    colour = HEX("A6F2ED"), -- Cian cristalino
    modifiers = function() 
        G.GAME.modifiers.kranlaxs_glass_scaling = true 
    end
}

-- Hook para hacer que las ciegas escalen aún más rápido
if not SMODS.kranlaxs_glass_stake_hook then
    local orig_get_blind_amount = get_blind_amount
    function get_blind_amount(ante)
        local amt = orig_get_blind_amount(ante)
        -- Si estamos en Pozo de Cristal y pasamos del Ante 1, multiplica el requisito exponencialmente
        if G.GAME and G.GAME.modifiers and G.GAME.modifiers.kranlaxs_glass_scaling and ante >= 2 then
            amt = amt * (1.25 ^ (ante - 1))
        end
        return amt
    end
    SMODS.kranlaxs_glass_stake_hook = true
end

-- ==============================================================================
-- NUEVA DIFICULTAD: APUESTA DE PLATINO (ACTUALIZADA)
-- ==============================================================================
SMODS.Stake{
    key = 'platinum',
    name = 'Platinum Stake',
    above_stake = 'kranlaxs_glass',
    applied_stakes = {'kranlaxs_glass'},
    pos = {x = 4, y = 0},
    atlas = 'CustomStakes',
    sticker_atlas = 'CustomCompletation',
    sticker_pos = {x = 4, y = 0},
    colour = HEX("E5E4E2"),
    modifiers = function() 
        G.GAME.win_ante = (G.GAME.win_ante or 8) + 2 
    end
}