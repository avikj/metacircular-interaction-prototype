# The chronological ledger

Appended batch by batch. Each entry: `date · path` then what the file introduces, its
own status marks, and its supersession relations. Nothing here is upgraded from what the
source says; where a source is unresolved the entry says unresolved.

## Batch 1 — 2026-08-11T01:55 → 2026-08-11T06:44

Read in full: `README.md`, `code/exp20_buchstab.py`, `collab/messages/0002`, `0003`,
`0004`, `0009`, `0010`, `0011`, `notes/BUCHSTAB_WINDOW.md`,
`notes/PRODUCT_WEIGHT_NO_GO.md`, `notes/CENTERING_ATOMS.md`, `notes/WOLFRAM_LENS.md`,
`notes/CYCLOTOMIC_TRACE.md` §§1–2. Remainder of batch 1 (msgs 0012–0018,
`SHARP_CUTOFF`, `CUBIC_OBSTRUCTION`, `papers/prime_prefix_cyclotomic.md`,
`PARITY_RESULTANT`, exp28–exp31) pending — resume there.

**What the first six hours actually contain.** Not a program being launched. A
program being *audited*. Every one of the first four notes is a correction or a
no-go against material that arrived from outside:

- `notes/BUCHSTAB_WINDOW.md` (04:02) — the finite Euler product gives the right local
  correlation but the **wrong one-body density** on `[1,X]` at polynomial sieve depth;
  the missing factor is archimedean and is Buchstab's `ω`. Theorems 2.1, 4.1, 6.1
  proved; `I_arch = 0.1814745290…` exact. §5 is a **no-go**: at `w=√X` the leading
  discrepancy is not a hidden zeta fluctuation, it is the deterministic mismatch
  between a constant sieve weight and `log p`. §8 states its own prior-art boundary
  (Pandey–Woo Prop 2.3 via Matthiesen) and the one genuinely open term.
- `notes/PRODUCT_WEIGHT_NO_GO.md` (04:06) — classification: a homogeneous Goldbach
  kernel has factorized Mellin coefficients **iff** it is an exponential heat kernel,
  which is already separable. So the Matsumoto–Suzuki product weight cannot be carried
  by any universal kernel of `m+n`. Kills `SCREW.md` §4's target. Scope stated
  honestly (§4): does not exclude spectrum-dependent interpolation.
- `notes/CENTERING_ATOMS.md` (04:08) — Theorem 1.1: subtracting an absolutely
  continuous one-body mean **cannot change the atomic coefficient** on any exact sum or
  difference fibre. "PNT centering subtracts the Goldbach main term" is false as
  literal subtraction. The escape is discrete: replacing Lebesgue by `ν_W` escapes the
  theorem because all four terms are then pure point.
- `notes/WOLFRAM_LENS.md` (04:45) — the U0011 directive ("wolfram spent decades on
  this, don't reinvent the wheel") executed. **One positive construction**: the finite
  sieve levels are exact modular automata, CRT tensors them, and the normalized
  accepted-state trace is exactly the partial Hardy–Littlewood singular series. **Two
  no-gos**: confluence ≠ causal invariance (Piskunov), and computational
  irreducibility neither ascends nor descends (Israeli–Goldenfeld). Verdict, its own
  words: "No Wolfram result found here advances Goldbach, prime gaps, or RH directly."
- `notes/CYCLOTOMIC_TRACE.md` (05:14) — Theorem 1: for **non-squarefree** `m`,
  `Φ_m ∤ F_X` for every `X`, by relative trace. Strictly strengthens the earlier
  `4|m` parity theorem and removes every lattice computation from that case. Reduces
  the global conjecture to squarefree moduli.

**Corrections already visible in batch 1** (both retro-fitted on 2026-08-14, four days
later, into day-one files — the corpus does go back and fix itself):
- `WOLFRAM_LENS.md` §1: the struck sentence conflated the **congruence/admissibility**
  obstruction (`p=2` empty fibre for odd `h`, total) with the **parity obstruction**
  (Selberg, applies with full force to admissible `h`). The seed121 audit notes that
  conflating them "would suggest that admissibility disposes of the parity problem,
  which is false."
- Same audit records **internal prior art**: the profinite two-point construction
  already sits in `chatgptdump.md` §6.1, dated the same day, *earlier*. The note's
  "synthesis, not a novelty claim" disclaimer was correct but understated.

**Status marks carried unchanged.** `BUCHSTAB_WINDOW` §8 open mixed expansion: OPEN.
`PRODUCT_WEIGHT_NO_GO`: NO-GO with stated scope. `CENTERING_ATOMS` Thm 1.1: proved.
`CYCLOTOMIC_TRACE` Thm 1: proved; squarefree case OPEN.

**Observation for the owner, not a conclusion.** The repository's first six hours are
almost entirely *deflationary* — four no-gos and a reduction, each one killing a route
that had looked promising the day before, each stating its own scope. Whatever the
corpus later became, it did not start by accumulating claims. It started by
subtracting them.

