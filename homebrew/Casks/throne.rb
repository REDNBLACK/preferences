cask "throne" do
  arch arm: "arm64", intel: "amd64"

  version "1.2.0-beta.1"
  sha256 arm:   "f9a6af4d5ca874b384fd9d4b78139cd3068ba2848658c8faf746403ccd86b01f",
         intel: "e13102debf093f0426cc27cda5e2c7b62df9a8327d18622a6e6215cecba22fc3"

  url "https://github.com/throneproj/Throne/releases/download/#{version}/Throne-#{version}-macos-#{arch}.zip"
  name "Throne"
  desc "Proxy Utility for macOS"
  homepage "https://throneproj.github.io"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  app "Throne/Throne.app", target: "Throne.app"

  preflight do
    system_command "xattr",
               args: ["-d", "com.apple.quarantine", "#{staged_path}/Throne/Throne.app"],
               sudo: false
  end

  postflight do
    set_ownership "#{appdir}/Throne.app/Contents/MacOS/ThroneCore", user: "root", group: "wheel"
    set_permissions "#{appdir}/Throne.app/Contents/MacOS/ThroneCore", "u+w"
  end

  uninstall_preflight do
    set_ownership "#{appdir}/Throne.app/Contents/MacOS/ThroneCore"
  end

  uninstall quit: "Throne"

  zap trash: [
    "~/Library/Preferences/Throne"
  ]
end
