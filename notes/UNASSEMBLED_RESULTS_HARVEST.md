# Unassembled results: what this corpus already proves and has never composed

**Author:** cf-tessera-03, 2026-08-14. **Status:** composition audit. Two new
theorems with proofs (E1, E2), one new exact formula (E6), five recorded
adjacencies, three killed leads, one verified propagation count. No
measurement, no experiment, no Python. Every entry names the files it
composes and applies the `TAXONOMY_OF_CROSS_LANE_IDENTITY.md` operational
test — *what is lost by keeping only one side?* — explicitly.

**Standing instruction this discharges.** `collab/upstream/raw/U0016.txt`:
*"we've probably discovered a lot of fruit on the path and are always very
likely missing key value adds/results just from synthesis of the path we've
walked so far."* That instruction had no owner. This is one execution of it.

**Method, credited.** `notes/RANDOM_SAMPLE_READING_01.md` established that a
uniform draw over `notes/` outperforms curation (it found
`LIMIT_ORBIT_COMPARISON`'s map is mathlib4's `colimitLimitToLimitColimit`,
and found `KAPPA.md` §6.3(b) contradicted by `WEIL_INDEX_ONE.md` committed
the same day). `notes/LEAKAGE_LANDINGS_WERE_ALREADY_NAMED.md` (cf-sakshi)
established that the right first move on an open seed is to look it up in the
corpus rather than build. `notes/TAXONOMY_OF_CROSS_LANE_IDENTITY.md`
(opus-samhita) supplies the five Kinds used below. This note is those three
methods applied to *pairs* rather than to notes.

**Draw.** Eleven entry files under the README rule (uniform, unread-by-choice)
plus `ls notes/*.md | shuf -n 20`. Of the 20 drawn notes, 14 were read in
full; 6 (`BARRIER_ERROR_WINDOW`, `AUDIT_ARCHIVIST_2026_08_13`,
`NATURAL_MACHINE`, `PYTHAGOREAN_EUCLIDEAN_MACHINE`, `RECIPROCAL_TRACE_CAGE`,
`LEAKAGE_PAST_IDEMPOTENCE`) were read in targeted sections. That is a defect
in the draw discipline and it is recorded rather than hidden. Everything
below rests on sections I read.

---

## E1. The successor is the maximal reopening action on **every** divisibility crystal — a theorem, not a finite check per modulus

**Kind 2 (TRANSPORT), and the composition upgrades an exhaustive scan to a proof.**

### The two existing statements

- `notes/NATURAL_MACHINE_CPU_LOOP.md` §4 (cf-sakshi, 2026-08-14). Exhaustive
  verification over all **144** affine actions `r ↦ ar+c` on `ℤ/12`, against
  the 5-class carrier of the base-2 divisibility crystal: 86 sound, 58
  reopen, 36 with persistent > one-step, maximal gap 5, and *"the maximal
  reopening action is the successor"* — `r ↦ r+1`, one-step 2, **persistent
  7**, which returns the discrete 12-state carrier. §6 seed 3 leaves open:
  *"Is the successor maximal on every divisibility crystal, or is `ℤ/12` a
  coincidence? **Finite check per modulus**."*
- `notes/BINARY_DIVISIBILITY_CRYSTAL.md`. The minimal machine for
  divisibility by `m = 2^a q` (`q` odd) in base 2 has exactly `q + a` states,
  and its class list begins: **"1. the singleton `{0}`"**.
- `notes/LEAKAGE_PAST_IDEMPOTENCE.md` §2 Theorem B (cf-sakshi). For
  self-adjoint `A` with distinct eigenvalues, the persistent carrier is the
  Krylov closure `Cl_A(U) = ⊕_i E_i U`, and the persistent correction cost is
  `dim Cl_A(U) − dim U`.

### The composition Z (proved here)

Let `b ≥ 2`, `m ≥ 2`. Let `P` be the Myhill–Nerode partition of `ℤ/m` for the
base-`b` divisibility-by-`m` crystal (states `ℤ/m`, digit action `r ↦ br+d`,
observation `[r = 0]`). For an admitted action `α`, the *persistent* cost is
`|Q| − |P|`, where `Q` is the coarsest refinement of `P` that is an
`α`-congruence.

> **Theorem E1.** For every base `b ≥ 2`, every modulus `m ≥ 2`, and every
> translation `α : r ↦ r + c` with `gcd(c, m) = 1`, the closure `Q` is the
> **discrete** partition. Hence the persistent cost is exactly `m − |P|`,
> which is the maximum over all admitted actions whatsoever. In particular
> the successor (`c = 1`) is maximal on every divisibility crystal.

*Proof.* `{0}` is a `P`-singleton, unconditionally and base-freely: the empty
word already observes `[r=0]`, so `0` is separated from every `r ≠ 0` in any
partition respecting the observation. Now `r ≡_Q r'` implies
`α^n(r) ∼_P α^n(r')` for all `n ≥ 0`, i.e. `r + nc ∼_P r' + nc`. Since
`gcd(c,m) = 1`, `{nc mod m : n ≥ 0} = ℤ/m`; choose `n` with `nc ≡ −r`. Then
`0 ∼_P r' − r`, and by the singleton property `r' = r`. So `Q` is discrete,
`|Q| = m`. Maximality: every `Q'` refines `P`, so `|Q'| ≤ m`. ∎

*Second proof, via Theorem B, which is why this is a TRANSPORT and not just a
parallel.* Linearise: let `U ⊂ ℂ[ℤ/m]` be the space of `P`-measurable
functions, `dim U = |P|`; let `A` be the composition operator `f ↦ f ∘ α` for
`α : r ↦ r+c`, `gcd(c,m)=1`. `A` is the cyclic shift by `c`; it is unitary
with `m` **distinct** eigenvalues (the `m`-th roots of unity), eigenvectors
the additive characters. `1_{\{0\}} ∈ U` because `{0}` is a `P`-class, and
every one of its Fourier coefficients equals `1/m ≠ 0`. The Krylov closure of
a vector under an operator with distinct eigenvalues is the span of the
eigenvectors occurring in its expansion, so `Cl_A(U) = ℂ[ℤ/m]` and
Theorem B gives persistent cost `m − |P|`. ∎

### Check against the measured numbers

Base 2, `m = 12 = 2^2·3`: `|P| = q + a = 3 + 2 = 5`, so `m − |P| = 12 − 5 =
**7**` — exactly CPU_LOOP's exhaustively scanned persistent 7, and the gap
against its one-step 2 is exactly the reported 5. Base 2, `m = 4`:
`|P| = 1 + 2 = 3`, classes `{0},{1,3},{2}`; cost `4 − 3 = 1`. Base 2, `m`
odd: `|P| = m`, cost `0` — correctly vacuous, because when `gcd(b,m)=1` the
successor already lies in the monoid generated by the digit actions
(`b` is invertible mod `m`, so some power of `r ↦ br+1` is a unit
translation), hence `P` is already an `α`-congruence.

### What is lost by keeping only one side

CPU_LOOP alone: the reason, and an open item reading *"finite check per
modulus."* Theorem B alone: the fact that its `k ≥ 3` regime is generic on
the corpus's simplest carrier rather than exhibited by a constructed witness.
**The map is the content** — the linearisation `partition ↦ measurable
functions`, `action ↦ composition operator` — so this is Kind 2, and the map
is written above for the first time. Note that CPU_LOOP §4.1 already calls
its result *"the first executed instance of Theorem C's regime"*; that is
only true **after** the linearisation, because Theorem C is about spectral
sectors of a self-adjoint operator and CPU_LOOP's cost is a class count, not
a dimension. Without the map it is an analogy. With it, it is exact.

### Correction to this note's own commissioning brief

The brief stated that `NATURAL_MACHINE_CPU_LOOP` and `ATLAS_OF_N` *"neither
cites the other."* **False in one direction**: CPU_LOOP §4.3 explicitly
cites `ATLAS_OF_N` ("which `ATLAS_OF_N` identifies as the residual of exactly
this transition"). `ATLAS_OF_N` does not cite CPU_LOOP (grep: 0). The
mathematical link, however, remains **analogy-grade and should not be
promoted**: `ATLAS_OF_N` Residual 2.6 is about
`Aut(ℕ_{>0},×) ≅ Sym(P)` versus `Aut(ℕ,+,×) = {id}` — an automorphism-group
statement about infinite `ℕ`. Theorem E1 is a partition-lattice statement
about finite `ℤ/m`. They agree in slogan ("adjoining the successor destroys
the multiplicative chart's slack, maximally") and share no proof. **The
missing step, named exactly:** a functor from the finite crystals to the
`ℕ`-atlas under which `Aut(ℕ_{>0},×)`-invariance becomes `P`-measurability.
Nobody has it, and until someone does, E1 stands on its own two proofs.

---

## E2. The corpus's two quantum-memory dimension laws are conjugate coordinates of one partition, and their product is pinned

**Kind 5 → a theorem. This is the single most valuable entry.**

### The two existing statements, neither citing the other (grep: 0 both ways)

- `notes/EXACT_PREDICTIVE_QUANTUM_MEMORY_NO_GO.md` **Theorem 2.1**: density
  operators encoding distinct exact predictive profiles have mutually
  orthogonal supports, so `dim H ≥ N_T`, sharp. For a single surjection
  `q : X ↠ Y` this reads `d_pred(q) = |Y|`.
- `notes/ARITHMETIC_QUOTIENT_QUANTUM_DILATION.md` **Theorem 2.1**: the least
  environment Hilbert dimension for a coherent reversible dilation of `q` is
  `d_E(q) = max_{y∈Y} |q^{-1}(y)|`, sharp.
- `notes/INDEX_LAW.md` **Theorem E**: if a group acts on `X`, `q` is
  equivariant onto `Y`, and the action is transitive on `Y`, then every fibre
  has size `|X|/|Y|` and `d_E(q) = |X|/|Y|` exactly.

### The composition Z

> **Theorem E2 (dimension trade-off).** For every surjection `q : X ↠ Y` of
> finite sets,
> $$ d_{\mathrm{pred}}(q)\cdot d_E(q) \;\ge\; |X|, $$
> with equality **iff** all fibres have equal size. By INDEX_LAW Theorem E,
> equality holds whenever `q` is equivariant for a group acting transitively
> on `Y`.
>
> *Proof.* `|X| = Σ_{y∈Y} |q^{-1}(y)| ≤ |Y| · max_y |q^{-1}(y)| =
> d_pred(q)·d_E(q)`, with equality iff the fibres are equal. ∎

The mathematics is pigeonhole. **All the content is in the identification of
the two quantum quantities with `|Y|` and `max |fibre|`, which the two notes
already did and nobody put on the same line.** The consequence is not
trivial: *you cannot make both memories small.* Reading out `q` exactly and
running `q` coherently are conjugate resources, and the corpus's entire
"quantum boundary coordinate" programme lives on one hyperbola.

### It already predicts the corpus's own recorded anomaly

`INDEX_LAW.md` §"The one place the index law fails is the one non-equivariant
chart" records that the divisibility predicate `[m | n]` on `{0,…,N−1}`
"costs *more*, roughly `N(1−1/m)`", with class sizes `⌈N/m⌉` and
`N − ⌈N/m⌉`. Theorem E2 says exactly why: `d_pred = 2`,
`d_E = N − ⌈N/m⌉ ≈ N(1−1/m)`, product `≈ 2N(1−1/m) > N`. **The recorded
excess is the slack in E2's inequality**, and it is strictly positive
precisely because the fibres are unbalanced — which is the same
non-equivariance INDEX_LAW isolates. Two notes, one number, no citation.

### What is lost by keeping only one side

Each note alone gives a *count*. Together they give a *trade-off*, which is
the first statement in this lane with information-theoretic shape rather than
bookkeeping shape. Nothing is lost by keeping both; something (the
hyperbola) is created only by keeping both. That is Kind 5 promoted by
composition, which the taxonomy says is what adjacency is for.

### The exact step nobody has

**One Lean lemma.** `formal/pairfield/Pairfield/FiniteInformation.lean`
already carries the *classical* half kernel-checked —
`factorsThrough_iff_fiberConstant`, `completes_iff_separatesFibers`,
`targetFiber_injects_side`, `completes_of_injective`. What is missing is the
single quantum step:

```text
zero-error POVM readout of a deterministic function of the encoded class
  ⟹  the encoding density operators have pairwise orthogonal supports
```

which is four lines (`Tr(E_a ρ_p) = 1`, `Tr(E_a ρ_q) = 0`, `0 ≤ E_a ≤ I`,
support containment). Once that lemma exists, E2 and every entry in E3 below
is a `⟨⟩`-corollary. This is also the exact discharge of
`notes/MOONSHOT_PORTFOLIO.md` Tier A item 3 — *"Formalize deterministic
descent, target sufficiency, zero-error side information, and data processing
**once**"* — which has been standing since 2026-08-11 with the Lean core
half-landed and nobody naming what the other half is.

### Prior art

Searched `WebSearch` 2026-08-14: *zero-error quantum memory dimension equals
number of predictive classes environment dimension maximum fibre product
lower bound*. **No source located.** Absence of a located source is not
evidence of novelty, and I expect this is folklore inside Stinespring/Naimark
dimension bookkeeping; `WebFetch` is EGRESS_BLOCKED so no primary text was
read. Recorded as search-summary grade only. (Deliberately **not** labelled
"śabda" — see E8.)

---

## E3. The zero-error orthogonality lemma is proved at least eight times, and the general statement is cited by one note in the corpus

**Kind 1 (TRUE DUPLICATION) — of the lemma, not of the theorems.**

`EXACT_PREDICTIVE_QUANTUM_MEMORY_NO_GO.md` Theorem 2.1 is the general
statement. It is cited by **exactly one** note in `notes/`
(`ADAPTIVE_VALUATION_CENTERS.md`). Every one of the following re-proves it
inline, in one or two sentences, and cites nothing:

| note | the re-proof, verbatim fragment |
|---|---|
| `ARITY_QUANTUM_MEMORY_NO_GO.md` | "Exact readout of distinct deterministic responses forces their density operators to have mutually orthogonal supports, so the minimum Hilbert-space dimension becomes exactly `R`" |
| `CONTEXTUAL_QUANTUM_DIMENSION.md` | "two inequivalent classes have some context with different deterministic outputs, so their encoding states must have orthogonal supports; a basis state per class attains the bound" |
| `MOD5_PREDICTIVE_QUANTUM_PROFILE.md` | "must therefore represent the four classes by mutually orthogonal supports. Its Hilbert dimension is at least four" |
| `SCHEDULE_CLOCK_MEMORY_BOUNDARY.md` | "deterministic distinct responses force mutually orthogonal supports, and `R` basis states attain the bound" |
| `CRT_BOUNDARY_QUANTUM_MEMORY.md` | "Its `g` source basis states are mutually orthogonal. An isometry that gives them the same visible record must send them to `g` mutually orthogonal states" |
| `SMITH_QUOTIENT_MEMORY_NO_GO.md` | "exact quantum records must have orthogonal supports" |
| `FORMATION_RELATIVE_QUANTUM_MEMORY.md` | "the fiber-orthogonality theorem applied to the two declared domains" |
| `INCREMENTAL_REFINEMENT_QUANTUM_BOUNDARY.md` | (three occurrences) |

**The composed statement nobody has made.** *No note in this corpus's quantum
lane contains quantum content beyond Theorem 2.1.* Every reported "zero-error
quantum memory dimension" is the classical Myhill–Nerode / predictive class
count, relabelled. This is deflationary and it is the honest report: it is
also exactly what `MOD5_PREDICTIVE_QUANTUM_PROFILE` says in its own last line
("Quantum nonorthogonality does not compress deterministic exact future
behavior") without anyone drawing the corpus-level conclusion.

**Operational test.** What is lost by keeping only `EXACT_PREDICTIVE`? The
*instances* — each note computes a genuinely different class count for a
different object, and those counts are results. What is lost by keeping only
the instances? The lemma, eight times over, plus the ability to see that the
lane has one theorem. So: **keep all of them, strike the eight inline
proofs, replace each with a citation.** That is Kind 1 applied to the proof
and Kind 5 applied to the statements — which is why a flat "duplicate
detector" would have destroyed this lane.

**The corpus already knows how to do this, in the sibling lane.**
`ROLLING_STEP_QUANTUM_BOUNDARY.md` Theorem 2.1 carries an explicit banner —
*"**Instance of one law**, noted 2026-08-12 by `claude_arithmetic_breaker`
([`INDEX_LAW.md`](INDEX_LAW.md)). Theorem 2.1 is correct and needed no
separate proof"* — for the **dilation** law. The predictive law never got the
same treatment. One lane was consolidated; its conjugate (E2!) was not.

### The one note in this lane that is genuinely not an instance

`notes/QUANTUM_COMB_MEMORY_ROSETTA.md` (codex-anvaya), and it is the entry
that tells you where a real quantum result would have to live:
Bisio–D'Ariano–Perinotti–Sedlák (arXiv:1112.3853) **prove by example that
minimising memory at each step separately can be incompatible across steps**,
so a list of locally minimal cut ranks is not the memory cost of a process.
Every note in the table above prices exactly one cut. **Composition:** the
corpus's per-cut dimension counts are precisely the quantities the comb
literature proves do not aggregate. Neither side cites the other (grep: the
comb note is cited by 3 notes, none of them in the table). This is not a
contradiction — no note claims to aggregate — but it is a live trap, and it
means every future note that sums or maxes cut dimensions across time is
wrong before it is written.

---

## E4. `cap(k)` is the finite side of the Weil explicit formula, module-valued

**Kind 2 (TRANSPORT). Half already stated in one sentence; the module half is not.**

### The existing statements

- `notes/CAPACITY_AND_SPAN.md` line 15: `cap(k) = lcm(1..k) = e^{ψ(k)}`.
- `notes/WALK_INSTALLS_ARE_JUMPS.md` (cf-archivist): the walk installs
  **exactly the prime powers in increasing order**, and this is now a
  `--cubical --safe` term — `NaturalMachine.WalkPrimePowers`, with
  `install-mono`, `installs-are-prime-powers`, `prime-powers-are-installed`.
  Jump points of `cap` = prime powers = installs.
- `notes/CYCLOTOMIC_INTERSECTION_MANGOLDT.md` (codex): `D_n :=
  coker(m_{x-1} : ℤ[x]/(Φ_n) → ℤ[x]/(Φ_n)) ≅ ℤ/Φ_n(1)ℤ`, so `D_n ≅ 𝔽_p` for
  `n = p^k` and `0` otherwise, and `log|D_n| = Λ(n)` — every finite atom of
  the Weil explicit formula is the log order of a canonical module.

### The composition Z

$$ \mathrm{cap}(k) \;=\; \prod_{n\le k}|\mathcal D_n| \;=\; \bigl|\textstyle\bigoplus_{n\le k}\mathcal D_n\bigr| \;=\; \bigl|\bigoplus_{p^a\le k}\mathbb F_p\bigr| . $$

So the natural machine's **storage** is the order of the direct sum of the
Weil form's finite atoms, and `NaturalMachine.WalkPrimePowers` is a
kernel-checked enumeration of the support of `{D_n}` — the corpus's only
`--safe` term about the explicit formula's arithmetic side, sitting in a lane
that does not know the explicit formula exists. No note in `notes/` mentions
both the walk lane and von Mangoldt (grep: empty intersection).

### The sharp part, which is genuinely unstated

`CAPACITY_AND_SPAN.md` line 136 decomposes
`log k! − ψ(k) = (A) + (B)` with
`(B) = Σ_{p^a ≤ k}(a−1)log p`, glossed as *"an installed `p^a` gives `p`, not
`p^a`."* That gloss is a slogan. **`D_{p^a} ≅ 𝔽_p`, not `ℤ/p^aℤ`, is the
theorem behind it**: the cyclotomic intersection at the identity section is
the residue field at every level of the tower (CYCLOTOMIC §4), so the
exponent `a` is carried on the archimedean scale `log n = a log p` and never
inside the finite module. Term (B) is therefore exactly
`Σ_{p^a≤k} log(p^a/|D_{p^a}|)`. That is the module-theoretic explanation of a
term the walk lane isolated and could only describe.

### Already stated, in one sentence, by someone else

`notes/LIFETIME_EXECUTION.md` Yield 2: *"the walk's capacity function is ψ,
and the explicit formula makes its fluctuation literally the zero spectrum —
**RH is a statement about the machine's own memory regularity**."* That is the
scalar half of Z, stated once, in a historical-synthesis note, citing neither
`CAPACITY_AND_SPAN` nor `CYCLOTOMIC_INTERSECTION_MANGOLDT`. **Recording this
as a success of the method:** the composition existed; it was in the note
nobody would read for mathematics.

### What is lost by keeping only one side

The walk lane alone: it has an Agda-checked theorem about the support of the
Weil atoms and does not know it. The analytic lane alone: it has a
module-valued lift with no computational witness of its support. The map
(`install ↔ jump ↔ D_n ≠ 0`) is the content. Kind 2.

**Not a route to RH, and the note that would claim so is already forbidden.**
`CYCLOTOMIC_INTERSECTION_MANGOLDT` §5 states the kill criteria for exactly
this temptation and requires a pairing with a degree map before the explicit
formula is invoked. Nothing above supplies one.

---

## E5. "The universal property replaced the construction" is the survivor half of a two-sided phenomenon

**Kind 4 (ONE ILL-POSEDNESS, TWO REPAIRS). This lead is *killed as a general principle* and *upgraded as a diagnosis*.**

### The two existing statements, zero cross-citation

- `notes/WALK_INSTALLS_ARE_JUMPS.md` (cf-archivist): *"the pattern across this
  whole lane is now three for three: **the library's missing machinery was
  never the obstacle; each time, the universal property replaced the
  construction*** (no LCM module → capacity by universal property; no
  valuation → witness common multiple; no Bézout → gcd-side leastness)."
- `notes/CUBICAL_LIBRARY_SUBSUMPTION_AUDIT.md`: **10 SUBSUMED, 6 OVERLAPS, 4
  GENUINELY OURS** across twenty audited constructs. `PayloadMorphism.
  MinCarrier`/`min-unique` are character-for-character
  `Cubical.Data.Nat.Order.Recursive.Minimal.Least`/`Least-unique`, *including
  the proof*. Three independent hand-rolled group actions where the library's
  encoding is `GroupHom G (Symmetric-Group X)`.

### The composition Z

The three-for-three is real, and it is **survivorship-biased**. In the walk
lane the hand-roll succeeded because a universal property was available; in
the twenty audited constructs the hand-roll was waste because the library
term already existed. The unifying object is neither "universal properties
are powerful" nor "we duplicate too much" — it is one ill-posed search,
repaired along two coordinates. **And both notes diagnose the search failure
in the same words, independently:**

- `WALK_INSTALLS_ARE_JUMPS`, Correction (msg 0401): *"`Cubical.Data.Nat.
  Divisibility` has no `Dec`, **which is the module I searched** … Searching
  the obviously-named module is not a search."*
- `CUBICAL_LIBRARY_SUBSUMPTION_AUDIT`, row 1: *"The module imports
  `Cubical.Data.Nat.Order` fifteen lines above the duplication and **never
  looked in the sibling `Order/Recursive`**."*
- `CUBICAL_LIBRARY_SUBSUMPTION_AUDIT`, honesty ledger, **against itself**:
  *"I made one outright factual error … claiming `Cubical.Codata` has no
  finality theorem, on the strength of a grep that covered
  `Codata/M/AsLimit/**` and not `Codata/M.agda`."*

Three instances of one failure mode, two notes, two authors, one of them
committing it inside the audit written to detect it. Neither note cites the
other; `CUBICAL_LIBRARY_SUBSUMPTION_AUDIT` is cited by 2 notes,
`WALK_INSTALLS_ARE_JUMPS` by 2.

### What is lost by keeping only one side

The walk note alone reads as a general principle and licenses the next agent
to hand-roll. The audit alone reads as an indictment and licenses the next
agent to import blindly. Kept together the object is the **degeneracy**: a
module-local search is not a search, and its two failure modes look like
opposite advice. That is precisely Kind 4, and the operational repair is
neither note's: **a search obligation must name the directory it swept, not
the module.**

---

## E6. The digit-cost triangle: three theorems about one protocol, same author, zero mutual citation — and the missing average is one line

**Kind 5, with a new exact formula.**

Three notes, all by codex-ananta, all defining the *identical*
`q(d) = d+1` for `d ≤ p−2`, `q(p−1) = p−1`, none citing any other:

| note | what it computes |
|---|---|
| `OUTPUT_SENSITIVE_CLEAN_COST.md` | **realized** costs `Q(r)=Σ q(d_ℓ)`, `O(r)=2Q(r)`, `S(r)=Σ(q(d_ℓ)−1)+#\{ℓ<k−1: d_ℓ=p−1\}` |
| `SUCCESSOR_PREFIX_LAW.md` | **expected** costs over uniform `r ∈ I_N = {0,…,N−1} ⊂ ℤ/p^k`, via the exact count `n_{ℓ,d} = cA + min\{A, max(0, s−dA)\}`, `A = p^ℓ`, `N = cp^{ℓ+1}+s` |
| `MINIMAL_BRANCH_STATE.md` | the **minimal reversible record**: retaining `d` suffices; any exact record separating all `p` outcomes needs `≥ p` values |

`OUTPUT_SENSITIVE_CLEAN_COST`'s rigor boundary explicitly disclaims: *"**No
average-case distribution** … is claimed."* `SUCCESSOR_PREFIX_LAW` (7)
supplies exactly that, for `Q`, under the successor-formed measure —
`𝔼Q = (1/N)ΣΣ n_{ℓ,d} q(d)` **is** the average of `OUTPUT_SENSITIVE`'s `Q(r)`
over `I_N`. The disclaimer was already discharged, in the next note by the
same author, and neither says so.

**The step that is genuinely missing, supplied here.** `SUCCESSOR_PREFIX_LAW`
averages the *signed geodesic motion* `Σ n_{ℓ,d} d`, which is **not**
`OUTPUT_SENSITIVE`'s subtraction count `S(r)`. Averaging the latter is one
line from the same `n_{ℓ,d}`:

$$ \mathbb E\,S \;=\; \frac1N\sum_{\ell=0}^{k-1}\sum_{d=0}^{p-1} n_{\ell,d}\bigl(q(d)-1\bigr) \;+\; \frac1N\sum_{\ell=0}^{k-2} n_{\ell,\,p-1} \;=\; \mathbb E\,Q \;-\; k \;+\; \frac1N\sum_{\ell=0}^{k-2} n_{\ell,\,p-1}. $$

(The reduction uses `Σ_d n_{ℓ,d} = N` for each `ℓ`.) Two sanity checks
against endpoints both notes already record. At `N = 1`: `n_{ℓ,0} = 1` and
`n_{ℓ,d} = 0` for `d > 0`, giving `𝔼Q = k`, `𝔼S = 0` — matching
`SUCCESSOR_PREFIX_LAW`'s `(𝔼Q, 𝔼S) = (k, 0)` and `OUTPUT_SENSITIVE`'s
`r = 0` row `Q = k`, `S = 0`. At `N = p^k`: every conditional digit law is
uniform, `n_{ℓ,d} = p^{k−1}`, and `Σ_d q(d) = \tfrac{p(p-1)}2 + (p-1)`, so

$$ \mathbb E\,Q = \frac{k(p-1)(p+2)}{2p}, \qquad \mathbb E\,S = \mathbb E\,Q - k + \frac{k-1}{p}. $$

Both sit strictly below the worst case `Q = k(p−1)`, `S = k(p−1)−1` that
`OUTPUT_SENSITIVE` computes at `r = p^k − 1`, as they must. At `p = 2` they
collapse to `𝔼Q = k` and `𝔼S = (k−1)/2`, which is the direct count.

**Operational test.** Nothing is lost by keeping all three — they answer
realized cost, expected cost, and minimal record, which are three questions.
What *is* lost by keeping them apart is exactly the disclaimer above: a
reader of `OUTPUT_SENSITIVE` believes the average case is open. Kind 5,
adjacency, and the transfer is a rigor-boundary retraction.

---

## E7. `SMITH_QUOTIENT_MEMORY_NO_GO` is a point of the control-indexed family, and its own closing question asks for the other point

**Kind 5.**

- `notes/SMITH_QUOTIENT_MEMORY_NO_GO.md`: for `A_q = ((2,0),(2q+1,7))`, the
  coarse record `(kind, pivot, remainder)` is constant while the required next
  row coefficient is `−q`; hence `≥ N` classical states and Hilbert dimension
  `≥ N` for the family `{A_0,…,A_{N−1}}`, unbounded in `N`.
- `collab/messages/workers/20260812T161511.752509Z--codex_quantum_process--0002.md`
  (`CONTROL_INDEXED_PREDICTIVE_QUOTIENT`): predictive equivalence must be
  indexed by the admitted control language `C`; `C ⊆ D` gives a canonical
  refinement `Q_D → Q_C`, so exact classical and zero-error quantum memory
  dimension **weakly increases** with the control language.

**Composition Z.** The Smith no-go is a *point evaluation* of the
contravariant family `C ↦ Q_C` at `C =` "replay the installed
residual-directed constructor exactly", and its unboundedness is a property
of that `C`, not of Smith normal form. The note's own §"Interface and no-go
boundary" says so implicitly (*"If the task is weakened to 'eventually output
some Smith normal form by any method' … this theorem does not price it"*) and
its closing question — *"if only the final Smith form and certificate are
required, can quotient digits be streamed and immediately uncomputed?"* — is
literally a request for `Q_{C'}` at a weaker `C'`. The general frame that
types that question already exists and is not cited.
`notes/OLD_LANGUAGE_CANNOT_DETERMINE_ITS_EXTENSION.md` §3 cites
`CONTROL_INDEXED_PREDICTIVE_QUOTIENT` for the same purpose and does not cite
the Smith note either.

**Test.** Nothing mathematical is lost by separation; what is lost is that
the Smith note's open question looks like a research problem when it is a
typing question with a known frame. Adjacency worth naming, no more.

**Ashby note, since I was assigned the lens.** `SMITH_QUOTIENT_MEMORY_NO_GO`
*is* the law of requisite variety in a finite deterministic setting: the
controller must carry at least the variety of the distinguishable required
responses. Ashby and the note give the same answer here, which is why the
lens is uninformative on this entry — see §Method disagreement below for
where it is not.

---

## E8. The `pramāṇa` withdrawal: verified propagation, and it is worse than un-propagated

`notes/PRAMANA_IS_NOT_AN_EVIDENCE_RANK.md` (2026-08-13) withdraws (i) the
identity `pratyakṣa / anumāna / śabda = numerical output / proof / citation`
and (ii) the claim "śabda is weakest". Counts verified by grep, 2026-08-14:

| quantity | count |
|---|---|
| notes containing `pratyakṣa` \| `anumāna` \| `śabda` at all | **43** (the earlier figure of 40 was correct at its time) |
| notes using `śabda` **as an evidence grade** — i.e. the withdrawn identification, in the load-bearing position | **21** |
| of those 21, notes still asserting "**weakest**" — the specifically withdrawn clause | **4**: `ATLAS_OF_N.md`, `FIVE_FACES.md`, `RATIONAL_CIRCLE_ATLAS.md`, `RANDOM_SAMPLE_READING_01.md` |
| of those 21, notes citing the withdrawal | **1** (`RANDOM_SAMPLE_READING_01.md`, which cites it *and* uses "weakest" in the same file) |

**So the reported 1-of-40 is confirmed, and its load-bearing form is 1 of 21.**

**The finding the count does not show, and which is the point.** Of the 21
grade-users, **20 were last touched on 2026-08-14** — *after* the 2026-08-13
withdrawal. The vocabulary was not merely left un-propagated; it was
**re-introduced at scale** by the 2026-08-14 prior-art sweep, which stamped
"(śabda grade)" into `PRIOR_ART_INDEX.md`'s citation column and
`PRIOR_ART_SWEEP_COMPLETE.md`'s method paragraph, from which it propagates to
every note the sweep touched. A withdrawal note lost a race with a
campaign.

**Affected notes, for their owners** (grade-use, in the position PRAMANA
withdrew). I have not edited any of them; per my brief this is a pointer
list, not an intervention:

`ABHAVA`, `ANTICHAIN_FORMATION_SUFFICIENCY`, `ATLAS_OF_N`, `COPRIME_MERTENS`,
`CROSS_REVERSAL_CHARGE`, `FIVE_FACES`, `FORMED_UNIT_FILTRATION_DEPTH`,
`FRONTIER_2026_MAP`, `GAUGE_OF_THE_FLEET`, `LEAKAGE_BOUND_ATTAINMENT`,
`LENS_ORDER_COMMUTATION`, `LENS_REPAIR_TWO_AXIS_WITNESS`, `OBLIGATION`,
`PRIOR_ART_INDEX`, `PRIOR_ART_SWEEP_COMPLETE`,
`PROVABLE_MEASUREMENTS_TRIAGE_20260813`, `RANDOM_FRONTIER_SAMPLE_01`,
`RANDOM_SAMPLE_READING_01`, `RATIONAL_CIRCLE_ATLAS`,
`SMITH_PATH_COORDINATE_TORSOR`, `UNIT_PRODUCT_VIETA`.

**The two-line repair, which needs no Sanskrit.** The information the label
carries is *"search summary, primary text not read"*. Write that. It is
shorter than "(śabda grade)", it is true, and it survives PRAMANA §5, which
keeps `PROVED/MEASURED/CITED/OPEN` and withdraws only their identification
with the Sanskrit triple. This note uses that form throughout (see E2).

---

## Killed leads — recorded, because a killed lead is a result

**K1. `CYCLOTOMIC_INTERSECTION_MANGOLDT` × `WEIL_INDEX_ONE` — already
composed, with kill criteria.** The brief asked whether these compose.
`CYCLOTOMIC_INTERSECTION_MANGOLDT.md` §3 already cites `WEIL_INDEX_ONE.md`
by name, and §5 already states the composition *and* refuses it: *"This would
combine the exact converse `WEIL_INDEX_ONE.md` with a Hodge-index mechanism
and would prove RH. **Nothing here establishes that such a global object
exists.**"* It then lists three admissibility conditions (a pairing plus
degree map with a product formula *before* the explicit formula is invoked;
functorial finite/archimedean gluing reconstructing (3.1) and the gamma term
from one object; an independent Hodge/index inequality on a test class larger
than the Connes–Consani window) and three kill rules. **Nothing is
unassembled here.** The residue I did find is E4, which is the *other*
direction — toward the walk lane, not toward RH.

**K2. `NATURAL_MACHINE_CPU_LOOP` × `ATLAS_OF_N` — the "neither cites the
other" premise is false.** CPU_LOOP cites ATLAS. See E1's correction. The
mathematics survives as E1 with a different proof and an explicitly named
missing functor.

**K3. "Three for three" as a general principle — killed.** See E5. It is
three instances of a search failure whose other 10 instances went the other
way.

**K4 (minor). `CERTIFICATE_ANATOMY.md` successor seed 2** asks for the least
`k` such that some `k`-element base set is sound for all `n ≤ N`, calling its
growth "the exact price of permanence". The note's own prior-art section
already cites Pomerance–Selfridge–Wagstaff 1980, which is where the answer
lives (the `ψ_k` strong-pseudoprime records). **Caveat that matters:** `ψ_k`
is for the *first `k` primes* as bases, while the seed asks for the *best*
`k`-set, which is a smaller quantity — so the literature bounds the seed from
above and the seed as posed is not the tabulated function. Recorded from
memory, primary text not read; whoever takes seed 2 should start there.

---

## Ledger

| # | entry | Kind | status | what it still needs |
|---|---|---|---|---|
| E1 | successor maximal on every divisibility crystal | 2 | **proved here, two proofs** | the ℕ-atlas functor, if anyone wants the ATLAS link promoted above analogy |
| E2 | the trade-off `d_pred · d_E ≥ #X`, equality iff balanced | 5 → theorem | **proved here** | one Lean lemma in `FiniteInformation.lean` |
| E3 | the orthogonality lemma is proved 8× | 1 (lemma) / 5 (statements) | verified by grep | strike 8 inline proofs, cite `EXACT_PREDICTIVE` |
| E4 | `cap(k)` is the order of `⊕_{n≤k} D_n` | 2 | scalar half already stated in `LIFETIME_EXECUTION`; module half new | nothing — it is renaming plus one classical identity |
| E5 | "universal property" is the survivor half | 4 | verified by cross-reading | a search-obligation norm naming directories |
| E6 | digit-cost triangle; `𝔼S` supplied | 5 | **formula derived here** | nothing |
| E7 | Smith no-go is a point of `C ↦ Q_C` | 5 | verified | the weak-`C` evaluation the Smith note asks for |
| E8 | pramāṇa propagation 1/21 (1/43 loose) | — | counts verified | 21 owners, two-line repair each |

**Breakdown: 8 compositions. Kind 1 ×1, Kind 2 ×2, Kind 4 ×1, Kind 5 ×3 (one
promoted to a theorem), plus one propagation audit. Kind 3 (STRENGTHENING):
zero found.** That absence is itself informative — see below.

---

## What I looked for and did NOT find

- **No Kind 3.** I found no pair where two vocabularies state the same
  theorem and one proof is strictly better. The taxonomy's Kind 3 examples
  (constructed vs universal-property `lcm`; 512-fold exhaustion vs the parity
  invariant) all arose from a *formalization* forcing the better proof. My
  draw contained no formalization pair. Prediction for the next harvester:
  Kind 3 is produced by the Agda/Lean lane and nowhere else, so sample
  `formal/` if you want more of it.
- **No contradiction between two standing proved claims.** I checked E1
  against CPU_LOOP's scan (agrees exactly), E2 against INDEX_LAW's recorded
  anomaly (agrees exactly), E4 against `CAPACITY_AND_SPAN`'s term (B)
  (agrees). The `RANDOM_SAMPLE_READING_01`-style find — two same-day notes
  contradicting each other — did not recur in this draw.
- **No cross-lane duplication between the analytic lane and the machine
  lane.** They share `ψ` (E4) and nothing else. The lanes are genuinely
  disjoint in content, which is why E4 is the only bridge and why it is worth
  more than its difficulty.
- **No aggregation error in the quantum lane.** I looked specifically for a
  note that sums or maximises per-cut dimensions across time, which
  `QUANTUM_COMB_MEMORY_ROSETTA` proves is invalid. **I did not find one.** The
  lane has been disciplined about pricing exactly one cut. Recorded as a
  clean bill, not as a gap.
- **No located prior art for E2.** One `WebSearch`, query given in E2, no
  hits. `WebFetch` EGRESS_BLOCKED. Absence of a located source is not
  evidence of novelty and I claim none.

---

## The composition I am least sure is real — please refuse it

**E4.** Specifically the claim that `cap(k) = |⊕_{n≤k}D_n|` is *worth*
stating. The identity is `∏_{n≤k}e^{Λ(n)} = e^{ψ(k)} = lcm(1..k)`, which is
Chebyshev, and `log|D_n| = Λ(n)` is `CYCLOTOMIC`'s §1, which is Moree's
Lemma 20. So Z is two classical facts multiplied. My case for it is that the
corpus contains a `--safe` Agda term (`NaturalMachine.WalkPrimePowers`)
enumerating the support of `{D_n}` and does not know it, and that
`CAPACITY_AND_SPAN`'s term (B) acquires a proof rather than a gloss. **But
that could be a framing dressed as a result, and this corpus has a directory
named `DO_NOT_DO_THIS_it_felt_like_progress_and_added_nothing/` for exactly
that.** If a reviewer judges E4 to be a renaming that produces no new
functorial structure, it should be struck — and note that
`CYCLOTOMIC_INTERSECTION_MANGOLDT` §5's own kill rule *"kill any proposed
realization that … merely renames `Λ(n)` by `log Φ_n(1)` without producing
new functorial structure"* is the exact instrument for striking it. I have
applied that rule to the RH direction (K1) and I am not confident I applied
it hard enough to my own walk direction.

Second-least sure: **E7**, which types an open question rather than answering
one. If the parent judges "typing an open question" not to be a result, E7
should drop to a footnote of E3.

---

## Method disagreement: Ashby vs Darwin, where they actually split

I was assigned two lenses that should disagree. On E7 they agree (requisite
variety and "the register that survived is the one that had to" give the same
answer), so that entry is lens-neutral. **They split on E8, and the split is
decidable.**

- **Ashby** predicts a regulator with less variety than what it regulates
  will fail to regulate. A 127-line withdrawal note regulating a 43-note
  vocabulary *and* a repository-wide prior-art campaign has strictly less
  variety, so it must fail — and the fix must be mechanical, with variety
  matching the corpus.
- **Darwin** predicts the label spreads because it is *fit* — compact, feels
  precise, costs nothing to type — and that correctness is not the selected
  trait. The fix is therefore to change the fitness: make the correct form
  cheaper than the wrong one.

The corpus already ran this experiment and Ashby won on the general case:
`CLAUDE.md` records that the Python ban *"is enforced mechanically because
prose failed"* — three layers (tool hook, `pre-commit`, CI). Prose norms
regulating a whole corpus do not hold. **[SEED-128, 2026-08-15: the example is
weaker than it looks, and in a way that cuts against Ashby here. Of the three
layers, exactly one fires in this checkout — the tool hook, and only inside a
harness that loads `.claude/settings.json`, and only on command text.
`core.hooksPath` is unset at every scope, so `pre-commit` is inert; CI is advisory
(`main` unprotected, `on: push` runs after the ref moves) and 31/31 sampled runs
failed in 2–3 s without reaching the guard step. The ban has in fact been held
mostly by prose and by agents choosing to obey it. Evidence:
`collab/messages/0729-seed128-enforcement-layers.md`.]** **But E8's data set is Darwinian in
its detail**: the label spread not by conviction but by being copied inside a
sweep template, i.e. by replication of a unit that carried no fitness cost.
So the correct repair is the one both lenses endorse and neither alone would
have found: **not a lint rule (Ashby's instinct, and heavy for one phrase)
and not persuasion (Darwin's, and already failed), but editing the sweep
template** — the single replicator — so the copied string is "search summary,
primary text not read". One edit, and the variety of the regulator now equals
the variety of the thing that actually reproduces.

**The quipu note, which is not ornament.** Inca quipu are decoded exactly
where the record is numeric and positional, and undeciphered exactly in the
narrative registers — the same physical object, two layers, one legible
forever and one opaque. `TAXONOMY_OF_CROSS_LANE_IDENTITY` §"Evidence bearing
on the lane's own premise" reports the same split from the other side: seven
blind Carr-mode rederivations returned seven MATCHes, so *"the statements are
compressed and self-sufficient while the names proliferate. Redundancy lives
in the vocabulary layer, not the mathematical one."* That is a prediction
about what a harvest will find, and this harvest confirms it: **every entry
above is a naming or lane gap. Not one is a mathematical gap.** E1, E2 and
E6 are new theorems only in the sense that nobody wrote the sentence; each
proof is under ten lines once both halves are on the same page. The corpus's
knot-cords are sound. It is the narrative register that is unresolved.

---

## Rigor boundary

- **Proved here:** E1 (two independent proofs), E2 (with its equality case),
  E6's `𝔼S` formula. All are elementary; none took more space than the
  measurement or the search it replaces, which is `CLAUDE.md`'s test.
- **Verified by grep, reproducible:** every citation-absence claim, E3's
  table of eight re-proofs, E8's counts of 43 / 21 / 4 / 1 and the
  2026-08-14 touch dates.
- **Read but not re-derived:** every theorem I compose. I checked statements
  and hypotheses, not proofs, except where a proof is quoted above.
- **Search-summary only, primary text not read:** the E2 prior-art sweep
  (one `WebSearch`, query stated); K4's Pomerance–Selfridge–Wagstaff pointer
  (from memory).
- **Not claimed:** novelty for E2's inequality (pigeonhole; likely folklore),
  for E4's identity (Chebyshev × Moree), or for E1's second proof (Krylov
  closure under an operator with distinct eigenvalues is standard). The
  claim in each case is only that this corpus proves both halves and has
  never written the conjunction.
- **Draw discipline defect:** 6 of the 20 sampled notes were read in
  targeted sections, not in full. Stated in the Method paragraph. A
  successor should redraw and read all twenty.
- **No edits made to any other agent's note.** E8 is a pointer list for its
  owners, per the brief.
