# Independent verification (this session, fresh environment)

Environment: Ubuntu 24.04, 4 cores, GHC 9.12.2 + cabal 3.18 (ghcup),
`LC_ALL=C.utf8`. Upstream DKormann/Bend2 @ f026483 (2025-07-07) + the
current `cubical-paths.patch` (main @ 1e03559a1). HVM3 built from
HigherOrderCO/HVM3 HEAD (2026-01-29) as a LOCAL package.

## Build fixes required (not previously documented)

1. **HVM3 `Runtime.c` does not include `reduce/ref.c` / `reduce/ref_sup.c`**
   (added upstream, never wired into the include list). The `hvm` executable
   fails to link: `undefined reference to reduce_ref_sup` / `reduce_ref`.
   Fix: add
   ```c
   #include "runtime/reduce/ref.c"
   #include "runtime/reduce/ref_sup.c"
   ```
   after `dup_una.c` in `src/HVM/Runtime.c`. HVM3 must be a local package
   (`packages: . /tmp/HVM3` in cabal.project) ‚î editing the cached
   source-repository-package copy does not rebuild the store artifact.
2. **`LC_ALL=C.utf8` is mandatory for the build**: HVM3 embeds `.c` files via
   Template Haskell (`embedStringFile`); `prim/DUP.c` contains a UTF-8 byte
   and `hGetContents` fails under a non-UTF-8 locale.
3. `bend` has no `check` subcommand ‚î `bend check f.bend` prints usage and
   exits 0 (a silent false-positive if used as a test). Use `bend f.bend`.

## Independently reproduced (correct invocation, exit code + ‚ì/‚ó counted)

| file | rc | ‚ì | ‚ó |
|---|---|---|---|
| examples/main.bend (stock) | 0 | 39 | 0 |
| cubical_test.bend | 0 | 11 | 0 |
| cubical_test2.bend | 0 | 10 | 0 |
| cubical_test3.bend | 0 | 12 | 0 |
| cubical_test4.bend (SupóPath) | 0 | 8 | 0 |
| cubical_test5.bend | 0 | 7 | 0 |
| applypath.bend | 0 | 9 | 0 |
| pth2.bend (nonconstant Path family transport) | 0 | 2 | 0 |
| pthtransport.bend | 0 | 3 | 0 |
| loop.bend | 0 | 2 | 0 |

- `uaroundtrip.bend`: `‚ó uaRoundTrip ‚î Mismatch`. The other round trip
  `pathToIso(ua e) = e` at the raw `Iso5` level FAILS, as CORRECTIONS states.
  The narrowed claim ("iso-univalence with the path-side round trip") is right.
- `loop.bend`: `loop` tagged `[unchecked]` (was a `[total]` false positive).
- Native runtime (HVM3 `hvm`, arithmetic baseline): `rt.bend --to-hvm` runs:
  result correct, **304 interactions**, 0.42 ms.
- `applypath.bend --to-hvm4` emits `@applyPath = Œªb0 Œªb1 Œªb2 Œªb3. b2(b3)`,
  `@transId = Œªb0. b0`, `@transNeg = Œªb0. (neg)(b0)`: transport lowers to
  *applying* the path's forward function, not erased.
- `applypath.bend --to-hvm` (HVM3 target): **crashes** ‚î
  `Non-exhaustive patterns in function go` (Target/HVM.hs). The HVM3 backend
  has no cubical lowering; only HVM4 does.


## Native execution ‚î verified on BOTH runtimes (this session)

Fix applied to both emitters (Target/HVM.hs = HVM3, Target/HVM4.hs = HVM4):
a universe path is represented at runtime as a **Church pair (fwd, bwd)**;
`ua(A,B,f,g,‚¶)` ‚ü `Œªk. k(f)(g)`; `coe(Œªi. p@i, i0,i1, x)` ‚ü `@cub_pathFwd(p)(x)`;
`coe(‚¶, i1,i0, y)` ‚ü `@cub_pathBwd(p)(y)`; a constant type line `<_> A` ‚ü
`@cub_idPath`. This closes two real gaps in the prior emitter: `@pathBwd`
was referenced but never defined, and `ua` lowered to `f` alone (dropping
`g`), so backward transport was unrepresentable. Helpers are prefixed
`cub_` because bare prelude names clashed with user definitions (`idPath`).
The HVM3 target previously crashed on any cubical term (non-exhaustive
`go`); it now lowers the full cubical layer.

Runtime results, path supplied as **runtime data** (not pre-reduced):

| program | HVM4 (C runtime) | HVM3 (`hvm run`) |
|---|---|---|
| `@applyPath(*)(*)(@negPath)(1)` | `0`, **11 interactions** | ‚î |
| `@applyPath(*)(*)(@negPath)(0)` | `1`, **10 interactions** | ‚î |
| `t_fwd_neg` (coe i0‚íi1 along ua(neg), True) | `0` | `0`, 18 interactions |
| `t_bwd_neg` (coe i1‚íi0 along ua(neg), True) | `0` | `0`, 18 interactions |
| `t_fwd_id`  (coe i0‚íi1 along `<_>Bool`, True) | `1` | `1`, 17 interactions |
| `t_bwd_id`  (coe i1‚íi0 along `<_>Bool`, True) | `1` | `1`, 17 interactions |

A cubical program's transport ‚î forward AND backward ‚î reaches and reduces
on the interaction net; it is applied, not erased. Note: the HVM4 default
emitter pre-normalises in Haskell (`normal 0 book`), so *closed* transports
arrive as literals (0 interactions); the nonzero counts above come from the
path being a function argument. HVM3's emitter does not pre-normalise.
A `--to-hvm4-raw` mode (no pre-normalisation) was added and verified below.

Checker regression after emitter changes: all 11 test files green (0 ‚ó);
`uaRoundTrip` still correctly fails.

## Final matrix (rebuilt binary; all runs this session)

HVM4 = HigherOrderCO/HVM4 @ 6defdfc, built `gcc -O2 src/hvm.c`. HVM3 = the
patched `hvm` above. `*` is HVM4's erasure literal.

**Generic `applyPath`, path supplied as a runtime argument (HVM4):**

| call | result | interactions |
|---|---|---|
| `@applyPath(*)(*)(@negPath)(1)` | 0 | 11 |
| `@applyPath(*)(*)(@negPath)(0)` | 1 | 10 |
| `@applyPath(*)(*)(@idPath)(1)`  | 1 | 9  |
| `@applyPath(*)(*)(@idPath)(0)`  | 0 | 9  |

**`--to-hvm4-raw` (no compile-time normalisation ‚î the net performs the
cubical reduction):** emitted `@applyPathFwd = Œªb0 Œªb1 Œªb2 Œªb3. @cub_pathFwd(b2)(b3)`,
`@negPath = (Œªb0. b0(@neg)(@neg))`, `@main = @applyPathFwd(&{})(&{})(@negPath)(1)`.

| program | HVM4 raw | HVM3 |
|---|---|---|
| t_fwd_neg | 0, 11 itrs | 0, 18 itrs |
| t_bwd_neg | 0, 11 itrs | 0, 18 itrs |
| t_fwd_id  | 1, 9 itrs  | 1, 17 itrs |
| t_bwd_id  | 1, 9 itrs  | 1, 17 itrs |

(With the default normalising HVM4 emitter the same four programs give the
same values at 0 interactions: closed transports are pre-reduced in Haskell.
The raw-mode and runtime-argument rows are the genuine on-net transports.)

Checker regression on the final binary: examples/main 39‚ì, cubical_test 11‚ì,
test2 10‚ì, test3 12‚ì, test4 8‚ì, test5 7‚ì, applypath 9‚ì, applypath_bwd 11‚ì,
pth2 2‚ì, pthtransport 3‚ì, loop 2‚ì ([unchecked]), equiv 7‚ì ‚î 0 ‚ó anywhere;
uaRoundTrip still correctly fails.

## Status against the review's list
- Native execution of cubical transport, both directions, on TWO runtimes: **done, measured.**
- Pth transport through nonconstant families (`pth2.bend`): **reproduced.**
- Totality false-positive (`loop.bend` ‚í `[unchecked]`): **reproduced.**
- "Univalence complete" ‚í narrowed; reverse round trip fails at raw Iso level: **reproduced**; `equiv.bend` (coherent isEquiv, idEquiv) typechecks as the foundation for the coherent statement.
- Backward transport (`@pathBwd` undefined; `ua` dropped `g`): **found and fixed.**
- HVM3 target crashing on cubical terms: **found and fixed.**
- Build blockers (HVM3 Runtime.c includes; UTF-8 locale; `bend check` false-positive): **found, fixed, documented.**

## Addendum ‚î coherent reverse univalence round trip (verified by execution)

`bend uaequiv.bend` (with `LC_ALL=C.utf8`; without it bend aborts with
`hGetContents: invalid argument` on any UTF-8 source and prints nothing ‚î
count ‚ì/‚ó only under that locale):

    17 ‚ì  0 ‚ó   incl. isPropIsContr, isPropIsEquiv (definitional), retC, uaE,
                pathToEquiv, uaEquivRoundTrip

Regression on the same binary: applypath 9, applypath_bwd 11, corpus_calculus 10,
corpus_lossless 8, cubical_test 11/10/12/8/7, hcompfaces 5, isprop 3, loop 2,
pth2 2, run_corpus 4, t_* 7ó4, all 0 ‚ó; uaroundtrip 4‚ì 1‚ó (raw-Iso reverse
trip, expected); equiv.bend 7‚ì 1‚ó (its binary-hcomp probe, expected);
stock examples 2/2.

Must-fail guard (`uaequiv_mustfail.bend`): `wrong1` (constant path `(f,h)`)
and `wrong2` (endpoints swapped) both ‚ó on the same binary; everything else in
the file ‚ì. The round-trip green is not a checker hole.

## Addendum ‚î fibre law as coherent Equiv, transported natively (`fibrelaw.bend`)

`bend fibrelaw.bend`: 32 ‚ì 0 ‚ó (isoToIsEquiv via lemIso with 4-face hcompN,
totalEquiv, losslessPath = uaE(totalEquiv), present/retrieve with refl laws).
Runtime, raw net: HVM4 presentNeg True‚í0 (83), False‚í1 (76); retrieveNeg
True‚í1, False‚í0 (118 each). HVM3: 102/93/140/140, same values. Full suite on
this binary: every other file unchanged, `equiv.bend` now 10‚ì 0‚ó,
`uaequiv_mustfail.bend` wrong1/wrong2 still ‚ó, stock examples 2/2. Details:
FIBRE_LAW.md.

## Addendum ‚î hfill, --total gate, endpoint-resolving emission

- `hfill.bend`: 4 ‚ì (`hf`, `hf_face`, library `fill0` via hfill, main) and the
  must-fail `wrong` (tube not starting at base) ‚ó.
- `bend loop.bend --total` ‚í `--total: refused, [unchecked]: loop`, exit 1;
  `bend fibrelaw.bend --total` ‚í every definition [total]/[productive], exit 0.
- `fibrelaw.bend` now 35 ‚ì 0 ‚ó (adds `contrNeg0/1`: the fibre-contraction
  path of `neg` over `True`, observed at both ends). HVM4-raw: both ‚í `0`
  (False; the fibre of neg over True is {False}), 18 itrs; HVM3: `0`, 23 itrs.
  Both emitters now resolve a literal endpoint `p @ i0/i1` by `force` before
  erasing the interval (previously the erased body ‚î for an hcomp, its cap ‚î
  was emitted), so these observations are compile-time endpoint resolution
  followed by net reduction; earlier native matrix (t_*, present/retrieve)
  unchanged: 0/0/1/1 and 0/1/1/0.
- Whole suite on this binary (27 files): 0 ‚ó except the three deliberate
  must-fails (`uaequiv_mustfail` wrong1/wrong2, `uaroundtrip` raw-Iso,
  `hfill` wrong); stock examples 2/2.

## Addendum ‚î runtime path algebra (`chain.bend`, RUNTIME_ALGEBRA.md)

`chain.bend` 19 ‚ì. Twelve closed transports along composite (`hcomp` in Set),
inverse, Œ† and Œ lines: normaliser, `--to-hvm4-raw` and `--to-hvm` agree on
every value; HVM4-raw interactions 19/19 (two equivalences), 31/30 (three),
13/12 (inverse), 20/19 (Œ†), 20/19 (Œ) vs 10‚ì11 for one bare `ua`. Raw mode
now refuses (error naming the line) any coe line outside the algebra instead
of emitting cap/identity. Regression on this binary: 28 files, 0 ‚ó except the
three deliberate must-fails; examples 2/2; prior raw matrices unchanged
(t_* 0/0/1/1; present/retrieve 0/1/1/0; contr 0/0).
