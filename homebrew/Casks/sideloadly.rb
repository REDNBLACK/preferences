cask "sideloadly" do
  version "0.60.0"
  sha256 "428d062af1ca819712fb12cb0ace25fa49c80d9735c73cda3cbaf09ffcd63212"

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
