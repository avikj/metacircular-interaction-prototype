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

## Not yet independently rerun
- Executing the HVM4 emission on the HVM4 runtime (`@applyPath(_)(_)(@negPath)(1) => 0`)
  — HVM4 runtime being built here now.

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
A `--to-hvm4-raw` mode (no pre-normalisation) was added; its output does
not yet parse on HVM4 (see open items).

Checker regression after emitter changes: all 11 test files green (0 ✗);
`uaRoundTrip` still correctly fails.
