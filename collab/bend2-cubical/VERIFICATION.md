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
   (`packages: . /tmp/HVM3` in cabal.project) — editing the cached
   source-repository-package copy does not rebuild the store artifact.
2. **`LC_ALL=C.utf8` is mandatory for the build**: HVM3 embeds `.c` files via
   Template Haskell (`embedStringFile`); `prim/DUP.c` contains a UTF-8 byte
   and `hGetContents` fails under a non-UTF-8 locale.
3. `bend` has no `check` subcommand — `bend check f.bend` prints usage and
   exits 0 (a silent false-positive if used as a test). Use `bend f.bend`.

## Independently reproduced (correct invocation, exit code + ✓/✗ counted)

| file | rc | ✓ | ✗ |
|---|---|---|---|
| examples/main.bend (stock) | 0 | 39 | 0 |
| cubical_test.bend | 0 | 11 | 0 |
| cubical_test2.bend | 0 | 10 | 0 |
| cubical_test3.bend | 0 | 12 | 0 |
| cubical_test4.bend (Sup×Path) | 0 | 8 | 0 |
| cubical_test5.bend | 0 | 7 | 0 |
| applypath.bend | 0 | 9 | 0 |
| pth2.bend (nonconstant Path family transport) | 0 | 2 | 0 |
| pthtransport.bend | 0 | 3 | 0 |
| loop.bend | 0 | 2 | 0 |

- `uaroundtrip.bend`: `✗ uaRoundTrip — Mismatch`. The other round trip
  `pathToIso(ua e) = e` at the raw `Iso5` level FAILS, as CORRECTIONS states.
  The narrowed claim ("iso-univalence with the path-side round trip") is right.
- `loop.bend`: `loop` tagged `[unchecked]` (was a `[total]` false positive).
- Native runtime (HVM3 `hvm`, arithmetic baseline): `rt.bend --to-hvm` runs:
  result correct, **304 interactions**, 0.42 ms.
- `applypath.bend --to-hvm4` emits `@applyPath = λb0 λb1 λb2 λb3. b2(b3)`,
  `@transId = λb0. b0`, `@transNeg = λb0. (neg)(b0)`: transport lowers to
  *applying* the path's forward function, not erased.
- `applypath.bend --to-hvm` (HVM3 target): **crashes** —
  `Non-exhaustive patterns in function go` (Target/HVM.hs). The HVM3 backend
  has no cubical lowering; only HVM4 does.


## Native execution — verified on BOTH runtimes (this session)

Fix applied to both emitters (Target/HVM.hs = HVM3, Target/HVM4.hs = HVM4):
a universe path is represented at runtime as a **Church pair (fwd, bwd)**;
`ua(A,B,f,g,…)` ⟶ `λk. k(f)(g)`; `coe(λi. p@i, i0,i1, x)` ⟶ `@cub_pathFwd(p)(x)`;
`coe(…, i1,i0, y)` ⟶ `@cub_pathBwd(p)(y)`; a constant type line `<_> A` ⟶
`@cub_idPath`. This closes two real gaps in the prior emitter: `@pathBwd`
was referenced but never defined, and `ua` lowered to `f` alone (dropping
`g`), so backward transport was unrepresentable. Helpers are prefixed
`cub_` because bare prelude names clashed with user definitions (`idPath`).
The HVM3 target previously crashed on any cubical term (non-exhaustive
`go`); it now lowers the full cubical layer.

Runtime results, path supplied as **runtime data** (not pre-reduced):

| program | HVM4 (C runtime) | HVM3 (`hvm run`) |
|---|---|---|
| `@applyPath(*)(*)(@negPath)(1)` | `0`, **11 interactions** | — |
| `@applyPath(*)(*)(@negPath)(0)` | `1`, **10 interactions** | — |
| `t_fwd_neg` (coe i0→i1 along ua(neg), True) | `0` | `0`, 18 interactions |
| `t_bwd_neg` (coe i1→i0 along ua(neg), True) | `0` | `0`, 18 interactions |
| `t_fwd_id`  (coe i0→i1 along `<_>Bool`, True) | `1` | `1`, 17 interactions |
| `t_bwd_id`  (coe i1→i0 along `<_>Bool`, True) | `1` | `1`, 17 interactions |

A cubical program's transport — forward AND backward — reaches and reduces
on the interaction net; it is applied, not erased. Note: the HVM4 default
emitter pre-normalises in Haskell (`normal 0 book`), so *closed* transports
arrive as literals (0 interactions); the nonzero counts above come from the
path being a function argument. HVM3's emitter does not pre-normalise.
A `--to-hvm4-raw` mode (no pre-normalisation) was added and verified below.

Checker regression after emitter changes: all 11 test files green (0 ✗);
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

**`--to-hvm4-raw` (no compile-time normalisation — the net performs the
cubical reduction):** emitted `@applyPathFwd = λb0 λb1 λb2 λb3. @cub_pathFwd(b2)(b3)`,
`@negPath = (λb0. b0(@neg)(@neg))`, `@main = @applyPathFwd(&{})(&{})(@negPath)(1)`.

| program | HVM4 raw | HVM3 |
|---|---|---|
| t_fwd_neg | 0, 11 itrs | 0, 18 itrs |
| t_bwd_neg | 0, 11 itrs | 0, 18 itrs |
| t_fwd_id  | 1, 9 itrs  | 1, 17 itrs |
| t_bwd_id  | 1, 9 itrs  | 1, 17 itrs |

(With the default normalising HVM4 emitter the same four programs give the
same values at 0 interactions: closed transports are pre-reduced in Haskell.
The raw-mode and runtime-argument rows are the genuine on-net transports.)

Checker regression on the final binary: examples/main 39✓, cubical_test 11✓,
test2 10✓, test3 12✓, test4 8✓, test5 7✓, applypath 9✓, applypath_bwd 11✓,
pth2 2✓, pthtransport 3✓, loop 2✓ ([unchecked]), equiv 7✓ — 0 ✗ anywhere;
uaRoundTrip still correctly fails.

## Status against the review's list
- Native execution of cubical transport, both directions, on TWO runtimes: **done, measured.**
- Pth transport through nonconstant families (`pth2.bend`): **reproduced.**
- Totality false-positive (`loop.bend` → `[unchecked]`): **reproduced.**
- "Univalence complete" → narrowed; reverse round trip fails at raw Iso level: **reproduced**; `equiv.bend` (coherent isEquiv, idEquiv) typechecks as the foundation for the coherent statement.
- Backward transport (`@pathBwd` undefined; `ua` dropped `g`): **found and fixed.**
- HVM3 target crashing on cubical terms: **found and fixed.**
- Build blockers (HVM3 Runtime.c includes; UTF-8 locale; `bend check` false-positive): **found, fixed, documented.**

## Addendum — coherent reverse univalence round trip (verified by execution)

`bend uaequiv.bend` (with `LC_ALL=C.utf8`; without it bend aborts with
`hGetContents: invalid argument` on any UTF-8 source and prints nothing —
count ✓/✗ only under that locale):

    17 ✓  0 ✗   incl. isPropIsContr, isPropIsEquiv (definitional), retC, uaE,
                pathToEquiv, uaEquivRoundTrip

Regression on the same binary: applypath 9, applypath_bwd 11, corpus_calculus 10,
corpus_lossless 8, cubical_test 11/10/12/8/7, hcompfaces 5, isprop 3, loop 2,
pth2 2, run_corpus 4, t_* 7×4, all 0 ✗; uaroundtrip 4✓ 1✗ (raw-Iso reverse
trip, expected); equiv.bend 7✓ 1✗ (its binary-hcomp probe, expected);
stock examples 2/2.

Must-fail guard (`uaequiv_mustfail.bend`): `wrong1` (constant path `(f,h)`)
and `wrong2` (endpoints swapped) both ✗ on the same binary; everything else in
the file ✓. The round-trip green is not a checker hole.

## Addendum — fibre law as coherent Equiv, transported natively (`fibrelaw.bend`)

`bend fibrelaw.bend`: 32 ✓ 0 ✗ (isoToIsEquiv via lemIso with 4-face hcompN,
totalEquiv, losslessPath = uaE(totalEquiv), present/retrieve with refl laws).
Runtime, raw net: HVM4 presentNeg True⇒0 (83), False⇒1 (76); retrieveNeg
True⇒1, False⇒0 (118 each). HVM3: 102/93/140/140, same values. Full suite on
this binary: every other file unchanged, `equiv.bend` now 10✓ 0✗,
`uaequiv_mustfail.bend` wrong1/wrong2 still ✗, stock examples 2/2. Details:
FIBRE_LAW.md.
