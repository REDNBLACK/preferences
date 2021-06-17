# ====================================================================================== #
#                                .profile                                                #
# ====================================================================================== #


# ====================================================================================== #
#                                Global settings                                         #
# ====================================================================================== #
typeset -gx LC_CTYPE="UTF-8"
typeset -gx LC_ALL="en_US.$LC_CTYPE"
typeset -gx LANG=$LC_ALL
typeset -gx XDG_CACHE_HOME="$HOME/Library/Caches"
typeset -gx XDG_CONFIG_HOME="$HOME/.config"

if [ -x /usr/libexec/path_helper ]; then
  eval `/usr/libexec/path_helper -s`
fi
# ====================================================================================== #


# ====================================================================================== #
#                                Homebrew settings                                       #
# ====================================================================================== #
typeset -gx HOMEBREW_PREFIX="/usr/local"
typeset -gx HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar"
typeset -gx HOMEBREW_REPOSITORY="$HOMEBREW_PREFIX/Homebrew"
typeset -gx HOMEBREW_NO_ANALYTICS=1
typeset -gx HOMEBREW_NO_INSTALL_CLEANUP=1
typeset -gx HOMEBREW_NO_EMOJI=1
# ====================================================================================== #
