# Cubical Bend2 — what is built, reproduced, and run (grounded ledger)

This file records what was **actually built and executed** in this session,
with the exact toolchain, so the claims are checkable and not narration.
It supersedes the optimistic phrasing in `WRITEUP.md`; where the two differ,
believe this file. Every line below was produced by a command that ran.

## Toolchain (independently built — not the repo's CI)

- GHC **9.12.2**, cabal **3.14.1.1** (via ghcup), `LC_ALL=C.utf8`.
- `cubical-paths.patch` applied cleanly to **DKormann/Bend2 @ f026483**
  ("implement dup-dup case", 2025-07-07 — the snapshot the patch targets).
- Patched `bend` builds green (`cabal build`, exit 0).
- HVM3 (**HigherOrderCO/HVM3**) built as the native runtime. Its `exe:hvm`
  needed a two-line weak stub for `reduce_ref`/`reduce_ref_sup` to *link*
  (those symbols are generated per-program by compiled mode; the interpreter
  path `reduceAt` never calls them, so the stub is inert for `run`). Recorded
  in `hvm3-link-stub.md`.

The public GitHub workflow on the corpus commit does **not** build this
checker or run the cubical suite; the results here come from the local build
above, reproduced from scratch.

## A. The suite typechecks (reproduced)

`bend <file>` on all ten shipped files → **8/8 cubical/corpus files green**
(`cubical_test`..`cubical_test5`, `corpus_calculus`, `corpus_lossless`,
`run_corpus`), plus stock `examples/*.bend` 2/2. No regressions.

## B. Native cubical EXECUTION on HVM3 (the decisive result)

This is what `WRITEUP.md §4.2` listed as *future work* ("emit HVM4 and run
cubical extractions"). It now runs — for **monomorphic/closed** transports —
through the exact compiler→runtime path (`bend --to-hvm` → `hvm run`):

| program | meaning | emitted HVM core | `hvm run` result |
|---|---|---|---|
| `applyNeg(True)` | transport along `ua(not)` from `i0`→`i1` | `λ&x (~x {0:1 _:0})` | **`0`** (False), 6 interactions |
| `supRoute(&0{T,T})` | **Sup×Path**: transport `&0{T,T}` along `&0{ua(not),Bool}` | `λ&p @DUP(0 p λ&t0 λ&t1 @SUP(0 (~t0{0:1 _:0}) t1))` | **`&0{0 1}`** (= `&0{False,True}`) |
| `run_corpus` | `div2(mul2 21)` with proof | proof erases to `*` | **`#S^21 #Z`** = 21, 218 interactions |

Two things this establishes that the writeup only asserted:

1. **A transport that changes a value executes into the value-changing
   function; it does not disappear.** `coe` along `ua(not)` compiled to actual
   boolean negation and ran to `False`. The backend *reduces* `Coe`/`PAp`/
   interval (via `elimCubical`, using the evaluator) rather than erasing them;
   a genuinely stuck transport is refused loudly, never silently dropped.
2. **Sup×Path is HVM's native annihilation.** The corpus's fibre-exact routing
   compiles to a **label-matched `DUP`/`SUP`**: on HVM the same-label DUP-SUP
   annihilates, pairing component-wise, so `&0{T,T}` routes to `&0{False,True}`.
   (An earlier naive lowering duplicated the input under a fresh label and
   produced `&0{&0{0 0} &0{1 1}}` — wrong; the fix emits the label-0 DUP. Both
   the bug and the fix are recorded, because the difference is the whole point.)

## C. The totality classifier is now SOUND (bug found and fixed)

The shipped classifier reported `loop(n,m){0->0; 1+p->loop(n,p)}` as
**`[total]`** though it diverges — but *not* by the route the audit predicted:
its traversal never even detected the recursive call (match-based recursion
was invisible), so *every* match-defined function was `[total]` vacuously,
including `mul2`/`div2`. The rewrite (`Totality.hs`):

- traverses the real `NatM`/eliminator representation and detects the self-call;
- tracks, per strictly-smaller variable, **which parameter it descends from**;
- tags `[total]` only when a **single argument position strictly decreases in
  every** recursive call (the standard sound size-change criterion for one
  function); conservative — it may under-tag, never over-tag.

Verified: `loop` → **`[unchecked]`**; `mul2`, `div2`, `div2_mul2`, and
`add(n,m){0->m;1+p->1+add(p,m)}` → **`[total]`**.

It remains an **analysis, not a gate** — Bend2 is non-total by design.

## D. hcomp is the primitive — made to compute (degenerate case, sound, universal)

CCHM's actual primitive is **`hcomp` (Kan composition)**; `coe`/`comp`,
transport-in-`Path`, path composition and the groupoid laws are *defined from
it*. The prototype inverted this — `coe` primitive with per-former dispatch,
`hcomp` a degenerate endpoint-picker (`whnfHCm` fired only when the direction
was literally `i0`/`i1`). That inversion is exactly why `Pth`-coe was
"missing": its foundation was stubbed.

First real step, in `WHNF_evaluator.hs` / patch: `hcomp` now computes in the
**constant-side-wall** case — when both walls are constant in the composition
dimension the square is degenerate and the lid equals the base. This is sound
for **any** type `A` (no dispatch on `A`), and it makes the groupoid
unit/idempotence laws hold **definitionally** (verified in
`hcomp_unit_laws.bend`):

- `runit : pcompH A a b b p (refl b) ≡ p` → **`definitional`**
- `rr    : pcompH A a a a (refl a) (refl a) ≡ refl a` → **`definitional`**

(The shipped code had these only propositionally; the analysis now reports
`definitional`, cost 0.) No regressions (8/8).

**Still open — the rest of the primitive.** General `hcomp` with
non-constant walls must dispatch on the type former (Π, Σ, data, and `Glue`
for the universe), exactly as `coe` does; that is the CCHM implementation
proper, and each former's rule must be verified individually before shipping
(a wrong composite is unsound, worse than stuck). Left-unit `refl · p`,
associativity of non-refl paths, and general `Pth`-coe (= `comp`) all wait on
that. Not exotic — it is *the* primitive — but real, careful work, done
former by former with a test each. The constant-wall case is the sound
down payment.

## What is NOT done, stated plainly (narrowing the writeup)

- **Transport through a nonconstant Path family / abstract motive.**
  `coe(λi. C(p@i) …)` with `C` a bound motive (generic `J`/`subst`/`uaEta`)
  is stuck by nature — it cannot reduce until `C` is concrete, and cannot be
  lowered to a first-order HVM function without a runtime `coe` primitive.
  `whnfCoe` still has **no `Pth` case**; adding a *correct* one needs real Kan
  composition, because the prototype's `hcomp` only reduces at a concrete
  direction endpoint (`whnfHCm`: `r=i0 → u0@i1`, `r=i1 → u1@i1`) — it is not a
  general composition, and `hfill`/general cofibrations are open (README).
  So generic transport combinators and `hcomp`-using terms (e.g. `pcompH`)
  **do not lower** — `--to-hvm` refuses them rather than emit something false.
- **Univalence is iso-level, and one round trip only.** `cubical_test5` proves
  `uaEta : ua(pathToIso p) = p` (path side) and the `idIso` computation, not
  `pathToIso(ua e) = e` for the raw `Iso5` record. Raw iso-data (two
  homotopies) is not a coherent equivalence, so that round trip is not
  expected to hold without half-adjoint/bi-invertible/contractible-fibre
  coherence. Claiming "univalence complete, both round trips checked"
  overstates it; the honest claim is **`isoToPath` with `uaβ` and `uaη`**.
- **The analysis "cost" is a syntactic count, not runtime cost.**
  `Analysis.hs` counts occurrences of `Rwt`/`Coe`/`HCm`/`Ua`; it does not
  measure HVM interactions or a thermodynamic floor. The interaction count
  (e.g. 6 / 218 above) comes from `hvm run -s`, a *different* meter. The only
  established coincidence is the narrow one: a proof that the checker rules
  `definitional` (`div2_mul2`: rewrites 1, cells 0) erases to `*` and costs
  **0** at runtime.
- **The corpus self-quotient census (§4.1) is still unrun.** No behavioral-
  equivalence census of the 2200 modules has been produced.

## Files

- `cubical-paths.patch` — the complete patch (original cubical layer **plus**
  the native-lowering backend and the sound classifier), vs DKormann/Bend2
  @ f026483.
- `Totality.hs`, `HVM_backend.hs` — the two files this session rewrote, for
  direct reading (also inside the patch).
- `applyneg.bend`/`.hvm`, `suproute.bend`/`.hvm` — the two demos and their
  emitted HVM3.
