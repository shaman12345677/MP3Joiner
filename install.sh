#!/bin/bash

# MP3Joiner Download Script
# Automaticky stáhne nejnovější verzi z GitHub Releases

set -e

REPO="shaman12345677/MP3Joiner"
APP_NAME="MP3Joiner"
DOWNLOAD_DIR="$HOME/Downloads"

echo "🎵 MP3Joiner Downloader"
echo "======================"

# Získání nejnovější verze
echo "📡 Kontroluji nejnovější verzi..."
LATEST_VERSION=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" | grep '"tag_name"' | cut -d'"' -f4)
echo "✅ Nejnovější verze: $LATEST_VERSION"

# Získání URL pro stažení
DOWNLOAD_URL="https://github.com/$REPO/releases/download/$LATEST_VERSION/$APP_NAME-$LATEST_VERSION.zip"
echo "📥 Stahuji z: $DOWNLOAD_URL"

# Stažení souboru
echo "⏳ Stahuji aplikaci..."
curl -L -o "$DOWNLOAD_DIR/$APP_NAME-$LATEST_VERSION.zip" "$DOWNLOAD_URL"

echo "✅ Stažení dokončeno!"
echo "📁 Soubor uložen do: $DOWNLOAD_DIR/$APP_NAME-$LATEST_VERSION.zip"

# Rozbalení a instalace
echo "📦 Rozbaluji aplikaci..."
cd "$DOWNLOAD_DIR"
unzip -o "$APP_NAME-$LATEST_VERSION.zip"

echo "🚀 Instalace:"
echo "1. Přetáhněte $APP_NAME.app do složky Applications"
echo "2. Spusťte aplikaci"
echo ""
echo "📋 Požadavky:"
echo "- macOS 14.0 nebo novější"
echo "- FFmpeg: brew install ffmpeg"
echo ""
echo "🎉 Instalace dokončena!"
