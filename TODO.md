# Who Am I? - TODO & Code Review

Her er en fuld gennemgang af koden med ting der kan optimeres, refaktoreres og forbedres, sorteret efter prioritet og markeret med ToDoKanban tags. Opgaver omkring egne kategorier er flyttet til [TODO-own_words_category.md](TODO-own_words_category.md).
// TODO: hero "animationen" fra splash screen til home page virker ikke.

---

## ✅ DONE
// DONE: Se alle words igennem for stavefejl! (Der blev fundet og rettet over 20 stavefejl via script).
// DONE: Kan vi lave en splash screen der har den samme bangrund som vores app? (Løst med BackgroundImage-widgeten).
// DONE: hero "animationen" klipper. Forsøgt løst med Transition.fadeIn. (Pauset for nu).
// DONE: Jeg har købt appne, men hvis jeg laver en shift+R så skal jeg ind i settings for at "gendane køb" for at få det igen, er det en fejl? (Løst ved at tvinge et kald til `unlockAllRead()` og `updateCustomerStatus()` i SettingsController's readSettings()).
// DONE {S} [architecture, ads] (H): Flyt Google Mobile Ads logik og keys til debug/release håndtering via `AdHelper`. (Færdiggjort og `.env` droppet da AdMob IDs er public).
// DONE {M} [code_quality, comments] (H): Opret et dedikeret TODO-dokument for "Egne kategorier/ord" og fjern alle relaterede indlejrede `//TODO` kommentarer fra `home_page.dart`, `buy_dialog.dart`, osv.
// DONE {S} [code_quality, logging] (M): Ryd op i store mængder `debugPrint` i `splash_page.dart`, `event_controller.dart` og andre filer.
// DONE {S} [architecture, controllers] (H): Opret `GameController` – accelerometer, timers og spilflow er nu trukket helt ud af `word_page.dart`.
// DONE {M} [logic, timer] (H): Memory leak på `_startWaitTimer` er løst – controlleren `onClose()` aflyser alle subscriptions og timers sikkert.
// DONE {S} [logic, first_word] (M): `generateFirstWord()` workaround er ryddet op og lever nu rent i `GameController`.
// DONE {C} [architecture, code_quality] (M): Fjernet alt dead code (udkommenterede knapper og popups) i `word_page.dart`.
// DONE {M} [logic, hardcoding] (H): Event-kategori hardcodede index (`0, 1, 2, 3`) erstattet med dynamisk `categoryForEvent()` metode i `CategoryController`.
// DONE {M} [ui, design] (H): Premium UI/Design løft – Glassmorphism på alle tiles, knapper og settings. Micro-animationer (ScaleTransition, AnimatedSwitcher, TweenAnimationBuilder) på CategoryTile, EventTile, IconBtn, countdown og tilt-badge.
// DONE {S} [ui, branding] (M): App-titel ændret til "Who Am I?" og vist under logoet på forsiden.
// DONE {S} [ui, localization] (M): Udskift hardcodede engelske tekster med tr-nøgler ("Who Am I?"), fjernet overflødig TODO i WordController.
// DONE {M} [system, build] (H): Migreret det mulige af Android-projektet til Built-in Kotlin (bygger nu uden fejl, men har stadig warnings fra plugins som rate_my_app og package_info_plus indtil deres forfattere opdaterer dem).
