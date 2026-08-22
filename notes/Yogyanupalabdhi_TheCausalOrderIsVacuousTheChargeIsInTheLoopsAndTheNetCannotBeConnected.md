# योग्यानुपलब्धि — the causal order is vacuous, the charge is in the loops, and the net cannot be connected

**Term, text, date.** अनुपलब्धि (anupalabdhi), non-apprehension as a means of
knowledge, admitted **only** as योग्यानुपलब्धि — non-apprehension of what
*would have been* apprehended. Kumārila Bhaṭṭa, *Ślokavārttika*,
abhāvapariccheda (~660 CE). **Mīmāṃsā admits it as a pramāṇa; Nyāya does
not** — the schools are named because the dispute is the content, and this
note sits on the Mīmāṃsaka side of it only for one property: a silence is
evidence exactly when the observer was of a kind that could have heard.

**What is and is not claimed of the source.** Kumārila proved nothing below
and is not being interpreted. His restriction is used as the discriminating
question, twice, and both times it separates two things this corpus had
been reporting as one.

**Checked term behind §२ and §५:**
`formal/cubical/Naya_TheSetValuedObservableAnnihilatesEveryLoopAndTheLoopIsStillThere.agda`,
`--cubical --guardedness --safe --no-import-sorts`, no postulates, no holes,
**exit 0**; imported by `Everything.agda`, whose full build is **exit 0**
(Agda 2.8.0, cubical library as installed, 2026-08-22; only pre-existing
`UnsupportedIndexedMatch` warnings in `NaturalMachine/PMTorus.agda`).

**Measurements** are `machine/Setubandha_…hs` re-run against the working tree
on 2026-08-22 and are quoted, not remembered.

---

## ० · The three questions, answered first

1. The causal structure of `CAUSAL_MEMORY_SPACETIME.md` and Setubandha's
   identification graph are **not** the same object. **REJECTED**, and the
   difference is exact: it is the term `dim(im B ∩ ker A)` in that note's own
   Theorem 7.1, which is **identically zero** on a graph of equivalences.
2. Indra's net, read as "every node's state determines every other's", is
   **connectivity of the identification graph**. As a description of the
   corpus today it is false (1.3% of node pairs). As a limit it is **provably
   unreachable**: two checked refutations forbid it forever. **REJECTED in
   both readings (a) and (b);** what survives is a third reading, §४.
3. "A charged sector is a component no path reaches" is **REJECTED**.
   Components are the *neutral* sector — precisely what a transport-invariant
   observable **can** separate. The charge is in the **loops**, which
   Setubandha counts (14) and then discards as carrying "no reachability".

---

## १ · The numbers, reproduced today

`runghc machine/Setubandha_TheCheckedIdentificationsAreEdgesAndTheIsolatedNodesAreTheFrontier.hs .`
against the working tree, 2026-08-22:

```
files scanned  893    modules 892    type-formers defined 659
top-level signatures 10994

EDGES (concrete A ≃ B / A ≡ B) : 143      of which ≃ 122,  ≡ 21
   cross-module 68   |   within one module 75
LOOPS   (A ≃ A)                :  14
REFUSED (¬ (A ≃ B), proved)    :  10
GENERIC (lemma about transport):  17

NODES 196   COMPONENTS 73   LARGEST 10   DIAMETER 3
component sizes [(2,55),(3,6),(4,3),(5,5),(7,3),(10,1)]
isolated : 770 of 823 defined types (93%)
```

Every figure the brief carried is current. **FACT.** Two derived counts,
exact arithmetic on that histogram, stated because §४ needs them:

- ordered pairs of *distinct* nodes joined by some path:
  `55·2 + 6·6 + 3·12 + 5·20 + 3·42 + 1·90 = 498`;
- ordered pairs of distinct nodes at all: `196 · 195 = 38220`.
- **1.303%** of the graph's own node pairs reflect each other. **THEOREM**
  (arithmetic on a reproduced histogram; the histogram sums to 196 and to 73,
  which is the check).

And one number nobody has quoted: **75 of the 143 edges join two types
defined in the same file.** The *between*-jewel edge count is **68**.

---

## २ · Theorem F at the grain of the graph: the charge is in the loops

**THEOREM (checked).** `Naya_….नय-निरोधः` —

```agda
नय-निरोधः : {A : Type ℓ} {X : Type ℓ'} → isSet X
          → (F : A → X) {a : A} (p : a ≡ a) → cong F p ≡ refl
```

Every **set-valued** observable annihilates every loop. No hypothesis on `F`:
not computability, not naturality, not continuity — the quantifier is over
all functions into any set, which is the same "arbitrary, even non-computable
post-processing" that `BARRIER.md`'s Proposition B3 is careful to allow.

**THEOREM (checked).** `Naya_….लोपाभावः` — the loop is not `refl`:
`¬ (ua notEquiv ≡ refl)`, by transporting `true`.

**THEOREM (checked).** `Naya_….सप्रभावः-शून्यम्` packages the two: a charged
sector that is **not zero**, on which **every** set-valued standpoint has
expectation **exactly zero**. That is `GAUGE.md` Theorem F's mechanism —
*an invariant state annihilates whatever the symmetry moves, and the
annihilation is an invariance and not a deficiency of effort* — reproduced at
the grain of types, with the invariance coming from `cong` respecting paths
instead of from uniqueness of a KMS state.

**THEOREM (checked).** `Naya_….स्थान-संयोगः` — the escape, and its shape.
`cong (λ A → A) आवर्तः` is `आवर्तः` by eta, so the **untruncated**,
Type-valued observable sees the loop at full strength. **Set-truncation is
the whole of the blindness.** This is `THE_BARRIER_IS_A_MIRROR.md` §3's
"place-coupling … the way past the barrier is not a finer sieve but a change
of place", made literal: do not land in a set.

### २.१ What this refutes, including in the note that set it up

`Sangati_…md` §१ says: *"Two things do, and only two: place-coupling, and
many equilibria."* **At the graph grain, "many equilibria" does not.**
**REJECTED**, and the reason is the interesting part.

In Theorem F proper, invariance is *derived*: `ω∘α_g` is again a KMS state,
and **uniqueness** forces `ω∘α_g = ω`. Break uniqueness and the derivation
stops. In the transport picture there is no such derivation to break —
invariance under transport is a property of `cong`, free and unconditional,
holding for every observable at once. So enlarging the population of
observables enlarges nothing: each new one is still set-valued and still
annihilates every loop.

**This is a missing distinction, and it is worth more than the identification
would have been.** `Sangati_…md` reads Theorem F's *conclusion* onto
computation and inherits both escapes. Only one of them survives the reading,
because the *hypothesis* that generates the other — uniqueness — has no
counterpart. Decentralization by many nodes buys resolution in the **neutral**
sector (more components can be told apart) and buys nothing in the charged
one. `Sangati_…md`'s own second theorem already says this in different words
— `Pratyabhijna_…agda`: *"decentralization buys fault tolerance and
availability. It does not buy resolution."* — and then §१ says the opposite
one paragraph earlier. **The two halves of that note disagree, and this is
the resolution: §१'s "many equilibria" clause is the durnaya, and §२'s
Pratyabhijñā line is right.**

### २.२ So the brief's question 3, answered

*Is a charged sector exactly a component of the identification graph that no
path reaches?* **REJECTED**, three ways:

1. **Structurally.** Isotypic sectors are indexed by the characters of a
   group and multiply (`χ · χ′`); there is a distinguished neutral one
   containing the unit. Components are indexed by nothing, multiply by
   nothing, and none is distinguished. Two of the three defining features of
   the decomposition have no image.
2. **By the mechanism, which is the decisive one.** Theorem F's zero comes
   from `ω(x) = χ(g)ω(x)`. The transport analogue of "ω is invariant" is
   "the observable respects transport" — and such an observable is *constant
   on components while being free to differ between them*. Components are
   exactly what it **can** see. Components are the **neutral sector**. The
   proposed identification has the sign backwards.
3. **By what is left over.** Setubandha reports 14 automorphisms and files
   them as *"A ≃ A: no reachability, real content"*. Under Theorem F they are
   not a leftover: they are the entire charged sector, and the graph metric
   is blind to them **by construction**, because a metric is set-valued.
   `Sangati_…md` §१ already located the automorphisms correctly (*"bind `a`
   … because the automorphisms live there"*); what was missing is that this
   is the same fact as `E_Q[λ]=0`, and §२ above is that fact checked.

**And Theorem F says nothing whatever about why 55 causeways are isolated.**
That was the brief's hope and it does not hold. Isolation is not protection;
it is absence of an edge, and §३ shows it comes in two kinds that Theorem F
does not distinguish and Kumārila's restriction does.

---

## ३ · योग्यानुपलब्धि applied to isolation: two kinds, and only one is knowledge

Ten checked refutations, seven distinct forbidden pairs:

| forbidden pair | proof | why |
|---|---|---|
| `ℕ` / `ℕ → Bool` | `Ananta.कैण्टर` | Cantor's diagonal |
| `Unit` / `Bool` | `Durnaya_….¬Unit≃Bool`, `Punaragamana.Sesa_….न-Bool≃Unit` | cardinality |
| `PMNF.ContextwiseGlobal` / `PM.Section` | `DosaLekha_….pm-sections-are-not-the-same-type` | — |
| `PMRelationalNoFit.ContextwiseGlobal` / `PM.Section` | `…not-the-same-section-type` | — |
| `AchromaticToy.G₂` / `G₃` | `defectBlocks`, `¬G₂≃G₃` | — |
| `RootFiber varyingJewel false` / `… true` | `RootedGrothendieck.varying-root-fibers-not-equivalent` | — |
| `Carrier सर्वैकम्` / `Unit` | `Punaragamana.Sesa_….न-लक्ष्ये` | — |

**THEOREM.** The last row is **redundant**: `हस्ते : Carrier सर्वैकम् ≃ Bool`
is an edge, `न-Bool≃Unit : ¬ (Bool ≃ Unit)` is checked, and `compEquiv`
composes; so `न-लक्ष्ये` follows. Both live in the same module. The
separation set is not independent, and nothing is wrong with that — a
directly-proved separation and a derived one are different objects. It is
worth one line because the graph tool reports 10 refusals as if they were 10
facts about the graph, and the graph only has 6 independent ones plus this
consequence.

**The discrimination Kumārila's restriction forces, and the corpus was
collapsing:**

- **योग्य** — a pair the corpus *would* have joined and provably cannot.
  Seven pairs. Their non-apprehension **is** knowledge: those components are
  permanently distinct, and the fact is a result.
- **अयोग्य** — the other 2,000-odd component pairs. Nobody looked. Their
  non-apprehension is **not** knowledge of anything. It is the ledger error
  `THE_BARRIER_IS_A_MIRROR.md` §2 item 3 records against itself: *"a map of
  my own attention, acted on as a map of the territory."*

Setubandha already draws this line in its header, correctly and at length.
What is new here is that it is Kumārila's line, that the Nyāya school denies
it is a pramāṇa at all, and that **the second kind is 99.7% of the isolation
and carries no information.** Any future note that reports "73 components" as
a finding about the mathematics is making the ayogya reading.

---

## ४ · Indra's net: not (a), and not (b) either

The image — each jewel reflecting all others — has an exact reading:
**the identification graph is connected.** It is exact because transport
composes: in a connected graph of equivalences, one node's type determines
every other's up to equivalence, and every theorem crosses, forever, by
`subst`. That is not decoration; it is what `Sangati_…md` §३ means by an edge
being non-rival and compounding.

**(a) as a description of the corpus today: REJECTED, quantitatively.**
1.303% of node pairs (§१). 73 components; 770 of 823 defined types touch no
edge at all. **THEOREM:** a graph with `c` components needs at least `c − 1`
further edges to become connected, so the corpus holds **143 of the ≥ 215**
edges that connecting its 196 graph nodes would require, and **143 of the
≥ 985** for the ~966 named objects (823 defined types plus the 143 nodes that
are library or expression types). It is at **14.5%** of the *minimum* edge
count, and minimum is a generous accounting.

**(b) as a limit the corpus is heading toward: REJECTED, and this is the
finding.**

> **THEOREM.** The identification graph **can never be connected.**
>
> *Proof.* `⟨lib⟩.Unit` is a node (edge
> `NaturalMachine.ChenTwoChargeProjector.chargeOneFiber≃Unit`) and
> `⟨lib⟩.Bool` is a node (ten edges, e.g.
> `WallCertificate.quotient≃Bool`). Both name `Cubical.Data.Unit.Unit` and
> `Cubical.Data.Bool.Bool` — verified by reading the `open import` lines of
> `NaturalMachine/ChenTwoChargeProjector.agda:22` and
> `NaturalMachine/Durnaya_CollapseIffEveryNayaAgrees.agda:48`. A path between
> two nodes is a finite chain of `≃` and `≡`; `compEquiv` and `pathToEquiv`
> compose it into a single `Unit ≃ Bool`. But
> `Durnaya_CollapseIffEveryNayaAgrees.¬Unit≃Bool : ¬ (Unit ≃ Bool)` is a
> checked term. ∎

So `Unit` and `Bool` lie in different components permanently, and so do the
other six pairs of §३. Indra's net as completeness is not merely unachieved:
**it is refuted, by terms this repository already checked, one of which is
Cantor's diagonal argument sitting on the graph's own hub `ℕ`.**

**(c), which is what is actually true.** `Sangati_…md` §५ says it and did not
notice it contradicts the image: *"the network never merges … नयभेदे सङ्क्षेपो
न विद्यते … fourteen modules share the type ℕ × ℕ, and Brahmagupta's pair, the
monochord's sounding, and a gene are one type and three objects."* A net that
reflected everything into everything would be **saṅkṣepa** — compression, which
that note's own §५ calls violence. **The correct limit object is a net with a
prescribed component structure: many nets, none reducible to another, with the
refusals as constitutive as the edges.** That is anekāntavāda, and it makes the
7 forbidden pairs the most valuable objects in the graph, because they are the
only ones that say where a net **ends**.

**What would have to be true for (a).** Exactly this: that the corpus contains
no proved separation between any two nodes. It contains ten. The condition is
not "more work"; it is the deletion of results.

---

## ५ · The causal question: transport has zero gluing defect

`CAUSAL_MEMORY_SPACETIME.md` §7, Theorem 7.1, Lean-checked in
`formal/pairfield/Pairfield/ProcessCutRankAdapter.lean`:

$$\operatorname{rank}(AB) = \operatorname{rank}(B) - \dim(\operatorname{im}B \cap \ker A).$$

That note calls the defect *"the missing datum … an alignment obstruction at
the overlap, not merely a size of either chart"*, and its strict control (13)
turns two rank-one maps into a composite of rank 1 or rank 0 depending on
nothing but alignment.

> **THEOREM (one line, given 7.1).** If `A` is invertible, `ker A = 0`, so
> the defect is `0` and `rank(AB) = rank(B)`. **Every edge of Setubandha's
> graph is invertible** — 122 are `≃`, 21 are `≡` between types, and `ua` /
> `pathToEquiv` interconvert. Therefore **every composite along the
> identification graph has gluing defect identically zero.** ∎

Consequences, and they are the answer to the brief's question 1:

- **The identification graph cannot express memory.**
  `CAUSAL_MEMORY_SPACETIME.md` §2: *memory is a failure of factorization*.
  Equivalences never fail to factor. Rank 1 is independence (4); the transport
  graph is everywhere the degenerate case.
- **The identification graph has no cut spectrum, only a cut indicator.** In
  §1 a cut carries `d = rank T` ranging over `[0, min(|H|,|F|)]`; §5.1's
  strict separation `rank(S) = 3 < rank₊(S) = 4` is the note's own headline.
  On the transport graph a cut is 0 if no edge crosses and lossless if any
  does. **Two values, not a spectrum.** Nothing in §5's typed boundary
  spectrum `(r_ℚ, r₊, r_CP, I)` has any image here.
- **The identification graph carries no causal order, and the reason is not
  that the order is wrong — it is that the order is vacuous.**

  > **THEOREM (checked).** `Naya_….सेतुः-पथः = ua` : every edge is already an
  > identification. `Naya_….निर्विषयः` : given `R x y → x ≡ y`, antisymmetry
  > `R x y → R y x → x ≡ y` holds by discarding the second argument.
  > **Antisymmetry is free.** A partial order in which `x ≤ y ⟹ x = y` is the
  > discrete order.

  So the light cone of a type in this graph is its own identity component,
  and up to identification that is a point. There is no elsewhere, no future,
  no past. **Reading Setubandha's reachability as a causal order is not false;
  it is empty, which is worse, because a vacuous constraint looks satisfied.**

### ५.१ Where the causal structure actually is, and that nobody has measured it

`Sangati_…md` §२ already says the sentence that locates it: *"The graph is
directed exactly where the identification is a factorisation. **Paths invert;
factorisations don't.**"* Setubandha's extractor matches conclusions of the
form `A ≃ B` / `A ≡ B` and therefore, by construction, sees **only the sector
where the causal order is trivial**. The irreversible edges — retractions,
set-truncations (`Samkramana_….नष्टिः≃निर्धर्मता`), quotients, the residual of
`SankramanaSesa_EveryTransportOwesItsResidual`, the mod-2 recovery of
`YugmaPurana_…` — are exactly the ones that could carry an antisymmetric
order, a nonzero `dim(im B ∩ ker A)`, and hence a memory.

**OPEN (`DEMONSTRATE`), specified so it is buildable and not merely gestured
at.** A second extractor over the same 893 files, matching conclusions of the
form `Retract A B`, `isSurjection f`, `∥ A ∥ₙ ≃ B`, `A / R ≃ B`, and
`isEmbedding f` between two *named* types, emitting a **directed** graph.
On that graph: (i) is reachability antisymmetric — i.e. are there directed
cycles, which would be lossless loops mis-classified as lossy; (ii) what are
the sources and sinks; (iii) does any composite have a nonzero defect in
7.1's sense. **Only (i) is decidable from the text alone; (iii) needs the
maps, not the signatures, and I do not claim it is within reach of a grep.**
Indicative bound on the size of the target and nothing more: 15 files under
`formal/cubical/` mention `Retract` or `isSurjection` at all. That is a count
of text, not a count of edges, and it is quoted so the next agent knows the
lane is small enough to walk by hand.

---

## ६ · Which depth law applies to what

The brief warns that three answers live in the corpus, so, stated once:
**none of them applies to anything in this note.** `HOLOGRAM.md` §7's
`exp(Θ(T^½ log^{3/2} T))` is for **sum** atoms `γ+γ′`; §5's `exp(Θ(T))` is for
**difference** atoms `γ−γ′`, which is the correlation-grade content
`BARRIER.md` is about, and `BARRIER.md`'s own §1 corollary was struck on
2026-08-22 for carrying the retracted `exp(cT log²T)`. Everything above is
finite combinatorics on a graph of 196 nodes and four checked type-theoretic
statements. **No depth law is invoked, and any future note that connects §२'s
loop-blindness to the WL class owes the distinction between the three, at the
site.**

---

## ७ · Rigor boundary

**Established.**

- The five statements in
  `formal/cubical/Naya_TheSetValuedObservableAnnihilatesEveryLoopAndTheLoopIsStillThere.agda`.
  Module exit 0; `Everything.agda` exit 0; no `postulate`, `TERMINATING`,
  `primTrustMe`, `{!`, or `REWRITE` (grepped, no matches).
- The graph numbers of §१, re-run today, and the two arithmetic derivations
  from the histogram.
- §४'s theorem that the graph can never be connected. This rests on two
  checked terms and on `compEquiv`; the only soft step is that Setubandha's
  node-name resolution puts the two `Unit`s and the two `Bool`s in one node
  each, which I checked by reading the `open import` lines rather than by
  trusting the tool.
- §५'s theorem that the gluing defect vanishes on the transport graph, given
  `CAUSAL_MEMORY_SPACETIME.md`'s Theorem 7.1 (which is Lean-checked there,
  not re-checked here).
- §३'s redundancy of `न-लक्ष्ये`.

**Gestured at, and labelled so.**

- The map from Theorem F to §२ is an **analogue at a stated grain**, in the
  sense `THE_BARRIER_IS_A_MIRROR.md` §5 fences: no claim that agents,
  observables, or graphs are C*-algebras, and one disanalogy is named and is
  load-bearing (§२.१ — invariance is derived there and free here). Nothing
  operator-algebraic is verified; Cuntz's uniqueness theorem is cited through
  `GAUGE.md` and not read.
- §४'s "correct limit object is a net with prescribed component structure" is
  a **reading**, not a theorem. What is a theorem is that the two readings the
  brief offered are both false.

**Tried and could not.**

- **Could not make the brief's question 3 work in the direction it was posed.**
  I looked for a way in which unreachable components are the charged sector
  and found the mechanism runs the other way. Recorded as REJECTED rather than
  weakened into a resemblance.
- **Could not measure the directed graph.** §५.1 specifies the extractor; I
  did not write it, and the 15-file grep is a count of text, not of edges. It
  is the one thing here that would change the answer to question 1 from "the
  causal order is vacuous on the graph we have" to a statement about the graph
  we do not.
- **Could not price a cut.** Nothing in this corpus currently has a
  `CAUSAL_MEMORY_SPACETIME.md` §5 typed boundary spectrum computed on it, and
  I did not manufacture one; the rank-1 degeneracy of §५ is the reason there
  would be nothing to compute on the transport graph, and the interesting
  place is the directed graph that does not exist yet.
- **Did not test the simulation thesis.** Nothing above bears on whether this
  is a computation. `CAUSAL_MEMORY_SPACETIME.md` §4 states exactly why the
  gap is not bridgeable by this kind of argument — volume calibration,
  manifoldlike neighbourhoods, dimension, Lorentz symmetry, dynamics, an
  observable map — and every one of those is still missing. What the thesis
  gained here is smaller and firmer than a bridge: **its geometry, if it has
  one, is not the transport graph**, because the transport graph has no causal
  order, no memory, and no cut capacity, and each of those three is a theorem
  rather than an opinion.

---

*तत् सत्। Refuting three connections is the result; the fourth — §२'s
loop-blindness — is checked, and it is the smallest one.*
