# What remains for complete cubical support — exact, audited, with locations

Audited by reading `Core/WHNF.hs`, `Core/Check.hs`, `Core/Type.hs`, the parser
and every backend, and by running probes. Every "missing" below was confirmed
by execution, not by reading. Paths are in the patched tree (`/tmp/Bend2`,
i.e. `cubical-paths.patch`). Fixed-in-this-pass items are marked DONE.

---

## A. Crashes — no catch-all, missing constructors (mechanical)

The SetQuotient HIT added five `Term` constructors (`Quo QCl QEq QSq QRec`)
that were never threaded through the exhaustive traversals. Each is a hard
`PatternMatchFail` at runtime, not a type error.

| function | file | status |
|---|---|---|
| `normal` | `Core/WHNF.hs` | **DONE** — 5 quotient cases added |
| `normalCap` | `Core/WHNF.hs` | **DONE** — same 5 (it is a copy of `normal`) |
| `occursMarker` | `Core/WHNF.hs` | **DONE** — crashed on any quotient inside a `coe` line |
| `mapSub` | `Core/WHNF.hs` | **DONE** — silently *skipped* quotients (no crash, wrong substitution under the Glue/coe marker) |
| `collapse` | `Core/Collapse.hs` | **TODO** — missing all 5 quotient **and** all 15 cubical constructors |
| `freeVars` | `Target/HVM.hs` | **TODO** — same; the HVM3 backend crashes on any cubical term |
| `emitFull` | `Target/HVM4Full.hs` | **TODO** — falls through, so `bend quotient.bend --to-hvm4-full` **crashes**. Quotients cannot reach the full runtime at all |
| `termToCT` | `Target/JavaScript.hs` | **TODO** — falls through; JS backend silently ignores cubical |

Reproduce the audit:
```
python3 - <<'P'   # lists every traversal handling >=20 Term ctors and what it misses
P
```
(the script is in this session's transcript; rerun after adding constructors).

---

## B. The big one: `hcomp` has NO type-directed rules except the universe

`whnfHCm` (`Core/WHNF.hs`) has exactly three outcomes: a face is `I1` → that
tube's cap; no live face → the base; the type is `Set` → a `Glue` type.
**Everything else returns the stuck term `HCm a live x`.** Confirmed failing
by probe: Π, Σ, Nat and Path all refuse to reduce.

This is the bulk of the remaining work and it is exactly transcription from
CCHM §4.3 / the cubicaltt reference implementation. Implement in this order,
because each uses the previous:

1. **`transp` with a cofibration.** `Coe` is `Coe line r s x` — four
   arguments, no face. CCHM needs `transp^A φ u0` where `A` is constant on
   `φ`. Required to state the Σ and Glue rules correctly. Either add a fifth
   field to `Coe` (touches every traversal above) or add a separate
   constructor.
2. **`comp`** (composition = coe + hcomp), one line once (1) exists:
   `comp^A [φ ↦ u] u0 = hcomp^{A 1} [φ ↦ coe^A_{i→1}(u i)] (coe^A_{0→1} u0)`.
   There is no surface syntax for it either — the parser has only
   `hcomp`, `hcompN`, `hfill`.
3. **`hfill` as a core operation.** It exists only as parser sugar
   (desugared to a `PLm` with `IAnd` tubes). The Σ rule needs it internally.
4. **`hcomp` in Π:**
   `hcomp^{Π(x:A)B} [φ ↦ u] u0 = λx. hcomp^{B x} [φ ↦ u i x] (u0 x)`
5. **`hcomp` in Σ:** first component by `hcomp^A`, second by `comp` along the
   *filled* first component (`hfill`), which is why (2) and (3) come first.
6. **`hcomp` in `Path`/`PathP`:** push into the path dimension and add the
   two endpoint faces:
   `hcomp^{PathP A u v} [φ ↦ p] p0 = <j> hcomp^{A j} [φ ↦ p i j, (j=0) ↦ u, (j=1) ↦ v] (p0 j)`
7. **`hcomp` in inductive types** (`Nat`, `Bit`, `Lst`, `Enu`, user `type`s):
   push through a constructor when every live face agrees on the head, e.g.
   `hcomp^Nat [φ ↦ suc n] (suc m) = suc (hcomp^Nat [φ ↦ n] m)`.
8. **`hcomp` in `Glue`** — the hardest rule in CCHM, and the only one whose
   `coe` counterpart is already done (`whnfCoe`'s `Glu` case). Until it
   exists, Glue types are Kan only for transport, not for composition.

Note the asymmetry: **`coe` is nearly complete** (Π, Σ, Path, ua, inverse
line, composite line, Glue, Sup, Lst, and rigid types all reduce);
**`hcomp` is nearly empty**. Anyone continuing should work only on `hcomp`.

---

## C. Primitives absent from the term language

| CCHM object | status |
|---|---|
| `Partial φ A` / `PartialP` | **absent** — no constructor. Systems exist only as the `[(face, tube)]` lists inside `HCm`/`Glu`, not as first-class partial elements |
| `Sub` / `A[φ ↦ u]`, `inS`, `outS` | **absent**. (`Core/Type.hs`'s `Sub` is a HOAS substitution marker, unrelated) |
| `comp` | **absent** (see B.2) |
| `transp` with φ | **absent** (see B.1) |
| interval de Morgan laws | present: `I0 I1 INot IAnd IOr`, with `∧` idempotence (`iSyntEq`). `∨` idempotence and the distributive laws are **not** normalised |
| face lattice | present as DNF (`faceDNF`, `restrictLits`, `facePairs`) |

---

## D. Higher inductive types

Only **SetQuotient**, and it is hardcoded as five constructors rather than
produced by a schema. `QSq` (squash) is an opaque set-truncation witness with
no computation rule.

Absent: any general HIT declaration form, the circle, suspensions, pushouts,
propositional/set truncation as types, and `coe`/`hcomp` rules for any HIT
other than the quotient's `qrec`. Adding a HIT today means adding
constructors to `Term` and threading them through every traversal in §A —
which is precisely why §A keeps recurring.

---

## E. Backend coverage

| target | cubical | quotients |
|---|---|---|
| `--to-hvm4-full` | complete (intervals, paths, types, `coe`, `hcomp` as data) | **crashes** |
| `--to-hvm4` / `--to-hvm4-raw` | erased/normalised | no |
| `--to-hvm` (HVM3) | `freeVars` crashes on cubical terms | no |
| JavaScript | silently drops cubical | no |

The full runtime also mirrors §B: its `@hcomp` gets stuck as `#HCm` for the
same reason the checker does, so implementing B.4–B.8 means writing each rule
**twice** — once in `whnfHCm`, once in `Target/HVM4Full.hs`.

---

## F. Not code — the honest caveats

- **Regularity is a syntactic heuristic.** `whnfCoe` decides "constant line,
  transport is the identity" by `not (occursMarker body)` — if the dimension
  variable does not literally occur. Sound but incomplete: a line that is
  semantically constant while mentioning `i` is not recognised.
- **No canonicity or normalisation theorem** for the layer. The rules were
  implemented and tested against the must-fail suite, never proved sound.
- **Two univalences coexist:** the primitive `Ua` constructor and `uaG`
  derived from `Glue`. They agree on the tested cases; nothing forces that.
- **Totality is a `--total` gate, not a typing rule**, and guardedness is a
  syntactic pass.

---

## G. Complete — do not redo

Interval and face algebra; `Path`/`PathP` with the typed endpoint law for
var- and Ref-headed spines; `coe` for Π, Σ, Path, ua, inverse and composite
lines, Glue, superposed lines, lists and rigid types; `hcomp` boundary
checking with per-cell restriction and adjacency; `hfill` sugar; `Glue`/
`glue`/`unglue` with boundary rules and the coherence obligation; `hcomp` in
`Set` reducing to `Glue`; univalence with a coherent round trip; the
SetQuotient recursor; genuine coinduction with a productivity classifier.
