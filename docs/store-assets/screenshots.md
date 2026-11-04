# English App Store screenshot series

Canonical editable document (one document, four pages, five frames per page):

`/Users/jackiejensen/Library/CloudStorage/OneDrive-Personal/Programering/Flutter/Hint Master/Desigma Library/projects/Hint Master/files/app-store-screenshots-en-US.desigma`

The document is registered under **Hint Master → Screenshots**. Native text layers use `COPY/en-US/...`; stickers, backgrounds and device frames remain editable. Screen image fills contain real English premium app captures. No interface was generated or reconstructed. System time, Wi-Fi and battery indicators are hidden; the devices' actual camera cutouts remain.

## Upload folders and current status

Root: `Desigma Library/exports/Hint Master/Screenshots/en-US/`

| Folder | Export dimensions | Ready | Pending |
|---|---|---:|---:|
| iPhone | 1206 × 2622 | 5 | 0 |
| Duo/Outer | 1398 × 2034 | 5 | 0 |
| Duo/Inner | 2853 × 2007 | 5 | 0 |
| iPad | 2064 × 2752 | 5 | 0 |

All twenty frames are complete and exported into these folders. There are no remaining placeholder frames. No files were uploaded to App Store Connect and acceptance has not been tested.

All 20 exported PNGs were checked for exact dimensions, 8-bit RGB without alpha, PNG chunk CRCs and SHA-256. Losslessly optimized image fills were verified to render the exact same pixels as the original native captures; originals are retained separately. Detailed frame IDs and hashes are in adjacent `upload-verification.json`. Previews and contact sheets live separately under `Verification/Screenshot Series/en-US/`; do not upload those previews.

Specifications checked 2026-11-03: [Apple screenshot specifications](https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications). The medium Dynamic Island iPhone, both Duo displays and 13-inch iPad use their own accepted output sizes. Landscape gameplay stays landscape within the composed device frame.

## Five-image story

1. **Your next game night.** Categories and two shared-device party games.
2. **Phone up. Game on.** Forehead guessing, friends' clues and the timer.
3. **Friends in. Secrets out.** Chameleon player setup and starting order.
4. **Pass the phone. Keep a secret.** Everyone receives a word except the Chameleon; private role reveal.
5. **Give a clue. Find the bluff.** Give clues without revealing the word, then uncover the Chameleon.

Mint/blue gradient, navy Roboto type, cream/coral stickers and white device frames follow the approved promotion images. Copy is native editable text, including later translation points. Supporting detail stays quieter than the two main sticker headlines.

## Completion and capture workflow — 2026-11-04

The initial RocketSim quota interruption is resolved. At Jackie's request, completed the remaining captures with Apple's Device Hub and its companion `devicectl` CLI. The latter accepts explicit display IDs, avoiding the Device Hub screenshot button sometimes capturing Duo's inactive outer display. Hinge posture was changed using Device Hub's actual Closed/Open controls.

The screenshot-only debug entrypoint also supports repeatable production-page fixtures, selected at build time with `--dart-define=HINTMASTER_STORE_SCENE=gameplay` (or `categories`, `setup`, `role`, `reveal`). It uses actual category resources, native production widgets, fictional players and a valid seeded finished Chameleon round. The real gameplay countdown is paused only in this capture target to allow a stable fold/unfold capture. No app UI is generated or reconstructed. `capture_scenes.py` waits for the app's own ready file before using Apple's native screenshot API. Build/install a matching fixture before each requested scene; the script's `--scenes` argument does not alter an already compiled app.

Duo capture should launch while closed, then unfold the running scene for an inner capture if a fresh launch while open does not attach its Flutter view. Keep the inner screenshot upright in its genuine captured orientation and preserve its aspect ratio in the design. Do not rotate or stretch UI to fake another display. Native inner captures can be portrait while their designed App Store export canvas is landscape.

Capture uses a separate simulator app bundle, `com.hartvig.develop.hint.master.capture`, with no persisted premium entitlement. It does not change the normal app's preferences. No video, store upload, commit or push is included.

## Landscape gameplay regression

The earlier change from cached Dimensions fields to viewport getters caused WordPage fonts and timer dimensions to shrink when screen height became the short landscape edge. WordPage now derives GameplayDimensions from its local MediaQuery's longest edge. This restores large word/timer/countdown sizes while keeping resize responsiveness and long-word fitting. Seven tests pass, including landscape readability, long words across five display sizes and orientation/fold scale checks. Flutter analyze passes; the normal lib/main.dart simulator build was restored successfully. Gameplay captures now show the corrected production widget.

## Authoring evidence

`tools/store_assets/screenshots.rs` is the initial native Desigma layout generator (desigma-doc/desigma-render alpha.14 Rust crates, compatible with the installed alpha.17 editor). Final copy was refined through the official alpha.17 MCP server's file session; the initial generator now also preserves the approved Duo outer text/device gap; final PNGs were exported through `desigma_export_image` and flattened with macOS AppKit. The canonical document is authoritative after those MCP edits. PNG image fills are losslessly recompressed with Apple pngcrush and verified pixel-identical using CoreGraphics; native originals remain in raw/en-US/screenshot-series/.

Desigma serializes embedded PNG bytes as JSON arrays. The final native file is compact JSON (about 45 MB), preserving all images and layers while keeping it below MCP's 64 MiB import limit. A pretty-printed save can exceed that import limit; compacting JSON without changing data restores compatibility. Do not overwrite the canonical file by rerunning the initial layout generator without preserving final copy/layout edits.
