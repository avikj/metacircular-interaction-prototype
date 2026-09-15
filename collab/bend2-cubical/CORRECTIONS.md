# Corrections and completions (response to technical review)

A close source-level review (of commit 86cb6919a) correctly identified places
where the earlier writeup claimed more than the code established, and gaps in
the cubical primitive. This document records what was **corrected in the
claims** and what was **completed in the code**. Every item below was rebuilt
and rerun with the patched binary (GHC 9.12.2, cabal 3.18, `LC_ALL=C.utf8`) in
this environment; see the file list at the end for the exact test programs.

## Completed in code

### 1. Faithful native lowering of cubical transport (was: erased)

The prior emitter lowered a stuck `coe` to its argument (`Coe _ _ _ x -> x`),
which is sound for proofs but **wrong for data transport** — a transport that
moves a value cannot vanish because its type mentions equality. The reviewer's
decisive example confirmed the bug: `applyPath` compiled to `λA B p x. x`.

Fixed. Universe paths are now represented at runtime by their **forward
transport function**, and `coe` along a path-application lowers to *applying*
that function:

- `ua(A,B,f,g,…)`  ⟶  `f`   (its runtime content is the forward transport)
- `coe(λi. p @ i, i0, i1, x)`  ⟶  `p(x)`   (apply the path's function)
- constant/rigid line  ⟶  `x`   (identity, via regularity)

`applyPath` now compiles to `λA B p x. p(x)`. **Verified executing on the HVM4
C runtime** (`applypath.bend` → `--to-hvm4` → `hvm`):

    @applyPath(_)(_)(@negPath)(1)  =>  0     -- transport a Bool across the
                                             -- negation univalence path
    @transId(1)  => 1                        -- identity path
    @transNeg(1) => 0 ,  @transNeg(0) => 1   -- through a wrapper function

This is a cubical program's transport reaching and running on the interaction
net — the connection the review named as the main missing boundary.

A second real bug surfaced and was fixed while doing this: the HVM4 printer did
not parenthesize a lambda in function position, so `(λx.M)(N)` mis-parsed. Now
`appFun` parenthesizes non-atomic heads, and binders are emitted with unique
depth-indexed names (`b0,b1,…`) to remove HOAS name capture.

### 2. Transport through nonconstant Path families (was: stuck)

`whnfCoe` had no `Pth` case; a transport through a nonconstant path-type family
fell through to the stuck fallback. Added the `Pth` case: transport of a path
along a family conjugates the pointwise-coerced path with the coerced endpoints
via `hcomp`. Verified: transport of `refl` along the nonconstant family
`λi. Path(Nat, q@i, q@i)` typechecks into `Path(Nat, b, b)` with the boundary
conditions holding (`pth2.bend`), and the constant family reduces to the
identity by regularity (`pthtransport.bend`).

### 3. Totality classifier: real descending-column analysis (was: false-positive)

The prior classifier tagged `loop(n,m) = match n { 1n+p → loop(n,p) }` as
`[total]` — a false positive, since `n` never decreases. Two bugs:
- it ran on the **unflattened `Pat`** term (match sugar), which `collect` had no
  case for, so it saw *no recursive calls at all* — every `match`-using
  definition was vacuously `[total]`;
- it counted a call as decreasing if *some* argument was smaller than *some*
  parameter, rather than requiring a fixed column to shrink.

Fixed: the term is `flatten`ed to eliminators first; each strictly-smaller
variable is tracked to the **parameter index it descends from**; a call
decreases in column *i* only if argument *i* descends from parameter *i*; and
`Total` requires a single fixed column that shrinks in **every** call. Now
`loop` is `[unchecked]`, `mul2`/`div2` remain `[total]`, and the coinductive
`run3` is `[productive]`. It remains an **analysis, not a gate** — Bend2's logic
is non-total by design; the tag marks the trust boundary per definition.

## Corrected in claims

### "Univalence complete" → iso-univalence with the path-side round trip

`cubical_test5.bend` proves `uaβ` (transport along `ua e` computes to `e`, both
directions), `uaIdEquiv` (`ua(idIso) = refl`), and `uaη` (`ua(pathToIso p) = p`,
by J). It does **not** prove the other round trip `pathToIso(ua e) = e` at the
`Iso5` record level — and that is not an oversight: `uaroundtrip.bend` shows it
fails by `refl`. Raw isomorphism data (two functions + two homotopies) is not
the same type as a **coherent** equivalence (contractible fibres / half-adjoint
/ bi-invertible); it can carry extra higher information, so the round trip is
not on the nose. The honest statement is: **`isoToPath` with `uaβ`, `uaIdEquiv`,
and `uaη`** — which is exactly the interface `Fibre.Carrier` uses — **not** a
full `Iso ≃ Path` equivalence. Coherent-equivalence univalence (with both round
trips) requires an `isEquiv`/`isContr`-fibre formulation — since done:
`uaequiv.bend` proves `uaEquivRoundTrip : pathToEquiv(uaE e) = e` (17✓ 0✗),
with `uaE` built from the contractible-fibre data and the second component
closed by `isPropIsEquiv` (general `hcompN`). See GENERAL_HCOMP.md.

### Proof-cost analysis is a syntactic static proxy, not a runtime/thermo measurement

`Core/Analysis.hs` counts **syntactic occurrences** of the rewrite/transport
constructors (`Rwt`, `EqlM`, `Coe`, `HCm`, `Ua`) in a proof term, and reports
`definitional` when none occur. This is a useful static proxy for "how much
non-contractible work a proof names," and it is motivated by the corpus's
cost-is-the-fibre theorem. It is **not** a measurement of executed HVM
interactions, and it does **not** compute contractibility or a thermodynamic
floor. The claim that these counts *coincide with* runtime interaction counts
or Landauer cost is a **design conjecture**, not something the implementation
establishes; treat it as motivation, not result.

### hcomp is a restricted binary-face operation

`hcomp(A, r, u0, u1, base)` implements the two-sided face system (r=i0/r=i1).
General cofibration systems and `hfill` are **not** implemented; the `Pth`
transport above uses exactly this binary `hcomp`. HIT schemas (user-declared
path constructors) remain open.

### What the green CI covers

The repository's machine workflow builds and tests the existing Yantra
executable and a wire query. It does **not** build the patched Bend2 compiler,
run the cubical test suite, or run the full Agda corpus check. The cubical
results reported here come from running the patched binary in the development
environment, not from that workflow. The corpus behavioral-census remains a
proposed next step, not a produced artifact.

## Accurate one-line status

A cubical Bend2 front-end + evaluator prototype — interval, Path/PathP,
boundary-checked path lambdas, `coe` (with a `Pth` case and regularity), J with
definitional refl, binary `hcomp`, iso-univalence (`isoToPath` + `uaβ`/`uaIdEquiv`/`uaη`),
the label-correlated `Sup × Path` transport rule, a sound descending-column
totality analysis, and a Bend2→HVM4 emitter that lowers cubical **transport
faithfully** so a cubical program's transport runs on the interaction-net
runtime. Corpus constructions (lossless `rightInv`, `CorpusCalculus`, the ISC
coalgebra) are transported into this language and check.

## Test programs (all rerun; 0 failures)

    applypath.bend      faithful coe: applyPath/transNeg/transId run on HVM4
    pth2.bend           transport of refl along a nonconstant Path family
    pthtransport.bend   constant Path family = identity (regularity)
    uaroundtrip.bend    documents that the record-level ua round trip fails by refl
    loop.bend           the totality false-positive probe: now [unchecked]
    cubical_test{,2,3,4,5}.bend, corpus_calculus.bend, run_corpus.bend


## Addendum (independent rerun + emitter fixes)

See `VERIFICATION.md`: fresh-environment reproduction of every item above, plus fixes to the emitters (`@pathBwd` was undefined and `ua` dropped `g`, so backward transport was unrepresentable; HVM3 target crashed on cubical terms; prelude names clashed with user defs). Transport now verified executing in both directions on HVM4 and HVM3 with the path supplied at runtime.

## 2026-09-15 — the superposed-population premium was the emitter, not the calculus

`bio/bench/README.md` (first pass, 2026-09-14) reported that superposing N cell
states over one shared program costs ≈1.45× per cell and read this as the net's
own commutation cost, concluding "the performance lever is transport, not
stepping". Wrong attribution. The same program hand-written in HVM4 with flat
constructors and native numbers runs superposed at 0.91× the list; the premium
is the `--to-hvm4-full` emitter's encoding of records as tagged pair chains
(~7 commuting matches per step instead of 1) plus Peano arithmetic running in
superposition. Corrected in `bio/bench/README.md` §3 and
`research/BIOLOGY_FRONTIER_20260914.md` §3. Found on the way: I64/F64 literals
compiled to `0` by both HVM4 emitters; fixed in the patch.
