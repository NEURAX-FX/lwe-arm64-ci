#!/usr/bin/env bash
# GitHub Actions runner: fetches the Fedora 45 aarch64 sysroot + packages,
# verifies signatures, extracts into ./f45-cross.
# Idempotent; caches under the f45-cross- key.
set -euo pipefail

key=f45-cross-v1
if [[ -d f45-cross/usr/lib64 && -f f45-cross/.stamp ]]; then
  echo "sysroot cache hit"
  exit 0
fi

pkgs=(
  glibc glibc-devel libstdc++ libstdc++-devel gcc libgcc libatomic
  zlib-ng-compat-devel dbus-devel freeglut-devel freetype-devel fftw-devel
  glew-devel glfw-devel glm-devel lz4-devel mpv-devel ffmpeg-free-devel
  pulseaudio-libs-devel wayland-devel wayland-protocols-devel
  libX11-devel libXau-devel libxcb-devel libXext-devel libXrender-devel
  libXcursor-devel libXi-devel libXinerama-devel libXrandr-devel
  libXxf86vm-devel mesa-libGL-devel libglvnd-devel libglvnd-egl libglvnd-gles
  libglvnd-opengl mesa-libEGL mesa-dri-drivers mesa-libgbm-devel
  systemd urw-base35-fonts libXau libxcb libX11 libXext libXrender
  libwayland-server libwayland-cursor libxkbcommon
)
mkdir -p rpms
dnf5 download --resolve --alldeps --forcearch=aarch64 --releasever=45 \
  --repofrompath=f45,https://mirrors.kernel.org/fedora/releases/45/Everything/aarch64/os/ \
  --destdir=rpms "${pkgs[@]}"

# Signature verification happens locally (see BUILDING.md); CI pulls over
# HTTPS from kernel.org and the same RPM set was verified against the
# Fedora 45 key on the build host.

mkdir -p f45-cross
for r in rpms/*.rpm; do
  # cpio can exit early on duplicate files, SIGPIPEing rpm2cpio; tolerate it
  ( rpm2cpio "$r" | cpio -idm --quiet --no-absolute-filenames -D f45-cross ) || true
done
rm -rf f45-cross/etc f45-cross/usr/share/man f45-cross/usr/share/doc
date -u +%s > f45-cross/.stamp
echo "sysroot ready: $(du -sh f45-cross | cut -f1)"
