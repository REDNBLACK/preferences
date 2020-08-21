# Preferences

My shell and programms settings

### Installation

##### Essentials
1. Open Terminal

1. Download this repo

    ```bash
    git clone --depth=1 --shallow-submodules --recurse-submodules --remote-submodules https://github.com/REDNBLACK/preferences.git
    echo "export DOTPREFSDIR=$(cd preferences && pwd)" | sudo tee -a /etc/zshenv > /dev/null
    exec zsh
    ```
1. Setup [Homebrew](https://brew.sh)

    ```bash
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    brew analytics off        # Turn off analytics
    brew tap buo/cask-upgrade # Better Cask command
    brew install mas          # App Store via CLI
    ```
1. Setup [Git](https://git-scm.com) & [GitHub](https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token)

    ```bash
    brew install git
    ln -fs $DOTPREFSDIR/git ~/.config/git
    ```
1. Setup [Fira Code (+Nerd)](https://github.com/tonsky/FiraCode) & [Meslo Nerd](https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Meslo)

    ```bash
    brew cask install homebrew/cask-fonts/font-fira-code
    brew cask install homebrew/cask-fonts/font-fira-code-nerd-font
    brew cask install homebrew/cask-fonts/font-meslo-lg-nerd-font
    ```
1. Setup [zsh](http://zsh.org) & [oh my zsh](https://ohmyz.sh) & [PowerLevel10k](https://github.com/romkatv/powerlevel10k) & [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) & [zsh-fast-syntax-highlighting](https://github.com/zdharma/fast-syntax-highlighting)

    ```bash
    brew install zsh
    ln -fs $DOTPREFSDIR/zsh ~/.config/zsh
    echo "export ZDOTDIR=$HOME/.config/zsh" | sudo tee -a /etc/zshenv > /dev/null

    # Set as default shell
    which zsh | sudo tee -a /etc/shells > /dev/null
    chsh -s $(which zsh)

    # Set as default shell (alternative)
    sudo dscl . -create ~ UserShell $(which zsh)
    ```
1. Setup [iTerm](https://iterm2.com)

    ```bash
    brew cask install iterm2
    ln -fs $DOTPREFSDIR/iterm2/conf.plist ~/Library/Preferences/com.googlecode.iterm2.plist
    ```
1. Setup Tools

    ```bash
    brew install nnn
    brew install jq
    brew install tldr

    # thefuck (https://github.com/nvbn/thefuck)
    # if command -v thefuck &> /dev/null; then
    #   eval "$(thefuck --alias)"
    # fi
    # brew install thefuck
    ```

##### Coding
1. Setup [Sublime Text 3](https://sublimetext.com/3)

    ```bash
    brew cask install sublime-text
    ln -fs $DOTPREFSDIR/sublime-text3/conf ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User
    curl -SsL "https://packagecontrol.io/Package%20Control.sublime-package" > ~/Library/Application\ Support/Sublime\ Text\ 3/Installed\ Packages/Package\ Control.sublime-package
    defaults write com.apple.LaunchServices/com.apple.launchservices.secure LSHandlers -array-add \
    '{LSHandlerContentType=public.plain-text;LSHandlerRoleAll=com.sublimetext.3;}'
    ```
1. Setup [Java OpenJDK](https://adoptopenjdk.net) & [GraalVM](https://graalvm.org)

    ```bash
    brew cask install adoptopenjdk/openjdk/adoptopenjdk8
    brew cask install adoptopenjdk/openjdk/adoptopenjdk14
    brew cask install graalvm/tap/graalvm-ce-java11

    # Switch jdk version to `1.8` or `14` or `graal`
    jdk 1.8
    ```
1. 💰 Setup [IntelliJ Idea](https://jetbrains.com/idea)

    ```bash
    brew cask install jetbrains-toolbox
    ```
1. 💰 Setup [Paw](https://paw.cloud)

    ```bash
    brew cask install paw
    ```
1. Setup [Docker](https://github.com/docker/for-mac)

    ```bash
    brew cask install docker
    ```
1. Setup [ngrok](https://ngrok.com)

    ```bash
    brew cask install ngrok
    ```
1. Setup [Postgres App](https://github.com/PostgresApp/PostgresApp)

    ```bash
    brew cask install postgres
    ```

##### Productivity
1. Setup [Cheatsheet](https://cheatsheetapp.com/CheatSheet)

    ```bash
    brew cask install cheatsheet
    defaults import com.mediaatelier.CheatSheet $DOTPREFSDIR/cheatsheet/conf.plist
    ```
1. 💰 Setup [BetterTouchTool](https://folivora.ai)

    ```bash
    brew cask install bettertouchtool
    defaults import com.hegenberg.BetterTouchTool $DOTPREFSDIR/btt/conf.plist

    # Install license
    cp -f "**Path to license.bettertouchtool file**" ~/Library/Application\ Support/BetterTouchTool/bettertouchtool.bttlicense
    ```
1. ~~Setup [Maccy](https://github.com/p0deje/Maccy)~~ (Superseded by [BetterTouchTool](#Productivity))

    ```bash
    # brew cask install maccy
    # defaults import org.p0deje.Maccy $DOTPREFSDIR/maccy/conf.plist
    ```
1. ~~Setup [Rectangle](https://github.com/rxhanson/Rectangle)~~ (Superseded by [BetterTouchTool](#Productivity))

    ```bash
    # brew cask install rectangle
    # defaults import com.knollsoft.Rectangle $DOTPREFSDIR/rectangle/conf.plist
    ```
1. ~~Setup [HapticKey](https://github.com/niw/HapticKey)~~ (Superseded by [BetterTouchTool](#Productivity))

    ```bash
    # brew cask install haptickey
    # defaults import at.niw.HapticKey $DOTPREFSDIR/haptickey/conf.plist
    ```
1. ~~Setup [Pock](https://github.com/pigigaldi/Pock)~~ (Superseded by [BetterTouchTool](#Productivity))

    ```bash
    # brew cask install pock
    # defaults import com.pigigaldi.pock $DOTPREFSDIR/pock/conf.plist

    # Hide system Dock
    # . $DOTPREFSDIR/pock/hide-dock.zsh apply
    ```
1. ~~Setup [Flow](https://flowapp.info)~~ (Superseded by [BetterTouchTool](#Productivity))

    ```bash
    # mas install 1423210932
    ```

##### System
1. 💰 Setup [iStat Menus](https://bjango.com/mac/istatmenus)

    ```bash
    brew cask install istat-menus
    defaults import com.bjango.istatmenus6.extras $DOTPREFSDIR/istat-menus/conf.plist

    # Install license
    defaults write com.bjango.istatmenus license6 -dict email '**License email**' serial '**License serial key**'
    ```
1. Setup [Amphetamine](https://apps.apple.com/app/id937984704) & [Amphetamine Enhancer](https://github.com/x74353/Amphetamine-Enhancer)

    ```bash
    mas install 937984704

    cd ~/Library/Containers/com.if.Amphetamine/Data/Library/Application\ Support
    hdiutil attach -nobrowse -quiet "https://github.com/x74353/Amphetamine-Enhancer/raw/master/Releases/Current/Amphetamine%20Enhancer.dmg"
    cp -rf /Volumes/Amphetamine\ Enhancer/*.app ./
    hdiutil detach -quiet /Volumes/Amphetamine\ Enhancer
    sed -r -i '' -e "s#/Applications/Amphetamine\\\? Enhancer.app#~/Library/Containers/com.if.Amphetamine/Data/Library/Application' 'Support/Amphetamine' 'Enhancer.app#g" Amphetamine\ Enhancer.app/**/*.(sh|plist)
    ```
1. Setup [Keka](https://github.com/aonez/Keka)

    ```bash
    brew cask install keka kekadefaultapp
    defaults import com.aone.keka $DOTPREFSDIR/keka/conf.plist
    ```
1. Setup [AppCleaner](https://freemacsoft.net/appcleaner)

    ```bash
    brew cask install appcleaner
    ```
1. Setup [Clean Me](https://github.com/Kevin-De-Koninck/Clean-Me)

    ```bash
    brew cask install clean-me
    ```
1. Setup [OnyX](https://www.titanium-software.fr/en/onyx.html)

    ```bash
    brew cask install onyx
    ```
1. 💰 Setup [Apple Remote Desktop](https://apps.apple.com/app/id409907375)

    ```bash
    mas install 409907375
    ```

##### Security
1. 💰 Setup [1Password](https://1password.com)

    ```bash
    # 6.8.8 Not in AppStore or Brew Cask
    ```
1. Setup [Gas Mask](https://github.com/2ndalpha/gasmask)

    ```bash
    brew cask install gas-mask
    ```

##### Network
1. Setup [Telegram](https://github.com/telegramdesktop/tdesktop)

    ```bash
    brew cask install telegram
    ```
1. Setup [Slack](https://slack.com)

    ```bash
    brew cask install slack
    ```
1. Setup [Google Chrome](https://google.com/chrome)

    ```bash
    brew cask install google-chrome

    # Disable auto update
    . $DOTPREFSDIR/chrome/disable-updates.zsh
    ```
1. Setup [Tor](https://github.com/TheTorProject)

    ```bash
    brew cask install tor-browser
    ```
1. Setup [Transmission](https://github.com/transmission/transmission)

    ```bash
    brew cask install transmission
    ```
1. Setup [Wi-Fi Explorer](https://intuitibits.com/products/wifi-explorer)

    ```bash
    brew cask install wifi-explorer
    ```

##### Entertainment
1. 💰 Setup [Spotify](https://spotify.com)

    ```bash
    brew cask install spotify
    ```
1. 💰 Setup [Air Server](https://airserver.com/Mac)

    ```bash
    brew cask install airserver
    ```
1. ~~Setup [Helium Lift](https://apps.apple.com/app/id1018899653)~~ (Superseded by [BetterTouchTool](#Productivity))

    ```bash
    # mas install 1018899653
    ```

1. Setup [Picktorial](https://apps.apple.com/app/id1043289526)

    ```bash
    mas install 1043289526
    ```
1. Setup [Pocket](https://apps.apple.com/app/id568494494)

    ```bash
    mas install 568494494
    ```
1. 💰 Setup [Noizio](https://apps.apple.com/app/id928871589)

    ```bash
    mas install 928871589
    ```

#### Core

```bash
# Enable sudo auth via Touch ID
sudo sed -i '.old' -e '2s;^;auth       sufficient     pam_tid.so\n;' /etc/pam.d/sudo
# Show Library folder
chflags nohidden ~/Library
# Show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true
# Show path bar
defaults write com.apple.finder ShowPathbar -bool true
# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true
```
