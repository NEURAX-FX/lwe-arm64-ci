# build-aarch64

Self-contained GitHub Actions build for the Fedora 45 aarch64 packages:

- `engine/` — sysroot bootstrap script (verifies Fedora RPM signatures)
- `addon/` — steamworks.js 0.4.0 Rust sources (aarch64) + Steamworks SDK 1.65 linuxarm64 `libsteam_api.so`
- `gui/` — electron-builder arm64 config + patched `steamworks.js/index.js`
- `toolchain.cmake` — cross toolchain against `f45-cross` sysroot

Trigger: `gh workflow run build.yml`. Artifacts land in the `aarch64-release` run artifact.
