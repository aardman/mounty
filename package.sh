#!/bin/bash
#
# Packages the built apps as installers, each installing to
# /Applications/<Name>.app.
#
# Run ./build.sh first to (re)build the apps.

set -euo pipefail
cd "$(dirname "$0")"

INSTALL_DIR="/Applications"
VERSION="1.0.0"

package_app() {
    local name="$1"

    if [ ! -d "$name.app" ]; then
        echo "$name.app not found - run ./build.sh first" >&2
        exit 1
    fi

    rm -rf ".pkgroot-$name" ".component-$name.plist" "$name.pkg"
    mkdir -p ".pkgroot-$name$INSTALL_DIR"
    cp -R "$name.app" ".pkgroot-$name$INSTALL_DIR/$name.app"

    # By default pkgbuild treats a top-level .app as a relocatable bundle:
    # if Launch Services already knows a bundle with this identifier exists
    # elsewhere (e.g. this very app, run once from this repo checkout), the
    # installer silently installs THERE instead of --install-location.
    # Disable that so it always goes to the path we ask for.
    pkgbuild --analyze --root ".pkgroot-$name" ".component-$name.plist"
    /usr/libexec/PlistBuddy -c "Set :0:BundleIsRelocatable false" ".component-$name.plist"

    pkgbuild \
        --root ".pkgroot-$name" \
        --component-plist ".component-$name.plist" \
        --identifier "org.aardman.$name.pkg" \
        --version "$VERSION" \
        --install-location / \
        "$name.pkg"

    rm -rf ".pkgroot-$name" ".component-$name.plist"
}

package_app "Mounty"
package_app "MiniMounty"

echo "Built Mounty.pkg, MiniMounty.pkg"
