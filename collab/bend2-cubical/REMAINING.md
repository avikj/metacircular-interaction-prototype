# What remains for complete cubical support — exact, audited, with locations

**State: sections A, B, C and E are closed. Section D has three working HITs
(set-quotient, circle, propositional truncation); a general HIT *schema* is
the only substantive item left, plus the one Glue law that needs
face-restricted contexts to state. Suite: 88 files, bad = 0.**

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
| `collapse` | `Core/Collapse.hs` | **DONE** — all 5 quotient + all 15 cubical constructors added |
| `freeVars` | `Target/HVM.hs` | **DONE** — same; the HVM3 backend no longer crashes on cubical terms |
| `emitFull` | `Target/HVM4Full.hs` | **TODO** — falls through, so `bend quotient.bend --to-hvm4-full` **crashes**. Quotients cannot reach the full runtime at all |
| `termToCT` | `Target/JavaScript.hs` | **TODO** — falls through; JS backend silently ignores cubical |

Reproduce the audit:
```
python3 - <<'P'   # lists every traversal handling >=20 Term ctors and what it misses
P
```
(the script is in this session's transcript; rerun after adding constructors).

---

## B. `hcomp`'s type-directed rules — MOSTLY DONE

`whnfHCm` previously had three outcomes only: a true face, no live face, or
the universe. Everything else was stuck. Now implemented, in both the checker
(`Core/WHNF.hs`) and the full runtime (`Target/HVM4Full.hs`):

| rule | checker | runtime | test |
|---|---|---|---|
| Π — pointwise in the codomain | DONE | DONE | `kan.bend` `hcPi` |
| PathP — push into the path dimension, endpoints become extra faces | DONE | DONE | `kan.bend` `hcPath` |
| Σ — first by `hcomp`, second by `comp` along the *filled* first | DONE | DONE | `kan.bend` `hcSig` |
| Nat / List — push through a common constructor head | DONE | DONE | `kan.bend` `hcNat` |
| Bit / Enum / Unit — discrete, the common nullary constructor | DONE | DONE | — |
| `Set` — reduces to `Glue` | DONE | DONE | `hcompset.bend` |
| **Glue** | DONE* | DONE* | `glue_kan.bend` (*partial, see below) |

`comp` and `hfill` now exist as core operations in both (`compAt`/`hfillAt`,
`@compAt`/`@hfillAt`), together with projections that reduce on a pair.
Constructor-headedness of a *line* is decided by applying it at a marker
dimension, the idiom `coe` already used for its regularity check.

Each rule is stated in `kan.bend` as a definitional equation, so the file
passes only if the rule actually fires; `kan_mustfail.bend` guards against
proving false ones. All eleven cubical programs produce byte-identical values
and interaction counts on the full runtime after the change.

**\*The Glue rule is implemented but only partly verified.** It follows CCHM:
compose inside each partial type `T` (where `Glue` *is* `T`), compose the
UNGLUED tube in `A` with one extra face per φ forcing `f` of the `T`-filler,
then glue the φ-parts onto the `A`-part. Verified: type preservation, both
boundary laws (a true tube face gives that tube's cap; no live tube gives the
base), no change to any existing Glue program in the checker or on the
runtime. **Not** verified: the characteristic law, that ungluing the composite
gives exactly that `A`-composite. It cannot be stated in surface syntax,
because the φ-face mentions the `T`-filler of a `Glue`-typed base, which is
well-typed only under the restriction φ=1. Restricted types (`Sub`) and
partial elements are now implemented (§C) and are still *not* enough: the
obstacle is that a **variable's type in the context** is not restricted by the
face, so `u0 : Glue(A,[(p,T,e)])` cannot be used at `T` on the cell `p=1`.
Stating this law needs face-restricted CONTEXTS — what Cubical Agda provides
through partial-element lambdas whose bodies elaborate under the constraint.
That is the remaining work for this one law; the rule itself follows CCHM and
nothing in the suite contradicts it.

**Nothing is open in this section any more.** The runtime carries Nat, Bit,
List and Unit as well; `transp` with a cofibration is its own constructor
(§C).

---

## C. Primitives from the CCHM presentation — ALL DONE

| CCHM object | status |
|---|---|
| `Partial φ A` and systems | **DONE** — `Partial(φ, A)`, `system([(ψ, v), …])`, `pout(u)`. Branches are typed on their own cells, must agree on overlaps and must COVER φ; `pout` requires the face to hold. `partial.bend` 6 ✓, `partial_mustfail.bend` rejects disagreement, a coverage gap, and a premature `pout` |
| `Sub` / `A[φ ↦ u]`, `inS`, `outS` | **DONE** — `Sub(A, φ, u)`, `inS(x)`, `outS(s)`; `inS` demands definitional equality with `u` on every cell of φ, `outS(inS x) = x`. `sub.bend` 8 ✓, `sub_mustfail.bend` 2 ✗ |
| `comp` | **DONE** — `comp(P, [(face, tube)…], base)`; `comp.bend` |
| `transp` with φ | **DONE** — `transp(L, φ, x)`, its own constructor; constancy of `L` on φ enforced cell by cell with the marker test. `transp.bend` 8 ✓, `transp_mustfail.bend` 1 ✗ |
| interval de Morgan laws | **DONE** — meets and joins normalise to a canonical flattened, deduplicated, sorted form, so commutativity, associativity, idempotence and absorption all hold DEFINITIONALLY (`interval.bend` 7 ✓). No complement law, correctly: the interval is de Morgan, not Boolean, so `i ∧ ¬i` is not `i0`. The runtime's `@iand`/`@ior` do not canonicalise, which is harmless because faces are evaluated there, never compared |
| face lattice | DNF (`faceDNF`, `restrictLits`, `facePairs`) |

All four new primitives are threaded through every traversal in §A and all
four backends, and each runs on HVM4 in agreement with the normaliser.

---

## D. Higher inductive types — three, not a schema

**Implemented and tested:**

| HIT | constructors | eliminator | tests |
|---|---|---|---|
| SetQuotient | `Quot(A,R)`, `qcl`, `qeq`, `qsquash` | `qrec` | `quotient.bend`, `effective.bend`, `erasure.bend` |
| The circle `S1` | `s1base` (point), `s1loop` (path) | `srec` | `circle.bend` 9 ✓, `circle_mustfail.bend` 2 ✗ |
| Propositional truncation | `tin` (point), `tsquash x y` (path, joining ANY two elements) | `trec` into a proposition | `truncation.bend` 9 ✓, `truncation_mustfail.bend` 2 ✗ |

The circle is the first HIT here with a non-trivial loop, and it behaves:
`s1loop` has both endpoints at `s1base`, the recursor computes on the point
*and* on the path constructor at every interval, and — the property that makes
it a real HIT — `s1loop` is **not** definitionally `refl`, so `S1` is not a
set. Both are emitted to the full runtime (`#S1`/`#Base`/`#Loop`/`@srec`, with
`s1loop` known to `@pathAt` as a path constructor) and agree with the
normaliser.

Truncation is the one real mathematics needs next (existentials, surjections,
images): its path constructor joins *any* two elements, so `Trunc(A)` is a
proposition by construction (`truncIsProp`), and `trec` is allowed only into a
proposition — the guard file confirms that a bogus `isProp(Bool)` is rejected.

**What is left: the general schema.** All three HITs are hardcoded as `Term`
constructors, so each new one costs another pass through every traversal in
§A. A declaration form would take point and path constructors and generate the
eliminator and its computation rules. Design sketch for whoever does it:

1. Extend the `type` declaration with path constructors whose codomain is a
   path between already-declared point constructors.
2. Store the constructor signatures in the `Book` instead of in `Term`.
3. Generate the eliminator's type from the signatures; its computation rules
   are one per constructor, path constructors reducing at an interval.
4. `hcomp` in a HIT correctly stays STUCK — for a higher inductive type a
   composite is a canonical form, which is exactly how the higher structure
   arises. (An earlier draft of this document wrongly listed that as missing.)

This is the one genuinely research-scale item remaining; everything else in
this document is closed. Absent for the same reason: suspensions, pushouts,
and propositional/set truncation as first-class types.

---

## E. Backend coverage

| target | cubical | quotients |
|---|---|---|
| `--to-hvm4-full` | complete (intervals, paths, types, `coe`, `hcomp` as data) | **DONE** — `#Quot`/`#QCl`/`#QEq`/`#QSq` + `@qrec`; quotient/effective/minmachine/erasure all agree with the normaliser |
| `--to-hvm4` / `--to-hvm4-raw` | erased/normalised by design | no |
| `--to-hvm` (HVM3) | `freeVars` fixed; the target still erases | no |
| JavaScript | **now fails loudly** — erasing a path silently produced wrong code, so every cubical constructor raises a clear error pointing at `--to-hvm4-full` | no |

The full runtime now carries the Π, PathP and Σ rules too (§B). Its `@hcomp`
still gets stuck for Nat, List and Glue. Every rule must be written **twice**,
once in `whnfHCm` and once in `Target/HVM4Full.hs`.

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
