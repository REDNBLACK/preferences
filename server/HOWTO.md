macOS Server Tools
=======================================
* * *


# Multicast DNS
Basically automated broadcast to macOS Bonjour for custom devices/sites.
Will execute and keep running many instances like this one:
`dns-sd -P homebridge _http._tcp . 80 homebridge.local 192.168.1.1:8581`

### Installation
`bin/osx-mdns`                -> `/Library/Scripts/`
`launch/osx.mdns.agent.plist` -> `/Library/LaunchDaemons/`

### Configuration
To add new entry, use: `sudo defaults write /Library/Preferences/osx.mdns.plist bind -dict ps5 '192.168.1.1:1935'`

After that, reload daemon with `sudo launchctl boot[strap|out] system /Library/LaunchDaemons/osx.mdns.agent.plist`

### Status and Debug
Install `brew install --cask bonjeff` to view all currently running Bonjour multicasts


# ENV Synchroniser
Parses global exported variables from profile/zshprofile etc., and loads them into `launchctl` envs

### Installation
`bin/osx-env-sync-gen`            -> `/Library/Scripts/`
`launch/osx.env-sync.agent.plist` -> `~/Library/LaunchAgents/`

### Configuration
Append `# SYS #` to the end of each variable declared in profile/* you want to,
  after that run `osx-env-sync-gen install` to generate `osx-env-sync` binary
