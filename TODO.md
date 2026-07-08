# Who Am I? - TODO & Code Review

Her er en fuld gennemgang af koden med ting der kan optimeres, refaktoreres og forbedres, sorteret efter prioritet og markeret med ToDoKanban tags. Opgaver omkring egne kategorier er flyttet til [TODO-own_words_category.md](TODO-own_words_category.md).

// TODO: Add `ITSAppUsesNonExemptEncryption=false` to `ios/Runner/Info.plist` if App Store Connect encryption answers remain unchanged.

---

## ✅ DONE
// DONE: Look throw all words and check for spelling errors. (Ordlisten blev gennemgået med scripts, heuristik og macOS stavekontrol; kun en manuel shortlist af reelle kandidater stod tilbage).
// DONE: hero "animationen" fra splash screen til home page virker ikke. (Splash og home bruger nu samme `AppLogoHero`, route fade er fjernet fra overgangen, og splash animation-controlleren initialiseres før resource loading).
// DONE: why do we not have sv and no in "LOCALE_LIST" in AppConstants, we have the languages or what? (Tilføjet `nb_NO` og `sv_SE`, da appen allerede har orddata, oversættelser og WordController support for dem).
// DONE: when watcing a reward add to "Who am i" it will accept hoizontal orientation, but we only support vertical orientation on this game. (Orientation styres nu via lifecycle-helper; Who Am I låses til landscape, øvrige sider til portrait, og rewarded-ad navigation sker først efter ad dismiss).
// DONE: Fix design for purchase also, after rules design is done. Also the other purchase dialog with ads need new design. (Purchase og buy-or-try bruger nu fælles glassy bottom sheet, glass icon header og glassy action buttons).
// DONE: Fix design on rules, ugly white bagckground is not good. (Rules dialogs now use glassy bottom sheet/dialog styling).
// DONE: Add glassy effect on game mode toggler.
// DONE: Reduce reveal word timer, and use a more beautiful spinner then we have now. (Reveal er nu 700ms med custom glass progress-ring).
// DONE: Play again button need to go to player naming screen, not directly to the game start.
// DONE: Remove back option on chamelion result. It should not be possible to go back to the rule/reveal screen after reveal is trickert and we are navigated.
// DONE: Add small "(hold)" on the reveal button under Reveal text (without moving the text possition we have now).
// DONE: move reveal/play again buttons so they do not share the same screen position and prevent accidental clicking play again.
// DONE: Add extra reveal button at the end, to prevent acedently revealing the world and imposters. (Løst med 2 sekunders hold-to-reveal knap).
// DONE: Add player naming and new startup flow.
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
