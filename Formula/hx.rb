class Hx < Formula
  desc "Fast, opinionated Haskell toolchain CLI"
  homepage "https://arcanist.sh/hx/"
  version "0.9.2"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/arcanist-sh/hx/releases/download/v0.9.2/hx-v0.9.2-aarch64-apple-darwin.tar.gz"
      sha256 "4ce2d2435263d4842f9b55d4eaca66a41a00edf3412711dde7400c0f290d15ba"
    else
      url "https://github.com/arcanist-sh/hx/releases/download/v0.9.2/hx-v0.9.2-x86_64-apple-darwin.tar.gz"
      sha256 "04ecfcb49f0f1d6c1cf675c7d7a8524798be92d8429019403febca7ef049029c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/arcanist-sh/hx/releases/download/v0.9.2/hx-v0.9.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "fca32d43ed08fc1e9ac7ae316e64dff58997447f253da1745aeadbc3d60e2f4a"
    else
      url "https://github.com/arcanist-sh/hx/releases/download/v0.9.2/hx-v0.9.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b937f7afb97aa42da8355f53f1cb21729dd71d3f50d3bb95773657612e7ce258"
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

