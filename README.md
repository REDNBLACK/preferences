# Preferences

My shell and programms settings

### Map

* 💰 - Paid or trial app
* 🆓 - Free with conditions app
* :octocat: - Link to GitHub repo of app

### Installation

##### Essentials
1. Open Terminal

2. Download this repo

    ```zsh
    git clone --depth=1 --shallow-submodules --recurse-submodules --remote-submodules https://github.com/REDNBLACK/preferences.git Preferences
    echo "export DOTPREFSDIR=$(cd Preferences && pwd)" | sudo tee -a /etc/zshenv > /dev/null
    exec zsh
    ```
3. Setup [Homebrew](https://brew.sh) [[:octocat:](https://github.com/Homebrew)] & [mas-cli](https://github.com/mas-cli/mas) & [cask-upgrade](https://github.com/buo/homebrew-cask-upgrade)

    ```zsh
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew analytics off
    brew tap buo/cask-upgrade
    brew install mas

    # Symlink custom Casks
    mkdir -p $HOMEBREW_PREFIX/Homebrew/Library/Taps/custom && ln -fs $DOTPREFSDIR/homebrew "$_/homebrew-custom"
    ```
4. Setup [Git](https://git-scm.com) [[:octocat:](https://github.com/git/git)] & [GitHub](hhttps://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)

    ```zsh
    brew install git
    ln -fs $DOTPREFSDIR/git ~/.config/git

    # After generation of Personal Access Token
    security add-internet-password -s github.com -r htps -a %GitHub Account Name% -w %GitHub Account Token%
    ```
5. Setup [Fira Code (+Nerd)](https://github.com/tonsky/FiraCode) & [Meslo Nerd](https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Meslo)

    ```zsh
    brew install --cask homebrew/cask-fonts/font-{fira-code,fira-code-nerd-font,meslo-lg-nerd-font}
    ```
6. Setup [zsh](http://zsh.org) [[:octocat:](https://github.com/zsh-users)] & [zinit](https://zdharma.github.io/zinit/wiki/) [[:octocat:](https://github.com/zdharma/zinit)] & [PowerLevel10K](https://github.com/romkatv/powerlevel10k) & [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) & [zsh-fast-syntax-highlighting](https://github.com/zdharma/fast-syntax-highlighting)

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
7. Setup [iTerm](https://iterm2.com) [[:octocat:](https://github.com/gnachman/iTerm2)]

    ```zsh
    brew install --cask iterm2

    # Variant 1
    ln -fs $DOTPREFSDIR/iterm2/com.googlecode.iterm2.plist ~/Library/Preferences/com.googlecode.iterm2.plist

    # Variant 2
    defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool YES
    defaults write com.googlecode.iterm2 PrefsCustomFolder "$DOTPREFSDIR/iterm2"
    ```
8. Setup Tools
    * [`cat` with rainbows!](https://github.com/jaseg/lolcat)
        ```zsh
        brew install lolcat-c --HEAD
        ```
    * [`ls` on steroids](https://github.com/ogham/exa)
        ```zsh
        brew install exa
        ```
    * [`grep` modern alternative](https://github.com/BurntSushi/ripgrep) (depends on `pcre2`)
        ```zsh
        brew install ripgrep
        ```
    * [`man` in TL;DR variant](https://github.com/dbrgn/tealdeer)
        ```zsh
        brew install tealdeer
        ```
    * [Set files association](https://github.com/moretension/duti)
        ```zsh
        brew install duti
        ```
    * [Process JSON via CLI](https://github.com/stedolan/jq) (depends on `oniguruma`)
        ```zsh
        brew install jq
        ```
    * [Correct errors in previous commands](https://github.com/nvbn/thefuck) (depends on `python`)
        ```zsh
        brew install thefuck
        ```
    * [Instant coding answers](https://github.com/WindSoilder/hors)
        ```zsh
        brew install hors-org/hors/hors
        ```
9. Setup macOS

    ```zsh
    . $DOTPREFSDIR/macOS/conf.zsh
    ```

##### Security
1. [💰] Setup [Strongbox](https://strongboxsafe.com) [[:octocat:](https://github.com/strongbox-password-safe)]

    ```zsh
    mas install 1481853033
    ```
2. Setup [GPG Suite](https://gpgtools.org) [[:octocat:](https://github.com/GPGTools)]

    ```zsh
    brew install --cask gpg-suite-no-mail
    defaults write org.gpgtools.updater SUEnableAutomaticChecks -bool NO

    # Remove bloat
    sudo rm -rf /Library/PreferencePanes/GPGPreferences.prefPane && sudo rm -f /Library/LaunchAgents/org.gpgtools.{updater,macgpg2.fix,macgpg2.updater,Libmacgpg.xpc,gpgmail.*}.plist
    ```
3. Setup [DNS over HTTPS/TLS](https://github.com/paulmillr/encrypted-dns)
    * Set var `config` to config name from [repo](https://github.com/paulmillr/encrypted-dns/tree/master/profiles) (for example `cloudflare-https`)
    *
        ```zsh
        curl -LSs -o 'DoH.mobileconfig' "https://raw.githubusercontent.com/paulmillr/encrypted-dns/master/profiles/${config}.mobileconfig" && \
        open -a ProfileHelper DoH.mobileconfig && \
        open "x-apple.systempreferences:com.apple.preferences.configurationprofiles" && \
        rm DoH.mobileconfig
        ```
    * In the Profiles window press 'Install...'
4. [🆓] Setup [NextDNS](https://nextdns.io) [[:octocat:](https://github.com/nextdns)]
    * Set vars `id` - to your configuration id, `name` - to device name and `model` - to one of values from [here](https://apple.nextdns.io) (for example `Apple MacBookPro11,1`)
    *
        ```zsh
        curl -GLSs -o 'NextDNS.mobileconfig' 'https://api.nextdns.io/apple/profile' \
          -d "configuration=${id}" \
          --data-urlencode "device_name=${name}" \
          --data-urlencode "device_model=${model}" \
          -d "sign=${sign:-0}" \
          -d "trust_ca=${trust:-0}" \
          -d "bootstrap_ips=${bootstrap:-0}" \
          -d "prohibit_disablement=${supervised:-0}" && \
        open -a ProfileHelper NextDNS.mobileconfig && \
        open "x-apple.systempreferences:com.apple.preferences.configurationprofiles" && \
        rm NextDNS.mobileconfig
        ```
    * In the Profiles window press 'Install...'
    * OR
        ```zsh
        brew install nextdns/tap/nextdns
        ```
5. [🆓] Setup [Lantern](https://lantern.io) [[:octocat:](https://github.com/getlantern)]

    ```zsh
    brew install --cask lantern
    cp -f $DOTPREFSDIR/lantern/settings.yaml ~/Library/Application\ Support/Lantern/settings.yaml
    ```
6. [🆓] Setup [Proton VPN](https://protonvpn.com) [[:octocat:](https://github.com/ProtonVPN)]

    ```zsh
    brew install --cask protonvpn
    ```
7. Setup misc

    ```zsh
    # Enable sudo auth via Touch ID (⚠️ Must be done after every system update)
    sudo sed -i '.old' -e '2s;^;auth       sufficient     pam_tid.so\n;' /etc/pam.d/sudo

    # Allow applications downloaded from anywhere
    sudo spctl --master-disable

    # Disable annoying root password request on every LaunchAgent launch
    security authorizationdb write com.apple.system-extensions.admin allow
    ```

##### Development
1. [🆓] Setup [Sublime Text 4](https://sublimetext.com) [[:octocat:](https://github.com/SublimeText)]

    ```zsh
    brew install --cask sublime-text
    ln -fs $DOTPREFSDIR/sublime-text/conf ~/Library/Application\ Support/Sublime\ Text/Packages/User

    # Install license
    cp -f "**Path to License.sublime_license file**" ~/Library/Application\ Support/Sublime\ Text/Local/License.sublime_license

    # Set files association
    internal set-file-assoc SublimeText com.sublimetext.4 $DOTPREFSDIR/sublime-text/file-assoc.list
    ```
2. [🆓] Setup [JetBrains Toolbox](https://jetbrains.com/toolbox-app) [[:octocat:](https://github.com/JetBrains)]

    ```zsh
    brew install --cask jetbrains-toolbox
    ln -fs $DOTPREFSDIR/jb-toolbox/conf.json ~/Library/Application\ Support/JetBrains/Toolbox/.settings.json
    ```
    <!--
        Crack, just out of spite, get fucking owned JB 🖕
        Repo:   https://github.com/libin9iOak/ja-netfilter-all
        Mirror: https://jetbra.in
    -->
3. Setup [Docker](https://docs.docker.com/docker-for-mac) [[:octocat:](https://github.com/docker/for-mac)]

    ```zsh
    brew install --cask docker
    ```
4. Setup [Helm](https://helm.sh) [[:octocat:](https://github.com/helm/helm)]

    ```zsh
    brew install helm
    ```
5. Setup Java [Eclipse Temurin](https://adoptium.net/) [[:octocat:](https://github.com/adoptium)] & [GraalVM](https://graalvm.org) [[:octocat:](https://github.com/graalvm)] & [JMC](https://oracle.com/java/technologies/jdk-mission-control.html) [[:octocat:](https://github.com/openjdk/jmc)] & [sbt](https://scala-sbt.org) [[:octocat:](https://github.com/sbt/sbt)]

    ```zsh
    brew install --cask temurin{8,17}
    brew install --cask graalvm/tap/graalvm-ce-java17

    brew install --cask openjdk-jmc
    brew install sbt

    # Switch JDK version to `8` or `17` or `graal`
    jdk 17
    ```
6. Setup Rust [rustup](https://rust-lang.github.io/rustup/) [[:octocat:](https://github.com/rust-lang/)]

    ```zsh
    bash -c "$(curl -fsSL https://sh.rustup.rs)" -- --profile default --default-toolchain nightly -y --no-modify-path
    ```
7. Setup [Python 3](https://python.org) [[:octocat:](https://github.com/python)]

    ```zsh
    ln -fs /Library/Developer/CommandLineTools/usr/bin/python3 /usr/local/bin/python
    ln -fs /Library/Developer/CommandLineTools/usr/bin/pip3 /usr/local/bin/pip
    ```
8. Setup [Postgres App](http://postgresapp.com) [[:octocat:](https://github.com/PostgresApp/PostgresApp)]

    ```zsh
    brew install --cask postgres
    ```
9. [💰] Setup [Paw](https://paw.cloud) [[:octocat:](https://github.com/luckymarmot)]

    ```zsh
    brew install --cask paw
    ```
10. Setup [grpcurl](https://github.com/fullstorydev/grpcurl)

    ```zsh
    brew install grpcurl
    ```
11. Setup [ngrok](https://ngrok.com)

    ```zsh
    brew install --cask ngrok
    ```

##### Productivity
1. Setup [Apple Configurator 2](https://support.apple.com/guide/apple-configurator-2/welcome/mac)

    ```zsh
    mas install 1037126344
    ```
2. Setup [Cheatsheet](https://cheatsheetapp.com/CheatSheet)

    ```zsh
    brew install --cask cheatsheet
    defaults import com.mediaatelier.CheatSheet $DOTPREFSDIR/cheatsheet/conf.plist
    ```
3. [💰] Setup [BetterTouchTool](https://folivora.ai)

    ```zsh
    brew install --cask bettertouchtool
    defaults import com.hegenberg.BetterTouchTool $DOTPREFSDIR/btt/conf.plist

    # Install license
    cp -f "**Path to license.bettertouchtool file**" ~/Library/Application\ Support/BetterTouchTool/bettertouchtool.bttlicense
    ```
4. Setup [Touchbar Nyan Cat](https://github.com/avatsaev/touchbar_nyancat)

    ```zsh
    brew install --cask touchbar-nyancat
    ```

##### System
1. [💰] Setup [iStat Menus](https://bjango.com/mac/istatmenus) [[:octocat:](https://github.com/bjango)]

    ```zsh
    brew install --cask istat-menus
    defaults import com.bjango.istatmenus6.extras $DOTPREFSDIR/istat-menus/conf.plist

    # Install license
    defaults write com.bjango.istatmenus license6 -dict email '**License email**' serial '**License serial key**'
    ```
2. Setup [Keka](https://keka.io) [[:octocat:](https://github.com/aonez/Keka)]

    ```zsh
    brew install --cask keka
    defaults import com.aone.keka $DOTPREFSDIR/keka/conf.plist

    # Set file association (w/o using kekadefaultapp)
    internal set-file-assoc Keka com.aone.keka $DOTPREFSDIR/keka/file-assoc.list
    ```
3. Setup [Pictogram](https://pictogramapp.com)

    ```zsh
    brew install --cask pictogram
    ```
4. [🆓] Setup [ForkLift](https://binarynights.com)

    ```zsh
    brew install --cask forklift
    defaults import com.binarynights.ForkLift-3 $DOTPREFSDIR/forklift/conf.plist

    # Set as default file viewer
    defaults write -g NSFileViewer -string com.binarynights.ForkLift-3
    defaults write com.apple.LaunchServices/com.apple.launchservices.secure LSHandlers -array-add '{LSHandlerContentType="public.folder";LSHandlerRoleAll="com.binarynights.ForkLift-3";}'
    ```
5. [💰] Setup [Apple Remote Desktop](https://apps.apple.com/app/id409907375)

    ```zsh
    mas install 409907375
    ```
6. Setup [OnyX](https://titanium-software.fr/en/onyx)

    ```zsh
    brew install --cask onyx
    ```
7. ~~Setup [Clean Me](https://github.com/Kevin-De-Koninck/Clean-Me)~~ (Abandoned)

    ```zsh
    # brew install --cask clean-me
    ```

##### Network
1. Setup [Brave Browser](https://brave.com)

    *
        ```zsh
        brew install --cask brave-browser
        ```
    * Install [plugins, theme and StartPage search engine](/brave/plugins.md)
    * Import [uBlock Origin settings](/brave/ublock-settings.txt)
2. Setup [TOR](https://torproject.org) [[:octocat:](https://github.com/TheTorProject)]

    ```zsh
    brew install --cask tor-browser
    ```
3. [🆓] Setup [Folx](https://mac.eltima.com/download-manager)

    ```zsh
    brew install --cask folx
    defaults import com.eltima.Folx3 $DOTPREFSDIR/folx/conf.plist
    ```
4. Setup [Wi-Fi Explorer](https://intuitibits.com/products/wifi-explorer)

    ```zsh
    brew install --cask wifi-explorer
    ```

##### Social
1. Setup [Signal](https://signal.org) [[:octocat:](https://github.com/signalapp)]

    ```zsh
    brew install --cask signal
    ```
2. Setup [Zoom](https://zoom.us) [[:octocat:](https://github.com/zoom)]

    ```zsh
    brew install --cask zoom
    
    # Remove dangerous daemon
    sudo launchctl bootout system /Library/LaunchDaemons/us.zoom.ZoomDaemon.plist && sudo rm -f /Library/{LaunchDaemons,PrivilegedHelperTools}/us.zoom.ZoomDaemon*
    ```
3. [💰] Setup [Krisp](https://krisp.ai)

    ```zsh
    brew install --cask krisp

    # Remove useless Camera function
    sudo launchctl bootout system /Library/LaunchAgents/ai.krisp.krispMac.cameraAssistant.plist && sudo rm -f /Library/LaunchAgents/ai.krisp.krispMac.cameraAssistant.plist && sudo rm -rf /Library/CoreMediaIO/Plug-Ins/DAL/KrispCamera.plugin && sudo pkgutil --forget ai.krisp.krispMacVideo
    ```
4. [💰] Setup [Proton Mail - Bridge](https://proton.me/mail/bridge) [[:octocat:](https://github.com/ProtonMail/proton-bridge)]

    ```zsh
    brew install --cask protonmail-bridge
    ```

##### Entertainment
1. [🆓] Setup [Spotify](https://spotify.com) [[:octocat:](https://github.com/spotify)]

    ```zsh
    brew install --cask spotify
    ```
2. [🆓] Setup [MP3Tag](https://mp3tag.app)

    ```zsh
    mas install 1532597159
    ```
3. Setup [HandBrake](https://handbrake.fr) [[:octocat:](https://github.com/HandBrake/HandBrake)]

    ```zsh
    brew install --cask handbrake
    ```
4. Setup [MediaInfo](https://mediaarea.net/MediaInfo)

    ```zsh
    # Ugly but free
    brew install --cask mediainfo
    
    # For Native UI
    mas install 510620098
    ```
5. [🆓] Setup [Picktorial](https://apps.apple.com/app/id1043289526)

    ```zsh
    mas install 1043289526
    ```
6. [🆓] Setup [Abyss](https://apps.apple.com/app/id1507396839)

    ```zsh
    mas install 1507396839
    ```

##### Mobile
1. Setup [AltServer](https://altstore.io) [[:octocat:](https://github.com/rileytestut/AltStore)]

    ```zsh
    brew install --cask altserver
    defaults import com.rileytestut.AltServer $DOTPREFSDIR/altserver/conf.plist
    ```
2. [💰] Setup [WALTR PRO](https://softorino.com/waltr)

    ```zsh
    brew install --cask waltr-pro
    defaults import com.softorino.waltrpro $DOTPREFSDIR/waltr/conf.plist

    # ~/Library/Application\ Support/WALTR\ PRO/.alticense && /Users/Shared/WALTR PRO/.alticense
    ```
