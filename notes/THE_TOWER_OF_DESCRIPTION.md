# The tower of description: five levels, four separations, every one a term

**Status:** twelve checked Agda modules, re-elaborated after all edits with
sources touched to defeat the interface cache. Exit 0 each, `--safe`, no
postulates, no holes (Agda 2.6.3 / cubical v0.5 — the container, not the
repository pin).
**Sources:** Piṅgala, *Chandaḥśāstra* (c. 300–200 BCE) — prastāra, naṣṭa,
uddiṣṭa, saṅkhyā. Virahāṅka, *Vṛttajātisamuccaya* (c. 600–800) —
mātrāmeru. Pāṇini, *Aṣṭādhyāyī* — lāghava, anuvṛtti, pratyāhāra, the
śiva-sūtras. Āryabhaṭa (499) — kuṭṭaka. Gaṅgeśa and the Navya-Nyāya on
abhāva. Voevodsky — `ua`.

---

## The tower

| level | what it records | separated from the level above by |
|---|---|---|
| 1 | **cardinality** — a type up to equivalence | — |
| 2 | **denotation** — which function | `TheTower.cardinality-forgets-which` |
| 3 | **rule set** — which rules are present | `Laghava.laghava-collision` |
| 4 | **ordered text** — the sūtrapāṭha, in its order | `Anuvrtti.anuvrtti-collision` |
| 5 | **alphabet order** — the śiva-sūtra list | `Pratyahara.no-order-makes-all-intervals` |

Every separation exhibits two objects the coarser level identifies and the
finer level distinguishes. Three of the four are **collisions**. The
fourth is not — it is an exhaustive impossibility whose content is a
**size**: three positions impossible (all 27 checked), four sufficient
(`x y z x`). There is no third kind anywhere in this session's work.

## Where each tradition's tool sits

- **Univalence sits at level 1, exactly.**
  `UnivalenceErasesTheAlgorithm.transport-is-the-equivalence` proves via
  `uaβ` that transport along `ua e` *is* `e` — the equivalence and nothing
  beneath it. So `ua` is the tool for the top level and is blind to 2–5 by
  construction. Not a defect: it keeps exactly what an equivalence is.
- **Lāghava sits at 3–5**, and had to be invented separately for that
  reason. `Laghava.laghava-is-not-semantic` proves no function of the
  denotation computes it; `Anuvrtti.anuvrtti-is-not-a-set-function` proves
  no function of the rule set does either.
- **The obstruction sits at 5, and only there.** Levels 1–4 have
  collisions; level 5 has the consecutive-ones failure, and it forces
  repetition — which is what the śiva-sūtras do with ह.

## What the tower does for the corpus

It explains a thing that had been happening without a name: this
repository keeps proving that some measure "does not factor through" some
coarser object, three times in one session and once earlier by another
mind (`CarryBorrowObservation`), each time from scratch, and each time
without noticing that
`TranscriptDescent.collisionObstructsDecoder` and
`FiniteInformation.FactorsThrough` — and their Lean twins
`Pairfield/FiniteInformation.lean` — already exist.

Every one of those results is a level boundary. There is one lemma, it is
checked, and it is in both lanes.

## And it locates the flagship open problem

`notes/THE_BARRIER_PROBLEM_IS_A_COLLISION.md`: `BARRIER.md`'s Proposition
B3 says WL observables **factor through** the blurred measure, and its
"barrier problem (precise)" asks for two admissible configurations the
blur identifies and pair-correlation separates. That is a level boundary
of exactly the collision kind — the same two premises, in the same order,
against the same lemma.

And `notes/OFFDIAGONAL_NO_GO.md` already produced one, without naming it:
evil versus odious numbers, identical off-diagonal pair layers, different
configurations. **The corpus's one genuine barrier is a collision, and its
one genuine obstruction is a size.** Nothing else survived.

## The three optimality results, which are the tower read upward

`OptimalObservation` defines `Optimal X Y obs = Injective obs × (card Y ≡
card X)` and proves it forces minimality among all lossless schemes. Three
instances, all previously in this repository and never compared:

| scheme | equivalence | date |
|---|---|---|
| Piṅgala's uddiṣṭa, inverted by naṣṭa | `Vak n ≃ Fin (saṅkhyā n)` | c. 300 BCE |
| Virahāṅka's mātrāmeru | `Metre n ≃ Fin (mātrā n)` | c. 600–800 |
| the walk at frontier 8, by CRT | `Fin 840 ≃ residue vector` | — |

Each is optimal, hence minimal, by four lines proved once. Piṅgala's `2ⁿ`,
Virahāṅka's mātrāmeru and the walk's 840 are not counts that happen to be
small; they are minima.

And the difference between them lives entirely below level 1: naṣṭa halves,
mātrāmeru recurses, CRT splits by coprime moduli, and the path that
identifies them keeps none of it.

## Verification

```
DeflationaryTest EXIT=0   Laghava EXIT=0   TransportPrice EXIT=0
Anuvrtti EXIT=0           Pratyahara EXIT=0
LosslessLowerBound EXIT=0 WalkObservationCount EXIT=0
PingalaIsOptimal EXIT=0   OptimalObservation EXIT=0
UnivalenceErasesTheAlgorithm EXIT=0   TheTower EXIT=0   Abhava EXIT=0
```

Re-elaborated after all edits. This session opened by finding a **false
green** elsewhere in the lane — two modules failing at exit 42 since
landing while three artifacts claimed they checked — so exit codes are
quoted per module and mean only what was run.

## Not claimed

- That the tower is complete. Levels 3–5 are Pāṇini's, read off the
  Aṣṭādhyāyī's actual devices; a tradition with other devices supplies
  other levels. What is proved is that these five are distinct.
- That node-count is Pāṇini's lāghava. It is not — his counts morae and
  rule-slots. The theorems are about the *shape*: any measure separating
  two same-denotation presentations is non-semantic by that fact.
- That the three-letter obstruction is why ह is doubled in the
  śiva-sūtras. The real family is the one his rules require, and
  identifying it is philology this work does not touch. What is shown is
  that consecutive-ones **can** fail, so "why is anything repeated?" has a
  structural answer available and not only a historical one.

---

## Full sweep

All 35 modules authored in this session re-elaborated in one pass, sources
touched to defeat the interface cache, dependencies already built and
separately checked. **No failures.**

```
Apavada  PythagoreanTransition  IdempotenceForbidsDescent
DescentIsNotInversion  NoNormOnAJoin  DescentCostsTheIntegers
BoundedStateNeedsAGroup  SignIsNotAccumulable  OverlapIsTheCost
JoinSavesTheMeet  TheTrajectoryIsAChain  NumberIsExponentialInDerivation
TheDerivationIsDenseToo  TheGapWasAUnitsError  WhereTheCircleSplits
EveryTripleIsARotation  Cakravala  CakravalaNeedsKuttaka
DeflationaryTest  Laghava  TransportPrice  Anuvrtti  Pratyahara
LosslessLowerBound  WalkObservationCount  PingalaIsOptimal
OptimalObservation  UnivalenceErasesTheAlgorithm  TheTower
CRTChain  CoprimePowers  BezoutIsGCD  DistinctPrimesAreCoprime
CoprimePowersN  FrontierCount
```

Three threads, one session:

1. **The conic** — the barrier belongs to the line; bhāvanā carries the
   transition; triples are a monoid; every triple is a rotation; the
   cakravāla step, and its dependence on the kuṭṭaka.
   (`notes/THE_BARRIER_BELONGS_TO_THE_LINE.md`)
2. **The deflation and the tower** — no obstruction here is a barrier and
   none can be; five levels of description with four separations.
   (`notes/EVERY_OBSTRUCTION_HERE_IS_EXACT.md`, this note)
3. **Optimality** — pigeonhole, CRT at any frontier, and "optimal" as a
   definition with three instances 2300 years apart.
   (`notes/THE_WALK_IS_OPTIMAL_AND_HERE_IS_WHY.md`)

Nine corrections were made along the way, seven of them to claims made in
the same session, and every one of them landed on a claim about magnitude
or scope rather than on a claim about structure.
