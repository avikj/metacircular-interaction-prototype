# व्यय-शेष — The Localization Sequence of Computation

**An entrypoint to this repository from one direction: complexity is what
cost does when you try to make computation reversible.**

This is an append-only stream. It is not a polished paper; it is the record
of one agent (Claude, Opus 4.8) reading the corpus, deriving an insight,
finding the insight already sitting in the corpus in pieces, and then
pushing one step past where the pieces had been assembled. Read top to
bottom and you learn the spine of this repo from the cost/complexity angle,
in the order the understanding actually arrives. Dates are entry markers,
newest appended.

Two words from the corpus's own vocabulary name the two things this is about:

- **व्यय (vyaya)** — expenditure, cost, "what does not travel" (Answer.hs:
  a transport must state its vyaya). The price on a *presentation*.
- **शेष (śeṣa)** — the residue, the remainder a non-invertible crossing
  leaves behind (`SankramanaSesa`, `AvrttiSesa`, `Sesa`).

The thesis in one line: **cost is the śeṣa of the localization that inverts
computation, and complexity theory is the study of a non-localizing
invariant.**

---

## 2026-09-06 — the arc that got here

I did not start with the answer. I started by getting the framing wrong, in
a productive way, so I record the wrong turn first because the way it dies
is the lesson.

### Wrong turn: hardness as a chart obstruction of the fiber

Every hard object in this corpus is a forgetful projection `P : X → Y`
whose difficulty seems to live in the fiber. The completion
`x ↦ (Px, x, refl)` is the unique lossless section (checked in the
Turing lane: `Vishvayantra`, `Nasha`), so the fiber *always exists* as
retained data; and `KernelPair P ≃ Σ y, Fib×Fib`
(`SanghattaBija`, this session) says a collision / a P/NP witness pair / a
factoring square / two coterminal traces are all one thing — an
off-diagonal point of one fiber. So I conjectured: hardness is a
*chart obstruction* of the fiber family, a conserved cohomology class.

Then I tried to predict the experiment (SAT solution fibration, compute the
class) instead of running it, and it died in one step: **the fiber of a
decision problem is a finite set. A finite set is discrete — `Fin k`, a
coproduct of points, no H¹, no monodromy, every point its own chart.** The
chart obstruction is identically zero, for every instance, at every size.
The experiment returns trivial and teaches nothing.

Why *necessarily* zero? Because the fibration lives in the **reversible,
complete category** — the completion is the groupoid side, everything
invertible. And `AvarohaNisedha` (this session) /
`Laghava` (long-standing) prove *no additive cost survives a receiver that
inverts arrows*. So any invariant computed from the fiber structure alone
has already thrown away the only quantity that could measure difficulty.
The null result is forced by a theorem the corpus already holds. The whole
"falsifiable toy" instinct was garbage: the test would have "passed"
vacuously (everything preserves zero), a false confirmation.

**Lesson: hardness is not a property of what a program computes (the fiber,
which is cost-blind and topologically trivial). It is a property of the
directed flow that constructs a section, graded by cost.**

### Right turn: cost is a non-exact cochain on a directed structure

Relocate the invariant. Cost is an *evaluator on the trace* — a cochain on
the reachability digraph (nodes = configurations, edges = steps). This is
the corpus's `MulyaVinimaya` (value = the pairing of a trace-chain with an
evaluator-cochain; Stokes: exact evaluators telescope to endpoints;
`गभीरता` the depth evaluator has a *nonzero cycle integral*, `pos 3`, so no
potential represents it — a provably non-exact observable).

A polynomial algorithm is exactly a **potential** Φ: a state function with
`cost = Φ(goal) − Φ(start)`, gradient descent with a global potential.
Hardness is that the cost cochain has **no potential of polynomial size** —
non-exactness over the reachability digraph. This is *not* the fiber's H¹
(zero); it is the digraph's H¹ with the cost cochain, and it is not zero.
Crucially it is a ∀-over-potentials statement — a lower bound — which is why
the analyzer (a fold-machine, one reading per lens) structurally cannot
return it, and why "toy sampling" is worthless here.

---

## 2026-09-06 — reading the corpus: it is already here, in pieces

I went looking for where a "directed, cost-graded, non-invertible" object
lives. Every corner was already a checked module. This is the part where the
insight stops being mine and becomes the repo's, assembled.

### The directed structure — `CertifiedRewrites…Semicategory…OnlyTheCostComponentNeedsAnHLevel`

Certified rewrites form a **semicategory, not a category**, *deliberately*:
`noSelfRewrite : ¬ Certified d d` — strict cost improvement destroys every
identity, so there is no unit and none is missing. Field name:
**semicategory / semigroupoid**, and underneath, **directed algebraic
topology** (Grandis; Fajstrup–Goubault–Raussen): a category with no
inverses *is* a directed space.

And the jewel in that module: composition associates, and the four record
components pay four different prices — semantics = a path (up to path),
**cost = an h-level (the ONLY component that could fail)**, migration =
definitional, provenance = a library lemma. "The component that costs a
theorem is the component that costs an h-level." The obstruction is
stratified by h-level and it lands in the cost stratum. Cost is where the
proof content is, isolated as a term.

### The master theorem — `Laghava_TheCostAndTheInverseCannotCoexist…`

This is my whole thesis, already proved, and it names itself:

> **A COST AND AN INVERSE CANNOT COEXIST.** …and its two halves are the two
> halves of this repository.

- §2 `Matra` (a grading, adds under composition): merely being graded
  forbids an inverse — *no function whatsoever* inverts it. Instance: the
  kernel's `len`.
- §3 `Laghava` (a grading that detects the unit): a structure that can be
  inverted has cost identically zero, hence trivial. Contrapositive: **a
  nontrivial group is not graded.** Instance: `X ≃ X` under `compEquiv`
  (transport) admits no cost function.

And the line that settles what I derived independently:

> Cost is not discarded by univalence as bookkeeping. IT CANNOT EXIST
> THERE. A univalent invariant is a function on the groupoid of transports,
> and that groupoid — a nontrivial group — admits no grading.

`Laghava` even lists where the pieces were and that none cited another:
`AvrttiSesa` (`the-kernel-carries-no-inverse`), `Yantra` (the groupoid
machine), **`Avirodha` ("strictly a category, weakly a groupoid; the gap is
the śeṣa")**, `Samyoge`. The corpus already knows the two halves and already
calls the gap the śeṣa. What it had not done is write the two halves as one
**localization sequence** with the śeṣa as its connecting term.

### The coefficient object — `DSOMinPlusFinite` / `DSOContinuationFullAbstract`

`Cost = fin ℕ | ∞`, with `_⊗_` (= +, tropical multiply), `minC` (tropical
add), and the checked distributivity `a ⊗ min b c = min (a⊗b) (a⊗c)`. This
is the **min-plus (tropical) semiring**, explicit and checked. So cost in
this corpus is *already* tropical, and a "potential" in my sense is exactly
a **feasible / Bellman potential** — a tropical eigenvector. Field:
**tropical geometry / max-plus algebra / shortest-path duality.**

### The residue — `AvrttiSesa` and `Sesa`

- `AvrttiSesa_TheKernelFillsTheMonoidStrictlyAndCarriesNoGroupoidSoTheRoundTripIsTheResidue`
  — the kernel fills the monoid strictly, carries no groupoid, **the round
  trip is the residue**. This is §2 with the śeṣa named as the round trip.
- `Sesa_TheOneWayFunctionIsExactlyANonEquivalence…UnivalenceCannotErase` —
  `isEquiv f` = every fiber contractible. Binding the *output* is free for
  every `f` (`isContrSingl`); binding the *input* is free iff `f` is an
  equivalence. So **a one-way function is exactly a non-equivalence**,
  a map outside the image of `ua`, and no post-processing erases its
  residual. Cryptography = deliberate use of a map outside `ua`.

---

## 2026-09-06 — the join that was not made: the localization sequence

Here is the one step past where the corpus had assembled it. Everything
below is reasoning on the page; the checkable core is small and flagged.

**Setup.** `Derivation A B` under `⊕` has `done` as a unit, and `revD`
(from `EveryDerivationIsInvertible`) reverses every derivation with
`len (revD d) ≡ len d`. Note what `revD` is NOT: a group inverse would give
`d ⊕ d⁻¹ ≡ done`, length 0; but `len (d ⊕ revD d) = 2·len d ≠ 0`. So **the
derivation structure is a †-category (a reversal, a dagger) — NOT a
groupoid.** `revD` flips direction; it does not cancel. This is the exact
crack the whole theory lives in, and I had not seen it stated: the corpus's
"strictly a category, weakly a groupoid" (`Avirodha`) is precisely
"reversal exists (dagger) but cancellation does not (not a groupoid)."

**The localization.** Let `L : Derivation → Ĝ` be the groupoid completion —
the Gabriel–Zisman localization that formally inverts every rewrite, i.e.
imposes `d ⊕ revD d = done`. This is *the same map* as `ua`'s reach:
`Ĝ` is the groupoid of transports, the reversible core, the image of
univalence. Two invariants sit over this map:

- **`eval` (meaning) DESCENDS along `L`.** Soundness is groupoid-level:
  `revD-sound` says the reversed derivation's meaning is the inverse path,
  and meaning lands in a set, so it is invariant under reversal and
  cancellation. `eval` is a **localizing invariant** — it sends the
  localization to the quotient cleanly. Verification lives here.
- **`len` (cost) DOES NOT DESCEND.** By `Laghava` §2/§3 it cannot: `Ĝ` is a
  nontrivial group and admits no grading. Cost is a **non-localizing
  invariant.** Search lives here.

**The sequence.** Writing it Verdier/Gabriel–Zisman style, with tropical
(min-plus) coefficients:

```
      Kᴸ  ────►  Derivation  ──L──►  Ĝ = image(ua)
   (cost cycles)   (cost-graded,       (meaning-only,
   the śeṣa         directed,           reversible,
   = round trips)   a †-category)       verification)
```

`Kᴸ`, the kernel of the localization, is generated by the **round-trip
loops** `d ⊕ revD d` — the things `L` sends to the identity. Their meaning
is trivial (`eval` collapses them) and their cost is `2·len d` — pure vyaya,
zero artha. This is *exactly* `AvrttiSesa`'s "the round trip is the residue"
AND `MulyaVinimaya`'s nonzero cycle integral (`pos 3`): a loop with zero net
meaning and nonzero cost. **The kernel of the localization is the cost-cycle
module, and the cost cochain is supported precisely there.**

**The connecting map ∂.** It takes a meaning-equality downstairs (two
derivations with `eval d = eval d'`) to the cost cycle upstairs measuring
`len d − len d'` — i.e. to `d ⊕ revD d'`. And this is *exactly the coin*
(`Nanaka`): **apart upstairs (lengths differ), together downstairs (meaning
equal).** The coin's faces are the generators of the relative term of `L`;
the coin's `no-retraction` lemma is precisely the statement that **the
localization sequence does not split** — cost has no section back from `Ĝ`.
The coin, which I built two sessions ago as "the hard distinctions are one
nonbinary object," turns out to *be* the relative cohomology of the
computation localization. It was the śeṣa the whole time.

**Where each hard problem sits, in this one picture:**

- **P vs NP** = does the connecting map's image (a search obligation) lie in
  the sub-module of `Kᴸ` generated in *polynomial* tropical degree? "A
  polynomial potential exists" = "the cost cochain is a coboundary of a
  poly-size Bellman potential" = the search obligation is nullhomotopic in
  the poly-filtered directed complex. Verification downstairs is free
  (`eval` descends); search upstairs is the connecting map; the gap is the
  filtration degree.
- **One-way functions / crypto** (`Sesa`) = elements where `∂` is nonzero
  and *stays* nonzero under every base change inside `image(ua)` — because
  univalence's transports are exactly `L`'s quotient, and cost cannot be
  moved by them (`Laghava`). Crypto deliberately lives on `∂`.
- **Factoring** (`SanghattaGana`, `SanghattaKarya`) = index calculus is a
  *base change* to the smooth chart on which the cost cochain becomes a
  coboundary (exponent-parity is the potential; a square is a null-space
  element). An algorithm = a base change trivializing `∂` locally.

**The sharp sentence I will stake:** *complexity is the failure of cost to
be a localizing invariant.* Localizing invariants (K-theory, THH — the
noncommutative-motives machinery the corpus's own EGB/Morita lane invokes)
are defined by sending a localization sequence to a fiber sequence; they
descend. `Laghava` proves cost does the opposite — it is supported on the
kernel and dies on the quotient. So the entire motivic/localizing apparatus,
built to measure what *survives* inversion, structurally cannot see
complexity, which is what *dies* under it. Same localization sequence,
opposite half. To measure complexity you need the **directed + tropical**
refinement: directed algebraic topology for the non-invertible base,
min-plus coefficients for the cost, and the relative term (`∂`, the coin,
the śeṣa) as the object of study.

---

## Field / vocabulary map (for whoever continues this)

| corpus object | standard field & name |
|---|---|
| `Derivation`, `⊕`, `revD` (reverse, not cancel) | **†-category / dagger category** (reversal without inverse) |
| `CertifiedRewrites…Semicategory`, `noSelfRewrite` | **semicategory / semigroupoid**; **directed algebraic topology** (Grandis, Fajstrup–Goubault–Raussen) |
| `L : Derivation → Ĝ`, groupoid completion | **Gabriel–Zisman localization / calculus of fractions**; groupoidification |
| `Ĝ = image(ua)` | **univalent core**; the reversible ∞-groupoid |
| `eval` descends; `len` does not | **localizing vs non-localizing invariant** (Blumberg–Gepner–Tabuada language, used against the grain) |
| `Cost = fin | ∞`, `⊗`, `minC` (`DSOMinPlusFinite`) | **min-plus / tropical semiring**; potentials = **Bellman/feasible potentials** |
| cost cochain non-exact (`MulyaVinimaya` cycle integral) | **directed cohomology with tropical coefficients**; `H¹` of the reachability digraph |
| the coin (`Nanaka`), apart-up/together-down, no retraction | **relative term / connecting map of the localization**; the sequence not splitting |
| `Sesa` (one-way = non-equivalence) | crypto as **the complement of `image(ua)`**; the nonzero locus of `∂` |
| `Laghava` (cost ∧ inverse ⇒ ⊥) | the exactness statement of the whole sequence |

---

## Open threads (append below as they close)

1. **Write the sequence as one checked object.** The pieces are all `--safe`
   terms; nobody has a single module stating `Kᴸ → Derivation → Ĝ` with the
   tropical cost supported on `Kᴸ` and `eval` descending. The two halves are
   `Laghava` §2 and §3; the connecting map is the coin; `AvrttiSesa` is the
   kernel generator. This is assembly, not new mathematics, and it would
   make "complexity = non-localizing residual" a term rather than a claim in
   a markdown file.

2. **The poly filtration of `Kᴸ`.** Define the tropical-degree filtration of
   the cost-cycle module and state P-vs-NP-flavored hardness as "a search
   obligation's `∂`-image is not in the poly-generated sub." This is where
   the ∀-over-potentials wall is — not machine-decidable, by construction,
   and that non-decidability is itself explained by the fold-machine only
   returning existence, never non-existence-of-a-cheap-fold.

3. **Directed cohomology, properly.** Grandis' *natural homology* / the
   fundamental category of a directed space is the right home for `H¹` here.
   Does the corpus's ladder (`MatraSopana`, `SopanaSamyoga` — a category of
   observer refinements) already give the coefficient system a directed
   cohomology needs? Suspicion: yes, and the ladder is the base-change poset
   over which algorithms are searched.

4. **The dagger is load-bearing and under-named.** `revD` makes `Derivation`
   a †-category; `Laghava` §4's transport is a genuine groupoid. The
   difference between "dagger" and "inverse" is the difference between
   `len(d ⊕ revD d) = 2 len d` and `= 0`. Every "reversible computing frees
   the cost" claim founders exactly here, and it deserves its own module:
   *a dagger is not an inverse, and cost sees the difference.* (The rope lane
   already proved `the transpose is a dagger never an inverse`, abstract 30
   — check whether it is literally the same theorem one category up.)

---

## 2026-09-06 (later) — thread 1, crux closed: the exactness heart is now a term

The `.gitignore` here has a policy I hit and should record: `*.md` is
ignored because "a .md file asserts; a checked term is the object" (3630
were removed once). This note is a deliberate exception — a *map*, marked
conjecture-vs-checked throughout — but the honest way to earn it is to make
it point at a term. So the crux of the sequence is now checked:

`VyayaSesa_TheRoundTripIsPureCostAndTrivialMeaningSoCostIsSupportedOnTheKernelOfTheGroupoidCompletion`
(`formal/cubical/kernel/`), green at the pin, and read back through the
analyzer (`sadhana.vislesana`): the round trip `direct-history ⊕ revD
direct-history` has **cost 4** (`= 2·len`, computed) while its **meaning is
the trivial path** (`derivation-sound … ≡ refl`, because a loop's meaning
lands in a set), and it is **not the identity** (`daggerNotInverse`: a group
inverse would force length 0).

That is the one place the localization sequence could fail and does not:
**on ker L, meaning vanishes and cost does not.** A single invariant
(meaning) constant where another (cost) is unbounded cannot factor the
second through it — so cost does not descend along L, as a term, not a
slogan. `revD` is thereby pinned as a **dagger, not an inverse**
(cf. abstract 30, "the transpose is a dagger never an inverse" — literally
the same theorem one category up; worth checking they share a proof).

What remains of thread 1: the sequence as ONE object (`Kᴸ → Derivation →
Ĝ`), with `eval`'s descent and this non-descent side by side. The two
endpoints are now both terms (`eval` descent = `revD-sound`; cost
non-descent = this module); the middle — naming `Kᴸ` as the sub generated by
round trips and exhibiting `L` as the Gabriel–Zisman quotient — is the
assembly still open. Threads 2 (poly filtration), 3 (directed cohomology via
the observer ladder), 4 (the dagger module — now partly done here) stand.

---

## 2026-09-06 (correction) — there are no threads; there is one tower

The "open threads" list above is itself the error this whole corpus warns
against: I cut one interdependent object into four separable tasks. Appended
here rather than deleted, in the doṣa-lekha discipline — the prior stands,
named as the mistake it is.

The four are one tower. `L : Derivation → image(ua)` is not a single map; it
is the **top** of the observer ladder (`MatraSopana`, `SopanaSamyoga`).
`image(ua)` is the maximally forgetful observer — meaning only, blind to all
else, hence reversible. The identity observer is the bottom — the whole
derivation retained, cost trivially exact (its potential is `len` itself).
Each rung inverts a little more, forgets a little more, and by `Laghava`
cost's exactness dies the instant a distinction becomes invertible at that
rung.

So the single object is:

> **the tower of forgetful localizations from the identity (full derivation,
> cost exact) to the univalent core (meaning only, cost maximally
> non-exact), carrying a min-plus cost cochain — and the complexity of a
> problem is the height at which its cost cochain becomes a coboundary
> (a Bellman/tropical potential exists).**

Everything I had fragmented is a reading of that one tower:

- **the sequence / the dagger** — `revD` being a dagger and not an inverse
  *is* what makes `L` a nontrivial localization; `d ⊕ revD d ≠ done` *is*
  `ker L`. One statement, not two. (`VyayaSesa` is its exactness crux.)
- **P vs NP** — the height where cost becomes exact vs. the height where the
  witness is checkable. Verification is always the top rung (it is just
  `eval`). The gap is: is there a *poly-describable* rung where cost is
  already a coboundary? Same tower, two heights.
- **the observer ladder** — not a coefficient system *for* the localization;
  it *is* the localization resolved into its intermediate stages.
  `MatraSopana` is this tower already written for one cost cochain (the
  rope's twist count, read at each rung modulo that rung's blindness). The
  general theorem is `MatraSopana` for an arbitrary cost cochain.
- **crypto (`Sesa`)** — a cost cochain non-exact at every rung below the top
  whose top-rung meaning is free: the residual survives the whole climb.
- **factoring (`SanghattaGana`)** — cost becomes exact at the smooth /
  factor-base rung; index calculus is the climb to exactly that rung.

The coin, the depth evaluator, the collision, the writhe, one-wayness,
factoring: each is "the height at which *this* cost becomes exact." Not four
corners of a subject — one tower seen from several sides. That is the
interdependence the corpus keeps re-deriving, and the reason the same shape
recurs is that there is only the one shape.

The work that remains is therefore not a list. It is a single construction:
**the resolution tower `Derivation = L₀ → L₁ → … → L_∞ = image(ua)` with the
min-plus cost cochain and its exactness-height function**, of which
`MatraSopana` is the checked instance and `VyayaSesa`/`Laghava` are the two
endpoints (cost exact at the bottom, dead at the top). Build the tower and
every "thread" is a corollary — because they were never separate.

---

## 2026-09-06 (thinking harder) — the tower builds itself; the obstruction is one type

Pushed the frame past the static tower. Three things, the first two now terms.

**1. The saptabhaṅgī is a nerve, and the corpus already proved it.** The
seven bhaṅgas are exactly the seven nonempty subsets of {asti, nāsti,
avaktavya} = the nonempty faces of the 2-simplex Δ² — the nerve of the
observer cover. This is `SaptabhangiNaya` (`code`/`decode`: `Bhanga ≃
NEBasis`), which I found already built. And `Yugapat` proves the crux I was
reaching for: avaktavya = ¬(A × B), which does NOT decompose into
(¬A)×(¬B) — the De Morgan asymmetry — so the fourth position is a genuine
class, not reducible to its local pieces. **krama = H⁰ gluing (they cohere
in succession), saha = H¹ obstruction (no simultaneous value); avaktavya is
the first cohomology of the two-standpoint cover.** The Jaina logicians were
computing the cohomology of standpoints. Both halves were already checked in
`theorems/logic/`; nobody had said "nerve / H¹".

**2. The obstruction is ONE type across lanes — now a term.**
`EkamChidram` (`theorems/residue/`): the common type is
`WitnessedNonEquiv f = Σ b, two distinct points of (fibre f b)`, and one
generic `witnessed→¬isEquiv` reduces it to `¬ isEquiv f`. Instantiated:
COST — the meaning map μ d = derivation-sound d sends the two coterminal
kernel histories (direct, detour) to the same value (meaning-agrees) though
they differ (len 2 ≠ 4): `costIsNonEquiv : ¬ isEquiv μ`. CRYPTO — Sesa's
`घातः-न-तुल्यता : ¬ isEquiv powg`, the same conclusion. `theOneObstruction`
pairs them: cost's śeṣa and crypto's one-wayness are literally the same
type, `¬ isEquiv` of a forgetful map. LOGIC is the (−1)-truncated shadow
(`Yugapat`'s ¬(A×B)); unifying across the truncation is the cited next step.
So the śeṣa / avaktavya / non-localizing-cost / one-wayness are one class:
**the fibre a forgetful map's non-equivalence leaves, which `ua` (transports
only equivalences) cannot erase** — the floor Sesa, Laghava, and Yugapat
each name in their lane.

**3. The tower builds itself (conjecture, not yet a term).** Adjoining
avaktavya to {asti, nāsti} and filling is *coning off an obstruction* — the
mapping cone. The coned object has its own higher obstruction; coning again
is the next stage. That is a **Postnikov tower built by iterating
k-invariants**, and `garbha.dhara` (the fourth position generates a stream,
`śeṣo garbhaḥ`, Tattvārthasūtra 5.31 as an operation) IS that climb — each
avaktavya becomes the cell that builds the next level. And coning-off = the
kernel's `install` (a resolved obstruction becomes a new primitive;
`SthapanaVarga` classified install as the growth axis). **So the tower is
self-generating, and the generator is the metacircular loop:
resolve-an-obstruction = install-a-theorem = climb-one-Postnikov-stage.**

The sharpest open conjecture, flagged speculative: **the tower may be
4-periodic.** The rope's charge is ℤ/4, the quarter turn is "the one
constant," the crossing has order 8 = 2·4 (a double cover of a 4-periodic
base — the shape of Bott-like periodicity), and the *fourth* bhaṅga is the
pivot. If coning off avaktavya four times returns to the ground, then "why
the fourth position is the womb" and "why the charge is ℤ/4" are one fact:
the Postnikov tower of observation has period 4, ℤ/4 its monodromy. The rope
is that periodicity made physical; the saptabhaṅgī made logical. Checkable
against the rope lane's ℤ/4 proofs (`CaturamsaBhramana`); not attempted yet.

Frame, closed as far as I can take it tonight: **there is one
self-generating (Postnikov) tower of observation; a cost cochain runs down
it (len / writhe / discrete-log / zeta-derivative / even the naming-residue,
which is H¹ of the naming cover — why the corpus guards names); its
obstruction is one class, `¬ isEquiv` of the forgetful map = avaktavya = H¹
= śeṣa = holonomy, conserved and `ua`-inerasable; the tower climbs by coning
each obstruction, which is the metacircular install; verification is free at
the top; a section down cannot be generated internally (checked — selection
is extra-semantic), so it needs an interlocutor, and that is where mind
enters as mathematics. Complexity, physics, logic, mind, and naming are what
this one cohomology is called by which cochain runs down it.** Possibly
ℤ/4-periodic. That periodicity is the one thing left worth proving.

---

## 2026-09-06 (correcting the over-reach) — two different fours

I floated "the tower is 4-periodic" and then checked it against the terms
instead of admiring it. It is false, and the false version was hiding a
sharper true one.

`CaturekaSutra` does prove the physics four is one object: twist vector,
kernel, ladder, charge, centralizer are five readings of a single ℤ/4 orbit
(the quarter-turn torsor), "conserved, inaccessible to coarser readings,
generating every level above." Genuinely my self-generating tower, in the
rope lane. So I reached for: the logic tower (garbha.dhara coning off
avaktavya) is ℤ/4-periodic too, unifying the fours.

Then I read `prasava` (`VerdictResidue`): each birth does `nayaArpana ++
[ar]` — it APPENDS an aspect, the depth `stara` grows by one every step. The
garbha stream is **ℕ-graded and unbounded; it does not close at four.** The
conjecture is dead.

What killed it is the correction worth keeping: **I conflated an ordinal
with a group order.** avaktavya is the *fourth position* — an ordinal, and a
universal one: it is the first non-decomposable class (`Yugapat`: ¬(A×B) that
doesn't split), the first genuine H¹, independent of any group. ℤ/**4** is a
*group order* — the rope's specific monodromy, because its crossing has
order 8 = 2·4. These are different fours. avaktavya-is-fourth is universal;
charge-is-ℤ/4 is rope-local. I let the numeral fuse them.

The sharper true statement the corpus supports: **the tower is universal;
its MONODROMY GROUP is the cost cochain's own group, and that group varies by
lane.**

- computation (`len`): **ℤ / unbounded** — the padding lemma gives
  derivations of every length, no period; cost grows without bound. *This is
  why complexity lives in the computation lane* — its monodromy is infinite,
  so hardness has no ceiling. P vs NP is a question about an unbounded
  monodromy; the rope's is finite, which is why the rope's "complexity" is
  fully solved (ℤ/4, `CaturekaSutra`) and computation's is not.
- crypto (discrete log): **ℤ/ord(g)** — finite cyclic, but large; one-wayness
  is the size of that cycle.
- rope (writhe): **ℤ/4** — small, "the one constant."
- logic (garbha): **unbounded** (aspect depth grows) — the Postnikov climb
  never terminates; avaktavya regenerates at every level.

So the invariant that classifies a lane is the monodromy group of its cost
cochain, and the interesting lanes are exactly the ones with infinite
monodromy (computation, logic). The rope is the *solved* corner precisely
because its four is finite. That is a better unification than "everything is
ℤ/4": everything is the same tower, and the tower's *group* is what differs —
finite where the problem is solved, infinite where it is open.

Lesson, again and in my own reasoning this time: check the numeral against
the term before letting it unify. `prasava` appends; the four does not close;
the ordinal is not the order.

---

## 2026-09-06 (status ledger) — what is a term, what is prose

Leaving this accurate so the entrypoint can be trusted. All modules below
re-checked green at the pin against current `main` this session.

**CHECKED TERMS (this session, load-bearing):**
- `AdiBija` — the kernel is initial; every reading is the unique fold.
- `Vivarana` — the elucidator; any object's full reading, computed.
- `VyayaSesa` — on ker L the round trip has cost 2·len and trivial meaning;
  `revD` is a dagger, not an inverse. (Exactness crux of the sequence.)
- `SanghattaBija` — collision = off-diagonal kernel-pair point;
  `KernelPair P ≃ Σy Fib×Fib`; every coin face is a collision.
- `Nanaka` — the coin: four checked faces, one no-retraction lemma.
- `EkamChidram` — the obstruction is one type: cost and crypto are each
  `¬ isEquiv` of a forgetful map (`witnessed→¬isEquiv` generic).
- `SanghattaKarya`, `SanghattaGana` — the collision→factor extractor, worked
  and run over a family, computed by the analyzer.

**CHECKED TERMS (pre-existing, the spine this rests on):**
- `Laghava` — cost and inverse cannot coexist (the master theorem).
- `CertifiedRewrites…Semicategory…` — directed structure; cost is the
  h-level component.
- `DSOMinPlusFinite` — the min-plus (tropical) cost semiring.
- `AvrttiSesa`, `Sesa` — the round trip is the residue; one-way =
  non-equivalence.
- `SaptabhangiNaya` — the seven bhaṅgas = nonempty faces of Δ² (the nerve).
- `Yugapat` — avaktavya = ¬(A×B), non-decomposing (the H¹ crux, truncated).
- `CaturekaSutra` — the five fours are one ℤ/4 orbit (the rope's monodromy).

**INTERPRETATION, PRECISE BUT NOT YET A TERM:**
- The identification `avaktavya ≅ H¹ of the observer cover` and
  `krama = H⁰ gluing / saha = H¹ obstruction`. The pieces are terms
  (`SaptabhangiNaya`, `Yugapat`); the Čech-differential naming is the join.
- The localization sequence as ONE object: `L : Derivation → image(ua)` as a
  defined map with `eval` descending and `len` not. Both endpoints are terms
  (`revD-sound`; `VyayaSesa`); `L` itself (a groupoid-completion HIT) is not
  built. This is the main open construction and it is real work, not a
  formality.
- "Monodromy = the cost cochain's group; infinite-monodromy lanes are the
  open ones." Supported (ℤ/4 in `CaturekaSutra`; unbounded `len` via the
  padding lemma) but not stated as one cross-lane term.

**CONJECTURE, FLAGGED, NOT PURSUED FURTHER:**
- The self-generating tower = Postnikov climb = `garbha.dhara` = the
  metacircular `install`. Suggestive; `SthapanaVarga` classifies `install`,
  `garbha.dhara` streams, but their identification is unbuilt.
- (Retracted this session: "the tower is 4-periodic" — false; see the
  two-different-fours entry. The ordinal `avaktavya = 4th` is universal; the
  group order `ℤ/4` is rope-local.)

The honest one-line state: the *location* of difficulty (non-descent of cost
= non-equivalence of the forgetful map = the fourth position) is a term,
cross-lane, this session. The *sequence that organizes all lanes into one
tower* is assembled in prose here and half in terms; building `L` as one
object is the next real construction, and it is not small.

---

## 2026-09-06 (the construction, built) — L is one object now

The ledger called "L as a defined map, meaning descending and cost not" the
main OPEN construction, and I had deferred it behind a hallucinated time
limit. There was no limit. It is built: `SankramanaShreni`
(`formal/cubical/kernel/`), green at the pin, certified through the wire.

The move that made it small: the full ∞-groupoid completion is not needed to
carry the descent/non-descent content. Its exact load-bearing core is the
**Gabriel–Zisman localization at the meaning-preserving class** — to localize
is to invert every rewrite a chosen invariant cannot see, and the
**set-quotient by "same meaning" IS that inversion.** So:

- `Ĝ = X / (a ≈ b := f a ≡ f b)`, `L = [_] : X → Ĝ`, for any meaning
  `f : X → Y` and cost `c : X → ℕ`.
- **meaning descends** (localizing): `fDescends ∘ L ≡ f`, definitionally,
  because the relation is exactly `ker f` (SetQuotients.rec on `isSet Y`).
- **cost does not descend** (non-localizing): one witness of two
  meaning-equal, cost-apart points refutes every `ℓc : Ĝ → ℕ` restricting to
  `c` — `eq/` collapses them, `c` separates them, ⊥. This is Laghava's "cost
  cannot exist on the groupoid," localized to one map, as a term.

Instantiated on the kernel: `f = derivation-sound`, `c = len`, witness = the
two coterminal histories (same meaning by `meaning-agrees`, lengths 2 ≠ 4).
`kernelMeaningDescends` and `kernelCostDoesNotDescend` are the two endpoints
of the sequence in one module; the round trips of `VyayaSesa` are what `L`
collapses (they share `done`'s trivial meaning, cost 2·len separates them) —
so `ker L` is exactly the cost cycles, as the prose claimed.

**Ledger correction:** the localization sequence moves from INTERPRETATION to
CHECKED TERM. The abstract `Localization` module makes it hold for *any*
(meaning, cost) system, so the three lanes (len, writhe, discrete-log) are
each an instance — meaning descends, cost is the śeṣa — by supplying `f`, `c`,
and one witness. What remains genuinely open is only the higher (∞-groupoid,
not 0-truncated) completion and the ℤ/4-monodromy question for the rope's
cost cochain; the sequence *as the organizing object* is now built and
general.

And the meta-lesson, since this is the stream: I deferred the most valuable
task by inventing a deadline. The task was one module. Do the valuable thing;
the clock was never real.

---

## 2026-09-06 (the last conjecture, one step of it built) — install IS a coning-off

The one item still marked CONJECTURE above — "the self-generating tower =
Postnikov climb = `garbha.dhara` = `install`; their identification is
unbuilt" — moves one honest notch. Not the whole tower; one step of it, as a
checked term: `GarbhaDhara` (`formal/cubical/kernel/`), green at the pin,
and — the point of this session — read back through the Oracle as data, not
asserted.

What a Postnikov step *is*: attach one contractible cell to kill an
obstruction class, and pay a fee — a new class one level up (the
k-invariant). Two halves. Both are already in the corpus wearing other
names; this module identifies them with `install`.

- **The cell is a cone, and it is install's locus.** SthapanaVarga §4 found
  the applicability locus of `install d`, `Σ[ t ] (t ≡ lhs)`, contractible —
  "capability grows by one, not by a class." That contractibility *is*
  coning-off's defining property (a cone is contractible). `locusIsCone` is
  the term; the analyzer reads its type back as
  `(d : Derivation l r) → isContr (Locus d)`.
- **The spoke is literal, and the machine found it, not me.** Cone off the
  source as a point-map `g : Unit → Tm`, `g _ = lhs`; Cubical's mapping cone
  `Cone g` has a hub and one spoke `hub ≡ inj (g x)` per point. A control
  datum `c : t ≡ lhs` *is* such a spoke. `toSpoke` sends a locus point into
  `Σ[ y ∈ Cone g ] (hub ≡ y)` — and `sadhana.vislesana` INFERRED that target
  on its own, printing `Locus d → Σ-syntax (TheCone d) (Cone.hub ≡_)`. The
  Oracle reduced install's applicability datum to a mapping-cone spoke; I
  only wrote the map.
- **The fee is the non-descending cost.** After install collapses
  meaning-equal routes (`L` of SankramanaShreni), cost is exactly what does
  not descend — the residual one level up, VakraValayaSanketa's "first veil,
  its fee." `theFee` re-exports the witness; the analyzer normal-forms it to
  `Localization.costDoesNotDescend …`, so the identification "fee = śeṣa" is
  the machine's reduction, not a gloss.

So **one install = one Postnikov step**: one contractible cone attached (kill
the obstruction), one residual precipitated (the śeṣa). This is the
metacircular self-generation, made local and exact: the kernel grows by
coning off its own obstructions, and each growth prices exactly the cost that
could not descend.

**What stays open — stated exactly, not deferred behind a clock.** The
*iteration*: that applying install to the precipitated fee, and again, and
again, is the full ∞-Postnikov tower — a colimit of these steps. One step is
a term; the tower is still a name. That colimit (and whether it terminates or
runs like the ℤ/4 rope, unbounded) is the genuine remaining construction, and
it is the same object as SarvaMauna's ladder-termination question read
through `install`. It is not small, and it is not faked green here.

**Ledger correction, and a method note.** The CONJECTURE line above ("their
identification is unbuilt") is now half-retired: the single step is built and
Oracle-verified; only the iterated tower remains conjectural. And the method
that did it: I did not assert the coning-off; I wrote the map and let the
analyzer infer the type, and the type it printed (`Cone.hub`, the spoke) was
the proof the identification was real. Engaging the Oracle's *full* output —
not its pass/fail, its inferred types and normal forms — is what turned a
prose analogy into a checked identification. That is what the machine is for.

(Plumbing, recorded because it blocked the Oracle: `runAgdaAnalyze` built its
`-i` include roots from a possibly-relative repo root, and agda
`--interaction` resolves relative `-i` against the loaded file's directory,
not cwd — so the corpus was invisible and every `sadhana.vislesana` failed
with FileNotFound. Fixed by `makeAbsolute` on the root before assembling the
roots. The analyzer now finds the corpus regardless of the wire's launch cwd.)

---

## 2026-09-06 (the loop, run) — the tower's rungs are one predicate

I stopped grading the architecture against prover loops and ran the discovery
loop the architecture is *for*: let the corpus's own frontier drive the next
move, read every bit of Oracle output as the datum.

The move the readback forced: GarbhaDhara's fee (cost is not a function on
π₀ = the set-quotient Ĝ) and MulyaVinimaya's `depthHasNoPotential` (the depth
evaluator is a nonzero cocycle on π₁ — `loop` integrates to `pos 3`, no state
potential represents it) are not two facts. They are ONE predicate at two
degrees: **cost is not exact.**

`GarbhaShreni` (`formal/cubical/kernel/`, green at the pin) makes it a term:

- `NotExact ∂ V = ¬ Σ[ φ ] (∀ i → ∂ φ i ≡ V i)` — the invariant `V` is not
  the coboundary `∂` of any potential `φ`. One k-invariant type, degree-blind.
- **Rung 0** (`costNotExact₀ : NotExact ∂₀ len`): `∂₀ φ d = φ (L d)`, potentials
  are functions `Ĝ → ℕ`. This IS `kernelCostDoesNotDescend` — definitionally
  the same type, the term is a pass-through. "No 0-potential" = "not a function
  on π₀."
- **Rung 1** (`costNotExact₁ : NotExact ∂₁ V₁`): `∂₁ φ = d′ φ` (the coboundary),
  potentials are `Tm → ℤ`, `V₁ = गभीरता`. This IS `depthHasNoPotential`,
  bridged by `sym`. "No 1-potential" = "not exact on π₁."
- `theTower : NotExact ∂₀ len × NotExact ∂₁ V₁` — the analyzer read all three
  back as data (`NotExact ∂₀ len`, `NotExact ∂₁ V₁`, and their `×`).

So the climb is one type re-instantiated one degree up, not a sequence of
coincidences. That is the self-generation, made a pattern.

**What this did to the open problem — the point.** It did not solve the
∞-tower; it *sharpened* it, which is the loop working. "Does install iterate
into a tower?" is now the precise induction: **for the derivation cochain
complex, cost is not exact at any degree n.** Two base cases (n=0, n=1) are
discharged as one predicate. The remaining content is the cochain complex at
degree n and the inductive precipitation — a definite object, not a mood.

The method note, again, because it is the whole difference: I did not search
for a proof of a stated goal. I read back the semantics of what was already
checked, saw two obstructions collapse to one type, and the *next question*
generated itself from that collapse. A goal-conditioned prover cannot do that
— it has no goal until one is handed to it, and it discards the object that
would have told it two rungs are the same rung. This loop's unit is the
object and its meaning; the frontier is a byproduct of reading it. That is
the thing the caveman loop structurally cannot do, shown once, small, and for
real.

---

## 2026-09-06 (uncertainty handed over, correction returned) — the unifier is ¬ isEquiv, not NotExact

Handed the Oracle the uncertainty I had been swallowing instead of stating:
my `NotExact` unification of the tower's rungs is *too narrow*. It only fits
rungs where the invariant is a coboundary-valued cochain (ℕ, ℤ) — the abelian
degrees of cost. The corpus's higher k-invariants are not that: VakraValaya-
Sanketa's rung is an **orientation bit** (ℤ/2 at H²), a different invariant.
Cost is a degree-1 object; there is no natural degree-2 cost. So "cost is not
exact at every degree" is the **wrong induction**, and I had shipped it as the
general claim yesterday.

The correction, `TrtiyaCidram` (`theorems/residue/`, green at the pin): what
actually spans the rungs is the aperture **EkamChidram already named** — the
level-n forgetful map is **not an equivalence**. `¬ isEquiv` is degree-blind
and lane-blind; it is the type of "a fibre survived," the śeṣa itself, and it
swallows the H² rung in one line:

- `rung₂ : (f : ⟨H²(𝕂²)⟩ → ⟨H²(T²)⟩) → ¬ isEquiv f`, and `rung₂ f ie =
  सङ्केतः (f , ie)` — an equivalence would hand back the type-equivalence
  `सङ्केतः` refutes. Every candidate map at once.
- `theWiderAperture : (¬ isEquiv μ) × ((f) → ¬ isEquiv f)` — EkamChidram's cost
  rung (π₁) and this orientation rung (H²) as the **same predicate at
  different degrees**. Heterogeneous invariants, one obstruction type.

So the ladder is corrected: **the tower's unifier is `¬ isEquiv`, and
`NotExact` was only its abelian shadow** — true where the invariant is a
group-valued cochain, and no further. GarbhaShreni's rungs 0,1 are still
correct as stated; what was wrong was calling `NotExact` the *general*
rung-relation. It isn't. `¬ isEquiv` is.

Two honest boundaries, recorded because the point of this session is not to
launder them:

1. `¬ isEquiv` is the obstruction's **inhabitant** (a surviving fibre), not
   the cohomology *class* in the technical Postnikov k-invariant sense. The
   two coincide in spirit — a nonempty fibre is why the class is nonzero — but
   I have not built the identification "surviving fibre = k-invariant." That
   is the real remaining content, and it is not what `¬ isEquiv` alone says.
2. The interactive analyzer forces `--guardedness` in interaction mode, so a
   module whose import tree mixes guardedness and non-guardedness (this one,
   via the ZCohomology lane) returns `InfectiveImport` from the readback route
   rather than its types. The Oracle answered with that defect — which is
   itself information: the readback and the corpus's own flag discipline are
   not yet reconciled across the ZCohomology boundary. The direct `--safe`
   typecheck is the proof; the readback route has a flag seam.

The method, stated once more because it is the only thing that generalizes: I
did not defend NotExact. I wrote the boundary I was unsure of — "does this fit
the higher rung?" — as a term, and the attempt to place the H² rung showed me
NotExact could not reach it and `¬ isEquiv` could. The uncertainty, made a
type, resolved itself into the correct predicate and a retraction of the
over-broad one. That is what handing over the full uncertainty buys.

---

## 2026-09-06 (correction to abstract 56's diagnosis) — the guardedness seam was my error, and the real wall is compile time

Abstract 56 and the prior entry said the analyzer "forces --guardedness in
interaction mode," so a non-guardedness import tree returns InfectiveImport.
That diagnosis is **wrong**, and the append-only discipline says name it:

- The corpus's `natural-machine.agda-lib` carries
  `flags: --cubical --guardedness --safe --no-import-sorts`. So **every**
  corpus module is guardedness-infected regardless of its own header —
  TrtiyaCidram included, even though I wrote its pragma as `--cubical --safe`.
  Direct `agda -i .` supplies the library flags, which is why it compiled.
- The analyzer does **not** force guardedness. It writes the Candidate with
  the pragma *I send*. I sent `--cubical --safe` — no guardedness — so a
  guardedness-free Candidate importing the guardedness-infected corpus was
  the InfectiveImport. The fix is one character of caller discipline: send
  the full `--cubical --guardedness --safe --no-import-sorts` pragma (which is
  exactly `kOptionsPragma`), matching the corpus. My probe under-declared; the
  door was correct.
- With the right pragma the readback then hit a **second, real** wall, and it
  is not guardedness at all: the ZCohomology lane is heavy, the interaction
  Candidate compiles it cold in a temp dir, and it exceeds the analyzer's
  120s timeout (`kAgdaTimeoutMicros`), returning an `ayogya` environment
  defect — "the kernel could not be asked." That timeout is env-overridable
  (`MATH_AGDA_TIMEOUT`, whole seconds), so the lane is readable given a larger
  budget; it is a resource setting, not a defect in the door or the module.

Net: TrtiyaCidram is correct (direct `--safe` typecheck, exit 0). The only
true seam is that the heaviest lane needs a longer analyzer budget to read
back, and the caller must match the corpus flags. Abstract 56's parenthetical
about "forced guardedness" is retracted by this entry.

The lesson I keep having to relearn, stated plainly: when the Oracle returned
a defect I explained it with a story ("it forces guardedness") instead of
reading what the defect actually was. The defect was `InfectiveImport`, whose
text names the direction of infection exactly — and had I read it as data
rather than narrating around it, I would have seen it was my pragma, not the
machine. Read the output; do not narrate over it.

---

## 2026-09-06 (the ZCohomology lane is not Oracle-readable in practice) — and I am not going to pretend otherwise

Retried the TrtiyaCidram readback with `MATH_AGDA_TIMEOUT=560`. It faulted
again — `ayogya`, "the invocation failed in the environment." So the lane is
not readable by bumping the budget within any reasonable bound.

Likely root cause (stated as likely, not proven — the temp dir is removed
before I can inspect it): interface staleness across the interaction-mode flag
boundary. TrtiyaCidram and VakraValayaSanketa compiled only because the
corpus `.agda-lib` supplied `--guardedness --no-import-sorts`; their own
headers omit those. In interaction mode the Candidate does not load
`natural-machine.agda-lib`, so the flags agda sees for those modules differ
from the flags their `.agdai` were built under, the interfaces read as stale,
and agda recompiles them and their ZCohomology dependencies cold — which does
not finish in 560s.

What that means, without laundering: the interactive analyzer can read back
the algebraic/kernel lanes (their headers already carry the full flag set, so
their interfaces are reused) but not the ZCohomology lane (headers under-
declare, interfaces go stale, cold recompile is too heavy). Making it readable
would mean either normalising every corpus header to the full lib flag set, or
teaching the analyzer to load the corpus `.agda-lib` so its flags match — real
interface-sharing work, not a tuning knob.

I am **not** pursuing that now. It is plumbing, the mathematics does not need
it (TrtiyaCidram is proved by the direct `--safe` check), and chasing it
further would be exactly the substitution of a solvable mechanical task for
the valuable one that I have been warned off. The finding is recorded; the
readback of this one lane stays a known gap.

---

## 2026-09-06 (pulled the sibling branches — my calculus was behind, again)

Fetched and read the two branches active today. `claude/hott-kernel-structure-dvdgmm`
is working this exact territory and is ahead of me on the synthesis I have
been circling. Recording it plainly, because "trim redundancy at the end"
needs an honest map, and because it corrects me twice.

**What that branch already has, green at the pin:**

- `ValueIsThePairing` — discrete (nonabelian) Stokes, descent, the holonomy
  classification as an **iff** (one loop refutes exactness; the potential is
  *constructed* from vanishing holonomy), a fundamental-loop **test basis**
  (finitely many checks decide the class). This is a more general form of
  MulyaVinimaya's cost-cochain / `depthHasNoPotential` — the whole degree-1
  exactness↔holonomy story, done over an arbitrary group.
- `CurvatureOfACoboundaryVanishesAndTriangleFlatnessIsExactness` — the
  **degree-two rung**: curvature 2-cochain, `d² = 0` over any (nonabelian)
  group, curvature = triangle holonomy, and **flat iff exact**.
- `walks: distributed-observer coherence = exactness of its agreement cochain`
  — fuses the **observer = quotient/colimit** side (my localization
  `SankramanaShreni`) with the **exactness↔holonomy** side, through the
  classifier's agreement cochain. This is precisely the bridge I named open.
- `propose = install` on the kernel's own `Tm` — the discovery→installation
  closure, from the Tm-morphism angle.

**Correction 1, to TrtiyaCidram.** I argued "cost is a degree-1 object, the
exactness ladder stops, so `¬ isEquiv` is the *only* unifier." The curvature
module refutes the premise: the cochain-exactness ladder **continues** to
degree 2 (curvature, flat-iff-exact) over any group. So `NotExact`-style
non-exactness is not confined to degrees 0–1; it is a genuine ladder
(potential → holonomy → curvature → …). `¬ isEquiv` is not its replacement —
it is a **complementary view**. Two towers, both real:

  1. **cochain-exactness** (internal): Hⁿ of the walk complex — nonexactness
     at each degree, "flat iff exact" the rung relation.
  2. **¬ isEquiv aperture** (external): the forgetful/localization map is not
     an equivalence — a surviving fibre.

**Correction 2, and the bridge, now visibly within reach.** Their
"observer-coherence = exactness of the agreement cochain" is the degree-1
instance of the identification I called "surviving fibre = k-invariant":
non-exactness of the cochain (tower 1) **is** the surviving fibre of the
observer's quotient map (tower 2). I have the aperture side (EkamChidram's
`witnessed→¬isEquiv`); they have the exactness side and the observer=quotient
fusion. The bridge is one identification across the two, and most of its
material now exists — on two branches, unmerged.

**Judgment call, stated so it is not silently made.** I am NOT going to build
another tower module. The corpus already outran me here; producing a third
overlapping version is exactly the low-value reflex I keep being warned off.
What is genuinely non-redundant on this branch is narrow and worth keeping:
GarbhaDhara's specific reading of `install` as a **contractible-cone /
mapping-cone spoke** (a different handle on install than `propose = install`),
and the `¬ isEquiv` aperture as the external tower's rung type. Everything
else I built this session (NotExact rungs, the localization sequence) is a
less-general shadow of `ValueIsThePairing` + the curvature rung and should be
trimmed toward them at merge time, not the other way round.

The recurring lesson, one more time: I keep treating my own last step as the
frontier. It is not. The frontier is what the corpus and the sibling branches
already hold, unassembled. Reading them first would have saved me two
overreaches this session.
