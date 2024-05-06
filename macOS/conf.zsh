#!/bin/zsh
emulate -LR zsh

# ====================================================================================== #
#                          macOS configuration                                           #
#                                                                                        #
#  - General                                                                             #
#  - Finder                                                                              #
# ====================================================================================== #
show -l "macOS" "Configuring..."
# Ask for the administrator password upfront
sudo -v
# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2> /dev/null &


# ====================================================================================== #
#                          Identity                                                      #
# ====================================================================================== #
echo
if read -q CHOICE\?"${fg[blue]}Configure Identity Settings?${reset_color} y/n: "; then
  # Set Host Name
  reply=`hostname`
  vared -p "    ${fg[yellow]}Enter New Hostname:${reset_color} " -c reply
  scutil --set HostName ${reply}
  scutil --set LocalHostName ${reply}
  sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string ${reply}
  unset reply

  # Set Computer Name
  reply=`networksetup -getcomputername`
  vared -p "    ${fg[yellow]}Enter New Computer Name:${reset_color} " -c reply
  scutil --set ComputerName ${reply}
  unset reply

  # Set Login Text
  sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText 'Fuck Off, M8'
fi
unset CHOICE
# ====================================================================================== #


# ====================================================================================== #
#                          General                                                       #
# ====================================================================================== #
echo
if read -q CHOICE\?"${fg[blue]}Configure General Settings?${reset_color} y/n: "; then
  # Menu Bar and Dock color
  defaults write -g AppleInterfaceStyle -string 'Dark'
  defaults -currentHost write -g AppleInterfaceStyle -string 'Dark'

  # Set Highlight & Accent Color to 'Multicolor'
  defaults delete -g AppleAccentColor
  defaults delete -g AppleHighlightColor

  # Enable 'Allow wallpaper tinting in windows'
  defaults write -g AppleReduceDesktopTinting -bool false

  # Disable the over-the-top focus ring animation
  # defaults write -g NSUseAnimatedFocusRing -bool false

  # Small Sidebar icon size (2 - Medium)
  defaults write -g NSTableViewDefaultSizeMode -int 1

  # Ask to keep changes when closing documents
  defaults write -g NSCloseAlwaysConfirmsChanges -bool true

  # Close windows when quitting an app
  defaults write -g NSQuitAlwaysKeepsWindows -bool false

  # Expand save panel by default
  defaults write -g NSNavPanelExpandedStateForSaveMode -bool true

  # Expand print panel by default
  defaults write -g PMPrintingExpandedStateForPrint -bool true

  # Disable Font Smoothing (0: Off, 1: Light, 2: Medium, 3: Strong)
  # defaults write -g AppleFontSmoothing -int 0

  # Disable the crash reporter
  defaults write com.apple.CrashReporter DialogType -string "none"
  launchctl unload -w /System/Library/LaunchAgents/com.apple.ReportCrash.plist
  sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.ReportCrash.Root.plist

  # Set Help Viewer windows to non-floating mode
  defaults write com.apple.helpviewer DevMode -bool true

  # Disable the sound effects on boot
  sudo nvram SystemAudioVolume=" "

  # Disable system sounds
  defaults write -g com.apple.sound.uiaudio.enabled -bool false

  # Require password immediately after sleep or screen saver begins
  defaults write com.apple.screensaver askForPassword -int 1
  defaults write com.apple.screensaver askForPasswordDelay -int 0

  # Prefer tabs when opening documents
  defaults write -g AppleWindowTabbingMode -string 'always'

  # Show hidden files
  defaults write -g AppleShowAllFiles -bool true

  # Show all file extensions
  defaults write -g AppleShowAllExtensions -bool true

  # Show Library folder
  chflags nohidden ~/Library

  # Show /Volumes folder
  sudo chflags nohidden /Volumes

  # Avoids creation of .DS_Store and AppleDouble files on Network and USB Volumes
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
  defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

  # Prevent Time Machine from prompting to use new hard drives as backup volume
  defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

  # Save to disk instead of iCloud
  defaults write -g NSDocumentSaveNewDocumentsToCloud -bool false
fi
unset CHOICE
# ====================================================================================== #


# ====================================================================================== #
#                          Input & Lang                                                 #
# ====================================================================================== #
echo
if read -q CHOICE\?"${fg[blue]}Configure Input & Lang Settings?${reset_color} y/n: "; then
  # Enable Tab in modal dialogs for all controls
  defaults write -g AppleKeyboardUIMode -int 3

  # Always show scrollbars
  # Possible values: `WhenScrolling`, `Automatic` and `Always`
  defaults write -g AppleShowScrollBars -string 'Automatic'

  # Disable automatic capitalization
  defaults write -g NSAutomaticCapitalizationEnabled -bool false

  # Disable smart dashes as they’re annoying when typing code
  defaults write -g NSAutomaticDashSubstitutionEnabled -bool false

  # Disable automatic period substitution as it’s annoying when typing code
  defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false

  # Disable auto-correct
  defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
  defaults write -g WebAutomaticSpellingCorrectionEnabled -bool false
  defaults write -g NSSpellCheckerAutomaticallyIdentifiesLanguages -bool true

  # Disable smart quotes
  defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false

  # Disable smart dashes
  defaults write -g NSAutomaticDashSubstitutionEnabled -bool false

  # Allow Control + Command + Click to drag windows without title bar
  defaults write -g NSWindowShouldDragOnGesture -bool true

  # Keyboard -> Shortcuts -> Mission Control -> Mission Control: off
  # Doesn't work :(
  # defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 32 "{ enabled = 0; value = { parameters = (65535, 126, 8650752); type = 'standard'; }; }"
  # defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 34 "{ enabled = 0; value = { parameters = (65535, 126, 8781824); type = 'standard'; }; }

  # Keyboard -> Key Repeat: Fast
  defaults write -g KeyRepeat -int 2

  # Keyboard -> Delay Until Repeat: Short
  defaults write -g InitialKeyRepeat -int 15

  # Trackpad -> Disable 'Natural' scrolling
  defaults write -g com.apple.swipescrolldirection -bool false

  # Trackpad -> Enable 'Tap to Click'
  defaults write com.apple.AppleMultitouchTrackpad 'Clicking' -bool true

  # Set language and text formats (System Preferences → Language & Text)
  defaults write -g AppleLanguages -array 'en-US' 'ru-RU'
  defaults write -g AppleLocale -string 'en_US@rg=ruzzzz'
  defaults write -g AppleMetricUnits -bool true
  defaults write -g AppleMeasurementUnits -string 'Centimeters'
  defaults write -g AppleTemperatureUnit -string 'Celsius'
  defaults write -g AppleICUForce24HourTime -bool true
  defaults write -g AppleICUDateFormatStrings -dict 1 'y-MM-dd'
  defaults write -g AppleFirstWeekday -dict 'gregorian' 2
  defaults write -g AppleICUNumberSymbols -dict 0 "," 1 "." 10 "," 17 "."

  # Timezone Support active by default
  defaults write com.apple.iCal 'TimeZone support enabled' -bool true
  # Show Event Times
  defaults write com.apple.iCal 'Show time in Month View' -bool true
  # Show week numbers by default
  defaults write com.apple.iCal 'Show Week Numbers' -bool true
  # Birthdays on
  defaults write com.apple.iCal 'display birthdays calendar' -bool true
  # Use Last Selected Calendar as Default Calendar
  defaults write com.apple.iCal 'CalDefaultCalendar' -string 'UseLastSelectedAsDefaultCalendar'
  # Enable Notifications for Shared Calendars
  defaults write com.apple.iCal 'SharedCalendarNotificationsDisabled' -bool false
  # Enable Notifications for Declined Events
  defaults write com.apple.iCal 'InviteeDeclineAlerts' -bool true
fi
unset CHOICE
# ====================================================================================== #


# ====================================================================================== #
#                          Finder                                                        #
# ====================================================================================== #
echo
if read -q CHOICE\?"${fg[blue]}Configure Finder Settings?${reset_color} y/n: "; then
  # Open folders in tabs instead of new windows
  defaults write com.apple.finder FinderSpawnTab -bool true

  # Use list view in all windows by default
  defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

  # Keep folders on top when sorting by name
  defaults write com.apple.finder _FXSortFoldersFirst -bool true

  # When performing a search, search the current folder by default
  defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

  # Disable the warning when changing a file extension
  defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

  # Show 'Quit' menu item
  defaults write com.apple.finder QuitMenuItem -bool true

  # Show path bar
  defaults write com.apple.finder ShowPathbar -bool true

  # Show status bar
  defaults write com.apple.finder ShowStatusBar -bool true

  # Display full POSIX path as window title.
  defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

  # Enable the warning before emptying the Trash
  defaults write com.apple.finder WarnOnEmptyTrash -bool true

  # Allow text selection in Quick Look
  defaults write com.apple.finder QLEnableTextSelection -bool true

  # Hide recent tags
  defaults write com.apple.finder ShowRecentTags -bool false

  # Expand the following File Info panes:
  # “General”, “Open with”, and “Sharing & Permissions”
  # defaults write com.apple.finder FXInfoPanesExpanded -dict \
  #   General -bool true \
  #   OpenWith -bool true \
  #   Privileges -bool true

  # Show item info near icons on the desktop and in other icon views
  # /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
  # /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
  # /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist

  # Show item info to the right of the icons on the desktop
  # /usr/libexec/PlistBuddy -c "Set DesktopViewSettings:IconViewSettings:labelOnBottom false" ~/Library/Preferences/com.apple.finder.plist

  # Enable snap-to-grid for icons on the desktop and in other icon views
  # /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
  # /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
  # /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

  # Show icons for hard drives, servers, and removable media on the desktop
  defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
  defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
  defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
  defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
fi
unset CHOICE
# ====================================================================================== #


# ====================================================================================== #
#                          Dock, Stage Manager and Expose                                #
# ====================================================================================== #
echo
if read -q CHOICE\?"${fg[blue]}Configure Dock, Stage Manager & Expose Settings?${reset_color} y/n: "; then
  # Enable highlight hover effect for the grid view of a stack (Dock)
  defaults write com.apple.dock mouse-over-hilite-stack -bool true

  # Enable Launch Animation
  defaults write com.apple.dock launchanim -bool true

  # Set Hover effect to 'Genie'
  defaults write mineffect -string 'genie'

  # Disable magnification on hover
  defaults write com.apple.dock magnification -bool false

  # Minimize on double click (System Preferences → Dock)
  defaults write -g AppleMiniaturizeOnDoubleClick -bool false

  # Minimize windows into their application’s icon
  defaults write com.apple.dock minimize-to-application -bool false
  defaults write com.apple.dock single-app -bool true

  # Show Process Indicators in Dock
  defaults write com.apple.dock show-process-indicators -bool true

  # Disable Recent Programs in Dock
  defaults write com.apple.dock show-recents -bool false

  # Set Dock Position to Bottom
  defaults write com.apple.dock orientation -string 'bottom'

  # Disable Possibility to Edit Dock Items
  defaults write com.apple.dock position-immutable -bool true
  defaults write com.apple.dock autohide-immutable -bool true
  defaults write com.apple.dock minimize-to-application-immutable -bool true
  defaults write com.apple.dock size-immutable -bool true
  defaults write com.apple.dock contents-immutable -bool true
  defaults write com.apple.dock mineffect-immutable -bool true
  defaults write com.apple.dock magsize-immutable -bool true
  defaults write com.apple.dock magnify-immutable -bool true

  # Set the icon size of Dock items to 64 pixels and max zooming to 64 pixes
  defaults write com.apple.dock tilesize -float 64.0
  defaults write com.apple.dock largesize -float 64.0

  # Group windows by application in Mission Control
  defaults write com.apple.dock expose-group-by-app -bool true

  # Don’t automatically rearrange Spaces based on most recent use
  defaults write com.apple.dock mru-spaces -bool false

  # Automatically hide and show the Dock
  defaults write com.apple.dock autohide -bool true

  # Hide Dock Forever
  defaults write com.apple.dock autohide-delay -float 100000000

  # Disable AppExpose
  defaults write com.apple.dock showAppExposeGestureEnabled -bool false
fi
unset CHOICE
# ====================================================================================== #


# ====================================================================================== #
#                          System Tools                                                  #
# ====================================================================================== #
echo
if read -q CHOICE\?"${fg[blue]}Configure System Tools Settings?${reset_color} y/n: "; then
  # Show the main window when launching Activity Monitor
  defaults write com.apple.ActivityMonitor 'OpenMainWindow' -bool true

  # (5: Visualize CPU usage in the Activity Monitor Dock icon, 0: Simple App Icon)
  defaults write com.apple.ActivityMonitor 'IconType' -int 0

  # Show all processes (hierarchicaly) in Activity Monitor
  defaults write com.apple.ActivityMonitor 'ShowCategory' -int 101

  # Sort Activity Monitor results by CPU usage
  defaults write com.apple.ActivityMonitor 'SortColumn' -string 'CPUUsage'
  defaults write com.apple.ActivityMonitor 'SortDirection' -int 0

  # Enable the debug menu in Disk Utility
  defaults write com.apple.DiskUtility 'DUDebugMenuEnabled' -bool true
  defaults write com.apple.DiskUtility 'advanced-image-options' -bool true
fi
unset CHOICE
# ====================================================================================== #


# ====================================================================================== #
#                          Performance                                                   #
# ====================================================================================== #
echo
if read -q CHOICE\?"${fg[blue]}Configure Performance Settings?${reset_color} y/n: "; then
  # Disable Discrete GPU both when charging OR on battery (For MacBook before Apple M Silicone)
  # sudo pmset -a gpuswitch 0

  # Disable backup While on Battery
  sudo defaults write /Library/Preferences/com.apple.TimeMachine RequiresACPower -bool false

  # Significantly improve the now rather slow animation in save dialogs. (for Cocoa applications)
  defaults write -g NSWindowResizeTime -float 0.001

  # Adjust toolbar title rollover delay
  defaults write -g NSToolbarTitleViewRolloverDelay -float 0

  # Enable spring loading for directories
  defaults write -g com.apple.springing.enabled -bool true

  # Remove the spring loading delay for directories
  defaults write -g com.apple.springing.delay -float 0

  # Disable opening and closing window animations
  defaults write -g NSAutomaticWindowAnimationsEnabled -bool false

  # Finder: Disable window animations and Get Info animations
  defaults write com.apple.finder 'DisableAllAnimations' -bool true

  # Remove the animation when hiding/showing the Dock
  defaults write com.apple.dock 'autohide-time-modifier' -float 0

  # Enable spring loading for all Dock items
  defaults write com.apple.dock 'enable-spring-load-actions-on-all-items' -bool true

  # Speed up Mission Control animations
  defaults write com.apple.dock 'expose-animation-duration' -float 0.1

  # Restart automatically if the computer freezes
  sudo systemsetup -setrestartfreeze on

  # Never go into computer sleep mode
  sudo systemsetup -setcomputersleep Off > /dev/null
fi
unset CHOICE
# ====================================================================================== #
