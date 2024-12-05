class VideoToolbox < Formula
  desc "Various Tools for Video Encoding/Transcoding etc"
  url "https://evermeet.cx/ffmpeg/info/ffmpeg/snapshot"
  version "1.0.0"

  resource "ffmpeg" do
    version "117771-g07904231cb"
    url "https://evermeet.cx/ffmpeg/ffmpeg-#{version}.zip"
    sha256 "5a3e520646bc0c988309f394dca9cfd0c4222d15a3bdf7e93dd5569afd4364db"
  end

  resource "mkvtoolnix" do
    version "88.0"
    url "https://mkvtoolnix.download/macos/MKVToolNix-#{version}.dmg"
    sha256 "cd34c72b47726bfbab2b7a5bd74ef5a3d4e8ce7f77b123312c9c222dfe2fe306"
  end

  resource "subler" do
    version "1.8.4"
    url "https://github.com/SublerApp/Subler/releases/download/#{version}/Subler-#{version}.zip"
    sha256 "849d56bc14a030e8dfb194b299c5a962b9bd31539436677fed66a77ffa946f2b"
  end

  def caveats
    <<~EOS
      Subler .app file will be placed into:
        "#{prefix}"

      To launch Subler, execute in Terminal:
        #{bin/"Subler"}
    EOS
  end

  def install
    resource("ffmpeg").stage do
      path = Dir["*"]

      bin.install path.select { |f| File.executable? f }
    end

    resource("mkvtoolnix").stage do
      path = "*.app/Contents/MacOS"
      bins = ['mkvextract', 'mkvinfo', 'mkvmerge', 'mkvpropedit']

      man.install Dir["#{path}/man/*"]
      bin.install Dir["#{path}/*"].select { |f| (['libs'] + bins).include?(File.basename(f)) }
    end

    resource("subler").stage do
      Pathname.glob("../*.app") do |app|
        prefix.install app
        bin.write_exec_script prefix/app.basename/"Contents/MacOS"/app.stem
      end
    end
  end
end
