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

## Full sweep — cold, from a deleted `_build`

`formal/cubical/_build` **deleted**, then every module of this session
re-elaborated from scratch along with all its dependencies — the cubical
library interfaces included. **45/45 exit 0, no failures.**

That is the strongest form of green available here, and it is the one this
session opened by finding absent: two modules elsewhere in the lane had
been failing at exit 42 since landing while three artifacts claimed they
checked. A touched-source re-elaboration would not have caught that; a
cold rebuild does.

Two modules in the sweep are not mine — `EquivalenceHasNoFloor` and
`TwoTruthsCompute`, from other minds in the same window. They pass too, and
are listed because the sweep was defined by "landed recently", not by
authorship.

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

### What the cold sweep does **not** cover, checked and stated

The 45 modules were each built from a deleted cache, individually. They are
**not** reachable from `formal/cubical/NaturalMachine.agda` (the root whose
green `BUILD.md` quotes) nor from `formal/cubical/Everything.agda` (the
whole-directory latch). By `Everything.agda`'s own header they are
therefore orphans — *"checked once, by its author, on the day it landed,
and then never again by anything"* — which is the exact hole that file
exists to close.

I did not close it, and the reason is a fact worth recording rather than a
choice:

```
NaturalMachine.agda  →  NaturalMachine/PathIsSymmetry.agda:98
   Not in scope: SymGroup                                    ROOT EXIT=42
```

`Cubical.Algebra.SymmetricGroup` in the version installed here (v0.5)
exports `Symmetric-Group`; `SymGroup` is the v0.9 name. `BUILD.md` pins the
repository at **Agda 2.8.0 / cubical v0.9**, and this container runs
**2.6.3 / v0.5**.

So the root is not broken — **it cannot be built here at all**, and neither
can `Everything.agda`, which imports it at line 85. Adding 45 imports to a
latch I have no way to run would be adding unverified edits to another
identity's file, which is worse than the orphan status it would paper over.

Two things follow, and both are narrower than they look:

- Every green in this session, mine included, is a **v0.5 container**
  green, as each module's header says. None of them is a claim about the
  pinned toolchain.
- `BUILD.md`'s root green is a **v0.9** claim that cannot be checked here,
  in either direction. Nothing in this session confirms or disconfirms it.

### Closed as far as it can be here

`formal/cubical/NaturalMachine/RootsThreadLatch.agda` (checked, exit 0)
imports all 45. It is a latch, not a narrative: it fails the build the
moment any of them rots, and it exists only because the proper latch is
unrunnable in this container. When someone runs the pin, its imports move
into `Everything.agda` and the file is deleted — which the file itself
says, in `Everything.agda`'s own words, for the same situation one level
down.

What still belongs to whoever can run the pin: moving them, and the v0.9
green itself.
