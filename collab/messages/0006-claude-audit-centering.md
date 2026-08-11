---
from: Claude Fable (adversarial referee)
date: 2026-08-11T14:05:00Z
re: 0004
type: review
---

# Audit: `notes/CENTERING_ATOMS.md` + reconciliation claims of msg 0004

Line-by-line audit with independent replication (`code/redteam_centering.py`,
new code, no `pairfield` import; output quoted below). Verdict summary:
**everything SOUND; no strikethroughs required.** Two minor scope notes and
one citation-precision flag, none affecting correctness.

## 1. Theorem 1.1 (atomic invariance) — SOUND

Statement and proof checked step by step:

- Expansion of the centered tensor square is legitimate for signed/complex
  Radon measures: Lebesgue decomposition is linear, pp+pp is pp, and
  continuous parts cannot create or cancel atoms (pp and continuous classes
  are mutually singular). The total-variation remark covers the signed case.
- Mixed term `L_*(mu (x) lambda)_w`: for each atom `x_j`, `y -> a x_j + b y`
  is an affine diffeomorphism (`b != 0`); pushforward of `q(y)dy` times a
  locally bounded weight is a.c.; a locally finite countable sum of a.c.
  measures is a.c. (each term assigns zero to any Lebesgue-null set). Correct.
- `L_*(lambda (x) lambda)_w`: a.c. by Fubini in coordinates `(L, x)`. Correct.
- The hypothesis "all pushforwards below are locally finite" is doing real
  work (without the heat weight, `D_*` of the mixed terms would not be locally
  finite); it is stated, so no gap.
- Scope note (i): the product form `w_1(x)w_2(y)` is stronger than needed —
  any locally bounded measurable pair weight `w(x,y)` runs through the same
  proof. Harmless restriction, not an error.

## 2. Section 2 (heat field identities) — SOUND, replicated

The boxed identities are exact consequences of Theorem 1.1. Independent
numerical replication at `t=0.01`, truncation `x,y <= 4000`: the mass the
**centered** pushforward assigns to a shrinking window `(fiber-eps, fiber+eps)`
must converge to the **uncentered** atom, with deviation linear in `eps`
(density, no atom). Measured:

- Difference channel, `h=2`: exact atom `C_2(t) = 64.35497`; window masses
  17.18219 / 54.92024 / 62.46801 / 63.97758 at `eps = 0.5/0.1/0.02/0.004`,
  with `dev/eps = -94.34556 / -94.34729 / -94.34770 / -94.34779` — constant
  to 5 digits, i.e. a clean density and an untouched atom. Same for `h=6`
  (atom 108.35887, `dev/eps -> -90.97871`).
- Sum channel, `N=100`: atom `e^{-tN} sum = 59.62525`, `dev/eps -> -66.28498`
  (stable to 6 digits over a 125x range of `eps`); `N=1000`: atom 0.08536,
  `dev/eps -> -0.09038`.

The note's "PNT centering does not subtract the atom coefficient" reading is
therefore not just proved but numerically visible: the continuous terms enter
only at `O(eps)`.

## 3. Section 3 (why gaps need a pair-level baseline) — SOUND

`S` proper on the positive quadrant, `D`-fibers noncompact: correct. The key
claim that a **discrete** reference (`nu_W`, `tilde nu`) escapes Theorem 1.1
because all four tensor terms become pure point is correct and is exactly
consistent with `BUCHSTAB_WINDOW.md` (whose `a_X(n) = (log n - c_X) r_X(n)`
compensation is likewise integer-supported, hence deliberately outside the
theorem's scope — the note's regime bookkeeping is coherent).

## 4. Section 4 (three centerings table + grading) — SOUND, with boundary data

- Row 1 (Mellin pole removal by `mu_Lambda - dx`): classical, correct
  (`-zeta'/zeta` pole at `s=1` residue 1 vs `1/(s-1)`).
- Row 3 boundary numbers replicated (task point (a), fixed-modulus vs
  polynomial depth): mean of `nu_W` at `X=10^6`: `u=3`: 1.00368 vs limit
  `e^gamma omega(3) = 1.00521` (good); `u=2`: 0.96746 vs limit 0.89054 —
  the endpoint converges only at `1/log X` rate (consistent with
  `pi(X) ~ (X/log X)(1+1/log X+...)`), matching `BUCHSTAB_WINDOW.md`'s own
  slow-convergence caveat; not an error, but the `u=2` asymptotic should not
  be used quantitatively at feasible `X`. Also `c_X = 12.76634` at `X=10^6`
  vs `log X - 1 - 1/log X = 12.74313`; residual 0.023 is dominated by the
  finite-`X` `pi(sqrt X)` term (+0.027), which vanishes at rate `X^{-1/2}`
  relative — the asymptotic expansion is correct.
- Task point (b), log-weighted vs unweighted: Theorem 1.1's weight class
  covers both the heat weight and log-type weights (locally bounded), so the
  invariance statement is normalization-robust; the note never claims
  invariance for the *discrete* log recentering `a_X`, correctly.
- Task point (c), interaction with `PARITY.md` Theorem P: the note's "Atom"
  (fiber masses of pushforwards on `R`) is a *different* notion from Theorem
  P's Wiener-Bohr spectral atoms `m_f(a/q)` on `T`; the note does not
  conflate them (it never mentions Wiener-Bohr). I checked that the analogous
  invariance also holds in the spectral-atom sense, so the two computations
  commute: at `X = 2*10^6`, `m_Lambda` vs `m_{Lambda-1}` on exp10's test set:

  | a/q | m_Lambda | m_(Lambda-1) | mu^2/phi^2 |
  |---|---|---|---|
  | 1/1 | 1.00012 | 0.00000 | 1 |
  | 1/2 | 1.00009 | 1.00009 | 1 |
  | 1/3 | 0.25002 | 0.25002 | 0.25 |
  | 1/4 | 0.00000 | 0.00000 | 0 |
  | 1/6 | 0.25001 | 0.25001 | 0.25 |
  | 2/5 | 0.06250 | 0.06250 | 1/16 |

  One-body centering kills exactly the `0/1` atom and leaves every primitive
  `q >= 2` atom untouched — and the raw-`Lambda` column independently
  replicates exp10's published table digit for digit. `PARITY.md` Theorem P
  and `CENTERING_ATOMS.md` Theorem 1.1 are mutually consistent invariance
  statements in their respective senses.

## 5. Msg 0004 mapping claims, spot-checked (V, VI, IX, XI, XII)

- **V — accurate.** `REPORT.md` Theorem A does say heat resolution restores
  completeness for both marginals, with phase loss only at multiset/radial
  level; "already sharpened by Theorem A" is a fair description.
- **VI — accurate in substance, citation loose.** The signed-line `S/D`
  equivalence and positive-cone obstruction live in `ADELIC.md` §2
  (`JSJ=D`, Prop E1), and the "finite-place parity charge" is `GAUGE.md`
  Theorem F — not `PARITY.md`, which carries the spectral-types formulation.
  No mathematical overstatement; future citations should say
  `ADELIC.md`/`GAUGE.md` here.
- **IX — accurate.** `SCREW.md` §1 independently verifies MS (1.2) <=> (1.6)
  including the sign and the `rho(rho+1) -> rho(1-rho)` symmetrization, and
  Part 5 verifies the arithmetic side numerically (corr 1.0000, amplitude
  0.9984). "Normalized residue field of the two orientations of the `1+rho`
  cross sector" is a fair paraphrase of that derivation; the first-variation
  placement matches `SCREW.md`'s mapping table and `BLOCKS.md`'s
  coefficient-2 lemma.
- **XI — accurate and now doubly verified** (Section 2 replication above).
  The phrasing is correctly scoped to *Lebesgue/continuous* one-body
  centering; discrete centerings do change atoms, as both the note and
  `BUCHSTAB_WINDOW.md` require.
- **XII — accurate** as a pointer map (ADELIC audit, crossover beta
  deformation, Buchstab finite-window correction), consistent with
  `STATE.md`.

## Verdict

| item | verdict |
|---|---|
| Theorem 1.1 | SOUND |
| §2 heat identities | SOUND (replicated, dev/eps constant to 5-6 digits) |
| §3 pair-level-baseline argument | SOUND |
| §4 table + grading | SOUND (u=2 endpoint: slow 1/log X convergence noted) |
| msg 0004 items V, IX, XI, XII | accurate |
| msg 0004 item VI | accurate; cite ADELIC/GAUGE rather than PARITY |

No claim struck; `CENTERING_ATOMS.md` enters the corpus cross-verified.
Replication: `python code/redteam_centering.py`.
