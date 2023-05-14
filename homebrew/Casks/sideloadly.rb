cask "sideloadly" do
  version "0.41.2"
  sha256 "7f58e922f1a882fc1d38818f82ed7c3bef4e9e4211a9f1adebe02ea2b2b963d8"

  url "https://sideloadly.io/SideloadlySetup.dmg"
  name "Sideloadly"
  desc "Sideload iOS apps without pain"
  homepage "https://sideloadly.io"

  app "Sideloadly.app"

  uninstall quit: "org.sideloadly.sideloadly"

  zap trash: [
    "~/Library/Application Support/CrashReporter/sideloadly_*",
    "~/Library/Application Support/sideloadly",
    "~/Library/Logs/sideloadly",
    "~/Library/Preferences/io.sideloadly.sideloadly.plist",
    "~/Library/Saved Application State/io.sideloadly.sideloadly.savedState",
    "~/Library/Application Support/Mail/Plug-ins/Bundles/Library/Mail/Bundles/SideloadlyPlugin.mailbundle",
    "/Library/Mail/Bundles/SideloadlyPlugin.mailbundle",
    "/Library/Logs/DiagnosticReports/Sideloadly_*"
  ]
end
