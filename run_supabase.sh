#!/usr/bin/env bash
# Run Mind Trust connected to Supabase (reads supabase.env.json)
set -euo pipefail
cd "$(dirname "$0")"

if [[ ! -f supabase.env.json ]]; then
  echo "Missing supabase.env.json — copy supabase.env.example.json and fill in your keys."
  exit 1
fi

# flutter devices prints: Name • DEVICE_ID • ios • ...
_pick_ios_android_id() {
  flutter devices 2>/dev/null | grep -E '• ios|• android' | head -1 | awk -F'•' '{gsub(/^[ \t]+|[ \t]+$/, "", $2); print $2}'
}

DEVICE_ID="$(_pick_ios_android_id)"

if [[ -z "$DEVICE_ID" ]]; then
  echo "No iOS/Android device found. Starting iOS Simulator..."
  flutter emulators --launch apple_ios_simulator 2>/dev/null || true
  echo "Waiting for simulator (up to 90s)..."
  for _ in $(seq 1 45); do
    DEVICE_ID="$(_pick_ios_android_id)"
    if [[ -n "$DEVICE_ID" ]]; then
      break
    fi
    sleep 2
  done
fi

if [[ -z "$DEVICE_ID" ]]; then
  echo ""
  echo "Still no iOS/Android device. Try:"
  echo "  open -a Simulator"
  echo "  flutter devices"
  echo "  ./run_supabase.sh"
  exit 1
fi

echo "Using device: $DEVICE_ID"
# Bundle keys for debug so plain `flutter run` still connects after one ./run_supabase.sh
mkdir -p assets
cp supabase.env.json assets/supabase.env.json
flutter run --dart-define-from-file=supabase.env.json -d "$DEVICE_ID" "$@"
