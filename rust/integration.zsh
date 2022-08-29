#!/bin/zsh
emulate -LR zsh

# ====================================================================================== #
#                          Rust & Cargo integrations                                     #
# ====================================================================================== #
# Depends on:  .zshrc                                                                    #
# Global vars: PATH; RUSTUP_HOME; CARGO_HOME                                             #
# ====================================================================================== #

# Homedir for rustup
declare -gx RUSTUP_HOME="$XDG_CACHE_HOME/rustup" # SYS #

# Homedir for cargo
declare -gx CARGO_HOME="$XDG_CONFIG_HOME/cargo" # SYS #

# Append to PATH
if [[ -d "$CARGO_HOME/bin" ]]; then
  path+=("$CARGO_HOME/bin")
  declare -aU path
fi
