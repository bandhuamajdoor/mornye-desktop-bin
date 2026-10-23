# Maintainer: Manas Singh <singhmanas27896@gmail.com>

pkgname=mornye-desktop-bin
pkgver=5.2.6
pkgrel=1
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

package() {
  install -Dm755 \
    "$srcdir/Mornye-${pkgver}-linux-${CARCH}.AppImage" \
    "$pkgdir/opt/mornye-desktop/mornye.AppImage"

  install -d "$pkgdir/usr/bin"

  cat > "$pkgdir/usr/bin/mornye-desktop" <<'EOF'
#!/bin/sh
exec /opt/mornye-desktop/mornye.AppImage "$@"
EOF

  chmod 755 "$pkgdir/usr/bin/mornye-desktop"
}
