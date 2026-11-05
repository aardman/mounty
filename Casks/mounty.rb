cask "mounty" do
  version "1.1.0"
  sha256 "46b0ae09aed3343b353e250a7f2864dfdc3594f2cc891b26d8b171ebf2f8a9e9"

  url "https://github.com/aardman/mounty/releases/download/v#{version}/Mounty.pkg"
  name "Mounty"
  desc "Menu bar picker for mounting SMB shares, with a custom-mount dialog"
  homepage "https://github.com/aardman/mounty"

  depends_on :macos

  pkg "Mounty.pkg"

  uninstall quit:    "org.aardman.Mounty",
            pkgutil: "org.aardman.Mounty.pkg",
            delete:  "/Applications/Mounty.app"
end
