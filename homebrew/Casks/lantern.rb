cask "lantern" do
  version "7.4.0"
  sha256 "a7e4b27832999c5a665867fb6f92e5297bde1473151f711e5dbc1c4bcfaa902b"

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
    "~/Library/Application Support/byteexec",
    "~/Library/LaunchAgents/org.getlantern.plist",
    "~/Library/Caches/Lantern",
    "~/Library/Logs/Lantern",
    "~/.lanternsecrets",
    "/Library/Logs/DiagnosticReports/lantern_*"
  ]
end
