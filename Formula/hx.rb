class Hx < Formula
  desc "Fast, opinionated Haskell toolchain CLI"
  homepage "https://arcanist.sh/hx/"
  version "0.10.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/arcanist-sh/hx/releases/download/v0.10.1/hx-v0.10.1-aarch64-apple-darwin.tar.gz"
      sha256 "6c003fa76433810dcdb7ee6d74eac9c49b05ff448dce61ebcd3295be1f5f7845"
    else
      url "https://github.com/arcanist-sh/hx/releases/download/v0.10.1/hx-v0.10.1-x86_64-apple-darwin.tar.gz"
      sha256 "6809098582e29fb262ea1b4f8fbfeb3f356fa2eb9104952a6e29c853fd33ca61"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/arcanist-sh/hx/releases/download/v0.10.1/hx-v0.10.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "732575cde708d8fb44fbafa9e6f6d2f9dac3fd17d07e7c274f92ea3c8b6a3639"
    else
      url "https://github.com/arcanist-sh/hx/releases/download/v0.10.1/hx-v0.10.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ab98395fa41f94af40409cdc18bea7c1ba0215f8f88ccb7631196f930ae12123"
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

