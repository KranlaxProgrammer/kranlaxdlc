return {
    descriptions = {
        Joker = {
            j_kranlaxs_tagger = {name = "Etiquetador", text = {"Gana {C:mult}+#1#{} multi por cada", "{C:attention}Etiqueta{} obtenida", "{C:inactive}(Actualmente {C:mult}+#2#{C:inactive} multi){}"}, unlock = {"Canjea los {C:attention}2{} Vales", "de descuento en una sola partida"}},
            j_kranlaxs_Cashback = {name = "Reembolso", text = {"{C:green}#1# en #2#{} de probabilidad de recuperar", "la {C:attention}mitad{} de cualquier {C:money}dinero gastado{}"}, unlock = {"Gana una partida en {C:attention}Pozo Rojo{}", "usando la {C:attention}Baraja Espacial{}"}},
            j_kranlaxs_underratedjoker = {name = "Comodín Infravalorado", text = {"Este Comodín gana {X:chips,C:white} X0.2 {} fichas", "si la mano jugada {C:attention}no es{}", "tu mano de póker más jugada", "{C:inactive}(Se reinicia si lo es){}", "{C:inactive}(Actualmente {X:chips,C:white} X#1# {C:inactive} fichas){}"}, unlock = {"Gana una partida en {C:attention}Pozo Azul{}", "usando la {C:attention}Baraja Espacial{}"}},
j_kranlaxs_d20 = {
    name = "D20", 
    text = {
        "Todas las renovaciones en la", 
        "tienda cuestan {C:money}$#1#{}", 
        "{C:inactive}(El precio cambia al final de{}", 
        "{C:inactive}la ronda, entre $1 y $20){}"
    }
},

            j_kranlaxs_facelessaccountant = {name = "Contador Descarado", text = {"Este Comodín gana {X:chips,C:white} X#1# {} fichas por", "cada {C:attention}#2#{} puntuada", "{C:inactive}(Actualmente {X:chips,C:white} X#1# {C:inactive} fichas){}"}, unlock = {"Gana una partida sin jugar figuras,", "pero teniendo al menos {C:attention}1{} en tu baraja"}},
            j_kranlaxs_thefixer = {name = "El Sobornador", text = {"Vender un {C:attention}Comodín{} durante una", "{C:purple}Ciega{} reduce la puntuación requerida", "{C:inactive}(Común: -10%, Inusual: -30%){}", "{C:inactive}(Rara: -60%, Legendaria: -95%){}"}, unlock = {"Vende al menos {C:attention}2{} comodines", "de cada rareza"}},
            j_kranlaxs_mysteriousgeode = {name = "Geoda Misteriosa", text = {"Cada {C:attention}Carta Versátil{} puntuada otorga", "un efecto {C:attention}aleatorio{}"}, unlock = {"Juega una mano", "con {C:attention}5{} Cartas Versátiles"}},
            j_kranlaxs_benchwarmer = {name = "Calientabancas", text = {"Las cartas en mano que compartan la", "{C:attention}categoría más alta{} otorgan {C:attention}4 veces{}", "su valor en {C:chips}fichas{} al puntuar"}},
            j_kranlaxs_entropy2 = {name = "Vórtice", text = {"Gana {X:dark_edition,C:white} ^#2# {} multi y {X:dark_edition,C:white} ^#2# {} fichas", "por cada carta por debajo del", "tamaño original de la baraja (52)", "{C:inactive}(Actualmente {X:dark_edition,C:white} ^#2# {C:inactive}){}"}, unlock = {"Reduce tu baraja a", "{C:attention}5{} cartas o menos", "{C:inactive}(Menor cantidad: {C:attention}#1#{C:inactive})"}} ,
            j_kranlaxs_greedyleprachaun = {name = "Duende Avaricioso", text = {"Roba {C:attention}4 cartas adicionales{} en el", "{C:attention}primer descarte{} de la ronda"}, unlock = {"Descarta solo {C:attention}1{} carta", "{C:attention}3{} veces seguidas"}},
            j_kranlaxs_charismaticbard = {name = "Bardo Carismático", text = {"Reduce el {C:purple}requisito de la Ciega{} un {C:attention}2%{}", "cada vez que juegas tu {C:attention}mano más jugada{}", "{C:inactive}(Máximo 90%){}", "Se reinicia si juegas otra mano", "{C:inactive}(Actualmente {C:attention}-#1#%{C:inactive} tamaño de Ciega){}"}},
            j_kranlaxs_russianroulette = {name = "Ruleta Rusa", text = {"{C:green}#1# en #2#{} de probabilidad de {C:red}Fin de la partida{}", "al seleccionar una Ciega", "Si sobrevives, gana", "{X:mult,C:white} X3 {} multi y {X:chips,C:white} X3 {} fichas", "{C:inactive}(Actualmente {X:mult,C:white} X#3# {C:inactive} multi y {X:chips,C:white} X#3# {C:inactive} fichas){}"}, unlock = {"Gana una partida en {C:attention}Pozo Negro{}", "usando la {C:attention}Baraja Espacial{}"}},
            j_kranlaxs_fidelitycard = {name = "Pase de batalla", text = {"Recupera el {X:money,C:white} dinero {} del último gasto", "cada {C:attention}7{} compras o transacciones", "{C:inactive}(Gastos registrados: {C:attention}#1#{C:inactive} / 7){}"}},
            j_kranlaxs_devioussheep = {name = "Oveja Glotona", text = {"{C:red}Devora{} un Comodín al azar al", "seleccionar una {C:attention}Ciega{} y gana {X:mult,C:white} X0.4 {} multi", "{C:red}Fin de la partida{} si no puede alimentarse", "{C:inactive}(¡Prioriza ciertos objetivos para más multi!){}", "{C:inactive}(Actualmente {X:mult,C:white} X#1# {C:inactive} multi){}"}},
            j_kranlaxs_lifeassurance = {name = "Seguro de vida", text = {"{C:attention}Evita la muerte{} si posees", "al menos {X:money,C:white} $#1# {}", "{C:inactive}(El coste se duplica tras cada uso){}"}, unlock = {"Pierde una partida con", "{X:money,C:white} $100 {} o más en tu poder", "antes de la {C:attention}Apuesta 8{}"}},
            j_kranlaxs_sundaycheckpoint = {name = "Punto de Control", text = {"{C:red}Fin de la partida{} si seleccionas una Ciega", "en un {C:attention}día entre semana{}. De lo contrario, crea", "un Comodín de {C:attention}Desafío Semanal{} al final de", "la ronda y se {C:red}destruye{} a sí mismo", "{C:inactive}(Día actual: #1#){}"}},
            j_kranlaxs_weeklychallenge = {name = "Desafío Semanal", text = {"Establece un desafío aleatorio para esta partida", "{C:clubs}Desafío actual:{} {C:attention}#1#{}", "{C:inactive}1:{} Empiezas con {X:money,C:white} -$100 {}, págalo antes de la Apuesta 8", "{C:inactive}2:{} Tienda restringida", "{C:inactive}3:{} 1 Mano, 20 Descartes (Sin Vales extra)", "{C:inactive}4:{} Límite de {C:blue}#2#{} manos y {C:red}#3#{} descartes en la partida", "{C:inactive}5:{} Velocidad de juego bloqueada en 0.5x", "{C:inactive}6:{} 3 Triboulets Eternos (Máx 3 Comodines, Apuesta rápida)", "{C:inactive}7:{} 1 en 6 prob. de GANAR al vencer la Ciega (Pierdes en Apuesta 8)"}},
            j_kranlaxs_panda = {name = "Panda Esponjoso", text = {"Otorga {C:chips}+500{} fichas", "{C:attention}-1{} ranura de Comodín"}},
            j_kranlaxs_miner = {name = "Minero", text = {"Este Comodín gana {C:mult}+5{} multi", "cuando puntúa una {C:attention}Carta de Piedra{}.", "{C:green}#2# en #3#{} de prob. de {C:red}destruirla{}", "para ganar entre {X:money,C:white} $#4# {} y {X:money,C:white} $#5# {}", "{C:inactive}(Actualmente {C:mult}+#1#{C:inactive} multi){}"}, unlock = {"Juega una mano", "con {C:attention}5{} Cartas de Piedra"}},
            j_kranlaxs_birthdaycake = {name = "Pastel de Cumpleaños", text = {"Otorga {X:dark_edition,C:white} ^#1# {} multi.", "Pierde {X:dark_edition,C:white} ^0.25 {} multi tras", "cada mano jugada. Al agotarse,", "crea un {C:attention}Comodín Reregalado{}"}, unlock = {"Gana una partida en {C:attention}Pozo Azul{}", "usando la baraja del {C:attention}Reto Semanal{}"}},
            j_kranlaxs_vipsuscription = {name = "Suscripción V.I.P.", text = {"Otorga {C:attention}+#2#{} ranuras en la tienda,", "{C:attention}+1{} Vale y Sobre extra. Cuesta {X:money,C:white} $#1# {}", "al abrir la tienda. El precio y el tamaño", "de la tienda {C:attention}aumentan{} al vencer una {C:attention}Ciega Jefe{}"}, unlock = {"Gana una partida en {C:attention}Pozo Naranja{}", "usando la baraja del {C:attention}Reto Semanal{}"}},
            j_kranlaxs_painterjoker = {name = "Comodín Pintor", text = {"Registra cada {C:attention}Carta Versátil{} jugada.", "En la tienda, paga {X:money,C:white} $#2# {} para crear", "una {C:attention}Etiqueta de Malabarista{} por carta registrada", "{C:inactive}(Registradas: {C:attention}#1#{C:inactive}){}"}, unlock = {"Gana una partida en {C:attention}Pozo Naranja{}", "usando la baraja del {C:attention}Reto Semanal{}"}},
            j_kranlaxs_coronation = {name = "Coronación", text = {"Si la mano contiene cartas puntuadas de", "categoría {C:attention}10 o menor{}, transforma la de", "menor valor en un {C:attention}Rey{}. Si no quedan cartas", "bajas, añade un {C:red}Sello Rojo{} al primer {C:attention}Rey{} puntuado"}, unlock = {"Juega una mano de exactamente", "{C:attention}5 Reyes{}. Todos deben tener", "{C:red}Sello Rojo{} y ser cartas de {C:attention}Acero{}"}},
            j_kranlaxs_speedrunner = {name = "Speedrunner", text = {"{X:mult,C:white} X#1# {} multi.", "Tienes {C:attention}#2# segundos{} para jugar", "una mano o descartar. Si el tiempo", "se agota, {C:red}FIN DE LA PARTIDA{}."}, unlock = {"Gana una partida en {C:attention}Pozo Verde{}", "usando la baraja del {C:attention}Reto Semanal{}"}},
            j_kranlaxs_passcode = {name = "Contraseña", text = {"Si la mano jugada coincide con alguno de los", "siguientes códigos, la mano cuenta como {C:attention}Cinco de Color{}", "{C:inactive}1. {C:attention}#1#{}", "{C:inactive}2. {C:attention}#2#{}", "{C:inactive}3. {C:attention}#3#{}"}, unlock = {"Gana una partida en {C:attention}Pozo Negro{}", "usando la baraja del {C:attention}Reto Semanal{}"}},
            j_kranlaxs_zombiejoker = {name = "Komodín Sombi", text = {"{C:attention}destrulle{} la {C:attention}primer{} carta", "k no da putos y gana {C:mult}+15{} multi", "pero pierds {C:mult}-10{} multi", "xkada mano jugda en la rond", "si yega a {C:mult}0{} multi", "{C:attention}se muere {}", "{C:inactive}(tines {C:mult}+#1#{C:inactive} multi o algo asi){}"}, unlock = {"Gana una partida en {C:attention}Pozo Morado{}", "usando la {C:attention}Baraja Espacial{}"}},
            j_kranlaxs_thecousin = {name = "El Primo", text = {"Gana {C:chips}+7{} fichas por cada", "{C:attention}número primo{} puntuado", "{C:inactive}(Actualmente {C:chips}+#1#{C:inactive} fichas){}"}, unlock = {"Gana una partida en {C:attention}Pozo Turquesa{}", "usando la {C:attention}Baraja Espacial{}"}},
            j_kranlaxs_colasoda = {name = "Refresco de Cola", text = {"Otorga {X:dark_edition,C:white} ^#1# {} multi.", "Pierde {X:dark_edition,C:white} ^0.001 {} multi por cada", "{C:attention}segundo{} que pasa"}, unlock = {"Gana una partida en {C:attention}Pozo Azul{}", "usando la baraja del {C:attention}Reto Semanal{}"}},
            j_kranlaxs_icecreamsandwich = {name = "Sándwich de Helado", text = {"Gana {X:money,C:white} $#1# {} extra al final", "de la ronda. La recompensa disminuye", "en {X:money,C:white} $#2# {} tras cada ronda"}, unlock = {"Gana {X:money,C:white} $50 {} o más", "de pago en una sola ronda"}},
            j_kranlaxs_dispensermachine = {name = "Máquina Expendedora", text = {"Si este Comodín está {C:attention}seleccionado{} al salir", "de la tienda, gasta {X:money,C:white} $#1# {} y crea", "un {C:attention}Comodín de Comida{} aleatorio"}, unlock = {"Ten {C:attention}4{} comodines de", "comida al mismo tiempo"}},
            j_kranlaxs_bottledwater = {name = "Agua Embotellada", text = {"{X:chips,C:white} X#1# {} fichas.", "Pierde {X:chips,C:white} X#2# {} fichas por", "cada carta puntuada"}, unlock = {"Gana una partida en {C:attention}Pozo Azul{}", "usando la baraja del {C:attention}Reto Semanal{}"}},
            j_kranlaxs_burrow = {name = "Madriguera", text = {"Gana {C:attention}+1{} Conejo por cada", "{C:attention}Ciega vencida{}. Al ser {C:gold}vendido{},", "crea {C:attention}#1#{} Conejos"}},
            j_kranlaxs_bunny = {name = "Conejo", text = {"Gana {X:mult,C:white} X#1# {} multi por cada", "Comodín {C:attention}Conejo{} que poseas", "{C:inactive}(Actualmente {X:mult,C:white} X#2# {C:inactive} multi){}"}},
            j_kranlaxs_sushi = {name = "Sushi", text = {"Reduce el requisito de la Ciega un {C:attention}#1#%{}.", "La reducción disminuye un {C:attention}#2#%{}", "tras vencer una {C:attention}Ciega{}"}, unlock = {"Gana una partida en {C:attention}Pozo Morado{}", "usando la baraja del {C:attention}Reto Semanal{}"}},
            j_kranlaxs_gigachad = {name = "Gigachad", text = {"Gana {C:chips}+#2#{} fichas por casi", "{C:attention}cualquier acción{} que realices", "{C:inactive}(Actualmente {C:chips}+#1#{C:inactive} fichas){}"}, unlock = {"Gana una partida en {C:attention}Pozo Blanco{}", "usando la baraja del {C:attention}Reto Semanal{}"}},
            j_kranlaxs_nft = {name = "Criptoestafa", text = {"Reduce la {C:attention}categoría{} de todas las cartas", "en tu mano en {C:attention}1{} al puntuar una mano", "{C:inactive}(No puede reducirse por debajo de 2){}"}},
            j_kranlaxs_beanstalk = {name = "Tallo de Frijol", text = {"Frijoles inútiles"}, unlock = {"Gana una partida en {C:attention}Pozo Blanco{}", "usando la baraja del {C:attention}Reto Semanal{}"}},
            j_kranlaxs_suspiciousbeanstalk = {name = "Tallo de Frijol Sospechoso", text = {"¿Frijoles inútiles?..."}},
            j_kranlaxs_epicbeanstalk = {name = "Tallo de Frijol Épico", text = {"Tal vez no sean frijoles inútiles..."}},
            j_kranlaxs_zenithbeanstalk = {name = "Tallo de Frijol Cenit", text = {"Frijoles"}},
            j_kranlaxs_commonseed = {name = "Semilla Común", text = {"{C:attention}Crea{} un Comodín", "{C:common}Común{} al azar"}},
            j_kranlaxs_weirdlookingseed = {name = "Semilla Rara", text = {"{C:attention}Crea{} un Comodín", "{C:uncommon}Inusual{} al azar"}},
            j_kranlaxs_magnificentseed = {name = "Semilla Magnífica", text = {"{C:attention}Crea{} un Comodín", "{C:rare}Raro{} al azar"}},
            j_kranlaxs_godseed = {name = "Semilla Divina", text = {"{C:attention}Crea{} un Comodín", "{C:legendary}Legendario{} al azar"}},
            j_kranlaxs_anonymousjoker = {name = "Comodín Anónimo", text = {"Al puntuar, se voltea boca abajo y otorga", "entre {X:mult,C:white} X1.5 {} y {X:mult,C:white} X4.0 {} multi"}, unlock = {"Derrota a la Ciega Jefe", "{C:attention}Bellota Ambarina{} 1 vez"}},
            j_kranlaxs_littlebro = {name = "Hermanito", text = {"Si la mano jugada es {C:attention}Carta Alta{} y la carta", "puntuada es un {C:attention}#3#{}, gana {X:mult,C:white} X#4# {} multi.", "La carta cambia cada ronda", "{C:inactive}(Actualmente {X:mult,C:white} X#2# {C:inactive} multi){}"}, unlock = {"Juega {C:attention}Carta Alta{}", "{C:attention}30{} veces en una sola partida", "{C:inactive}(Progreso: {C:attention}#1#{C:inactive} / 30){}"}},
            j_kranlaxs_medusa = {name = "Medusa", text = {"{C:attention}Todas las cartas jugadas{} se convierten", "permanentemente en {C:attention}Cartas de Piedra{}", "tras puntuar {C:inactive}(incluso no puntuadas){}"}, unlock = {"Gana una partida en {C:attention}Pozo Marrón{}", "usando la {C:attention}Baraja Espacial{}"}},
            j_kranlaxs_depression = {name = "Recesión Económica", text = {"Otorga {X:dark_edition,C:white} ^#2# {} multi. Aumenta en", "{X:dark_edition,C:white} ^#1# {} multi por cada {X:money,C:white} $1 {} por debajo de {X:money,C:white} $0 {}"}, unlock = {"Entra a una tienda", "con {X:money,C:white} -$25 {} o menos"}},
            j_kranlaxs_grannyjoker = {name = "La Abuela", text = {"Otorga {X:mult,C:white} X3 {} multi.", "Se {C:red}destruye{} si la mano jugada", "contiene una {C:attention}Escalera{}"}, unlock = {"Derrota {C:attention}12{} Ciegas con la", "velocidad de juego en {C:attention}0.5x{}"}},
            j_kranlaxs_lateshippment = {name = "Envío Tardío", text = {"Reactiva {C:attention}todas las cartas jugadas{} {C:attention}1 vez{}", "por cada mano jugada en la {C:attention}ronda anterior{}", "{C:inactive}(Guardadas esta ronda: {C:attention}#1#{C:inactive}){}"}, unlock = {"Gana una partida en {C:attention}Pozo Naranja{}", "usando la {C:attention}Baraja Espacial{}"}},
            j_kranlaxs_unkownfactor = {name = "Variable X", text = {"Todas las cartas jugadas son consideradas como {C:attention}#1#{}", "{C:inactive}(La categoría cambia al final de la ronda){}"}, unlock = {"Gana una partida en {C:attention}Pozo Dorado{}", "usando la baraja del {C:attention}Reto Semanal{}"}},
            j_kranlaxs_thethreers = {name = "Las 3 R", text = {"Crea una {C:attention}copia{} de cada carta jugada", "y la añade a tu {C:attention}baraja{}.", "{C:attention}Destruye{} todas las cartas puntuadas"}, unlock = {"Gana una partida en {C:attention}Pozo Dorado{}", "usando la baraja del {C:attention}Reto Semanal{}"}},
            j_kranlaxs_the = {name = "Com", text = {"Otorga {X:chips,C:white} X2 {} fichas y {X:mult,C:white} X2 {} multi", "solo en la {C:attention}primera mano{} de la ronda"}, unlock = {"Vence {C:attention}5{} Ciegas usando", "solo {C:attention}1{} mano cada una"}},
            j_kranlaxs_chainreaction = {name = "Reacción en Cadena", text = {"Si la mano jugada es {C:attention}#2#{}, gana {X:chips,C:white} X0.5 {} fichas", "y la mano requerida cambia. Se reinicia si la", "mano {C:attention}no coincide{}", "{C:inactive}(Actualmente {X:chips,C:white} X#1# {C:inactive} fichas){}"}, unlock = {"Juega todas las manos de póker", "al menos {C:attention}1{} vez en una partida"}},
            j_kranlaxs_anubis = {name = "Anubis", text = {"Equilibra las {C:chips}fichas{} y el {C:mult}multi{}", "cuando una mano es puntuada"}, unlock = {"Gana una partida con la {C:attention}Baraja de Plasma{}", "en cada una de las dificultades"}},
            j_kranlaxs_erraticjoker = {name = "Comodín Errático", text = {"Si la carta puntuada es una {C:attention}Carta Versátil{},", "intercambia las {C:chips}fichas{} y el {C:mult}multi{}"}, unlock = {"Gana una partida en {C:attention}Pozo Blanco{}", "usando la {C:attention}Baraja Espacial{}"}},
            j_kranlaxs_luckyseven = {name = "Los 7 Afortunados", text = {"Gana {C:chips}+7{} fichas y {C:mult}+7{} multi por", "cada {C:attention}7{} cartas de categoría {C:attention}7{} jugadas", "{C:inactive}(Actualmente {C:chips}+#1#{} fichas, {C:mult}+#2#{} multi){}", "{C:inactive}(7s jugados: {C:attention}#3#{C:inactive} / 7){}"}, unlock = {"Ten al menos {C:attention}10{} cartas", "con categoría {C:attention}7{} en tu baraja"}},
            j_kranlaxs_certificateddocument = {name = "Documento Certificado", text = {"Reactiva {C:attention}todos{} los sellos"}, unlock = {"Gana una partida en {C:attention}Pozo Morado{}", "usando la baraja del {C:attention}Reto Semanal{}"}},
            j_kranlaxs_platanito = {name = "Platanito", text = {"Cada vez que otro Comodín se activa, otorga", "{X:mult,C:white} X#3# {} multi adicional.", "{C:green}#1# en #2#{} de probabilidad de destruirse", "al final de la ronda"}, unlock = {"Gana una partida en {C:attention}Pozo de Platino{}", "usando la {C:attention}Baraja Espacial{}"}},
            j_kranlaxs_grapesoda = {name = "Refresco de Uva", text = {"Al ser {C:gold}vendido{}, crea una carta {C:spectral}Espectral{}", "aleatoria con edición {C:dark_edition}Negativa{}"}, unlock = {"Gana una partida en {C:attention}Pozo Magenta{}", "usando la {C:attention}Baraja Espacial{}"}},
            j_kranlaxs_telescope = {name = "Telescopio", text = {"Si se sube de nivel {C:attention}#1#{}, sube de nivel", "esa mano {C:attention}1{} vez adicional", "{C:inactive}(La mano cambia al final de la ronda){}"}, unlock = {"Gana una partida en {C:attention}Pozo Rojo{}", "usando la baraja del {C:attention}Reto Semanal{}"}},
            j_kranlaxs_pandorabox = {name = "Caja de Pandora", text = {"Al vencer a una {C:attention}Ciega Jefe{}, crea un", "Comodín {C:attention}útil{} basado en tu baraja actual", "{C:inactive}(Debes tener espacio){}"}, unlock = {"Gana una partida en {C:attention}Pozo Magenta{}", "usando la {C:attention}Baraja de Mazmorra{}"}},
            j_kranlaxs_doppelganger = {name = "Doppelgänger", text = {"Copia la habilidad de un {C:attention}Comodín{} aleatorio de", "toda la colección. El Comodín copiado cambia tras", "vencer una {C:attention}Ciega{}.", "{C:inactive}(Actualmente: {C:attention}#1#{C:inactive})"}, unlock = {"Gana una partida en {C:attention}Pozo Dorado{}", "usando la baraja del {C:attention}Reto Semanal{}"}},
            j_kranlaxs_thechampion = {name = "El Campeón", text = {"Requisito de la Ciega {C:attention}X#1#{}. Gana {X:money,C:white} $#2# {} de {C:attention}interés{}", "extra por cada {X:money,C:white} $5 {} que poseas al final de ronda"}, unlock = {"Llega a la {C:attention}Apuesta 16{}"}},
            j_kranlaxs_clerigo = {name = "Clérigo", text = {"Otorga {C:mult}+#1#{} multi por cada carta en tu baraja completa.", "Pierde {C:mult}-#2#{} multi por cada carta con alguna", "mejora, sello o edición", "{C:inactive}(Actualmente {C:mult}+#3#{C:inactive} multi){}"}, unlock = {"Completa el reto:", "{C:attention}Receta Familiar{}"}},
            j_kranlaxs_entrenador = {name = "Entrenador", text = {"Otorga {X:mult,C:white} X#1# {} multi si estás por debajo de la", "Apuesta {C:attention}#3#{}. De lo contrario, da {X:mult,C:white} X#2# {} multi", "{C:inactive}(Actualmente {X:mult,C:white} X#4# {C:inactive} multi){}"}, unlock = {"Completa el reto:", "{C:attention}Crisis Económica{}"}},
            j_kranlaxs_medium = {name = "Médium", text = {"Otorga {C:chips}+#2#{} fichas por cada", "partida {C:red}perdida{} en tu perfil", "{C:inactive}(Actualmente {C:chips}+#3#{C:inactive} fichas){}"}, unlock = {"Pierde {C:attention}1{} partida", "{C:inactive}(Progreso: {C:attention}#1#{C:inactive} / 1){}"}},
            j_kranlaxs_monk = {name = "Monje", text = {"Gana {X:chips,C:white} X#1# {} fichas si sales de la tienda sin gastar", "{C:money}dinero{}. Se {C:red}reinicia{} si compras cualquier artículo", "{C:inactive}(Actualmente {X:chips,C:white} X#2# {C:inactive} fichas){}"}, unlock = {"Completa el reto:", "{C:attention}Voto de Pobreza{}"}},
            j_kranlaxs_knight = {name = "Caballero", text = {"Tras puntuar {C:attention}#1#{} {C:attention}Cartas de Acero{},", "{C:attention}deshabilita{} la siguiente {C:attention}Ciega Jefe{}", "{C:inactive}(Cartas puntuadas: #2#/#1#){}"}, unlock = {"Completa el reto:", "{C:attention}Sindicato de Jefes{}"}},
            j_kranlaxs_overpopulation = {name = "Sobrepoblación", text = {"Otorga {C:mult}+#1#{} multi por cada {C:attention}figura{}", "en tu baraja por encima del límite de {C:attention}#2#{}", "{C:inactive}(Actualmente {C:mult}+#3#{C:inactive} multi){}"}, unlock = {"Gana una partida en {C:attention}Pozo Verde{}", "usando la {C:attention}Baraja Espacial{}"}},
            j_kranlaxs_antisocial = {name = "Antisocial", text = {"Este Comodín gana {C:mult}+#1#{} multi si juegas exactamente", "{C:attention}1{} carta. Se {C:red}reinicia{} si juegas más de 1", "{C:inactive}(Actualmente {C:mult}+#2#{C:inactive} multi){}"}, unlock = {"Completa el reto:", "{C:attention}Fijación Total{}"}},
            j_kranlaxs_famous = {name = "Famoso", text = {"Otorga {C:chips}+#1#{} fichas si la mano jugada es", "{C:attention}Quintilla{}, {C:attention}Cinco de Color{} o {C:attention}Full House de Color{}"}},
            j_kranlaxs_influencer = {name = "Influencer", text = {"Otorga {C:mult}+#1#{} multi si la mano jugada es", "{C:attention}Quintilla{}, {C:attention}Cinco de Color{} o {C:attention}Full House de Color{}"}},
            j_kranlaxs_potatobag = {name = "Bolsa de frituras", text = {"Acumula las fichas puntuadas. Al llegar a {C:attention}#1#{},", "aplica {X:mult,C:white} X#2# {} multi en la siguiente mano y se vacía", "{C:inactive}(Acumulado: #3#/#1#){}"}},
            j_kranlaxs_simonsays = {name = "Simón Dice", text = {"Este Comodín gana {X:mult,C:white} X#2# {} multi al completar", "su petición. Simón dice... {C:attention}#3#{}", "{C:inactive}(Actualmente {X:mult,C:white} X#1# {C:inactive} multi){}"}, unlock = {"Completa el reto:", "{C:attention}El Gran Tallo{}"}},
            j_kranlaxs_cheater = {name = "Tramposo", text = {"Las ranuras de cartas en la tienda tienen", "probabilidad de generar {C:attention}Paquetes Potenciadores{}#1#"}, unlock = {"Completa el reto:", "{C:attention}Gachapón{}"}},
            j_kranlaxs_philosopher = {name = "Filósofo", text = {"Muestra las siguientes {C:attention}5 cartas{}", "de tu baraja", "{C:attention}#1#{}"}, unlock = {"Completa el reto:", "{C:attention}Premoniciones{}"}},
            j_kranlaxs_mandalajoker = {name = "Comodín Mandala", text = {"Este Comodín gana {X:mult,C:white} X0.5 {} multi", "por cada carta {C:spectral}Espectral{} usada", "{C:inactive}(Actualmente {X:mult,C:white} X#1# {C:inactive} multi){}"}, unlock = {"Usa {C:attention}20{} cartas {C:spectral}Espectrales{}", "{C:inactive}(Progreso: {C:attention}#1#{C:inactive} / 20){}"}},
            j_kranlaxs_regift = {name = "Comodín Reregalado", text = {"Al ser {C:gold}vendido{}, crea un {C:attention}Comodín aleatorio{}.", "La rareza depende de la {C:attention}Ciega{} actual"}, unlock = {"Vende {C:attention}50{} comodines en total", "{C:inactive}(Progreso: {C:attention}#1#{C:inactive} / 50){}"}},
            j_kranlaxs_pyromaniac = {name = "Piromaníaco", text = {"Tras puntuar, {C:red}destruye{} todas las cartas de {C:attention}número{}", "en tu mano {C:inactive}(las cartas de Oro, Cristal y Acero son inmunes){}"}, unlock = {"Destruye {C:attention}100{} cartas", "que no sean figuras", "{C:inactive}(Progreso: {C:attention}#1#{C:inactive} / 100){}"}},
            j_kranlaxs_neverendinggambling = {name = "Ludopatía sin fin", text = {"Pierdes {X:money,C:white} $1 {} por acción realizada {C:inactive}(si posees ≥ $5){}.", "Gira 3 números. ¡Si coinciden, ganas el premio mayor!", "Si coinciden 2, recuperas {X:money,C:white} $1 {}. Tras fallar", "{C:attention}10{} veces seguidas, se reembolsan {X:money,C:white} $10 {}", "{C:inactive}(Tirada actual: #1# - #2# - #3#){}"}, unlock = {"Falla {C:attention}30{} probabilidades en", "comodines o consumibles", "{C:inactive}(Progreso: {C:attention}#1#{C:inactive} / 30){}"}},
            j_kranlaxs_solarsystem = {name = "Sistema Solar", text = {"Al {C:attention}final de la ronda{}, crea una carta de {C:planet}Planeta{}", "siguiendo una secuencia fija de manos", "{C:inactive}(Siguiente planeta: {C:planet}#1#{C:inactive}){}"}, unlock = {"Usa las {C:attention}12{} cartas de {C:planet}Planeta{}", "estándar en una sola partida", "{C:inactive}(Progreso: {C:attention}#1#{C:inactive} / 12){}"}},
            j_kranlaxs_deranged = {name = "Trastornado", text = {"Otorga {C:mult}+#1#{} multi o {C:chips}+#2#{} fichas.", "El efecto alterna cada vez que juegas una mano"}, unlock = {"Completa el reto:", "{C:attention}Crisis de Identidad{}"}},
            j_kranlaxs_deranged_mult = {name = "Trastornado", text = {"Otorga {C:mult}+#1#{} multi.", "El efecto alterna cada vez que juegas una mano"}},
            j_kranlaxs_deranged_chips = {name = "Trastornado", text = {"Otorga {C:chips}+#2#{} fichas.", "El efecto alterna cada vez que juegas una mano"}},
            j_kranlaxs_judgejoker = {name = "Comodín Juez", text = {"{C:green}#1# en 20{} de probabilidad de salvarte de un {C:attention}Fin de la Partida{}.", "{C:green}#1# en 10{} de probabilidad de {C:attention}deshabilitar{} la Ciega Jefe"}},
            j_kranlaxs_beingoflight = {name = "Ser de Luz", text = {"Las cartas puntuadas tienen un {C:green}1 en 12{} de prob. de", "obtener la edición {C:dark_edition}Cósmica{} {C:inactive}(si no tienen otra edición){}"}},
            j_kranlaxs_olympicswimmer = {name = "Nadador Olímpico", text = {"Las cartas puntuadas tienen un {C:green}1 en 10{} de prob. de", "obtener la edición {C:blue}Acuática{} {C:inactive}(si no tienen otra edición){}"}},
            j_kranlaxs_postagestamp = {name = "Sello Postal", text = {"Este Comodín gana {C:chips}+#1#{} fichas por", "cada carta puntuada con un {C:attention}Sello{}", "{C:inactive}(Actualmente {C:chips}+#2#{C:inactive} fichas){}"}},
            j_kranlaxs_sealer = {name = "El Sellador", text = {"En tu {C:attention}última mano{} de la ronda, aplica un", "{C:attention}Sello{} aleatorio a todas las cartas en mano sin uno"}},
            j_kranlaxs_monochromer = {name = "Escala de grises", text = {"Las cartas puntuadas tienen un {C:green}1 en 7{} de prob. de", "obtener la edición {C:dark_edition}Monocromática{} {C:inactive}(si no tienen edición){}"}},
            j_kranlaxs_libra = {name = "Libra", text = {"La {C:attention}Ciega Grande{} y la {C:attention}Ciega Jefe{} tienen el mismo", "requisito base de puntuación que la {C:attention}Ciega Pequeña{}"}},
            j_kranlaxs_paratrooper = {name = "Paracaidista", text = {"Otorga {C:chips}+#1#{} fichas. Pierde {C:chips}-1{} ficha por cada", "{C:attention}2 segundos{} de tiempo real {C:inactive}(Límite mínimo +20){}"}},
            j_kranlaxs_paratrooper_min = {name = "Paracaidista", text = {"Otorga {C:chips}+#1#{} fichas", "{C:inactive}(Límite mínimo alcanzado){}"}},
            j_kranlaxs_socks = {name = "Calcetines", text = {"Gana {C:chips}+#1#{} fichas si la mano", "jugada contiene un {C:attention}Doble Par{}", "{C:inactive}(Actualmente {C:chips}+#2#{C:inactive} fichas){}"}, unlock = {"Gana una partida sin", "jugar un {C:attention}Doble Par{}"}},
            j_kranlaxs_collector = {name = "Coleccionista", text = {"Gana {X:mult,C:white} XMult {} por cada elemento {C:attention}Único{} en posesión:", "{C:inactive}Ediciones (+0.25), Mejoras (+0.2), Sellos (+0.2){}", "{C:inactive}Rareza de Comodines: {C:common}C (+0.25){C:inactive}, {C:uncommon}I (+0.5){C:inactive}, {C:rare}R (+1){C:inactive}, {C:legendary}L (+2){}", "{C:inactive}(Actualmente {X:mult,C:white} X#2# {C:inactive} Mult){}"}, unlock = {"Descubre {C:attention}100{} comodines", "en tu colección", "{C:inactive}(Progreso: {C:attention}#1#{C:inactive} / 100){}"}},
            j_kranlaxs_witch = {name = "Bruja", text = {"Todos los {C:attention}Comodines{} sin edición", "que {C:attention}obtengas{} ganan la", "edición {C:red}Maldita{}"}, unlock = {"Gana una partida en {C:attention}Pozo Negro{}", "usando la {C:attention}Baraja Malvada{}"}},
            j_kranlaxs_oldcartoon = {name = "Caricatura Antigua", text = {"Las cartas puntuadas tienen un {C:green}1 en 10{} de prob. de", "obtener la edición {C:attention}Sepia{} {C:inactive}(si no tienen otra edición){}"}},
            j_kranlaxs_licenseplate = {name = "Placa de Auto", text = {"Gana {X:mult,C:white} X#2# {} multi por cada {C:attention}mano jugada{}.", "Se reinicia al final de la ronda", "{C:inactive}(Actualmente {X:mult,C:white} X#3# {C:inactive} multi){}"}, unlock = {"Juega {C:attention}6{} manos en", "una sola ronda", "{C:inactive}(Progreso: {C:attention}#1#{C:inactive} / 6){}"}},
            j_kranlaxs_statistician = {name = "Medalla de plata", text = {"Al final de la ronda, otorga {C:money}${} equivalente a la", "categoría de la carta en el {C:attention}centro exacto{} de tu {C:attention}mano{}"}},
            j_kranlaxs_transmuter = {name = "Alquimia", text = {"Al puntuar, transforma el {C:attention}valor completo en fichas{}", "de la carta en {C:mult}multi{} en lugar de {C:chips}fichas{}"}},
            j_kranlaxs_investor = {name = "Lobo de Wall Street", text = {"{C:red}Pierdes la mitad{} del dinero ganado en la ronda.", "Se convierte en {X:mult,C:white} XMult {} permanente para este Comodín", "{C:inactive}(Actualmente {X:mult,C:white} X#2# {C:inactive} Mult){}"}, unlock = {"Gana una partida en {C:attention}Pozo Mostaza{}", "usando la {C:attention}Baraja Catálogo{}"}},
            j_kranlaxs_professor = {name = "Profesor", text = {"Otorga {X:mult,C:white} XMult {} a las cartas puntuadas según su categoría:", "{C:attention}6{}: {X:mult,C:white}X1.2{} | {C:attention}7{}: {X:mult,C:white}X1.4{} | {C:attention}8{}: {X:mult,C:white}X1.6{}", "{C:attention}9{}: {X:mult,C:white}X1.8{} | {C:attention}10{}: {X:mult,C:white}X2.0{} | {C:attention}As{}: {X:mult,C:white}X2.5{}"}, unlock = {"Juega {C:attention}20 Ases{} en una sola partida", "{C:inactive}(Progreso: {C:attention}#1#{C:inactive} / 20){}"}},
            j_kranlaxs_censored = {name = "Comodín censurado", text = {"Cada carta robada tiene {C:green}#2# en #3#{} de prob. de ser {C:red}debilitada{}.", "Otorga {C:mult}+#1#{} multi por cada carta debilitada que puntúe", "{C:inactive}(Actualmente {C:mult}+#4#{C:inactive} multi){}"}},
            j_kranlaxs_nazar = {name = "Nazar", text = {"Los Comodines en la tienda {C:attention}no tendrán stickers{}", "durante las siguientes {C:attention}#2#{} Ciegas. Se agota permanentemente", "{C:inactive}(Solo aparece en Pozo Negro o superior){}"}, unlock = {"Gana {C:attention}7{} partidas en {C:attention}Pozo Negro{}", "o superior con barajas diferentes", "{C:inactive}(Progreso: {C:attention}#1#{C:inactive} / 7){}"}},
            j_kranlaxs_charlatan = {name = "Comodín arquitecto", text = {"{C:attention}+#1#{} al tamaño de mano durante las {C:purple}Ciegas Jefe{}"}},
            j_kranlaxs_filmcrew = {name = "Comodín cinéfilo", text = {"Gana {C:mult}+#2#{} multi por cada {C:attention}Vale{} canjeado en la partida", "{C:inactive}(Actualmente {C:mult}+#3#{C:inactive} multi){}"}, unlock = {"Canjea {C:attention}10{} Vales o más", "en una sola partida", "{C:inactive}(Progreso: {C:attention}#1#{C:inactive} / 10){}"}},
            j_kranlaxs_mysteryserum = {name = "Suero Misterioso", text = {"Al ser {C:gold}vendido{}, los Comodines a la izquierda y derecha", "se transforman en otros {C:attention}Comodines aleatorios{}"}},
            j_kranlaxs_eugenizer = {name = "Eugenizador", text = {"Al final de la ronda, {C:green}#1# en #2#{} de probabilidad de", "{C:attention}evolucionar{} al Comodín de la izquierda a mayor rareza"}, unlock = {"Gana una partida en {C:attention}Pozo Turquesa{}", "usando la {C:attention}Baraja Malvada{}"}},
            j_kranlaxs_thepact = {name = "El Pacto", text = {"Todo en la tienda cuesta {X:money,C:white} $1 {}. El requisito de las", "Ciegas aumenta un {C:attention}#1#%{} por cada compra {C:inactive}(sobres excluidos){}.", "{C:red}Botón de venta deshabilitado{} tras la primera compra", "{C:inactive}(Aumento actual: {C:attention}#2#%{C:inactive}){}"}, unlock = {"Gana una partida en {C:attention}Pozo Verde{}", "usando la {C:attention}Baraja Malvada{}"}},
            j_kranlaxs_chocolate = {name = "Chocolate", text = {"Otorga {X:mult,C:white} X#1# {} multi.", "Se {C:red}derrite{} tras jugar {C:attention}#2#{} manos"}},
            j_kranlaxs_dividend = {name = "Comodín presidente", text = {"Al puntuar, cada carta en {C:attention}mano{} otorga {C:mult}multi{}", "equivalente a la {C:attention}mitad{} de su valor en fichas"}},
            j_kranlaxs_tmtrainer = {name = "TMTRAINER", text = {"{C:dark_edition}#1#{}", "{C:attention}#2#{}", "{C:red}#3#{}", "{C:inactive}#4#{}"}, unlock = {"Completa el reto:", "{C:attention}Crisis de Identidad{}"}},
            j_kranlaxs_bingocard = {name = "Tarjeta de Bingo", text = {"Gana {X:mult,C:white} X0.5 {} multi por cada línea completada", "{C:inactive}(Total: {X:mult,C:white} X#2# {C:inactive} multi){}", "{C:attention}#3#{}", "{C:attention}#4#{}", "{C:attention}#5#{}", "{C:attention}#6#{}", "{C:attention}#7#{}"}, unlock = {"Completa el reto:", "{C:attention}Anonimato Total{}"}},
            j_kranlaxs_vikingo = {name = "Vikingo", text = {"Los {C:attention}Paquetes Potenciadores{} ofrecen {C:attention}+#1#{} seleccion adicional"}, unlock = {"Gana una partida en {C:attention}Pozo Marrón{}", "usando la {C:attention}Baraja de Mazmorra{}"}},
            j_kranlaxs_prosopagnosia = {name = "Prosopagnosia", text = {"Las {C:attention}figuras{} están {C:red}debilitadas{}.", "Las {C:attention}cartas numéricas{} puntuadas otorgan {X:mult,C:white} X#1# {} multi"}, unlock = {"Gana una partida en {C:attention}Pozo Cósmico{}", "sin haber jugado figuras"}},
            j_kranlaxs_galletas = {name = "Galletas", text = {"{C:attention}Horneando...{}"}},
            j_kranlaxs_galletas_ready = {name = "Galletas", text = {"Otorga {C:chips}+#1#{} fichas. Pierde {C:chips}-#2#{} fichas", "tras cada mano jugada"}},
            j_kranlaxs_dinerosangriento = {name = "Dinero Sangriento", text = {"Gana {C:purple}+1 Token{} extra tras", "vencer a la {C:purple}Ciega Jefe{}"}, unlock = {"Compra {C:attention}15{} artículos en", "el {C:attention}Mercado Negro{}", "{C:inactive}(Progreso: {C:attention}#1#{C:inactive} / 15){}"}},
            j_kranlaxs_aries = {name = "Aries", text = {"En tu {C:attention}última mano{} de la ronda, todos los comodines", "de escalado activan su crecimiento {C:attention}1 vez más{}"}},
            j_kranlaxs_gemini = {name = "Géminis", text = {"Tras vencer una {C:purple}Ciega Jefe{}, {C:green}#1# en #2#{} de probabilidad", "de clonar un Comodín en posesión {C:inactive}(debe haber espacio){}"}, unlock = {"Vende un {C:attention}Comodín Invisible{}", "durante una {C:purple}Ciega Jefe{}"}},
            j_kranlaxs_virgo = {name = "Virgo", text = {"Otorga {C:chips}+#1#{} fichas por cada", "comodín {C:attention}sin stickers{} que poseas", "{C:inactive}(Actualmente {C:chips}+#2#{C:inactive} fichas){}"}, unlock = {"Gana una partida en {C:attention}Pozo Negro{} o superior", "sin comodines con stickers"}},
            j_kranlaxs_sagittarius = {name = "Sagitario", text = {"Gana {C:mult}+#1#{} multi al seleccionar una {C:attention}Ciega{}.", "Se reinicia si la Ciega es {C:red}saltada{}", "{C:inactive}(Actualmente {C:mult}+#2#{C:inactive} multi){}"}, unlock = {"Gana una partida", "sin {C:red}saltarte{} ninguna Ciega"}},
            j_kranlaxs_capricorn = {name = "Capricornio", text = {"Asegura que tu porcentaje de {C:attention}Maldad base{}", "nunca descienda por debajo del {C:attention}20%{}"}, unlock = {"Realiza {C:attention}5{} compras en", "el {C:attention}Mercado Negro{}", "{C:inactive}(Progreso: {C:attention}#1#{C:inactive} / 5){}"}},
            j_kranlaxs_taurus = {name = "Tauro", text = {"Si sales de la tienda con menos de {C:money}$#3#{},", "{C:green}#1# en #2#{} de prob. de establecer tu dinero en {C:money}$#3#{}"}, unlock = {"Gana una partida en {C:attention}Pozo Blanco{}", "usando la {C:attention}Baraja Catálogo{}"}},
            j_kranlaxs_cancer = {name = "Cáncer", text = {"{C:green}#1# en #2#{} de probabilidad de {C:attention}evitar la muerte{}.", "Inmune a aumentos externos de probabilidad"}},
            j_kranlaxs_scorpio = {name = "Escorpio", text = {"Cada carta puntuada otorga {X:dark_edition,C:white} ^#1# {} multi"}},
            j_kranlaxs_aquarius = {name = "Acuario", text = {"Antes de puntuar, la primera carta en tu", "mano jugada obtiene la edición {C:blue}Acuática{}", "{C:inactive}(Una vez por {C:attention}Apuesta{C:inactive}){}"}, unlock = {"Gana una partida en {C:attention}Pozo Morado{}", "usando la {C:attention}Baraja de Mazmorra{}"}},
            j_kranlaxs_pisces = {name = "Piscis", text = {"Multiplica tu dinero por {X:money,C:white} X#1# {} al final de ronda.", "El multiplicador aumenta en {X:money,C:white} X#2# {} si juegas {C:attention}#3#{}", "{C:inactive}(La mano objetivo cambia al cumplirse){}"}},
            j_kranlaxs_contrabandista = {name = "Contrabandista", text = {"El {C:attention}Mercado Negro{} tiene {C:attention}1{} espacio adicional.", "Renovar el mercado cuesta {C:purple}1 Token menos{}"}},
            j_kranlaxs_footballstamp = {name = "Estampilla de fútbol", text = {"Cada comodín {C:common}Común{} otorga", "{X:mult,C:white} X#1# {} multi al evaluarse"}},
            j_kranlaxs_battlecard = {name = "Carta de batalla", text = {"Cada comodín {C:rare}Raro{} otorga", "{X:mult,C:white} X#1# {} multi al evaluarse"}},
            j_kranlaxs_american = {name = "Tarjeta de fútbol americano", text = {"Cada comodín {C:legendary}Legendario{} y {C:dark_edition}Cenit{}", "evaluado otorga {X:mult,C:white} X#1# {} multi"}},
            j_kranlaxs_constellation = {name = "Caballero del zodíaco", text = {"Copia la habilidad de un Comodín del {C:attention}Zodíaco{} aleatorio.", "Los valores de escalado acumulados persisten al rotar", "{C:inactive}(Copiado: {C:attention}#1#{C:inactive}){}"}},
            j_kranlaxs_hippie = {name = "Comodín Hippie", text = {"Este Comodín gana {C:mult}+#1#{} multi al usar cartas de", "{C:purple}Tarot Inverso{}, {C:blue}UNO{} o {C:attention}Cuarzos{}", "{C:inactive}(Actualmente {C:mult}+#2#{C:inactive} multi){}"}},
            j_kranlaxs_supremeseed = {name = "Semilla Suprema", text = {"{C:attention}Crea{} un Comodín", "{C:dark_edition}Cenit{} al azar"}},
            j_kranlaxs_ascendedbeanstalk = {name = "Tallo Ascendido", text = {"¿Más frijoles?"}},
            j_kranlaxs_yakuza = {name = "Yakuza", text = {"Gana {X:mult,C:white} X#1# {} multi por cada {X:money,C:white} $#2# {} gastados", "{C:inactive}(Progreso: {X:money,C:white} $#3# {C:inactive} / $#2#){}", "{C:inactive}(Actualmente {X:mult,C:white} X#4# {C:inactive} multi){}"}, unlock = {"Gana una partida en {C:attention}Pozo Cósmico{}", "usando la {C:attention}Baraja Catálogo{}"}},
            j_kranlaxs_credits = {name = "Créditos", text = {"Otorga {C:money}$#2#{} al final de la ronda. El pago aumenta", "en {C:money}+$#3#{} si vences la Ciega en {C:attention}1 sola mano{}"}, unlock = {"Gana en {C:attention}Pozo Mostaza{}", "con {C:attention}3{} barajas distintas", "{C:inactive}(Progreso: {C:attention}#1#{C:inactive} / 3){}"}},
            j_kranlaxs_teddybear = {name = "Osito de Peluche", text = {"Este Comodín gana {C:chips}+#2#{} fichas cada", "vez que un comodín es {C:attention}vendido{}", "{C:inactive}(Actualmente {C:chips}+#1#{C:inactive} fichas){}"}},
            j_kranlaxs_salsadancers = {name = "Bailarines de Salsa", text = {"Si la mano jugada contiene un {C:attention}Par{}, cada carta", "puntuada otorga {X:mult,C:white} X#1# {} multi"}, unlock = {"Juega {C:attention}20 Pares{} en una sola partida"}},
            j_kranlaxs_tribaltattoo = {name = "Tatuaje Tribal", text = {"Antes de puntuar, cada carta en la", "mano jugada gana permanentemente", "{C:mult}+#1#{} multi"}, unlock = {"Gana una partida en {C:attention}Pozo Azul{}", "usando la {C:attention}Baraja de Mazmorra{}"}},
            j_kranlaxs_tsunami = {name = "Tsunami", text = {"Otorga {X:chips,C:white} X#1# {} fichas si el tamaño de mano es de 10 o superior"}, unlock = {"Consigue un tamaño de mano", "de {C:attention}12{} o superior en la partida", "{C:inactive}(Progreso actual: {C:attention}#2#{C:inactive} / 12){}"}},
            j_kranlaxs_kranlax = {name = "Kranlax", text = {"Tu porcentaje de {C:attention}Maldad{}", "se fija permanentemente en {C:attention}100%{}"}},
            j_kranlaxs_cyanuro = {name = "Cyanuro", text = {"Otorga {X:mult,C:white} XMult {} igual al {C:attention}nivel{} actual", "de la mano de póker jugada", "{C:inactive}(Actualmente {X:mult,C:white} X#1# {C:inactive} multi){}"}},
            j_kranlaxs_rottenapple = {name = "Manzana Podrida", text = {"{C:attention}+#1#{} ranuras de Comodín, {C:red}-#2#{} mano por ronda,", "{C:red}-#3#{} descarte por ronda y {C:red}-#4#{} tamaño de mano"}, unlock = {"Gana una partida en {C:attention}Pozo Negro{}", "usando la {C:attention}Baraja Ceniza{}"}},
            j_kranlaxs_venusstatue = {name = "Estatua de Venus", text = {"Otorga {C:money}$#1#{} al final de ronda. {C:green}#3# en #4#{} de prob.", "de aumentar el pago en {C:money}+$#2#{} por carta de {C:attention}Piedra{} puntuada"}, unlock = {"Gana una partida en {C:attention}Pozo Magenta{}", "usando la {C:attention}Baraja Incrustada{}"}},
            j_kranlaxs_beachday = {name = "Día de Playa", text = {"Otorga {X:chips,C:white} X#1# {} fichas si la mano jugada", "es de nivel {C:attention}#2# o superior{}"}, unlock = {"Gana una partida en {C:attention}Pozo Carmesí{}", "usando la {C:attention}Baraja Ceniza{}"}},
            j_kranlaxs_taco = {name = "Taco", text = {"Empieza en {X:mult,C:white} X#1# {} multi. Pierde {X:mult,C:white} X#2# {} multi", "tras cada mano jugada"}},
            j_kranlaxs_legendaryhero = {name = "Comodín veterano", text = {"Gana {C:chips}+#2#{} fichas por cada {C:attention}Reto{}", "completado en tu perfil", "{C:inactive}(Actualmente {C:chips}+#3#{C:inactive} fichas){}"}, unlock = {"Supera {C:attention}1 Reto{} o más", "en tu perfil", "{C:inactive}(Completados: {C:attention}#1#{C:inactive}){}"}},
            j_kranlaxs_cigar = {name = "Cigarro", text = {"Deshabilita las siguientes {C:attention}3{} Ciegas Jefe. No se puede vender.", "Al agotarse, las Ciegas son permanentemente un {C:attention}30% más grandes{}", "{C:inactive}(Restantes: {C:attention}#1#{C:inactive}){}"}},
            j_kranlaxs_couponstrip = {name = "Tira de cupones", text = {"Todas las {C:attention}renovaciones{} de la tienda son {C:green}gratis{}.", "Se agota tras comprar {C:attention}#2#{} artículos de la tienda"}, unlock = {"Renueva la tienda {C:attention}30{} veces", "en una sola partida", "{C:inactive}(Progreso: {C:attention}#1#{C:inactive} / 30){}"}},
            j_kranlaxs_rosary = {name = "Rosario", text = {"La Maldad se bloquea en {C:attention}0%{},", "las renovaciones de tienda cuestan {C:money}$2 menos{}"}, unlock = {"Gana una partida sin abrir el", "{C:attention}Mercado Negro{} y sin comprar", "{C:attention}Vales de Renovación{}"}},
            j_kranlaxs_rose = {name = "Rosa", text = {"Otorga {X:mult,C:white} X#1# {} multi.", "Se {C:attention}marchita{} en una Rosa marchita si la tocas"}},
            j_kranlaxs_wiltedrose = {name = "Rosa marchita", text = {"Otorga {X:mult,C:white} X#1# {} multi.", "Pierdes {C:money}$#2#{} al venderla"}},
            j_kranlaxs_earrings = {name = "Aretes", text = {"{C:green}#1# en #2#{} de probabilidad de crear un {C:attention}Cuarzo{}", "aleatorio al seleccionar una Ciega {C:inactive}(debe haber espacio){}"}, unlock = {"Usa {C:attention}5 Cuarzos{}", "en tu perfil"}},
            j_kranlaxs_silkgloves = {name = "Guantes de seda", text = {"{C:attention}+1{} tamaño de mano por cada {C:money}$#1#{} en posesión", "{C:inactive}(Actualmente {C:attention}+#2#{C:inactive} tamaño de mano){}"}},
            j_kranlaxs_dementia = {name = "Demencia", text = {"Hace... algo"}},
            j_kranlaxs_keychain = {name = "Llavero", text = {"Otorga {C:mult}+#1#{} multi si tienes", "{C:attention}3 o menos{} comodines en el inventario"}},
            j_kranlaxs_soap = {name = "Jabón", text = {"Otorga {X:mult,C:white} X#1# {} multi. Pierde {X:mult,C:white} X#2# {} por cada carta puntuada", "con mejora, sello o edición, {C:attention}limpiando{}", "todas las modificaciones de esa carta"}},
            j_kranlaxs_lifeoftheparty = {name = "Alma de la fiesta", text = {"Gana {X:mult,C:white} X#1# {} multi por cada Comodín en posesión", "{C:inactive}(Actualmente {X:mult,C:white} X#2# {C:inactive} multi){}"}},
            j_kranlaxs_fridaythe13th = {name = "Viernes 13", text = {"Este Comodín gana {C:mult}+#1#{} multi por cada", "{C:attention}figura{} destruida", "{C:inactive}(Actualmente {C:mult}+#2#{C:inactive} multi){}"}},
            j_kranlaxs_guardianangel = {name = "Ángel guardián", text = {"Mientras no abras el {C:attention}Mercado Negro{}, ninguna carta", "puede ser {C:red}debilitada{}, {C:red}destruida{} ni {C:attention}volteada{}", "{C:inactive}(Estado: {C:attention}#1#{C:inactive}){}"}, unlock = {"Gana una partida sin", "abrir el {C:attention}Mercado Negro{}"}},
            j_kranlaxs_scalper = {name = "Bootleg", text = {"Los {C:attention}Paquetes Potenciadores{} tienen {C:attention}+2{} opciones extra"}, unlock = {"Abre {C:attention}100{} Paquetes Potenciadores", "{C:inactive}(Progreso: {C:attention}#1#{C:inactive} / 100){}"}},
            j_kranlaxs_christmastree = {name = "Árbol de Navidad", text = {"Si la Ciega no fue derrotada en una sola mano,", "crea un {C:attention}Comodín Reregalado{} al final de la ronda"}, unlock = {"Vende {C:attention}5{} Comodines Reregalados", "{C:inactive}(Progreso: {C:attention}#1#{C:inactive} / 5){}"}},
            j_kranlaxs_scarf = {name = "Bufanda", text = {"Este Comodín gana {C:mult}+#2#{} multi por cada mano", "jugada que contenga un {C:attention}Color{}", "{C:inactive}(Actualmente {C:mult}+#1#{C:inactive} multi){}"}},
            j_kranlaxs_belt = {name = "Cinturón", text = {"Otorga {X:mult,C:white} X#3# {} multi por cada carta por debajo", "de {C:attention}#2#{} en tu tamaño de mano", "{C:inactive}(Actualmente {X:mult,C:white} X#4# {C:inactive} multi){}"}, unlock = {"Ten un tamaño de mano", "de {C:attention}3 o menos{}", "{C:inactive}(Actual: {C:attention}#1#{C:inactive}){}"}},
            j_kranlaxs_nightlamp = {name = "Lámpara de Noche", text = {"{C:green}#2# en #3#{} de prob. de otorgar {C:attention}+#4#{} tamaño de mano", "durante la ronda al seleccionar una {C:attention}Ciega{}"}, unlock = {"Derrota a {C:attention}50{} Ciegas Jefe", "en tu perfil", "{C:inactive}(Progreso: {C:attention}#1#{C:inactive} / 50){}"}},
            j_kranlaxs_darkhallway = {name = "Pasillo Oscuro", text = {"Otorga {X:dark_edition,C:white} ^#2# {} multi, {C:red}-#3#{} al tamaño de mano"}, unlock = {"Compra el Comodín {C:attention}Lámpara de Noche{}", "{C:attention}3 veces{}", "{C:inactive}(Compradas: {C:attention}#1#{C:inactive} / 3){}"}},
            j_kranlaxs_brokenmodem = {name = "Módem Roto", text = {"Las cartas jugadas tienen un {C:green}#3# en #4#{} de", "probabilidad de {C:attention}reactivarse{}"}, unlock = {"Gana una partida con la {C:attention}Baraja Roja{}", "en {C:attention}Pozo Cristal{} y {C:attention}Pozo Carmesí{}", "{C:inactive}(Cristal: #1#/1, Carmesí: #2#/1){}"}},
            j_kranlaxs_alienjoker = {name = "Comodín Alienígena", text = {"{C:attention}-#2#{} al límite de cartas seleccionables.", "Otorga {X:mult,C:white} X#3# {} multi"}, unlock = {"Gana una partida en {C:attention}Pozo Verde{}", "usando {C:attention}5 barajas diferentes{}", "{C:inactive}(Barajas usadas: {C:attention}#1#{C:inactive} / 5){}"}},
            j_kranlaxs_ophiuchus = {name = "Ofiuco", text = {"Cada carta puntuada de tipo {C:attention}#9#{} otorga {X:money,C:white} $#10# {}.", "La mejora objetivo cambia cada ronda,", "priorizando mejoras presentes en tu baraja"}, unlock = {"Usa cartas de Tarot base dos veces:", "{C:inactive}Hiero: #1#/2, Empr: #2#/2, Love: #3#/2, Char: #4#/2{}", "{C:inactive}Just: #5#/2, Towe: #6#/2, Magi: #7#/2, Devi: #8#/2{}"}},
            j_kranlaxs_brokenvhs = {name = "VHS Roto", text = {"Al finalizar la mano, las cartas jugadas tienen un {C:green}#2# en #3#{}", "de probabilidad de regresar a tu mano"}, unlock = {"Usa la carta UNO {C:blue}Rejugar{}", "{C:attention}5 veces{}", "{C:inactive}(Progreso: {C:attention}#1#{C:inactive} / 5){}"}},
            j_kranlaxs_berserker = {name = "Comodín Berserker", text = {"Al vencer una {C:purple}Ciega Jefe{}, se activa por {C:attention}60s{}", "y da {X:mult,C:white} X#1# {} multi. Otras Ciegas dan {C:attention}+30s{}", "{C:inactive}(Tiempo: #2#s){}"}},
            j_kranlaxs_emergencyinstructions = {name = "Instrucciones de emergencias", text = {"En tu {C:attention}última mano{}, las cartas puntuadas otorgan", "sus bonificaciones completas de {C:chips}fichas{} y {C:mult}multi{} otra vez"}},
            j_kranlaxs_hippodrome = {name = "Hipódromo", text = {"Gana {X:mult,C:white} XMult {} según la velocidad en tiempo real", "al derrotar la {C:attention}Ciega{} {C:inactive}(Tiempo Real){}", "{C:inactive}<15s: {X:mult,C:white}X0.75{C:inactive} | <30s: {X:mult,C:white}X0.4{}", "{C:inactive}<60s: {X:mult,C:white}X0.2{C:inactive} | >60s: {X:mult,C:white}X0.1{}", "{C:inactive}(Actualmente {X:mult,C:white} X#2# {C:inactive} Mult | #3#s){}"}, unlock = {"Juega {C:attention}20 Colores{}", "en una sola partida", "{C:inactive}(Progreso: {C:attention}#1#{C:inactive} / 20){}"}},
            j_kranlaxs_postit = {name = "Post-it", text = {"{C:green}#1# en #2#{} de prob. de copiar la habilidad", "del {C:attention}Comodín{} a la izquierda"}, unlock = {"Gana una partida en {C:attention}Pozo Dorado{}", "usando la {C:attention}Baraja Catálogo{}"}},
            j_kranlaxs_semaforo = {name = "Semáforo", text = {"Las {C:attention}Ciegas Pequeñas{} otorgan {C:money}+$4{} de pago,", "las {C:attention}Ciegas Grandes{} otorgan {C:money}+$2{} y", "las {C:attention}Ciegas Jefe{} otorgan {C:money}$0{}"}},
            j_kranlaxs_tabletagrafica = {name = "Tableta Gráfica", text = {"{C:attention}+#4#{} ranura de Comodín por cada {C:money}$#1#{} en posesión.", "{C:green}#2# en #3#{} de probabilidad de {C:red}autodestruirse{}", "al final de la ronda"}},
            j_kranlaxs_chronometer = {name = "Cronómetro", text = {"Al jugar una mano: otorga {C:chips}fichas{} igual", "a los {C:attention}Segundos{} actuales, {C:mult}multi{} igual a los", "{C:attention}Minutos{} actuales y gana {C:money}dinero{} igual a las", "{C:attention}Horas{} actuales una vez por Apuesta"}, unlock = {"Gana una partida en {C:attention}Pozo de Oro{}", "o superior usando la", "{C:attention}Baraja Espacial{}"}},
            
            j_kranlaxs_fenix = {name = "Fenix", text = {"Al {C:red}destruir{} una carta con mejora,", "acumula y aplica permanentemente", "los efectos de esas mejoras", "{C:inactive}(Bono: #1#, Multi: #2#, Vidrio: #3#, Acero: #4#){}", "{C:inactive}(Suerte: #5#, Oro: #6#, Versátil: #7#, S.Azul: #8#){}"}, unlock = {"Gana una partida en {C:attention}Pozo Cósmico{}", "usando la {C:attention}Baraja Ceniza{}"}},
            
            j_kranlaxs_jar = {name = "La Jarra", text = {"Cuando vendes el {C:attention}Comodín{} a la {C:attention}izquierda{},", "esta carta {C:attention}registra{} su habilidad.", "Al ser {C:gold}vendida{}, crea una copia de los {C:attention}#1#/#2#{}", "Comodines registrados y pierdes {C:red}$#3#{} {C:inactive}($4 x Apuesta){}", "{C:inactive}Registro:{} {C:attention}#4#{}, {C:attention}#5#{}, {C:attention}#6#{}, {C:attention}#7#{}, {C:attention}#8#{}"}, unlock = {"Gana {C:attention}5{} partidas en", "{C:attention}Pozo de Cristal{} o superior", "{C:inactive}(Progreso: {C:attention}#1#{C:inactive} / 5){}"}},
            j_kranlaxs_hojadecuaderno = {name = "Hoja de Cuaderno", text = {"Añade 1 {C:attention}Carta de la Suerte{} aleatoria a", "tu baraja al seleccionar una {C:attention}Ciega{}"}},
            j_kranlaxs_crayonbox = {name = "Caja de Crayones", text = {"Las cartas puntuadas de {C:attention}#1#{} se convierten en", "{C:attention}Cartas Versátiles{} {C:inactive}(si no poseen otra mejora){}"}, unlock = {"Usa la carta de Tarot", "{C:purple}Los Enamorados{} 10 veces", "{C:inactive}(Progreso: {C:attention}#1#{C:inactive} / 10){}"}},
            j_kranlaxs_cubicaljoker = {name = "Comodín Cúbico", text = {"Otorga {C:mult}+#1#{} multi. El valor se eleva al", "{C:attention}Cubo (^3){} por cada {C:attention}Ciega Jefe{} vencida"}, unlock = {"Gana en {C:attention}Pozo Dorado{} o superior", "con {C:attention}12{} barajas diferentes", "{C:inactive}(Progreso: {C:attention}#1#{C:inactive} / 12){}"}},
            j_kranlaxs_curseddice = {name = "Dado Maldito", text = {"Al {C:attention}renovar{} la tienda, reduce en {C:attention}1{}", "el ID interno del {C:attention}Comodín{} a la izquierda", "{C:inactive}(Muta en el Comodín anterior de la colección){}"}, unlock = {"Gana en {C:attention}Pozo Carmesí{} o superior", "con {C:attention}7{} barajas diferentes", "{C:inactive}(Progreso: {C:attention}#1#{C:inactive} / 7){}"}},
            j_kranlaxs_holywater = {name = "Agua bendita", text = {"Al ser {C:gold}vendida{}, fija la Maldad en {C:attention}0%{} y garantiza", "un {C:attention}Comodín{} en la tienda de la {C:attention}siguiente partida{}"}, unlock = {"Gana en {C:attention}Pozo Cósmico{} o superior", "con {C:attention}4{} barajas diferentes", "{C:inactive}(Progreso: {C:attention}#1#{C:inactive} / 4){}"}},
            j_kranlaxs_leo = {name = "Leo", text = {"Otorga {X:mult,C:white} X#1# {} multi. Gana {X:mult,C:white} X#2# {} multi adicional", "por cada Comodín en posesión con sticker {C:attention}Eterno{}", "{C:inactive}(Actualmente {X:mult,C:white} X#3# {C:inactive} multi){}"}, unlock = {"Gana en {C:attention}Pozo Negro{} o superior", "con {C:attention}15{} barajas diferentes", "{C:inactive}(Progreso: {C:attention}#1#{C:inactive} / 15){}"}},
            -- ================= PECADOS (DEMONIOS) =================
j_kranlaxs_furioso = {name = "Demonio rabioso", text = {"La {C:attention}primera{} carta puntuada", "otorga {X:mult,C:white} X#1# {} mult", "y luego se {C:red}destruye{}"}},
j_kranlaxs_libidinoso = {name = "El Íncubo", text = {"Al puntuar, las cartas te otorgan", "las mismas {C:chips}fichas{} y {C:mult}multi{} que", "dio la carta evaluada anterior"}},
j_kranlaxs_envidia = {name = "Demonio envidioso", text = {"{C:red}Inhabilita{} a todos tus", "demás comodines.", "Otorga {X:mult,C:white} X#1# {} mult por", "cada comodín inhabilitado", "{C:inactive}(Actualmente {X:mult,C:white} X#2# {C:inactive} mult){}"}},
j_kranlaxs_avaricia = {name = "Demonio avaricioso", text = {"Gana {X:money,C:white} $#2# {} extra al final", "de la ronda por cada {X:money,C:white} $#1# {}", "por encima de tu {C:attention}límite de interés{}", "{C:inactive}(Límite actual: {X:money,C:white} $#3# {C:inactive}){}", "{C:inactive}(Ganancia actual: {X:money,C:white} +$#4# {C:inactive}){}"}},
j_kranlaxs_gula = {name = "Demonio goloso", text = {"Crea un comodín de {C:attention}comida{}", "aleatorio cada vez", "que vences a una ciega", "{C:inactive}(Si hay espacio){}"}},
j_kranlaxs_pereza = {
    name = "Demonio holgazán", 
    text = {
        "Al robar tu {C:attention}primera mano{},", 
        "suma el {C:attention}50%{} del puntaje", 
        "requerido de la ciega", 
        "a tu marcador de ronda"
    }
},
j_kranlaxs_soberbia = {name = "Demonio orgulloso", text = {"+{C:mult}#1#{} Mult por cada", "partida {C:attention}ganada en racha{}", "{C:inactive}(Actualmente {C:mult}+#2#{C:inactive} Mult){}", "{C:inactive}(Racha actual: {C:attention}#3#{C:inactive}){}"}},

-- ================= VIRTUDES (ÁNGELES) =================
j_kranlaxs_humildad = {name = "Ángel humilde", text = {"Otorga {X:mult,C:white} X#1# {} Mult mientras", "solo tengas Comodines", "{C:blue}Comunes{} o {C:green}Inusuales{}"}},
j_kranlaxs_castidad = {name = "Ángel casto", text = {"Gana {X:mult,C:white} X#1# {} Mult permanente", "por cada carta puntuada que no", "tenga mejora, edición ni sello", "{C:inactive}(Actualmente {X:mult,C:white} X#2# {C:inactive} Mult){}"}},
j_kranlaxs_templanza = {name = "Ángel sereno", text = {"Gana {X:money,C:white} $#1# {} al final de la", "ronda por cada mano jugada que", "tenga el mismo nivel que", "tu mano más jugada", "{C:inactive}(Ganancia actual: {X:money,C:white} $#2# {C:inactive}){}"}},
j_kranlaxs_amabilidad = {name = "Ángel amable", text = {"Las cartas de rango {C:attention}2, 3, 4, 5 y 6{}", "{C:attention}siempre{} puntúan y otorgan", "el {C:attention}doble{} del valor en fichas", "de la carta más alta jugada"}},
j_kranlaxs_caridad = {name = "Ángel caritativo", text = {"Al final de la ronda, si", "tienes más de {C:money}$#1#{}, gástalos para", "añadir {X:mult,C:white} X#2# {} Mult permanente a", "{C:attention}#3#{} cartas aleatorias en tu baraja"}},
j_kranlaxs_paciencia = {name = "Ángel paciente", text = {"Gana {X:chips,C:white} X#1# {} Fichas por", "cada ciega que es saltada", "Se reinicia si usas un consumible", "{C:inactive}(Actualmente {X:chips,C:white} X#2# {C:inactive} Fichas){}"}},
j_kranlaxs_diligencia = {name = "Ángel diligente", text = {"+{C:mult}#1#{} Mult por cada", "{C:attention}Apuesta (Ante){} actual", "{C:inactive}(Actualmente {C:mult}+#2#{C:inactive} Mult){}"}},

-- ================= EXTRAS =================
j_kranlaxs_minimalista = {name = "Comodín minimalista", text = {"Todas las manos de póker", "requieren {C:attention}1 carta menos{}", "para ser válidas", "{C:inactive}(Un par solo requiere 1 carta, etc.){}"}}
        },
        Back = {
            b_kranlaxs_week_challenge = {name = "Reto Semanal", text = {"Empiezas con un Joker de {C:attention}Desafío Semanal{}", "{C:red}Superable{} cada {C:attention}fin de semana{}"}, unlock = {"Abre el juego durante un", "{C:attention}Sábado{} o {C:attention}Domingo{}"}}, --[cite: 9]
            b_kranlaxs_chaos_deck = {name = "Baraja del Caos", text = {"Empiezas con {C:attention}5{} manos, {C:attention}5{} descartes,", "{C:money}$25{} y los {C:attention}8 Vales{} del mod.", "{C:attention}Toca 2 veces{} un {C:attention}Comodín{} en la", "colección para conjurarlo {C:red}(1 vez por partida){}"}, unlock = {"Desbloquea {C:legendary,E:1}TODO{} en", "tu colección"}},
            b_kranlaxs_dungeon_deck = {name = "Baraja de Mazmorra", text = {"Tras vencer a una {C:attention}Ciega Jefe{},", "elige entre 3 {C:attention}opciones{}", "con {C:green}pros{} y {C:red}contras{}"}, unlock = {"Gana una partida en {C:attention}Pozo Verde{}", "o superior usando la", "baraja del {C:attention}Reto Semanal{}"}}, --[cite: 9]
            b_kranlaxs_bugged_deck = {name = "Baraja Bugueada", text = {"!?"}, unlock = {"Adquiere un {C:attention}TMTRAINER{}", "por primera vez"}}, --[cite: 9]
            b_kranlaxs_space_deck = {name = "Baraja Espacial", text = {"Sube {C:attention}4 niveles{} a una", "{C:attention}mano de póker{} aleatoria", "al inicio de la partida"}, unlock = {"Haz que una mano de póker", "alcance el {C:attention}Nivel 100{}", "{C:inactive}(Progreso: {C:attention}#1#{C:inactive} / 100){}"}}, --[cite: 9]
            b_kranlaxs_embedded_deck = {name = "Baraja Incrustada", text = {"Empiezas con {C:attention}0{} ranuras de comodín", "y {C:attention}+3{} ranuras de consumibles.", "Los {C:attention}Cuarzos{} invaden la tienda"}, unlock = {"Desbloquea {C:attention}10{} Cuarzos", "o más en tu colección", "{C:inactive}(Desbloqueados: {C:attention}#1#{C:inactive} / 10){}"}}, --[cite: 9]
            b_kranlaxs_ash_deck = {name = "Baraja Ceniza", text = {"Comienzas con los vales {C:attention}Truco de magia{}", "y {C:attention}Ilusión{}.", "Cada carta en tu mano tiene {C:green}1 en 4{}", "probabilidades de destruirse", "al {C:attention}jugar una mano{}"}, unlock = {"Usa la carta", "{C:spectral}Inmolar{} 5 veces", "{C:inactive}(Usos: {C:attention}#1#{C:inactive} / 5){}"}}, --[cite: 9]
            b_kranlaxs_catalog_deck = {name = "Baraja Catálogo", text = {"La tienda tiene {C:attention}+2 espacios{},", "{C:attention}+1 espacio{} de Vales y", "{C:attention}+1 espacio{} de Paquetes.", "Comienzas con {C:money}$0{}"}, unlock = {"Compra {C:attention}200{} Jokers", "en la tienda", "{C:inactive}(Progreso: {C:attention}#1#{C:inactive} / 200){}"}}, --[cite: 9]
            b_kranlaxs_evil_deck = {name = "Baraja Malvada", text = {"El medidor de {C:attention}Maldad{} siempre", "se mantiene al {C:attention}100%{}", "Las ciegas crecen {C:red}más rápido{}", "Los jefes dan el {C:attention}doble de Tokens{}"}, unlock = {"Compra {C:attention}50{} artículos", "en el Mercado Negro", "{C:inactive}(Progreso: {C:attention}#1#{C:inactive} / 50){}"}}, --[cite: 9]
            b_kranlaxs_brown_deck = {name = "Baraja Café", text = {"Las cartas {C:attention}jugadas{} son {C:red}destruidas{},", "pero se añade una {C:attention}copia", "{C:attention}idéntica{} a tu baraja"}, unlock = {"Destruye {C:attention}400{} cartas", "o comodines en total", "{C:inactive}(Progreso: {C:attention}#1#{C:inactive} / 400){}"}} --[cite: 9]
        },
        

        Stake = {
    stake_kranlaxs_magenta = {name = "Pozo Magenta", text = {"Las cartas en la tienda pueden", "tener el sticker {C:attention}Fijado{}"}},
    stake_kranlaxs_brown = {name = "Pozo Marrón", text = {"{C:attention}-1{} espacio de", "{C:attention}Paquete de Mejora{} en la tienda"}},
    stake_kranlaxs_turquoise = {name = "Pozo Turquesa", text = {"Las ciegas tienen un {C:attention}35%{} de", "probabilidad de {C:red}no poder saltarse{}"}},
    stake_kranlaxs_crimson = {name = "Pozo Carmesí", text = {"Las {C:purple}Ciegas Jefe{} otorgan", "solo un {C:attention}7%{} de Maldad", "al ser derrotadas {C:inactive}(antes 15%){}"}},
    stake_kranlaxs_glass = {name = "Pozo de Cristal", text = {"Los comodines en tiendas o paquetes", "pueden tener el sticker {C:attention}Cegado{}"}},
    stake_kranlaxs_mustard = {name = "Pozo Mostaza", text = {"Empiezas la partida con", "{C:money}-2${} y {C:attention}-1{} Token"}},
    stake_kranlaxs_platinum = {name = "Pozo Cósmico", text = {"Debes vencer la {C:attention}Apuesta 10{}", "para ganar la partida"}}
},

        UNOCards = {
            c_kranlaxs_skip = {name = "Saltar", text = {"Elimina {C:attention}todos los stickers{}", "de {C:attention}1 Comodín{} seleccionado.", "{C:inactive}(No elimina Fijado en Retos){}"}},
            c_kranlaxs_stacking = {name = "Apilar", text = {"Añade un {C:attention}Sello Rosa{} a", "{C:attention}1{} carta seleccionada en tu mano"}}, --[cite: 9]
            c_kranlaxs_draw2 = {name = "Roba 2", text = {"Roba {C:attention}2 cartas adicionales{} a tu mano,", "pierdes {C:blue}1{} mano"}}, --[cite: 9]
            c_kranlaxs_draw4 = {name = "Roba 4", text = {"Roba {C:attention}4 cartas adicionales{} a tu mano,", "pierdes {C:blue}1{} mano"}}, --[cite: 9]
            c_kranlaxs_reverse = {name = "Reversa", text = {"Devuelve {C:attention}todas las cartas{} de tu mano", "a la baraja y las {C:attention}rebarajea{}"}}, --[cite: 9]
            c_kranlaxs_wildcard = {name = "Comodín de color", text = {"Convierte hasta {C:attention}3{} cartas seleccionadas", "en cartas {C:attention}Versátiles{} con una", "{C:dark_edition}Edición{} aleatoria"}}, --[cite: 9]
            c_kranlaxs_replay = {name = "Rejugar", text = {"Devuelve las cartas de la última", "mano jugada a tu mano {C:inactive}(se reinicia", "{C:inactive}tras su uso o al fin de ronda){}"}}, --[cite: 9]
            c_kranlaxs_discardall = {name = "Descarta todo", text = {"Requiere {C:attention}1{} carta seleccionada. Descarta {C:red}todas{}", "las cartas de tu mano y baraja del mismo palo"}}, --[cite: 9]
            c_kranlaxs_shield = {name = "Escudo", text = {"Te protege pasivamente de la {C:red}muerte{}, o", "puedes venderla para {C:attention}deshabilitar{} la {C:purple}Ciega Jefe{}"}}, --[cite: 9]
            c_kranlaxs_misery = {name = "Miseria", text = {"Elige un {C:attention}Palo{}. Robarás cartas de tu baraja", "sin parar hasta que obtengas una de ese palo"}}, --[cite: 9]
            c_kranlaxs_gift = {name = "Regalo", text = {"Otorga {C:attention}1{} recompensa al azar:", "• Un {C:attention}Comodín{} con Edición", "• Un {C:dark_edition}Consumible Negativo{}", "• Una {C:attention}Carta{} con Mejora, Sello y Edición"}}, --[cite: 9]
            c_kranlaxs_customdraw = {name = "Robo Personalizado", text = {"Selecciona {C:attention}1 Joker{} en la tienda y usa esta", "carta para {C:attention}robarlo forzosamente{} {C:inactive}(ignora espacio){}"}} --[cite: 9]
        },

        InverseTarot = {
            c_kranlaxs_thefool = {name = "¿El Loco?", text = {"Crea una carta {C:spectral}Espectral{} aleatoria.", "{C:red}Baja de nivel{} una mano de póker aleatoria"}}, --[cite: 9]
            c_kranlaxs_themagician = {name = "¿El Mago?", text = {"Crea {C:attention}2{} cartas de la {C:attention}Suerte{} aleatorias"}}, --[cite: 9]
            c_kranlaxs_thehighpriestess = {name = "¿La Sacerdotisa?", text = {"Crea un {C:spectral}Agujero Negro{}.", "Tu dinero {C:red}disminuye{} un {C:attention}20%{}"}}, --[cite: 9]
            c_kranlaxs_theempress = {name = "¿La Emperatriz?", text = {"Añade {C:mult}+8{} multi permanente", "hasta a {C:attention}2{} cartas seleccionadas"}}, --[cite: 9]
            c_kranlaxs_theemperor = {name = "¿El Emperador?", text = {"Crea {C:attention}2{} {C:attention}Etiquetas{} aleatorias"}}, --[cite: 9]
            c_kranlaxs_thehierophant = {name = "¿El Hierofante?", text = {"Añade {C:chips}+40{} fichas permanentes", "hasta a {C:attention}2{} cartas seleccionadas"}}, --[cite: 9]
            c_kranlaxs_thelovers = {name = "¿Los Enamorados?", text = {"Otorga {C:attention}+1{} tamaño de mano si", "posees una {C:attention}Carta Versátil{} en tu baraja"}}, --[cite: 9]
            c_kranlaxs_thechariot = {name = "¿El Carro?", text = {"Crea {C:attention}1{} carta de {C:attention}Acero{} aleatoria", "con un {C:red}Sello Rojo{}"}}, --[cite: 9]
            c_kranlaxs_justice = {name = "¿La Justicia?", text = {"Añade {X:mult,C:white} X2 {} multi permanente a {C:attention}1{} carta.", "Probabilidad de {C:green}#1# en #2#{} de {C:red}destruir{} esa carta"}}, --[cite: 9]
            c_kranlaxs_thehermit = {name = "¿El Ermitaño?", text = {"Fija tu dinero en {X:money,C:white} $25 {} si", "posees menos de {X:money,C:white} $25 {}"}}, --[cite: 9]
            c_kranlaxs_thewheeloffortune = {name = "¿La Rueda de la Fortuna?", text = {"{C:green}#1# en #2#{} de probabilidad de crear un clon de", "un Joker aleatorio con edición {C:dark_edition}Negativa{}"}}, --[cite: 9]
            c_kranlaxs_strenght = {name = "¿La Fuerza?", text = {"Reduce la categoría de hasta {C:attention}2{} cartas en {C:attention}1{}"}}, --[cite: 9]
            c_kranlaxs_thehangedman = {name = "¿El Colgado?", text = {"{C:attention}Aleatoriza{} por completo rango y palo", "de hasta {C:attention}2{} cartas seleccionadas"}}, --[cite: 9]
            c_kranlaxs_death = {name = "¿La Muerte?", text = {"Crea una copia {C:dark_edition}Negativa{} de un Joker aleatorio.", "Un Joker en posesión recibe sticker {C:attention}Perecedero{}"}}, --[cite: 9]
            c_kranlaxs_temperance = {name = "¿La Templanza?", text = {"Vende {C:attention}TODOS{} los Jokers (incluso Eternos) por el", "{C:money}triple{} de su valor de venta {C:inactive}(Fijados inmunes){}"}}, --[cite: 9]
            c_kranlaxs_thedevil = {name = "¿El Diablo?", text = {"Añade {X:money,C:white} $2 {} de venta permanentes", "hasta a {C:attention}2{} cartas seleccionadas"}}, --[cite: 9]
            c_kranlaxs_thetower = {name = "¿La Torre?", text = {"Elimina mejoras, sellos y ediciones de las cartas", "en mano. Gana {X:money,C:white} $1 {} por modificación eliminada"}}, --[cite: 9]
            c_kranlaxs_thestars = {name = "¿Las Estrellas?", text = {"Añade un {C:attention}Sello Blanco{} hasta a {C:attention}2{} cartas"}}, --[cite: 9]
            c_kranlaxs_themoon = {name = "¿La Luna?", text = {"Añade un {C:attention}Sello Gris{} hasta a {C:attention}2{} cartas"}}, --[cite: 9]
            c_kranlaxs_thesun = {name = "¿El Sol?", text = {"Añade un {C:attention}Sello Naranja{} hasta a {C:attention}2{} cartas"}}, --[cite: 9]
            c_kranlaxs_judgement = {name = "¿El Juicio?", text = {"Canjea un {C:attention}Vale{} aleatorio. {C:red}-1{} al tamaño de mano"}}, --[cite: 9]
            c_kranlaxs_theworld = {name = "¿El Mundo?", text = {"Añade un {C:attention}Sello Café{} hasta a {C:attention}2{} cartas"}} --[cite: 9]
        },

        Voucher = {
            v_kranlaxs_more_stock = {name = "Más Inventario", text = {"La tienda tiene {C:attention}+1{} espacio", "adicional de {C:attention}Paquetes{}"}},
            v_kranlaxs_even_more_stock = {name = "Aún Más Inventario", text = {"La tienda tiene {C:attention}+1{} espacio", "adicional de {C:attention}Vales{}"}, unlock = {"Compra {C:attention}50{} Vales", "en total", "{C:inactive}(Progreso: {C:attention}#1#{C:inactive} / 50){}"}},
            v_kranlaxs_shiny_appearance = {name = "Aparición Inusual", text = {"Cartas legendarias y consumibles raros", "ahora pueden aparecer en la tienda"}},
            v_kranlaxs_stickerfever = {name = "Fiebre de Pegatinas", text = {"Al obtener una {C:attention}Etiqueta{}, {C:green}1 en 2{} de", "probabilidad de recibir {C:attention}1 copia extra{}"}},
            v_kranlaxs_stickeralbum = {name = "Álbum de Pegatinas", text = {"Al obtener una {C:attention}Etiqueta{}, otra probabilidad", "de {C:green}1 en 2{} de recibir {C:attention}1 copia extra{}"}, unlock = {"Salta {C:attention}75{} Ciegas", "en total", "{C:inactive}(Progreso: {C:attention}#1#{C:inactive} / 75){}"}},
            v_kranlaxs_hotfix = {name = "Hotfix", text = {"{C:attention}Renovar{} la tienda también", "reabastece los {C:attention}Paquetes Potenciadores{}"}},
            v_kranlaxs_version2 = {name = "Versión 2.0", text = {"Saltar Ciegas otorga su pago económico.", "Requisito de puntuación de Ciegas {C:attention}-15%{}"}, unlock = {"Renueva la tienda", "{C:attention}100{} veces en total", "{C:inactive}(Progreso: {C:attention}#1#{C:inactive} / 100){}"}},
            v_kranlaxs_common_shinys = {name = "Avistamiento Legendario", text = {"Cartas legendarias y consumibles raros", "aparecen el doble de frecuente"}, unlock = {"Usa la carta espectral", "{C:spectral}El Alma{} 3 veces", "{C:inactive}(Progreso: {C:attention}#1#{C:inactive} / 3){}"}},
            v_kranlaxs_blessing = {name = "Bendición", text = {"Comienzas cada Ciega con el {C:attention}10%{} del", "requisito de puntuación ya completado"}},
            v_kranlaxs_protection = {name = "Protección Divina", text = {"Evita un {C:red}Fin de la Partida{}. Se destruye", "al activarse y reaparece en futuras tiendas", "al {X:money,C:white}doble{} de su precio original"}}
        },

        Quartz = {
            c_kranlaxs_blackquartz = {name = "Obsidiana", text = {"Modifica reglas de partida", "bajo tu elección"}, unlock = {"Gana una partida en {C:attention}Pozo Marrón{}", "usando la {C:attention}Baraja Mágica{}"}}, --[cite: 9]
            c_kranlaxs_whitequartz = {name = "Perla", text = {"Crea el último consumible usado", "{C:inactive}(Último: {C:attention}#1#{C:inactive}){}"}, unlock = {"Gana una partida en {C:attention}Pozo Marrón{}", "usando la {C:attention}Baraja Fantasma{}"}}, --[cite: 9]
            c_kranlaxs_pinkquartz = {name = "Cuarzo Rosa", text = {"Añade {C:dark_edition}Polícromo{} a un {C:attention}Joker{}", "o a una {C:attention}carta{} seleccionada"}, unlock = {"Gana en {C:attention}Pozo Magenta{}", "o superior con {C:attention}Baraja de Mazmorra{}"}}, --[cite: 9]
            c_kranlaxs_bluequartz = {name = "Zafiro", text = {"Añade {C:dark_edition}Laminado{} a un {C:attention}Joker{}", "o a una {C:attention}carta{} seleccionada"}, unlock = {"Gana una partida en {C:attention}Pozo Cósmico{}", "usando la {C:attention}Baraja de Plasma{}"}}, --[cite: 9]
            c_kranlaxs_lilacquartz = {name = "Kunzita", text = {"Añade {C:dark_edition}Holográfico{} a un {C:attention}Joker{}", "o a una {C:attention}carta{} seleccionada"}, unlock = {"Gana una partida en {C:attention}Pozo Marrón{}", "usando la {C:attention}Baraja Nébula{}"}}, --[cite: 9]
            c_kranlaxs_grayquartz = {name = "Hematita", text = {"Añade {C:dark_edition}Negativo{} a un {C:attention}Joker{}", "o {C:attention}consumible{} seleccionado"}, unlock = {"Gana una partida en {C:attention}Pozo Turquesa{}", "usando la {C:attention}Baraja Pintada{}"}}, --[cite: 9]
            c_kranlaxs_transparentquartz = {name = "Diamante", text = {"Elimina stickers y ediciones de un {C:attention}Joker{},", "o sellos y ediciones de una {C:attention}carta{}"}, unlock = {"Gana una partida en {C:attention}Pozo Cósmico{}", "usando la {C:attention}Baraja de Mazmorra{}"}}, --[cite: 9]
            c_kranlaxs_redquartz = {name = "Rubí", text = {"Mientras esté en tus consumibles,", "otorga {X:mult,C:white} X2 {} multi {C:inactive}(Pasivo){}"}, unlock = {"Gana en {C:attention}Pozo Magenta{}", "o superior con {C:attention}Baraja Roja{}"}}, --[cite: 9]
            c_kranlaxs_celestequartz = {name = "Larimar", text = {"Mientras esté en tus consumibles,", "otorga {X:chips,C:white} X1.5 {} fichas {C:inactive}(Pasivo){}"}, unlock = {"Gana una partida en {C:attention}Pozo Turquesa{}", "usando la {C:attention}Baraja de Cuadros{}"}}, --[cite: 9]
            c_kranlaxs_yellowquartz = {name = "Topacio", text = {"Crea al {C:attention}Joker{} indicado.", "El objetivo cambia al azar tras cada ronda", "{C:inactive}(Objetivo: {C:attention}#1#{C:inactive}){}"}, unlock = {"Gana una partida en {C:attention}Pozo Azul{}", "usando la {C:attention}Baraja de Mazmorra{}"}}, --[cite: 9]
            c_kranlaxs_greenquartz = {name = "Esmeralda", text = {"Mientras lo poseas, crea una {C:attention}Etiqueta{} al vencer", "una Ciega. Se destruye tras crear {C:attention}#2#{} {C:inactive}(#1#){}"}, unlock = {"Gana en {C:attention}Pozo Magenta{}", "o superior con {C:attention}Baraja Verde{}"}}, --[cite: 9]
            c_kranlaxs_brownquartz = {name = "Ojo de tigre", text = {"Crea la {C:attention}Carta{} indicada. El objetivo cambia", "al azar tras {C:green}Renovar{} en la tienda", "{C:inactive}(Objetivo: {C:attention}#1#{C:inactive}){}"}, unlock = {"Gana una partida en {C:attention}Pozo Turquesa{}", "usando la {C:attention}Baraja Anaglifo{}"}}, --[cite: 9]
            c_kranlaxs_turquoisequartz = {name = "Turquesa", text = {"Mientras lo poseas, {C:red}deshabilita{} todos los Jokers", "excepto el primero. Lo reactiva {C:attention}2 veces{}"}, unlock = {"Gana una partida en {C:attention}Pozo Turquesa{}", "usando la {C:attention}Baraja Zodiacal{}"}}, --[cite: 9]
            c_kranlaxs_orangequartz = {name = "Citrino", text = {"Añade un {C:dark_edition}Sello Negro{} a una carta o un", "{C:dark_edition}Sticker Maligno{} a un {C:attention}Comodín{} seleccionado"}, unlock = {"Gana en {C:attention}Pozo Magenta{}", "o superior con {C:attention}Baraja Amarilla{}"}},
            c_kranlaxs_lapislazuli = {name = "Lapislázuli", text = {"Otorga {C:chips}+#1#{} fichas a la primera carta puntuada.", "Disminuye en {C:chips}-#2#{} por uso {C:inactive}(inactivo en 0){}"}, unlock = {"Gana en {C:attention}Pozo Magenta{}", "o superior con {C:attention}Baraja Azul{}"}}, --[cite: 9]
            c_kranlaxs_cinnabar = {name = "Cinabrio", text = {"Otorga {C:mult}+#1#{} multi a la primera carta puntuada.", "Disminuye en {C:mult}-#2#{} por uso {C:inactive}(inactivo en 0){}"}, unlock = {"Gana una partida en {C:attention}Pozo Marrón{}", "usando la {C:attention}Baraja Abandonada{}"}}, --[cite: 9]
            c_kranlaxs_graphite = {name = "Grafito", text = {"{C:green}#1# en #2#{} de prob. de copiar en mano las cartas", "jugadas. La probabilidad decae al activarse"}, unlock = {"Gana en {C:attention}Pozo Magenta{}", "o superior con {C:attention}Baraja Negra{}"}}, --[cite: 9]
            c_kranlaxs_uranium = {name = "Uranio", text = {"Aplica 1 efecto caótico aleatorio por ronda.", "Puede ser salvador o devastador.", "{C:dark_edition}Estado:{} {C:red,E:2}#1#{}"}, unlock = {"Gana una partida en {C:attention}Pozo Cósmico{}", "usando la {C:attention}Baraja Errática{}"}} --[cite: 9]
        },

        Booster = {
            p_kranlaxs_uno_store_3 = {name = "Paquete UNO", text = {"Elige {C:attention}1{} de hasta {C:attention}3{} cartas {C:blue}UNO{}"}}, --[cite: 9]
            p_kranlaxs_uno_store_5 = {name = "Paquete UNO Jumbo", text = {"Elige {C:attention}1{} de hasta {C:attention}5{} cartas {C:blue}UNO{}"}}, --[cite: 9]
            p_kranlaxs_invtarot_instant_3_1 = {name = "Paquete Tarot Inverso", text = {"Elige {C:attention}1{} de hasta {C:attention}3{} cartas de {C:purple}Tarot Inverso{}"}}, --[cite: 9]
            p_kranlaxs_invtarot_instant_5_1 = {name = "Paquete Tarot Inverso Jumbo", text = {"Elige {C:attention}1{} de hasta {C:attention}5{} cartas de {C:purple}Tarot Inverso{}"}}, --[cite: 9]
            p_kranlaxs_invtarot_instant_5_2 = {name = "Mega Paquete Tarot Inverso", text = {"Elige {C:attention}2{} de hasta {C:attention}5{} cartas de {C:purple}Tarot Inverso{}"}}, --[cite: 9]
            p_kranlaxs_invtarot_store_3_1 = {name = "Tarot Inverso Guardado", text = {"Elige {C:attention}1{} de hasta {C:attention}3{} cartas de {C:purple}Tarot Inverso{}"}}, --[cite: 9]
            p_kranlaxs_invtarot_store_5_1 = {name = "Tarot Inverso Guardado Jumbo", text = {"Elige {C:attention}1{} de hasta {C:attention}5{} cartas de {C:purple}Tarot Inverso{}"}}, --[cite: 9]
            p_kranlaxs_invtarot_store_5_2 = {name = "Mega Tarot Inverso Guardado", text = {"Elige {C:attention}2{} de hasta {C:attention}5{} cartas de {C:purple}Tarot Inverso{}"}} --[cite: 9]
        },

        Edition = {
            e_kranlaxs_cosmic = {name = "Cósmica", text = {"Sube de nivel la {C:attention}mano de póker{}", "seleccionada al ser {C:red}descartada{}"}}, --[cite: 9]
            e_kranlaxs_sepia = {name = "Sepia", text = {"{C:green}#1# en #2#{} de prob. de crear una {C:attention}Etiqueta{}", "si se sostiene en mano al puntuar"}}, --[cite: 9]
            e_kranlaxs_cursed = {name = "Maldita", text = {"Equilibra {C:chips}fichas{} y {C:mult}multi{} al puntuar.", "{C:green}#1# en #2#{} de prob. de autodestruirse después"}}, --[cite: 9]
            e_kranlaxs_monochrome = {name = "Monocromática", text = {"Otorga {X:dark_edition,C:white} ^#1# {} multi.", "Se {C:red}destruye{} al puntuar"}}, --[cite: 9]
            e_kranlaxs_underwater = {name = "Acuática", text = {"Otorga {X:chips,C:white} X#1# {} fichas"}} --[cite: 9]
        },

        Tag = {
            tag_kranlaxs_mega_invtarot = {name = "Etiqueta Inversa Mega", text = {"Otorga un {C:attention}Mega Paquete Tarot Inverso{} gratis al instante"}}, --[cite: 9]
            tag_kranlaxs_mega_uno = {name = "Etiqueta UNO Jumbo", text = {"Otorga un {C:attention}Paquete UNO Jumbo{} gratis al instante"}}, --[cite: 9]
            tag_kranlaxs_mega_invtarot_store = {name = "Etiqueta Inversa Mega Guardada", text = {"Otorga un {C:attention}Mega Tarot Inverso Guardado{} gratis al instante"}}, --[cite: 9]
            tag_kranlaxs_quartz_tag = {name = "Etiqueta de Cuarzo", text = {"Crea un {C:attention}Cuarzo{} aleatorio {C:inactive}(debe haber espacio){}"}}, --[cite: 9]
            tag_kranlaxs_sticker_remover = {name = "Etiqueta Limpiadora", text = {"Elimina un sticker {C:attention}Eterno{}, {C:attention}Perecedero{} o de {C:attention}Renta{}", "de un {C:attention}Joker{} aleatorio en posesión"}}, --[cite: 9]
            tag_kranlaxs_legendary = {name = "Etiqueta Legendaria", text = {"La tienda contiene un {C:legendary}Joker Legendario{} gratis"}}, --[cite: 9]
            tag_kranlaxs_cosmic_tag = {name = "Etiqueta Cósmica", text = {"Añade la edición {C:dark_edition}Cósmica{} a una carta aleatoria en baraja"}}, --[cite: 9]
            tag_kranlaxs_yellowish_tag = {name = "Etiqueta Amarillenta", text = {"Añade la edición {C:attention}Sepia{} a una carta aleatoria en baraja"}}, --[cite: 9]
            tag_kranlaxs_boring_tag = {name = "Etiqueta Aburrida", text = {"El próximo Joker de la tienda tendrá edición {C:dark_edition}Monocromática{}"}}, --[cite: 9]
            tag_kranlaxs_demonic_tag = {name = "Etiqueta Demoníaca", text = {"El próximo Joker de la tienda tendrá edición {C:red}Maldita{}"}}, --[cite: 9]
            tag_kranlaxs_wet_tag = {name = "Etiqueta Mojada", text = {"Añade la edición {C:blue}Acuática{} a una carta aleatoria en baraja"}}, --[cite: 9]
            tag_kranlaxs_zen_tag = {name = "Etiqueta Zen", text = {"Reduce la dificultad de {C:attention}apuesta base{} en {C:blue}-1{}"}} --[cite: 9]
        },

        Other = {
            kranlaxs_magenta_sticker = {name = "Sticker magenta", text = {"Usaste este comodín para", "ganar en {C:attention}Pozo magenta{}"}}, --[cite: 9]
            kranlaxs_brown_sticker = {name = "Sticker marrón", text = {"Usaste este comodín para", "ganar en {C:attention}Pozo marrón{}"}}, --[cite: 9]
            kranlaxs_turquoise_sticker = {name = "Sticker turquesa", text = {"Usaste este comodín para", "ganar en {C:attention}Pozo turquesa{}"}}, --[cite: 9]
            kranlaxs_crimson_sticker = {name = "Sticker carmesí", text = {"Usaste este comodín para", "ganar en {C:attention}Pozo carmesí{}"}}, --[cite: 9]
            kranlaxs_glass_sticker = {name = "Sticker de cristal", text = {"Usaste este comodín para", "ganar en {C:attention}Pozo de cristal{}"}}, --[cite: 9]
            kranlaxs_mustard_sticker = {name = "Sticker mostaza", text = {"Usaste este comodín para", "ganar en {C:attention}Pozo mostaza{}"}}, --[cite: 9]
            kranlaxs_platinum_sticker = {name = "Sticker cósmico", text = {"Usaste este comodín para", "ganar en {C:attention}Pozo cósmico{}"}}, --[cite: 9]
            kranlaxs_orangeseal_seal = {name = "Sello Naranja", text = {"Si puntúa en mano: {C:attention}#1#{}, crea 1 {C:attention}#2#{}.", "Rota tras cada activación {C:inactive}(debe haber espacio){}"}}, --[cite: 9]
            kranlaxs_pinkseal_seal = {name = "Sello Rosa", text = {"Aplica {X:dark_edition,C:white} ^#1# {} multi al {C:attention}puntuar{}"}}, --[cite: 9]
            kranlaxs_whiteseal_seal = {name = "Sello Blanco", text = {"{C:attention}Siempre puntúa{}. Inmune a ser", "{C:red}debilitada{}, {C:red}destruida{} o {C:attention}volteada{}"}}, --[cite: 9]
            kranlaxs_brownseal_seal = {name = "Sello Café", text = {"{C:green}#1# en #2#{} de prob. de {C:attention}duplicar{} esta carta", "mientras se retenga en mano al fin de ronda"}}, --[cite: 9]
            kranlaxs_grayseal_seal = {name = "Sello Gris", text = {"Si se retiene en {C:attention}mano{}, obtiene una", "{C:attention}Mejora{} aleatoria de toda la colección"}},
            kranlaxs_mintseal_seal = {name = "Sello Negro", text = {"{C:green}#1# en 4{} probabilidades de", "otorgar {C:purple}1 Token{} extra", "al puntuar"}}
        }
    },
    
    misc = {
        challenge_names = {
            c_kranlaxs_reto_fijado = "Fijación Total", --[cite: 9]
            c_kranlaxs_reto_abuela = "Receta Familiar", --[cite: 9]
            c_kranlaxs_crisis_economica = "Crisis Económica", --[cite: 9]
            c_kranlaxs_reto_doppelganger = "Crisis de Identidad", --[cite: 9]
            c_kranlaxs_reto_anonimo = "Anonimato Total", --[cite: 9]
            c_kranlaxs_reto_jefes = "Sindicato de Jefes", --[cite: 9]
            c_kranlaxs_reto_premonisiones = "Premoniciones", --[cite: 9]
            c_kranlaxs_reto_tallo = "El Gran Tallo", --[cite: 9]
            c_kranlaxs_reto_gachapon = "Gachapón", --[cite: 9]
            c_kranlaxs_reto_pobreza = "Voto de Pobreza" --[cite: 9]
        },
        
        dictionary = {
            ph_kranlaxs_lifeassurance = "Salvado por el Seguro de vida",
            ph_kranlaxs_cancer = "Salvado por Cáncer",
            ph_kranlaxs_judge = "Salvado por el Comodín Juez",
            ph_kranlaxs_shield = "Salvado por el Escudo",
            k_booster_group_p_kranlaxs_uno_store_3 = "Paquete UNO", --[cite: 9]
            k_booster_group_p_kranlaxs_uno_store_5 = "Paquete UNO Jumbo", --[cite: 9]
            k_booster_group_p_kranlaxs_invtarot_instant_3_1 = "Paquete Tarot Inverso", --[cite: 9]
            k_booster_group_p_kranlaxs_invtarot_instant_5_1 = "Paquete Tarot Inverso Jumbo", --[cite: 9]
            k_booster_group_p_kranlaxs_invtarot_instant_5_2 = "Mega Paquete Tarot Inverso", --[cite: 9]
            k_booster_group_p_kranlaxs_invtarot_store_3_1 = "Tarot Inverso Guardado", --[cite: 9]
            k_booster_group_p_kranlaxs_invtarot_store_5_1 = "Tarot Inverso Guardado Jumbo", --[cite: 9]
            k_booster_group_p_kranlaxs_invtarot_store_5_2 = "Mega Tarot Inverso Guardado", --[cite: 9]
            k_zenith = "Cenit", --[cite: 9]
            k_constellation = "Constelación", --[cite: 9]
            k_holy = "Sagrada" --[cite: 9]
        },
        labels = {
            kranlaxs_zenith = "Cenit", --[cite: 9]
            kranlaxs_magenta_sticker = "Sticker magenta", --[cite: 9]
            kranlaxs_brown_sticker = "Sticker marrón", --[cite: 9]
            kranlaxs_turquoise_sticker = "Sticker turquesa", --[cite: 9]
            kranlaxs_crimson_sticker = "Sticker carmesí", --[cite: 9]
            kranlaxs_glass_sticker = "Sticker de cristal", --[cite: 9]
            kranlaxs_mustard_sticker = "Sticker mostaza", --[cite: 9]
            kranlaxs_platinum_sticker = "Sticker cósmico", --[cite: 9]
            kranlaxs_orangeseal_seal = "Sello Naranja",  --[cite: 9]
            kranlaxs_pinkseal_seal = "Sello Rosa",  --[cite: 9]
            kranlaxs_whiteseal_seal = "Sello Blanco",  --[cite: 9]
            kranlaxs_brownseal_seal = "Sello Café",  --[cite: 9]
            kranlaxs_grayseal_seal = "Sello Gris",  --[cite: 9]
            kranlaxs_mintseal_seal = "Sello Menta",  --[cite: 9]
            cegado = "Sticker Cegado", --[cite: 9]
            clover = "Sticker Malvado", --[cite: 9]
            p_kranlaxs_uno_store_3 = "Paquete UNO", --[cite: 9]
            p_kranlaxs_uno_store_5 = "Paquete UNO Jumbo", --[cite: 9]
            p_kranlaxs_invtarot_instant_3_1 = "Paquete Tarot Inverso", --[cite: 9]
            p_kranlaxs_invtarot_instant_5_1 = "Paquete Tarot Inverso Jumbo", --[cite: 9]
            p_kranlaxs_invtarot_instant_5_2 = "Mega Paquete Tarot Inverso", --[cite: 9]
            p_kranlaxs_invtarot_store_3_1 = "Tarot Inverso Guardado", --[cite: 9]
            p_kranlaxs_invtarot_store_5_1 = "Tarot Inverso Guardado Jumbo", --[cite: 9]
            p_kranlaxs_invtarot_store_5_2 = "Mega Tarot Inverso Guardado", --[cite: 9]
            kranlaxs_wave = "Acuática", --[cite: 9]
            e_kranlaxs_cosmic = "Cósmica", --[cite: 9]
            e_kranlaxs_sepia = "Sepia", --[cite: 9]
            e_kranlaxs_cursed = "Maldita", --[cite: 9]
            e_kranlaxs_monochrome = "Monocromática", --[cite: 9]
            e_kranlaxs_underwater = "Acuática", --[cite: 9]
            k_constellation = "Constelación", --[cite: 9]
            k_holy = "Sagrada" --[cite: 9]
        },

        v_text = {
            ch_c_kran_fijado_1 = {"Todos los comodines tienen el sticker {C:attention}Fijado{}"}, --[cite: 9]
            ch_c_kran_abuela_1 = {"Los comodines de {C:attention}puntuación{} están {C:red}baneados{}"}, --[cite: 9]
            ch_c_kran_crisis_1 = {"La tienda es un {C:attention}20% más cara{}"}, --[cite: 9]
            ch_c_kran_crisis_2 = {"El premio base de las ciegas se {C:red}reduce{} en {X:money,C:white} $2 {}"}, --[cite: 9]
            ch_c_kran_crisis_3 = {"El mazo está compuesto únicamente de {C:attention}52 Ases{}"}, --[cite: 9]
            ch_c_kran_doppel_1 = {"Todos los comodines están {C:red}baneados{} de la tienda"}, --[cite: 9]
            ch_c_kran_anonimo_1 = {"Cartas en la mano y comodines están {C:attention}boca abajo{}"}, --[cite: 9]
            ch_c_kran_jefes_1 = {"Las Ciegas Pequeñas y Grandes son {C:attention}Ciegas Jefe{}"}, --[cite: 9]
            ch_c_kran_premon_1 = {"Todas las cartas en tu mano están {C:attention}boca abajo{}"}, --[cite: 9]
            ch_c_kran_tallo_1 = {"Los demás {C:attention}comodines{} y {C:attention}Paquetes{} están {C:red}baneados{}"}, --[cite: 9]
            ch_c_gacha_rule_1 = {"Ninguna {C:attention}carta individual{} aparece en la tienda"}, --[cite: 9]
            ch_c_kran_pobreza_1 = {"{C:attention}50%{} de probabilidad de que un {C:common}Común{} sea {C:legendary}Legendario{}"}, --[cite: 9]
            ch_c_kran_pobreza_2 = {"Si tu comodín {C:attention}Monje{} se decepciona, {C:red}pierdes la partida{}"} --[cite: 9]
        }
    }
}