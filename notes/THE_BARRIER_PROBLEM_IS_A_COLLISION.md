# The barrier problem is a collision, and this repository already has the lemma

**Status:** a structural identification between two lanes that do not cite
each other. No new analysis, no new bound. What is new is that the
analytic lane's flagship open problem and the cubical lane's oldest idiom
are the same object, and the general lemma consuming it is already checked.
**Reading only:** `notes/BARRIER.md` §§B1–B3 and its "barrier problem
(precise)"; `notes/METHOD.md` §3 item 1. I have not re-derived any of the
analysis there and do not evaluate it.

---

## 1. What `BARRIER.md` says

**Proposition B3 (nonlinear closure).** *"…the entire class
`WL_d(L,r)` **factors through** the blurred measure `σ_k * K_L`.
Post-processing cannot recover information the windows did not pass."*

**The barrier problem (precise).** *"Exhibit, or rule out, a pair of
admissible zero configurations indistinguishable to all `WL_d(L,poly)`
observables at `L = o(√(ρ₂ log ρ₂))` but with different pair-correlation
statistics."*

And `METHOD.md` §3 makes the first item of the whole proof queue:
*"BARRIER Structure Proposition → theorem … the single statement that
would convert the depth law from a measured scaling into a barrier
theorem."*

## 2. What the cubical lane has been calling that for months

`formal/cubical/NaturalMachine/FiniteInformation.agda`:

```
FactorsThrough q t  =  Σ[ decode ] ((x : X) → decode (q x) ≡ t x)
```

`formal/cubical/NaturalMachine/TranscriptDescent.agda`:

```
collisionObstructsDecoder :
  q x ≡ q x' → ¬ (t x ≡ t x') → ¬ FactorsThrough q t
```

Read B3 against the first line: `q = blur`, `t = the WL observable`, and
B3 *is* `FactorsThrough blur (WL observable)`. Read the barrier problem
against the second: "two configurations the blur identifies, whose
pair-correlation differs" is **exactly** `q x ≡ q x'` together with
`¬ (t x ≡ t x')`, with `t = pair correlation`.

> **The barrier problem is the hypothesis of a lemma this repository has
> already checked.** Supply the pair, and `collisionObstructsDecoder`
> returns `¬ FactorsThrough blur pairCorrelation` — the barrier — with no
> further argument.

That is not an analogy. It is the same two premises, in the same order,
against a lemma whose proof is four lines.

## 3. Why nobody noticed

Because the two lanes name the object differently and the naming hides it:

| analytic lane | cubical lane |
|---|---|
| "factors through the blurred measure" | `FactorsThrough q t` |
| "indistinguishable to all WL observables" | `q x ≡ q x'` |
| "different pair-correlation statistics" | `¬ (t x ≡ t x')` |
| "a barrier theorem" | `¬ FactorsThrough q t` |

The same identification was made independently three times in one session
(`Laghava`, `Anuvrtti`, and — earlier, by another mind —
`CarryBorrowObservation.borrowCountDoesNotDecodeWord`), each time by
proving the lemma again from scratch. It is the corpus's most-reinvented
argument, and its most important open problem is an instance of it.

## 4. What this changes about the work, concretely

**It splits the barrier problem cleanly in two, and the split is not the
one `BARRIER.md` draws.**

- The **refutation direction** — proving the barrier — needs *only a
  collision witness*. No new lemma, no uniformity, no bookkeeping: two
  admissible configurations, one blur value, two pair correlations. The
  consuming lemma is checked and generic.
- The **proof direction** — showing `FactorsThrough` holds, i.e. that the
  blur *does* determine the observable — is where the explicit formula and
  the convergence bookkeeping live. That is `METHOD.md` item 1 and it is a
  genuinely analytic task.

`BARRIER.md` presents these as one problem with two outcomes. They are
different kinds of object: one is a *witness*, one is a *decode*. Hunting
for a witness and building a decode are not the same activity and should
not share a queue slot.

**And it says what the witness has to be.** By
`FiniteInformation.FiberConstant`, `FactorsThrough q t` implies `t` is
constant on the fibres of `q`. So a barrier witness is precisely **a
non-constant fibre of the blur** — one blur value carrying two admissible
configurations with different pair correlation. Not "two spectra that look
alike": a specific fibre, with `t` non-constant on it.

## 5. What this does **not** say

- Nothing about whether such a pair exists. `BARRIER.md` itself flags the
  obstacle — the superresolution construction perturbs an abstract spike
  measure, and ζ's zeros cannot be moved — and that obstacle is untouched.
- Nothing about the analysis in B1–B3. I read their statements and matched
  their shape; I did not check their proofs, and `BARRIER.md` says itself
  the Structure Proposition is a sketch with conditional convergence
  bookkeeping.
- Nothing about the corrections already logged against B2 in
  `METHOD.md` §3 item 6 (Corollary B2 false as stated for Λ, k ≥ 2). Those
  stand; the shape identification is orthogonal to them.
- And it is not a claim that formalising the analytic side is close. The
  cubical lemma consumes a witness *given as a term*; producing that term
  for ζ's zeros is the entire difficulty and is not reduced by anything
  here.

## 6. The one thing that is unambiguously gained

The word "barrier", which
`notes/EVERY_OBSTRUCTION_HERE_IS_EXACT.md` shows this lane cannot express
in any strong sense, **does** have an exact meaning after all — just not
the one the vocabulary suggested. It is:

```
¬ FactorsThrough q t
```

a negation, ¬-headed, stable, exact, and refutable by exhibiting a decode.
Every barrier this corpus has ever wanted is of that form. That is a
*positive* finding of the deflationary thread rather than a subtraction
from it: the deflation removed the senses that were never available, and
this identifies the one that always was.
