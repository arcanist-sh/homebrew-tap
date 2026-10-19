class Hx < Formula
  desc "Fast, opinionated Haskell toolchain CLI"
  homepage "https://arcanist.sh/hx/"
  version "0.10.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/arcanist-sh/hx/releases/download/v0.10.0/hx-v0.10.0-aarch64-apple-darwin.tar.gz"
      sha256 "37d57cae2600b8b5f120422e3b9f83f3f2aff8c8943a8a2a23881986d7055db5"
    else
      url "https://github.com/arcanist-sh/hx/releases/download/v0.10.0/hx-v0.10.0-x86_64-apple-darwin.tar.gz"
      sha256 "14c9018d362fff8f2a3af42ca94bdd0a75e2e70cd51ac8b506bc6baea68e7d00"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/arcanist-sh/hx/releases/download/v0.10.0/hx-v0.10.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "490daa7bfb0aa3077c67064ccd9b87877daa71f3b9d6179fe776c96225d56405"
    else
      url "https://github.com/arcanist-sh/hx/releases/download/v0.10.0/hx-v0.10.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a678a85acfdfa0ebbafad35f0295620d3d444dd2f96301103906650ec27baeaf"
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

