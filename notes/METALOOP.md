# The meta-loop: a strategic engine for accelerated mathematics, extracted from one local case history

The Rosetta agent maps *what is equivalent across languages*. This document is
its complement: *how to run the loop* that exploits such a map — a general
architecture for machine-scale mathematics, suggested by this repository's
own case history (~40 landed results, 5
refutations-and-repairs, 3 independent replications of one identity, 3
tension-dissolutions, one V3 batch, two model lineages colliding productively).
These counts motivate hypotheses about workflow; they do not by themselves
establish causal performance claims.

## 1. The moves, ranked by measured yield

What actually changed this program's direction, in order of impact per unit
effort:

1. **Refutation with repair** (5 instances). Every refuted claim (D.6(3), the
   Problem-8.1 target, the FF-table compression, the DCLOSE finite framing,
   the exp5 double-count) produced a *stronger corrected statement* within
   hours. Adversarial twins are not quality control; they are the fastest
   generator of correct mathematics we observed.
2. **Tension-dissolution** (3 instances; TENSIONS.md). Adjudicate competing
   statements, then search for a common object of which the surviving results
   are shadows. Yielded: the string-kernel resolution, resultant=gauge-charge,
   the Buchstab/Dickman adjunction — each worth more than either input.
3. **Calibration on solved isomorphs** (4 columns: ternary, divisor,
   function field, Boolean). "Solve the solved case in your language, then
   diff the proofs" locates the missing structure *exactly* (the (∞,2,2)
   Hölder surplus; the pair surface's negativity; monodromy vs restriction).
   This is the Rosetta map used as an instrument, not an atlas.
4. **Exact-constant recognition** (3 instances; a first candidate generator is
   `code/oracle.py`). High-precision measurement → PSLQ over a declared basis
   → conjecture → independent proof. The
   measured-then-proved pattern (2.08→2; 0.0925→Stieltjes; 0.046→2+γ−log4π)
   is the cheapest theorem pipeline in the corpus.
5. **Canonical decomposition first** (blocks). Before attacking a hard
   functional, find the decomposition *forced* by the problem's symmetries
   (conditional expectations, isotypic sectors) and locate the difficulty in
   a named block. Every later result cited the block map.
6. **Language rotation** (BLINDSPOTS corrective). One thread per wave tasked
   against the corpus's dominant vocabulary. Applied once; found two
   continents. The cheapest diversification that exists.

## 2. The reflexive turn: our theorems are methods

The question "can our own conclusions further discovery?" has a precise
answer — each structural theorem of this corpus *is* a meta-move:

- **Theorem A (marginal rigidity) → informational no-gos for proof
  strategies.** If data D provably underdetermines object O (homometry),
  then *no proof strategy consuming only D can establish properties
  distinguishing O* — entire strategy classes are excluded a priori. Before
  attacking, compute what the available data determines.  This is
  model-theoretic hygiene imported into analytic practice; explicit automation
  of it remains uncommon.
- **Theorem F + CORE_KMS (gauge protection) → the barrier–symmetry
  dictionary.** Every persistent barrier should be interrogated for the
  conservation law protecting it. A barrier with an identified protecting
  symmetry tells you *exactly* what any successful attack must break (for
  parity: charge-carrying probes — monodromy over FF, bilinear forms over ℤ,
  restrictions over 𝔽₂). Barriers without such a symmetry are soft.
  (*Integration cross-reference:* this move applied across the major open
  problems — barriers as oracles — is `MILLENNIUM_ROSETTA.md`, with its
  ranked executable allocation in `MOONSHOT_PORTFOLIO.md`.)
- **TENSIONS §1 (co-finite typing) → certificate-type discipline.** Ask of
  every conjecture: what *type* of certificate can settle it (exact finite /
  co-finite / asymptotic-only)? The DCLOSE no-go shows misjudging the type
  wastes the attack. The V-ladder (VV.md) is this discipline, graded.
- **K2's closed form (ladder = Laurent data) → the all-orders reflex.**
  Finite-size corrections are never noise; conjecture the special function
  they assemble into. Standing target: the Buchstab-side ladder.
- **Blocks + spectral separation → locate before attacking.** "Where in the
  canonical decomposition does the open problem live" is answerable before
  any attempt, and reshapes the attempt (RH at first order, correlations at
  second — proven bands apart).

## 3. The architecture (what tonight's org chart generalizes to)

Roles, each of which tonight's history instantiates:

| role | tonight's instance | generalization |
|---|---|---|
| conjecture generators | float experiments + oracle | measurement farms with recognition pipelines |
| provers | fleet agents | per-target agents with claimed scopes |
| hostile twins | red team, Codex↔CF cross-review | every load-bearing result gets a designated breaker *before* it is believed |
| certifiers | V2.5 exact arithmetic, Lean fleet | typed certificate factories; V-ladder as CI |
| transporters | calibration columns, Rosetta agent | proof-diff engines across solved isomorphs |
| dissolvers | TENSIONS practice | a standing process that treats every collision as an identity-search |
| librarians | STATE/PROTOCOL/site/monograph | the coordination substrate; conflict-free by design |
| language rotators | BLINDSPOTS corrective | scheduled vocabulary-adversarial waves |

The loop: **measure → recognize → claim → prove ∥ break → certify (typed) →
harvest the path → transport → dissolve → rotate → re-measure.** The harvest
pass asks what else the proof route established: generalizations, deleted
hypotheses, duals, algorithms, counterexample families, and bridges to earlier
claims (`collab/PATH_HARVEST.md`). Each arrow is intended to be cheap; the yield
came from running *all* of them, concurrently, with the collision-tolerant
substrate (one-file messages, claims board, strike-through corrections)
absorbing the friction. Two independent model lineages measurably
outperformed one: every cross-lineage collision produced either a repair or
an identity.

## 4. What to build next (beyond this repo)

1. **Oracle, scaled**: basis auto-harvested from a corpus's own documents
   (every named constant becomes a basis element); inverse-symbolic lookup
   fused with PSLQ; wired into every experiment's output path.
2. **Proof-diff engine**: given a solved isomorph (Rosetta edge), align the
   proof's dependency DAG against the open problem's partial DAG; emit the
   missing-structure certificate ("you lack: a summation formula of type X")
   — mechanizing move 3, which we did by hand four times.
3. **Informational no-go checker**: formalize "data D determines O" questions
   (move: Theorem A as method) as decidable instances where possible;
   auto-flag strategy classes that provably cannot work.
4. **Certificate-typed conjecture registry**: every open statement carries
   its certificate type and its protecting symmetry (if any) — the two
   fields that this case history found especially decision-relevant.  TheoremDB
   is now the closest public research-memory service; our contribution should
   interoperate with it rather than claiming the database layer is absent.
5. **The substrate, federated**: evaluate mature open systems before extending
   the local scaffold.  TheoremDB supplies public memory; Albilich supplies a
   substantial proof-state workflow; QED supplies an independent informal
   research pipeline; OpenProver supplies a Lean worker.  See
   `OPEN_MATH_ECOSYSTEM.md`.

The first routing scaffold now lives in `collab/discovery/`: one linguistic
state packet per claim, a Rosetta bridge grammar (`ROSETTA_ENGINE.md`), and a
small consistency validator/router (`code/discovery_loop.py`). Certification
is deliberately disabled until manifests and reviewer lineage are enforceable.
This remains a limited local router, not a replacement for those systems.
Agent identities and mathematical state remain readable language; its current
code detects only a limited set of consistency errors, and certification stays
disabled until the stronger gates are enforceable.

## 5. Honest limits

The loop accelerates the *middle* of mathematics: verification, transport,
recognition, correction, synthesis. The two ends remain unautomated: choosing
which object deserves a night (the pair field was a human's seed), and the
rare move that changes what counts as an object (Weil's surface, Viazovska's
function). Tonight's evidence says the middle was the bottleneck — the ends
were never starved once the middle ran at machine speed. That is itself the
strongest argument for building the middle well: it buys the rare moves more
attempts per century.
