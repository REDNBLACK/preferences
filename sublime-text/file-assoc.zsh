#!/bin/zsh
emulate -LR zsh

# ====================================================================================== #
#                          Sublime Text files association setup                          #
# ====================================================================================== #
print_info "Setting Sublime Text file associations..."

() {
  local utis=$(cat <<EOF
    com.apple.property-list
    public.css
    public.html
    public.json
    public.plain-text
    public.rtf
    public.shell-script
    public.source-code
    public.xhtml
    public.xml
    public.yaml
    bashrc
    bat
    cfg
    cmd
    conf
    default
    groovy
    hs
    inc
    inf
    ini
    jsonl
    jsonp
    jsp
    kt
    lng
    make
    markdown
    md
    nfo
    properties
    rc
    reg
    sbt
    scala
    sql
    src
    toml
    ts
    usr
    vbs
EOF
)

  echo $utis | awk '{print "com.sublimetext.4", $1, "all"}' | duti -v
}
