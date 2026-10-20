class Hx < Formula
  desc "Whole Haskell toolchain in one fast binary"
  homepage "https://arcanist.sh/hx/"
  version "0.11.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/arcanist-sh/hx/releases/download/v0.11.0/hx-v0.11.0-aarch64-apple-darwin.tar.gz"
      sha256 "a35658b529de9484805b4ac12df4e87b75d079abaf0ef737f84de57c49236ee5"
    else
      url "https://github.com/arcanist-sh/hx/releases/download/v0.11.0/hx-v0.11.0-x86_64-apple-darwin.tar.gz"
      sha256 "a6184ee81906a4887242fad10e98460599c8b7d9e31e520f59cdf7e9bd646306"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/arcanist-sh/hx/releases/download/v0.11.0/hx-v0.11.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c60dd15a68d1fb343ec0909f32c1e75ac827cb8d3fa778a6b6d50b4cd912b423"
    else
      url "https://github.com/arcanist-sh/hx/releases/download/v0.11.0/hx-v0.11.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1342cf60ac338e258293aaf0c3ff758a91398d1b84f46684ad5b671423971a20"
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

