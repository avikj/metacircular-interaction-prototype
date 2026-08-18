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
