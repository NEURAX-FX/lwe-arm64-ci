# build-aarch64

Native ARM64 GitHub Actions build for the Fedora 45 aarch64 packages.
Uses the standard `ubuntu-24.04-arm` runner (4 cores, 16 GB RAM for public repositories).
The engine builds and runs `--help` inside a native ARM64 `fedora:45` container;
Steamworks and the GUI build directly on the ARM64 host. No cross toolchain,
extracted sysroot, or QEMU is required.

- `addon/` — steamworks.js 0.4.0 Rust sources + matching SDK linuxarm64 `libsteam_api.so`
- `gui/` — electron-builder arm64 config + patched `steamworks.js/index.js`

Fedora dependencies come from Huawei Cloud with RPM signature verification enabled.
CEF remains pinned to 135.0.17; the archive and Electron ARM64 runtime are checksum-verified.
The workflow checks RPM architectures and loads the packaged native addon with ARM64 Node.

Trigger: `gh workflow run build.yml`. Artifacts land in the `aarch64-release` run artifact.
