class VideoToolbox < Formula
  desc "Various Tools for Video Encoding/Transcoding etc"
  url "https://evermeet.cx/ffmpeg/info/ffmpeg/snapshot"
  version "1.0.0"

  resource "ffmpeg" do
    version "112969-g5475f665f6"
    url "https://evermeet.cx/ffmpeg/ffmpeg-#{version}.zip"
    sha256 "7893851ac916135f3b3b0da43366ed9257b235f57e41b21c635073ae7f51c820"
  end

  resource "mkvtoolnix" do
    version "81.0"
    url "https://mkvtoolnix.download/macos/MKVToolNix-#{version}.dmg"
    sha256 "ac80111db885d10258f4e4cd7382033f9f54db3f578b808cc66298bff201a951"
  end

  resource "subler" do
    version "1.7.5"
    url "https://bitbucket.org/galad87/subler/downloads/Subler-#{version}.zip"
    sha256 "3596dad190deae9dfcdd6bac68a477def27df407e97f6870553b4640c08fd0b6"
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
