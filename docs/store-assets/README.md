# Hint Master store assets

## Current files

- `raw/` — all original native captures and their metadata, preserved unchanged.
- `upload/<locale>/screenshots/` — five current screenshots each for iPhone, Duo outer and iPad. Locales: en-US, da-DK, nb-NO, sv-SE.
- `upload/en-US/promotion/` — full-size Header and Search PNGs.
- `upload/<locale>/verification.json` — dimensions, RGB/no-alpha and SHA-256 verification for each language.
- `creative/app-design/` — current editable UI design system.
- `reference/` — historical project notes and research; older asset paths in these notes are historical.

Upload only the PNGs in `upload/en-US/`. Desigma thumbnails and raw captures are not upload artwork. No store submission has been made.

## Verified sizes — 2026-11-04

| Asset | Pixels | Files |
|---|---|---:|
| iPhone — medium Dynamic Island | 1206 × 2622 | 5 |
| Duo — outer | 1398 × 2034 | 5 |
| iPad — 13-inch | 2064 × 2752 | 5 |
| Header | 3840 × 1646 | 1 |
| Search | 1920 × 1280 | 1 |

All current PNGs have exact dimensions, 8-bit RGB without alpha, checked PNG CRCs and SHA-256 hashes. App Store Connect acceptance remains untested.

## Editable source

Canonical OneDrive library:
`/Users/jackiejensen/Library/CloudStorage/OneDrive-Personal/Programering/Flutter/Hint Master/Desigma Library`

Documents under `projects/Hint Master/files/`:

- `app-store-screenshots-en-US.desigma` — latest composed English screenshots, including Jackie's larger copy and adjusted layouts.
- The same document has editable **App Store Header** and **App Store Search** pages. Its library title is **App Store Artwork • Screenshots, Header & Search**.
- `hint-master-editable-system.desigma` — editable app UI components and localized store layouts.

All twenty screenshots were freshly exported from the current document on 2026-11-04; iPhone image 03 uses `raw/en-US/iphone-medium/03-chameleon_setup.png`. Matching OneDrive screenshot exports are refreshed. Promotion PNGs were copied from the verified full-size `App Store Upload` folder.

Old local drafts, review strips, external optimized image duplicates, rejected video loops, the obsolete screenshot reference and Apple template project/import have been moved to the macOS Trash in `Hint-Master-unused-assets-2026-11-04`. Current native documents and their embedded images remain intact. The original template in Downloads is outside this cleanup.

See [screenshots.md](screenshots.md) for native capture workflow and [desigma-mcp.md](desigma-mcp.md) for editor setup. Danish, Norwegian Bokmål and Swedish promotional text is now ready alongside English. Embedded app screenshots remain English. Video and Google Play creatives remain later work.

## Official requirements

- [Apple screenshot specifications](https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications/)
- [Apple header/search specifications](https://developer.apple.com/help/app-store-connect/reference/app-information/creative-assets-specifications/)

## Localized screenshots — 2026-11-04

The same canonical Desigma document now has four rows on each iPhone, Duo outer and iPad page: English, Danish, Norwegian Bokmål, Swedish. Each translated row duplicates the five English frames 1:1 below the previous row. Only editable promotional text and language/frame names differ; font sizes, layout, device shapes and embedded screenshot pixels are preserved. English originals are unchanged.

Ready folders: `upload/da-DK/screenshots/`, `upload/nb-NO/screenshots/`, `upload/sv-SE/screenshots/`, each containing 15 PNGs. There are 60 active screenshots across four languages, plus two English promotion PNGs.

Duo inner is not used for this submission. Its original document page and raw files remain as references; its five old English exports were moved out of upload folders into recoverable macOS Trash. Only Duo outer was localized. No store uploads or release submissions made.

## Google Play screenshots

The shared Desigma document contains **Android Phone** and **Android Tablet** pages with five screenshots per language. The original captures are under `raw/en-US/android-phone/` and `raw/en-US/android-tablet/`, named by scene. App captures are in English, with editable promotional text in English, Danish, Norwegian Bokmål and Swedish.

Use `upload/<locale>/google-play/android-phone/` for 1440 × 2560 phone PNGs and `upload/<locale>/google-play/android-tablet/` for 2560 × 1440 tablet PNGs. Matching OneDrive exports are under `exports/Hint Master/Google Play/<locale>/`. The combined native document exceeds the Desigma MCP import limit. The Android pages were rendered from a temporary native document with the same layers and image assets.
