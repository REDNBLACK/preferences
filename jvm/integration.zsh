# Initialize JAVA_HOME
if [[ -f /usr/libexec/java_home ]]; then
  export JAVA_HOME=$(/usr/libexec/java_home)
  # launchctl setenv JAVA_HOME $JAVA_HOME
fi

# Change or get Java JDK version
function jdk() {
  local version=$1

  if [[ $version == "graal" ]]; then
    version=$(/usr/libexec/java_home -V 2>&1 | grep -Eo '([0-9\.]+),.+graalvm-..-java[0-9\.-]+-' | awk '{gsub(/,/,""); print $1}')
  fi

  if [[ $version != "" ]]; then
    export JAVA_HOME=$(/usr/libexec/java_home -v"$version")
  fi

  java -version
}

# Update sbt version to latest in current project
function sbt-latest() {
  local v=$(curl -s https://repo1.maven.org/maven2/org/scala-sbt/sbt/maven-metadata.xml | xmllint --xpath '/metadata/versioning/latest/text()' -)
  # local latestscala=$(curl -s https://repo1.maven.org/maven2/org/scala-lang/scala-compiler/maven-metadata.xml | xmllint --xpath '/metadata/versioning/latest/text()' -)

  echo "sbt.version = $v" > project/build.properties
}

# Clear sbt compilation cache in current project
function sbt-cleanup() {
  find . -name target -type d -prune -exec rm -r {} \;
}
