class Hx < Formula
  desc "Fast, opinionated Haskell toolchain CLI"
  homepage "https://arcanist.sh/hx/"
  version "0.7.8"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/arcanist-sh/hx/releases/download/v0.7.8/hx-v0.7.8-aarch64-apple-darwin.tar.gz"
      sha256 "e53f6aac3a51ef930ea41dad416a60cb1bf9acf20004cc2bdf515fd5843cf48b"
    else
      url "https://github.com/arcanist-sh/hx/releases/download/v0.7.8/hx-v0.7.8-x86_64-apple-darwin.tar.gz"
      sha256 "a61a2ecc6e973de9d08dda3c44f5638728ef1abb13ccedb6a19ea7278fcd09d7"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/arcanist-sh/hx/releases/download/v0.7.8/hx-v0.7.8-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "add2d8aaff869f416ba40cf0d76cdaccd726d80a77fb85f8c4cefcd4e39349f5"
    else
      url "https://github.com/arcanist-sh/hx/releases/download/v0.7.8/hx-v0.7.8-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7dd8352744c802bab967a45642ed59efc77ce943c96a9cf3ff32ea2c69667020"
    end
  end

  def install
    bin.install "hx"
  end

  test do
    assert_match "hx #{version}", shell_output("#{bin}/hx --version")
  end
end
