class Hx < Formula
  desc "Fast, opinionated Haskell toolchain CLI"
  homepage "https://github.com/raskell-io/hx"
  version "0.4.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/raskell-io/hx/releases/download/v0.4.1/hx-v0.4.1-aarch64-apple-darwin.tar.gz"
      sha256 "bbac7322e6e229363c16494aef0dea5e8ec1615b0c5ae58b562a21ae58e030d7"
    else
      url "https://github.com/raskell-io/hx/releases/download/v0.4.1/hx-v0.4.1-x86_64-apple-darwin.tar.gz"
      sha256 "dd53121f3b447904d13069a248064f579ee66efb344f4e070c58362b7e2e471e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/raskell-io/hx/releases/download/v0.4.1/hx-v0.4.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a5fcb4b700fb52c36135a13c3996cf13176820ba919df1d439e06b4e85f453d9"
    else
      url "https://github.com/raskell-io/hx/releases/download/v0.4.1/hx-v0.4.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e10f1306737a81bff158ca90f19ceb160f92a7bf2fd3f6391474861c9b8d8a26"
    end
  end

  def install
    bin.install "hx"
  end

  test do
    assert_match "hx #{version}", shell_output("#{bin}/hx --version")
  end
end
