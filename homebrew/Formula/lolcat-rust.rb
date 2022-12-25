class LolcatRust < Formula
  version "1.3.1"
  sha256 "6eee67d2ceeb0443b5cbd285e320e8923c891fa0734815394339141b442a4d33"

  url "https://github.com/ur0/lolcat/archive/refs/tags/v#{version}.tar.gz"
  desc "Fastest and concurrency safe lolcat implementation in Rust"
  homepage "https://github.com/ur0/lolcat"
  license "MIT"
  head "https://github.com/ur0/lolcat.git"

  depends_on "rust" => :build

  def install
    # ENV.prepend_path "PATH", "/Users/rb/.config/cargo/bin"
    # system "rustup", "default", "stable"
    system "cargo", "install", *std_cargo_args
  end

  livecheck do
    url :stable
  end

  test do
    system "false"
  end
end
