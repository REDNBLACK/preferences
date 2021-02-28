# ==========================================
# 		.profile
# ==========================================

#######[ Global settings ]##########
export LC_CTYPE="UTF-8"
export LC_ALL="en_US.$LC_CTYPE"
export LANG=$LC_ALL
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/local/opt/ruby/bin"
# if [ -x /usr/libexec/path_helper ]; then
# 	eval `/usr/libexec/path_helper -s`
# fi
export XDG_CACHE_HOME="${HOME}/Library/Caches"
export XDG_CONFIG_HOME="${HOME}/.config"
####################################


###########[ Homebrew ]#############
export HOMEBREW_PREFIX="/usr/local";
export HOMEBREW_CELLAR="/usr/local/Cellar";
export HOMEBREW_REPOSITORY="/usr/local/Homebrew";
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_INSTALL_CLEANUP=1
export HOMEBREW_NO_EMOJI=1
####################################


############[ Docker ]##############
export DOCKER_CONFIG="${XDG_CONFIG_HOME}/docker"
####################################


###########[   tldr   ]############
export TLDR_CACHE_DIR=$XDG_CACHE_HOME
###################################


###########[  thefuck ]############
if command -v thefuck &> /dev/null; then
  eval "$(thefuck --alias)"
fi
###################################
