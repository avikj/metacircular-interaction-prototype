# 0799 — The pinned toolchain exists here. The root is green; `Sl2TensorProduct` is not.

2026-08-15, Claude (pinned-toolchain pass, branch
`claude/collaborative-subagents-loop-ekfugp`).

Short version, for anyone who reads one paragraph: **Agda 2.8.0 and cubical
v0.9 can be obtained in this container** — about 75 minutes, no exotic
tooling. Under them, `agda NaturalMachine.agda` **exits 0**. The
`PathIsSymmetry` / `SymGroup` failure that 0791 refused to "fix" was exactly
the v0.5 skew it was diagnosed as, and the un-edited file is correct. But the
same run found a module that is **green under 2.6.3/v0.5 and red under the
pin**: `Sl2TensorProduct.agda`, which 0798 published two hours ago.

## How

- **cubical v0.9**: `git clone --depth 1 --branch v0.9
  https://github.com/agda/cubical /root/agda-libs/cubical-v0.9`. The proxy
  permits github.com. The existing v0.5 clone and `~/.agda/libraries` were
  **not touched**; v0.9 is selected per-run with `--library-file`.
- **v0.9 alone is useless.** It uses `opaque` blocks; Agda 2.6.3 parse-errors
  inside `Cubical/Foundations/Structure.agda:28`, i.e. in the library, before
  any repo module. v0.8 parses under 2.6.3 but fails on unsolved metas in
  `Cubical/Categories/`, so there is no usable halfway house. (Bonus fact:
  `Symmetric-Group` → `SymGroup` is a **v0.8 → v0.9** rename.)
- **Agda 2.8.0**: `apt-get install cabal-install` (3.8.1.0), `cabal update`,
  `cabal get Agda-2.8.0`, `cabal build exe:agda --ghc-options=-j4` against the
  system GHC 9.4.7 (2.8.0's `tested-with` says 9.4.8; 9.4.7 built it clean).
  Two traps: `cabal install Agda-2.8.0` fails under cabal 3.8 in its sdist
  step ("Could not find module: Agda.Benchmarking") — use `cabal get` +
  `cabal build`; and the binary looks for its `prim` bundle in
  `~/.cabal/share/x86_64-linux-ghc-9.4.7/Agda-2.8.0`, which `cabal build`
  never populates, so `src/data/` must be copied there by hand.
- All runs in a scratchpad **copy** of `formal/cubical`, so no v0.9 interface
  entered the repo's `_build`. `LC_ALL=C.UTF-8` throughout — still mandatory
  under 2.8.0.

## Results

| module | 2.6.3 / v0.5 | 2.8.0 / v0.9 |
|---|---|---|
| `NaturalMachine.agda` (root) | 42 | **0** |
| `Everything.agda` | 42 | **42** (new cause) |
| `StagewiseComposite` · `SimplicialDefectFailure` · `Sl2DivisorLattice` | 0 | **0** |
| `NaturalMachine/{DecategorifiedDefect,RepairTorsor,FillabilityCertificate,LineWorldTransport}` | 0 | **0** |
| `NaturalMachine/Control/QuantifierDrop` (control) | 42 | **42 — still the intended `[UnequalTerms]` at line 80** |
| `PolarityClosure` | 42 | **42 — `[ClashingDefinition] Sub`, against the 2.8.0 builtin** |
| `Sl2TensorProduct` | **0** | **42** |

The v0.5 column is my own re-run, not a quotation; all eleven numbers
reproduced 0791's table exactly. The root run has 186
`UnsupportedIndexedMatch` warnings (F39) and zero errors.

## The two things worth arguing about

**1. `PolarityClosure`'s open question is closed, and the answer is bad.**
0791 recorded "whether 2.8.0 still brings `Sub` into scope at this import set
is exactly what I cannot settle". It does: `Multiple definitions of Sub.
Previous definition at Agda-2.8.0/lib/prim/Agda/Builtin/Cubical/Sub.agda`.
Not a skew artefact — a real defect under the pin. Whoever is renaming that
identifier: you are fixing a real thing, not appeasing an old compiler.

**2. `Sl2TensorProduct.agda:115` uses `·Rid`, which v0.9 spells `·IdR`.**
`Cubical.Data.Int.Properties.·Rid` is at `Int/Properties.agda:417` in v0.5 and
at line 1184 as `·IdR` in v0.9. One error, one token. This is what makes
`Everything.agda` red under the pin — and because it aborts there,
`Everything.agda` checks nothing imported after it, so its exit code says
nothing about the modules downstream. Expect more of these in the unswept
tree.

0798's claim is not withdrawn: the module does check under 2.6.3/v0.5, and
0798 explicitly flagged the pin check as outstanding. That flag was
load-bearing, and the discipline of writing it is what let this pass be a
half-hour of running rather than an argument. But no claim about
`Sl2TensorProduct` should now be made without naming the toolchain.

**I did not fix it, deliberately.** Renaming `·Rid` → `·IdR` makes the file
right under the pin and wrong under the only `/usr/bin/agda` in this
container — the mirror image of the trade 0791 refused. Which toolchain the
sources track is an owner's decision and should be made once for the tree,
not file by file by whichever agent last ran a build. Recorded, not repaired.

## Scope limits

- Twelve modules against the pin, not the tree. Given `·Rid`, the prior
  should now be that other unswept modules are red under the pin too.
- "The pin" here means Agda 2.8.0 **built from Hackage against GHC 9.4.7**
  plus cubical v0.9 at tag `b150186d`. Not a distributed binary.
- The pinned Agda lives in a session scratchpad and **is not installed** as
  `/usr/bin/agda`, which is still 2.6.3. What survives this pass is the result
  table and the recipe, not an environment.
- One naming deviation: upstream v0.9's `.agda-lib` names itself
  `cubical-0.9` while `natural-machine.agda-lib` says `depend: cubical`. I
  renamed that field **in my own v0.9 clone**. Anyone reproducing must do the
  same. No repository source was modified by this pass — only
  `notes/TOOLCHAIN_SKEW_AND_COVERAGE.md` §6 and a new section at the end of
  `formal/cubical/BUILD.md`, both by addition.
