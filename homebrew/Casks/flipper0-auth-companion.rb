cask "flipper0-auth-companion" do
  arch arm: "-arm64", intel: ""

  version "2.9.10"
  sha256 arm:   "a69a4dd2c5df953ff16a5f724b2aaf50b74256be39c10c588c5fc19ce1bc1016",
         intel: "0a05deed38796d739ec283321667398dda4120f88560dd52cd6958fb7cb37794"

  url "https://github.com/akopachov/flipper-zero_authenticator-companion/releases/download/v#{version}/Flipper-Authenticator-Companion-#{version}#{arch}.dmg"
  name "Flipper Authenticator Companion"
  desc "Flipper Authenticator Companion is a companion application for Flipper Authenticator software-based TOTP/HOTP authenticator for Flipper Zero device"
  homepage "https://github.com/akopachov/flipper-zero_authenticator-companion"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  app "Flipper Authenticator Companion.app"

  uninstall quit: "com.flipper.authenticator.companion.app"

  #xattr -d com.apple.quarantine "/Applications/Flipper Authenticator Companion.app"

  zap trash: [
    "~/Library/Preferences/tk.zwander.samsungfirmwaredownloader.plist",
    "~/Library/HTTPStorages/tk.zwander.samsungfirmwaredownloader",
    "~/Library/HTTPStorages/tk.zwander.samsungfirmwaredownloader.binarycookies"
  ]
end
