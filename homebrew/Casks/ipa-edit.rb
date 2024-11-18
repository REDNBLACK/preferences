cask "ipa-edit" do
  version "2.0"
  sha256 "b003d0bdb3853db89916fc7dfd796d59e533f933f82b6a4f6fb4e415e595e108"

  url "https://github.com/ethandgoodhart/IPAEdit/releases/download/v#{version}/IPAEdit.zip"
  name "IPAEdit"
  desc "App to modify .ipa metadata including app icon, display name, and app version to avoid updates"
  homepage "https://github.com/ethandgoodhart/IPAEdit"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  app "IPAEdit.app"

  uninstall quit: "Ethan-Goodhart.IPAEdit"

  zap trash: [
    "~/Library/Saved Application State/Ethan-Goodhart.IPAEdit.savedState"
  ]
end
