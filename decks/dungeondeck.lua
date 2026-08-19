

-- ==============================================================================
-- DICCIONARIO DE TRADUCCIONES (10 IDIOMAS)
-- ==============================================================================
local dungeon_loc = {
    ['es_419'] = {
        title = "RECOMPENSA DEL JEFE", subtitle = "Elige tu perdición (No puedes omitir)",
        [1]="+1 Mano permanente, -$50", [2]="+1 Descarte permanente, -$40", [3]="+1 Slot de Joker, -50% de tu dinero",
        [4]="+1 Slot Consumible, -25% de tu dinero", [5]="+1 Tamaño de Mano, destruye un Joker", [6]="+$50 instantáneos, -1 Tamaño de Mano",
        [7]="Sin Comunes, Tienda 50% más cara", [8]="Sin Inusuales, Tienda 100% más cara", [9]="Crea Cuarzo Rosa, 1 Joker obtiene Renta",
        [10]="Crea Zafiro, 1 Joker obtiene Perecedero", [11]="Crea Kunzita, 1 Joker obtiene Eterno", [12]="Crea Hematita, 1 Joker se maldice",
        [13]="-$2 Costo de Reroll, destruye 1 Joker", [14]="Reroll afecta Vales/Boosters, Dinero = 0", [15]="Clona todos tus Jokers, Ciegas x3",
        [16]="-2 Apuestas (Ante), Ciegas x1.5", [17]="Opciones de Paquete +1, Jokers Fijados", [18]="Randomiza todos los Jokers y Consumibles",
        [19]="+3 Slots de Joker, Baraja Limpia", [20]="+5 Tamaño de Mano, Baraja Limpia", [21]="+3 Descartes, Baraja Limpia",
        [22]="+4 Vales Random, -1 Mano y Descarte", [23]="-4 Apuestas (Ante), Baraja Limpia", [24]="Límite de Interés x2, +2 Apuestas (Ante)",
        [25]="Legendarios en Tienda, 200% más caro", [26]="+1 Max. Booster y Vale, -3 Max. Jokers", [27]="Tienda sin Stickers, -2 Slots Joker",
        [28]="Limpia 1 Sticker de un Joker, -$10"
    },
    ['en-us'] = {
        title = "BOSS REWARD", subtitle = "Choose your doom (Cannot skip)",
        [1]="+1 permanent Hand, -$50", [2]="+1 permanent Discard, -$40", [3]="+1 Joker Slot, -50% of your money",
        [4]="+1 Consumable Slot, -25% of your money", [5]="+1 Hand Size, destroys a Joker", [6]="+$50 instantly, -1 Hand Size",
        [7]="No Commons, Shop is 50% more expensive", [8]="No Uncommons, Shop is 100% more expensive", [9]="Create Pink Quartz, 1 Joker gets Rental",
        [10]="Create Sapphire, 1 Joker gets Perishable", [11]="Create Kunzite, 1 Joker gets Eternal", [12]="Create Hematite, 1 Joker gets Cursed",
        [13]="-$2 Reroll Cost, destroys 1 Joker", [14]="Reroll affects Vouchers/Packs, Money = 0", [15]="Clone all your Jokers, Blinds x3",
        [16]="-2 Antes, Blinds x1.5", [17]="Pack Choices +1, Jokers Pinned", [18]="Randomize all Jokers and Consumables",
        [19]="+3 Joker Slots, Clean Deck", [20]="+5 Hand Size, Clean Deck", [21]="+3 Discards, Clean Deck",
        [22]="+4 Random Vouchers, -1 Hand and Discard", [23]="-4 Antes, Clean Deck", [24]="Interest Cap x2, +2 Antes",
        [25]="Legendaries in Shop, 200% more expensive", [26]="+1 Max Pack and Voucher, -3 Max Jokers", [27]="No Stickers in Shop, -2 Joker Slots",
        [28]="Clean 1 Sticker from a Joker, -$10"
    },
    ['pt_BR'] = {
        title = "RECOMPENSA DO CHEFÃO", subtitle = "Escolha sua perdição (Não pode pular)",
        [1]="+1 Mão permanente, -$50", [2]="+1 Descarte permanente, -$40", [3]="+1 Espaço de Curinga, -50% do seu dinheiro",
        [4]="+1 Espaço de Consumível, -25% do seu dinheiro", [5]="+1 Tam. de Mão, destrói um Curinga", [6]="+$50 instantâneos, -1 Tam. de Mão",
        [7]="Sem Comuns, Loja 50% mais cara", [8]="Sem Incomuns, Loja 100% mais cara", [9]="Cria Quartzo Rosa, 1 Curinga ganha Aluguel",
        [10]="Cria Safira, 1 Curinga ganha Perecível", [11]="Cria Kunzita, 1 Curinga ganha Eterno", [12]="Cria Hematita, 1 Curinga é Amaldiçoado",
        [13]="-$2 Custo de Reroll, destrói 1 Curinga", [14]="Reroll afeta Vales/Pacotes, Dinheiro = 0", [15]="Clona todos os seus Curingas, Blinds x3",
        [16]="-2 Apostas (Ante), Blinds x1.5", [17]="Opções de Pacote +1, Curingas Fixados", [18]="Aleatoriza Curingas e Consumíveis",
        [19]="+3 Espaços de Curinga, Baralho Limpo", [20]="+5 Tam. de Mão, Baralho Limpo", [21]="+3 Descartes, Baralho Limpo",
        [22]="+4 Vales Aleatórios, -1 Mão e Descarte", [23]="-4 Apostas, Baralho Limpo", [24]="Limite de Juros x2, +2 Apostas",
        [25]="Lendários na Loja, 200% mais cara", [26]="+1 Máx. Pacote e Vale, -3 Máx. Curingas", [27]="Sem Adesivos na Loja, -2 Espaços Curinga",
        [28]="Limpa 1 Adesivo de um Curinga, -$10"
    },
    ['fr'] = {
        title = "RÉCOMPENSE DE BOSS", subtitle = "Choisissez votre destin (Impossible de passer)",
        [1]="+1 Main permanente, -50$", [2]="+1 Défausse permanente, -40$", [3]="+1 Emplac. de Joker, -50% de votre argent",
        [4]="+1 Emplac. Consommable, -25% de votre argent", [5]="+1 Taille de Main, détruit un Joker", [6]="+50$ instantanés, -1 Taille de Main",
        [7]="Pas de Communs, Boutique 50% plus chère", [8]="Pas d'Inhabituels, Boutique 100% plus chère", [9]="Crée Quartz Rose, 1 Joker devient Location",
        [10]="Crée Saphir, 1 Joker devient Périssable", [11]="Crée Kunzite, 1 Joker devient Éternel", [12]="Crée Hématite, 1 Joker est Maudit",
        [13]="-2$ Coût Relance, détruit 1 Joker", [14]="Relance affecte Bons/Paquets, Argent = 0", [15]="Clone tous vos Jokers, Blindes x3",
        [16]="-2 Mises (Ante), Blindes x1.5", [17]="Choix de Paquets +1, Jokers Épinglés", [18]="Aléatoirise Jokers et Consommables",
        [19]="+3 Emplac. de Joker, Jeu Propre", [20]="+5 Taille de Main, Jeu Propre", [21]="+3 Défausses, Jeu Propre",
        [22]="+4 Bons Aléatoires, -1 Main et Défausse", [23]="-4 Mises, Jeu Propre", [24]="Plafond d'Intérêts x2, +2 Mises",
        [25]="Légendaires en Boutique, 200% plus chère", [26]="+1 Max Paquet et Bon, -3 Max Jokers", [27]="Pas d'Autocollants, -2 Jokers",
        [28]="Nettoie 1 Autocollant d'un Joker, -10$"
    },
    ['it'] = {
        title = "RICOMPENSA DEL BOSS", subtitle = "Scegli il tuo destino (Non puoi saltare)",
        [1]="+1 Mano permanente, -$50", [2]="+1 Scarto permanente, -$40", [3]="+1 Slot Joker, -50% dei tuoi soldi",
        [4]="+1 Slot Consumabile, -25% dei tuoi soldi", [5]="+1 Dimen. Mano, distrugge un Joker", [6]="+$50 istantanei, -1 Dimen. Mano",
        [7]="Niente Comuni, Negozio 50% più caro", [8]="Niente Non Comuni, Negozio 100% più caro", [9]="Crea Quarzo Rosa, 1 Joker a Noleggio",
        [10]="Crea Zaffiro, 1 Joker diventa Deperibile", [11]="Crea Kunzite, 1 Joker diventa Eterno", [12]="Crea Ematite, 1 Joker viene Maledetto",
        [13]="-$2 Costo Reroll, distrugge 1 Joker", [14]="Reroll vale per Voucher/Pacchetti, Soldi = 0", [15]="Clona tutti i tuoi Joker, Bui x3",
        [16]="-2 Ante, Bui x1.5", [17]="Scelte Pacchetto +1, Joker Fissati", [18]="Randomizza tutti i Joker e Consumabili",
        [19]="+3 Slot Joker, Mazzo Pulito", [20]="+5 Dimen. Mano, Mazzo Pulito", [21]="+3 Scarti, Mazzo Pulito",
        [22]="+4 Voucher Casuali, -1 Mano e Scarto", [23]="-4 Ante, Mazzo Pulito", [24]="Limite Interessi x2, +2 Ante",
        [25]="Leggendari nel Negozio, 200% più caro", [26]="+1 Max Pacchetto e Voucher, -3 Max Joker", [27]="Niente Adesivi nel Negozio, -2 Slot Joker",
        [28]="Pulisci 1 Adesivo da un Joker, -$10"
    },
    ['de'] = {
        title = "BOSS-BELOHNUNG", subtitle = "Wähle dein Schicksal (Nicht überspringbar)",
        [1]="+1 perm. Hand, -$50", [2]="+1 perm. Abwerfen, -$40", [3]="+1 Joker-Slot, -50% deines Geldes",
        [4]="+1 Verbrauchs-Slot, -25% deines Geldes", [5]="+1 Handgröße, zerstört einen Joker", [6]="+$50 sofort, -1 Handgröße",
        [7]="Keine Gewöhnlichen, Shop 50% teurer", [8]="Keine Ungewöhnlichen, Shop 100% teurer", [9]="Erschaffe Rosenquarz, 1 Joker wird Miete",
        [10]="Erschaffe Saphir, 1 Joker wird Verderblich", [11]="Erschaffe Kunzit, 1 Joker wird Ewig", [12]="Erschaffe Hämatit, 1 Joker wird Verflucht",
        [13]="-$2 Reroll-Kosten, zerstört 1 Joker", [14]="Reroll betrifft Gutscheine/Packs, Geld = 0", [15]="Klone alle deine Joker, Blinds x3",
        [16]="-2 Einsätze (Ante), Blinds x1.5", [17]="Pack-Auswahl +1, Joker Gepinnt", [18]="Zufällige Joker und Verbrauchsgüter",
        [19]="+3 Joker-Slots, Sauberes Deck", [20]="+5 Handgröße, Sauberes Deck", [21]="+3 Abwerfen, Sauberes Deck",
        [22]="+4 Zufällige Gutscheine, -1 Hand & Abwerfen", [23]="-4 Einsätze, Sauberes Deck", [24]="Zinslimit x2, +2 Einsätze",
        [25]="Legendäre im Shop, 200% teurer", [26]="+1 Max Pack & Gutschein, -3 Max Joker", [27]="Keine Sticker im Shop, -2 Joker-Slots",
        [28]="Entfernt 1 Sticker von einem Joker, -$10"
    },
    ['ru'] = {
        title = "НАГРАДА БОССА", subtitle = "Выбери свою судьбу (Нельзя пропустить)",
        [1]="+1 Раздача навсегда, -$50", [2]="+1 Сброс навсегда, -$40", [3]="+1 Слот Джокера, -50% от ваших денег",
        [4]="+1 Слот Расходника, -25% от ваших денег", [5]="+1 Размер руки, уничтожает 1 Джокера", [6]="+$50 мгновенно, -1 Размер руки",
        [7]="Без обычных, Магазин на 50% дороже", [8]="Без необычных, Магазин на 100% дороже", [9]="Создать Розовый Кварц, 1 Джокер в Аренду",
        [10]="Создать Сапфир, 1 Джокер Скоропортящийся", [11]="Создать Кунцит, Джокер становится Вечным", [12]="Создать Гематит, 1 Джокер Проклят",
        [13]="-$2 Стоимость реролла, уничтожает 1 Джокера", [14]="Реролл влияет на Ваучеры/Наборы, Деньги = 0", [15]="Клонировать всех Джокеров, Блайнды x3",
        [16]="-2 Анте, Блайнды x1.5", [17]="Выбор из набора +1, Джокеры Приколоты", [18]="Случайные Джокеры и Расходники",
        [19]="+3 Слота Джокеров, Чистая колода", [20]="+5 Размер руки, Чистая колода", [21]="+3 Сброса, Чистая колода",
        [22]="+4 Случайных ваучера, -1 Рука и Сброс", [23]="-4 Анте, Чистая колода", [24]="Лимит процентов x2, +2 Анте",
        [25]="Легендарные в магазине, на 200% дороже", [26]="+1 Макс Набор и Ваучер, -3 Макс Джокера", [27]="В магазине без наклеек, -2 Слота Джокеров",
        [28]="Очистить 1 наклейку с Джокера, -$10"
    },
    ['ko'] = {
        title = "보스 보상", subtitle = "운명을 선택하세요 (건너뛰기 불가)",
        [1]="+1 영구 핸드, -$50", [2]="+1 영구 버리기, -$40", [3]="+1 조커 슬롯, 소지 금액의 50% 감소",
        [4]="+1 소모품 슬롯, 소지 금액의 25% 감소", [5]="+1 핸드 크기, 조커 1장 파괴", [6]="즉시 +$50, -1 핸드 크기",
        [7]="커먼 없음, 상점 가격 50% 상승", [8]="언커먼 없음, 상점 가격 100% 상승", [9]="장미석 생성, 조커 1장에 렌탈 부여",
        [10]="사파이어 생성, 조커 1장에 소멸 부여", [11]="쿤자이트 생성, 조커 1장에 이터널 부여", [12]="적철석 생성, 조커 1장에 저주 부여",
        [13]="-$2 리롤 비용, 조커 1장 파괴", [14]="리롤이 바우처/팩에 적용, 소지 금액 = 0", [15]="모든 조커 복제, 블라인드 요구량 x3",
        [16]="-2 앤티, 블라인드 요구량 x1.5", [17]="팩 선택지 +1, 조커 고정됨", [18]="모든 조커와 소모품 무작위 변경",
        [19]="+3 조커 슬롯, 깔끔한 덱", [20]="+5 핸드 크기, 깔끔한 덱", [21]="+3 버리기, 깔끔한 덱",
        [22]="+4 무작위 바우처, -1 핸드 및 버리기", [23]="-4 앤티, 깔끔한 덱", [24]="이자 한도 x2, +2 앤티",
        [25]="상점에 레전더리 등장, 상점 가격 200% 상승", [26]="+1 최대 팩 및 바우처, -3 최대 조커", [27]="상점 스티커 없음, -2 조커 슬롯",
        [28]="조커의 스티커 1개 제거, -$10"
    },
    ['ja'] = {
        title = "ボスの報酬", subtitle = "運命を選べ（スキップ不可）",
        [1]="+1 恒久ハンド, -$50", [2]="+1 恒久ディスカード, -$40", [3]="+1 ジョーカースロット, 所持金の50%減少",
        [4]="+1 消費アイテムスロット, 所持金の25%減少", [5]="+1 ハンドサイズ, ジョーカーを1枚破壊", [6]="即座に+$50, -1 ハンドサイズ",
        [7]="コモンなし, ショップ価格50%上昇", [8]="アンコモンなし, ショップ価格100%上昇", [9]="ローズクォーツを生成, ジョーカー1枚がレンタル化",
        [10]="サファイアを生成, ジョーカー1枚が期限付き化", [11]="クンツァイトを生成, ジョーカー1枚がエターナル化", [12]="ヘマタイトを生成, ジョーカー1枚が呪われる",
        [13]="-$2 リロールコスト, ジョーカーを1枚破壊", [14]="リロールがバウチャー/パックに適用, 所持金 = 0", [15]="すべてのジョーカーを複製, ブラインド x3",
        [16]="-2 アンテ, ブラインド x1.5", [17]="パックの選択肢 +1, ジョーカーをピン留め", [18]="ジョーカーと消費アイテムをすべてランダム化",
        [19]="+3 ジョーカースロット, クリーンデッキ", [20]="+5 ハンドサイズ, クリーンデッキ", [21]="+3 ディスカード, クリーンデッキ",
        [22]="+4 ランダムバウチャー, -1 ハンドとディスカード", [23]="-4 アンテ, クリーンデッキ", [24]="利子上限 x2, +2 アンテ",
        [25]="ショップにレジェンダリー出現, 価格200%上昇", [26]="+1 最大パックおよびバウチャー, -3 最大ジョーカー", [27]="ショップにステッカーなし, -2 ジョーカースロット",
        [28]="ジョーカーのステッカーを1つ消去, -$10"
    },
    ['zh_CN'] = {
        title = "Boss奖励", subtitle = "选择你的命运（不可跳过）",
        [1]="+1 永久出牌次数, -$50", [2]="+1 永久弃牌次数, -$40", [3]="+1 小丑牌槽位, 扣除50%的金钱",
        [4]="+1 消耗品槽位, 扣除25%的金钱", [5]="+1 手牌上限, 摧毁一张小丑牌", [6]="立即获得+$50, -1 手牌上限",
        [7]="不出售常见牌, 商店价格上涨50%", [8]="不出售罕见牌, 商店价格上涨100%", [9]="生成粉水晶, 1张小丑牌获得租赁贴纸",
        [10]="生成蓝宝石, 1张小丑牌获得易损贴纸", [11]="生成紫锂辉石, 1张小丑牌获得永恒贴纸", [12]="生成赤铁矿, 1张小丑牌被诅咒",
        [13]="-$2 刷新价格, 摧毁1张小丑牌", [14]="刷新影响优惠券/补充包, 金钱清零", [15]="克隆所有小丑牌, 盲注要求 x3",
        [16]="-2 底注(Ante), 盲注要求 x1.5", [17]="补充包选项 +1, 小丑牌被固定", [18]="随机化所有小丑牌和消耗品",
        [19]="+3 小丑牌槽位, 重置牌组", [20]="+5 手牌上限, 重置牌组", [21]="+3 弃牌次数, 重置牌组",
        [22]="+4 随机优惠券, -1 出牌和弃牌次数", [23]="-4 底注, 重置牌组", [24]="利息上限 x2, +2 底注",
        [25]="传奇牌出现在商店, 价格上涨200%", [26]="+1 最大补充包和优惠券, -3 最大小丑牌", [27]="商店不含贴纸, -2 小丑牌槽位",
        [28]="清除小丑牌的1个贴纸, -$10"
    }
}

local dungeon_options = {
    { id = 1, req = function() return true end, apply = function() G.GAME.round_resets.hands = G.GAME.round_resets.hands + 1; ease_dollars(-50) end },
    { id = 2, req = function() return true end, apply = function() G.GAME.round_resets.discards = G.GAME.round_resets.discards + 1; ease_dollars(-40) end },
    { id = 3, req = function() return true end, apply = function() G.jokers.config.card_limit = G.jokers.config.card_limit + 1; ease_dollars(-math.floor(G.GAME.dollars / 2)) end },
    { id = 4, req = function() return true end, apply = function() G.consumeables.config.card_limit = G.consumeables.config.card_limit + 1; ease_dollars(-math.floor(G.GAME.dollars / 4)) end },
    { id = 5, req = function() return G.jokers and #G.jokers.cards > 0 end, apply = function() G.hand.config.card_limit = G.hand.config.card_limit + 1; local j = kranlaxs_get_random_joker(); if j then j:start_dissolve(nil, true) end end },
    { id = 6, req = function() return G.hand.config.card_limit > 1 end, apply = function() ease_dollars(50); G.hand.config.card_limit = G.hand.config.card_limit - 1 end },
    { id = 7, req = function() return not G.GAME.dungeon_no_common end, apply = function() G.GAME.dungeon_no_common = true; G.GAME.dungeon_price_mod = (G.GAME.dungeon_price_mod or 1) + 0.5 end },
    { id = 8, req = function() return not G.GAME.dungeon_no_uncommon end, apply = function() G.GAME.dungeon_no_uncommon = true; G.GAME.dungeon_price_mod = (G.GAME.dungeon_price_mod or 1) + 1.0 end },
    { id = 9, req = function() return G.jokers and #G.jokers.cards > 0 end, apply = function() kranlaxs_create_consumable('c_kranlaxs_pinkquartz'); local j = kranlaxs_get_random_joker(); if j then j:set_rental(true) end end },
    { id = 10, req = function() return G.jokers and #G.jokers.cards > 0 end, apply = function() kranlaxs_create_consumable('c_kranlaxs_bluequartz'); local j = kranlaxs_get_random_joker(); if j then j:set_perishable(true) end end },
    { id = 11, req = function() return G.jokers and #G.jokers.cards > 0 end, apply = function() kranlaxs_create_consumable('c_kranlaxs_lilacquartz'); local j = kranlaxs_get_random_joker(); if j then j:set_eternal(true) end end },
    { id = 12, req = function() return G.jokers and #G.jokers.cards > 0 end, apply = function() kranlaxs_create_consumable('c_kranlaxs_blackquartz'); local j = kranlaxs_get_random_joker(); if j then j:set_eternal(true); j:set_rental(true); j:set_perishable(true); j.pinned = true end end },
    { id = 13, req = function() return G.jokers and #G.jokers.cards > 0 end, apply = function() G.GAME.round_resets.reroll_cost = math.max(0, G.GAME.round_resets.reroll_cost - 2); local j = kranlaxs_get_random_joker(); if j then j:start_dissolve(nil, true) end end },
    { id = 14, req = function() return not G.GAME.dungeon_mega_reroll end, apply = function() G.GAME.dungeon_mega_reroll = true; ease_dollars(-G.GAME.dollars) end },
    { id = 15, req = function() return G.jokers and #G.jokers.cards > 0 end, apply = function() G.GAME.dungeon_blind_mult = (G.GAME.dungeon_blind_mult or 1) * 3; local to_copy = {}; for _, v in ipairs(G.jokers.cards) do table.insert(to_copy, v) end; for _, v in ipairs(to_copy) do if #G.jokers.cards < G.jokers.config.card_limit then local copy = copy_card(v, nil, nil, nil, v.playing_card and v.playing_card or nil); copy:add_to_deck(); G.jokers:emplace(copy) end end end },
    { id = 16, req = function() return G.GAME.round_resets.ante > 2 end, apply = function() ease_ante(-2); G.GAME.dungeon_blind_mult = (G.GAME.dungeon_blind_mult or 1) * 1.5 end },
    { id = 17, req = function() return true end, apply = function() G.GAME.dungeon_booster_pick_add = (G.GAME.dungeon_booster_pick_add or 0) + 1; if G.jokers and G.jokers.cards then for _, v in ipairs(G.jokers.cards) do v.pinned = true end end end },
    { id = 18, req = function() return true end, apply = function() kranlaxs_randomize_jokers_and_cons() end },
    { id = 19, req = function() return true end, apply = function() G.jokers.config.card_limit = G.jokers.config.card_limit + 3; kranlaxs_reset_deck_to_52() end },
    { id = 20, req = function() return true end, apply = function() G.hand.config.card_limit = G.hand.config.card_limit + 5; kranlaxs_reset_deck_to_52() end },
    { id = 21, req = function() return true end, apply = function() G.GAME.round_resets.discards = G.GAME.round_resets.discards + 3; kranlaxs_reset_deck_to_52() end },
    { id = 22, req = function() return G.GAME.round_resets.hands > 1 and G.GAME.round_resets.discards > 1 end, apply = function() G.GAME.round_resets.hands = G.GAME.round_resets.hands - 1; G.GAME.round_resets.discards = G.GAME.round_resets.discards - 1; for i=1, 4 do local v_key = get_next_voucher_key(); G.GAME.used_vouchers[v_key] = true; local fake = Card(0, 0, G.CARD_W, G.CARD_H, G.P_CARDS.empty, G.P_CENTERS[v_key]); fake:apply_to_run(); fake:remove() end end },
    
    -- =========================================================
    -- SOLO ANTE 5+ (Validado con la variable segura de Ante)
    -- =========================================================
    { id = 23, req = function() return G.GAME.round_resets.ante and G.GAME.round_resets.ante >= 5 end, apply = function() ease_ante(-4); kranlaxs_reset_deck_to_52() end },
    { id = 24, req = function() return G.GAME.round_resets.ante and G.GAME.round_resets.ante >= 5 end, apply = function() G.GAME.interest_cap = G.GAME.interest_cap * 2; ease_ante(2) end },
    { id = 25, req = function() return G.GAME.round_resets.ante and G.GAME.round_resets.ante >= 5 and not G.GAME.dungeon_legendary_shop end, apply = function() G.GAME.dungeon_legendary_shop = true; G.GAME.dungeon_price_mod = (G.GAME.dungeon_price_mod or 1) + 2.0 end },
    { id = 26, req = function() return G.GAME.round_resets.ante and G.GAME.round_resets.ante >= 5 end, apply = function() if G.GAME.shop then G.GAME.shop.booster_max = G.GAME.shop.booster_max + 1; G.GAME.shop.voucher_max = G.GAME.shop.voucher_max + 1; G.GAME.shop.joker_max = math.max(1, G.GAME.shop.joker_max - 3) end end },
    
    -- =========================================================
    -- SOLO POZO NEGRO+ (Validado mecánicamente para evitar SMODS)
    -- =========================================================
    { id = 27, req = function() return G.GAME.modifiers.enable_eternals_in_shop and not G.GAME.dungeon_no_stickers end, apply = function() G.GAME.dungeon_no_stickers = true; G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 2) end },
    
    -- NUEVA OPCION 28: Limpiar Sticker (Pozo Negro+ y al menos un joker pegado)
    { id = 28, req = function() 
        if not G.GAME.modifiers.enable_eternals_in_shop then return false end
        if not G.jokers or not G.jokers.cards then return false end
        for _, v in ipairs(G.jokers.cards) do
            if v.ability.eternal or v.ability.perishable or v.ability.rental then return true end
        end
        return false 
    end, apply = function() 
        ease_dollars(-10)
        local eligible = {}
        for _, v in ipairs(G.jokers.cards) do
            if v.ability.eternal or v.ability.perishable or v.ability.rental then table.insert(eligible, v) end
        end
        if #eligible > 0 then
            local card = pseudorandom_element(eligible, pseudoseed('dungeon_cleanse'))
            local stickers = {}
            if card.ability.eternal then table.insert(stickers, 'eternal') end
            if card.ability.perishable then table.insert(stickers, 'perishable') end
            if card.ability.rental then table.insert(stickers, 'rental') end
            
            local picked = pseudorandom_element(stickers, pseudoseed('dungeon_cleanse_st'))
            
            if picked == 'eternal' then 
                card.ability.eternal = nil
            elseif picked == 'perishable' then 
                card.ability.perishable = nil
                card.ability.perish_tally = G.GAME.perishable_jokers_tally or 5
                card.debuff = false
            elseif picked == 'rental' then 
                card.ability.rental = nil 
            end
            
            card:set_cost()
            card:juice_up(0.3, 0.5)
            play_sound('tarot1')
        end
    end }
}

-- ==============================================================================
-- DEFINICIÓN DEL OBJETO SMODS.BACK
-- ==============================================================================
SMODS.Back {
    key = 'dungeon_deck',
    pos = { x = 2, y = 0 }, 
    unlocked = false,
    discovered = false,
    
    -- Candado para que el juego no la oculte por error
    unlock_condition = {type = '', extra = ''}, 
    
    -- Nombres y descripción de tu baraja en el menú
    loc_txt = {
        name = "Baraja de Mazmorra",
        text = {
            "Al vencer una {C:attention}Ciega Jefe{},",
            "aparecerá un menú con",
            "opciones {C:red}implacables{}.",
            "No puedes omitirlo."
        }
    },
    
    atlas = 'CustomDecks',
    
    config = {
        joker_slot = 0, 
        consumable_slot = 0, 
        hand_size = 0, 
    },
    
    -- Texto visual que explica cómo desbloquear el candado
    loc_vars = function(self, info_queue, card)
        return {
            unlock_condition = {
                "Gana una partida con la",
                "{C:attention}Baraja de Reto Semanal{}",
                "en dificultad {C:attention}Pozo Negro{}"
            }
        }
    end,
    
    check_for_unlock = function(self, args)
        if args and args.type == 'win' then
            -- Verificamos si ganamos con la baraja correcta
            if G.GAME and G.GAME.selected_back and G.GAME.selected_back.effect.center.key == 'b_kranlaxs_week_challenge' then
                -- Blanco=1, Rojo=2, Verde=3, Azul=4, Negro=5
                if G.GAME.stake >= 5 then 
                    return true 
                end
            end
        end
        return false
    end,

    apply = function(self, back)
        G.GAME.dungeon_menu_active = false
        G.GAME.dungeon_menu_spawned = false
        G.GAME.dungeon_choice_made = false
        G.GAME.dungeon_pending_menu = false
        G.GAME.dungeon_price_mod = 1
        G.GAME.dungeon_no_common = false
        G.GAME.dungeon_no_uncommon = false
        G.GAME.dungeon_mega_reroll = false
        G.GAME.dungeon_blind_mult = 1
        G.GAME.dungeon_booster_pick_add = 0
        G.GAME.dungeon_legendary_shop = false
        G.GAME.dungeon_no_stickers = false
    end,
    
    calculate = function(self, back, context)
        if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
            if G.GAME.blind and G.GAME.blind.boss and not G.GAME.dungeon_menu_spawned then
                G.GAME.dungeon_menu_spawned = true 
                G.GAME.dungeon_pending_menu = true 
            end
        end
    end
}