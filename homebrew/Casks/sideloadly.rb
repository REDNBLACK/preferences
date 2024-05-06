cask "sideloadly" do
  version "0.50.1"
  sha256 "37de6a5b627e433623d6d082c7a1fa3e0b9d3f3e54519fe69b56c4ca01725f3c"

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
    "~/Library/Caches/sideloadly",
    "~/Library/Logs/sideloadly",
    "~/Library/Preferences/io.sideloadly.sideloadly.plist",
    "~/Library/Saved Application State/io.sideloadly.sideloadly.savedState",
    "/Library/Logs/DiagnosticReports/Sideloadly_*"
  ]
end
