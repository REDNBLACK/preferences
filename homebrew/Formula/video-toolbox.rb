class VideoToolbox < Formula
  desc "Various Tools for Video Encoding/Transcoding etc"
  url "https://evermeet.cx/ffmpeg/info/ffmpeg/snapshot"
  version "1.0.0"

  resource "ffmpeg" do
    version "112061-g654e4b00e2"
    url "https://evermeet.cx/ffmpeg/ffmpeg-#{version}.zip"
    sha256 "de002f07a22cfb8a979b045fb6e069a981c9e69bc9fb1b174481c708201774df"
  end

  resource "mkvtoolnix" do
    version "79.0"
    url "https://mkvtoolnix.download/macos/MKVToolNix-#{version}.dmg"
    sha256 "93f69fb341f5384475b2c4ded26f2dc990f273a4e95cbca5729a9b87d967be18"
  end

  resource "subler" do
    version "1.7.5"
    url "https://bitbucket.org/galad87/subler/downloads/Subler-#{version}.zip"
    sha256 "3596dad190deae9dfcdd6bac68a477def27df407e97f6870553b4640c08fd0b6"
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
      libexec.mkpath
      Pathname.glob("../*.app") do |app|
        mv app.realpath, libexec/"#{app.basename(".app")}.app"
      end
    end
  end
end
