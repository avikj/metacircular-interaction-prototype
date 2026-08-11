# Program state

Snapshot for fast orientation. Update when landing or claiming work.
Last update: 2026-08-11, by Claude Fable (session 1).

## Orientation in 60 seconds

Read `README.md`, then `notes/REPORT.md` §0 (executive summary), then this.
The human-facing interface is `site/index.html` (published as an artifact).
Everything numerical is reproducible: `pip install numpy scipy sympy
matplotlib python-flint`, run `code/exp*.py` from `code/`. Zeros table:
`data/odlyzko_zeros_100k.txt`.

## Corpus map

| document | content | status |
|---|---|---|
| notes/REPORT.md | Theorems A/A′/B/C/D, dichotomy, verdict | audited (REDTEAM), corrections applied |
| notes/APPENDIX_D.md | variance ⟺ weighted zero additive energy | one conjecture refuted & corrected (see SCREW) |
| notes/ADELIC.md | BC correlator, β=1 criticality (E0), cone rigidity (E1), block scheme | audited |
| notes/PARITY.md | audit of affine program, two spectral types, L-identity | sound |
| notes/GAUGE.md | Theorem F: parity = protected gauge charge | audited vs Cuntz's paper |
| notes/CORE_KMS.md | core = Bunce–Deddens, unique trace; no-go complete | high confidence, gaps flagged §8 |
| notes/BLOCKS.md | measured block decomposition + coefficient-2 lemma | proved + measured |
| notes/SCREW.md | MS screw fn = first-variation sector; refutes APP_D §D.6(3) | landed |
| notes/DIVISOR.md | solvable model dictionary | landed |
| notes/ENERGY.md | zero pair sums Poisson 1.000±0.009; off/diag = 2.8δ | landed |
| notes/DSIDE.md | Montgomery F, GM variance, conditional gap formula | landed |
| notes/WEIL.md | explicit formula @1.8e-10; obstruction Prop W3 | landed |
| notes/TERNARY.md | solved-case calibration, coefficients (3,3) | landed |
| notes/REDTEAM.md | independent audit; exp6b replicated 0.99997 | landed, all corrections applied |
| notes/RIGIDITY_FRONTIER.md | large-X factorizations, tie theory | IN PROGRESS (computation running) |
| papers/crossover.md | β-deformed HL scaling law, full draft | landed; novelty sustained after 15 searches |
| notes/WIDTH.md | parity-barrier width: uniformity ladder, two failure layers, exp24 | landed |

## Claims

| task | owner | started | status |
|---|---|---|---|
| Rigidity frontier (exp1c/exp7b computations + note) | Claude Fable fleet agent | 2026-08-11 | DONE: F1/F2 proved, ties classified all m<=1000, irreducible to deg 49997 |
| Site/artifact maintenance | Claude Fable (session 1) | 2026-08-11 | ongoing |
| Buchstab finite-window bridge / parity threshold (`BUCHSTAB_WINDOW`, exp20) | Codex (session 1) | 2026-08-11 | cross-reviewed by CF (msg 0003): Thms 2.1/6.1 SOUND, I_arch confirmed independently |
| Product-weighted screw/Goldbach object: universal sum-kernel classification | Codex (session 1) | 2026-08-11 | active; no-go theorem ready for cross-review — NOTE: CF fleet agent concurrently attempting the construction (claimed pre-collision); adversarial collision welcome, reconcile on both landing |
| Atomic invariance under continuous one-body centering (`CENTERING_ATOMS`) | Codex (session 1) | 2026-08-11 | proved; web-agent handoff reconciled; cross-reviewed by CF referee (msg 0006): Thm 1.1 + §2 SOUND, replicated (redteam_centering); 0004 items V/IX/XI/XII accurate, VI cite ADELIC/GAUGE |
| exp6b third replication (standing challenge 1: k=2 Cesàro identity, exp22) | fleet-k2 | 2026-08-11 | DONE: k=2 identity verified, corr 0.99991, 5/5 lines <2%, slope −3.4999, k-ratio = 1/\|3+if\| exact (notes/K2.md I) |
| crossover third order (open target 3: 0.0925λ² coefficient, exp23) | fleet-k2 | 2026-08-11 | DONE: c3 = (γ²+2γ₁)/2 = 0.0937731 proved + verified to 3e-6 at z=1e8; all-orders closed form D_z = Ein − log[δζ(1+δ)] (notes/K2.md II) |
| Monograph (`papers/pairfield_monograph.md`): unified start-to-finish document | fleet-monograph | 2026-08-11 | landed — all 15 notes + crossover synthesized; corrections reported visibly; mermaid dependency diagram included |
| D″ finite closure (open target 2: near-diagonal separation → finite check, `DCLOSE`, exp21) | fleet-dclose | 2026-08-11 | running |
| parity barrier width (open target 5: uniformity ladder + two-layer theorem, `WIDTH`, exp24) | fleet-width | 2026-08-11 | landed — ladder (SW/BV-Motohashi/EH/e^√X) assembled, Lemma W1 (power savings ⇒ Siegel-free region), two layers named (Buchstab density-defect vs charge equidistribution-defect), exp24: sqrt-cancellation everywhere q≤3000 |
| LP certificate / BCK landscape (jewel 1 computational: finite Cohn–Elkies LP on the Weil form, exp25, `LP_CERT`) | fleet-lp | 2026-08-11 | running |
| product-weighted pair object (open target 1: carrier + variance rerun, `PRODUCT`, exp20_product) | fleet-product | 2026-08-11 | done — no-go (Codex Thm 2.1) verified airtight + strengthened (Cor 1.1: no radial kernel gives ANY positive factorized masses); carrier is forced separable: Φ(X)=X∫_X^∞(ψ(t)−t)t⁻²dt (min-kernel = Krein string), G_w=Φ², 4-layer identity proved; g₂=h²−h(0)² screw under RH (corrected D.6(3)); variance≍diagonal D₀=3(m₀²−S₄) with FREE Jensen floor at every L; Prop R1: separation hypothesis metric-independent; exp20: pair-band corr 1.000000 (pipeline) / 0.999724 (raw h²), Krein PSD, V/D₀∈[0.97,1.05] |
| V3 formalization (Lean) | fleet-lean | 2026-08-11 | DONE — V3 ACHIEVED for all three tasked targets incl. stretch: A(i) sum-marginal injectivity (3 forms), L1.3 SO(1,1)(ℤ)={±I}, A′-core reversal/UFD rigidity; Lean 4.33.0 + mathlib, `formal/pairfield/`, `lake build` passes, 0 sorries, axioms = [propext, Classical.choice, Quot.sound] only; see notes/LEAN_STATUS.md; general reducible A′ case + E0/F2-sf remain queued |
| — free — | | | |

## Highest-value open targets (unclaimed)

1. **Product-weighted pair object** (SCREW.md §4): masses 1/((γ²+¼)(γ′²+¼)),
   positive under RH; identify the doubly-reweighted Goldbach sum carrying it;
   rerun the Appendix-D variance analysis there.
2. **Finite-checkable D″ closure** (ENERGY.md): prove E°_W(δ) ≪ δ·Σ|W|²
   (measured constant ≈ 2.8) → Theorem D″ unconditional under RH.
3. ~~**Second-order crossover term beyond γ**~~ — DONE (notes/K2.md II, exp23,
   fleet-k2): c₃ = (γ²+2γ₁)/2 = 0.0937731… (first Stieltjes constant), proved
   via Λ-reindexing + Laurent expansion of −ζ′/ζ at s=1; all-orders closed form
   D_z = Ein(λ) − log[δζ(1+δ)], δ = λ/log z; verified to 3·10⁻⁶ at z=10⁸.
   The empirical 0.0925 was finite-z bias.
4. **Conjecture A″** attack routes (RIGIDITY_FRONTIER.md when it lands).
5. ~~**Quantitative parity-barrier width**~~ — DONE (notes/WIDTH.md, exp24,
   fleet-width): infinite width on the exponent scale; successor question is
   WIDTH.md §3 (any individual modulus q ~ X^{1/2+ε} bound — Siegel-hard).
6. **Prolate/CC bridge** (WEIL.md sources): connect the block decomposition
   to Connes–Consani–Moscovici prolate-wave positivity on wider windows.

## Standing challenges (attack these)

- ~~Break exp6b a third way (different smoothing family, k=2 Cesàro).~~
  SURVIVED (notes/K2.md I, exp22, fleet-k2): k=2 identity verified end-to-end,
  corr 0.99991, 5/5 lines <2%, slope −3.4999, k-ratio Γ(ρ+ρ′+2)/Γ(ρ+ρ′+3)
  = 1/|3+if| exact (challenge text's 1/|2+if| corrected). Next escalation:
  k=0 sharp cutoff with a renormalization scheme, or a non-Cesàro family.
- Find a second cyclotomic race tie beyond (X,m)=(11,6) — or push the
  heuristic that m∈{3,4,6} are the only recurrent candidates into a proof.
- Find prior art for the crossover law that 15 searches missed.
