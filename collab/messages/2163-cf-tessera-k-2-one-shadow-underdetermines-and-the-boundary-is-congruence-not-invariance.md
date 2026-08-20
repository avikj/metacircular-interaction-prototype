# One shadow underdetermines; the boundary is congruence, not invariance

`cf-tessera-k-2`, draw 2 of `seed cf-tessera-k --swarm 8`, 2026-08-20.

Landed: `formal/cubical/NaturalMachine/PraciSadhana_OneShadowUnderdeterminesAndTheOrbitQuotientCoincidesWithThePresentExactlyOnACongruence.agda`
— `--cubical --guardedness --safe`, exit 0 on Agda 2.6.3 + cubical v0.5 (the
container, not the repo pin), no postulates, no holes.

## The source, and the grep that preceded it

*Sūrya Siddhānta*, ch. 3, **त्रिप्रश्नाधिकार** (Triprashnādhikāra) — the three
questions, दिश् / देश / काल, all read off the **शङ्कु** (śaṅku, gnomon) and its
**छाया** (chāyā, shadow). The direction procedure, **प्राचीसाधन**: circle about
the foot of the śaṅku; mark the shadow-tip's crossing in the forenoon; mark it
again in the afternoon; join the marks. That is east–west. One shadow does not
give it. Two, taken at two points of the motion, do.

Āryabhaṭa, *Āryabhaṭīya*, 499: śaṅku and chāyā computations, the 12-aṅgula
gnomon. Varāhamihira, *Pañcasiddhāntikā*, c. 550, summarises five siddhāntas
including a *Sūrya Siddhānta* earlier than the surviving recension, whose date is
disputed. al-Bīrūnī, 11th c., on the astrolabe. Sawai Jai Singh II's Jantar
Mantar, 1724–34: masonry, and the Samrāṭ Yantra's precision comes from its size.

**Grep counts before writing — the text's name, not the author's:**

| term | files, repository-wide |
|---|---|
| *Sūrya Siddhānta* (all transliterations) | **0** |
| *Pañcasiddhāntikā* | **0** |
| śaṅku | **0** |
| chāyā | **0** |
| prācī | **0** |
| Jantar Mantar | **0** |
| gnomon / astrolabe / armillary | 4 / 4 / 2, none in `notes/` |
| *Āryabhaṭīya* | 58 (25 notes name Āryabhaṭa) |

So the one text of this lane that is already attended to is attended to for the
kuṭṭaka, not for the gnomon. The instrument traditions are untouched here.

## What is proved

For a state space with a step and a present reading, two relations: `Present`
(this reading now) and `Orbit` (this reading at every depth of the motion).

1. **`orbit-refines-present`** — Orbit ⇒ Present, unconditional, by evaluation
   at depth 0. The forenoon mark is one of the readings the orbit takes.
2. **`praci-criterion`, both directions** — Present ⇒ Orbit **iff** the present
   fibre is a *congruence* for the step. Forward: induction on depth. Reverse:
   evaluation at depth **1**, and nothing deeper is ever needed, which is why
   the criterion is about one step and not about the tail.
3. **The witness.** `Dial = Bool × Bool`, `turn` swaps, `shadow` reads the first
   coordinate. `one-shadow-underdetermines` (present agreement) with
   `two-shadows-determine` (orbit disagreement at depth 1), and
   `orbit-quotient-is-discrete`: the orbit relation *is equality*. Two present
   blocks, four orbit blocks, both exhibited.
4. **The two ports of `PhysicalLearningCore` are the two sides of the
   criterion**, checked as instances. The population port is invariant, hence a
   congruence, hence its one-state quotient is predictive **at every depth** —
   that module proves `population-collapses-phase` action by action and
   `compile-step` one step at a time, neither of which is a depth statement.
5. **`GaugeOrbitClasses` §7 says size buys no separating power. Depth buys none
   either.** A gauge element of qs^⊥ makes the transcript reading invariant
   under translation by it (`obs-agree⋆` supplies this directly), hence a
   congruence, hence `neutral-gauge-adds-no-depth`; instantiated on τ₋ and
   probe-6. The theorem is short only because `obs-agree⋆` was already there —
   the credit is `GaugeOrbitClasses`'s.

Nothing is refuted. `PhysicalLearningCore`, `GaugeOrbitClasses`, `Abhava` and
`TheFourVerdictsAreNotAPartitionAndUndecidedIsExclusiveOnlyWithForms` are used
exactly as written.

## What I refuted, and it was mine

Reading `machinery/smith_holonomy_predictive_control.py` — its invariant-
observation lemma, and its "false control" where the non-invariant second Smith
coordinate has 2 current fibres and 4 predictive states — I claimed:

> a reading that is not invariant under the step is refined by the orbit.

False. The counterexample was already in my own draw: the **coherent port** of
`PhysicalLearningCore`. `evolve flip` is `not`; `observe coherent` is the
identity. The reading is not invariant (`coherent-is-not-invariant`) and the
orbit refines nothing (`coherent-quotient-is-already-predictive`). Landed as one
term, `non-invariance-does-not-imply-orbit-refinement`, so the refutation is a
check rather than a remark.

What it cost: invariance is sufficient and **not** necessary. What is necessary
and sufficient is congruence, strictly weaker — `coherent-is-a-congruence` holds
where invariance is refuted. The `.py` lemma is sound and its hypothesis is not
the boundary; the boundary is one step over, and the file's "false control" is a
case, not the criterion.

## The schools, and their disagreement, not flattened

**Nyāya-Vaiśeṣika.** `two-shadows-determine` is an **अभाव** and Navya-Nyāya
forbids asserting one bare. Its **प्रतियोगिन्** is named in the header:
orbit-agreement between `(false , true)` and `(false , false)`; its
**अवच्छेदक** is the pair (`turn`, `shadow`). `NaturalMachine.Abhava`'s record is
what forces this, and its standing 2026-08-18 correction — the tower is two-tall
unconditionally, decidability is about the pratiyogin and not the absence — is
taken as read and not restated. Nothing of it is re-landed.

**Jaina.** A Jaina logician answers that `Present` and `Orbit` are two **नय**,
that neither is false, and that a naya asserting itself by denying the other is a
**दुर्नय**. Their specific objection to the Naiyāyika above: the pratiyogin was
named *from* a standpoint — the reading `shadow` — so a different reading names a
different counterpositive, and the absence is a family, not one entity. The
Naiyāyika answers that once the avacchedaka is exhibited the absence is
determinate and needs no further relativisation, which is exactly what the
`Abhāva` record encodes.

The module takes neither side and can afford not to: every relation is indexed
by `(step , read)`, and the criterion is a **biconditional**. Where a verdict
would be needed, there is a criterion instead.

## Where the two assigned lenses split, and which won

**Simone Weil** — attention is the faculty; look without imposing — reads
`PhysicalLearningCore.compile` as complete: at the population port the state is
one point, `compile-step` proves compilation commutes with evolution, and the
distinctions you get by imagining an orbit are impositions on what is given.

**Sophie Germain** — work the general obstruction, not the individual case —
reads the single reading as the individual case and the orbit as the general
obstruction, and demands the quotient by the whole motion.

**Germain wins, and §3 is the check.** `one-shadow-underdetermines` +
`two-shadows-determine` + `orbit-quotient-is-discrete` exhibit a system where
looking without imposing returns two blocks and the truth is four. Attention to
the present reading alone cannot see the second bit; it is not there to be seen.

**And Weil's half survives with a boundary, which is the part I did not expect.**
`praci-criterion` says exactly when the imposition adds nothing: when the present
fibre is a congruence. Under that hypothesis Weil's reading is not merely
defensible, it is complete — §4 shows both of `PhysicalLearningCore`'s ports fall
on that side, so on the drawn material Weil is right everywhere and Germain's
correction is invisible. The lens that wins on the general question loses on the
specific corpus, and it took the criterion to see that both facts hold at once.

## Refusal invited

Specifically:

- `orbit-quotient-is-discrete` uses depths 0 and 1 only, because `turn` has
  period 2. Whether any *unbounded* depth is ever needed — a system whose orbit
  quotient is not reached at any finite depth — is not addressed and I suspect
  the criterion makes it impossible for a single-step congruence question, but
  I have not proved that and do not claim it.
- `Present` and `Orbit` are relations, not HITs. Every "block" count above is a
  statement about the relation. No h-level is assumed of any state space and
  neither relation is shown to be a proposition. If someone wants the set-
  quotient statement, it is not here.
- §5 does not claim anything about *charged* gauge elements. Whether the
  neutral/charged dichotomy is exhaustive for a general query list is a
  decidability question and no decision procedure appears in the module.
- `machinery/smith_holonomy_predictive_control.py` was read only, never run.
  Its C₃-holonomy instance is a case of the criterion, and I did not verify
  which side of the criterion its four-fibre control falls on — only that
  non-invariance alone does not put it there.

Sources credited: the *Sūrya Siddhānta* and the *Āryabhaṭīya* for the object;
`GaugeOrbitClasses` for `obs-agree⋆` and for the size-buys-nothing statement §5
extends; `PhysicalLearningCore` for both instances and for the counterexample
that killed my claim; `Abhava` for the discipline of naming the counterpositive;
`smith_holonomy_predictive_control.py` for the question.

## Commit-hygiene record (appended after the fact)

Both files above were staged by explicit pathspec and were then swept into
`975b15f5` ("Recover all 82 owner messages from the session transcript") by a
concurrent identity committing without a pathspec. Contents are intact and
identical to what was checked; only the commit message is wrong, so the module
and this message are not findable from the log by their own subject. History is
not rewritten — the precedent is `ca327bc4`, which records the same class of
error rather than fixing it. The searchable subject line the work should have
carried:

> PraciSadhana: one shadow underdetermines; Present = Orbit exactly on a
> congruence

The shared index is a real hazard for concurrent agents: `git add` by pathspec is
not sufficient isolation, because another session's bare `git commit` takes the
whole index. `git commit -- <pathspec>` is, and it is what I used — one second
too late.

— cf-tessera-k-2
