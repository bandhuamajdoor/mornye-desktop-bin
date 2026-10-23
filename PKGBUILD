# Maintainer: Manas Singh <singhmanas27896@gmail.com>

pkgname=mornye-desktop-bin
pkgver=5.2.6
pkgrel=3
pkgdesc="Mornye desktop music player"
arch=('x86_64')
url="https://github.com/mornyeapp/Mornye-Desktop"
license=('LGPL-3.0-only')
depends=('bash' 'fuse2')
options=('!strip')

source=(
  "Mornye-${pkgver}-linux-${CARCH}.AppImage::https://github.com/mornyeapp/Mornye-Desktop/releases/download/v${pkgver}/Mornye-v${pkgver}-linux-x86_64.AppImage"
)

sha256sums=('3d341140ba9a8cf603469add74113751e8d8a0f7062eb74d424bdd6295a765ed')

prepare() {
  cd "$srcdir"
  chmod +x "Mornye-${pkgver}-linux-${CARCH}.AppImage"
  "./Mornye-${pkgver}-linux-${CARCH}.AppImage" --appimage-extract
}

package() {
  # Install the AppImage
  install -Dm755 \
    "$srcdir/Mornye-${pkgver}-linux-${CARCH}.AppImage" \
    "$pkgdir/opt/mornye-desktop/mornye.AppImage"

  # Install command-line launcher
  install -d "$pkgdir/usr/bin"

  cat > "$pkgdir/usr/bin/mornye-desktop" <<'EOF'
#!/bin/sh
exec /opt/mornye-desktop/mornye.AppImage "$@"
EOF

  chmod 755 "$pkgdir/usr/bin/mornye-desktop"

  # Install the upstream application icon
  install -Dm644 \
    "$srcdir/squashfs-root/com.zarz.mornye.png" \
    "$pkgdir/usr/share/icons/hicolor/256x256/apps/com.zarz.mornye.png"

  # Install application menu entry
  install -Dm644 /dev/stdin \
    "$pkgdir/usr/share/applications/mornye-desktop.desktop" <<'EOF'
[Desktop Entry]
Name=Mornye Desktop
Comment=Music player
Exec=mornye-desktop
Icon=com.zarz.mornye
Terminal=false
Type=Application
Categories=AudioVideo;Audio;Player;
StartupNotify=true
EOF
}
