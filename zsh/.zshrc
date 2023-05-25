# ====================================================================================== #
#                                .zshrc                                                  #
# ====================================================================================== #


# ====================================================================================== #
#                                 zsh                                                    #
#   more at:                                                                             #
#    https://grml.org/zsh/zsh-lovers.html                                                #
# ====================================================================================== #
# Load profile
. $ZDOTDIR/profile

# Colored ASCII text
autoload -U colors && colors

# Path to cache directory
declare -gx ZSH_CACHE_DIR="$XDG_CACHE_HOME/zsh"
[[ ! -d $ZSH_CACHE_DIR ]] && mkdir -p $ZSH_CACHE_DIR

# Correctly display UTF-8 with combining characters.
setopt COMBINING_CHARS

# Don't beep on an ambiguous completion
unsetopt LIST_BEEP

# Allow expansion in prompts
setopt PROMPT_SUBST

# Display PID when suspending processes as well
setopt LONGLISTJOBS

# Automatically changle directory if a dir is entered
setopt AUTO_CD

# Make cd push each old directory onto the stack
setopt AUTO_PUSHD

# Like AUTO_CD, but for named directories
setopt CDABLE_VARS

# Don't push duplicates onto the stack
setopt PUSHD_IGNORE_DUPS

# Use extended globbing
setopt EXTENDED_GLOB

# Do not confirm twice on rm with glob pattern
setopt RM_STAR_SILENT

# Path to completions cache
zstyle ':completion::complete:*' cache-path "$ZSH_CACHE_DIR/zcompcache"

# Path to LESS history file
declare -gx LESSHISTFILE="$ZSH_CACHE_DIR/.less_history"

# Path to history file
declare -gx HISTFILE="$ZSH_CACHE_DIR/.history"

# The number of commands to save
declare -gx HISTSIZE=2000

# The history is trimmed when its length excedes SAVEHIST by 20%
declare -gx SAVEHIST=1000

# Ignore command lines with leading spaces
setopt HIST_IGNORE_SPACE

# Do Not Record An Event That Was just recored again
setopt HIST_IGNORE_DUPS

# Ignore repeated lines in history file
setopt HIST_IGNORE_ALL_DUPS

# Do Not Display A Previously Found Event
setopt HIST_FIND_NO_DUPS

# Do Not Write A Duplicate Event To The History File
setopt HIST_SAVE_NO_DUPS

# Sessions will append their history list to the history file, rather than replace it
setopt APPEND_HISTORY

# Share History Between All Sessions
setopt SHARE_HISTORY

# Use keycodes (generated via zkbd) if present, otherwise fallback on
# values from terminfo
typeset -g -A key
[[ -n "$terminfo[kf1]" ]] && key[F1]=$terminfo[kf1]
[[ -n "$terminfo[kf2]" ]] && key[F2]=$terminfo[kf2]
[[ -n "$terminfo[kf3]" ]] && key[F3]=$terminfo[kf3]
[[ -n "$terminfo[kf4]" ]] && key[F4]=$terminfo[kf4]
[[ -n "$terminfo[kf5]" ]] && key[F5]=$terminfo[kf5]
[[ -n "$terminfo[kf6]" ]] && key[F6]=$terminfo[kf6]
[[ -n "$terminfo[kf7]" ]] && key[F7]=$terminfo[kf7]
[[ -n "$terminfo[kf8]" ]] && key[F8]=$terminfo[kf8]
[[ -n "$terminfo[kf9]" ]] && key[F9]=$terminfo[kf9]
[[ -n "$terminfo[kf10]" ]] && key[F10]=$terminfo[kf10]
[[ -n "$terminfo[kf11]" ]] && key[F11]=$terminfo[kf11]
[[ -n "$terminfo[kf12]" ]] && key[F12]=$terminfo[kf12]
[[ -n "$terminfo[kf13]" ]] && key[F13]=$terminfo[kf13]
[[ -n "$terminfo[kf14]" ]] && key[F14]=$terminfo[kf14]
[[ -n "$terminfo[kf15]" ]] && key[F15]=$terminfo[kf15]
[[ -n "$terminfo[kf16]" ]] && key[F16]=$terminfo[kf16]
[[ -n "$terminfo[kf17]" ]] && key[F17]=$terminfo[kf17]
[[ -n "$terminfo[kf18]" ]] && key[F18]=$terminfo[kf18]
[[ -n "$terminfo[kf19]" ]] && key[F19]=$terminfo[kf19]
[[ -n "$terminfo[kf20]" ]] && key[F20]=$terminfo[kf20]
[[ -n "$terminfo[kbs]" ]] && key[Backspace]=$terminfo[kbs]
[[ -n "$terminfo[kich1]" ]] && key[Insert]=$terminfo[kich1]
[[ -n "$terminfo[kdch1]" ]] && key[Delete]=$terminfo[kdch1]
[[ -n "$terminfo[khome]" ]] && key[Home]=$terminfo[khome]
[[ -n "$terminfo[kend]" ]] && key[End]=$terminfo[kend]
[[ -n "$terminfo[kpp]" ]] && key[PageUp]=$terminfo[kpp]
[[ -n "$terminfo[knp]" ]] && key[PageDown]=$terminfo[knp]
[[ -n "$terminfo[kcuu1]" ]] && key[Up]=$terminfo[kcuu1]
[[ -n "$terminfo[kcub1]" ]] && key[Left]=$terminfo[kcub1]
[[ -n "$terminfo[kcud1]" ]] && key[Down]=$terminfo[kcud1]
[[ -n "$terminfo[kcuf1]" ]] && key[Right]=$terminfo[kcuf1]

# Default key bindings
[[ -n ${key[Delete]} ]] && bindkey "${key[Delete]}" delete-char
[[ -n ${key[Home]} ]] && bindkey "${key[Home]}" beginning-of-line
[[ -n ${key[End]} ]] && bindkey "${key[End]}" end-of-line
[[ -n ${key[Up]} ]] && bindkey "${key[Up]}" up-line-or-search
[[ -n ${key[Down]} ]] && bindkey "${key[Down]}" down-line-or-search
# ====================================================================================== #


# ====================================================================================== #
#                                    zinit                                               #
#   more at                                                                              #
#    https://github.com/zdharma/zinit                                                    #
# ====================================================================================== #
declare -A ZINIT

# Path to home dir
ZINIT[HOME_DIR]="$ZSH_CACHE_DIR/zinit"

# Path to downloaded plugins
ZINIT[PLUGINS_DIR]="${ZINIT[HOME_DIR]}/plugins"

# Path to downloaded completions
ZINIT[COMPLETIONS_DIR]="${ZINIT[HOME_DIR]}/completions"

# Path to downloaded snippets
ZINIT[SNIPPETS_DIR]="${ZINIT[HOME_DIR]}/snippets"

# Path to autocompletion dump file
ZINIT[ZCOMPDUMP_PATH]="$ZSH_CACHE_DIR/.zcompdump"

# Plugins load mode
ZINIT[LOAD_MODE]=light

# Path to makefile dir
ZPFX="${ZINIT[HOME_DIR]}/polaris"

# Load
. $ZDOTDIR/zinit/zinit.zsh
zinit ice pick"async.zsh"
zinit $ZINIT[LOAD_MODE] mafredri/zsh-async

# Load the shell dotfiles
# rm -rf "${ZINIT[HOME_DIR]}/snippets/DF::core::functions"
zinit id-as'DF::core::functions' is-snippet for $ZDOTDIR/functions
zinit id-as'DF::core::aliases'   is-snippet for $ZDOTDIR/aliases

# Snippets
zinit snippet OMZP::sudo              # Press `ESC` twice to prefix previous or current console command
zinit snippet OMZP::alias-finder      # Learn existing aliases easily
zinit snippet OMZP::command-not-found # Suggest packages to be installed if a command cannot be found
zinit snippet OMZP::extract           # Defines `extract` function for wide variety of archive filetypes
zinit snippet OMZP::git               # Provides many aliases and a few useful functions for git
zinit snippet OMZP::gitignore         # Download gitignore.io templates from the command line
zinit ice atclone"sed -i '' -e 's/source/#/g' OMZP::macos" nocompile="!"
zinit snippet OMZP::macos             # Control macOS from command line

# Colors
zinit snippet OMZP::colored-man-pages # Adds colors to man pages
# ====================================================================================== #


# ====================================================================================== #
#                                PowerLevel 10K Theme                                    #
#   more at                                                                              #
#    https://github.com/romkatv/powerlevel10k/tree/master/config                         #
# ====================================================================================== #
() {
  # Unset default aliases
  setopt NO_ALIASES

  # Unset all configuration options. This allows you to apply configuration changes without
  # restarting zsh. Edit ~/.p10k.zsh and type `source ~/.p10k.zsh`.
  unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

  # The list of segments shown on the left. Fill it with the most important segments.
  declare -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=()

  # The list of segments shown on the right. Fill it with less important segments.
  # Right prompt on the last prompt line (where you are typing your commands) gets
  # automatically hidden when the input line reaches it. Right prompt above the
  # last prompt line gets hidden if it would overlap with left prompt.
  declare -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    status                  # exit code of the last command
    command_execution_time  # duration of the last command
    rust_version            # rustc version (https://www.rust-lang.org)
    java_version            # java version (https://www.java.com/)
    time                    # current time
  )

  # Defines character set used by powerlevel10k. It's best to let `p10k configure` set it for you.
  declare -g POWERLEVEL9K_MODE=nerdfont-complete
  # When set to `moderate`, some icons will have an extra space after them. This is meant to avoid
  # icon overlap when using non-monospace fonts. When set to `none`, spaces are not added.
  declare -g POWERLEVEL9K_ICON_PADDING=none

  # When set to true, icons appear before content on both sides of the prompt. When set
  # to false, icons go after content. If empty or not set, icons go before content in the left
  # prompt and after content in the right prompt.
  #
  # You can also override it for a specific segment:
  #
  #   POWERLEVEL9K_STATUS_ICON_BEFORE_CONTENT=false
  #
  # Or for a specific segment in specific state:
  #
  #   POWERLEVEL9K_DIR_NOT_WRITABLE_ICON_BEFORE_CONTENT=false
  declare -g POWERLEVEL9K_ICON_BEFORE_CONTENT=

  # Add an empty line before each prompt.
  declare -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=false

  # Separator between same-color segments on the left.
  declare -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR='\uE0B1'
  # Separator between same-color segments on the right.
  declare -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR='\uE0B3'
  # Separator between different-color segments on the left.
  declare -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR='\uE0B0'
  # Separator between different-color segments on the right.
  declare -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR='\uE0B2'
  # The right end of left prompt.
  declare -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL='\uE0B0'
  # The left end of right prompt.
  declare -g POWERLEVEL9K_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL='\uE0B2'
  # The left end of left prompt.
  declare -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=''
  # The right end of right prompt.
  declare -g POWERLEVEL9K_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL=''
  # Left prompt terminator for lines without any segments.
  declare -g POWERLEVEL9K_EMPTY_LINE_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=

  ##########################[ status: exit code of the last command ]###########################
  # Enable OK_PIPE, ERROR_PIPE and ERROR_SIGNAL status states to allow us to enable, disable and
  # style them independently from the regular OK and ERROR state.
  declare -g POWERLEVEL9K_STATUS_EXTENDED_STATES=true

  # Status on success. No content, just an icon. No need to show it if prompt_char is enabled as
  # it will signify success by turning green.
  declare -g POWERLEVEL9K_STATUS_OK=true
  declare -g POWERLEVEL9K_STATUS_OK_VISUAL_IDENTIFIER_EXPANSION='✔'
  # declare -g POWERLEVEL9K_STATUS_OK_FOREGROUND=2
  # declare -g POWERLEVEL9K_STATUS_OK_BACKGROUND=0

  # Status when some part of a pipe command fails but the overall exit status is zero. It may look
  # like this: 1|0.
  declare -g POWERLEVEL9K_STATUS_OK_PIPE=true
  declare -g POWERLEVEL9K_STATUS_OK_PIPE_VISUAL_IDENTIFIER_EXPANSION='✔'
  # declare -g POWERLEVEL9K_STATUS_OK_PIPE_FOREGROUND=2
  # declare -g POWERLEVEL9K_STATUS_OK_PIPE_BACKGROUND=0

  # Status when it's just an error code (e.g., '1'). No need to show it if prompt_char is enabled as
  # it will signify error by turning red.
  declare -g POWERLEVEL9K_STATUS_ERROR=true
  declare -g POWERLEVEL9K_STATUS_ERROR_VISUAL_IDENTIFIER_EXPANSION='✘'
  # declare -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=3
  # declare -g POWERLEVEL9K_STATUS_ERROR_BACKGROUND=1

  # Status when the last command was terminated by a signal.
  declare -g POWERLEVEL9K_STATUS_ERROR_SIGNAL=true
  # Use terse signal names: "INT" instead of "SIGINT(2)".
  declare -g POWERLEVEL9K_STATUS_VERBOSE_SIGNAME=false
  declare -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_VISUAL_IDENTIFIER_EXPANSION='✘'
  # declare -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_FOREGROUND=3
  # declare -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_BACKGROUND=1

  # Status when some part of a pipe command fails and the overall exit status is also non-zero.
  # It may look like this: 1|0.
  declare -g POWERLEVEL9K_STATUS_ERROR_PIPE=true
  declare -g POWERLEVEL9K_STATUS_ERROR_PIPE_VISUAL_IDENTIFIER_EXPANSION='✘'
  # declare -g POWERLEVEL9K_STATUS_ERROR_PIPE_FOREGROUND=3
  # declare -g POWERLEVEL9K_STATUS_ERROR_PIPE_BACKGROUND=1

  ###################[ command_execution_time: duration of the last command ]###################
  # Execution time color.
  declare -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=0
  declare -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND=3
  # Show duration of the last command if takes at least this many seconds.
  declare -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
  # Show this many fractional digits. Zero means round to seconds.
  declare -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
  # Duration format: 1d 2h 3m 4s.
  declare -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'
  # Custom icon.
  declare -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_VISUAL_IDENTIFIER_EXPANSION=
  # Custom prefix.
  # declare -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PREFIX='took '

  ####################[ java_version: java version (https://www.java.com/) ]####################
  # Java version color.
  declare -g POWERLEVEL9K_JAVA_VERSION_FOREGROUND=1
  declare -g POWERLEVEL9K_JAVA_VERSION_BACKGROUND=7
  # Show java version only when in a java project subdirectory.
  declare -g POWERLEVEL9K_JAVA_VERSION_PROJECT_ONLY=true
  # Show brief version.
  declare -g POWERLEVEL9K_JAVA_VERSION_FULL=false
  # Custom icon.
  # declare -g POWERLEVEL9K_JAVA_VERSION_VISUAL_IDENTIFIER_EXPANSION='⭐'

  #################[ rust_version: rustc version (https://www.rust-lang.org) ]##################
  # Rust version color.
  declare -g POWERLEVEL9K_RUST_VERSION_FOREGROUND=37
  # Show rust version only when in a rust project subdirectory.
  declare -g POWERLEVEL9K_RUST_VERSION_PROJECT_ONLY=true
  # Custom icon.
  #  declare -g POWERLEVEL9K_RUST_VERSION_VISUAL_IDENTIFIER_EXPANSION='⭐'

  ####################################[ time: current time ]####################################
  # Current time color.
  # declare -g POWERLEVEL9K_TIME_FOREGROUND=0
  # declare -g POWERLEVEL9K_TIME_BACKGROUND=7
  # Format for the current time: 09:51:02. See `man 3 strftime`.
  declare -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M:%S}'
  # If set to true, time will update when you hit enter. This way prompts for the past
  # commands will contain the start times of their commands as opposed to the default
  # behavior where they contain the end times of their preceding commands.
  declare -g POWERLEVEL9K_TIME_UPDATE_ON_COMMAND=false
  # Custom icon.
  declare -g POWERLEVEL9K_TIME_VISUAL_IDENTIFIER_EXPANSION=
  # Custom prefix.
  # declare -g POWERLEVEL9K_TIME_PREFIX='at '

  # Transient prompt works similarly to the builtin transient_rprompt option. It trims down prompt
  # when accepting a command line. Supported values:
  #
  #   - off:      Don't change prompt when accepting a command line.
  #   - always:   Trim down prompt when accepting a command line.
  #   - same-dir: Trim down prompt when accepting a command line unless this is the first command
  #               typed after changing current working directory.
  declare -g POWERLEVEL9K_TRANSIENT_PROMPT=off

  # Instant prompt mode.
  #
  #   - off:     Disable instant prompt. Choose this if you've tried instant prompt and found
  #              it incompatible with your zsh configuration files.
  #   - quiet:   Enable instant prompt and don't print warnings when detecting console output
  #              during zsh initialization. Choose this if you've read and understood
  #              https://github.com/romkatv/powerlevel10k/blob/master/README.md#instant-prompt.
  #   - verbose: Enable instant prompt and print a warning when detecting console output during
  #              zsh initialization. Choose this if you've never tried instant prompt, haven't
  #              seen the warning, or if you are unsure what this all means.
  declare -g POWERLEVEL9K_INSTANT_PROMPT=off

  # Hot reload allows you to change POWERLEVEL9K options after Powerlevel10k has been initialized.
  # For example, you can type POWERLEVEL9K_BACKGROUND=red and see your prompt turn red. Hot reload
  # can slow down prompt by 1-2 milliseconds, so it's better to keep it turned off unless you
  # really need it.
  declare -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true

  # Remove extra space without background on the right side of right prompt
  declare -g ZLE_RPROMPT_INDENT=0

  # If p10k is already loaded, reload configuration.
  # This works even with POWERLEVEL9K_DISABLE_HOT_RELOAD=true.
  (( ! $+functions[p10k] )) || p10k reload
}

declare -g POWERLEVEL9K_CACHE_DIR="$ZSH_CACHE_DIR/powerlevel"
mkd -e $POWERLEVEL9K_CACHE_DIR

# Tell `p10k configure` which file it should overwrite.
declare -g POWERLEVEL9K_CONFIG_FILE=${${(%):-%x}:a}

# Load theme
zinit ice depth"1" atclone"LC_ALL=C && LANG=C && sed -i '' -e 's|XDG_CACHE_HOME|POWERLEVEL9K_CACHE_DIR|g' **/*(D.)" atpull'%atclone' nocompile="!" lucid
zinit $ZINIT[LOAD_MODE] romkatv/powerlevel10k
# ====================================================================================== #



# ====================================================================================== #
#                            integrations                                                #
# ====================================================================================== #
. $ZDOTDIR/integrations


# ====================================================================================== #
#                            zsh fast syntax highlighting                                #
#   more at                                                                              #
#    https://github.com/zdharma-continuum/fast-syntax-highlighting                       #
# ====================================================================================== #
# Plugin home dir
declare -gx FAST_WORK_DIR="$ZSH_CACHE_DIR/zfsh"
mkd -e $FAST_WORK_DIR

# Theme
declare -gx FAST_THEME_NAME="default"

# Load
zinit ice wait lucid atinit"ZINIT[COMPINIT_OPTS]=-C; zpcompinit; zpcdreplay"
zinit $ZINIT[LOAD_MODE] zdharma-continuum/fast-syntax-highlighting
# ====================================================================================== #


# ====================================================================================== #
#                             zsh autosuggestions                                        #
#   more at                                                                              #
#    https://github.com/zsh-users/zsh-autosuggestions#configuration                      #
# ====================================================================================== #
# Style suggestion is shown with
declare -gx ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8,bold,underline"

# Disable automatic widget re-binding on each precmd
declare -gx ZSH_AUTOSUGGEST_MANUAL_REBIND="1"

# Suggestions strategy
declare -gx ZSH_AUTOSUGGEST_STRATEGY=(
  history    # Chooses the most recent match from history
  completion # Chooses a suggestion based on what tab-completion would suggest
)

# Disable suggestions for large buffers
declare -gx ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# Ignore history suggestions that match a pattern
declare -gx ZSH_AUTOSUGGEST_HISTORY_IGNORE="vpn *"

# Load
zinit ice wait lucid atload"_zsh_autosuggest_start"
zinit $ZINIT[LOAD_MODE] zsh-users/zsh-autosuggestions
# ====================================================================================== #


# ====================================================================================== #
#                           zsh completions                                              #
#   more at                                                                              #
#    https://github.com/zsh-users/zsh-completions                                        #
# ====================================================================================== #
zinit ice as"completion"
zinit snippet OMZP::macos/_security

zinit ice as"completion"
zinit snippet OMZP::docker/_docker

zinit ice blockf atpull'zinit creinstall -q .'
zinit $ZINIT[LOAD_MODE] zsh-users/zsh-completions
# ====================================================================================== #
