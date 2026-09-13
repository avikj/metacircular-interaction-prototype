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
