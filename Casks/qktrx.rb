cask "qktrx" do
  version "0.1.2"
  sha256 "147b3c4728a1375c8d8aa7e6a4f1c91b89bf67af5546b9ba3be372e5c2d505cd"

  url "https://github.com/kelev-games/qktrx-releases/releases/download/v#{version}/qktrx-#{version}-darwin-arm64.dmg"
  name "qktrx"
  desc "Course editor for 13 Duck Race"
  homepage "https://github.com/kelev-games/qktrx-releases"

  auto_updates true
  depends_on arch: :arm64, macos: :ventura

  app "qktrx.app"
end
