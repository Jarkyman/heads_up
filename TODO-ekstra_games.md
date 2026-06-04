# Ekstra Spil-modes (Fremtidige Idéer)

Dette dokument indeholder koncepter til fremtidige spiltilstande, som let kan bygge videre på appens eksisterende arkitektur (kategorier, ord, multiplayer-flow).

## 1. "Alias" / Forklar Ordet (Hold mod Hold)
I stedet for at én person skal gætte ordet ved at holde telefonen for panden, deles selskabet op i to hold. 
- **Gameplay:** Telefonen går på tur mellem spillerne (evt. én fra Hold A, så én fra Hold B).
- Man har 60 sekunder til at forklare så mange ord som muligt til sit hold, *uden* at sige selve ordet (eller dele af det).
- **Navigation:** Man swiper til højre for at registrere et rigtigt gæt og få næste ord, eller swiper til venstre (eller trykker) for at skippe, hvis det er for svært.
- **Konkurrence:** Appen holder automatisk styr på point for Hold 1 og Hold 2. Vinderholdet kåres til sidst.

## 2. "Tikkende Bombe" (Tick Tick Boom / Catch Phrase)
En ekstremt stressende og underholdende mode, hvor telefonen fungerer som en bombe, der er ved at springe.
- **Gameplay:** Et ord, en kategori, eller et bogstav vises på skærmen (fx "Noget man finder på badeværelset" eller bare ordet "Badekar", som man skal relatere noget til).
- Så snart ordet er læst, tjekker/tikker telefonen som en bombe. Spilleren skal lynhurtigt sige noget relevant og *straks* kaste/række telefonen videre til den næste spiller.
- **Tid:** Tiden løber ud tilfældigt et sted mellem 30 og 60 sekunder. Tik-lyden bliver hurtigere og hurtigere.
- **Taber:** Den, der sidder med telefonen, når "bomben" sprænger (og telefonen vibrerer voldsomt + laver eksplosionslyd), taber runden!

## 3. Mime-spillet (Charades)
En klassiker, der minder om "Who Am I?", men mekanikken er vendt om.
- **Gameplay:** Instruktionerne og interfacet er lavet til, at *én spiller kigger på skærmen* og læser ordet.
- Denne spiller skal nu *mime* (uden at bruge ord eller lyde) ordet til resten af selskabet.
- **Styring:** Spilleren, der mimer, styrer selv telefonen og trykker "Korrekt" når resten af gruppen gætter det, eller "Skip".
- **Kategorier:** Kan udnytte specifikke action-kategorier som "Ting man gør", "Dyr", "Kendte personer" eller "Film".
