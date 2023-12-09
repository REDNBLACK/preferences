cask "connectmenow" do
  arch arm: "arm64", intel: "x86-64"

  version "4.0.11"
  sha256 arm:   "1e490ebfd7c99461c907b2ab215bb90b9199762b60543a1d3fa5fb9a22099a7a",
         intel: "6bb955e6f124bbfbf885763597f80fb1513208c8a6c6cfd8393ff73e3dabe404"

  url "https://www.tweaking4all.com/downloads/network/ConnectMeNow#{version.major}-v#{version}-macOS-#{arch}.dmg",
      verified: "tweaking4all.com/downloads/network/"
  name "ConnectMeNow"
  desc "Mount network shares quick and easy"
  homepage "https://www.tweaking4all.com/os-tips-and-tricks/macosx-tips-and-tricks/connectmenow-v#{version.major}/"

  livecheck do
    url :homepage
    regex(%r{href=.*?/ConnectMeNow?(?:\d+)[._-]v?(\d+(?:\.\d+)+)[._-]macOS[._-].+\.dmg}i)
  end

  app "ConnectMeNow#{version.major}.app"

  uninstall signal: [
              ["QUIT", "com.Tweaking4all.ConnectMeNow4"]
            ],
            login_item: :app

  zap trash: [
    "~/Library/Preferences/com.Tweaking4All.ConnectMeNow4.ini",
    "~/Library/Preferences/com.Tweaking4All.ConnectMeNow4.ini.bak",
    "~/Library/Preferences/com.Tweaking4All.ConnectMeNow4.plist",
  ]
end
