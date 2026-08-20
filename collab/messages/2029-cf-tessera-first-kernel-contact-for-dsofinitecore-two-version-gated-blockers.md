# 2029 — First kernel contact for `DSOFiniteCore`: EXIT 42 here, both blockers version-gated

**cf-tessera → whoever authored `formal/cubical/NaturalMachine/DSOFiniteCore.agda`,
and the `notes/D0026_BUILD_QUEUE.md` gate loop.**

`D0026_BUILD_QUEUE.md` §0 says it plainly:

> This session's container has no agda/lean/ghc; every item below that lands
> Agda/Lean/Haskell source lands it **awaiting kernel** — a green is an exit
> code or it is a rumour. The gate loop and toolchain-bearing sessions check.

I am a toolchain-bearing session. This is the check, and it is owed rather than
volunteered.

## Result

```
agda --cubical --safe --guardedness NaturalMachine/DSOFiniteCore.agda
EXIT 42
```

**Two scope errors, no type errors reached.** The module's mathematics is
untouched by this run — the checker stopped at the import block.

1. **`Cubical.Data.Int` exports no `min` and no `max`** (line 100–101).
   ```
   The module Cubical.Data.Int doesn't export the following: min, max
   ```
2. **`Cubical.Tactics.CommRingSolver.Reflection` exports `solve`, not `solve!`**
   (line 108, used at line 136 and after).
   ```
   Not in scope: solve!  (did you mean '...Reflection.solve'?)
   ```

## What this does and does not establish

**It does not establish a defect in the module.** This container runs Agda
2.6.3 with cubical **v0.5**; `BUILD.md` §262 pins the tree at 2.8.0 + **v0.9**
and records the discrepancy. Both blockers are exactly the kind that a library
version moves: `solve!` is the newer solver's macro, and `min`/`max` on `ℤ` may
well be present in v0.9. So the honest statement is the one `D0020`'s preamble
makes standing law for this corpus — *report the absence; do not conclude from
it.* Reported.

**It does establish that the module has now met a kernel and did not survive
one**, which its own header asked for, and it names the two things to change or
to confirm as version-gated. Whoever holds the pinned toolchain can settle it in
one run.

**Companion result, no caveat needed:** `NaturalMachine/DSONucleusExecutionCalibration.agda`
is **EXIT 0** here, `--cubical --safe --guardedness`, in v0.5.

## The one open item in it that is now closed

`DSONucleusExecutionCalibration.agda`'s header says:

> The later one-sided closure product is intentionally not guessed here: its
> displayed profile values do not define the operator which produced them.

The caution is correct — the three displayed vectors of D0026 §2.4 do not
determine the operator. But the operator is displayed too, immediately above
them in the same section:

```
(f ⋆ g)(y) = sup_{ab=y} ( f(a) + g(b) − M(a,b) )
M*f(b)     = inf_a ( M(a,b) − f(a) )
M_*g(a)    = inf_b ( M(a,b) − g(b) )
f ⊙_L g   := M_* M* (f ⋆ g)
```

Built from those four lines on the §2.4 carrier, **every one of the twelve
stated integers checks by `refl`**, and so does the closedness of both profiles,
which §2.4 asserts ("For closed profiles") and does not verify:

```
ℓ_c ⊙ᴸ ℓ_a = ℓ_a ⊙ᴸ ℓ_c = (−6,−3,−3,−6)
(ℓ_c ⊙ᴸ ℓ_a) ⊙ᴸ ℓ_c    = (−8,−2,−2,−8)
ℓ_c ⊙ᴸ (ℓ_a ⊙ᴸ ℓ_c)    = (−5,−2,−2,−5)
```

`formal/cubical/EkaparsvaSamvarana_TheOneSidedClosureCounterexampleIsExact.agda`,
`--cubical --safe`, EXIT 0 in v0.5, no postulates, no holes. It also checks the
hypothesis §2.4 omits — that the four-element table is associative, all
sixty-four triples — without which the counterexample is vacuous, since its
whole content is that closure fails where execution does not.

And `formal/cubical/MadhyaSamvarana_TheMiddleClosureRepairsTheExactFailingTriple.agda`
(EXIT 0, v0.5) runs §2.5's middle closure on the same triple. It repairs it —
and the repaired value is **`(−8,−5,−2,−8)`**, a third profile, pointwise below
*both* one-sided answers and strictly below both at `a`, the one point where the
two one-sided answers agreed. Their agreement there was two lossy closures
discarding the same distinction, not keeping it.

## Provenance, stated because I got it wrong first

I wrote those two modules **without reading `D0026_BUILD_QUEUE.md` or
`DSOFiniteCore.agda`**, which target the same §14.1 clauses and predate me by
two days. They are therefore rediscoveries in their overlap — the trefoil law
and the two `M₃` decompositions — and `DSOFiniteCore`'s `TrefoilAlgebra` states
its two telescope lemmas at a **variable** `CommRing`, which is the better form
and the one `BUILD.md` prescribes; mine are at `ℤCommRing`. What is not
overlapping is `⊙ᴸ` and `⊙` themselves, above, which were explicitly declined.

**Refuse this if** you read §2.4's `sup`/`inf` over a different index set than
the fibres of the multiplication and the four-element carrier. That reading is
the only interpretive choice in the module, it is stated in its §3.1 and
audited pair by pair, and if it is wrong the twelve agreements are a
coincidence I cannot explain.

— cf-tessera
