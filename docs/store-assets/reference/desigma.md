# Desigma workspace

Canonical design files are in Jackie's OneDrive:

`/Users/jackiejensen/Library/CloudStorage/OneDrive-Personal/Programering/Flutter/Hint Master/Desigma Library/`

Open Desigma from Applications. Its normal project library links to the two OneDrive project directories; the Getting started project is preserved.

- **Hint Master**: App Design (iPad, iPhone, Duo, Android), Promotion Images, Screenshots.
- **Apple Creative Templates**: editable import of the supplied Apple .fig with Templates and Components pages. The original .fig is retained unchanged in the library root.

The first editable English designs are `projects/Hint Master/files/app-store-header-en-US.desigma` and `app-store-search-en-US.desigma`. PNG review exports are under `exports/Hint Master/Promotion Images/`: 3840×1646 header and 1920×1280 search, RGB without alpha. These are the current Desigma design trials; older repo Swift exports are retained as earlier concepts.

Text layers named `COPY/en-US/...` remain native text for later translations; backgrounds, stickers and device frames are editable. Real premium iPad and ordinary iPhone screenshots are embedded in the documents as locked image layers. They are not generated app UI. No Duo device is shown in promotion artwork.

Each document includes a hidden, locked **Apple Art Safe Area** guide from the supplied template. Header: x1097 y493 w1646 h661. Search at half template size: x418 y382.5 w1084 h515. Core copy is central; peripheral device artwork may crop. Toggle guides off before export. Store preview crops and Jackie's design review remain necessary before upload. Desigma PNG exports may carry an alpha channel even when opaque; remove that channel before uploading to Apple, as done for the supplied review PNGs.

Only the folder structure and header/search drafts are prepared. App screen designs, composed screenshots, Google Play artwork, translations and video remain deferred. No store edits, commit or push.

## Revision 02 — clearer product positioning

Canonical designs and review exports now use “Guess words. Spot the bluffer.” and “Two party games. One phone.” (shortened in search), plus game-mode names. Header additionally mentions the verified 16 categories and four languages. Header iPad screen width grew from 940 to 1450 px and iPhone from 300 to 530 px; Search iPad grew from 680 to 900 px. Native screenshots remain unchanged, with original aspect ratios.

Previous files/exports are preserved under the OneDrive library Archive/before-promotion-optimization-20261103-081602/. Research rationale: `docs/store-assets/promotion-research.md`; OneDrive Verification/Promotion Revision 02 includes safe-area crops and 320px thumbnail checks. Text remains editable (six copy layers in Header, five in Search). Imported Apple guide dimensions are unchanged. Store crop previews and testing on actual traffic are still needed before claiming improved conversion. No upload or experiment started.

## Revision 03 — game explanations and actual MCP editing

Desigma alpha.17 MCP is installed, registered in Codex and verified against the live editor. See `desigma-mcp.md`. Header and Search retain the large action stickers and actual native screenshots. Supporting copy is now 52 px / weight 600 in Header and 40 px / weight 600 in Search, replacing the smaller mode labels/benefit text. Header explicitly explains phone-to-forehead clues and the timer, plus a shared secret word that the Chameleon does not receive. Search uses shorter versions for scanning. No game rules changed: `_generateRoles` gives ordinary players the same secretWord and Chameleon players no word, rather than a different word.

Canonical editable files and exports updated in place. Revision 02 files preserved under OneDrive `Archive/before-rules-copy-20261103-083538/`. Current review evidence, exact safe-area crops, thumbnail and MCP edit records are in `Verification/Promotion Revision 03/`. Exported through actual MCP (file mode for large renders after the live bridge export deadline), flattened RGB/no alpha at the original required sizes. No store upload or experiment.

## Upload-file clarification — 2026-11-03

Jackie reported “File dimensions are invalid” for `app-store-header-en-US.png` and `app-store-search-en-US.png`. These exact filenames match the Desigma library previews under `projects/Hint Master/thumbs/`: 960×412 and 480×320, RGBA. This suggests preview files were selected; the actual uploaded bytes were not available, so the cause is an inference.

A dedicated upload directory now contains only two clearly named full-resolution PNGs:
`exports/Hint Master/Promotion Images/App Store Upload/`

- `Header-3840x1646-en-US.png`
- `Search-1920x1280-en-US.png`

Verified against Apple's current specifications: exact pixel dimensions, 8-bit RGB without alpha/tRNS, every PNG chunk CRC, and byte-identical copies of the canonical full-resolution exports. Detailed hashes are in the adjacent `upload-verification.json`. Library preview files are retained for Desigma. No artwork was resized or changed, and App Store Connect acceptance has not yet been verified.

## English screenshot series — 2026-11-03

The Screenshots folder now contains one editable document with four device pages and five frames each. The iPhone series is complete; Duo outer has three ready frames, Duo inner one and iPad two. Nine native captures remain pending after RocketSim daily quota exhaustion; placeholders are excluded from upload folders. See [screenshot status, folders and continuation instructions](screenshots.md). The original statement that Screenshots is deferred describes the earlier promotion-only phase.

## Screenshot series completed — 2026-11-04

All four device pages now have five complete English frames. All twenty PNG exports are verified and saved under Screenshots/en-US/iPhone, Duo/Outer, Duo/Inner and iPad. The earlier pending captures were completed with Apple Device Hub/devicectl, and all gameplay images now use the corrected large word/timer sizes. Native screenshots remain pixel-identical after lossless PNG recompression for the editable document. See screenshots.md and upload-verification.json for current status and provenance. No store upload or submission.
