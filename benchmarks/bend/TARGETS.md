# Implementation map

The integrated working branch is `integration/main-bend-20260922`, rebased on
`origin/main` at `51a67c10ed`. Both canonical fork directories are present:
`collab/bend2-interactive-cubical/` and `collab/bend2-official-cubical/`.
The old `collab/bend2-cubical` path is a compatibility symlink, not another fork.
The public cubical fork provides a patch, runner and tests against public Bend
2.0.21 at `6018e28`; the measured official baseline is 2.0.25 at `a495242`.
Version alignment must be explicit before comparing their performance.

| Target ID | Lineage / execution | Source of truth or current location | Readiness |
|---|---|---|---|
| `official-public` | `bendlang/bend`, TypeScript compiler, C/Metal backend; new public Bend 2 | Pinned `a49524265bdfa5753a4bf38e25f0574a705dd868`; local copy under `local/toolchains/2026-09-21/bend-a49524265bdfa5753a4bf38e25f0574a705dd868` | Baseline complete; rerun adapter available |
| `cubical-inet` | Older Haskell Bend2 fork, cubical extensions, HVM interaction-net execution | [Patch series, examples and design](../../collab/bend2-interactive-cubical/README.md); working compiler at `research/biology_exact/build/toolchain/Bend2-f026483`; HVM3/HVM4 and runtime variants alongside it | Located; exact compiler/patch/runtime snapshot and workload ports required before measurement |
| `cubical-public` | Cubical fork of the new public TypeScript Bend compiler | `collab/bend2-official-cubical/` | Located as patch + runner + tests; based on `6018e28`, not baseline `a495242`; adapter and version alignment still needed |

Other similarly named directories:

- `integration/bend2_unison/` is Unison/UCM integration for the older fork. Its scripts
  directly reference `research/biology_exact/build/toolchain/Bend2-f026483`; moving that
  compiler would break those consumers.
- `collab/bend2-interactive-cubical/` contains the older fork's patch series, specifications and fixtures.
  It is not the new public TypeScript compiler.
- `research/` currently mixes experiment reports, applications and local toolchain builds.
  It does not identify a single Bend implementation. This campaign now has its own home.
- `interactive/` is not the official public Bend benchmark source.

No active compiler trees, patch series, runtime variants or integration paths were moved.
The directory name `Bend2-f026483` alone is not sufficient provenance: the working compiler
has local changes and is not an independently pinned Git checkout here.

## Contract for the upcoming comparisons

1. Snapshot each working compiler and selected runtime without changing its checkout. Record
   repository/commit where available, dirty patch or source hashes, build flags, executable
   hashes and the exact cubical/optimization mode. Select explicitly among the HVM runtime
   variants; do not choose whichever binary happens to be on PATH.
2. Keep the official workload suite pinned independently of the compiler. A public-fork
   adapter must use those same workloads, sizes, seeds, output checks and timing boundaries.
3. Port the 16 runtime and five checker cases for the older language explicitly. Record each
   port and validate semantics/output. A failed parse is unsupported, not a performance score.
   Do not substitute a smaller workload. Missing equivalents remain visibly unmeasured.
4. Separate compile/check time from execution, include memory and correctness, and record
   thread/backend choices. GPU-unavailable lanes are not CPU results. HVM interaction counts
   are useful within a specified runtime; they do not replace elapsed-time comparisons.
5. Distinguish unchanged ordinary workload performance from cubical-enabled rewrites. The
   stock suite may contain no structure that activates a cubical optimization. If optimized
   formulations are added, report their transformations and equivalence evidence separately.
6. Rerun the official baseline under the same current conditions. Measure repeated runs and
   interleave target order; historical single samples cannot establish small speedups.

The user describes the old fork as providing optimal execution. This organizational audit
does not independently establish that claim or predict a speedup on these workloads.
