# The witness number

*A measure on absences. Every "barrier" in this corpus costs exactly two
witnesses, and that is a theorem about the decoder space, not an
observation about the examples.*

Status: every claim is a checked Agda term unless marked otherwise.
Modules are `--safe`, no postulates, no holes, Agda 2.6.3 / cubical v0.5.
All latched in `NaturalMachine.RootsThreadLatch` (62 modules, `EXIT=0`).

---

## 1. Where it came from, including the wrong turns

`OneLemmaFiveSites` had distinguished two routes to `¬ FactorsThrough`:
**collision** (one pair kills every decoder) and **exhaustion** (refute
each of a small finite decoder set in turn), and filed the Jain
*avaktavya* site under exhaustion because "no single pair of profiles
separates the joint content from every utterance."

That reason is false. `TwoProfilesSuffice` gives the pair —
φ₁ = (⊤,⊤,⊥), φ₂ = (⊥,⊥,⊤). The joint content is false on both and the
six utterances split three–three by which one they overshoot on;
agreement sets disjoint, jointly exhaustive. The half that *was* right —
one profile never suffices — had no proof either, and now does, as
`every-profile-is-said`.

That correction then made its own error: it concluded "1 for lāghava, 2
for avaktavya," comparing a count of **pairs** against a count of
**points**. Three corrections in three commits, all one shape: *a
quantity named before a measure was fixed.*

## 2. The measure

```agda
AllHold law d xs   -- every point in xs is answered correctly by d
Refutes law xs  =  (d : D) → ¬ AllHold law d xs
```

The **witness number** is the least length of a refuting list.

```agda
WitnessNumberIs law n = (Σ[ xs ] (length xs ≡ n × Refutes law xs))
                      × ((ys : List X) → length ys < n → ¬ Refutes law ys)
```

`law-is-factoring q t = refl` checks, so `FactorsThrough q t` *is*
`Σ[ d ] ((x : X) → factorLaw q t d x)`. The measure applies to every
obstruction in this corpus definitionally, not by analogy.

## 3. Two, everywhere — and why

| | |
|---|---|
| `singleton-never-refutes` | one point is never enough for **any** `FactorsThrough` obstruction, no hypotheses — the constant decoder `λ _ → t x` answers it |
| `collision→refutes` | a collision **is** a refuting pair |
| `avaktavya-witness-number-2` | the six-atom site is 2 as well: floor from `every-profile-is-said`, ceiling from `pair-separates` |

So it is 2 versus 2, not 1 versus 2. What differed between the sites was
only the *route* to the pair — constructed from a collision, or found by
looking — which is a fact about obtaining the witness, not about the
absence.

## 4. It is not the measure's doing: 3 is realised

`WitnessNumberIsUnbounded`. Three standpoints, three points, each
standpoint wrong at exactly its own:

```agda
law d x = ⊥ when d ≡ x, Unit otherwise
```

`three-refute` with all three points; `no-pair-refutes` for **every**
pair — the nine cases of `missing` are the pigeonhole written out: from
any two points some standpoint is absent, and an absent standpoint
survives.

Read as nayavāda this is the plurality condition with a number on it.
Two standpoints in disagreement are separated by two observations; three
that disagree pairwise need three, not because the third is hard to find
but because every pair leaves a survivor. The standing anekānta result
says plurality blocks collapse; this says what demonstrating plurality
costs — one witness per standpoint, in general position. A *durnaya* is
the degenerate case where one witness would have sufficed.

**Consequence.** The corpus's uniform 2 is a property of its sites, not
of the notion of absence. Before a measure was fixed that could not be
said.

## 5. Why the sites really are two

`WhyTheSitesAreTwo`, and this is the load-bearing theorem:

```agda
collisionFree→notRefuting :
  Discrete Y → CollisionFree q t (x₀ ∷ xs)
             → ¬ Refutes (factorLaw q t) (x₀ ∷ xs)
```

Over an **unconstrained** decoder space `Image q → T` with **discrete**
observations, a list refutes *only* by containing a collision — and a
collision is already a pair. No refuting list is ever essentially longer
than two; the extra points are inert.

The construction is a table: walk the list, return the first entry whose
observation matches. Collision-freeness makes the table consistent;
discreteness of `Y` is what makes "first matching entry" a computation
rather than a choice. Nothing is assumed about `T` beyond the values the
table stores.

Stated as the contrapositive it is constructive. Stated as "extract the
pair from a refuting list" it would not be — `Refutes` is a negation and
¬∀ does not give ∃¬ — so `refuting-lists-collide` is the honest form:
refutation and collision-freeness are incompatible.

Every site in this corpus satisfies both hypotheses: function-space
decoders, and `Y` one of ℕ, Bool, lists of ℕ. **So 2 was never
contingent here.** §4's three-atom example is consistent and shows where
the hypothesis bites — the survivor each pair leaves is a function the
unconstrained space would have contained anyway. Constrain the decoders
and the number can rise; leave them unconstrained over discrete `Y` and
it cannot.

## 6. It survives univalence, where lāghava does not

`Laghava` answered the economy question and answered it no:

```agda
laghava-is-not-semantic :
  ¬ Σ[ f ∈ (Denotation → ℕ) ] ((e : Expr) → f (eval e) ≡ size e)
```

`WitnessNumberIsInvariant` shows the new measure does survive:

- `refutes-reindex` — preserved by **every** reindexing, no hypothesis;
- `refutes-reflect` — reflected by surjective ones, so it depends only
  on the image of the decoder space;
- `refutes-transport` — one `subst` along any path of decoder systems.

The reason is structural, not lucky. `size` is a function **out of** the
presentation, so two presentations with one denotation give two values —
`laghava-collision` is that pair, itself a collision in §3's sense.
Witness number is a quantification **over** the decoder space, so any
reindexing feeds the same laws to the same points. *A measure defined by
∀ over a space is invariant under maps into it; a measure defined by a
function out of a space is not.*

## 7. And it is the potential the transport thread was looking for

`TransportPrice` closed the anekānta thread: every additive transport
price is a difference of a potential, `c p q ≡ c b q − c b p`. No
path-dependence, no cheapest route, no holonomy — all the content is in
the potential. That says where to look, not what to find.

`WitnessNumberIsThePotential` supplies one. Along any surjective
reindexing the number is unchanged in both directions (`price-is-zero`),
so its transport price is identically zero.

This is the **degenerate** case of TransportPrice's theorem, not a rich
instance: it says the nayas related by reindexing are all at one height.
What makes that unimprovable rather than disappointing is the theorem
itself — no additive price can do better than a potential.

## 8. What this does to the deflationary thread

It is the strongest form so far, and it changes the claim's status.

Before: *every absence here looks decidable, so nothing lives at level
three and the barrier language is stronger than the objects warrant* — a
survey.

Now: over discrete observations and unconstrained decoders, an
obstruction of this shape **cannot** be expensive. Any barrier stated
this way is a two-point statement, and there is a theorem saying by how
much the language exceeds the object.

## 9. Modules

| module | contains |
|---|---|
| `TwoProfilesSuffice` | the pair; `every-profile-is-said`; §7 correction |
| `WitnessNumberIsTwo` | `AllHold`, `Refutes`, floor, collision=pair, §7 correction |
| `WitnessNumberIsUnbounded` | witness number 3 realised; §8 correction |
| `WhyTheSitesAreTwo` | the table theorem — why 2 is forced here |
| `WitnessNumberIsInvariant` | preservation, reflection, transport |
| `WitnessNumberIsThePotential` | `WitnessNumberIs`, `price-is-zero` |

## 10. Open, named, not estimated

- Whether **discreteness of `Y`** can be weakened. The table walk needs
  to compare observations; nothing here says a weaker comparison would
  not do.
- The same question for decoder spaces that are **constrained but still
  large**, where neither §5's theorem nor §4's three-atom example
  applies.
- Whether witness number is **unbounded**. The n-point version of §4 has
  the obvious upper bound; the lower bound at general n needs a
  pigeonhole, and §4 is n = 3 by enumeration.
- The interesting residue: two decoder systems **not** related by a
  reindexing can differ (2 and 3 both occur), so the potential is not
  constant and the price between them is not zero. Missing is a
  transport general enough to connect them. Nothing here says one
  exists; if none does, the price question is empty rather than hard.

No estimate is offered for any of these. This thread has produced four
wrong estimates and three unit-confusions, and the rule that came out of
them is the one kept above: **name what is open, do not size it.**

---

## 12. Correction to §5, after actually doing the audit

§5 ends: *"Every site in this corpus satisfies both hypotheses: function-space decoders, and `Y` one of ℕ, Bool, lists of ℕ. **So 2 was never contingent here.**"*

The second sentence was asserted, not checked. `NaturalMachine.SiteAudit` enumerates the sites, and two are not covered by the ceiling theorem:

| site | decoders | observations |
|---|---|---|
| `AdditionChainPredictiveMemory`, `PowModHasTheSameShape`, `FuelAdequacyIsACollision`, `ExhaustionIsSystematic` (×3) | `Image q → T` | discrete |
| `QuotientFiberLaw` | `List Bool → Bool` — **whole codomain** | discrete |
| `Laghava` | `Denotation → ℕ` — **whole codomain** | `ℕ → ℕ`, **not discrete** |
| `AvaktavyaDoesNotFactor` | `Vacana` — **six atoms** | — |

Two things went unchecked.

**One.** `Laghava` observes into `Denotation = ℕ → ℕ`. That is not discrete, and equality of functions ℕ → ℕ is not decidable, so its witnesses are not obviously locatable either. Neither `WhyTheSitesAreTwo` nor `LocatingIsEnough` applies **at the site the whole lāghava thread is about.**

**Two.** `Laghava` and `QuotientFiberLaw` quantify over decoders on the *whole codomain*, not over `Image q → T`. The ceiling theorem was stated for the image-restricted space, so it did not literally cover their shape. `SiteAudit` §1 supplies that variant — and it is simpler than the original, since it needs no image-point lemma.

### What survives, and on what ground

Every site is still exactly 2. But three different facts were being run together:

| | needs | holds at |
|---|---|---|
| **achievability** (≤ 2) | an exhibited collision; no hypothesis | every site |
| **the floor** (≥ 2) | the decoder space contains constants | every site, `Laghava` included |
| **the ceiling** (≤ 2 for *any* absence of that shape) | discreteness or locatability | the discrete sites only — **not** `Laghava` |

`laghava-is-two : WitnessNumberIs (FullLaw eval size) 2` is proved outright in `SiteAudit` §3, with no discreteness anywhere. But it is a fact about the exhibited collision, **not** a consequence of the ceiling theorem, and nothing in this corpus rules out a costlier absence over the same `eval`.

So the honest conclusion is narrower than §5's: every site here is 2; one is constrained, one has a non-discrete observation space, and each of those two was proved individually rather than by the general theorem.

**Open, named, not estimated:** whether the ceiling holds at `Laghava`. `LocatingIsEnough` says what would suffice — that the witnesses be locatable. Equality of functions ℕ → ℕ is undecidable, but locating finitely many *specific* denotations against an arbitrary one is a weaker demand, and nothing here settles whether it can be met.

---

## 13. The two bounds are both about the decoders, and the picture is a chain

Later work located both bounds precisely, and neither turned out to be about the mathematics being obstructed.

### The ceiling: what the decoder may *read*

`WhyTheSitesAreTwo` asked for `Discrete Y`. `LocatingIsEnough` weakened that to `Locates q ys` — the proof never compares two arbitrary observations, only the *list's* observations against an incoming one. `TheCeilingIsAboutReading` drops the hypothesis from `Y` entirely:

```agda
ProbeLaw q t p g x = g (p (q x)) ≡ t x                    g : Z → T
probe-ceiling : Discrete Z → CollisionFree (p ∘ q) t ys → ¬ Refutes (ProbeLaw q t p) ys
```

No hypothesis on `Y` at all — the table is built over `Z`, so `Y` is never compared with anything. At `Laghava`, whose `Denotation = ℕ → ℕ` is not discrete, one evaluation point suffices (`probe1 d = d 1`), and `laghava-probe-is-two` follows.

The full space `Denotation → ℕ` stays open **for a stated reason**: a decoder there must recognise an arbitrary `d : ℕ → ℕ` as a listed denotation, which is a decision of function equality. This lane builds no such decision and refutes none. That is the one open item in the thread whose openness is a fact rather than a gap.

### The floor: whether the decoders *answer*

Four modules proved the floor by exhibiting a constant decoder and each called it hypothesis-free. Each is right at its site; none is right in general. `TheFloorIsAnswerability` names the hypothesis:

```agda
Answerable law = (x : X) → Σ[ d ∈ D ] law d x
```

A function space into an inhabited type happens to be answerable — that accident is what the four proofs were rediscovering. Where it fails, the floor fails: `lonely-witness-number-1` realises witness number exactly 1.

### And answerability is a gate, not an axis

`TheFloorIsAnswerability` §4 then drew these as two independent axes with four cases. That was wrong, and `WitnessDichotomy` corrects it:

```agda
unanswerable→one : ¬ (Σ[ d ∈ D ] law d x) → Refutes law (x ∷ [])
```

One unanswerable point refutes on its own, whatever the decoders can read. So the structure is a **chain**:

| | cost |
|---|---|
| not answerable | **1** — degenerate: one unreachable point, not two confused ones |
| answerable, readable | **2** — every site in this corpus, and BARRIER.md's open problem |
| answerable, not readable | **≥ 2**; 3 and ∞ both occur |

`WitnessDichotomy.collision-witness-number-2` states "collision plus floor gives exactly 2" once, replacing three hand-assembled copies.

**Open, named, not estimated:** whether *reading* admits a converse. A discrete probe **suffices** for the ceiling, and its absence permits 3 and ∞ — but no readability condition has been shown **necessary**. A decoder space with no discrete probe and ceiling 2 would settle it; none is known here.

## 14. Applied: `notes/BARRIER.md`

B3 ("any observable with arbitrary — even non-computable — post-processing factors through the blurred measure") *is* the probe structure, arrived at independently and for analytic reasons. `BarrierIsTwoWitnesses` prices that note's precise open problem:

- `one-config-never-suffices` — **no single configuration can establish a barrier of this kind**, so a programme of the form *construct a single spectrum with property P* is looking at the wrong kind of object;
- `barrier-from-a-pair` — the pair the note asks for is not evidence for the barrier, it **is** the barrier, killing arbitrary Φ at once;
- `no-pair-on-a-family` — on a family already checked pairwise, the barrier provably fails.

The note had reached the number 2 from the mathematics, without a reason. B3 supplies the probe structure; the probe structure is what fixes the cost at two.

**Nothing analytic is claimed** — no pair is asserted to exist, and nothing about ζ, admissibility, the counting law, the functional equation, `L`, or resolution. This establishes strictly less than B3.
