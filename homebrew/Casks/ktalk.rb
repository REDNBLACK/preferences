cask "ktalk" do
  version "3.1.0"
  sha256 "dfb72c3efafc0ccb669fef45851b28c97c3a40780f4d1a67dc3003e4172cdef8"

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
