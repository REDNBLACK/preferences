#!/bin/zsh
emulate -LR zsh

echo "Removing Google Keystone..."
rm -rf /Applications/Google\ Chrome.app/Contents/Frameworks/Google\ Chrome\ Framework.framework/Versions/Current/Frameworks/KeystoneRegistration.framework
rm -rf ~/Library/LaunchAgents/com.google.*.plist
rm -rf ~/Library/Preferences/com.google.Keystone.*.plist
rm -rf ~/Library/Google/
