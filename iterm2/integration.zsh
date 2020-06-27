# Path to installation directory
ITERM2_DIR="$XDG_CONFIG_HOME/iterm2"

# Resolve conflict with zsh themes changing PS1
ITERM2_SQUELCH_MARK="Yes"

# Install shell integration
if [ "${ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX-}""$TERM" != "screen" -a "${ITERM_SHELL_INTEGRATION_INSTALLED-}" = "" -a "$TERM" != linux -a "$TERM" != dumb ]; then
  ITERM_SHELL_INTEGRATION_INSTALLED=Yes
  ITERM2_SHOULD_DECORATE_PROMPT="1"

  # Indicates start of command output. Runs just before command executes.
  iterm2_before_cmd_executes() {
    printf "\033]133;C;\007"
  }

  iterm2_set_user_var() {
    printf "\033]1337;SetUserVar=%s=%s\007" "$1" $(printf "%s" "$2" | base64 | tr -d '\n')
  }

  # Users can write their own version of this method. It should call
  # iterm2_set_user_var but not produce any other output.
  # e.g., iterm2_set_user_var currentDirectory $PWD
  # Accessible in iTerm2 (in a badge now, elsewhere in the future) as
  # \(user.currentDirectory).
  whence -v iterm2_print_user_vars > /dev/null 2>&1
  if [ $? -ne 0 ]; then
    iterm2_print_user_vars() {
      true
    }
  fi

  iterm2_print_state_data() {
    printf "\033]1337;RemoteHost=%s@%s\007" "$USER" "${iterm2_hostname-}"
    printf "\033]1337;CurrentDir=%s\007" "$PWD"
    iterm2_print_user_vars
  }

  # Report return code of command; runs after command finishes but before prompt
  iterm2_after_cmd_executes() {
    printf "\033]133;D;%s\007" "$STATUS"
    iterm2_print_state_data
  }

  # Mark start of prompt
  iterm2_prompt_mark() {
    printf "\033]133;A\007"
  }

  # Mark end of prompt
  iterm2_prompt_end() {
    printf "\033]133;B\007"
  }

  # There are three possible paths in life.
  #
  # 1) A command is entered at the prompt and you press return.
  #    The following steps happen:
  #    * iterm2_preexec is invoked
  #      * PS1 is set to ITERM2_PRECMD_PS1
  #      * ITERM2_SHOULD_DECORATE_PROMPT is set to 1
  #    * The command executes (possibly reading or modifying PS1)
  #    * iterm2_precmd is invoked
  #      * ITERM2_PRECMD_PS1 is set to PS1 (as modified by command execution)
  #      * PS1 gets our escape sequences added to it
  #    * zsh displays your prompt
  #    * You start entering a command
  #
  # 2) You press ^C while entering a command at the prompt.
  #    The following steps happen:
  #    * (iterm2_preexec is NOT invoked)
  #    * iterm2_precmd is invoked
  #      * iterm2_before_cmd_executes is called since we detected that iterm2_preexec was not run
  #      * (ITERM2_PRECMD_PS1 and PS1 are not messed with, since PS1 already has our escape
  #        sequences and ITERM2_PRECMD_PS1 already has PS1's original value)
  #    * zsh displays your prompt
  #    * You start entering a command
  #
  # 3) A new shell is born.
  #    * PS1 has some initial value, either zsh's default or a value set before this script is sourced.
  #    * iterm2_precmd is invoked
  #      * ITERM2_SHOULD_DECORATE_PROMPT is initialized to 1
  #      * ITERM2_PRECMD_PS1 is set to the initial value of PS1
  #      * PS1 gets our escape sequences added to it
  #    * Your prompt is shown and you may begin entering a command.
  #
  # Invariants:
  # * ITERM2_SHOULD_DECORATE_PROMPT is 1 during and just after command execution, and "" while the prompt is
  #   shown and until you enter a command and press return.
  # * PS1 does not have our escape sequences during command execution
  # * After the command executes but before a new one begins, PS1 has escape sequences and
  #   ITERM2_PRECMD_PS1 has PS1's original value.
  iterm2_decorate_prompt() {
    # This should be a raw PS1 without iTerm2's stuff. It could be changed during command
    # execution.
    ITERM2_PRECMD_PS1="$PS1"
    ITERM2_SHOULD_DECORATE_PROMPT=""

    # Add our escape sequences just before the prompt is shown.
    # Use ITERM2_SQUELCH_MARK for people who can't mdoify PS1 directly, like powerlevel9k users.
    # This is gross but I had a heck of a time writing a correct if statetment for zsh 5.0.2.
    local PREFIX=""
    if [[ $PS1 == *"$(iterm2_prompt_mark)"* ]]; then
      PREFIX=""
    elif [[ "${ITERM2_SQUELCH_MARK-}" != "" ]]; then
      PREFIX=""
    else
      PREFIX="%{$(iterm2_prompt_mark)%}"
    fi
    PS1="$PREFIX$PS1%{$(iterm2_prompt_end)%}"
  }

  iterm2_precmd() {
    local STATUS="$?"
    if [ -z "${ITERM2_SHOULD_DECORATE_PROMPT-}" ]; then
      # You pressed ^C while entering a command (iterm2_preexec did not run)
      iterm2_before_cmd_executes
    fi

    iterm2_after_cmd_executes "$STATUS"

    if [ -n "$ITERM2_SHOULD_DECORATE_PROMPT" ]; then
      iterm2_decorate_prompt
    fi
  }

  # This is not run if you press ^C while entering a command.
  iterm2_preexec() {
    # Set PS1 back to its raw value prior to executing the command.
    PS1="$ITERM2_PRECMD_PS1"
    ITERM2_SHOULD_DECORATE_PROMPT="1"
    iterm2_before_cmd_executes
  }

  # If hostname -f is slow on your system set iterm2_hostname prior to
  # sourcing this script.
  if [ -z "${iterm2_hostname-}" ]; then
    iterm2_hostname=`hostname -f 2>/dev/null`
    # Some flavors of BSD (i.e. NetBSD and OpenBSD) don't have the -f option.
    if [ $? -ne 0 ]; then
      iterm2_hostname=`hostname`
    fi
  fi

  [[ -z ${precmd_functions-} ]] && precmd_functions=()
  precmd_functions=($precmd_functions iterm2_precmd)

  [[ -z ${preexec_functions-} ]] && preexec_functions=()
  preexec_functions=($preexec_functions iterm2_preexec)

  iterm2_print_state_data
  printf "\033]1337;ShellIntegrationVersion=11;shell=zsh\007"
fi

# Install utilites
if [[ -z "$ITERM_UTILS_INSTALLED" ]]; then
  ITERM_UTILS_INSTALLED="Yes"

  local UTILS_DIR="$ITERM2_DIR/utils"
  if [[ ! -e "$UTILS_DIR" ]]; then
    mkdir -p "$UTILS_DIR"
  fi

  local utils=(
    imgcat
    imgls
    it2api
    it2attention
    it2check
    it2copy
    it2dl
    it2getvar
    it2git
    it2setcolor
    it2setkeylabel
    it2ul
    it2universion
  )

  for util in "${utils[@]}"; do
    if [ ! -f "$UTILS_DIR/$util" ]; then
      print "[iTerm] Downloading $util..."
      curl -SsL "https://iterm2.com/utilities/$util" > "$UTILS_DIR/$util"
      chmod +x "$UTILS_DIR/$util"
    fi

    alias $util="$UTILS_DIR/$util"
  done
  unset util

  if [ ! -f "$UTILS_DIR/lolcat" ]; then
    print "[iTerm] Cloning lolcat ..."
    git clone -q "https://github.com/jaseg/lolcat.git" "$UTILS_DIR/lolcat_build"
    print "[iTerm] Building lolcat ..."
    make "$UTILS_DIR/lolcat_build/lolcat"
    cp -f "$UTILS_DIR/lolcat_build/lolcat" "$UTILS_DIR/lolcat"
    rm -rf "$UTILS_DIR/lolcat_build"
    chmod +x "$UTILS_DIR/lolcat"
  fi

  alias lolcat="$UTILS_DIR/lolcat"
fi