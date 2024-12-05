cask "sideloadly" do
  version "0.55.4"
  sha256 "d7ff06d3a83e61962b95dca87f93d6bf2333e33e34a86e351760278b33f3f8a7"

  url "https://sideloadly.io/SideloadlySetup.dmg"
  name "Sideloadly"
  desc "Sideload iOS apps without pain"
  homepage "https://sideloadly.io"

  app "Sideloadly.app"

  livecheck do
    url :url
    strategy :header_match
  end

  uninstall launchctl: "io.sideloadly.daemon",
            quit:      [
              "io.sideloadly.sideloadly",
              "com.apple.mail"
            ],
            delete:    [
              "~/Library/Application Support/Mail/Plug-ins/Bundles/Library/Mail/Bundles/SideloadlyPlugin.mailbundle",
              "/Library/Mail/Bundles/SideloadlyPlugin.mailbundle"
            ]

  zap trash: [
    "~/Library/Application Support/CrashReporter/sideloadly_*",
    "~/Library/Application Support/sideloadly",
    "~/Library/Caches/sideloadly",
    "~/Library/Logs/sideloadly",
    "~/Library/Preferences/io.sideloadly.sideloadly.plist",
    "~/Library/Saved Application State/io.sideloadly.sideloadly.savedState",
    "/Library/Logs/DiagnosticReports/Sideloadly_*"
  ]
end
