cask "ktalk" do
  version "2.6.1"
  sha256 "c4d20669773dc7aef6c26e7b22e48887e086837ae37312a2b9ea76e2b256acbb"

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
