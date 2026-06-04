# Heads Up! - TODO & Code Review

Her er en fuld gennemgang af koden med ting der kan optimeres, refaktoreres og forbedres, sorteret efter prioritet og markeret med ToDoKanban tags. Opgaver omkring egne kategorier er flyttet til [TODO-own_words_category.md](TODO-own_words_category.md).

## 🚀 Høj Prioritet (H) - Logik & Arkitektur
// TODO {S} [architecture, controllers] (H): Flyt accelerometer-logik ud af `word_page.dart` (View) og ind i en dedikeret `GameController` for at følge GetX MVC/MVVM mønstret bedre.
// TODO {M} [logic, hardcoding] (H): Gør `EventStatus` (Jul, Halloween osv.) mere dynamisk i `home_page.dart` i stedet for at hardcode index `0, 1, 2, 3`. (Ref: `//TODO: Det her kan gøres mere dynamisk` i koden).
// TODO {M} [logic, timer] (H): Start/Stop af `_startWaitTimer` i `word_page.dart` kan forårsage memory leaks, hvis brugeren navigerer væk før den rammer 1. Sørg for at den altid afbrydes sikkert i `dispose()`.
// TODO {M} [system, build] (H): Så snart third-party packages (fx `package_info_plus`) understøtter det fuldt ud, skal Android-projektet endeligt migreres til "Built-in Kotlin" (KGP fjernes fra plugins).

## 🟡 Mellem Prioritet (M) - UI & UX
// TODO {S} [logic, first_word] (M): `generateFirstWord()` i `word_page.dart` er et workaround. Det bør gøres direkte i en Controller ved initialisering, så View'et altid har et ord klar.
// TODO {C} [architecture, code_quality] (M): Fjern alt udkommenteret (dead code) i filer som `home_page.dart` og `word_page.dart` (f.eks. knapper i bunden af word_page).
// TODO {S} [ui, theme] (M): Centraliser gradients og farver i et samlet `ThemeData` eller i `app_colors.dart` frem for at hardcode dem i `CategoryTile` og `EventTile`.
// TODO {S} [ui, localization] (M): Udskift hardcodede engelske tekster med tr-nøgler (`'Tap the screen to start'.tr` er fint, men undgå at bygge sætninger statisk). Måske bruge Locale('da') direkte i WordController (Ref: `//TODO: Det her kan nok gøres anderledes måske bruge Locale('da')`).
// TODO {M} [ui, design] (M): Appen kunne få et mere "premium" feel (Glassmorphism, blødere skygger, mere dynamiske micro-animationer) i stedet for de meget flade gradients.

## 🟢 Lav Prioritet (L) - Code Quality
// TODO {C} [ui, dimensions] (L): `Dimensions.dart` benytter multiplikation (f.eks. `Dimensions.height10 * 16`). Det kan gøres renere ved at generere de specifikke størrelser dynamisk baseret på skærmens højde/bredde.

---

## ✅ DONE
// DONE {S} [architecture, ads] (H): Flyt Google Mobile Ads logik og keys til debug/release håndtering via `AdHelper`. (Færdiggjort og `.env` droppet da AdMob IDs er public).
// DONE {M} [code_quality, comments] (H): Opret et dedikeret TODO-dokument for "Egne kategorier/ord" og fjern alle relaterede indlejrede `//TODO` kommentarer fra `home_page.dart`, `buy_dialog.dart`, osv.
// DONE {S} [code_quality, logging] (M): Ryd op i store mængder `debugPrint` (f.eks. "Loaded Events", "object", osv.) i `splash_page.dart` og andre filer.
