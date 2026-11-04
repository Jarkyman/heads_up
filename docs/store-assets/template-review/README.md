# Apple template and editor review — 2026-11-03

## Export dimensions

Verified current preferred exports: header 3840×1646, search 1920×1280; both RGB PNG without alpha. These match Apple creative-asset requirements. Pixel dimensions do not establish safe-area compliance. Existing artwork still needs template safe-area placement review and App Store Connect crop previews before upload.

## Supplied Apple file

Source: `/Users/jackiejensen/Downloads/creative_assets-templates.fig`, ZIP containing canvas.fig, thumbnail, metadata and two images. Internal document title: `OLD Creative Assets Templates`; exported 2026-08-05. Original file left unchanged. Desigma successfully imported Universal, Search and Header frames and displayed green art-safe-area guides. Header properties show 3840×1646. See `apple-template-in-desigma.png` for the actual import test. Import success is not proof of complete Figma rendering parity.

## Editor evaluation

- Desigma: tested official v0.1.0-alpha.14 macOS universal archive, SHA256 `f842a6552e3f3d646fd7161d076f836518a202961b56eff8aed096c4fd2c23df`, matched release SHA256SUMS. Ran temporarily from /tmp with isolated /tmp library; no permanent install or MCP configuration. Actual Apple-file import and screenshot rendering succeeded. Suitable for evaluating this file, but the project is early alpha and unsigned releases/import fidelity warrant evaluation before making it the main editor.
- Penpot: much larger open-source design project (about 62k GitHub stars versus Desigma about 954 at inspection). Its official migration guidance uses exported SVG/images or conversion, so direct lossless .fig import should not be assumed. Better general open-source candidate; less direct for this supplied Apple file.
- Figma Starter: free plan, unlimited drafts, .fig import available on all plans. Preferred simplest route for inspecting this Apple-native template without a subscription. No account creation, login or purchase performed.

## Sources

- https://developer.apple.com/help/app-store-connect/reference/app-information/creative-assets-specifications
- https://developer.apple.com/app-store/asset-best-practices/
- https://github.com/deepfounder-ai/desigma
- https://github.com/deepfounder-ai/desigma/releases/tag/v0.1.0-alpha.14
- https://github.com/penpot/penpot
- https://help.penpot.app/user-guide/first-steps/migration-guide/
- https://help.figma.com/hc/en-us/articles/13838684089751-Starter-plan-overview
- https://help.figma.com/hc/en-us/articles/360041003114-Import-files-to-the-file-browser
