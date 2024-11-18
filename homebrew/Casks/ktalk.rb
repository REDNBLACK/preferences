cask "ktalk" do
  version "2.13.0"
  sha256 "24aef3978fa5bdf7822a585584bb6423527297ae84b3fc5970379fd51b3e16cd"

  url "https://app.ktalk.ru/system/dist/download/mac"
  name "Kontur Talk"
  desc "Video and audio conference of your organization"
  homepage "https://ktalk.ru/"

  livecheck do
    url :url
    strategy :header_match
  end

  app "Толк.app"

  uninstall quit:      "kontur.talk",
            launchctl: "kontur.talk"

  zap trash: [
    "~/Library/Application Support/ktalk",
    "~/Library/LaunchAgents/Толк.plist",
    "~/Library/Logs/ktalk",
    "~/Library/Preferences/kontur.talk.plist",
    "~/Library/Saved Application State/kontur.talk.savedState",
  ]
end
