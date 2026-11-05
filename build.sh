#!/bin/bash
#
# Rebuilds Mounty.app and MiniMounty.app from their source scripts using
# Platypus. See README.md for what each variant does.
#
# Platypus's own command line tool (platypus_clt) expects its ScriptExec
# binary and nib to live in /usr/local/share/platypus, which normally only
# get installed there via Platypus > Preferences > "Install command line
# tool". Rather than touching that shared system location, this script
# decodes the bundled ScriptExec straight out of Platypus.app into a local
# .build/ dir and points platypus_clt at it directly.

set -euo pipefail
cd "$(dirname "$0")"

PLATYPUS_APP="/Applications/Platypus.app/Contents/Resources"
PLATYPUS_CLT="$PLATYPUS_APP/platypus_clt"

if [ ! -x "$PLATYPUS_CLT" ]; then
    echo "Platypus.app not found at /Applications/Platypus.app" >&2
    exit 1
fi

mkdir -p .build
base64 -d -i "$PLATYPUS_APP/ScriptExec.b64" > .build/ScriptExec
chmod +x .build/ScriptExec

build_app() {
    local name="$1"
    shift
    rm -rf "$name.app"
    "$PLATYPUS_CLT" \
        -a "$name" \
        -u "Nathan Taylor" \
        -i "./AppIcon.icns" \
        -e "$(pwd)/.build/ScriptExec" \
        -E "$PLATYPUS_APP/MainMenu.nib" \
        -y \
        "$@" \
        "$name.app"
}

# Mounty: a configurable list of SMB shares (edit the @shares array in
# mounty.pl), plus a "Mount Custom Share..." item that shells out to
# miniMounty.sh (bundled alongside it, since mounty.pl runs it as
# "./miniMounty.sh" relative to the app's Resources folder)
build_app "Mounty" \
    -o "Status Menu" \
    -p /usr/bin/perl \
    -V "1.1.0" \
    -I "org.aardman.Mounty" \
    -K "Icon" \
    -L "./hard-drive-white.png" \
    -q \
    -Y "Mounty" \
    -f "miniMounty.sh" \
    mounty.pl

# MiniMounty: just the custom-mount dialog, standalone, no menu
build_app "MiniMounty" \
    -o "None" \
    -p /bin/bash \
    -V "1.1.0" \
    -I "org.aardman.MiniMounty" \
    -R \
    miniMounty.sh

echo "Built Mounty.app, MiniMounty.app"
