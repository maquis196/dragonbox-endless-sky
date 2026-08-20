#!/bin/bash

set -euo pipefail

VERSION="${1:?Usage: $0 <version - example - 0.22.1>}"
UPSTREAM_VERSION="${VERSION%-r*}"

PACKAGE_NAME="endless-sky"
REVISION="${VERSION##*-r}"
P="${PACKAGE_NAME}-${UPSTREAM_VERSION}"

# Fetch sources
mkdir -p build
cd build
rm -f "v${UPSTREAM_VERSION}.tar.gz"
wget https://github.com/endless-sky/endless-sky/archive/refs/tags/v0.11.2.tar.gz
tar zxpvf v${UPSTREAM_VERSION}.tar.gz
cd endless-sky-${UPSTREAM_VERSION}

# Build # Set options
cmake --preset linux-gles -DCMAKE_INSTALL_PREFIX=./gamedata
cmake --build --preset linux-glex-release --target EndlessSky
cmake --install build/linux-gles

## Configure meta file
cat > assets/meta/default.desktop <<EOF
[Desktop Entry]
Version=${UPSTREAM_VERSION}
Type=Application
Categories=Game;Strategy;
Name=Endless Sky
Exec=endless_sky.sh
Icon=icon_32x32.png
X-DBP-Screenshot=teaser1.png

[Package Entry]
Id=endless_sky_maquis196
Name=Endless Sky
Arch=armhf
Exec=endless_sky.sh
Version=${VERSION}
Icon=WinApp.ico
EOF

rm -f data.zip gamedata.sqfs
mksquashfs gamedata gamedata.sqfs -comp xz

cd assets
zip -r ../data.zip *
cd ..

cat gamedata.sqfs data.zip > "${P}_maquis196.dbp"
