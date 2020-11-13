# Preferences

My shell and programms settings

### Installation

##### Essentials
1. Open Terminal

2. Download this repo

    ```bash
    git clone --depth=1 --shallow-submodules --recurse-submodules --remote-submodules https://github.com/REDNBLACK/preferences.git
    echo "export DOTPREFSDIR=$(cd preferences && pwd)" | sudo tee -a /etc/zshenv > /dev/null
    exec zsh
    ```
3. Setup [Homebrew](https://brew.sh)

    ```bash
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    brew analytics off        # Turn off analytics
    brew tap buo/cask-upgrade # Install better "brew cask"
    brew install mas          # Install CLI for App Store
    ```
4. Setup [Git](https://git-scm.com) & [GitHub](https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token)

    ```bash
    brew install git
    ln -fs $DOTPREFSDIR/git ~/.config/git
    ```
5. Setup [Fira Code (+Nerd)](https://github.com/tonsky/FiraCode) & [Meslo Nerd](https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Meslo)

    ```bash
    brew cask install homebrew/cask-fonts/font-fira-code
    brew cask install homebrew/cask-fonts/font-fira-code-nerd-font
    brew cask install homebrew/cask-fonts/font-meslo-lg-nerd-font
    ```
6. Setup [zsh](http://zsh.org) & [oh my zsh](https://ohmyz.sh) & [PowerLevel10k](https://github.com/romkatv/powerlevel10k) & [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) & [zsh-fast-syntax-highlighting](https://github.com/zdharma/fast-syntax-highlighting)

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
7. Setup [iTerm](https://iterm2.com)

    ```bash
    brew cask install iterm2
    ln -fs $DOTPREFSDIR/iterm2/conf.plist ~/Library/Preferences/com.googlecode.iterm2.plist
    ```
8. Setup Tools

    ```bash
    brew install exa         # 'ls' on steroids
    brew install ripgrep     # Modern 'grep'
    brew install tldr --HEAD # TL;DR version of 'man'
    brew install nnn         # File Manager
    brew install jq          # CLI for JSON processing

    # https://github.com/gleitz/howdoi
    # brew install howdoi

    # https://github.com/nvbn/thefuck
    # brew install thefuck
    ```
9. Setup macOS

    ```bash
    . $DOTPREFSDIR/macOS/conf.zsh
    ```

##### Security
1. 💰 Setup [1Password](https://1password.com)

    ```bash
    # 6.8.8 Not in AppStore or Brew Cask
    ```
2. Setup [DNS over HTTPS](https://github.com/paulmillr/encrypted-dns)

    ```bash
    curl -OSsL "https://raw.githubusercontent.com/paulmillr/encrypted-dns/master/cloudflare-https.mobileconfig" && open -a ProfileHelper cloudflare-https.mobileconfig && open "x-apple.systempreferences:com.apple.preferences.configurationprofiles"
    rm -f cloudflare-https.mobileconfig
    ```
3. Setup [Gas Mask](https://github.com/2ndalpha/gasmask)

    ```bash
    brew cask install gas-mask
    ```
4. Setup misc

    ```bash
    # Enable sudo auth via Touch ID
    sudo sed -i '.old' -e '2s;^;auth       sufficient     pam_tid.so\n;' /etc/pam.d/sudo

    # Allow applications downloaded from anywhere
    sudo spctl --master-disable
    ```

##### Coding
1. Setup [Sublime Text 3](https://sublimetext.com/3)

    ```bash
    brew cask install sublime-text
    ln -fs $DOTPREFSDIR/sublime-text3/conf ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User
    curl -SsL "https://packagecontrol.io/Package%20Control.sublime-package" > ~/Library/Application\ Support/Sublime\ Text\ 3/Installed\ Packages/Package\ Control.sublime-package

    # Install license
    cp -f "**Path to License.sublime_license file**" ~/Library/Application\ Support/Sublime\ Text\ 3/Local/License.sublime_license

    # Set file association
    . $DOTPREFSDIR/sublime-text3/file-assoc.zsh
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

##### Productivity
1. Setup [Cheatsheet](https://cheatsheetapp.com/CheatSheet)

    ```bash
    brew cask install cheatsheet
    defaults import com.mediaatelier.CheatSheet $DOTPREFSDIR/cheatsheet/conf.plist
    ```
2. 💰 Setup [BetterTouchTool](https://folivora.ai)

    ```bash
    brew cask install bettertouchtool
    defaults import com.hegenberg.BetterTouchTool $DOTPREFSDIR/btt/conf.plist

    # Install license
    cp -f "**Path to license.bettertouchtool file**" ~/Library/Application\ Support/BetterTouchTool/bettertouchtool.bttlicense
    ```
3. ~~Setup [Maccy](https://github.com/p0deje/Maccy)~~ (Superseded by [BetterTouchTool](#Productivity))

    ```bash
    # brew cask install maccy
    # defaults import org.p0deje.Maccy $DOTPREFSDIR/maccy/conf.plist
    ```
4. ~~Setup [Rectangle](https://github.com/rxhanson/Rectangle)~~ (Superseded by [BetterTouchTool](#Productivity))

    ```bash
    # brew cask install rectangle
    # defaults import com.knollsoft.Rectangle $DOTPREFSDIR/rectangle/conf.plist
    ```
5. ~~Setup [HapticKey](https://github.com/niw/HapticKey)~~ (Superseded by [BetterTouchTool](#Productivity))

    ```bash
    # brew cask install haptickey
    # defaults import at.niw.HapticKey $DOTPREFSDIR/haptickey/conf.plist
    ```
6. ~~Setup [Pock](https://github.com/pigigaldi/Pock)~~ (Superseded by [BetterTouchTool](#Productivity))

    ```bash
    # brew cask install pock
    # defaults import com.pigigaldi.pock $DOTPREFSDIR/pock/conf.plist

    # Hide system Dock
    # . $DOTPREFSDIR/pock/hide-dock.zsh apply
    ```
7. ~~Setup [Flow](https://flowapp.info)~~ (Superseded by [BetterTouchTool](#Productivity))

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
2. Setup [Amphetamine](https://apps.apple.com/app/id937984704) & [Amphetamine Enhancer](https://github.com/x74353/Amphetamine-Enhancer)

    ```bash
    mas install 937984704

    # cd ~/Library/Containers/com.if.Amphetamine/Data/Library/Application\ Support
    # hdiutil attach -nobrowse -quiet "https://github.com/x74353/Amphetamine-Enhancer/raw/master/Releases/Current/Amphetamine%20Enhancer.dmg"
    # cp -rf /Volumes/Amphetamine\ Enhancer/*.app ./
    # hdiutil detach -quiet /Volumes/Amphetamine\ Enhancer
    # sed -r -i '' -e "s#/Applications/Amphetamine\\\? Enhancer.app#~/Library/Containers/com.if.Amphetamine/Data/Library/Application' 'Support/Amphetamine' 'Enhancer.app#g" Amphetamine\ Enhancer.app/**/*.(sh|plist)
    ```
3. Setup [Keka](https://github.com/aonez/Keka)

    ```bash
    brew cask install keka
    defaults import com.aone.keka $DOTPREFSDIR/keka/conf.plist

    # Set file association (Without using kekadefaultapp)
    . $DOTPREFSDIR/keka/file-assoc.zsh
    ```
4. Setup [AppCleaner](https://freemacsoft.net/appcleaner)

    ```bash
    brew cask install appcleaner
    ```
5. Setup [Clean Me](https://github.com/Kevin-De-Koninck/Clean-Me)

    ```bash
    brew cask install clean-me
    ```
6. Setup [OnyX](https://titanium-software.fr/en/onyx)

    ```bash
    brew cask install onyx
    ```
7. 💰 Setup [Apple Remote Desktop](https://apps.apple.com/app/id409907375)

    ```bash
    mas install 409907375
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
    . $DOTPREFSDIR/chrome/disable-auto-update.zsh

    # Disable built-in DNS
    defaults write com.google.Chrome BuiltInDnsClientEnabled -boolean false
    ```

    * Install [plugins, theme and StartPage search engine](/chrome/plugins.md)
    * Import [uBlock Origin settings](/chrome/ublock-settings.txt)
4. Setup [Tor](https://github.com/TheTorProject)

    ```bash
    brew cask install tor-browser
    ```
5. Setup [Transmission](https://github.com/transmission/transmission)

    ```bash
    brew cask install transmission
    ```
6. Setup [Wi-Fi Explorer](https://intuitibits.com/products/wifi-explorer)

    ```bash
    brew cask install wifi-explorer
    ```

##### Entertainment
1. 💰 Setup [Spotify](https://spotify.com)

    ```bash
    brew cask install spotify
    ```
2. 💰 Setup [Air Server](https://airserver.com/Mac)

    ```bash
    brew cask install airserver
    ```
3. Setup [HandBrake](https://handbrake.fr)

    ```bash
    brew cask install handbrake
    ```
4. ~~Setup [Helium Lift](https://apps.apple.com/app/id1018899653)~~ (Superseded by [BetterTouchTool](#Productivity))

    ```bash
    # mas install 1018899653
    ```

5. Setup [Picktorial](https://apps.apple.com/app/id1043289526)

    ```bash
    mas install 1043289526
    ```
6. Setup [Abyss](https://apps.apple.com/app/id1507396839)

    ```bash
    mas install 1507396839
    ```
7. 💰 Setup [Noizio](https://apps.apple.com/app/id928871589)

    ```bash
    mas install 928871589
    ```
8. Setup [Touchbar Nyancat](https://github.com/avatsaev/touchbar_nyancat)

    ```bash
    curl -SsL "https://github.com/avatsaev/touchbar_nyancat/releases/download/0.0.2/touchbar_nyancat.app.zip" | tar -xf - -C /Applications/
    chmod -R 755 /Applications/touchbar_nyancat.app
    ```

##### Mobile
1. Setup [AltServer](https://altstore.io)

    ```bash
    brew cask install altserver
    ```
