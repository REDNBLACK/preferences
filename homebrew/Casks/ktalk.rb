cask "ktalk" do
  version "2.7.0"
  sha256 "1cfece5a0da07aabf235ce7ff5ad05ddad0c4215fc61d8b176d2be79553a5c38"

  url "https://app.ktalk.ru/system/dist/download/mac"
  name "Kontur Talk"
  desc "Video and audio conference of your organization"
  homepage "https://ktalk.ru/"

  livecheck do
    url "https://app.ktalk.ru/system/dist/download/mac"
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
