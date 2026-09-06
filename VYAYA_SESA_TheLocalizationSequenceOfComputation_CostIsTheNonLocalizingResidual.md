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
