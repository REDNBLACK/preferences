#!/bin/zsh
emulate -LR zsh

# ====================================================================================== #
#                          JDK, JVM and sbt integrations                                 #
#                                                                                        #
#  - jdk = get or set current Java version                                               #
#  - sbt = various sbt tools                                                             #
# ====================================================================================== #

# Initialize JAVA_HOME
if [[ -f /usr/libexec/java_home ]]; then
  typeset -gx JAVA_HOME=$(/usr/libexec/java_home)
  typeset -gx PATH=$JAVA_HOME/bin:$PATH
fi

# Java JDK utils
function jdk() {
  zparseopts -D -E -F - h=help -help=help

  local usage=$(cat <<EOF
${fg_bold[blue]}Usage:${reset_color} jdk <version> ${fg[cyan]}Get current or change Java JDK version${reset_color}

${fg_bold[blue]}Options:${reset_color}
  ${fg_bold[yellow]}--help${reset_color}      ${fg[blue]}Show help (this message) and exit${reset_color}

${fg_bold[blue]}Examples:${reset_color}
  jdk         ${fg[blue]}Get current JDK version${reset_color}
  jdk 1.8     ${fg[blue]}Set JDK version to 1.8.0_x${reset_color}
  jdk 8       ${fg[blue]}Set JDK version to 1.8.0_x${reset_color}
  jdk 16      ${fg[blue]}Set JDK version to 16.0.x${reset_color}
  jdk graal   ${fg[blue]}Set JDK version to latest GraalVM${reset_color}
EOF
)

  if [[ ${#help} = 1 ]]; then
    echo $usage
  elif [[ "$1" != "" ]]; then
    local ver="$1"
    if [[ $ver = "graal" ]]; then
      ver="$(/usr/libexec/java_home -V 2>&1 | grep -Eo '([0-9\.]+).+graalvm-..-java[0-9\.-]+-' | awk '{gsub(/,/,""); print $1}')"
    elif [[ $ver -gt 1.8 && $ver -le 8 ]]; then
      ver="1.$ver"
    fi

    print_info "Setting JDK version to $ver..."
    typeset -gx JAVA_HOME=$(/usr/libexec/java_home -v "$ver")
    typeset -gx PATH=$JAVA_HOME/bin:$PATH
  else
    java -version
  fi
}

# Utils for sbt
function sbt() {
  zparseopts -D -E -F - l=latest -latest=latest h=help -help=help

  local usage=$(cat <<EOF
${fg_bold[blue]}Usage:${reset_color} sbt [options…] <command> ${fg[cyan]}Useful sbt tools${reset_color}

${fg_bold[blue]}Options:${reset_color}
  ${fg_bold[yellow]}--latest${reset_color}    ${fg[blue]}Use 'latest' artifact version instead of 'release'${reset_color}
  ${fg_bold[yellow]}--help${reset_color}      ${fg[blue]}Show help (this message) and exit${reset_color}

${fg_bold[blue]}Examples:${reset_color}
  sbt update ${fg_bold[yellow]}--latest${reset_color}                ${fg[blue]}Perform sbt version update to 'latest' in current project${reset_color}
  sbt cleanup                        ${fg[blue]}Completely remove sbt cache ('.target' dirs) in current project${reset_color}
  sbt ideafix                        ${fg[blue]}Fix IntelliJ IDEA sbt configuration, including .sbt and .ivy dirs location move to ~/.config${reset_color}
  sbt version org/domain/library_x.y ${fg[blue]}Get 'release' version of library published in Maven Central${reset_color}
  sbt version ${fg_bold[yellow]}--latest${reset_color} scala         ${fg[blue]}Get 'latest' version of Scala Compiler published in Maven Central${reset_color}
  sbt version sbt                    ${fg[blue]}Get 'release' version of sbt published in Maven Central${reset_color}
EOF
)

  function lib_ver() {
    local ver=$([ "$2" = '1' ] && echo 'latest' || echo 'release')

    local lib="$1"
    if [[ $lib == "scala" ]]; then
      lib="org/scala-lang/scala-compiler"
    elif [[ $lib == "sbt" ]]; then
      lib="org/scala-sbt/sbt"
    fi

    echo $(curl -s "https://repo1.maven.org/maven2/$lib/maven-metadata.xml" | xmllint --xpath "/metadata/versioning/$ver/text()" -)
  }

  # print_debug "    $1\n    ${#latest}\n    $2"

  if [ ${#help} = 1 ]; then
    echo $usage
  elif [[ $1 == "update" ]]; then
    local ver=$(lib_ver "sbt" $latest)
    print_info "Setting project sbt version to $ver..."
    echo "sbt.version = $ver" > project/build.properties
  elif [[ $1 == "version" ]] && [[ "$2" != "" ]]; then
    echo $(lib_ver "$2" $latest)
  elif [[ $1 == "cleanup" ]]; then
    print_info "Clearing project sbt compilation cache..."
    find . -name target -type d -prune -exec rm -r {} \;
  elif [[ $1 == "ideafix" ]]; then
    local xml=$(cat <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<project version="4">
  <component name="ScalaSbtSettings">
    <option name="customVMEnabled" value="true" />
    <option name="linkedExternalProjectsSettings">
      <SbtProjectSettings>
        <option name="externalProjectPath" value="\$PROJECT_DIR\$" />
        <option name="modules">
          <set>
            <option value="\$PROJECT_DIR\$" />
            <option value="\$PROJECT_DIR\$/project" />
          </set>
        </option>
        <option name="resolveSbtClassifiers" value="true" />
        <option name="useSbtShellForBuild" value="true" />
        <option name="useSbtShellForImport" value="true" />
        <option name="enableDebugSbtShell" value="true" />
      </SbtProjectSettings>
    </option>
    <option name="maximumHeapSize" value="4096" />
    <option name="vmParameters" value="-Dsbt.global.base=$XDG_CONFIG_HOME/sbt -Dsbt.ivy.home=$XDG_CONFIG_HOME/ivy2" />
  </component>
</project>
EOF
)
    print_info "Fixing IntelliJ IDEA sbt configuration..."
    echo $xml > .idea/sbt.xml

  else
    print_err "Incorrect args, use --help to learn more"
  fi
}
