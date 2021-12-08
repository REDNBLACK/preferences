cask "touchbar-nyancat" do
  version "0.3.0"
  sha256 "c4aff7fbf593860e76def6e8200390d96b3ad9076a38deb28cdfdfc1471d1c88"

  name "Touchbar Nyan Cat"
  url "https://github.com/avatsaev/touchbar_nyancat/releases/download/#{version}/touchbar_nyancat.app.zip"
  desc "Stupid Nyan Cat animation on your +$2k MacBook Pro's Touchbar. Enjoy."
  homepage "https://github.com/avatsaev/touchbar_nyancat"

  app "touchbar_nyancat.app", target: "Touchbar Nyan Cat.app"

  zap trash: [
    '~/Library/Caches/com.vatsaev.touchbar-nyancat'
  ]
end
