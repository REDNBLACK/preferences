### How To Build
Compile the bridge with the listening host changed as in this commit [1e85c8d](https://github.com/ProtonMail/proton-bridge/pull/270/commits/1e85c8d057b245f77d21ff7376621739b019832a)

```diff
--- a/internal/constants/constants.go
+++ b/internal/constants/constants.go
@@ -60,7 +60,7 @@ const (
KeyChainName = "bridge-v3"                                                                                                                                                                                                                                          // Host is the hostname of the bridge server.
-        Host = "127.0.0.1"
+       Host = "0.0.0.0"
)
```
And then build bridge without gui as per this instruction [build-bridge-without-gui](https://github.com/ProtonMail/proton-bridge/blob/master/BUILDS.md#build-bridge-without-gui)

### Configure

```zsh
/usr/local/bin/bridge --cli

proxy allow     # Allow Connect via Proxy if Main Server is Blocked by ISP
add             # Interactively Login and Add User to Bridge DB
info            # Display Credentials for Connection to Server
export-tls-cert # Export TLS cert which you will need to install to Client Machine
```

### Check Connection (or show cert like from `export-tls-cert` output)

```zsh
openssl s_client -connect {IP}:1025 -starttls smtp
openssl s_client -starttls imap -connect {IP}:1143 -showcerts
```

### Run as Daemon

```zsh
launchctl bootstrap "gui/{UID}" /Library/LaunchDaemons/com.proton.mail.bridge.plist
```

### Useful Links
https://www.reddit.com/r/ProtonMail/comments/107nsb5/how_to_use_the_proton_bridge_on_a_different_pc/
https://stackoverflow.com/questions/57746821/getting-a-self-signed-certificate-error-with-protonbridge-and-mbsync
https://gist.github.com/ibaiul/60d603845df931483a05d96c5b433981
https://gist.github.com/githubcom13/2f30f46cd5273db2453a6e7fdb3c422b
https://protonmail.com/bridge/thunderbird
