cask "bifrost" do
  arch arm: "aarch64", intel: "amd64"

  version "1.20.4"
  sha256 arm:   "5b5057da8703ee8ed7783f52c6099a906e2dfe7c5faefff827e47d49c0b2222b",
         intel: "20f55617db449d7af7ca59ec06a266caa8ee67d159c984387f42edc79277c066"

  url "https://github.com/zacharee/SamloaderKotlin/releases/download/#{version}/bifrost-#{version}-mac-#{arch}.zip"
  name "Bifrost"
  desc "Samsung Firmware Downloader"
  homepage "https://github.com/zacharee/SamloaderKotlin"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  app "Bifrost.app"

  uninstall quit: "Bifrost"

  zap trash: [
    "~/Library/Preferences/tk.zwander.samsungfirmwaredownloader.plist",
    "~/Library/Caches/tk.zwander.samsungfirmwaredownloader",
    "~/Library/HTTPStorages/tk.zwander.samsungfirmwaredownloader",
    "~/Library/HTTPStorages/tk.zwander.samsungfirmwaredownloader.binarycookies"
  ]
end
