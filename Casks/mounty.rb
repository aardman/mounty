cask "mounty" do
  version "1.0.0"
  sha256 "5f02461f36417ea3e119ef127a4ddb4961e1c83d8577f23e7514337415eab6b4"

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
