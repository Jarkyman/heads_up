# Heads Up! - TODO & Code Review

Her er en fuld gennemgang af koden med ting der kan optimeres, refaktoreres og forbedres, sorteret efter prioritet og markeret med ToDoKanban tags. Opgaver omkring egne kategorier er flyttet til [TODO-own_words_category.md](TODO-own_words_category.md).

## 🚀 Høj Prioritet (H) - Logik & Arkitektur
// TODO {M} [system, build] (H): Så snart third-party packages (fx `package_info_plus`) understøtter det fuldt ud, skal Android-projektet endeligt migreres til "Built-in Kotlin" (KGP fjernes fra plugins).

## 🟡 Mellem Prioritet (M) - UI & UX
// TODO {S} [ui, localization] (M): Udskift hardcodede engelske tekster med tr-nøgler. Måske bruge Locale('da') direkte i WordController (Ref: `//TODO: Det her kan nok gøres anderledes måske bruge Locale('da')`).
// TODO {M} [ui, design] (M): Appen kunne få et mere "premium" feel (Glassmorphism, blødere skygger, mere dynamiske micro-animationer) i stedet for de meget flade gradients.

## 🟢 Lav Prioritet (L) - Code Quality
// TODO {C} [ui, dimensions] (L): `Dimensions.dart` benytter multiplikation (f.eks. `Dimensions.height10 * 16`). Det kan gøres renere ved at generere de specifikke størrelser dynamisk baseret på skærmens højde/bredde.

---

## ✅ DONE
// DONE {S} [architecture, ads] (H): Flyt Google Mobile Ads logik og keys til debug/release håndtering via `AdHelper`. (Færdiggjort og `.env` droppet da AdMob IDs er public).
// DONE {M} [code_quality, comments] (H): Opret et dedikeret TODO-dokument for "Egne kategorier/ord" og fjern alle relaterede indlejrede `//TODO` kommentarer fra `home_page.dart`, `buy_dialog.dart`, osv.
// DONE {S} [code_quality, logging] (M): Ryd op i store mængder `debugPrint` i `splash_page.dart`, `event_controller.dart` og andre filer.
// DONE {S} [architecture, controllers] (H): Opret `GameController` – accelerometer, timers og spilflow er nu trukket helt ud af `word_page.dart`.
// DONE {M} [logic, timer] (H): Memory leak på `_startWaitTimer` er løst – controlleren `onClose()` aflyser alle subscriptions og timers sikkert.
// DONE {S} [logic, first_word] (M): `generateFirstWord()` workaround er ryddet op og lever nu rent i `GameController`.
// DONE {C} [architecture, code_quality] (M): Fjernet alt dead code (udkommenterede knapper og popups) i `word_page.dart`.
// DONE {M} [logic, hardcoding] (H): Event-kategori hardcodede index (`0, 1, 2, 3`) erstattet med dynamisk `categoryForEvent()` metode i `CategoryController`.
