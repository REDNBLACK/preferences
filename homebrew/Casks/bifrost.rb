cask "bifrost" do
  arch arm: "aarch64", intel: "amd64"

  version "2.1.2"
  sha256 arm:   "480920afb2b67ff733c7c0c2f981430ff0b15d221150891e4a34a6fb4d9855a9",
         intel: "6fbf20f84a2a271b07573c8ad23aa3df07b2e844a9a68e9db8bdc4f53ebf310a"

  url "https://github.com/zacharee/Bifrost/releases/download/#{version}/bifrost-#{version}-mac-#{arch}.zip"
  name "Bifrost"
  desc "Samsung Firmware Downloader"
  homepage "https://github.com/zacharee/Bifrost"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  app "Bifrost.app"

  uninstall quit: "Bifrost"

  zap trash: [
    "~/Library/Application Support/Bifrost",
    "~/Library/Preferences/tk.zwander.samsungfirmwaredownloader.plist",
    "~/Library/Caches/tk.zwander.samsungfirmwaredownloader",
    "~/Library/HTTPStorages/tk.zwander.samsungfirmwaredownloader",
    "~/Library/HTTPStorages/tk.zwander.samsungfirmwaredownloader.binarycookies"
  ]
end
