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

---

## 7. Addendum: the idiom is in **both** lanes already, and neither cites the barrier

Checked after writing §§1–6, by grep rather than by memory:

- `formal/cubical/NaturalMachine/FiniteInformation.agda:199`
  `factorsThrough→fiberConstant : FactorsThrough q t → FiberConstant q t`
  — exactly the direction §4 uses to say a witness is a non-constant fibre.
  `--safe`, `--guardedness`.
- `formal/cubical/NaturalMachine/TranscriptDescent.agda:64`
  `collisionObstructsDecoder`, four lines, built on that. `--safe`.
- `formal/pairfield/Pairfield/FiniteInformation.lean:17,23`
  `FactorsThrough` and `factorsThrough_iff_fiberConstant` — **the same pair
  of definitions, in the analytic lane, in Lean**, with the iff in both
  directions rather than the one.
- `formal/pairfield/Pairfield/CharacterSectorClosure.lean:32` already uses
  it to characterise when a polynomial action realises an observable.

So the shape is not a cubical curiosity to be exported. It is present, in
Lean, in the same lane as `BARRIER.md`, with the stronger biconditional —
and `BARRIER.md` does not mention it, `METHOD.md` §3 item 1 does not
mention it, and `CharacterSectorClosure` does not mention the barrier.

The gap is not mathematical. Three files hold the pieces and no file holds
the sentence.

**Concrete consequence for whoever works `METHOD.md` item 1 next:** the
Lean lane's `factorsThrough_iff_fiberConstant` turns the Structure
Proposition into a fibre-constancy statement *by definition*, in the lane
where the analysis lives. "WL observables factor through the blurred
measure" and "the WL observable is constant on each fibre of the blur" are
the same claim, and the second is the one an explicit-formula argument
actually addresses — it is a statement about two configurations at a time,
which is the form the explicit formula is applied in anyway.

---

## 8. The corpus has already produced exactly one barrier, and it is a collision

`notes/OFFDIAGONAL_NO_GO.md` (2026-08-18) settles `METHOD.md` §3 item 2's
sub-item **negatively**. Read it against §2 of this note:

| that note | this note's vocabulary |
|---|---|
| `A` = evil numbers, `B` = odious numbers | the two objects |
| `g_A = g_B` — identical off-diagonal pair layers | `q A ≡ q B` |
| `A ≠ B` as configurations | `¬ (t A ≡ t B)` |
| "the off-diagonal pair layer does **not** determine the configuration" | `¬ FactorsThrough q t` |

That is a collision, in full, with both hypotheses discharged and the
conclusion drawn — produced in the analytic lane, on the same day, without
the word "collision" and without the lemma that consumes it.

So the framing is not merely tidy. It **predicts and sorts both halves of
what this corpus has actually produced**:

- everything the deflation ate (`notes/EVERY_OBSTRUCTION_HERE_IS_EXACT.md`)
  — no collision, no barrier, `¬A` and exact;
- the one thing that survived — a collision, hence a barrier, in the only
  sense the word ever had.

One instance is not a validated method. But it is the difference between a
vocabulary proposal and a classification with a confirming case, and the
case was found by reading rather than by argument.

## 9. What §8 says about the flagship problem, strategically

`BARRIER.md` states its own obstacle:

> *"The superresolution construction perturbs an abstract spike measure;
> the zeros of ζ cannot be moved."*

Prouhet's witness **does not perturb anything.** It partitions a fixed set
— the nonnegative integers — into two halves by a parity of binary digits,
and the coarse layers agree because of a product identity, not because one
configuration was nudged into another.

> The obstacle `BARRIER.md` names is an obstacle to *perturbation*
> witnesses. The one witness this corpus has is a *partition* witness, and
> partition witnesses are not subject to it.

That is a concrete redirection and it costs nothing to try: look for two
admissible configurations obtained by **splitting one fixed admissible
configuration**, whose blurred measures agree by an identity. Whether ζ's
zeros admit such a split is exactly the question — but it is a different
question from the one `BARRIER.md` ruled out, and the corpus's only success
in this shape came from the other side.

**Stated as a caution, because it is cheap to say and hard to do:** Prouhet's
identity works because `1/(1-x)` factors as `∏(1+x^{2^k})` — the split is
supplied by binary representation, an exact structure the integers have and
a zero configuration has no evident analogue of. Nothing here suggests one
exists. What is claimed is only that the search should be aimed at
splittings and identities rather than at perturbations, because the stated
obstacle does not apply there.

---

## 10. A fifth site, and the first outside mathematics

`formal/cubical/NaturalMachine/AvaktavyaDoesNotFactor.agda` (checked, exit
0).

`Saptabhangi.agda` formalises the syādvāda's sevenfold predication, with
Akalaṅka's 3+3+1 = 7 as an isomorphism, and proves

```
no-single-vacana : (v : Vacana) → Σ[ φ ] (¬ (denotes v φ ≡ joint φ))
```

— for every single utterance there is a profile on which it disagrees with
the joint content. That is **avaktavya**, the fourth bhaṅga, and it is
exactly a non-factoring statement:

```
avaktavya-does-not-factor : ¬ Σ[ v ∈ Vacana ] ((φ : Profile) → denotes v φ ≡ joint φ)
```

Side by side with the other two:

| | statement |
|---|---|
| avaktavya | `¬ Σ[ v ] (∀ φ → denotes v φ ≡ joint φ)` |
| लाघव | `¬ Σ[ f ] (∀ e → f (eval e) ≡ size e)` |
| the barrier (B3) | `¬ Σ[ d ] (∀ x → d (blur x) ≡ observable x)` |

One shape, three traditions, and only the middle one had been noticed here.
Counting `CarryBorrowObservation`, `Laghava`, `Anuvrtti` and this, the
lemma has now been independently reinvented **five** times in this
repository, four of them within one session.

### And the Jain one is decidable

`avaktavya-decidable : (φ : Profile) → Dec (joint φ ≡ true)` — because
`joint φ` is a Boolean. `Saptabhangi` had already shown it is not a
truth-value gap (`joint-realised` and `joint-refuted` are both exhibited).
So the fourth bhaṅga is **neither a gap nor an undecidability**. It is a
failure to factor through a single utterance: an expressiveness fact about
the medium of predication, not a defect in what is predicated of.

Which is what `notes/EVERY_OBSTRUCTION_HERE_IS_EXACT.md` predicts.
Avaktavya was this corpus's best candidate for something genuinely
inexpressible, and it is exact.

### The reading, marked as one

> What a tradition calls "inexpressible" is often not a claim about truth
> at all, but about the **arity of its medium** — one utterance, one
> denotation, one blur value — and the formal content is the same negation
> every time.

Avaktavya says it about predication, lāghava about meaning, B3 about
windowed observation. No historiography backs the generalisation; three
formalised instances do, and they are in three different files by three
different hands.
