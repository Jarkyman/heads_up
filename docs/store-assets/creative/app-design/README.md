# Hint Master editable design system

`hint-master-editable-system.desigma` is the canonical editable source for app UI and store artwork.

## What is editable

- Five core phone screens: categories/home, Who Am I gameplay, Chameleon setup, secret role and reveal/result.
- Responsive phone and tablet screen variants built from native Desigma layers and Auto Layout.
- Shared button, category tile, icon and screen components.
- Editable SVG category icons, colors, spacing, typography and source background asset.
- A `Language` collection with English, Danish, Norwegian and Swedish modes.
- 38 variables covering screen copy, category names and store-promotion copy.
- `Store Pictures • Default` and `Store Pictures • Christmas` pages with App Store, Google Play and iPad export canvases.
- Store device shells reuse linked app-screen components; they are not screenshots.

The generator is `tools/store_assets/desigma_editable_system.rs`. It reads current translations from `assets/locale/translate/locale.json`, then builds the Desigma document reproducibly.

The canonical file is also registered in the OneDrive Desigma Library under **Hint Master → App Design** as **Hint Master • Editable Design System**.
