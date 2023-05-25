cask "sideloadly" do
  version "0.42.0"
  sha256 "24b4f4e06dfe9eb5cd87a8e3392fdf90255016a910cd51461582e56127d84b87"

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
