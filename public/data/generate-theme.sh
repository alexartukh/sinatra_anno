#!/bin/bash
# Generate GeneratedColors.xcassets from packages/theme/theme.json
# Run as Xcode build phase on the iOS app target.
set -euo pipefail

THEME_FILE="${SRCROOT}/../theme/theme.json"
XCASSETS_DIR="${SRCROOT}/GeneratedColors.xcassets"

if [ ! -f "$THEME_FILE" ]; then
    echo "error: theme.json not found at $THEME_FILE" >&2
    exit 1
fi

# Parse hex values using Python 3 (always available on macOS)
TEXT_HEX=$(python3 -c "import json; d=json.load(open('$THEME_FILE')); print(d['text'].lstrip('#'))")
BG_HEX=$(python3 -c "import json; d=json.load(open('$THEME_FILE')); print(d['background'].lstrip('#'))")

hex_to_components() {
    local hex="$1"
    python3 -c "
h='$hex'
r=int(h[0:2],16)/255.0
g=int(h[2:4],16)/255.0
b=int(h[4:6],16)/255.0
print(f'{r:.3f} {g:.3f} {b:.3f}')
"
}

read TEXT_R TEXT_G TEXT_B <<< "$(hex_to_components "$TEXT_HEX")"
read BG_R BG_G BG_B <<< "$(hex_to_components "$BG_HEX")"

# Dark mode: text and background swap per user decision
DARK_TEXT_R=$BG_R; DARK_TEXT_G=$BG_G; DARK_TEXT_B=$BG_B
DARK_BG_R=$TEXT_R; DARK_BG_G=$TEXT_G; DARK_BG_B=$TEXT_B

mkdir -p "$XCASSETS_DIR"

cat > "$XCASSETS_DIR/Contents.json" <<'JSON'
{"info": {"author": "xcode", "version": 1}}
JSON

write_colorset() {
    local name="$1"
    local lr="$2" lg="$3" lb="$4"
    local dr="$5" dg="$6" db="$7"
    local dir="$XCASSETS_DIR/${name}.colorset"
    mkdir -p "$dir"
    cat > "$dir/Contents.json" <<JSON
{
  "colors": [
    {
      "color": {
        "color-space": "srgb",
        "components": {"alpha": "1.000", "blue": "$lb", "green": "$lg", "red": "$lr"}
      },
      "idiom": "universal"
    },
    {
      "appearances": [{"appearance": "luminosity", "value": "dark"}],
      "color": {
        "color-space": "srgb",
        "components": {"alpha": "1.000", "blue": "$db", "green": "$dg", "red": "$dr"}
      },
      "idiom": "universal"
    }
  ],
  "info": {"author": "xcode", "version": 1}
}
JSON
}

write_colorset "KMFText"       "$TEXT_R" "$TEXT_G" "$TEXT_B"   "$DARK_TEXT_R" "$DARK_TEXT_G" "$DARK_TEXT_B"
write_colorset "KMFBackground" "$BG_R"   "$BG_G"   "$BG_B"     "$DARK_BG_R"   "$DARK_BG_G"   "$DARK_BG_B"

echo "generate-theme.sh: generated $XCASSETS_DIR from $THEME_FILE"
