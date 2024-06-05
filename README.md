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
    mkdir -p ~/.config/
    echo "export DOTPREFSDIR=$(cd Preferences && pwd)" | sudo tee -a /etc/zshenv > /dev/null
    exec zsh
    ```
3. Setup [Homebrew](https://brew.sh) [[:octocat:](https://github.com/Homebrew)] & [mas-cli](https://github.com/mas-cli/mas) & [cask-upgrade](https://github.com/buo/homebrew-cask-upgrade)

    ```zsh
    # Prepare System
    [[ "$(uname -m)" == "arm64" ]] && sudo softwareupdate --install-rosetta --agree-to-license

    # Install Homebrew
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval $(/opt/homebrew/bin/brew shellenv)
    brew analytics off

    # Install Essential Modules
    brew tap homebrew/cask-versions
    brew tap buo/cask-upgrade
    brew install mas

    # Symlink custom Formulaes, Casks and Patches
    mkdir -p $HOMEBREW_REPOSITORY/Library/Taps/rednblack && ln -fs $DOTPREFSDIR/homebrew "$_/homebrew-tap"
    ```
4. Setup [Git](https://git-scm.com) [[:octocat:](https://github.com/git/git)] & [Git LFS](https://git-lfs.com) [[:octocat:](https://github.com/git-lfs/git-lfs)] & [GitHub](hhttps://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)

    ```zsh
    # Patch git formula, removing gettext and pcre2 dependencies and install
    brew patch rednblack/tap git
    brew install rednblack/tap/git --build-from-source

    brew install git-lfs
    ln -fs $DOTPREFSDIR/git ~/.config/git

    # After generation of Personal Access Token (Classic)
    security add-internet-password -l 'GitHub Token (%GitHub Account Name%)' -s github.com -r htps -a %GitHub Account Name% -w '%GitHub Account Token%'
    ```
5. Setup [Fira Code (+Nerd)](https://github.com/tonsky/FiraCode) & [Meslo Nerd](https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Meslo)

    ```zsh
    brew install --cask font-{fira-code,fira-code-nerd-font,meslo-lg-nerd-font}
    ```
6. Setup [zsh](http://zsh.org) [[:octocat:](https://github.com/zsh-users)] & [zinit](https://zdharma.github.io/zinit/wiki/) [[:octocat:](https://github.com/zdharma/zinit)] & [PowerLevel10K](https://github.com/romkatv/powerlevel10k) & [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) & [zsh-fast-syntax-highlighting](https://github.com/zdharma/fast-syntax-highlighting)

    ```zsh
    brew install zsh # ⚠️ Command may be skipped in case of actual preinstalled zsh version
    ln -fs $DOTPREFSDIR/zsh ~/.config/zsh
    echo "export ZDOTDIR=$HOME/.config/zsh" | sudo tee -a /etc/zshenv > /dev/null
    echo "export PATH=${HOMEBREW_PREFIX}bin:${HOMEBREW_PREFIX}sbin:/Library/Developer/CommandLineTools/usr/bin:\$PATH" | sudo tee -a /etc/zshenv > /dev/null

    # Set as default shell ⚠️ Command may be skipped in case of actual preinstalled zsh version
    which zsh | sudo tee -a /etc/shells > /dev/null
    chsh -s $(which zsh)

    # Set as default shell (alternative) ⚠️ Command may be skipped in case of actual preinstalled zsh version
    sudo dscl . -create ~ UserShell $(which zsh)
    ```
7. Setup [iTerm](https://iterm2.com) [[:octocat:](https://github.com/gnachman/iTerm2)]

    ```zsh
    brew install --cask iterm2

    # Import Settings
    defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool YES
    defaults write com.googlecode.iterm2 PrefsCustomFolder "$DOTPREFSDIR/iterm2"

    # Set files association (⚠️ MUST START iTERM2 AT THIS STEP!!!)
    internal set-file-assoc iTerm com.googlecode.iterm2 $DOTPREFSDIR/iterm2/file-assoc.list
    ```
8. Setup Tools
    * [`cat` with rainbows!](https://github.com/ur0/lolcat)
        ```zsh
        brew install lolcat-rust
        ```
    * [`ls` on steroids](https://github.com/eza-community/eza)
        ```zsh
        # Patch eza formula, removing libgit2, libssh2, openssl@3 dependencies and install
        brew patch rednblack/tap eza
        brew install rednblack/tap/eza --build-from-source
        brew smartremove eza && rm -rf "$(brew --prefix)"/etc/{openssl@3,ca-certificates}
        ```
    * [`grep` modern alternative](https://github.com/BurntSushi/ripgrep) (depends on `pcre2`)
        ```zsh
        brew install ripgrep
        ```
    * [`sponge` helps in fully reading `stdin` to temp files automatically](https://mbork.pl/2019-09-16_sponge_and_other_moreutils)
        ```zsh
        brew install sponge
        ```
    * [`man` in TL;DR variant](https://github.com/dbrgn/tealdeer)
        ```zsh
        brew install tealdeer
        ```
    * Set files association [`duti`](https://github.com/moretension/duti), [`swiftdefaultappsprefpane`](https://github.com/Lord-Kamina/SwiftDefaultApps)
        ```zsh
        brew install duti swiftdefaultappsprefpane
        ```
    * Process JSON, YAML, XML, CSV via CLI [`jaq` (jq на rust)](https://github.com/01mf02/jaq) & [`yq`](https://github.com/mikefarah/yq)
        ```zsh
        brew install jaq yq
        ```
    * [Correct errors in previous commands](https://github.com/nvbn/thefuck) (depends on `python`)
        ```zsh
        brew install thefuck
        ```
9. Setup macOS

    ```zsh
    . $DOTPREFSDIR/macOS/conf.zsh
    ```

##### Security
1. Setup Yubikey [Manager](https://developers.yubico.com/yubikey-manager-qt/) [[:octocat:](https://github.com/Yubico/yubikey-manager-qt)] + [Authenticator](https://developers.yubico.com/yubioath-flutter/) [[:octocat:](https://github.com/Yubico/yubioath-flutter)]

    ```zsh
    brew install --cask yubico-{yubikey-manager,authenticator}

    # Add Manager CLI to Path
    cat > ${HOMEBREW_PREFIX}/bin/ykman <<EOF
#!/bin/bash
export PYTHONHOME=""
exec '/Applications/$(brew info yubico-yubikey-manager --json=v2 | jq -r '.casks[].name | .[0]').app/Contents/MacOS/ykman' "\$@"
EOF
    chmod +x ${HOMEBREW_PREFIX}/bin/ykman
    ```
2. [💰] Setup [Strongbox](https://strongboxsafe.com) [[:octocat:](https://github.com/strongbox-password-safe)]

    ```zsh
    mas install 1481853033
    ```
3. Setup [GPG Suite](https://gpgtools.org) [[:octocat:](https://github.com/GPGTools)]

    ```zsh
    brew install --cask gpg-suite-no-mail
    defaults write org.gpgtools.updater SUEnableAutomaticChecks -bool NO
    defaults write org.gpgtools.gpgkeychain DoNotShowUploadDialogAgain -bool YES
    defaults write org.gpgtools.common UseKeychain -bool YES

    # Enable Touch ID
    ln -fs $DOTPREFSDIR/pgp/gpg-agent.conf ~/.config/pgp/gpg-agent.conf
    pkill -9 -f pinentry-swift 2> /dev/null || true && swiftc $DOTPREFSDIR/pgp/pinentry-swift.swift -enable-bare-slash-regex -o $HOMEBREW_PREFIX/bin/pinentry-swift

    # Secure SSH
    # sudo sed -i '' "s/^#?PrintLastLog yes$/^PrintLastLog no$/" /etc/ssh/sshd_config
    ln -fs $DOTPREFSDIR/pgp/ssh.conf ~/.config/ssh/client_config
    sudo sed -i '' -n -e '/^Include \/Users\/\*\*\/.*$/!p' -e '$a\'$'\n\\\n# Load Custom Config. DO NOT EDIT\\\nInclude /Users/**/.config/ssh/client_config' /etc/ssh/ssh_config
    sudo sed -i '' -n -e '/^Include \/Users\/\*\*\/.*$/!p' -e '$a\'$'\n\\\n# Load Custom Config. DO NOT EDIT\\\nInclude /Users/**/.config/ssh/daemon_config' /etc/ssh/sshd_config
    ## > Variant 1: Disabled Password Auth, Key Only
    ln -fs $DOTPREFSDIR/pgp/sshd-key.conf ~/.config/ssh/daemon_config
    ## > Variant 2: Auth via Password + 2FA
    ln -fs $DOTPREFSDIR/pgp/sshd-otp.conf ~/.config/ssh/daemon_config
    brew install --ignore-dependencies google-authenticator-libpam
    google-authenticator -t -D -Cfq -w 17 -r 3 -R 30 -s ~/.config/ssh/google_authenticator
    sudo sed -i '.old' -e '6s;^;auth       required       /usr/local/opt/google-authenticator-libpam/lib/security/pam_google_authenticator.so secret=/Users/${USER}/.config/ssh/google_authenticator\n;' /etc/pam.d/sshd

    # Remove bloat
    sudo rm -rf /Library/PreferencePanes/GPGPreferences.prefPane && sudo rm -f /Library/LaunchAgents/org.gpgtools.{updater,macgpg2.fix,macgpg2.updater,Libmacgpg.xpc}.plist
    ```
4. Setup secure DNS over HTTPS/TLS/QUIC
    * Popular [DNS over HTTPS/TLS](https://github.com/paulmillr/encrypted-dns)
        1. Set var `config` to config name from [repo](https://github.com/paulmillr/encrypted-dns/tree/master/profiles) (for example `cloudflare-https`)
        2.
            ```zsh
            curl -LSs -o 'DoH.mobileconfig' "https://raw.githubusercontent.com/paulmillr/encrypted-dns/master/profiles/${config}.mobileconfig" && \
            open -a ProfileHelper DoH.mobileconfig && \
            open "x-apple.systempreferences:com.apple.preferences.configurationprofiles" && \
            rm DoH.mobileconfig
            ```
        3. In the Profiles window press 'Install...'
    * [🆓] [NextDNS](https://nextdns.io) [[:octocat:](https://github.com/nextdns)]
        1. Set vars `id` - to your configuration id, `name` - to device name and `model` - to one of values from [here](https://apple.nextdns.io) (for example `Apple MacBookPro11,1`)
        2.
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
        3. In the Profiles window press 'Install...'

        OR
        ```zsh
        brew install nextdns/tap/nextdns
        ```
5. Setup [Orbot](https://orbot.app) [[:octocat:](hhttps://github.com/guardianproject/orbot-apple)]

    ```zsh
    mas install 1609461599
    ```
6. [💰] Setup [AdGuard VPN](https://adguard-vpn.com)

    ```zsh
    brew install --cask adguard-vpn
    defaults import com.adguard.mac.vpn $DOTPREFSDIR/adguard/conf.plist

    # Add NextDNS as QUIC DNS
    defaults write com.adguard.mac.vpn 'dns-servers-settings' -data $(jq -n --arg profile "%NextDNS Profile%" --arg device "%Device Name%" '{"selectedServer": {"uid": "42B5EEE1-2255-4B6F-96EA-54953B75807B", "name": "NextDNS [QUIC] (\($profile))", "address": "quic://\($device)-\($profile).dns.nextdns.io"}} | .servers = [.selectedServer]' | xxd -u -p - | tr -d '\n')
    ```
7. Setup misc

    ```zsh
    # Enable sudo auth via Touch ID (⚠️ Must be done after every system update)
    sudo sed -i '.old' -e '2s;^;auth       sufficient     pam_tid.so\n;' /etc/pam.d/sudo

    # Allow applications downloaded from anywhere (⚠️ Must be done after every system update)
    sudo spctl --master-disable

    # Add Terminal to Developer Tools, so any processes run by it to be excluded from Gatekeeper
    sudo spctl developer-mode enable-terminal

    # Disable annoying root password request on every LaunchAgent launch (⚠️ Must be done after every system update)
    security authorizationdb write com.apple.system-extensions.admin allow

    # Disable library validation (⚠️ USE YOUR BRAIN, also must be done after every system update)
    sudo defaults write /Library/Preferences/com.apple.security.libraryvalidation.plist DisableLibraryValidation -bool true

    # Disable the “Are you sure you want to open this application?” dialog
    defaults write com.apple.LaunchServices LSQuarantine -bool false

    # Cleanup conflicting configs for bash/zsh (⚠️ Must be done after every system update)
    sudo rm -f /etc/zshrc_Apple_Terminal /etc/zshrc /etc/zprofile /etc/bashrc_Apple_Terminal /etc/bashrc /etc/profile
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

    *
        ```zsh
        brew install --cask jetbrains-toolbox
        ln -fs $DOTPREFSDIR/jb-toolbox/conf.json ~/Library/Application\ Support/JetBrains/Toolbox/.settings.json
        ln -fs $DOTPREFSDIR/jb-toolbox/storage.json ~/Library/Application\ Support/JetBrains/Toolbox/.storage.json
        ```
    * Next download `IntelliJ IDEA Ultimate`
    * Install [plugins for IntelliJ IDEA](/jb-toolbox/IDEA/plugins.md)
    * ¯\_(ツ)_/¯
        <!--
            Crack, just out of spite, get fucking owned JB 🖕
            Repo:   https://github.com/libin9iOak/ja-netfilter-all
            Mirror: https://jetbra.in
        -->

3. Setup [Docker](https://docs.docker.com/docker-for-mac) [[:octocat:](https://github.com/docker/for-mac)] & [Helm](https://helm.sh) [[:octocat:](https://github.com/helm/helm)]

    ```zsh
    brew install --cask docker
    brew install helm

    # After generation of Access Token
    security add-internet-password -l 'Docker Token (%Docker Account Name%)' -s docker.com -r htps -a %Docker Account Name% -w '%Docker Account Token%'
    ```
4. Setup Java [Eclipse Temurin](https://adoptium.net/) [[:octocat:](https://github.com/adoptium)] & [GraalVM](https://graalvm.org) [[:octocat:](https://github.com/graalvm)] & [JMC](https://oracle.com/java/technologies/jdk-mission-control.html) [[:octocat:](https://github.com/openjdk/jmc)] & [sbt](https://scala-sbt.org) [[:octocat:](https://github.com/sbt/sbt)]

    ```zsh
    brew install --cask temurin@{8,17} graalvm-jdk
    brew install --cask openjdk-jmc
    brew install sbt

    # Switch JDK version to `8` or `17` or `graal`
    jdk 17
    ```
5. Setup [Python](https://python.org) [[:octocat:](https://github.com/python)]

    ```zsh
    ln -fs /Library/Developer/CommandLineTools/usr/bin/python3 $HOMEBREW_PREFIX/bin/python
    ln -fs /Library/Developer/CommandLineTools/usr/bin/pip3 $HOMEBREW_PREFIX/bin/pip
    ```
6. Setup Rust [rustup](https://rust-lang.github.io/rustup/) [[:octocat:](https://github.com/rust-lang/)]

    ```zsh
    curl -L https://sh.rustup.rs | bash -s -- --profile default --default-toolchain nightly -y --no-modify-path
    ```
7. Setup Node.js [n](https://github.com/tj/n) [[:octocat:](https://github.com/tj/n)] & [pnpm](https://pnpm.io) [[:octocat:](https://github.com/pnpm/pnpm)]

    ```zsh
    curl -L https://raw.githubusercontent.com/mklement0/n-install/stable/bin/n-install | bash -s -- -n -y lts
    corepack enable npm pnpm
    ```
8. Setup [RapidAPI](https://paw.cloud) & [grpcurl](https://github.com/fullstorydev/grpcurl) & [ngrok](https://ngrok.com)

    ```zsh
    brew install --cask rapidapi
    brew install grpcurl
    brew install --cask ngrok
    ```
9. Setup [Postgres App](http://postgresapp.com) [[:octocat:](https://github.com/PostgresApp/PostgresApp)]

    ```zsh
    brew install --cask postgres-unofficial
    ```
10. Setup [Hex Fiend](https://ridiculousfish.com/hexfiend)

    ```zsh
    brew install --cask hex-fiend
    ```

##### Productivity
1. Setup [Obsidian](https://obsidian.md)

    ```zsh
    brew install --cask obsidian
    ```
2. [🆓] Setup [Raycast](https://raycast.com)

    ```zsh
    brew install --cask raycast
    ```
3. Setup [Cheatsheet](https://cheatsheetapp.com/CheatSheet)

    ```zsh
    brew install --cask cheatsheet
    defaults import com.mediaatelier.CheatSheet $DOTPREFSDIR/cheatsheet/conf.plist
    ```

4. [💰] Setup [DevUtils](https://devutils.com)

    ```zsh
    brew install --cask devutils
    ```
5. Setup [Touchbar Nyan Cat](https://github.com/avatsaev/touchbar_nyancat)

    ```zsh
    brew install --cask touchbar-nyancat
    ```

##### System
1. [🆓] Setup [Nimble Commander](https://magnumbytes.com)

    ```zsh
    brew install --cask nimble-commander
    ln -fs $DOTPREFSDIR/nimble-commander/conf.json ~/Library/Application\ Support/Nimble\ Commander/Config/Config.json
    defaults import info.filesmanager.Files $DOTPREFSDIR/nimble-commander/conf.plist

    # Set as default file viewer
    defaults write -g NSFileViewer -string info.filesmanager.Files
    defaults write com.apple.LaunchServices/com.apple.launchservices.secure LSHandlers -array-add '{LSHandlerContentType="public.folder";LSHandlerRoleAll="info.filesmanager.Files";}'

    # Install license
    cp -f "**Path to License.nimblecommanderlicense file**" ~/Library/Application\ Support/Nimble\ Commander/registration.nimblecommanderlicense

    # Import Remote Fileshares
    ln -fs $DOTPREFSDIR/nimble-commander/network.json ~/Library/Application\ Support/Nimble\ Commander/Config/NetworkConnections.json
    cp -f "**SSH Keys for SFTP**" ~/Library/Application\ Support/Nimble\ Commander/Keys
    ```
2. Setup [Keka](https://keka.io) [[:octocat:](https://github.com/aonez/Keka)]

    ```zsh
    brew install --cask keka
    defaults import com.aone.keka $DOTPREFSDIR/keka/conf.plist

    # Set file association (w/o using kekadefaultapp)
    internal set-file-assoc Keka com.aone.keka $DOTPREFSDIR/keka/file-assoc.list
    ```
3. [💰] Setup [iStat Menus](https://bjango.com/mac/istatmenus) [[:octocat:](https://github.com/bjango)]

    ```zsh
    brew install --cask istat-menus
    defaults import com.bjango.istatmenus6.extras $DOTPREFSDIR/istat-menus/conf.plist

    # Install license
    defaults write com.bjango.istatmenus license6 -dict email '**License email**' serial '**License serial key**'
    ```
4. Setup [OnyX](https://titanium-software.fr/en/onyx)

    ```zsh
    brew install --cask onyx
    ```
5. [💰] Setup [DaisyDisk](https://daisydiskapp.com)

    ```zsh
    brew install --cask daisydisk
    ```
6. Setup [Wineskin](https://github.com/Gcenx/WineskinServer)

    ```zsh
    brew install --cask gcenx/wine/wineskin
    ```
7. [💰] Setup [Apple Remote Desktop](https://apps.apple.com/app/id409907375)

    ```zsh
    mas install 409907375
    ```

##### Network
1. Setup [Brave Browser](https://brave.com)

    *
        ```zsh
        brew install --cask brave-browser
        ```
    * Install [plugins, theme and StartPage search engine](/brave/plugins.md)
    * Import [uBlock Origin settings](/brave/ublock-settings.txt)
2. Setup [Transmission](https://transmissionbt.com) [[:octocat:](https://github.com/transmission/transmission)]

    ```zsh
    brew install --cask transmission
    defaults import org.m0k.transmission $DOTPREFSDIR/transmission/conf.plist
    ```
3. [🆓] Setup [Wi-Fi Explorer](https://intuitibits.com/products/wifi-explorer)

    ```zsh
    brew install --cask wifi-explorer
    defaults import com.intuitibits.wifiexplorerpro3 $DOTPREFSDIR/wifi-explorer/conf.plist
    ```

##### Social
1. Setup [Signal](https://signal.org) [[:octocat:](https://github.com/signalapp)]

    ```zsh
    brew install --cask signal
    ```
2. Setup [KTalk](https://kontur.ru/talk)

    ```zsh
    brew install --cask ktalk
    ```
3. [💰] Setup [Krisp](https://krisp.ai)

    ```zsh
    brew install --cask krisp

    # Disable autostart
    rm -f ~/Library/LaunchAgents/krisp.plist
    ```
4. [💰] Setup [Proton Mail - Bridge](https://proton.me/mail/bridge) Headless, with [patched hostname resolve](https://github.com/ProtonMail/proton-bridge/pull/270/commits/1e85c8d057b245f77d21ff7376621739b019832a) [[:octocat:](https://github.com/ProtonMail/proton-bridge)]

    ```zsh
    cd $DOTPREFSDIR/protonmail-bridge && ./install.zsh
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
3. Setup [Subler](https://subler.org) & [HandBrake](https://handbrake.fr) [[:octocat:](https://github.com/HandBrake/HandBrake)] & [FFmpeg](https://ffmpeg.org) & [MKVToolNix](https://mkvtoolnix.download)

    ```zsh
    brew install --cask video-toolbox
    ```
4. Setup [MediaInfo](https://mediaarea.net/MediaInfo)

    ```zsh
    # Ugly but free
    brew install --cask mediainfo
    
    # For Native UI
    mas install 510620098
    ```

##### Mobile
1. Setup [Sideloadly](https://sideloadly.io)

    ```zsh
    brew install --cask sideloadly
    ```
2. Setup [Apple Configurator 2](https://support.apple.com/guide/apple-configurator-2/welcome/mac)

    ```zsh
    mas install 1037126344
    ```
3. Setup [iMazing](https://imazing.com)

    ```zsh
    brew install --cask imazing imazing-profile-editor
    ```
4. [💰] Setup [WALTR PRO](https://softorino.com/waltr)

    ```zsh
    brew install --cask waltr-pro
    defaults import com.softorino.waltrpro $DOTPREFSDIR/waltr/conf.plist

    # ~/Library/Application\ Support/WALTR\ PRO/.alticense && /Users/Shared/WALTR PRO/.alticense
    ```
