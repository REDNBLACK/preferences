class LolcatC < Formula
  desc "Faster lolcat implementation in CLang"
  homepage "https://github.com/jaseg/lolcat"
  url "https://github.com/jaseg/lolcat/archive/refs/tags/v1.2.tar.gz"
  sha256 "b6e1a0e24479fbdd4eb907531339e2cafc0c00b78d19caf70e8377b8b7546331"
  license "WTFPL"
  head "https://github.com/jaseg/lolcat.git", branch: "main"

  def install
    system "make", "DESTDIR=#{prefix}"
    bin.install "lolcat"
  end

  test do
    system "false"
  end
end
