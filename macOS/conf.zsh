#!/bin/zsh
emulate -LR zsh

# ====================================================================================== #
#                          macOS configuration                                           #
#                                                                                        #
#  - General                                                                             #
#  - Finder                                                                              #
# ====================================================================================== #
print_info "Configuring macOS..."


# ====================================================================================== #
#                          General                                                       #
# ====================================================================================== #
# Menu Bar and Dock color
defaults write -g AppleInterfaceStyle -string 'Dark'

# Small Sidebar icon size
defaults write -g NSTableViewDefaultSizeMode -int 1

# Ask to keep changes when closing documents
defaults write -g NSCloseAlwaysConfirmsChanges -bool true

# Close windows when quitting an app
defaults write -g NSQuitAlwaysKeepsWindows -bool false

# Prefer tabs when opening documents
defaults write -g AppleWindowTabbingMode -string 'always'

# Show hidden files
defaults write -g AppleShowAllFiles -bool true

# Show all file extensions
defaults write -g AppleShowAllExtensions -bool true

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
defaults write com.apple.finder QuitMenuItem -bool true

# Show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true
# ====================================================================================== #
