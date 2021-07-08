class LolcatC < Formula
  desc "Faster lolcat implementation in CLang"
  homepage "https://github.com/jaseg/lolcat"
  url "https://github.com/jaseg/lolcat/archive/refs/tags/v1.2.tar.gz"
  version "1.2"
  sha256 ""
  license "WTFPL"
  head "https://github.com/jaseg/lolcat.git"

  def install
    system "make", "DESTDIR=#{prefix}", "install"
    bin.install "lolcat"
  end

  test do
    system "false"
  end
end
