class LolcatC < Formula
  version "1.4"
  sha256 "6ea43ee2b2bb2f15fc91812b72ebcdaa883052853ed8f055b6f8b38637bda909"

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
