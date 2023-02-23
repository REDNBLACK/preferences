cask "lantern" do
  version "7.3.4"
  sha256 "adbde39f0ba00865fdd27fa2676893fe6542c98e4f267b4e287c7bdaf5a300ce"

  url "https://github.com/getlantern/lantern-binaries/raw/main/lantern-installer.dmg"
  name "Lantern"
  desc "Open Internet For All"
  homepage "https://lantern.io/"

  livecheck do
    url "https://github.com/getlantern/lantern-binaries/blob/main/lantern-installer.dmg"
    regex(/title=["'](.+?)["'](?:.+?)href=["']\/getlantern\/lantern-binaries\/commit\/(?:.+?)["']/i)
    strategy :page_match do |page, regex|
      match = page.scan(regex).map { |title| title&.first&.match(/(\d+(?:\.\d+)+)/) }
      "#{match.first}"
    end
  end

  app "Lantern.app"

  uninstall quit:      "com.getlantern.lantern",
            launchctl: "org.getlantern"

  zap trash: [
    "~/Library/Application Support/Lantern",
    "~/Library/LaunchAgents/org.getlantern.plist",
    "~/Library/Caches/Lantern",
    "~/Library/Logs/Lantern",
    "~/.lanternsecrets"
  ]
end
