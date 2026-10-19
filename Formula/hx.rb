class Hx < Formula
  desc "Fast, opinionated Haskell toolchain CLI"
  homepage "https://arcanist.sh/hx/"
  version "0.9.3"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/arcanist-sh/hx/releases/download/v0.9.3/hx-v0.9.3-aarch64-apple-darwin.tar.gz"
      sha256 "86233e21395c4048c46021d449fb164e505138d61541b2c18c21042f99ba3422"
    else
      url "https://github.com/arcanist-sh/hx/releases/download/v0.9.3/hx-v0.9.3-x86_64-apple-darwin.tar.gz"
      sha256 "c63c763a1e9350102e896178317266b7d7c3f41030b643375b171cfd9d2994dc"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/arcanist-sh/hx/releases/download/v0.9.3/hx-v0.9.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "080e13ec5519dac557c29bb0405a4cf40d2b49d6880edabcde65b5a14e94fd93"
    else
      url "https://github.com/arcanist-sh/hx/releases/download/v0.9.3/hx-v0.9.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b3eeb066edef06018529457db83a4bdd90e74f9d67b0c3c8a585bc11c42ec461"
    end
  end

  def install
    # Installed as `hxs`, not `hx`: the Helix editor already provides an `hx`
    # binary and ships in homebrew-core, so `bin.install "hx"` fails at the
    # link step for anyone who has it. Homebrew formulae have no install-time
    # choice, so unlike install.sh we cannot detect and adapt -- we have to
    # pick one name for everyone.
    #
    # Rename rather than `conflicts_with "helix"`. Helix's own conflicts
    # (evil-helix, hex) are all editors, genuine alternatives to it; a Haskell
    # toolchain is not, and someone may reasonably want both. This follows the
    # same convention as fcrackzip renaming zipinfo to fcrackzipinfo.
    bin.install "hx" => "hxs"

    # Generate completions from the installed binary rather than shipping the
    # archive's copies: those are generated under the default name and would
    # register against `hx`, a command this install does not provide.
    (bash_completion/"hxs").write Utils.safe_popen_read("#{bin}/hxs", "completions", "generate", "bash")
    (fish_completion/"hxs.fish").write Utils.safe_popen_read("#{bin}/hxs", "completions", "generate", "fish")
    (zsh_completion/"_hxs").write Utils.safe_popen_read("#{bin}/hxs", "completions", "generate", "zsh")
  end

  def caveats
    <<~EOS
      Installed as `hxs` rather than `hx`, because the Helix editor already
      provides an `hx` binary. Every command works the same, spelled `hxs`.

      If you do not use Helix and want the shorter name:
        ln -s #{bin}/hxs $HOMEBREW_PREFIX/bin/hx
    EOS
  end

  test do
    # The version banner is named from argv[0] as of #19, so a binary
    # installed as hxs reports "hxs <version>", not "hx <version>".
    assert_match "hxs #{version}", shell_output("#{bin}/hxs --version")
  end
end

