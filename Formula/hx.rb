class Hx < Formula
  desc "Fast, opinionated Haskell toolchain CLI"
  homepage "https://arcanist.sh/hx/"
  version "0.9.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/arcanist-sh/hx/releases/download/v0.9.1/hx-v0.9.1-aarch64-apple-darwin.tar.gz"
      sha256 "a73e90d7477fa8162bbc5e1c293b272407c624f3aedb4ec78989dd2a70dbca33"
    else
      url "https://github.com/arcanist-sh/hx/releases/download/v0.9.1/hx-v0.9.1-x86_64-apple-darwin.tar.gz"
      sha256 "19ece7a70bb7ccc41edc96bec02383591ae5d4149f882d7407a4a488b36f1979"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/arcanist-sh/hx/releases/download/v0.9.1/hx-v0.9.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "24efcd2c4e7596c70a8759eeb7a116e13d8834e4e4b9929b84fd704f62b73e11"
    else
      url "https://github.com/arcanist-sh/hx/releases/download/v0.9.1/hx-v0.9.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f005e671266933f7655aca92ed7125534a9fe537cd640eba87ca119adb3bc288"
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

