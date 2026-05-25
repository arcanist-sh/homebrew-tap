class Bhc < Formula
  desc "Basel Haskell Compiler - native code Haskell compiler"
  homepage "https://arcanist.sh/bhc/"
  version "0.2.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/arcanist-sh/bhc/releases/download/v0.2.1/bhc-aarch64-darwin.tar.gz"
      sha256 "8d3ded8b7a1c6ef4942ea2086855a45d0299202b939ad84c735c355367a2887b"
    else
      odie "bhc is not available for Intel Macs. Apple Silicon required."
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/arcanist-sh/bhc/releases/download/v0.2.1/bhc-x86_64-linux.tar.gz"
      sha256 "d6de9a73c6be80beeb45fc6ab8b5c8624c83b12897e0a6db090f8858c9f128c3"
    else
      odie "bhc is not available for Linux ARM. x86_64 required."
    end
  end

  def install
    bin.install "bhc"
    lib.install "lib/libbhc_rts.a"
    pkgshare.install "examples" if File.directory?("examples")
  end

  def caveats
    <<~EOS
      To compile Haskell programs, bhc needs to find the RTS library.
      Add to your shell profile:

        export LIBRARY_PATH="#{opt_lib}:$LIBRARY_PATH"

      Example usage:

        echo 'main = putStrLn "Hello!"' > hello.hs
        bhc hello.hs -o hello
        ./hello
    EOS
  end

  test do
    assert_match "bhc", shell_output("#{bin}/bhc --version")
  end
end
