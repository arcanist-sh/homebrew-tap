# homebrew-tap

Homebrew formulae for [arcanist.sh](https://arcanist.sh) tools.

```bash
brew install arcanist-sh/tap/hx
```

| Formula | What it is | Notes |
|---|---|---|
| [`hx`](Formula/hx.rb) | [hx](https://arcanist.sh/hx/), the whole Haskell toolchain in one fast binary | Installed as `hxs`, because the Helix editor in homebrew-core already provides an `hx` binary. Every command works the same under that name. Shell completions are included. |
| [`bhc`](Formula/bhc.rb) | [bhc](https://arcanist.sh/bhc/), the Basel Haskell Compiler | Still at 0.2.3 while it is brought up to the current release ([arcanist-sh/bhc#47](https://github.com/arcanist-sh/bhc/issues/47)). Until then, install bhc with `curl -fsSL https://arcanist.sh/bhc/install.sh \| sh` or `hx toolchain install --bhc 0.2.22`. |

The hx formula is updated from each hx release's `checksums.txt`.

To upgrade:

```bash
brew update && brew upgrade hx
```
