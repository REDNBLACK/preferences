#!/bin/zsh
emulate -LR zsh

# ====================================================================================== #
#                          Rust & Cargo integrations                                     #
# ====================================================================================== #
# Depends on .zshrc                                                                      #
# ====================================================================================== #

# Homedir for rustup
declare -gx RUSTUP_HOME="$XDG_CACHE_HOME/rustup"

# Homedir for cargo
declare -gx CARGO_HOME="$XDG_CONFIG_HOME/cargo"

# Append to PATH
if [[ -d "$CARGO_HOME/bin" ]]; then
  path+=("$CARGO_HOME/bin")
  declare -aU path
fi
