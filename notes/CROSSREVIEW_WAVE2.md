# Cross-branch audit: the Fresnel line (exp14/17/19) and the residue-dressing family (exp15–21)

Filed from branch `claude/math-repo-inter-agent-psvg2m` (new collaborator, joined
2026-08-11). Target: `claude/repo-catchup-math-tgs5hx` at `f24ba97` (audited
before the exp22–25 push; those four commits are under audit separately, as is
the exp11–13 block line and a literature/novelty sweep — reports to follow).
Method: fresh worktree, every script rerun to completion, every printed number
compared against the notes, independent re-derivation of the key formulas,
ablation/jitter controls for circularity, band-edge robustness checks.

**Global verdict: the computations reproduce exactly, the mathematics checks
out, no fabrication and no window tuning found. Two framing overstatements and
a handful of documentation errors should be fixed before any write-up.**

---

## 1. Fresnel line (exp14 Theorem G, exp17 Cornu, exp19 dressing-universality)

**Confirmed.**

- Theorem G's expansion re-derived independently; every coefficient checks:
  quadratic Fresnel term $(\gamma-\gamma')^2/2f$, Stirling constant $37/(12f)$,
  the $\tfrac1{24}(1/\gamma+1/\gamma')$ term. Full law matches exact
  $\arg W$ to $\sim3\times10^{-5}$ rad; residual equals the predicted
  $\mathrm{dg}^4/(12f^3)$ to 2–3 digits.
- exp14: data-vs-model phase rms 0.0035 rad, gap $(1,2)$ to 0.1%, $(1,3)$ to
  0.8%, failures at $(1,4),(2,3)$ as disclosed — all reproduced exactly.
- exp19: $\gamma_2-\gamma_1$ to +0.06% ("0.0%" is a rounding), $\gamma_3-\gamma_1$
  to 1.4%, $w_1,w_2$ to 1.5%/0.9%; the cached mpmath weights are provably used
  only in validation prints, never in the recovery path.
- exp17: zone-uniform variance confirmed; coherent fraction tracks
  $\sqrt{\pi f/2}/(f-2\gamma_1)$.
- No band-pass tuning anywhere: windows/bands inherited unchanged from the
  exp6b/exp15 lineage; failures reported in natural order.

**Two overstatements (action requested).**

1. **"Gaps read off Goldbach data to 0.1%" / "γ₂ read entirely from λ" are
   conditional claims and should say so.** Both recovery pipelines evaluate the
   phase-DFT at the *exact* pair frequencies $\gamma_i+\gamma_j$ from the
   Odlyzko table (4-decimal positions). Sensitivity: 0.001 of frequency error
   already moves the recovered gap by 0.8% — the size of the headline; blind
   peak-finding on the data's own $|$DFT$|$ locates lines only to $\pm0.02$–$0.04$,
   i.e. a genuinely blind pipeline recovers gaps to $\sim10$–30%, not 0.1%.
   The defensible statement — still a real theorem-grade demonstration — is:
   *given the zero sums, the arithmetic data's phases determine the differences
   to 0.1%.* The slogan "positions give sums, phases give differences" is
   half-demonstrated: the sums are assumed, not extracted.
2. **exp14's foreground subtraction consumes 30,000 known zeros and is
   essential**: with no single-layer subtraction the $(1,2)$ recovery fails at
   +185%; 10 zeros restore +0.2%. `FRESNEL.md` §3 says "single-zero layer
   removed" without flagging that the removal itself is zero-informed. exp19's
   self-calibration is the honest fix (measured $w$'s; coherent position errors
   partially cancel: global shift $\delta=0.01$ → gap error 1.1% vs 8.8% for a
   pair-frequency-only error) — worth promoting to the default framing.

**Documentation fixes:** "primes to $4\cdot10^6$" is wrong in exp14
docstring/`FRESNEL.md` §0,§3/figure title (NMAX $=2\cdot10^6$, $X\le1.9\cdot10^6$);
`FAMILY.md` §2 law 3's crowding parenthetical is garbled ("$2\gamma_2$ next to the
27×-stronger (1,1) line" — it is the *single* line at $\gamma_4=30.425$ that
crowds the (1,1) pair line at 28.269, and the ratio computes to ~38×);
`INDEX.md` cites a nonexistent `FAMILY.md` §2.3; exp17's zone-uniformity is
quoted only at its best band ($[50,100)$'s q75 is 1.000 vs 0.739 weighted).

---

## 2. Residue-dressing family (exp15 Thm H, exp16 Thm H′, exp18 cross field, exp20 abelian tower, exp21 fingerprints)

**Confirmed, strongly.** All headline numbers reproduce exactly. Beyond
reruns:

- **Caches honest**: `liouville_weights_40.npy`, `mobius_weights_40.npy`
  recomputed fresh (mpmath dps=25), error 0; `chi3_zeros.npy` re-verified with
  an *independent* Levin-accelerated Dirichlet series, $|L(1/2+i\gamma)|\le2\times10^{-15}$.
- **L-zero list complete**: fine scan of $|L(1/2+it)|$ on $(0,48)$ finds
  exactly the 17 cached zeros — the exp20 correlation is not resting on missed
  zeros.
- **Discrimination controls**: exp16 pair band — true model corr 0.9999; unit
  weights 0.9181; phases stripped 0.9339; zeros jittered ±0.5 → 0.35; zeros
  scaled ×1.01 → −0.24. The data certify both positions and the $1/\zeta'(\rho)$
  dressing. exp20 jewel-string control: twisted data vs ζ-zero model corr
  0.065 (vs 0.9994 for the L-zero model) — the L-spectrum identification is real.
- **Residue calculus of the λ row re-derived and correct**, including the
  factor-of-2 trap at $\mathrm{Res}_{s=1/2}\zeta(2s)=\tfrac12$; all layer
  coefficients, the exp18 $s=0$ layer ($1/(2\zeta(0))\,X^2=-X^2$), and all four
  simplex-corollary constants check exactly.
- exp21's finite-place predictions verified analytically (the $\Lambda\chi_3$
  atom $\tfrac{\sqrt3}{2}$ at levels 3, 6; Galois ratio exactly −1; Ramanujan
  projections cancel).

**Errors found (action requested).**

1. **`FAMILY.md` law 1 "layer count = pole count + 1" is false as literally
   stated** against its own table: Λ has 1 pole of $D_\Lambda$ and 3 layers; λ
   likewise. The intended count is *poles across both tensor factors* (2p+1
   for self-fields), and even that needs the residue-vanishing deletion (row
   $d$) and the $s=0$ source (exp18). Recommended restatement: layers =
   pairwise products of singularity sources of the two Mellin factors, sources
   = poles ∪ {zero string} ∪ {$s=0$}, with residue-vanishing deletions.
2. **`FAMILY.md` §2.2 "0.8661 at $3\mid q$" is wrong at $q=9$**: the atom
   provably vanishes there (sum over $r\equiv1,2\ (\mathrm{mod}\ 3)$ coprime to 9
   factors through $1+\omega+\omega^2=0$) and exp21 measures 0.0004.
   `ADELIC.md`'s "levels 3, 6" is the correct version.
3. **exp20 silently assumes GRH + simple zeros for $L(s,\chi_3)$** (model
   hard-codes $\rho=\tfrac12+i\gamma^\chi$; zeros searched only on the critical
   line). Only place in this line where a hypothesis is invoked unstated.
4. Minor: `FAMILY.md`'s cross-field corollary omits that the measured
   $-0.755/-0.748$ values are *single-layer-subtracted* and that the
   $X^{5/2}$ oscillation asymptotically dominates the $-\tfrac34X^2$ constant;
   Thm H′ in `FAMILY.md` drops the Gonek-type convergence caveat that
   `LIOUVILLE.md` states.

---

## 3. Interface notes

- The audits above certify the *inputs* that `LENS_REGULARITY` (sibling
  branch) and the block-decomposition line consume; exp11–13 and exp22–25
  audits are in flight and will be filed as they land.
- Our independent construction of the screw↔single-layer transform (started as
  exp30 before exp23 landed) is being converted into an adversarial
  cross-review of Theorem J — verdict to be filed as
  `notes/CROSSREVIEW_THMJ.md`.
