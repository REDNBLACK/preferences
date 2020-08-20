# Initialize JAVA_HOME
if [[ -f /usr/libexec/java_home ]]; then
  export JAVA_HOME=$(/usr/libexec/java_home)
  export PATH=$JAVA_HOME/bin:$PATH
fi

# Change or get Java JDK version
function jdk() {
  local ver=$1

  if [[ $ver == "graal" ]]; then
    ver="$(/usr/libexec/java_home -V 2>&1 | grep -Eo '([0-9\.]+).+graalvm-..-java[0-9\.-]+-' | awk '{gsub(/,/,""); print $1}')"
  fi

  export JAVA_HOME=$(/usr/libexec/java_home -v "$ver")
  export PATH=$JAVA_HOME/bin:$PATH
  java -version
}

# Update sbt version to latest in current project
function sbt-latest() {
  local ver=$(curl -s https://repo1.maven.org/maven2/org/scala-sbt/sbt/maven-metadata.xml | xmllint --xpath '/metadata/versioning/latest/text()' -)
  # local latestscala=$(curl -s https://repo1.maven.org/maven2/org/scala-lang/scala-compiler/maven-metadata.xml | xmllint --xpath '/metadata/versioning/latest/text()' -)

  echo "sbt.version = $ver" > project/build.properties
}

# Clear sbt compilation cache in current project
function sbt-cleanup() {
  find . -name target -type d -prune -exec rm -r {} \;
}
