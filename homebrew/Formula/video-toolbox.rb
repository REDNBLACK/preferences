class VideoToolbox < Formula
  desc "Various Tools for Video Encoding/Transcoding etc"
  url "https://evermeet.cx/ffmpeg/info/ffmpeg/snapshot"
  version "1.0.0"

  resource "ffmpeg" do
    version "111772-g8653dcaf7d"
    url "https://evermeet.cx/ffmpeg/ffmpeg-#{version}.zip"
    sha256 "f62bea50cf29d2deee5ee4641b1eeeaf3cd0b777ddcbae83957ec2094983050a"
  end

  resource "mkvtoolnix" do
    version "78.0"
    url "https://mkvtoolnix.download/macos/MKVToolNix-#{version}.dmg"
    sha256 "6be03a526bbf4673575b0639bce28ec9a02c122195e2134596da26cd31922b8e"
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
