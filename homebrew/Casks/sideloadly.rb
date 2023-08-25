cask "sideloadly" do
  version "0.43.0"
  sha256 "d4102ed425d0ad0a7a6ccddd5efb31bc594c40e6f51c90edcc366950a9ef5628"

  url "https://sideloadly.io/SideloadlySetup.dmg"
  name "Sideloadly"
  desc "Sideload iOS apps without pain"
  homepage "https://sideloadly.io"

  app "Sideloadly.app"

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
    "~/Library/Logs/sideloadly",
    "~/Library/Preferences/io.sideloadly.sideloadly.plist",
    "~/Library/Saved Application State/io.sideloadly.sideloadly.savedState",
    "/Library/Logs/DiagnosticReports/Sideloadly_*"
  ]
end
