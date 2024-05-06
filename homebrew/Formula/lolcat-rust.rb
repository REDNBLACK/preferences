class LolcatRust < Formula
  version "1.5.2"
  sha256 "a62dfd4031bdba4dad0a73e5d79a2b40b4d37057e1ce4bf9160c496cf771ab5f"

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
