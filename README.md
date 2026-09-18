# Mounty / MiniMounty

Menu bar picker for SMB shares - mount a share (or open it in Finder if already mounted) by
clicking its name from the menu bar, instead of typing `smb://...` paths manually.

Two variants, built from the same underlying script:

* **Mounty** - a configurable list of shares in the menu, plus a "Mount Custom Share..."
  item at the bottom for typing in an arbitrary path (Windows UNC or `smb://` format).
* **MiniMounty** - just the custom-mount dialog on its own, no menu. Launching it
  immediately pops the "Enter network path" dialog and quits. This is the same dialog
  Mounty's "Mount Custom Share..." item calls internally (via the bundled
  `miniMounty.sh`), packaged standalone in case you just want that as its own launchable
  utility (e.g. from Self Service, Spotlight, etc.).

## Configuring your own shares

Mounty's share list lives in [mounty.pl](mounty.pl) as a plain array:

```perl
my @shares = (
    ["Example Share",    "smb://fileserver.example.com/share"],
    ["Example Projects",  "smb://fileserver.example.com/projects"],

    ["=== Example Section ===", undef],
    ["Example Archive", "smb://nas.example.com/archive"],
);
```

Each entry is `[menu label, smb:// URL]`. A URL of `undef` makes a non-clickable section
header. Edit this list to match your own shares, then run `./build.sh` to rebuild the app -
the menu and the mount action are both generated from this one list, so there's only one
place to edit.

## Installing

### Via Homebrew

```
brew tap aardman/mounty https://github.com/aardman/mounty
brew install --cask mounty        # menu with your configured shares
brew install --cask minimounty    # just the custom-mount dialog
```

The explicit URL on `brew tap` is needed because this repo isn't named `homebrew-mounty` -
Homebrew's short `brew tap aardman/mounty` form only looks for a repo with that exact
prefix, so the URL tells it where to actually find this one.

If you want your own share list baked into what Homebrew installs, fork this repo, edit
`mounty.pl`, and publish your own release + cask (see "Releasing a new version" below) -
Homebrew casks install a specific downloaded `.pkg`, so there's no way to point the default
cask at a locally-edited script without rebuilding and hosting your own version.

### Manually

Download `Mounty.pkg` and/or `MiniMounty.pkg` from the [Releases](../../releases) page (or
build them yourself, see below) and run:

```
sudo installer -pkg Mounty.pkg -target /
```

This installs the app to `/Applications/Mounty.app`. Launch it from Spotlight, Finder, or
your MDM of choice - it isn't set to launch automatically at login.

## Building from source

Requires [Platypus](https://sveinbjorn.org/platypus) (`/Applications/Platypus.app`).

```
./build.sh      # (re)builds Mounty.app, MiniMounty.app from the scripts
./package.sh    # builds Mounty.pkg, MiniMounty.pkg
```

`package.sh` also disables `pkgbuild`'s default bundle relocation
(`BundleIsRelocatable`): without this, if Launch Services already knows an app with this
identifier exists somewhere (e.g. this very app, having been run once from a local
checkout), the installer silently installs *there* instead of `/Applications` - no error,
no warning. Worth checking `pkgutil --payload-files Mounty.pkg` after any change to confirm
it still lands where you expect.

## Files

* `mounty.pl` - the share list + mount logic
* `miniMounty.sh` - the custom-mount dialog (osascript prompt -> UNC/`smb://` conversion ->
  `open`), used standalone by MiniMounty and internally by Mounty
* `hard-drive-white.png` - the menu bar status icon (a template image, so it adapts to
  light/dark menu bars)
* `AppIcon.icns` - the app bundle icon, shared by both
* `build.sh` - rebuilds `Mounty.app` and `MiniMounty.app` from the scripts above
* `package.sh` - builds `Mounty.pkg` and `MiniMounty.pkg` from the built apps
* `Casks/mounty.rb`, `Casks/minimounty.rb` - the Homebrew cask definitions (this repo
  doubles as its own tap)

## Releasing a new version

1. Bump the version in both `build.sh` (per-app `-V`) and `package.sh` (`VERSION=`), then
   `./build.sh && ./package.sh`
2. `shasum -a 256 Mounty.pkg MiniMounty.pkg` and update `version`/`sha256` in both
   `Casks/*.rb` to match
3. Commit, push, then `gh release create vX.Y.Z Mounty.pkg MiniMounty.pkg` (or create the
   release and upload both as assets via the GitHub UI) - each cask's `url` expects its pkg
   at `releases/download/vX.Y.Z/<Name>.pkg`
4. `brew audit --cask` and `brew style --cask` against both tapped casks before calling it
   done

## License

MIT - see [LICENSE](LICENSE).
