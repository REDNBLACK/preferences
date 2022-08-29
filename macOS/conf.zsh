#!/bin/zsh
emulate -LR zsh

# ====================================================================================== #
#                          macOS configuration                                           #
#                                                                                        #
#  - General                                                                             #
#  - Finder                                                                              #
# ====================================================================================== #
show -l "macOS" "Configuring..."


# ====================================================================================== #
#                          General                                                       #
# ====================================================================================== #
# Set computer name
scutil --set ComputerName "RB's YYYYY XXXX"
scutil --set HostName 'rb'
scutil --set LocalHostName 'rb'
defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string 'rb'

# Menu Bar and Dock color
defaults write -g AppleInterfaceStyle -string 'Dark'

# Small Sidebar icon size
defaults write -g NSTableViewDefaultSizeMode -int 1

# Ask to keep changes when closing documents
defaults write -g NSCloseAlwaysConfirmsChanges -bool true

# Close windows when quitting an app
defaults write -g NSQuitAlwaysKeepsWindows -bool false

# Disable the crash reporter
defaults write com.apple.CrashReporter DialogType -string "none"

# Prefer tabs when opening documents
defaults write -g AppleWindowTabbingMode -string 'always'

# Significantly improve the now rather slow animation in save dialogs.
defaults write -g NSWindowResizeTime .001

# Show hidden files
defaults write -g AppleShowAllFiles -bool true

# Show all file extensions
defaults write -g AppleShowAllExtensions -bool true

# Enable Tab in modal dialogs for all controls
defaults write -g AppleKeyboardUIMode -int 3

# Disable “natural” scrolling
defaults write -g com.apple.swipescrolldirection -bool false

# Disable automatic capitalization
defaults write -g NSAutomaticCapitalizationEnabled -bool false

# Disable smart dashes as they’re annoying when typing code
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false

# Disable automatic period substitution as it’s annoying when typing code
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable auto-correct
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false

# Disable smart quotes
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable smart dashes
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false

# Show Library folder
chflags nohidden ~/Library && xattr -d com.apple.FinderInfo ~/Library

# Show /Volumes folder
sudo chflags nohidden /Volumes
# ====================================================================================== #


# ====================================================================================== #
#                          Finder                                                        #
# ====================================================================================== #
# Open folders in tabs instead of new windows
defaults write com.apple.finder FinderSpawnTab -bool true

# Use list view in all windows by default
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Show 'Quit' menu item
# defaults write com.apple.finder QuitMenuItem -bool true

# Show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Disable window animations and Get Info animations
defaults write com.apple.finder DisableAllAnimations -bool true

# Display full POSIX path as window title.
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Avoids creation of .DS_Store and AppleDouble files on Network and USB Volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Enable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool true

# Disable Discrete GPU both when charging OR on battery
sudo pmset -a gpuswitch 0

# Disable backup While on Battery
# defaults write /Library/Preferences/com.apple.TimeMachine RequiresACPower -bool false
# ====================================================================================== #
