#!/bin/zsh
emulate -LR zsh

# ====================================================================================== #
#                          JDK, JVM and sbt integrations                                 #
# ====================================================================================== #
# Depends on .zshrc                                                                      #
# ====================================================================================== #
#  - jdk  = get or set current Java version                                              #
#  - sbtu = various sbt tools                                                            #
# ====================================================================================== #

# Java JDK utils
function jdk() {
  local usage=$(cat <<EOF
${fg_bold[blue]}Usage:${reset_color} jdk <version> ${fg[cyan]}Get current or change Java JDK version${reset_color}

${fg_bold[blue]}Options:${reset_color}
  ${fg_bold[yellow]}--init${reset_color}      ${fg[blue]}Set JAVA_HOME and PATH to the most up-to-date installed JDK version${reset_color}
  ${fg_bold[yellow]}--help${reset_color}      ${fg[blue]}Show help (this message) and exit${reset_color}

${fg_bold[blue]}Examples:${reset_color}
  jdk --init  ${fg[blue]}Initialize JAVA_HOME and PATH${reset_color}
  jdk         ${fg[blue]}Get current JDK version${reset_color}
  jdk 8       ${fg[blue]}Set JDK version to 1.8.0_x${reset_color}
  jdk 16      ${fg[blue]}Set JDK version to 16.0.x${reset_color}
  jdk graal   ${fg[blue]}Set JDK version to latest GraalVM${reset_color}
EOF
)

  switch() {
    if [[ ! -z "$JAVA_HOME" ]]; then
      path=(${(@)path:#$JAVA_HOME/bin})
    fi

    declare -gx JAVA_HOME=$(/usr/libexec/java_home -v "$1" 2> /dev/null)

    if [[ -d "$JAVA_HOME/bin" ]]; then
      path+=("$JAVA_HOME/bin")
      declare -aU path
    fi
  }

  case $1 in
    ([1-9])       switch "1.$1" ;;
    ([1-9][0-9])  switch $1 ;;
    (graal)       switch "$(/usr/libexec/java_home -V 2>&1 | grep -Eo '([0-9\.]+).+graalvm-..-java[0-9\.-]+-' | awk '{gsub(/,/,""); print $1}')" ;;
    (-i | --init) switch ;;
    (-h | --help) echo $usage ;;
    (*)           java -version ;;
  esac
}

# Initialize JAVA_HOME and PATH
jdk --init

# Utils for sbt
function sbtu() {
  zparseopts -D -E -F - l=latest -latest=latest h=help -help=help

  local usage=$(cat <<EOF
${fg_bold[blue]}Usage:${reset_color} sbt [options…] <command> ${fg[cyan]}Useful sbt tools${reset_color}

${fg_bold[blue]}Options:${reset_color}
  ${fg_bold[yellow]}--latest${reset_color}    ${fg[blue]}Use 'latest' artifact version instead of 'release'${reset_color}
  ${fg_bold[yellow]}--help${reset_color}      ${fg[blue]}Show help (this message) and exit${reset_color}

${fg_bold[blue]}Examples:${reset_color}
  sbtu update ${fg_bold[yellow]}--latest${reset_color}                ${fg[blue]}Perform sbt version update to 'latest' in current project${reset_color}
  sbtu cleanup                        ${fg[blue]}Completely remove sbt cache ('.target' dirs) in current project${reset_color}
  sbtu ideafix                        ${fg[blue]}Fix IntelliJ IDEA sbt configuration, including .sbt and .ivy dirs location move to ~/.config${reset_color}
  sbtu version org/domain/library_x.y ${fg[blue]}Get 'release' version of library published in Maven Central${reset_color}
  sbtu version ${fg_bold[yellow]}--latest${reset_color} scala         ${fg[blue]}Get 'latest' version of Scala Compiler published in Maven Central${reset_color}
  sbtu version sbt                    ${fg[blue]}Get 'release' version of sbt published in Maven Central${reset_color}
EOF
)

  fetch() {
    local ver=$([ "$2" -eq 1 ] && echo 'latest' || echo 'release')

    local lib
    case $1 in
      (sbt)   lib="org/scala-sbt/sbt" ;;
      (scala) lib="org/scala-lang/scala-compiler" ;;
      (*)     lib="$1" ;;
    esac

    echo $(curl -s "https://repo1.maven.org/maven2/$lib/maven-metadata.xml" | xmllint --xpath "/metadata/versioning/$ver/text()" -)
  }

  # show -d "    $1\n    ${#latest}\n    $2"

  if [ ${#help} = 1 ]; then
    echo $usage
  elif [[ $1 == "version" ]] && [[ "$2" != "" ]]; then
    show $(fetch "$2" ${#latest})
  elif [[ $1 == "update" ]]; then
    local ver=$(fetch "sbt" ${#latest})
    show "Setting project sbt version to $ver..."
    echo "sbt.version = $ver" > project/build.properties
  elif [[ $1 == "cleanup" ]]; then
    show "Clearing project sbt compilation cache..."
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
    show "Fixing IntelliJ IDEA sbt configuration..."
    echo $xml > .idea/sbt.xml
  else
    show -e "Incorrect args, use --help to learn more"
  fi
}
