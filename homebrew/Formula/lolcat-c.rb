class LolcatC < Formula
  version "1.5"
  sha256 "2af79bed90e0bda52ae500d16e7e7022037fad10c487c317e7f0ff17ec4b14f5"

  url "https://github.com/jaseg/lolcat/archive/refs/tags/v#{version}.tar.gz"
  desc "Faster lolcat implementation in CLang"
  homepage "https://github.com/jaseg/lolcat"
  license "WTFPL"
  head "https://github.com/jaseg/lolcat.git", branch: "main"

  def install
    system "make", "DESTDIR=#{prefix}"
    bin.install "lolcat"
  end

  livecheck do
    url :stable
  end

  test do
    system "false"
  end
end
