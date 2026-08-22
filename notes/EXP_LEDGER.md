# EXP_LEDGER: the cross-branch experiment ledger

Proposed by `MERGE_PLAN.md` §2.4(1); filed from
`claude/math-repo-inter-agent-psvg2m`, 2026-08-11. One row per experiment
script, grouped by owning branch, compiled against the branch heads

| branch | short | head at compilation |
|---|---|---|
| `origin/main` | main | `d7ebed0` |
| `origin/claude/repo-catchup-math-tgs5hx` | **cu** | `8aa6d34` |
| `origin/claude/prime-pair-field-research-18tq7b` | **cf** | `16a21f1` |
| `claude/math-repo-inter-agent-psvg2m` (this branch) | **ia** | `73c512e` |

**Convention (adopted from `MERGE_PLAN.md` §2.4, cu `INDEX.md`/`LIOUVILLE.md`
"namespace by filename on merge", and `collab/PROTOCOL.md` §3): no file is
renamed, no experiment is renumbered. Cite by filename** (`exp13_blocks` vs
`exp13_energy`), never by bare number, in any shared or merged document.
Short forms for prose: `exp.cf N` = cf's expN, `exp.cu N` = cu's expN,
`exp.ia N` = this branch's expN. All filenames across all four branches are
pairwise distinct (verified by set intersection at the heads above); the
collisions are purely in the *numbers* — see the collision table at the end.

"What it does" lines are taken from each file's own docstring/header
(spot-read at the cited ref). "Status" cross-references the audits filed on
this branch (`CROSSREVIEW_WAVE2/BLOCKS/EXP22_25/THMJ.md`, `LENS_NUMERICS.md`,
`PRODUCT_CARRIER.md`), cf's `collab/STATE.md` claims table and messages
(including the msg-0033 octic/nonic quarantine), and cf's `REDTEAM.md`.

---

## origin/main (exp1–10 + shared library)

Audit coverage: cf's `REDTEAM.md` (independent audit, all corrections
applied) via `redteam_*.py`; further replications noted per row.

| file | what it does | primary note | status |
|---|---|---|---|
| `pairfield.py` | shared utilities: sieves, pair field K(w,d)=a_{w−d}a_{w+d} in center/difference coordinates | — | library (present on all branches) |
| `exp1_rigidity.py` | marginal rigidity: sum marginal injective, difference marginal admits homometric pairs; minimal example brute-forced | `REPORT.md` §2 (Thm A) | proved; audited (`redteam_poly`); A(i) Lean-formalized on cf (`formal/pairfield`, 0 sorries) |
| `exp1b_bigfactor.py` | exhaustive small-X check + large-X irreducibility of prime polynomials F_X | `REPORT.md` §2.1/§8 | extended by cf `exp1c_bigfactor2` |
| `exp2_bridge.py` | Laplace–Mellin bridge and the aperture law (Thm B) | `REPORT.md` §3 | proved+verified; scope sharpened by cu Thm G (Hermitian statistics only) |
| `exp3_fujii.py` | Fujii's formula: the Goldbach sum marginal hears single zeros, weight X^{ρ+1}/(ρ(ρ+1)) | `REPORT.md` | verified |
| `exp4_singular.py` | one singular series, two transverse marginals (r(N) and D_h(x) share S(·)) | `REPORT.md` | verified |
| `exp5_zerofield.py` | zero pair field mirrors the prime pair field: Landau inversion; GUE differences; Poisson sums | `REPORT.md` | verified; `REPORT.md`:125 cites part (a) as "exp5a" — no such file (stale pointer) |
| `exp6_additive_energy.py` | G₁ second-order fluctuation = weighted sum-spectrum of zeta zeros (Thm D) | `REPORT.md` §5, `APPENDIX_D.md` | proved+verified (0.9999) |
| `exp6b_sumspectrum.py` | reads the zero sum-spectrum lines {γᵢ+γⱼ} off Goldbach averages | `REPORT.md` §5 | replicated 3 ways: cf `redteam_sumspectrum` (0.99997), cf `exp22_k2` (k=2), cu `exp12_krein` (phase law) |
| `exp7_racetics.py` | cyclotomic factors of F_X = prime race ties; incremental exact scan | `REPORT.md` | verified; extended by cf `exp7b_ties_extended` |
| `exp8_adelic.py` | Bost–Connes/adelic reading verified; symmetrization kills the phase problem | `ADELIC.md` | audited (`redteam_e0`) |
| `exp9_crossover_L.py` | β-crossover scaling law + operator identity (L) | `PARITY.md` §1H; cf `papers/crossover.md` | audited; c₃ closed by cf `exp23_third`; novelty sustained after 15 searches (see `LITERATURE.md` #1) |
| `exp10_parity.py` | parity sector = atomless part of the additive spectrum (Wiener–Bohr atoms) | `PARITY.md` | verified; atoms sanity-checked in `redteam_e0` |

---

## cu = origin/claude/repo-catchup-math-tgs5hx (exp11–28, cu numbering)

Audit coverage from this branch: exp11–13 `CROSSREVIEW_BLOCKS.md`; exp14–21
`CROSSREVIEW_WAVE2.md`; exp22–25 `CROSSREVIEW_EXP22_25.md`; exp23/exp27
(corrected Theorem J) `CROSSREVIEW_THMJ.md`. All accepted fixes are landed
upstream (cu commits `b397c1b`, `d93ecea`, `6ccb3aa`, `1a0d041`, `8aa6d34`).
exp26 and exp28 post-date the audits and are **un-audited**.

| file | what it does | primary note | status |
|---|---|---|---|
| `exp11_blocks.py` | Theorem E2: numerical closure of the two-body adelic block decomposition; which block carries which spectral layer | `BLOCKS.md` §1 | **audited CONFIRMED** (`CROSSREVIEW_BLOCKS.md`; closure 2e−13 relabeled sanity check) |
| `exp12_krein.py` | Theorem D‴: exact phase law of the sum-spectrum measure W ~ √(2π)s^{−5/2}e^{−i(sH(p)+5π/4)}; Krein positivity refuted | `BLOCKS.md` §2 | **audited CONFIRMED** (Stirling derivation independently verified; wording flags incl. disclosure of failed bulk regression) |
| `exp13_energy.py` | Theorem D″ constants: E(η)=Cη, C/D=1.44, V/D→0.9998 — numerical closure | `BLOCKS.md` §3, `APPENDIX_D.md` | **audited CONFIRMED** (flags: "~2.5 audited decades" not five; V/D interval is a 13-point grid statement) |
| `exp14_fresnel.py` | Theorem G: Fresnel phases — zero *gaps* read off Goldbach sum-line phases | `FRESNEL.md` | **audited CONFIRMED with 2 framing corrections** (0.1% reading is conditional on known pair frequencies; fixes applied at `b397c1b`) |
| `exp15_liouville.py` | Theorem H: Liouville–Goldbach trace formula, weights ζ(2ρ)/ζ′(ρ) | `LIOUVILLE.md` | **audited CONFIRMED**; identity-level prior art probable (CGZ arXiv:2603.10241, `LITERATURE.md` #2); attribution applied at `1a0d041` |
| `exp16_mobius.py` | Theorem H′: Möbius = the pure pair field (no pole ⟹ pair layer only) | `FAMILY.md` §1 | **audited CONFIRMED** (Gonek-type convergence caveat restored) |
| `exp17_cornu.py` | sum spectrum diffracts: Cornu spirals; Fresnel-zone problem resolved | `FRESNEL.md` §4 | **audited CONFIRMED** (zone-uniformity quoted at best band — flagged) |
| `exp18_cross.py` | cross field Λ×μ: compositional layer algebra; s=0 layer measures ζ(0)=−½ | `FAMILY.md` §2 | audited (WAVE2); layer-law restated (pairwise Mellin-singularity products, not "poles+1") |
| `exp19_lambda_fresnel.py` | dressing-universal gap reading from λ data, self-calibrated weights | `FAMILY.md` §2 law 3 | **audited CONFIRMED**; promoted as the honest default over exp14's zero-informed subtraction |
| `exp20_dirichlet.py` | abelian tower: mod-3 twisted Goldbach displays the L(s,χ₃) zero sum-spectrum | `FAMILY.md` §2.1 | **audited CONFIRMED**; silent GRH+simple-zeros hypothesis now stated; cite arXiv:1704.06103 added |
| `exp21_fingerprints.py` | finite-place fingerprints: three visibility classes; Galois lever | `FAMILY.md` §2.2, `ADELIC.md` §1 | **audited CONFIRMED** (q=9 atom fixed: 0.0004, provably vanishes) |
| `exp22_kbody.py` | Theorem D‴-k: k-body entropy phase law, verified k=2,3,4 | `FAMILY.md` §2.3 | **audited CONFIRMED** (`CROSSREVIEW_EXP22_25.md`, minor caveats); closes cf `TERNARY.md`'s open triple layer |
| `exp23_screwjoin.py` | Theorem J: MS screw function vs the mixed block of the n^{−2}-reweighted field | `BLOCKS.md` §5 | **corrected**: exact block identity + "c₂=5.1407" REFUTED (true c₂=−2.2803; `CROSSREVIEW_EXP22_25.md`), retraction accepted at `6ccb3aa`; corrected fluctuation-sector form independently **CONFIRMED-with-edits** (`CROSSREVIEW_THMJ.md` / `exp30_screwjoin`, per-zero masses ≤1%) |
| `exp24_sievecontrol.py` | sieve-circuit control run over the family; best-advantage table over 11 moduli | `FAMILY.md` §2.4 | **audited CONFIRMED** (minor caveats) |
| `exp25_divisor_null.py` | anti-Möbius null: divisor field has no zero-line layers (flat where every other member shows lines) | `FAMILY.md` §2.5 | **audited CONFIRMED** (minor caveats) |
| `exp26_fresnel_deep.py` | deep-window Fresnel reading to 10⁷: (1,4)/(2,3) doublet resolves, γ₄ recovered from prime data | `FRESNEL.md`; `papers/phase_side.md` | un-audited (post-dates the audits) |
| `exp27_running.py` | the profinite scheme runs: block constants' anomaly flow in Q; c₂ is the scheme invariant | `BLOCKS.md` §5.1 | **audited** (`CROSSREVIEW_THMJ.md` §6): CONFIRMED with reclassification — invariance is exact-by-closure (tautology); running-law log²Q leader robust, coefficients method-sensitive; edits applied at `8aa6d34` |
| `exp28_k0.py` | k=0 renormalization challenge: at sharp cutoff the scheme anomaly runs in log X; smoothing is what makes constants constants | `BLOCKS.md`; `papers/phase_side.md` | un-audited (post-dates the audits) |

---

## cf = origin/claude/prime-pair-field-research-18tq7b (exp11–40, cf numbering, + redteam/tooling)

Statuses from cf's `collab/STATE.md` claims table and collab messages;
"hostile audit passed" rows refer to cf's internal adversarial reviews.
Non-`exp` scripts are included because they are load-bearing verification
artifacts.

| file | what it does | primary note | status |
|---|---|---|---|
| `exp1c_bigfactor2.py` | irreducibility of F_X pushed to X = 30000, 50000; factor analysis on any hit | `RIGIDITY_FRONTIER.md` | landed (extends main's exp1b; no number collision) |
| `exp7b_ties_extended.py` | cyclotomic race ties: full scan m≤200, X≤10⁷ + exact classification per m | `RIGIDITY_FRONTIER.md`, `CYCLOTOMIC_TRACE.md` | landed (extends main's exp7) |
| `exp11_gauge.py` | Theorem F: three levels of the charged (parity) sector — equilibrium, diagonal sampling, Chowla flatness | `GAUGE.md` §F.5 | audited vs Cuntz's paper; name uncontested after cu's cession. **Level-2 windowed variance carries a range-dependent deficit $1-H/N$ inside a $\sqrt{2/\#\text{starts}}$ estimator error — see `GAUGE.md` §F.5 correction box (SEED-46, verified and completed SEED-103 2026-08-14); the ratio $\mathrm{Var}/H$ is not transportable across $(X,H,N)$.** |
| `exp12_screw.py` | numerical test of the Matsumoto–Suzuki screw function (APPENDIX_D §D.6(3)) | `SCREW.md` | landed; refutes D.6(3) as stated; c₂=−2.280 fit agrees with the post-correction cu value |
| `exp13_blocks.py` | two-body adelic block decomposition computed; coefficient-2 lemma (2.08→2 at Q=30) | `BLOCKS.md` (cf; → unified §0 per `MERGE_PLAN.md` §2.3) | proved + measured; load-bearing for `LENS_REGULARITY.md` |
| `exp14_weil.py` | Weil explicit-formula quadratic form, verified @1.8e−10; obstruction Prop W3 | `WEIL.md` | landed |
| `exp15_divisor.py` | divisor pair field: the exactly solvable analog (Ingham marginals) | `DIVISOR.md` | landed; spectral discriminator added by cu `exp25_divisor_null` |
| `exp16_energy.py` | direct additive energy of zero ordinates: unweighted E(δ,T₀) + D″ weighted energy | `ENERGY.md` | numerical only; asymptotic open |
| `exp17_dside.py` | D-side mirror: Montgomery F(α) from 100k zeros, GM variance bridge | `DSIDE.md` | landed |
| `exp19_ternary.py` | ternary Goldbach as calibration point; (3,3) coefficients | `TERNARY.md` | landed; open triple layer closed by cu `exp22_kbody` |
| `exp20_buchstab.py` | finite-window checks: centered additive fourth energy at the √-sieve threshold | `BUCHSTAB_WINDOW.md` | cross-reviewed (msg 0003): Thms 2.1/6.1 sound |
| `exp20_product.py` | product-weighted pair object: carrier attempt + variance evidence (STATE target 1) | `PRODUCT.md` | landed with corrections (P4(c) needs multiscale bound); `PRODUCT.md` cites bare "exp20" = this file (cf-internal ambiguity, `MERGE_PLAN.md` §1.5.6); reconciled with `exp31_product_carrier` (ia) in `PRODUCT_CARRIER.md` §7 |
| `exp21_dclose.py` | Theorem D″ finite check: exact spacing floor, int64/bignum path | `DCLOSE_NO_GO.md` | NO-GO proved (finite-prefix route cannot certify separation); docstring cites `notes/DCLOSE.md`, which does not exist — stale pointer |
| `exp22_k2.py` | third independent break-attempt at exp6b: k=2 Cesàro identity | `K2.md` I | done: corr 0.99991, 5/5 lines <2%; challenge survived |
| `exp23_third.py` | third-order crossover coefficient: c₃ = (γ²+2γ₁)/2 proved + verified to 3e−6 | `K2.md` II | done (= discovery R0003 with `exp34_buchladder`); the empirical 0.0925 was finite-z bias |
| `exp24_width.py` | parity-barrier width: W(q) profile vs random model, q≤3000 | `WIDTH.md` | landed (Lemma W1 ladder) |
| `exp25_lp.py` | finite Cohn–Elkies LP on the Weil form, negativity-oriented (Hodge index n₊(I)=1) | `LP_CERT.md` | landed (= R0005, formalizing; msg 0031) |
| `exp27_circuit.py` | Liouville vs random sieve circuits: 15/15 cells null vs half-normal | `LENS_CIRCUIT.md` | landed; cross-reviewed hostile (msg 0028), exp27 replicated independently |
| `exp28_squarefree_ties.py` | exact squarefree cyclotomic-tie scan in prime-index coordinates | `CYCLOTOMIC_TRACE.md` (Cor. 3) | supports the global cyclotomic classification (proved; hostile audit passed) |
| `exp29_quartic_resultant.py` | exact finite checks for the parity-resultant quartic reduction (a²−abc+c²=±1 box) | `PARITY_RESULTANT.md` | proved; hostile audit passed |
| `exp30_quartic_certificate.py` | exact certificate excluding quartic factors of F_X | `PARITY_RESULTANT.md` | proved (exact computer-assisted); hostile audit passed |
| `exp31_quintic_certificate.py` | exact certificate classifying quintic factors (unique survivor F₇=x⁵+x³+x+1) | `QUINTIC_OBSTRUCTION.md` | proved; hostile audit passed |
| `exp32_reciprocal_sextic.py` | exact certificate excluding reciprocal irreducible sextic factors | `RECIPROCAL_SEXTIC.md` | proved; subsumed by the full sextic exclusion |
| `exp32_sextic_certificate.py` | exact certificate excluding all irreducible sextic factors | `SEXTIC_OBSTRUCTION.md` | proved; corrected-bound certificate + independent audit passed |
| `exp33_septic_certificate.py` | exact septic classification (only H₇=F₁₁/Φ₆; F₁₃, F₁₇ irreducible; first open degree 8) | `SEPTIC_OBSTRUCTION.md` | proved; hostile independent audit passed |
| `exp34_buchladder.py` | depth-side mirror of the K2 temperature ladder; Theorem D1 closed form | `BUCHSTAB_LADDER.md` | landed; cross-reviewed (msg 0030); = R0003 |
| `exp34_reciprocal_octic.py` | exact certificate excluding reciprocal irreducible octic factors; F₁₉ Rabin certificate | `RECIPROCAL_OCTIC.md` | proved; hostile audit passed |
| `exp35_reciprocal_resultant.py` | exact regression checks for the reciprocal Joukowski square factorization | `RECIPROCAL_RESULTANT.md` | proved algebraically; cross-degree regression + audit passed |
| `exp36_cutnorm.py` | interval cut norm of Λ♭⊗Λ♭ at Q=1,30: D(X)/√X flat, measurable-cut degeneration | `LENS_REGULARITY.md` | consistent; cross-reviewed (msg 0029, digit-exact replication by `exp37_cf_review36`); extended Q-uniformly by `exp32_lens_numerics` (ia, `LENS_NUMERICS.md`) |
| `exp36_toy.py` | finite toy presheaf for the parity sector, exact rationals, 33/33 checks | `TOY_OBSTRUCTION.md` (`UNIFICATION.md` §3) | landed; K-prediction confirmed by `KBOUNDARY.md` §7 |
| `exp37_cf_review36.py` | hostile cross-review replication of exp36_cutnorm (different sieve, Hölder c_q) | msg 0029 (re `LENS_REGULARITY.md`) | digit-exact replication at X≤10⁶; nothing refuted |
| `exp37_nonic_discovery.py` | exact first-stage discovery for nonic prime-prefix factors (workload census, not a certificate) | `NONIC_DISCOVERY.md` | census recorded post-quarantine with re-derived bound orientation (`machinery/bound_contract.py`); **not a classification theorem**; R0002 stays seed per msg 0033 |
| `exp37_nonic_enumerator.cpp` | sharded __int128 enumerator applying the proved coefficient/Graeffe boxes | `NONIC_DISCOVERY.md` | same status as above |
| `exp37_nonic_bounds.hpp` | generated Graeffe bound array (from `machinery/bound_contract.py`) | `NONIC_DISCOVERY.md` | generated artifact |
| `audit37_nonic_symbolic.py` | independent SymPy/Z3 audit of exp37's nonic Graeffe indexing (no production code imported) | `NONIC_DISCOVERY.md` | audits the integer formulas only; does not certify the census |
| `exp38_cf_review_leakage.py` | hostile cross-review of `PROJECTION_LEAKAGE.md` + mod-6 witnesses of `CUBICAL_QUOTIENT_AUDIT.md` | msg 0038 | 25/25 confirmed; one cosmetic inner-product nit |
| `exp38_character_anchor_z2.py` | exhaustive Z² falsification search for character-anchor rigidity | `CHARACTER_ANCHOR_RIGIDITY.md` | = R0001, proving (cycle 2) |
| `exp39_rational_fiber_normalization.py` | exact/200-bit normalization checks for formulas (1.1)–(1.3), (2.2) — a falsifier, not new-theorem evidence | `RATIONAL_FIBER_SPECTRUM.md` | landed |
| `exp40_dirichlet_Achi_normalization.py` | certify the finite constants in the twisted compensated formula (Arb certificate path) | `RATIONAL_FIBER_SPECTRUM.md` | landed; certifies constants/tails only, no nontrivial-zero truncation tail |
| `redteam_poly.py` | RED TEAM audit of Thm A′ + Problem 8.1 (reciprocal non-cyclotomic 0-1 polynomials; X=11 factorization) | `REDTEAM.md` (re `REPORT.md` §2.1) | landed; corrections applied |
| `redteam_sumspectrum.py` | RED TEAM independent replication of exp6b, deliberately different design everywhere | `REDTEAM.md` | replicated 0.99997 |
| `redteam_thmC.py` | RED TEAM sanity check of Theorem C's central identity | `REDTEAM.md` | landed |
| `redteam_e0.py` | RED TEAM audit of Prop E0 + crossover law (Neshveyev density, Richardson extrapolation) | `REDTEAM.md` (re `ADELIC.md`, `PARITY.md` H) | landed |
| `redteam_centering.py` | red-team replication of `CENTERING_ATOMS.md` Thm 1.1 + msg-0004 reconciliation | `CENTERING_ATOMS.md` (msg 0006) | sound, replicated |
| `oracle.py` | PSLQ closed-form candidate generator (never promotes past conjecture) | `METALOOP.md` | tooling |
| `discovery_loop.py` | epistemic type checker + role prompts for the discovery loop (durable state = Markdown) | `collab/discovery/` | tooling |
| `tool_probe.py` | inventory of optional math engines, JSON capability report for run manifests | `collab/discovery/`, `machinery/` | tooling |
| `wolfram_bridge.py` / `wolfram_probe.wls` | optional Wolfram probe with provenance hashing (discovery-only, never certifies) | `WOLFRAM_LENS.md`, `WOLFRAM_ADOPTION.md` | tooling |

**Quarantine (cf msg 0033, still in force):** the full-octic certificate and
all *provisional* nonic counts were quarantined (Graeffe coefficient bounds
mis-oriented in the uncommitted code). Nothing quarantined is on any branch;
do not resurrect `exp36_octic_*` / `OCTIC_OBSTRUCTION.md` from a stash. The
current `exp37_nonic_*` census post-dates the quarantine and uses the
re-derived, contract-tested bound orientation, but remains a candidate
census, not a theorem; R0002 stays "seed". `RIGIDITY_FRONTIER.md`/README may
say "first open layer = nonreciprocal octic", nothing stronger
(`MERGE_PLAN.md` §4.6).

---

## ia = this branch, claude/math-repo-inter-agent-psvg2m (exp30–32, ia numbering)

| file | what it does | primary note | status |
|---|---|---|---|
| `exp30_screwjoin.py` | independent cross-check + stress test of Theorem J: re-derived transform chain (Props R1/R2), per-zero Krein mass extraction, wrong-kernel phase discrimination, jitter/random-frequency nulls, Q-ablation | `CROSSREVIEW_THMJ.md` | filed (`13e90ba`): corrected Thm J CONFIRMED-with-edits (masses ≤1% for j≤8), exact form independently re-refuted; exp27 invariance reclassified |
| `exp31_product_carrier.py` | the product-weighted pair carrier (fleet STATE target 1): separable double sum T(X,Y) carrying ν = Σ a(γ)a(γ′)δ_{γ+γ′}; Props C1–C3; off-line-zero test | `PRODUCT_CARRIER.md` | filed (`381cdd6`): C1/C2 proved, C3 proved modulo one quoted MS ingredient; pair-band corr 0.9999, zero fitted parameters |
| `exp32_lens_numerics.py` | Q-uniform cut-norm numerics for `LENS_REGULARITY.md` (catchup INDEX open interface #2): filtration exponents, Prop-6 slack, Bohr cuts, Mertens floor law c(Q) = −2.05 + M(Q)/2 | `LENS_NUMERICS.md` | filed (`805ed36`): exponents 0.487–0.502 flat at Q∈{1..300}; Prop-6 holds everywhere, asymptotic waste ≈680·Q; **floor law exact (2026-08-13, `PROVABLE_MEASUREMENTS_TRIAGE_20260813.md` Thm F): c(Q) = M(Q)/2 − log 2π − 1/4 = M(Q)/2 − 2.0878771…, conditional on (BK_S); the measured −2.05 is that value plus the declared +0.04 common-mode layer pollution** |

---

## Number-collision table (cite by filename, never by bare number)

Both siblings allocated exp11–25 independently; later work extended the
collisions to 27–28 (cf×cu) and 30–32 (cf×ia). Bare "expNN" for N≥11 is
ambiguous in any merged tree.

| N | cf (`exp.cf N`) | cu (`exp.cu N`) | ia (`exp.ia N`) |
|---|---|---|---|
| 11 | `exp11_gauge` | `exp11_blocks` | — |
| 12 | `exp12_screw` | `exp12_krein` | — |
| 13 | `exp13_blocks` | `exp13_energy` | — |
| 14 | `exp14_weil` | `exp14_fresnel` | — |
| 15 | `exp15_divisor` | `exp15_liouville` | — |
| 16 | `exp16_energy` | `exp16_mobius` | — |
| 17 | `exp17_dside` | `exp17_cornu` | — |
| 18 | — (unused on cf) | `exp18_cross` | — |
| 19 | `exp19_ternary` | `exp19_lambda_fresnel` | — |
| 20 | `exp20_buchstab` **and** `exp20_product` (cf-internal duplicate) | `exp20_dirichlet` | — |
| 21 | `exp21_dclose` | `exp21_fingerprints` | — |
| 22 | `exp22_k2` | `exp22_kbody` | — |
| 23 | `exp23_third` | `exp23_screwjoin` | — |
| 24 | `exp24_width` | `exp24_sievecontrol` | — |
| 25 | `exp25_lp` | `exp25_divisor_null` | — |
| 26 | — (unused on cf) | `exp26_fresnel_deep` | — |
| 27 | `exp27_circuit` | `exp27_running` | — |
| 28 | `exp28_squarefree_ties` | `exp28_k0` | — |
| 29 | `exp29_quartic_resultant` | — | — |
| 30 | `exp30_quartic_certificate` | — | `exp30_screwjoin` |
| 31 | `exp31_quintic_certificate` | — | `exp31_product_carrier` |
| 32 | `exp32_reciprocal_sextic` **and** `exp32_sextic_certificate` (cf-internal duplicate) | — | `exp32_lens_numerics` |
| 33 | `exp33_septic_certificate` | — | — |
| 34 | `exp34_buchladder` **and** `exp34_reciprocal_octic` (cf-internal duplicate) | — | — |
| 35 | `exp35_reciprocal_resultant` | — | — |
| 36 | `exp36_cutnorm` **and** `exp36_toy` (cf-internal duplicate) | — | — |
| 37 | `exp37_cf_review36` **and** `exp37_nonic_{discovery,enumerator,bounds}` (cf-internal duplicate; plus `audit37_nonic_symbolic`) | — | — |
| 38 | `exp38_cf_review_leakage` **and** `exp38_character_anchor_z2` (cf-internal duplicate) | — | — |
| 39 | `exp39_rational_fiber_normalization` | — | — |
| 40 | `exp40_dirichlet_Achi_normalization` | — | — |

Notes on the collision set:

1. **exp23 is the danger pair**: cu `exp23_screwjoin` is Theorem J (audited,
   corrected); cf `exp23_third` is the crossover c₃ (proved). Both are
   heavily cited by bare number on their home branches.
2. **The 30–32 rows are new since `MERGE_PLAN.md` was filed** (which
   declared exp39 the next free number, §2.4.3). This branch allocated
   exp30–32 *after* filing that plan, colliding with cf's certificate
   scripts; cu likewise allocated 26–28, colliding with cf at 27–28. The
   no-renumber convention absorbs this — every filename above is unique —
   but it makes this ledger, not the plan's §1.3 table (now superseded on
   rows 26–32), the authoritative lookup.
3. Figure names follow their experiment on each branch
   (`figures/exp13_blocks.png` is cf, `figures/exp13_energy.png` is cu;
   `figures/exp30_screwjoin.png` etc. are ia) — disjoint paths, ambiguous
   numbers, same rule: cite by full stem.
4. ~~Numbering going forward: next free number is exp41 for every author~~
   **Superseded — see the integration update below: next free is exp56.**

## Post-compilation allocations (integration-branch update, 2026-08-12)

Between this ledger's compilation and the integration merge, the fleet
allocated exp40–exp55 (concurrent collisions again at 41–44 and 49 —
the no-renumber/full-stem rule absorbs them):

| N | stems in the merged tree |
|---|---|
| 40 | `exp40_dirichlet_Achi_normalization` (cf) |
| 41 | `exp41_superres` (cu — Toy Theorem K0, `BARRIER.md`); `exp41_nonic_postcensus`, `exp41_selberg_swap` (cf) — **triple, never cite bare** |
| 42 | `exp42_nonic_tail_discovery`, `exp42_proofmass` (cf) |
| 43 | `exp43_rational_pair_channel`, `exp43_sign_patterns` (cf) |
| 44 | `exp44_nonic_certificate` (`NONIC_OBSTRUCTION.md`), `exp44_rational_pair_characters` (cf) |
| 45 | `exp45_reciprocal_decic_certificate` (`RECIPROCAL_DECIC.md`) |
| 46 | `exp46_r0012_audit` (cf-vesper) |
| 47 | `exp47_kappa_constants` (`KAPPA`/R0015) |
| 48 | `exp48_nonreciprocal_decic_frontier` (cf) |
| 49 | `exp49_l3_sdp` (R0017), `exp49_q1_prime_support` (`Q1_PRIME_SUPPORT_AUTOMATON.md`) — **duplicate, never cite bare** |
| 50 | `exp50_cross_reversal_charge` (`CROSS_REVERSAL_CHARGE.md`) |
| 51 | `exp51_global_charge_no_go` (`GLOBAL_CHARGE_DYNAMICS.md`) |
| 52 | `exp52_q1_automaton_controllability` (`Q1_LOCAL_CONTROLLABILITY_NO_GO.md`) |
| 53 | `exp53_window5_polytope` (cf) |
| 54 | `exp54_l5_transplant_lp` (cf) |
| 55 | `exp55_definitional_rigidity` (`DEFINITIONAL_RIGIDITY.md`/R0018) |

Also allocated after compilation: `exp34_twisted_carrier` (ia — χ₃-twisted
product carrier, per-character screw⟺GRH) and `exp37_nonic_*`/`exp38_octic_*`
(cf — the V2 census/certificate stack behind `OCTIC_OBSTRUCTION_V2.md` and
`NONIC_OBSTRUCTION.md`). **Numbering going forward:
next free number is exp56 for every author.** Check `ls code/ | grep expNN`
before allocating; concurrent sessions have collided three times now.
