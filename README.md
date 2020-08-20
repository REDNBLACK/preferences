# Preferences

My shell and programms settings

### Installation

##### Essentials
1. Download this repo

    ```bash
    git clone --depth=1 --shallow-submodules --recurse-submodules --remote-submodules https://github.com/REDNBLACK/preferences.git
    export DOTPREFSDIR="$(cd preferences && pwd)" && launchctl setenv DOTPREFSDIR "$DOTPREFSDIR"
    ```
2. Setup [Homebrew](https://brew.sh)

    ```bash
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    brew analytics off        # Turn off analytics
    brew tap buo/cask-upgrade # Better Cask command
    brew install mas          # App Store via CLI
    ```
3. Setup [Git](https://git-scm.com) & [GitHub](https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token)

    ```bash
    brew install git
    ln -fs $DOTPREFSDIR/git ~/.config/git
    ```
4. Setup [Fira Code](https://github.com/tonsky/FiraCode)

    ```bash
    brew cask install homebrew/cask-fonts/font-fira-code
    ```
5. Setup [zsh](http://zsh.org) & [oh my zsh](https://ohmyz.sh) & [PowerLevel10k](https://github.com/romkatv/powerlevel10k) & [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) & [zsh-fast-syntax-highlighting](https://github.com/zdharma/fast-syntax-highlighting)

    ```bash
    brew install zsh
    ln -fs $DOTPREFSDIR/zsh ~/.config/zsh
    echo "export ZDOTDIR=$HOME/.config/zsh" | sudo tee /etc/zshenv > /dev/null

    # Set as default shell
    which zsh | sudo tee -a /etc/shells > /dev/null
    chsh -s $(which zsh)

    # Set as default shell (alternative)
    sudo dscl . -create ~ UserShell $(which zsh)
    ```
6. Setup [iTerm](https://iterm2.com)

    ```bash
    brew cask install iterm2
    ln -fs $DOTPREFSDIR/iterm2/conf.plist ~/Library/Preferences/com.googlecode.iterm2.plist
    ```
7. Setup Tools

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
2. Setup [Java OpenJDK](https://adoptopenjdk.net) & [GraalVM](https://graalvm.org)

    ```bash
    brew cask install adoptopenjdk/openjdk/adoptopenjdk8
    brew cask install adoptopenjdk/openjdk/adoptopenjdk14
    brew cask install graalvm/tap/graalvm-ce-java11

    # Switch jdk version to `1.8` or `14` or `graal`
    jdk 1.8
    ```
3. 💰 Setup [IntelliJ Idea](https://jetbrains.com/idea)

    ```bash
    brew cask install jetbrains-toolbox
    ```
4. 💰 Setup [Paw](https://paw.cloud)

    ```bash
    brew cask install paw
    ```
5. Setup [Docker](https://github.com/docker/for-mac)

    ```bash
    brew cask install docker
    ```
6. Setup [ngrok](https://ngrok.com)

    ```bash
    brew cask install ngrok
    ```
7. Setup [Postgres App](https://github.com/PostgresApp/PostgresApp)

    ```bash
    brew cask install postgres
    ```

##### System
1. Setup [Rectangle](https://github.com/rxhanson/Rectangle)

    ```bash
    brew cask install rectangle
    defaults import com.knollsoft.Rectangle $DOTPREFSDIR/rectangle/conf.plist
    ```
2. Setup [Maccy](https://github.com/p0deje/Maccy)

    ```bash
    brew cask install maccy
    defaults import org.p0deje.Maccy $DOTPREFSDIR/maccy/conf.plist
    ```
3. Setup [Pock](https://github.com/pigigaldi/Pock)

    ```bash
    brew cask install pock
    defaults import com.pigigaldi.pock $DOTPREFSDIR/pock/conf.plist

    # Hide Dock completely
    defaults write com.apple.dock autohide -bool true
    defaults write com.apple.dock autohide-delay -float 1000.0
    defaults write com.apple.dock no-bouncing -bool true
    killall Dock
    ```
4. Setup [Cheatsheet](https://cheatsheetapp.com/CheatSheet)

    ```bash
    brew cask install cheatsheet
    defaults import com.mediaatelier.CheatSheet $DOTPREFSDIR/cheatsheet/conf.plist
    ```
5. Setup [Amphetamine](https://apps.apple.com/app/amphetamine/id937984704) & [Amphetamine Enhancer](https://github.com/x74353/Amphetamine-Enhancer)

    ```bash
    mas install 937984704

    cd ~/Library/Containers/com.if.Amphetamine/Data/Library/Application\ Support
    hdiutil attach -nobrowse -quiet "https://github.com/x74353/Amphetamine-Enhancer/raw/master/Releases/Current/Amphetamine%20Enhancer.dmg"
    cp -rf /Volumes/Amphetamine\ Enhancer/*.app ./
    hdiutil detach -quiet /Volumes/Amphetamine\ Enhancer
    sed -r -i '' -e "s#/Applications/Amphetamine\\\? Enhancer.app#~/Library/Containers/com.if.Amphetamine/Data/Library/Application' 'Support/Amphetamine' 'Enhancer.app#g" Amphetamine\ Enhancer.app/**/*.(sh|plist)
    ```
6. Setup [Keka](https://github.com/aonez/Keka)

    ```bash
    brew cask install keka
    brew cask install kekadefaultapp
    defaults import com.aone.keka $DOTPREFSDIR/keka/conf.plist
    ```
7. 💰 Setup [BetterTouchTool](https://folivora.ai)

    ```bash
    brew cask install bettertouchtool
    ```
8. 💰 Setup [Haptic Touchbar](https://haptictouchbar.com)

    ```bash
    brew cask install haptic-touch-bar
    ```
9. 💰 Setup [iStat Menus](https://bjango.com/mac/istatmenus)

    ```bash
    brew cask install istat-menus # mas install 1319778037
    defaults import com.bjango.istatmenus6.extras $DOTPREFSDIR/istat-menus/conf.plist
    defaults write com.bjango.istatmenus license6 -dict email '**REDACTED**' serial '**REDACTED**'
    ```
10. 💰 Setup [Apple Remote Desktop](https://apps.apple.com/app/apple-remote-desktop/id409907375)

    ```bash
    mas install 409907375
    ```
11. 💰 Setup [CleanMyMac X](https://macpaw.com/cleanmymac)

    ```bash
    brew cask install cleanmymac
    ```
12. Setup [AppCleaner](https://freemacsoft.net/appcleaner)

    ```bash
    brew cask install appcleaner
    ```

##### Security
1. 💰 Setup [1Password](https://1password.com)

    ```bash
    # 6.8.8 Not in AppStore or Brew Cask
    ```
2. Setup [Gas Mask](https://github.com/2ndalpha/gasmask)

    ```bash
    brew cask install gas-mask
    ```

##### Network
1. Setup [Telegram](https://github.com/telegramdesktop/tdesktop)

    ```bash
    brew cask install telegram
    ```
2. Setup [Slack](https://slack.com)

    ```bash
    brew cask install slack
    ```
3. Setup [Google Chrome](https://google.com/chrome)

    ```bash
    brew cask install google-chrome

    # Disable auto update
    rm -rf /Applications/Google\ Chrome.app/Contents/Frameworks/Google\ Chrome\ Framework.framework/Versions/Current/Frameworks/KeystoneRegistration.framework
    rm -rf ~/Library/LaunchAgents/com.google.*.plist
    rm -rf ~/Library/Preferences/com.google.Keystone.*.plist
    rm -rf ~/Library/Google/
    ```
4. Setup [Tor](https://github.com/TheTorProject)

    ```bash
    brew cask install tor-browser
    ```
5. Setup [Transmission](https://github.com/transmission/transmission)

    ```bash
    brew cask install transmission
    ```

##### Entertainment
1. 💰 Setup [Spotify](https://spotify.com)

    ```bash
    brew cask install spotify
    ```
2. 💰 Setup [Air Server](https://www.airserver.com/Mac)

    ```bash
    brew cask install airserver
    ```
3. Setup [Helium Lift](https://apps.apple.com/app/heliumlift/id1018899653)

    ```bash
    mas install 1018899653
    ```
4. Setup [Picktorial](https://apps.apple.com/app/picktorial/id1043289526)

    ```bash
    mas install 1043289526
    ```
5. Setup [Pocket](https://apps.apple.com/app/pocket/id568494494)

    ```bash
    mas install 568494494
    ```
6. 💰 Setup [Noizio](https://apps.apple.com/app/noizio-focus-relax-sleep/id928871589)

    ```bash
    mas install 928871589
    ```

#### Core
https://mhmd.io/blog/04-2020/macsetup-devops/
http://www.drjackyl.de/how/to/2017/08/15/Set_Global_Environment_Variables_in_macOS_10.10_and_later.html

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
