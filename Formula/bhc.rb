class Bhc < Formula
  desc "Basel Haskell Compiler - native code Haskell compiler"
  homepage "https://arcanist.sh/bhc/"
  version "0.2.3"
  license "BSD-3-Clause"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/arcanist-sh/bhc/releases/download/v0.2.3/bhc-aarch64-darwin.tar.gz"
      sha256 "f4bb303bd1892958dbd7a12a3fbff7bda6149b9ce2f46597d99957e2ffeb53ee"
    else
      odie "bhc is not available for Intel Macs. Apple Silicon required."
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/arcanist-sh/bhc/releases/download/v0.2.3/bhc-x86_64-linux.tar.gz"
      sha256 "d621a962a4d18b2ba42ee26b62243ddcd090b1f930d104c144b1cba85f20e7f3"
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
