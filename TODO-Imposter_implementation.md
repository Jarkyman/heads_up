# Feature: Ny Spiltilstand - Imposter / Undercover

Dette dokument beskriver implementeringen af en ny spiltilstand, hvor appen skifter fra et gættespil til et socialt deduktionsspil i stil med Spyfall eller Undercover.

## 🎲 Navneforslag til Spiltilstande
Siden "Heads up" er et varemærke/beskyttet navn, og "Imposter" er stærkt forbundet med Among Us, er her nogle friske og originale navneforslag til appen og dens to modes:

**Forslag til App-navnet overordnet:**
- *Party Words*, *WordMates*, *BrainBluff*, *Social Sync*

**Mode 1 (Det nuværende "Heads up" med telefonen på panden):**
- *Tilt & Tell*
- *Forehead Fun*
- *UpWord*
- *Flip & Guess*
Find more ideres before disiding.

**Mode 2 (Det nye "Imposter" spil):**
- *Undercover*
- *The Spy* / *Spionen*
- *Chameleon* / *Kamæleonen*
- *Word Thief* / *Ordtyven*
- *Odd One Out*
Chameleon sound nice

## 🎯 Hvordan spillet (Mode 2) fungerer
Spillet bruger præcis de samme kategorier og ord som Mode 1, men flowet ændres drastisk.

### Spilflow:
1. **Vælg Mode:** På forsiden (i toppen) er der en Toggle/Tab-bar, hvor brugeren kan vælge mellem [ Mode 1 ] og [ Mode 2 ].
2. **Kategorivælg:** Brugeren vælger en kategori (f.eks. "Dyr").
3. **Spilleropsætning:** En ny skærm hvor brugeren vælger antal spillere (f.eks. 3 til xx spillere) og evt. antallet af imposters (ved mange spillere kan der være 2).
4. **Rolle-tildeling:** Appen udvælger tilfældigt 1 ord fra kategorien (f.eks. "Løve") og blander et array af roller: `["Løve", "Løve", "Løve", "Løve", "Imposter"]`.
5. **Send telefonen rundt (Pass & Play):**
   - Skærmen viser: "Spiller 1's tur. Hold skærmen nede for at se dit ord."
   - Når spilleren holder en knap nede, vises ordet ("Løve" eller "Imposter").
   - Når man slipper står orde som ?????????? på skræmen
   - I bunen er en knap med "Næste spiller" trykker man der, skifter vi til spiller 2.
6. **Spillets Faser:** Når alle har set deres rolle, er der kun afsløring eller regler man kan se på skærmen.
7. **Afstemning & Afsløring:** Efter max 3 runder, eller hvis spillerne er klar til at gætte før tid, trykkes der på "Gæt". Spillerne stemmer mundtligt om, hvem der er imposteren.
8. **Resultat:** Appen afslører, hvem imposteren var, og hvad det hemmelige ord var.
9. **Genstart:** Mulighed for at starte en ny runde med samme opsætning eller gå tilbage til forsiden.
extra: **app** Appen skal ikke håntere noget spille histroik, det holder folke selv styr på, så når alle har set deres ord, så hedder kanppen "Start spil" og så går vi til spillet er starte siden. Her ser vi 2 kanpper, "Afslut spil" og "Regler". Afslut spil giver Spiller X and X is imposter, word is Y. Regler viser en popup med reglerne for spillet.

## 🗄️ Arkitektur & Data
- **Toggle State:** Der skal tilføjes en variabel i en ny `GameModeController`, der gemmer den aktive spilmode: `enum GameMode { tiltAndTell, undercover }`.
- **UI Ændring:** `HomePage` skal vise en custom toggle switch i toppen. Listen af kategorier er den samme, men `onTap` skal føre til forskellige konfigurationsskærme baseret på den valgte `GameMode`.
- **UndercoverSetupPage:** En ny side til at indstille antallet af spillere.
- **UndercoverRolePage:** Siden hvor telefonen sendes rundt. Bør implementere et `GestureDetector` med `onLongPressStart` og `onLongPressEnd` for sikkert at vise/skjule ordet.
- **UndercoverGamePage:** Skærm der holder styr på de (op til 3) runder og tilbyder "Afslør Imposter" knappen.
- `onLongPressEndDelay`: ville genre have når man begynder at holde inde på skærmen, så forsvinder "??????????" og en rund lode fylder lige 360 på cirkelen over 1 sekund. Så den ikke bare skfiter ved et hurtigt fejl tryk.

## ✅ Action Plan for senere
1. Vælg de endelige navne for modes.
2. Byg ToggleUI i toppen af `HomePage`.
3. Byg Flowet for "Undercover Setup" (Antal spillere).
4. Byg Flowet for "Send Telefon Rundt" og ordvisning.
5. Byg "Afslørings"-skærmen.
6. Byg "Regler"-popup.
