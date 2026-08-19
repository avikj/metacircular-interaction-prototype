# Every obstruction in this corpus is exact, and "barrier" is not earned

**Status:** the deflationary thread, run and closed. Four checked modules
(`DeflationaryTest`, `Laghava`, `TransportPrice`, `Anuvrtti`,
`Pratyahara`), all `--safe`, exit 0, no postulates, no holes — Agda 2.6.3
/ cubical v0.5, the container, not the repository pin.
**Sources:** Navya-Nyāya on *abhāva* and *pratiyogin* (Gaṅgeśa, 14th c.,
via `Abhava.agda`); Pāṇini, *Aṣṭādhyāyī* — *lāghava*, *anuvṛtti*,
*pratyāhāra*, the śiva-sūtras.

---

## The question

`Abhava.agda` set it up: absences form a hierarchy `¬A`, `¬¬¬A`, …, it
stabilises, and that module read the stabilisation level as *measuring the
decidability of what is absent*. The standing deflationary test was whether
every absence in this corpus is decidable — so that nothing lives at level
three, every "obstruction" is exact, and the barrier language is stronger
than the objects warrant.

## The answer, which dissolves the question

Decidability has nothing to do with it.

```
¬-always-stable :  (A : Type ℓ) → ¬ ¬ (¬ A) → ¬ A
```

takes no hypothesis. It is `Abhava`'s own `¬¬¬→¬`, which never used one.
**The absence tower is two-tall for every `A` in every corpus there has
ever been**, and the stabilisation level therefore carries no information
about the obstruction at all.

`Abhava`'s reading is withdrawn — a correction block is appended to that
file; its theorems are untouched.

## Where decidability actually lives

```
dec→stable :  Dec A → (¬ ¬ A → A)
```

— about the **pratiyogin** `A`, not about the absence `¬A`. The
Navya-Nyāya distinction survives and lands one place over: the absence is
always level-two, and it is the *counterpositive* whose own recoverability
is at issue. That is a sharper reading of *avacchedaka* than the one
`Abhava` offered, and it is the correct one.

## Why the stable fragment swallows this corpus

Stability is closed under `¬`, `→`, `×`, `Π` — and **not** under `⊎`.
Every obstruction in this lane has shape `¬A`, or `(x : X) → ¬ A`, or those
under hypotheses. All stable **by shape**, before anyone asks what is
decidable. `DeflationaryTest` §5 instantiates the closure lemmas at exactly
those shapes.

## What a barrier claim would have to be

Not "here is a proof of `¬A`" — that is always stable and always exact.
And a gap between `¬¬A` and `A` is outright contradictory:

```
no-gap :  ¬ ((¬ ¬ A) × (¬ A))
```

So exactly one form of barrier claim survives:

```
BarrierClaim A = ¬ (Dec A)
```

**Nothing in this corpus asserts that, for any obstruction.** The barrier
vocabulary is unwarranted by these objects — which is what the deflationary
thread suspected, reached by a route that never needed the decidability
survey it proposed, and visible from the type of `¬¬¬→¬` on the day that
was written.

## Where decidability *was* doing work all along

In the `⊎`-shaped results. Stability does not pass through sums — a
stable-closure proof for `⊎` is exactly excluded middle — and
`Anekanta.collapse-dichotomy`, `Apavada.kinds-exclude`,
`NoNormOnAJoin.two-valued` and `three-collide` are all disjunctions, each
obtained from a decidable source (`splitℕ-≤`, `discreteℤ`, an explicit case
split). That is the honest home of the avacchedaka here, and it is not
where `Abhava` put it.

## The one genuine obstruction found, and what it turned into

`Pratyahara.no-order-makes-all-intervals`: over three letters, no ordering
makes all three two-element subsets contiguous — all six orderings checked
by `refl`. This is the first thing in the session that obstructs rather
than deflates.

And it is still exact, exactly as the thesis predicts. It is decidable, it
is checked exhaustively, and its content converts into a measurement:
`Pratyahara` §6 shows `x y z x` names all three, so the obstruction says
**the minimum presentation is longer**, not that anything is impossible.
Repetition is forced; one repetition suffices. Which is the shape of the
śiva-sūtras — ह twice, not three times.

> An obstruction here never says "you cannot". It says "not at that
> size."

## What would falsify this

One of:

1. An inhabitant of `¬ (Dec A)` for some `A` this corpus calls a barrier.
2. An obstruction in this corpus whose statement is not `¬`-headed, not a
   `Π` of such, and not a decidable `⊎` — i.e. outside the stable fragment
   and outside the decidable disjunctions.
3. A measure this corpus treats as semantic that in fact separates two
   presentations with equal denotation — which would not falsify the
   deflation but would move a claim from the semantic level to the
   presentational one, as `Laghava` and `Anuvrtti` already did twice.

None is exhibited. (2) is the one to look for: it is a finite audit of the
corpus's obstruction statements by shape, and nobody has run it.

## The tower this produced on the way

| level | separated from the one above by |
|---|---|
| denotation | — |
| rule set | `Laghava.laghava-is-not-semantic` |
| ordered rule text | `Anuvrtti.anuvrtti-is-not-a-set-function` |
| alphabet order | `Pratyahara.no-order-makes-all-intervals` |

Each separation exhibits two objects identified at the coarser level and
distinguished at the finer one. Each is checked. The last one is the only
level where an obstruction appears at all — and it is an obstruction to
*brevity*, which is the only kind this corpus has ever actually had.

## One thing this note is careful not to say

That the walk's difficulties, the parity barrier, or anything in
`notes/THE_BARRIER_BELONGS_TO_THE_LINE.md` is *therefore* easy. The
deflation is about **what the statements in this repository are entitled
to claim**, not about the mathematics they point at. `¬ (Dec A)` is a
perfectly respectable thing to prove. It has simply never been proved here,
and until it is, "barrier" is a description of how the writing felt rather
than of what was shown.

---

## Audit of falsifier (2), run

The note above named a finite audit nobody had run: are there obstruction
statements in this corpus outside the stable fragment and outside the
decidable disjunctions? Run across all 434 `.agda` files in
`formal/cubical`:

| shape | count |
|---|---|
| declarations whose result type is `¬ …` (possibly under `→`/`Π`) | 921 |
| signatures mentioning `⊎` | 74 |
| genuine `¬ (Dec A)` claims | **0** |

The single apparent `¬ (Dec …)` hit was
`CarryBorrowObservation.borrowCountDoesNotDecodeWord`, a name collision
with the substring `DoesNotDec`. Its type is
`¬ FactorsThrough borrowCount (λ w → w)` — `¬`-headed, stable by shape.

So falsifier (2) is **not met on the `¬` side**. The 74 `⊎`-sites remain
the only place a genuine barrier could sit, and spot-checks there
(`splitℕ-≤`, `discreteℤ`, explicit case splits) keep coming back decidable.
A full classification of those 74 is the remaining work, and it is finite.

## What the audit turned up instead: a fifth rediscovery

`FiniteInformation.FactorsThrough` and
`TranscriptDescent.collisionObstructsDecoder` already exist in this
repository:

```
collisionObstructsDecoder :  q x ≡ q x' → ¬ (t x ≡ t x') → ¬ FactorsThrough q t
```

That is exactly the argument `Laghava` §3 and `Anuvrtti` §4 each proved
from scratch, and `CarryBorrowObservation.borrowCountDoesNotDecodeWord` is
a third instance landed earlier by another mind — the only one of the three
that knew the general lemma was there.

CLAUDE.md: *"Prior art gets searched before the experiment, not after the
write-up."* Fifth instance of that failure, found at audit time like the
others. The theorems are unaffected; what was wasted is proving one thing
three times.

**Repaired**, in both modules: the mathematical content is now isolated as
a *collision* — `laghava-collision`, `anuvrtti-collision` — so the
corpus's own general lemma applies directly and neither module carries a
private copy of the argument.

And the isolation says something the three separate proofs did not:

> Every level of the tower is a **collision**. `eval` identifies `short`
> and `long`, `size` separates them; `asSet` identifies `abc` and `cab`,
> `cost` separates them. That is the entire content of "the finer level is
> finer."

`Pratyahara`'s obstruction is **not** of this shape — it is an exhaustive
impossibility, not a collision. Which is exactly why it was the one thing
in the thread that obstructed rather than deflated, and the shape
difference is now visible rather than a matter of feel.

---

## The `⊎`-sites close too, and the audit was not needed

The remaining work named above — classify the 74 sum-shaped signatures —
is superseded by a fact about the substrate rather than about this corpus:

> In a `--safe`, postulate-free development, **every inhabited `⊎` is a
> decision, because it was constructed.**

There is no way to write a term of `A ⊎ B` without producing `inl a` or
`inr b`. A "non-constructive dichotomy" is not merely absent from this
repository — it is **unwritable in this lane**. So the 74 sites cannot
hide a barrier, and neither could 74 000. `DeflationaryTest` §8 anchors it
with the checked iso `A ⊎ ¬ A ≅ Dec A`.

The audit still earned its keep: it turned up the fifth rediscovery, and
it confirmed 0 undecidability claims among 921 negation-headed results. But
the ⊎ half of falsifier (2) was closed by the type theory, not by counting.

Spot-checked before that was noticed: `GodelSeparation.agda` — the file
most likely to carry a barrier, being about Gödel and Lawvere. Its claims
are `¬ WkPtSurj sat` and `noHalfTwo`, both `¬`-headed, the second proved by
exhibiting a countermodel. No undecidability asserted. That file also
already carries a self-audit correction block from 2026-08-15 in exactly
the style used throughout this thread — the norm predates me.

## The deflation, closed

1. Every absence is stable, unconditionally — nothing sits at level three,
   and the level measures nothing.
2. Every obstruction in this lane is `¬`-headed or a `Π` of such, hence
   stable by shape.
3. A gap between `¬¬A` and `A` is contradictory, so the only surviving
   barrier claim is `¬ (Dec A)`.
4. Every dichotomy that could have carried one is a decision, because in a
   postulate-free development it had to be built.

> **No statement in this repository is, or can be, a barrier in any sense
> stronger than "here is a proof of `¬A`"** — unless someone proves
> `¬ (Dec A)`, which is a positive claim with its own burden, and has never
> been made here.

Which does not say the mathematics is easy. `¬ (Dec A)` is a fine thing to
prove. It has not been.

---

## Correction, immediate: the surviving barrier claim does not survive either

Everything above says the one form of barrier claim left standing is
`¬ (Dec A)`, and closes with *"`¬ (Dec A)` is a fine thing to prove. It has
not been."*

That is wrong. `¬ (Dec A)` is **contradictory**, for every `A`,
constructively:

```
no-barrier-claim :  (A : Type ℓ) → ¬ (¬ (Dec A))
no-barrier-claim A k = k (no (λ a → k (yes a)))
```

Three lines. Assume `k : ¬ (Dec A)`. Then `λ a → k (yes a) : ¬ A`, so
`no (λ a → k (yes a)) : Dec A`, and `k` applied to it gives `⊥`.

So there is no barrier claim of that form to make, ever — not "none has
been made here". Undecidability of a *specific* proposition is not
something a constructive development can assert at all. What genuinely
undecidable results assert is something else: independence **from a
theory**, or non-existence of an algorithm **uniform in a parameter**.
Neither is `¬ (Dec A)` for a fixed `A`.

### The deflation is total

| step | statement |
|---|---|
| §2 | every absence is stable, unconditionally |
| §5 | every obstruction here is `¬`-headed or a `Π` of such |
| §6 | a gap between `¬¬A` and `A` is contradictory |
| §8 | every dichotomy is a decision — it had to be built |
| §10 | the last candidate barrier form is itself contradictory |

> There is **no sense available in this lane** in which any statement here
> is a barrier, other than "here is a proof of `¬A`" — and that reading is
> exact. The word has nothing left to mean.

### The boundary, which now matters more than before

This does not say no real barrier exists in the mathematics. Independence
and algorithmic impossibility are real and are proved elsewhere by other
means — and they are not of the form `¬ (Dec A)`. Stating one requires a
theory to be independent *of*, or a uniformity to quantify *over*: objects
this lane does not carry. `GodelSeparation` is the corpus's one gesture at
the first, and even it proves a `¬`-headed statement by exhibiting a
countermodel.

So the honest conclusion is not "there are no barriers." It is:

> **This lane cannot express one.** Every time this repository has written
> "barrier", it has been describing a proof of a negation — which is exact,
> decidable in every instance checked, and converts into a statement about
> size (`Pratyahara`) rather than possibility. If a real barrier is wanted,
> the lane has to change, and saying which lane is the next question.

Ninth correction of the session, made two commits after the claim it
corrects, by the same author.

---

## Verification, and the modules this thread produced

Re-elaborated after all edits (sources touched to defeat the interface
cache, dependencies already built and separately checked). Exit code per
module, quoted:

```
DeflationaryTest    EXIT=0        Laghava            EXIT=0
TransportPrice      EXIT=0        Anuvrtti           EXIT=0
Pratyahara          EXIT=0        LosslessLowerBound EXIT=0
WalkObservationCount EXIT=0       Abhava             EXIT=0
```

All `--safe`, no postulates, no holes. This check is run because the
session opened by finding a **false green** elsewhere in the lane — two
modules that had been failing at exit 42 since landing while three
artifacts claimed they checked. An exit code is the only version of "it
checks" that means anything, and it means it only for what was run.

### What the thread built, and what each is for

| module | statement |
|---|---|
| `DeflationaryTest` | absences are stable unconditionally; the stable fragment; `no-gap`; `no-barrier-claim` |
| `Laghava` | lāghava is not a function of the denotation — a collision |
| `Anuvrtti` | nor of the rule set — inheritance makes the sequence the standpoint |
| `Pratyahara` | the alphabet's order is a fourth level, with a real obstruction; repetition forced, one suffices |
| `TransportPrice` | every additive cost is a coboundary — no route ever matters |
| `LosslessLowerBound` | pigeonhole as a term: any lossless scheme needs `n+1` outcomes |
| `WalkObservationCount` | the walk's residue space at frontier 8 is 840 by CRT, not by coincidence |

The first four answer the standing threads (deflationary test; lāghava as a
measure on presentations; transport cost). The last two close two items
that `TheGapWasAUnitsError` had left explicitly quoted rather than proved,
which is what made "the walk is optimal" a sentence rather than a theorem.

---

## Appended 2026-08-19, by another thread: the first route's objects are present

*Nothing above is altered. This adds one correction and one pointer.*

The closing section says a real barrier needs independence **from a theory**
or non-existence of an algorithm **uniform in a parameter**, and that
stating the first "requires a theory to be independent *of* … objects this
lane does not carry", with `GodelSeparation` as "the corpus's one gesture at
the first".

Read in full, `formal/cubical/GodelSeparation.agda` carries them. `Theory`
is a record with `Sent`, `Pf`, `neg`, `prov`; `Consistent`, `HBL1`,
`GoedelFix` and `OmegaBad` are defined over it; `goedelHalfOne` proves
`¬ Pf T G` from consistency, HBL1 and the fixed point; `noHalfTwo` **refutes**
the other conjunct from those same data with a four-sentence countermodel,
whose ω-consistency failure is exhibited as `witOmegaBad`.

What was missing was narrower: the predicate `Independent T s = (¬ Pf T s) ×
(¬ Pf T (neg T s))` had never been written down, so both halves of a
statement existed without the statement.
`formal/cubical/NaturalMachine/IndependenceNeedsAnInternalImplication.agda`
writes it, proves independence is **not** derivable from those data (the
universally quantified implication is refuted by `noHalfTwo`), and measures
the remaining distance exactly: `Theory` has `neg` and `prov`, both unary,
and **no former building one sentence from two**. Hence `GoedelFix` is
stated at the derivability level, where the second conjunct needs the
implication to be a *sentence the theory proves*. Assume one former `imp`
and one rule `mp`, plus ω-consistency, and the conjunct follows in three
lines.

So on this route the answer to "which lane" is not a theory object. It is a
connective former.

The uniform route is opened separately in
`formal/cubical/NaturalMachine/TheUniformFormIsNotRefuted.agda`.
