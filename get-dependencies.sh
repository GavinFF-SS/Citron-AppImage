#!/bin/sh

set -ex

sed -i 's/DownloadUser/#DownloadUser/g' /etc/pacman.conf

if [ "$(uname -m)" = 'x86_64' ]; then
	PKG_TYPE='x86_64.pkg.tar.zst'
fi

LLVM_URL="https://github.com/pkgforge-dev/llvm-libs-debloated/releases/download/continuous/llvm-libs-nano-$PKG_TYPE"
FFMPEG_URL="https://github.com/pkgforge-dev/llvm-libs-debloated/releases/download/continuous/ffmpeg-mini-$PKG_TYPE"
QT6_URL="https://github.com/pkgforge-dev/llvm-libs-debloated/releases/download/continuous/qt6-base-iculess-$PKG_TYPE"
LIBXML_URL="https://github.com/pkgforge-dev/llvm-libs-debloated/releases/download/continuous/libxml2-iculess-$PKG_TYPE"

echo "Installing build dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --needed --noconfirm base-devel boost catch2 cmake ffmpeg fmt git glslang libzip lz4 \
    mbedtls ninja nlohmann-json openssl opus qt5 sdl2 zlib zstd zip unzip qt6-base qt6-tools qt6-svg \
    qt6-declarative qt6-webengine sdl3 qt6-multimedia clang qt6-wayland fuse2 rapidjson wget sdl3

if [ "$(uname -m)" = 'x86_64' ]; then
	pacman -Syu --noconfirm vulkan-intel
fi


echo "Installing debloated pckages..."
echo "---------------------------------------------------------------"
wget --retry-connrefused --tries=30 "$LLVM_URL" -O ./llvm-libs.pkg.tar.zst
wget --retry-connrefused --tries=30 "$QT6_URL" -O ./qt6-base-iculess.pkg.tar.zst
wget --retry-connrefused --tries=30 "$LIBXML_URL" -O ./libxml2-iculess.pkg.tar.zst
wget --retry-connrefused --tries=30 "$FFMPEG_URL" -O ./ffmpeg-mini-x86_64.pkg.tar.zst

pacman -U --noconfirm \
	./qt6-base-iculess.pkg.tar.zst \
	./libxml2-iculess.pkg.tar.zst \
	./ffmpeg-mini-x86_64.pkg.tar.zst \
	./llvm-libs.pkg.tar.zst

rm -f ./qt6-base-iculess.pkg.tar.zst \
	./libxml2-iculess.pkg.tar.zst \
	./ffmpeg-mini-x86_64.pkg.tar.zst \
	./llvm-libs.pkg.tar.zst

echo "All done!"
echo "---------------------------------------------------------------"
