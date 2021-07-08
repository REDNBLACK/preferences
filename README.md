# Preferences

My shell and programms settings

### Installation

##### Essentials
1. Open Terminal

2. Download this repo

    ```zsh
    git clone --depth=1 --shallow-submodules --recurse-submodules --remote-submodules https://github.com/REDNBLACK/preferences.git Preferences
    echo "export DOTPREFSDIR=$(cd Preferences && pwd)" | sudo tee -a /etc/zshenv > /dev/null
    exec zsh
    ```
3. Setup [Homebrew](https://brew.sh) & [mas-cli](https://github.com/mas-cli/mas) & [cask-upgrade](https://github.com/buo/homebrew-cask-upgrade)

    ```zsh
    zsh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    brew analytics off
    brew tap buo/cask-upgrade
    brew install mas

    # Symlink custom Casks
    mkdir -p /usr/local/Homebrew/Library/Taps/custom && ln -fs $DOTPREFSDIR/homebrew "$_/homebrew-custom"
    ```
4. Setup [Git](https://git-scm.com) & [GitHub](https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token)

    ```zsh
    brew install git
    ln -fs $DOTPREFSDIR/git ~/.config/git
    ```
5. Setup [Fira Code (+Nerd)](https://github.com/tonsky/FiraCode) & [Meslo Nerd](https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Meslo)

    ```zsh
    brew install --cask homebrew/cask-fonts/font-fira-code
    brew install --cask homebrew/cask-fonts/font-fira-code-nerd-font
    brew install --cask homebrew/cask-fonts/font-meslo-lg-nerd-font
    ```
6. Setup [zsh](http://zsh.org) & [oh my zsh](https://ohmyz.sh) & [PowerLevel10k](https://github.com/romkatv/powerlevel10k) & [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) & [zsh-fast-syntax-highlighting](https://github.com/zdharma/fast-syntax-highlighting)

    ```zsh
    brew install zsh # ⚠️ Command may be skipped in case of actual preinstalled zsh version
    ln -fs $DOTPREFSDIR/zsh ~/.config/zsh
    echo "export ZDOTDIR=$HOME/.config/zsh" | sudo tee -a /etc/zshenv > /dev/null

    # Set as default shell ⚠️ Command may be skipped in case of actual preinstalled zsh version
    which zsh | sudo tee -a /etc/shells > /dev/null
    chsh -s $(which zsh)

    # Set as default shell (alternative) ⚠️ Command may be skipped in case of actual preinstalled zsh version
    sudo dscl . -create ~ UserShell $(which zsh)
    ```
7. Setup [iTerm](https://iterm2.com)

    ```zsh
    brew install --cask iterm2

    # Variant 1
    ln -fs $DOTPREFSDIR/iterm2/com.googlecode.iterm2.plist ~/Library/Preferences/com.googlecode.iterm2.plist

    # Variant 2
    defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool YES
    defaults write com.googlecode.iterm2 PrefsCustomFolder "$DOTPREFSDIR/iterm2"
    ```
8. Setup Tools

    ```zsh
    brew install lolercat --HEAD # ['cat' with rainbows!](https://github.com/jaseg/lolcat)
    brew install exa             # ['ls' on steroids](https://github.com/ogham/exa)
    brew install ripgrep         # ['grep' modern alternative](https://github.com/BurntSushi/ripgrep)
    brew install tldr --HEAD     # ['man' in TL;DR variant](https://github.com/tldr-pages/tldr)

    # /Library/Developer/CommandLineTools/usr/bin/python3

    brew install jq              # [Process JSON via CLI](https://github.com/stedolan/jq)
    brew install thefuck         # [Corrects errors in previous commands](https://github.com/nvbn/thefuck)
    brew install howdoi          # [Instant coding answers](https://github.com/gleitz/howdoi)
    ```
9. Setup macOS

    ```zsh
    . $DOTPREFSDIR/macOS/conf.zsh
    ```

##### Security
1. 💰 Setup [1Password](https://1password.com)

    ```zsh
    brew install --cask 1password

    # Install license
    cp -f "**Path to 1Password 7 License.onepassword7-license-mac**" ~/Library/Group\ Containers/2BUA8C4S2C.com.agilebits/License/1Password\ 7\ License.onepassword7-license-mac
    ```
2. Setup [DNS over HTTPS](https://github.com/paulmillr/encrypted-dns)

    *
        ```zsh
        # ⚠️ Set config to `cloudflare-https` or other config name from repo
        curl -LSs -o 'DoH.mobileconfig' "https://raw.githubusercontent.com/paulmillr/encrypted-dns/master/${config}.mobileconfig" && \
        open -a ProfileHelper DoH.mobileconfig && \
        open "x-apple.systempreferences:com.apple.preferences.configurationprofiles"
        ```
    * In the Profiles window press 'Install...'
    *
        ```zsh
        rm -f DoH.mobileconfig
        ```
3. 💰❔ Setup [NextDNS](https://nextdns.io)

    *
        ```zsh
        # ⚠️ Set `id`, `name`, `model` to desired values before running.
        curl -GLSs -o 'NextDNS.mobileconfig' 'https://api.nextdns.io/apple/profile' \
          -d "configuration=${id}" \
          --data-urlencode "device_name=${name}" \
          --data-urlencode "device_model=${model}" \
          -d "sign=${sign:-0}" \
          -d "trust_ca=${trust:-0}" \
          -d "bootstrap_ips=${bootstrap:-0}" \
          -d "prohibit_disablement=${supervised:-0}" && \
        open -a ProfileHelper NextDNS.mobileconfig && \
        open "x-apple.systempreferences:com.apple.preferences.configurationprofiles"
        ```
    * In the Profiles window press 'Install...'
    *
        ```zsh
        rm -f NextDNS.mobileconfig
        ```
4. Setup [rage](https://github.com/str4d/rage)

    ```zsh
    brew tap str4d.xyz/rage https://str4d.xyz/rage
    brew install rage
    ```
5. Setup misc

    ```zsh
    # Enable sudo auth via Touch ID (⚠️ Must be done after every system update)
    sudo sed -i '.old' -e '2s;^;auth       sufficient     pam_tid.so\n;' /etc/pam.d/sudo

    # Allow applications downloaded from anywhere
    sudo spctl --master-disable
    ```

##### Development
1. 💰❔ Setup [Sublime Text 4](https://sublimetext.com)

    ```zsh
    brew install --cask sublime-text
    ln -fs $DOTPREFSDIR/sublime-text/conf ~/Library/Application\ Support/Sublime\ Text/Packages/User
    curl -LSs -o ~/Library/Application\ Support/Sublime\ Text/Installed\ Packages/Package\ Control.sublime-package 'https://packagecontrol.io/Package%20Control.sublime-package'

    # Install license
    cp -f "**Path to License.sublime_license file**" ~/Library/Application\ Support/Sublime\ Text/Local/License.sublime_license

    # Set file association
    . $DOTPREFSDIR/sublime-text/file-assoc.zsh
    ```
2. 💰❔ Setup [JetBrains Toolbox](https://jetbrains.com/idea)

    ```zsh
    brew install --cask jetbrains-toolbox
    ln -fs $DOTPREFSDIR/jb-toolbox/conf.json ~/Library/Application\ Support/JetBrains/Toolbox/.settings.json
    ```
3. Setup [Docker](https://docs.docker.com/docker-for-mac)

    ```zsh
    brew install --cask docker
    ```
4. Setup [HELM](https://helm.sh)

    ```zsh
    brew install helm
    ```
5. Setup Java [OpenJDK](https://adoptopenjdk.net) & [GraalVM](https://graalvm.org) & [JMC](https://oracle.com/java/technologies/jdk-mission-control.html)

    ```zsh
    brew install --cask adoptopenjdk/openjdk/adoptopenjdk8
    brew install --cask adoptopenjdk/openjdk/adoptopenjdk16
    brew install --cask graalvm/tap/graalvm-ce-java11

    brew install --cask jdk-mission-control

    # Switch JDK version to `1.8` or `8` or `16` or `graal`
    jdk 16
    ```
6. Setup [Postgres App](https://github.com/PostgresApp/PostgresApp)

    ```zsh
    brew install --cask postgres
    ```
7. 💰 Setup [Paw](https://paw.cloud)

    ```zsh
    brew install --cask paw
    ```
8. Setup [ngrok](https://ngrok.com)

    ```zsh
    brew install --cask ngrok
    ```

##### Productivity
1. Setup [Cheatsheet](https://cheatsheetapp.com/CheatSheet)

    ```zsh
    brew install --cask cheatsheet
    defaults import com.mediaatelier.CheatSheet $DOTPREFSDIR/cheatsheet/conf.plist
    ```
2. 💰 Setup [BetterTouchTool](https://folivora.ai)

    ```zsh
    brew install --cask bettertouchtool
    defaults import com.hegenberg.BetterTouchTool $DOTPREFSDIR/btt/conf.plist

    # Install license
    cp -f "**Path to license.bettertouchtool file**" ~/Library/Application\ Support/BetterTouchTool/bettertouchtool.bttlicense
    ```
3. ~~Setup [Maccy](https://github.com/p0deje/Maccy)~~ (Superseded by [BetterTouchTool](#Productivity))

    ```zsh
    # brew install --cask maccy
    # defaults import org.p0deje.Maccy $DOTPREFSDIR/maccy/conf.plist
    ```
4. ~~Setup [Rectangle](https://github.com/rxhanson/Rectangle)~~ (Superseded by [BetterTouchTool](#Productivity))

    ```zsh
    # brew install --cask rectangle
    # defaults import com.knollsoft.Rectangle $DOTPREFSDIR/rectangle/conf.plist
    ```
5. ~~Setup [HapticKey](https://github.com/niw/HapticKey)~~ (Superseded by [BetterTouchTool](#Productivity))

    ```zsh
    # brew install --cask haptickey
    # defaults import at.niw.HapticKey $DOTPREFSDIR/haptickey/conf.plist
    ```
6. ~~Setup [Pock](https://github.com/pigigaldi/Pock)~~ (Superseded by [BetterTouchTool](#Productivity))

    ```zsh
    # brew install --cask pock
    # defaults import com.pigigaldi.pock $DOTPREFSDIR/pock/conf.plist

    # Hide system Dock
    # . $DOTPREFSDIR/pock/hide-dock.zsh apply
    ```
7. ~~Setup [Flow](https://flowapp.info)~~ (Superseded by [BetterTouchTool](#Productivity))

    ```zsh
    # mas install 1423210932
    ```

##### System
1. 💰 Setup [iStat Menus](https://bjango.com/mac/istatmenus)

    ```zsh
    brew install --cask istat-menus
    defaults import com.bjango.istatmenus6.extras $DOTPREFSDIR/istat-menus/conf.plist

    # Install license
    defaults write com.bjango.istatmenus license6 -dict email '**License email**' serial '**License serial key**'
    ```
2. Setup [Keka](https://github.com/aonez/Keka)

    ```zsh
    brew install --cask keka
    defaults import com.aone.keka $DOTPREFSDIR/keka/conf.plist

    # Set file association (Without using kekadefaultapp)
    . $DOTPREFSDIR/keka/file-assoc.zsh
    ```
3. 💰❔ Setup [ForkLift](https://binarynights.com)

    ```zsh
    brew install --cask forklift
    defaults import com.binarynights.ForkLift-3 $DOTPREFSDIR/forklift/conf.plist

    # Set as default file viewer
    defaults write -g NSFileViewer -string com.binarynights.ForkLift-3
    defaults write com.apple.LaunchServices/com.apple.launchservices.secure LSHandlers -array-add '{LSHandlerContentType="public.folder";LSHandlerRoleAll="com.binarynights.ForkLift-3";}'
    ```
4. Setup [OnyX](https://titanium-software.fr/en/onyx)

    ```zsh
    brew install --cask onyx
    ```
5. 💰 Setup [Apple Remote Desktop](https://apps.apple.com/app/id409907375)

    ```zsh
    mas install 409907375
    ```
6. ~~Setup [Clean Me](https://github.com/Kevin-De-Koninck/Clean-Me)~~ (Abandoned)

    ```zsh
    # brew install --cask clean-me
    ```
7. ~~Setup [Amphetamine](https://apps.apple.com/app/id937984704) & [Amphetamine Enhancer](https://github.com/x74353/Amphetamine-Enhancer)~~ (Superseded by [caffeinate](https://ss64.com/osx/caffeinate.html))

    ```zsh
    # mas install 937984704
    ```

##### Network
1. Setup [grpcurl](https://github.com/fullstorydev/grpcurl)

    ```zsh
    brew install grpcurl
    ```
2. Setup [Sidekick Browser](https://meetsidekick.com)

    *
        ```zsh
        brew install --cask pushplaylabs-sidekick
        ```
    * Install [plugins, theme and StartPage search engine](/sidekick/plugins.md)
    * Import [uBlock Origin settings](/sidekick/ublock-settings.txt)
3. Setup [Tor](https://github.com/TheTorProject)

    ```zsh
    brew install --cask tor-browser
    ```
4. Setup [Transmission](https://github.com/transmission/transmission)

    ```zsh
    brew install --cask transmission
    defaults import org.m0k.transmission $DOTPREFSDIR/transmission/conf.plist
    ```
5. Setup [Wi-Fi Explorer](https://intuitibits.com/products/wifi-explorer)

    ```zsh
    brew install --cask wifi-explorer
    ```

##### Social
1. Setup [Telegram](https://github.com/telegramdesktop/tdesktop)

    ```zsh
    brew install --cask telegram
    ```
2. Setup [Slack](https://slack.com)

    ```zsh
    brew install --cask slack
    ```
3. Setup [Zoom](https://zoom.us)

    ```zsh
    brew install --cask zoom
    ```
4. 💰 Setup [ProtonMail Bridge](https://protonmail.com/bridge)

    ```zsh
    brew install --cask protonmail-bridge
    ```

##### Entertainment
1. 💰❔ Setup [Spotify](https://spotify.com)

    ```zsh
    brew install --cask spotify
    ```
2. 💰 Setup [Air Server](https://airserver.com/Mac)

    ```zsh
    brew install --cask airserver
    ```
3. Setup [HandBrake](https://handbrake.fr)

    ```zsh
    brew install --cask handbrake
    ```
4. Setup [Picktorial](https://apps.apple.com/app/id1043289526)

    ```zsh
    mas install 1043289526
    ```
5. Setup [Abyss](https://apps.apple.com/app/id1507396839)

    ```zsh
    mas install 1507396839
    ```
6. 💰 Setup [Noizio](https://apps.apple.com/app/id928871589)

    ```zsh
    mas install 928871589
    ```
7. Setup [Touchbar Nyan Cat](https://github.com/avatsaev/touchbar_nyancat)

    ```zsh
    brew install --cask touchbar-nyancat
    ```
8. ~~Setup [Helium Lift](https://apps.apple.com/app/id1018899653)~~ (Superseded by [BetterTouchTool](#Productivity))

    ```zsh
    # mas install 1018899653
    ```

##### Mobile
1. Setup [Apple Configurator 2](https://support.apple.com/guide/apple-configurator-2/welcome/mac)

    ```zsh
    mas install 1037126344
    ```
2. Setup [AltServer](https://altstore.io)

    ```zsh
    brew install --cask altserver
    defaults import com.rileytestut.AltServer $DOTPREFSDIR/altserver/conf.plist
    ```
3. 💰 Setup [WALTR PRO](https://softorino.com/waltr)

    ```zsh
    brew install --cask waltr-pro
    defaults import com.softorino.waltrpro $DOTPREFSDIR/waltr/conf.plist

    # ~/Library/Application\ Support/WALTR\ PRO/.alticense && /Users/Shared/WALTR PRO/.alticense
    ```
