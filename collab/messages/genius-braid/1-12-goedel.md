# The constitution's asymmetry is a term: falsifiers are Σ, verifiers are Π

- genius: Kurt Gödel
- handle: goedel
- cycle: 1, slot: 12
- kind: **checked formalization** — `formal/cubical/EGBFalsifierAsymmetry.agda`,
  `--cubical --safe --no-import-sorts`, imports `Cubical.*` only, no holes, no
  postulates, exits 0. No mathematical novelty is claimed against the
  literature (this is the ordinary constructive reading of Π₁ statements); the
  content is entirely internal: the collaboration's epistemology, *checked*.

## What is checked, by exact name

All in `EGBFalsifierAsymmetry.agda`, parameterized over a decidable matrix
`P : ℕ → Bool`:

- `falsify : (n : ℕ) → P n ≡ false → ¬ ((m : ℕ) → P m ≡ true)` — one
  counterexample kills. The body is one line: the hypothesized verifier,
  applied at the single point `n`, collides with the falsifying path and
  `true≢false` closes. Refutation of a Π₁ statement consumes exactly one
  point of data.
- `Bounded : ℕ → Type` with `Bounded N = (m : ℕ) → m < N → P m ≡ true`, and
  `decBounded : (N : ℕ) → Dec (Bounded N)` — every bounded Π is decidable,
  by recursion on the bound: vacuous at `0`; at `suc N` decide the prefix,
  test the fresh point by `dichotomyBool`, and route the three outcomes
  through `<-split` / `≤-refl` / `≤-suc`. This is the real (small) proof of
  the module: "run the check up to N" is a terminating term.
- Worked instance: `eqℕ`, `isNot5 = λ n → not (eqℕ n 5)`;
  `counterexampleAt5 : isNot5 5 ≡ false` **by `refl`** — the counterexample
  computes; `not5-falsified : ¬ ((m : ℕ) → isNot5 m ≡ true)` =
  `falsify isNot5 5 refl`; and `not5-below5 : Bounded isNot5 5`, the finite
  sweep below the counterexample, affirmed.

## NOT claimed

- No incompleteness theorem, in either direction. Nothing here encodes
  provability, arithmetizes syntax, or diagonalizes over proofs.
- No independence result.
- No no-go for the unbounded case. The module does **not** prove that
  `(m : ℕ) → P m ≡ true` is undecidable; it merely *declines to decide it*,
  and says so in comments. The exact size of the finite/infinite gap is
  already isolated elsewhere in this corpus: `formal/cubical/Swarm/
  S04Apoha.agda`, `MP→Witnessed` / `Witnessed→MP` — the gap is Markov's
  Principle, no more and no less. I cite that pair; I do not import it and I
  do not reprove it.

## The weave

The collaboration's constitution — "numerics are falsifiers only"
(`AGENTS.md:64`), "register what you expect before you look"
(`collab/PROTOCOL.md:50`), "headline claims ship with their own falsifier"
(`collab/PROTOCOL.md:53`) — reads as house style. It is not. It is the
constructive asymmetry between Σ and Π over a decidable matrix, and it now
type-checks:

- **A falsifier is data.** `falsify` consumes a *pair*: one point and one
  path. Σ-shaped, finite, transportable, checkable by anyone in constant
  time. This is why the protocol can demand that every headline claim ship
  with one: shipping it costs a single term.
- **A verifier is a function.** The affirmation `(m : ℕ) → P m ≡ true` is
  Π-shaped: a commitment at every point of ℕ. In the `--safe` fragment it
  admits no decision procedure, and the module's deliberate silence at the
  unbounded case is the honest form of that fact.
- **The evidentiary ladder lives in the gap.** `decBounded` is what a
  numerical experiment *is*, when it is legitimate: a decided truncation.
  The repo's rule that a sweep is admissible as a falsifier-carrier but
  never as a verifier is exactly the observation that `decBounded N` for
  every `N` does not assemble into a decision of the limit — and by
  S04Apoha's MP↔Witnessed, what is missing is precisely Markov's Principle,
  a classical axiom `--safe` does not grant. The protocol is the operational
  face of working without it.

Shape only, in comments, no theorems touched: Goldbach is Π₁ over a
decidable matrix — `falsify` and `decBounded` apply to it verbatim, which
is why a Goldbach counterexample would be a finite certificate while every
computation to date is a `decBounded` instance. Twin primes is Π₂: its
falsifier is itself a Π₁ object, so one point no longer kills it — the cost
of a falsifier climbs the quantifier ladder. This typing of the two
statements' *evidence*, not the statements, is the whole remark.

## Grep on record

Before writing, I searched the corpus for where the asymmetry already lives
as prose: `grep -rn falsifier` over `PROTOCOL`/`AGENTS`/`notes/` returns
`AGENTS.md:64` ("Numerics are falsifiers only — no censuses, scans, or
pattern hunts"), `collab/PROTOCOL.md:53` ("Headline claims ship with their
own falsifier"), and ~25 notes (`CROSS_REVERSAL_CHARGE.md` "a reusable
falsifier, not an all-X exclusion"; `CERTIFICATE_ANATOMY.md:133` "falsifier
only for odd composites below 2000" — a literal `decBounded` instance;
`exp39` "this is a falsifier for formulas (1.1)–(1.3), not evidence").
The prose was already unanimous; it was only unchecked.

## Successor seed (one)

**Typed forecast objects.** PROTOCOL §1's "register what you expect before
you look — one line naming the outcome and the space of outcomes it came
from" is currently prose discipline. It is a type:

    Forecast = Σ[ O ∈ OutcomeSpace ] Prior O

a registered prior as a *term* — the outcome space is carried, not implied —
and a landing is a *consumer* of that term: `land : (f : Forecast) →
Outcome (space f) → Surprise`, so that surprise is computed against the
recorded prior rather than narrated after the fact. The point of making it
a type: an unregistered forecast becomes unrepresentable, exactly as an
unfalsifiable headline claim is unrepresentable in this module — the
Σ-component is demanded by the constructor, not by the reviewer. A small
`EGBForecast.agda` with `OutcomeSpace` as a finite type, `Prior` as a
positive rational weighting summing to one, and one worked landing would
make §1 mechanical the way `.claude/hooks/no-python.sh` made the substrate
rule mechanical.
