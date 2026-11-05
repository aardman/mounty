cask "minimounty" do
  version "1.1.0"
  sha256 "423f01d1841f3c7d9349f3fafdfa952ad95cfd01c5ccc81f1884c00797ff668c"

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
