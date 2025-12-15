cask "idevice-pair" do
  version "0.1.9"
  sha256 "6a86716ca3485aa90752c35bca014972c4cc4329917b5ba62822487e9baaa413"

  url "https://github.com/jkcoxson/idevice_pair/releases/download/v#{version}/idevice_pair--macos-universal.dmg"
  name "iDevice Pair"
  desc "A cross-platform GUI application for managing iOS device pairing and wireless debugging"
  homepage "https://github.com/jkcoxson/idevice_pair"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  app "idevice_pair.app"
end
