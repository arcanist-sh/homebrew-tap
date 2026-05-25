class Hx < Formula
  desc "Fast, opinionated Haskell toolchain CLI"
  homepage "https://arcanist.sh/hx/"
  version "0.6.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/arcanist-sh/hx/releases/download/v0.6.0/hx-v0.6.0-aarch64-apple-darwin.tar.gz"
      sha256 "275405aafb9399d27927dad87b2cf028986e34dd41057a1ddc912ec83c44fc2f"
    else
      url "https://github.com/arcanist-sh/hx/releases/download/v0.6.0/hx-v0.6.0-x86_64-apple-darwin.tar.gz"
      sha256 "40f940c80d9bb0dc8dc29246342dcbe861d2526541adb176f8f2fe78c6ef14e2"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/arcanist-sh/hx/releases/download/v0.6.0/hx-v0.6.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c662038440f5e2ffad9b95af5b9549e1890b4acb810cc0bdb5c7d9f8b73b39c5"
    else
      url "https://github.com/arcanist-sh/hx/releases/download/v0.6.0/hx-v0.6.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a0809674a42bdb56c48800037b46b8b136e4faaf0f239756987ce0d0163004e1"
    end
  end

  def install
    bin.install "hx"
  end

  test do
    assert_match "hx #{version}", shell_output("#{bin}/hx --version")
  end
end
