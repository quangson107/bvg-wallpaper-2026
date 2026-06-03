#!/bin/zsh
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "$0")" && pwd)"
WALLPAPER_DIR="$SCRIPT_DIR/wallpapers"
PLIST="$HOME/Library/LaunchAgents/vn.bovagau.wallpaper2026.plist"

URLS=(
  ""
  "https://storage.googleapis.com/cdn-entrade/bovagau-meme/lich-2026_page-0002_1767177192"
  "https://storage.googleapis.com/cdn-entrade/bovagau-meme/lich-2026_page-0003_1767177198"
  "https://storage.googleapis.com/cdn-entrade/bovagau-meme/lich-2026_page-0004_1767177207"
  "https://storage.googleapis.com/cdn-entrade/bovagau-meme/lich-2026_page-0005_1767177214"
  "https://storage.googleapis.com/cdn-entrade/bovagau-meme/lich-2026_page-0006_1767177219"
  "https://storage.googleapis.com/cdn-entrade/bovagau-meme/lich-2026_page-0007_1767177232"
  "https://storage.googleapis.com/cdn-entrade/bovagau-meme/lich-2026_page-0008_1767177244"
  "https://storage.googleapis.com/cdn-entrade/bovagau-meme/lich-2026_page-0009_1767177251"
  "https://storage.googleapis.com/cdn-entrade/bovagau-meme/lich-2026_page-0010_1767177263"
  "https://storage.googleapis.com/cdn-entrade/bovagau-meme/lich-2026_page-0011_1767177277"
  "https://storage.googleapis.com/cdn-entrade/bovagau-meme/lich-2026_page-0012_1767177296"
  "https://storage.googleapis.com/cdn-entrade/bovagau-meme/lich-2026_page-0013_1767177301"
)

FILES=(
  ""
  "BVG-2026-01-Jan.jpg"
  "BVG-2026-02-Feb.jpg"
  "BVG-2026-03-Mar.jpg"
  "BVG-2026-04-Apr.jpg"
  "BVG-2026-05-May.jpg"
  "BVG-2026-06-Jun.jpg"
  "BVG-2026-07-Jul.jpg"
  "BVG-2026-08-Aug.jpg"
  "BVG-2026-09-Sep.jpg"
  "BVG-2026-10-Oct.jpg"
  "BVG-2026-11-Nov.jpg"
  "BVG-2026-12-Dec.jpg"
)

usage() {
  echo "Usage: ./set-bvg-wallpaper.command [month 1-12] [--download-all] [--install-reminder] [--remove-reminder]"
}

download_month() {
  local month="$1"
  local out="$WALLPAPER_DIR/${FILES[$month]}"
  mkdir -p "$WALLPAPER_DIR"
  if [[ ! -s "$out" ]]; then
    echo "Downloading month $month: ${FILES[$month]}"
    curl -L --fail -A "Mozilla/5.0" -o "$out.download" "${URLS[$month]}"
    mv "$out.download" "$out"
  fi
  echo "$out"
}

set_wallpaper() {
  local image="$1"
  osascript -e "tell application \"System Events\" to tell every desktop to set picture to POSIX file \"$image\""
}

install_reminder() {
  mkdir -p "$HOME/Library/LaunchAgents"
  cat > "$PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>vn.bovagau.wallpaper2026</string>
  <key>ProgramArguments</key>
  <array>
    <string>$SCRIPT_DIR/set-bvg-wallpaper.command</string>
  </array>
  <key>StartCalendarInterval</key>
  <dict>
    <key>Day</key>
    <integer>1</integer>
    <key>Hour</key>
    <integer>9</integer>
    <key>Minute</key>
    <integer>0</integer>
  </dict>
  <key>RunAtLoad</key>
  <true/>
</dict>
</plist>
EOF
  launchctl unload "$PLIST" >/dev/null 2>&1 || true
  launchctl load "$PLIST"
  echo "Monthly wallpaper task installed for day 1 at 09:00."
}

remove_reminder() {
  launchctl unload "$PLIST" >/dev/null 2>&1 || true
  rm -f "$PLIST"
  echo "Monthly wallpaper task removed."
}

MONTH="$(date +%-m)"
DOWNLOAD_ALL=0
INSTALL_REMINDER=0
REMOVE_REMINDER=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --download-all) DOWNLOAD_ALL=1 ;;
    --install-reminder) INSTALL_REMINDER=1 ;;
    --remove-reminder) REMOVE_REMINDER=1 ;;
    -h|--help) usage; exit 0 ;;
    [1-9]|1[0-2]) MONTH="$1" ;;
    *) echo "Unknown argument: $1"; usage; exit 1 ;;
  esac
  shift
done

if [[ "$REMOVE_REMINDER" -eq 1 ]]; then
  remove_reminder
  exit 0
fi

if [[ "$MONTH" -lt 1 || "$MONTH" -gt 12 ]]; then
  echo "Month must be from 1 to 12."
  exit 1
fi

if [[ "$DOWNLOAD_ALL" -eq 1 ]]; then
  for month in {1..12}; do
    download_month "$month" >/dev/null
  done
fi

IMAGE_PATH="$(download_month "$MONTH")"
set_wallpaper "$IMAGE_PATH"

if [[ "$INSTALL_REMINDER" -eq 1 ]]; then
  install_reminder
fi

echo "BVG wallpaper set for month $MONTH: $IMAGE_PATH"
