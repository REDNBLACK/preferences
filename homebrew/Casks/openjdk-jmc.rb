cask "openjdk-jmc" do
  version "8.1.0,07"
  sha256 "6719d9e9e22e3d456994e398c47b280090c2eff58dc4cb69f8b3d45713dfc29c"

  url "https://download.java.net/java/GA/jmc#{version.major}/#{version.after_comma}/binaries/jmc-#{version.before_comma}_osx-x64.tar.gz"
  name "JDK Mission Control"
  desc "Tools to manage, monitor, profile and troubleshoot Java applications"
  homepage "https://jdk.java.net/jmc/8"

  livecheck do
    url :homepage
    strategy :page_match do |page|
      match = page.match(%r{href=.*?/(\d+)/binaries/jmc-(\d+(?:\.\d+)*)_osx-x64.tar\.gz}i)
      next if match.blank?

      "#{match[2]},#{match[1]}"
    end
  end

  target_app = "jmc-#{version.before_comma}_osx-x64/JDK Mission Control.app".freeze

  binary "#{target_app}/Contents/MacOS/jmc"

  postflight do
    eclipse_dir = "#{staged_path}/#{target_app}/Contents/Eclipse"
    config_file = "#{eclipse_dir}/configuration/config.ini"
    system_command "/usr/bin/sed", args: ["-i", ".old", "-e", "s;@user.home/.jmc/;@user.home/.config/jmc/;", config_file]
  end

  zap trash: [
    '~/.config/jmc'
  ]

  caveats do
    depends_on_java "11"
  end
end
