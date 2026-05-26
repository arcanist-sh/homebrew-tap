class Bhc < Formula
  desc "Basel Haskell Compiler - native code Haskell compiler"
  homepage "https://arcanist.sh/bhc/"
  version "0.2.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/arcanist-sh/bhc/releases/download/v0.2.2/bhc-aarch64-darwin.tar.gz"
      sha256 "a4065c1669aee4b5faab55596aa82dfbce6e52029b0eed1aa629491354b2d4a3"
    else
      odie "bhc is not available for Intel Macs. Apple Silicon required."
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/arcanist-sh/bhc/releases/download/v0.2.2/bhc-x86_64-linux.tar.gz"
      sha256 "cfd90504e6a6b141ec291cc4669eb18faa94e0235e61ba1602b51a7e44fcfbb5"
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
