# Hint Master store refresh — 2026-11-03

## Release 1.4.1 (14)

- Chameleon starts with a random name, then follows the seating order cyclically. The embedded shuffle/repeat button in the shared Chameleon count glass card disables random start; the first name then starts. The control was moved out of Settings. Roles remain random.
- Player drag handles reorder names, controllers and focus nodes together. New order is saved without persisting the random rotation. Delete controls are red, drag handles neutral grey.
- Direct dependencies updated to latest resolvable releases: Cupertino Icons 2.0.0, Google Mobile Ads 9.2.0 and Purchases Flutter 11.0.0. Flutter 3.47.8 / Dart 3.13.7 used. The current Flutter build migrates iOS minimum to 15.0. Dart constraint corrected to >=3.10.0 <4.0.0.
- Dimensions now recompute from the current viewport rather than retaining launch-time dimensions, allowing fold/resize changes.

## Verified console state

App Store Connect: 1.4.0 (13) Ready for Distribution. New Header/Search fields available; no selected header and Asset Library reports zero assets. This work does not publish changes or start experiments.

Google Play: dashboard reports pending publishing changes; latest production release dated July 6, 2026, build 11. Only 3 device acquisitions in the last 28 days; experiments may be inconclusive for a long time. Do not mix existing pending changes into an automatic submission.

## Capture rules

Capture actual app UI at native simulator/emulator resolution. Never recreate interface text, category cards or gameplay with generative AI. Keep provenance (device, locale, screen, build, date) in the manifest. Avoid consent forms, debug banners, test ads and personal names. Record both game modes, categories, role reveal and gameplay. AI may optionally supply decorative backgrounds; compose the unaltered UI above those and review disclosures before upload.

Minimum target set: current medium Dynamic Island iPhone, 13-inch iPad, Duo outer and Duo inner. Do not capture every older phone. Reuse scaling only where Apple accepts it and the interface matches. English only for this first pass. Danish, Swedish and Norwegian artwork is deferred at Jackie’s request.

Apple native Duo screenshots: outer 1398×2034, inner 2007×2853, or corresponding landscape. Providing Duo screenshots enables the optimized badge; screenshot requirement starts April 2027 for iOS 27.1 SDK submissions. Ordinary phone and iPad screenshots remain necessary.

## Creative direction

Match the existing English App Store screenshot series (reviewed directly in App Store Connect): mint/teal gradient, white typography and a large angled white iPhone. Keep the existing “ALL CATEGORIES / ONE PLACE” message for device screenshots. The revised header/search designs use “BIG LAUGHS. tiny clues.”, navy lettering, cream/coral stickers, sparse accents and the familiar teal/blue palette. Header/search show a landscape iPad alongside an ordinary iPhone, never Duo. Use Duo only for its device-specific screenshots and testing.

Show the full premium UI with every category unlocked and no system status bars (including Duo’s side time/status area). `tools/store_assets/main.dart` is a separate debug-only entrypoint that substitutes a premium settings controller without saving entitlement state or configuring purchases. Production continues to use `lib/main.dart`. Hide status UI before capture; do not paint over it or synthesize app content.

Creative exports: header 3840×1646; search 1920×1280 or larger 3:2 up to 3840×2560; universal still 5244×2950 PNG. RGB, no alpha. Keep essential artwork within official template safe areas and inspect actual console crops. Header/search loops: 5–30 seconds, 30/60 fps, MOV/M4V/MP4. Jackie rejected the still-image zoom loops; those files are archived under `archive/rejected-still-loops/` and must not be uploaded. Video is deferred until it can show real interaction: category selection, correct/pass tilts, results and return to start. Actual app previews use recorded gameplay and their separate specifications.

## Experiments and publishing sequence

1. Complete fold/resize, keyboard, role handoff, tilt gameplay, ads, purchase and restore checks. Use sandbox purchases; never buy a real product as part of testing.
2. Capture final release UI across the target set in English. Review all screenshots at full size; check names, text clipping and current build provenance.
3. Produce header/search creatives and Google Play 1024×500 feature graphic. Android screenshots must show the Android app, not iOS chrome. Add localized alt text where supported.
4. Stage approved assets in Apple Asset Library and inspect header/search previews. Associate screenshot sets with the new version. Verify the Duo badge after Apple processes the assets.
5. Check current name/subtitle/keywords, localization coverage, category and privacy declarations against the new SDKs. Do not blindly remove existing keywords or change privacy declarations from package names alone.
6. Test only the first screenshot A vs B initially, holding other assets and copy constant. Use App Store Product Page Optimization and Google Play localized Store Listing Experiments. Track conversion and retained installs; wait for confidence and adequate sample size. Do not claim a lift from a few downloads.
7. Consider a featuring nomination after final Duo QA and polished assets. Describe real distinctive qualities and the release date; no guarantee of featuring. Create in-app events only for genuine time-limited experiences.
8. Jackie reviews and tests local code before commit/push. Upload/review/release and live experiment activation remain separately reviewable steps.

## Official sources

- [Apple asset best practices](https://developer.apple.com/app-store/asset-best-practices/)
- [Screenshot specifications](https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications)
- [Creative asset specifications](https://developer.apple.com/help/app-store-connect/reference/app-information/creative-assets-specifications)
- [App preview specifications](https://developer.apple.com/help/app-store-connect/reference/app-information/app-preview-specifications)
- [Prepare for Duo](https://developer.apple.com/iphone-duo/)
- [Google preview assets](https://support.google.com/googleplay/android-developer/answer/9866151?hl=en)
- [Google experiments](https://google.play/business/store-listing-experiments/)

## Reproduce the English captures and artwork

Original source layouts were read from `Mock UPS/EN/Hint master EN.mockup` inside Jackie's OneDrive screenshot folder. The extracted design settings are in `tools/store_assets/reference-style.json`. Original PSD, mockup and export files were not changed.

1. Build the isolated capture target:
   `flutter build ios --simulator --debug --target tools/store_assets/main.dart`
2. For the local simulator bundle only, enable controller-based status bar handling:
   `/usr/libexec/PlistBuddy -c 'Set :UIViewControllerBasedStatusBarAppearance true' build/ios/iphonesimulator/Runner.app/Info.plist`
   This is an adjustment to the generated screenshot bundle, not to `ios/Runner/Info.plist`.
3. Install/launch it on the chosen simulator. Let home finish loading, then use RocketSim to capture native PNGs. Confirm no unlock icon, no category locks, and no time/Wi-Fi/battery status UI before retaining a capture. Hardware camera cutouts are part of the actual device capture.
4. Capture iPad in actual landscape orientation and rebuild its category layout before saving `raw/en-US/ipad-13/02-categories-landscape.png`. All 16 base category cards should be visible. Do not rotate a portrait screenshot to imitate landscape.
5. Run `swift -module-cache-path /tmp/hint-master-swift-cache tools/store_assets/render.swift` for the original-style device screenshots, then `swift -module-cache-path /tmp/hint-master-swift-cache tools/store_assets/render-v2.swift` for the preferred header/search drafts under `creative/en-US/v2/`. Roboto is bundled with its OFL license. `video.py` is retained as historical tooling only; do not generate new still-image loops.
6. Restore the normal target with `flutter build ios --simulator --debug --target lib/main.dart` before ordinary app testing. Simulator instances used for captures may still run the isolated premium capture build; they are not suitable for validating real purchases or ads.

Current exports are review drafts. Native captures cover one ordinary iPhone, Duo outer/inner and 13-inch iPad, all in English. Preferred header/search drafts are `creative/en-US/v2/header.png` (3840×1646) and `creative/en-US/v2/search.png` (1920×1280), showing an actual landscape iPad with all 16 base categories and an ordinary iPhone. Older header/search PNGs are retained as superseded drafts. The Duo outer layout was adjusted to keep its complete headline clear of the device frame. No generated AI imagery was needed. Additional gameplay/Chameleon variants, translations, console crop previews and store submissions remain later work after the first English design review.

Native raw PNGs retain RocketSim’s original alpha channel as source material. Upload the RGB, alpha-free composed exports under `creative/en-US/`, or flatten raw captures losslessly before direct upload.

## English device screenshot series

See [screenshots.md](screenshots.md) for the single editable Desigma document, per-device upload folders and exact completion status. Completed 2026-11-04: iPhone, Duo outer, Duo inner and iPad each have 5/5 English images. Remaining native captures were completed using Apple Device Hub/devicectl. Gameplay screenshots include the corrected landscape word and timer sizes. All twenty PNGs have verified dimensions and RGB/no-alpha format.
