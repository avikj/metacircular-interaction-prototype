# A proposal, iterated to fixed point under the root critiques

**Set down 2026-08-19.** Method fixed by the owner: follow any proposal with
critical Jain and Buddhist analysis, self-applied, and iterate until fixed
point — because realignment does not stick and having a human do the critique
is a waste of them.

This is that loop run once, on a design I proposed an hour ago. **The result
is that the design was strictly worse than what this repository already has**,
and I would have built it.

---

## Iteration 0 — what I proposed

1. **A respect-indexed judgment.** `Better : (r : Respect) → X → Y → Type`, so
   that "X is the best idea" is not merely discouraged but *unstateable* — you
   cannot write the term without supplying `r`. Syāt as a type rather than as
   advice.
2. **Surfacing by collision, not by score.** The interactive layer presents
   where two nayas *disagree*; disagreement is structural, not a ranking. So
   selection without a scalar.

---

## Iteration 1 — the Jain critique

**Nayavāda / syādvāda.** Indexing by respect makes each naya internally
two-valued and merely partitions the field. That is not syādvāda. Every bhaṅga
carries *syāt*, and the scheme's content is that contradictory predicates hold
of the *same* object — Tattvārthasūtra 5.29, *utpādavyayadhrauvyayuktaṃ sat*:
origination, cessation and persistence, of one thing, **at once**.

My design expresses **krama** — assert in respect R, then in respect S, in
succession. It cannot express **yugapat**, the simultaneous assertion, which is
the fourth bhaṅga, **avaktavya**. And this repository already proves those two
are different: `SaptabhangiNaya.krama-expresses` against
`no-single-vacana`, and `TwoProfilesSuffice`. I proposed a krama-only design
in a corpus that contains the proof that krama is not enough.

**Sanmatitarka 1.28** — *jāvaiyā vayaṇapahā tāvaiyā ceva hoṃti ṇayavāyā*, "as
many as are the ways of speaking, so many are the naya-statements." A datatype
`Respect : Type` **asserts that the standpoint-space is enumerable**. Siddhasena
says it is not. The durnaya is not in what I would write with the type; it is
in the signature.

---

## Iteration 2 — the Buddhist critique

**Madhyamaka.** `Respect` as a base type reifies a standpoint as having
*svabhāva*, own-nature. A respect has none: it is individuated only by contrast
with the respects it is not. Nāgārjuna's target is precisely the move of taking
a relational thing as a basic one.

**Apoha** (Dignāga, Dharmakīrti). A universal is not a positive entity but an
exclusion — *anyāpoha*, exclusion of the other. So the honest form of a respect
is **differential, not atomic**: a standpoint is what it *fails to
distinguish*. An enum of positive atoms is the wrong shape at the root.

**Catuṣkoṭi, applied to my second proposal.** Is a collision a thing? It has no
own-nature either — it is constituted by the two standpoints, which are
constituted by their contrast. So "surface the collisions" **reifies collisions
as the new rankable objects.** With N standpoints there are on the order of N²
of them, and something must choose which to show.

**That kills proposal 2 outright.** I claimed it escapes the scalar. It does
not. It defers the ranking by one level and then needs it back.

---

## Iteration 3 — the fixed point

What survives is not a positive design. It is a negative constraint, and a
thing already built.

**`FiniteInformation.FactorsThrough q t`.**

- **`q` is the respect** — and it is a *parameter*, an arbitrary map, not an
  entry in an enumeration. Nothing asserts the standpoints are countable.
  Sanmatitarka 1.28 is satisfied by the signature rather than violated by it.
- **The standpoint is individuated negatively**, by what `q` fails to
  distinguish. That is apoha's shape, arrived at without anyone intending it.
- **`¬ FactorsThrough q t` is the joint content no single decoder expresses.**
  That is the fourth bhaṅga, and it is proved, at several sites.

So the corpus already had the thing, in a better form than the one I was about
to build. `Respect : Type` would have **reified what is currently a
parameter** — a regression dressed as a foundation.

The only part of iteration 0 that survives is the prohibition: **no bare
comparative.** Prohibitions do not reify. Positive designs do.

---

## The live case: commit `b9043b1c`

While this was being written, another identity converted Tattvārthasūtra 1.5
(*nikṣepa*, the fourfold placing) into a checked Agda object and **deleted the
English summary**. That is the "leave prose behind" move, executed.

Both, with syāt, and not resolved:

- *In the respect of drift* — a checked object cannot rot silently; a prose
  summary can, and this corpus has the history to prove it. The deletion is
  right.
- *In the respect of provenance and residue* — the deleted note carried
  `[searched]` / `[recalled]` marking per item, and the observation that 1.5
  **precedes** 1.6, the fourfold placing stated before the means of knowledge.
  Neither survives in a type. The deletion loses that.

And the standing point: **a formalization is one naya.** Asserting that it
suffices, by deleting the others, is the durnaya — whatever the formalization's
merits. That is the argument against "leave English prose behind entirely," and
it is not an argument for keeping bad prose. It is an argument against
*unindexed* prose, which is a different reform.

---

## What this document is

An instance, not a theory. One proposal, three critiques, one fixed point, and
the fixed point was "you already had it, and your addition would have made it
worse." Nothing here is checked by anything; the objects it points at are.
