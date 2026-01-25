class Bhc < Formula
  desc "Basel Haskell Compiler - native code Haskell compiler"
  homepage "https://bhc.raskell.io"
  version "0.1.0-alpha"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/raskell-io/bhc/releases/download/v0.1.0-alpha/bhc-aarch64-darwin.tar.gz"
      sha256 "bf46daf71653ab394ee7dff38f8745e0e03bdebb59ddfb8db83b5007a41585d0"
    else
      odie "bhc is not available for Intel Macs. Apple Silicon required."
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/raskell-io/bhc/releases/download/v0.1.0-alpha/bhc-x86_64-linux.tar.gz"
      sha256 "c12ef7740cc2c50becc0d30d7b1087a9d46ee2f89823591dc76b3b6c02075a52"
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
