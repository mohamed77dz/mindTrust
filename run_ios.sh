#!/bin/bash
# iOS builds fail from Desktop paths (spaces / Finder metadata).
# This script syncs to ~/mind_trust and runs there.
set -e
export LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 COPYFILE_DISABLE=1
export PATH="$HOME/development/flutter/bin:$PATH"

SRC="$(cd "$(dirname "$0")" && pwd)"
DEST="$HOME/mind_trust"

rsync -a --delete "$SRC/" "$DEST/" \
  --exclude build \
  --exclude ios/Pods \
  --exclude ios/.symlinks \
  --exclude ios/Podfile.lock \
  --exclude .dart_tool

cd "$DEST"
xattr -rc . 2>/dev/null || true
flutter pub get
flutter run "$@"
