# Heads Up! - TODO & Code Review

Her er en fuld gennemgang af koden med ting der kan optimeres, refaktoreres og forbedres. Jeg har formateret dem efter dine ToDoKanban regler, så du nemt kan tilføje dem i din kode, hvis du ønsker det.

## 🏗️ Arkitektur & State Management
// TODO {S} [architecture, controllers] (H): Flyt accelerometer-logik ud af `word_page.dart` (View) og ind i en dedikeret `GameController` for at følge GetX MVC/MVVM mønstret bedre.
// TODO {S} [architecture, ads] (M): Flyt Google Mobile Ads logik (`_loadRewardedAd` osv.) ud af `HomePage` og ind i en dedikeret `AdController` eller `AdService`.
// TODO {C} [architecture, code_quality] (M): Fjern alt udkommenteret (dead code) i filer som `home_page.dart` og `word_page.dart` (f.eks. knapper i bunden af word_page).

## 🎨 UI & UX (Design Aesthetics)
// TODO {S} [ui, theme] (M): Centraliser gradients og farver i et samlet `ThemeData` eller i `app_colors.dart` frem for at hardcode dem i `CategoryTile` og `EventTile`.
// TODO {C} [ui, dimensions] (L): `Dimensions.dart` benytter multiplikation (f.eks. `Dimensions.height10 * 16`). Det kan gøres renere ved at generere de specifikke størrelser dynamisk eller fjerne overflødige udregninger.
// TODO {S} [ui, localization] (M): Udskift hardcodede engelske tekster med tr-nøgler (`'Tap the screen to start'.tr` er fint, men undgå at bygge sætninger statisk).
// TODO {M} [ui, design] (M): Appen kunne få et mere "premium" feel (Glassmorphism, blødere skygger, mere dynamiske micro-animationer) i stedet for de meget flade gradients.

## ⚙️ Logik & Funktionalitet
// TODO {M} [logic, hardcoding] (H): Gør `EventStatus` (Jul, Halloween osv.) mere dynamisk i `home_page.dart` i stedet for at hardcode index `0, 1, 2, 3`.
// TODO {M} [logic, timer] (H): Start/Stop af `_startWaitTimer` i `word_page.dart` kan forårsage memory leaks hvis brugeren navigerer væk før den rammer 1. Sørg for at den altid afbrydes sikkert i `dispose()`.
// TODO {S} [logic, first_word] (M): `generateFirstWord()` i `word_page.dart` er et workaround. Det bør gøres direkte i en Controller ved initialisering, så View'et altid har et ord klar.

## 📦 System & Afhængigheder
// TODO {M} [system, build] (H): Så snart third-party packages (fx `package_info_plus`) understøtter det, skal Android-projektet endeligt migreres til "Built-in Kotlin" (KGP fjernes).
