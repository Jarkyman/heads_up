# Promotion creative revision — 2026-11-03

## Evidence and limits

Apple advises a clear focal point, short legible text, central safe-area composition, one clear idea for headers and an immediately obvious purpose in search. The current Heads Up listing leads with “Play Charades with Friends!” and explains giving clues/guessing words; Impostor Party's site explains its bluffing/guessing games and single-phone play. These are positioning examples, not evidence that their specific artwork caused conversion or that a similar design will outperform ours.

Apple's product-page optimization examples show that plausible visual hypotheses can lose; the Simply Piano example reports that stills beat its proposed video treatment. A/B testing on our own traffic is needed before calling any revision a conversion winner. No experiment is started in this work.

## Specific creative direction

- Palette: mint #28D8AA, sea blue #3189B9, navy #082F48, warm white #FAF8EE, cream #FFF1CB and coral #FFAA88. Retains the established App Store series and approved sticker direction.
- Typeface: Roboto, bold for the actions, quieter supporting copy. Text remains editable; no generated interface text or flattened headline artwork.
- Main message: **Guess words. Spot the bluffer.** Explains the two actual game mechanics, replacing the vague “BIG LAUGHS. tiny clues.” slogan.
- Supporting benefit: **Two party games. One phone.** / **Two games. One phone.** The in-app instructions confirm both shared-phone game flows. **Charades + Chameleon** names them.
- Header secondary facts: **16 categories • 4 languages**. The actual captured grid has 16 base categories; AppConstants.LOCALE_LIST enables da_DK, en_US, nb_NO and sv_SE. These are truthful features, not claims of exclusive advantages. Do not imply every category is free or claim unique/best/#1 status.
- Layout: header uses a substantially larger iPad on the left, large action phrases centrally inside Apple's guide, ordinary iPhone on the right. Search places clear actions centrally, enlarges the iPad at right and uses a smaller ordinary iPhone at lower left. Screens retain their actual native aspect ratios and premium UI pixels.
- Critique of initial plan: scaling the original tiny central cluster alone would still explain little. The revised action-led copy and two-phone/game benefit communicate the product. The iPad's breadth supports category variety; repeated category screens alone do not demonstrate actual gameplay. A later real gameplay capture could improve that explanation, but no interface is synthesized for this revision.
- Five/six short copy layers at most; sparse confetti and quiet orbital background. Core copy remains in the exact imported safe areas; peripheral branding/device artwork can crop. Check full resolution, 320 px thumbnail views and safe-area crops, then the actual console preview before upload.

## Sources

- [Apple asset best practices](https://developer.apple.com/app-store/asset-best-practices/)
- [Apple creative specifications](https://developer.apple.com/help/app-store-connect/reference/app-information/creative-assets-specifications)
- [Apple product-page optimization and developer examples](https://developer.apple.com/app-store/product-page-optimization/)
- [Heads Up official App Store listing](https://apps.apple.com/us/app/heads-up/id623592465)
- [Impostor Party official site](https://impostorpartygame.com/)
- Local feature validation: `lib/widgets/how_to_play_dialog.dart`, `lib/helper/app_constants.dart`, native premium iPad category screenshot.
