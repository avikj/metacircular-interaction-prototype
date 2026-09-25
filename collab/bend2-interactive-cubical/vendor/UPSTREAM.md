# Vendored sources

The compiler and runtime live here as ordinary source, edited by ordinary
commits.

| Tree | Upstream | Base commit |
|---|---|---|
| `Bend2/` | https://github.com/DKormann/Bend2 | `f026483` |
| `HVM4/src/hvm.c` | https://github.com/HigherOrderCO/HVM4 | `6defdfc7dae2a3cca5dd6e74ed0612385b5646a8` |

HVM3 is used unmodified as a Haskell library dependency of Bend2
(`fba2e9c82faf6e2f019c9ecea94c32f19a8b7820`); `build.sh` clones it and adds
the two missing C includes of its FFI aggregator.

Bend2's upstream CLAUDE.md is not vendored. HVM4 carried no license file at
the base commit; its README is kept for provenance.

To see everything changed relative to upstream:

    git clone https://github.com/DKormann/Bend2 /tmp/b && git -C /tmp/b checkout f026483
    diff -ru /tmp/b/src vendor/Bend2/src
    git clone https://github.com/HigherOrderCO/HVM4 /tmp/h && git -C /tmp/h checkout 6defdfc
    diff -u /tmp/h/src/hvm.c vendor/HVM4/src/hvm.c
