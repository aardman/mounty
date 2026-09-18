cask "minimounty" do
  version "1.0.0"
  sha256 "f54c9602550a481dc9f9a59c8f2997812dcd4c230f6f1c2a96f48f7fcbcd68ab"

  url "https://github.com/aardman/mounty/releases/download/v#{version}/MiniMounty.pkg"
  name "MiniMounty"
  desc "Standalone custom SMB share mount dialog"
  homepage "https://github.com/aardman/mounty"

  depends_on :macos

  pkg "MiniMounty.pkg"

  uninstall quit:    "org.aardman.MiniMounty",
            pkgutil: "org.aardman.MiniMounty.pkg",
            delete:  "/Applications/MiniMounty.app"
end
