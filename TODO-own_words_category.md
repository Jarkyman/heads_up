# Feature: Opret Egne Kategorier & Ord

Dette dokument beskriver, hvordan funktionaliteten for "Egne Kategorier og Ord" kan bygges ind i Heads Up appen. Det tjener som en samlet oversigt.

## 🎯 Mål med featuren
Brugeren skal have mulighed for at trykke på en "Add" (➕) knap på forsiden. Denne knap åbner et dialogvindue, hvor brugeren kan oprette en ny kategori (f.eks. "Vores Familie" eller "Interne Jokes"). Når kategorien er oprettet, skal brugeren kunne tilføje sine egne ord til den, og spille dem på præcis samme måde som de indbyggede spil. (Anbefal at de tilføjer minumum 20-30 ord for at sikre en god spiloplevelse, mindst 5 ord i hver kategori).

## 🗄️ Database & State Management
For at gemme brugerens egne kategorier skal `Shared Preferences` benyttes (eller en simpel lokal database som Hive/Isar, hvis det bliver komplekst).
1. **CategoryModel**: Vi skal kunne skelne mellem "default" kategorier og "user generated" kategorier. Måske en boolean `isUserGenerated`.
2. **WordController/Repo**: En metode til at gemme `List<String> userWords` i `SharedPreferences` under en nøgle, der svarer til den nye kategoris ID.
3. **CategoryController/Repo**: En metode til at tilføje, redigere og slette `CategoryModel`s fra `SharedPreferences`.

## 🎨 UI Komponenter
1. **"Tilføj Kategori" Knap**: På forsiden (`home_page.dart`), sidst i listen over kategorier, tilføjes en `CategoryTile`, som kun indeholder et plus-ikon. Denne skal kun være klikbar, hvis brugeren har købt *Unlock All* (eller vi tillader én gratis custom kategori).
2. **AddCategoryDialog**: En popup (som delvist findes i `lib/widgets/add_category_dialog.dart`) hvor brugeren kan skrive navnet på kategorien og evt. vælge et farvetema/ikon.
3. **Manage Words Screen**: Når brugeren holder inde på en af deres egne kategorier (Long Press), skal et "Edit" vindue poppe op, hvor man kan tilføje, redigere eller slette ord på en liste.
4. **Fejlhåndtering**: En popup hvis brugeren prøver at starte spillet med en tom kategori (som f.eks. "Tilføj mindst 5 ord for at spille!").

## 📌 Relaterede Opgaver (Tidligere TODO's fra kodebasen)
- [x] Ryd op i `home_page.dart`: `//TODO: Add new word dialog`
- [x] Ryd op i `home_page.dart`: `//TODO: Open edit popup` på `onLongPress`.
- [x] Ryd op i `add_category_dialog.dart`: `//TODO: Skal føre til en ny popup hvor man udfylder ord`
- [x] Ryd op i `add_category_dialog.dart`: `//TODO: Måske en fejl meddelse;` (Hvis felter er tomme).
- [x] Ryd op i `buy_dialog.dart`: `//TODO: Skal på når man kan oprette selv`
- [x] Ryd op i `categories_controller.dart`: `//TODO: Add own til events`

*Når vi bygger featuren, bruger vi dette dokument som primær rettesnor og Kanban board!*
