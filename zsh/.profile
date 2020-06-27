# ==========================================
# 		.profile 
# ==========================================

# Global settings
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin:/usr/local/opt/ruby/bin"
# if [ -x /usr/libexec/path_helper ]; then
# 	eval `/usr/libexec/path_helper -s`
# fi
export XDG_CACHE_HOME="${HOME}/Library/Caches"
export XDG_CONFIG_HOME="${HOME}/.config"

# Homebrew
export HOMEBREW_PREFIX="/usr/local";
export HOMEBREW_CELLAR="/usr/local/Cellar";
export HOMEBREW_REPOSITORY="/usr/local/Homebrew";
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_INSTALL_CLEANUP=1
export HOMEBREW_NO_EMOJI=1

# Java
if [[ -f /usr/libexec/java_home ]]; then
  export JAVA_HOME=$(/usr/libexec/java_home)
  launchctl setenv JAVA_HOME $JAVA_HOME
else
  abort "Failed to set JAVA_HOME, /usr/libexec/java_home not found"
fi

# thefuck (https://github.com/nvbn/thefuck)
if command -v thefuck &> /dev/null; then
  eval "$(thefuck --alias)"
fi