class LolcatRust < Formula
  version "1.5.0"
  sha256 "fd83a337ae5c3027e60ae508331d2f328a833ec12bf9279ce89e9df99ab126bd"

  url "https://github.com/ur0/lolcat/archive/refs/heads/master.tar.gz"
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
