cask "qktrx" do
  version "0.1.3"
  sha256 "35069b09c222ee923236434978161a14dc0efeb9068d0214121e26359a84bffe"

  url "https://github.com/kelev-games/qktrx-releases/releases/download/v#{version}/qktrx-#{version}-darwin-arm64.dmg"
  name "qktrx"
  desc "Course editor for 13 Duck Race"
  homepage "https://github.com/kelev-games/qktrx-releases"

  auto_updates true
  depends_on arch: :arm64, macos: :ventura

  app "qktrx.app"
end
