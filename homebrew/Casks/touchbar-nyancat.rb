cask "touchbar-nyancat" do
  version "0.0.2"
  sha256 :no_check

  url "https://github.com/avatsaev/touchbar_nyancat/releases/download/#{version}/touchbar_nyancat.app.zip"
  name "Touchbar Nyan Cat"
  desc "Stupid Nyan Cat animation on your +$2k MacBook Pro's Touchbar. Enjoy."
  homepage "https://github.com/avatsaev/touchbar_nyancat"

  app "touchbar_nyancat.app", target: "Touchbar Nyan Cat.app"
end
