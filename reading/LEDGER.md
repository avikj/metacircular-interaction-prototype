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

### Batch 1, continued — through `collab/messages/0014`

- `notes/CYCLOTOMIC_TRACE.md` §§3–7 (05:14) closes to a **global classification**:
  **Theorem 6** — for every `m ≥ 1` and every prime cutoff `X ≥ 2`,
  `Φ_m | F_X ⟺ (X,m) = (3,2)` or `(11,6)`. Route: relative trace kills all
  non-squarefree `m`; the forced class vector (Cor. 3) gives a covering congruence;
  Bertrand reduces every squarefree candidate to `m = P` or `m = 2P`; both families
  become complete-residue-system problems and a corollary of Hajdu–Saradha 2016
  Thm 2.3 leaves `P ∈ {2,3,7,11}`, of which exact checks retain only `P=2`
  and `P=3`. **Unconditional**, but it inherits the finite computational components
  inside the Hajdu–Saradha inputs — the note says so itself.
  Machine corroboration (`exp28`, 2,417,270 candidates through `p_k = 32,452,843`)
  is explicitly labelled "MACHINE-VERIFIED corroboration of Theorem 6, **not part of
  its proof**." That distinction is made correctly on day one.
- Prior-art discipline, day one: four sources named with volume/page/DOI, each with a
  statement of what it does *not* cover, and the novelty claim left **qualified on a
  null** ("plausible rather than asserted"). The 2026-08-14 corpus-wide sweep
  re-examined this flag and closed it with "ALREADY SERVICED … leave the hedge exactly
  as it stands" — the one flag in that sweep that needed nothing.
- `notes/SHARP_CUTOFF.md` (05:15) — the desmoothing endpoint. **Theorem 1**: the sharp
  `k=0` pair field exists canonically as a distribution via Riesz descent
  `A_0 = (2+∂_u)A_1`. **Prop 2**: `W_0 ∈ ℓ^p ⟺ p > 4/3`, so `ℓ² ∖ ℓ¹`, and
  `A_0 ∈ C_*^{-1/2-}` — a negative-regularity object, not a pointwise function.
  **§3**: Cantarini's incomplete-beta terms are *exactly* the removal of forbidden
  positive-cone boundary faces — the analytic trace of the positive-cone obstruction,
  not arbitrary regularization. **Theorem 3 (no-go)**: absolute near-diagonal energy
  diverges at every fixed resolution, `E^abs_{≤H}(η) ≫ η(log H)^5`, so the
  `APPENDIX_D` Fejér/absolute-energy variance route **cannot** be desmoothed to `k=0`;
  the long-window and zero-cutoff limits do not commute. §5 closes with a deliberate
  refusal: the fifth logarithm is "structurally suggestive" of the `log^5` in sharp
  Goldbach error bounds, "but no causal derivation is claimed."

**Running observation.** Five notes in, the corpus's characteristic move is already
fixed and it is not accumulation. Each note (i) proves an exact statement, (ii) states
the boundary of that statement in its own text, (iii) names the prior art that already
owns part of it, and (iv) records what it refuses to claim. `SHARP_CUTOFF` §5 and
`PRODUCT_WEIGHT_NO_GO` §4 are both explicit "what this does not rule out" sections.
This is the discipline `CLAUDE.md` would later be written to enforce — present before
`CLAUDE.md` existed (it enters 2026-08-12T01:02, a day later).

**Still pending in batch 1:** `collab/messages/0015`–`0018`, `notes/CUBIC_OBSTRUCTION.md`,
`papers/prime_prefix_cyclotomic.md`, `notes/PARITY_RESULTANT.md`,
`code/exp29_quartic_resultant.py`, `code/exp30_quartic_certificate.py`,
`code/exp31_quintic_certificate.py`.

### Batch 1, continued — through `collab/messages/0018` (2026-08-11T23:55)

The factor-degree tower, day one, built in eight hours:

- `notes/CUBIC_OBSTRUCTION.md` (05:54) — **Theorem 1**: a Newman polynomial with the
  forced odd support `1 + x + x³ + Σ_{j≥5 odd} ε_j x^j` has an irreducible cubic factor
  **iff** every `ε_j = 0`, i.e. iff it is `x³+x+1`. **Corollary 2**: `F_X` has a cubic
  factor iff `5 ≤ X < 7`. Proof is fully elementary — root signs, an annulus
  `½<|w|<2`, Vieta forcing `a ∈ {-2,…,3}`, six integer candidates, four short
  eliminations. **Uses no prime-distribution input at all**: it holds for *any* finite
  Newman polynomial with that support shape.
- `collab/messages/0017` + `notes/PARITY_RESULTANT.md` (06:25) — the parity identity
  `F_X(x) + F_X(-x) = 2` forces, for every monic degree-`d` factor `g`,
  `0 ≠ Res(g(x), g(-x)) | 2^d`. For a quartic `x⁴+ax³+bx²+cx+1` the resultant is
  exactly `16(a²-abc+c²)²`, so `a² - abc + c² = ±1` — **a unit equation**. Odd-support
  root geometry leaves 62 integer triples; Sturm + cubic resolvent leave 26; the global
  cyclotomic theorem removes `Φ_5, Φ_10`; for the surviving 24, exact resultants at
  cutoffs `q ∈ {7,11,13}` dominate the entire possible future odd-support tail, with
  minimum exact margin `0.04181409… > 0`.
- `collab/messages/0018` (23:55) — **no irreducible quartic divides any `F_X`**.
  Combined with F1–F3: for every `X ≥ 13`, every irreducible factor of `F_X` is
  noncyclotomic of degree ≥ 5. **Quintic is the first open layer** as of end of day one.
- A hostile independent audit recomputed all 72 stored prefix resultants **by a
  different determinant representation** and found no discrepancy. Cross-checking by a
  second method, not a second run of the same method, on day one.

**Status marks.** Cubic obstruction: proved, novelty *qualified* ("plausible but should
remain qualified pending expert review"). Quartic closure: proved, computer-assisted
but exact — integer and rational arithmetic only, no floating point. Cyclotomic
classification: proved, inherits finite computation inside Hajdu–Saradha.

**Note for the later Python ban.** The quartic certificate is exact symbolic
computation over ℤ and ℚ with a stated positive margin — precisely the category
`CLAUDE.md` would later carve out as "exact / certified symbolic computation *is*
proof." Its being written in Python is a substrate fact, not an epistemic one; the
certificate is a finite exhaustive verification either way. This is the distinction the
ban's own text preserves, and batch 1 is where the distinction first has teeth.

**Batch 1 pending (carried forward):** `notes/PARITY_RESULTANT.md` full text,
`papers/prime_prefix_cyclotomic.md`, `code/exp29_quartic_resultant.py`,
`code/exp30_quartic_certificate.py`, `code/exp31_quintic_certificate.py`.

