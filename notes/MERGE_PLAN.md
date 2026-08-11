# Merge plan: reconciling the three research branches

Filed from `claude/math-repo-inter-agent-psvg2m`, 2026-08-11. Scope: the
three-way reconciliation of

| branch | head | content |
|---|---|---|
| `origin/main` | `d7ebed0` | base corpus: `REPORT.md`, `ADELIC.md`, `PARITY.md`, `APPENDIX_D.md`, exp1–10 |
| `origin/claude/prime-pair-field-research-18tq7b` ("**cf**", certificate-frontier fleet) | `35816f6` | ~80 commits: ~50 notes, `collab/`, `formal/pairfield` (Lean, 0 sorries), `formal/cubical`, `papers/` (monograph, crossover, cyclotomic), `machinery/`, `site/`, exp11–38 (cf numbering) |
| `origin/claude/repo-catchup-math-tgs5hx` ("**cu**", catchup branch) | `b94eb55` | exp11–25 (cu numbering); `INDEX.md`, `BLOCKS.md`, `FRESNEL.md`, `LIOUVILLE.md`, `FAMILY.md`; edits to `REPORT.md`/`APPENDIX_D.md`/`ADELIC.md`/`PARITY.md`/`README.md` |
| this branch (`psvg2m`) | `cb6b214` | audits only: `CROSSREVIEW_WAVE2.md`, `CROSSREVIEW_BLOCKS.md` (+ this plan) |

Every claim below was verified against the actual trees (`git diff`,
`git show`, grep) and the conflict set was confirmed by **running the merge
in a sandbox clone in both orders**.

---

## 1. Verified conflict inventory

### 1.1 Git-level conflicts (confirmed by simulated merge)

Merging cf and cu onto main (either order) produces **exactly three
conflicted files**, one conflict hunk each:

| file | kind | cf side | cu side |
|---|---|---|---|
| `notes/BLOCKS.md` | **add/add — two entirely different documents** (91 vs 279 lines) | exp13_blocks-based: "Theorem E made empirical" — BC block = truncated singular series (ratio 1.00000), zero block rms 0.0024 = Parseval, **coefficient-2 Lemma** (mixed block carries the single-zero layer with coefficient exactly 2, proved) | exp11/12/13(cu)-based: **Theorem E2** (block spectral support, closure 2×10⁻¹³, mixed = single-zero layer corr 1.0000), **Theorem D‴** (chirp/entropy phase law) + Krein refutation, **D″ constants** (E(η)=Cη, C/D=1.44, V/D→0.9998), §5 **Theorem J** (screw join, exp23_screwjoin) |
| `notes/REPORT.md` | content, §8 problem 1 (lines ~225) | §8.1 rewritten: rigidity is solved (Theorem A′′ via singleton parity); remaining question renamed **Conjecture A″_alg** (prime-prefix irreducibility). Also (non-conflicting hunks): Theorem A′′ statement in §0/§2.1, Lemma 1.3 proof completed, Thm C exponent fixed to $O(t^{-3/2-\varepsilon})$, homometric-pair count corrected (6 pairs/12 events), §9 verdict updated | §8.1 annotated in place with an erratum bracket ("reciprocal factors *remove* swap freedom", `FRESNEL.md` §1). Also (non-conflicting hunk): §5 update — off-diagonal empty for *Hermitian* statistics only; Fresnel phases carry the difference spectrum (Theorem G, exp14 cu) |
| `notes/APPENDIX_D.md` | content, §D.6 item 3 | item 3 struck through: "**Refuted as stated — see `SCREW.md`**": MS screw fn = first-variation sector in Krein normal form; pair measure complex-phased, Krein kernel maximally indefinite; corrected direction = product-weighted masses $1/((\gamma^2+\frac14)(\gamma'^2+\frac14))$ | item 3 annotated: "**Tested — exp12 [cu] / `BLOCKS.md` §2**": measure NOT positive, exact chirp law $W=\sqrt{2\pi}s^{-5/2}e^{-i(sH(p)+5\pi/4)}$ (D‴), positivity only at $|W|^2$ level. Also (non-conflicting hunk): item 1 annotated "numerically closed — exp13 [cu] / `BLOCKS.md` §3" |

The two §D.6(3) strikes are **independent, textually different, and
mathematically consistent** (cf measures 50% negative-real lines /
$\lambda_{\min}/|\lambda|_{\max}=-1.00$; cu derives the closed-form chirp law
that explains it). Both are subsumed by cu's Theorem J, which both branches'
predictions ("screw kernel lives in the mixed block": cf `BLOCKS.md`
consequence 1 & `PARITY.md` §1K; cu Theorem E2 §1) anticipated.

`README.md` is modified by both but **auto-merges** (cf rewrites the
rigidity bullet; cu appends 8 new bullets) — still needs an editorial pass
(see §2).

### 1.2 Files changed on exactly one branch vs main (no git conflict)

- **cu only:** `notes/ADELIC.md` (§1 Galois-lever update from exp21 cu;
  §3 zero-block attribution **corrected** — single-zero sums live in the
  *mixed* block, verified; next-derivations list updated; D‴ bracket added),
  `notes/PARITY.md` (§ final: parity-barrier disjointness dissolved by
  Theorem H / `LIOUVILLE.md` — barrier is a property of the *place*, not the
  function). Plus new: `INDEX.md`, `FRESNEL.md`, `LIOUVILLE.md`, `FAMILY.md`.
- **cf only:** everything else — ~50 new `notes/*.md`, `collab/**` (protocol,
  STATE, 38 messages, discovery claims R0001–R0005), `formal/pairfield`
  (Lean 4.33.0 + mathlib, `lake build` passes, 0 sorries),
  `formal/cubical/ProjectionChargeAudit.agda`, `papers/{pairfield_monograph,
  crossover,prime_prefix_cyclotomic}.md`, `machinery/`, `site/index.html`,
  `.github/workflows/epistemic.yml`, `requirements-discovery.txt`.
- **psvg2m (this branch):** adds `notes/CROSSREVIEW_WAVE2.md`,
  `notes/CROSSREVIEW_BLOCKS.md`, this plan. Merges cleanly onto anything.

`code/`, `figures/`, `data/`: **zero path-level collisions** between the
siblings (verified by set intersection) — all filenames are disjoint. The
collisions are purely semantic (numbering, §1.3).

### 1.3 The exp-numbering collision (verified file-by-file)

Both branches allocated exp11–25 independently. Disjoint filenames,
colliding *numbers* — every bare "expNN" citation in prose is ambiguous in
the merged tree:

| N | cf = 18tq7b (`exp.cf N`) | cu = tgs5hx (`exp.cu N`) |
|---|---|---|
| 11 | `exp11_gauge.py` — Theorem F illustration (`GAUGE.md` §F.5) | `exp11_blocks.py` — Theorem E2 (`BLOCKS.md` §1) |
| 12 | `exp12_screw.py` — MS dictionary (`SCREW.md`) | `exp12_krein.py` — Theorem D‴ (`BLOCKS.md` §2) |
| 13 | `exp13_blocks.py` — block decomposition, coeff-2 (`BLOCKS.md` cf) | `exp13_energy.py` — D″ constants (`BLOCKS.md` §3) |
| 14 | `exp14_weil.py` — explicit formula @1.8e−10 (`WEIL.md`) | `exp14_fresnel.py` — Theorem G gap reading (`FRESNEL.md`) |
| 15 | `exp15_divisor.py` — solvable model (`DIVISOR.md`) | `exp15_liouville.py` — Theorem H (`LIOUVILLE.md`) |
| 16 | `exp16_energy.py` — zero-pair energies (`ENERGY.md`) | `exp16_mobius.py` — Theorem H′ (`FAMILY.md` §1) |
| 17 | `exp17_dside.py` — Montgomery F/GM bridge (`DSIDE.md`) | `exp17_cornu.py` — Cornu zones (`FRESNEL.md` §4) |
| 18 | — (number unused on cf) | `exp18_cross.py` — Λ×μ cross field, s=0 layer (`FAMILY.md`) |
| 19 | `exp19_ternary.py` — (3,3) coefficients (`TERNARY.md`) | `exp19_lambda_fresnel.py` — dressing universality (`FAMILY.md` §2) |
| 20 | `exp20_buchstab.py` **and** `exp20_product.py` (cf-internal duplicate) | `exp20_dirichlet.py` — abelian tower (`FAMILY.md` §2.1) |
| 21 | `exp21_dclose.py` — D″ finite-closure no-go (`DCLOSE_NO_GO.md`) | `exp21_fingerprints.py` — finite-place fingerprints (`FAMILY.md` §2.2) |
| 22 | `exp22_k2.py` — k=2 Cesàro replication (`K2.md` I) | `exp22_kbody.py` — Theorem D‴-k (`FAMILY.md` §2.3) |
| 23 | `exp23_third.py` — crossover c₃ (`K2.md` II) | `exp23_screwjoin.py` — **Theorem J** (`BLOCKS.md` §5) |
| 24 | `exp24_width.py` — parity-barrier width (`WIDTH.md`) | `exp24_sievecontrol.py` — sieve-circuit run (`FAMILY.md` §2.4) |
| 25 | `exp25_lp.py` — LP/negativity landscape (`LP_CERT.md`) | `exp25_divisor_null.py` — anti-Möbius null (`FAMILY.md` §2.5) |
| 27–38 | cf only: `exp27_circuit` … `exp38_*`; **cf-internal duplicates** at 32 (`exp32_reciprocal_sextic`/`exp32_sextic_certificate`), 34 (`exp34_buchladder`/`exp34_reciprocal_octic`), 36 (`exp36_cutnorm`/`exp36_toy`), 38 (`exp38_cf_review_leakage`/`exp38_character_anchor_z2`) | — |

Also non-colliding extensions of main's series: cf `exp1c_bigfactor2.py`,
`exp7b_ties_extended.py`; figure names follow their experiment on each side
(e.g. `figures/exp13_blocks.png` is **cf**, `figures/exp13_energy.png` is
**cu** — disjoint paths, ambiguous numbers).

### 1.4 Bare-number cross-references (grep-verified census)

Bare "expNN" (N∈11–38, no filename suffix) citations that become ambiguous
in the merged tree:

- **cu-meaning** (~53 sites): `BLOCKS.md` cu (exp11×7, exp12×8, exp13×5),
  `FRESNEL.md` (exp14×3, exp17×4), `LIOUVILLE.md` (exp15×6, exp11),
  `FAMILY.md` (exp15/16/18/19/20/21/22/24/25), `INDEX.md` (full table,
  exp11–24), `ADELIC.md` cu edits (exp11×3, exp12, exp21),
  `PARITY.md` cu edit (exp15), `REPORT.md` cu edit (exp14), cu `README.md`
  bullets — **and this branch's `CROSSREVIEW_WAVE2.md` /
  `CROSSREVIEW_BLOCKS.md`** (exp11–25 in cu sense throughout).
- **cf-meaning** (~35 sites in notes + 11 in the monograph): `GAUGE.md` §F.5
  (exp11), `SCREW.md`/`PRODUCT.md` (exp12, exp20), `TERNARY.md`
  ("exp6b/exp13" = exp13_blocks cf; exp19), `WEIL.md` (exp14, exp12),
  `DSIDE.md` (exp17), `DIVISOR.md` (exp15), `ENERGY.md` (exp16),
  `JEWELS.md`/`LP_CERT.md`/`ATIYAH.md` (exp14, exp25), `WIDTH.md` (exp24),
  `LENS_CIRCUIT.md` (exp27, exp24), `BLINDSPOTS.md` (exp27),
  `papers/pairfield_monograph.md` (**§3.5 cites "`BLOCKS`, `exp13`" =
  exp13_blocks cf; §3.7/3.8 cite exp17/exp12 in cf sense**), `collab/STATE.md`
  claims table (exp22/23/24/25/27/34/36 cf sense).
- **Danger case verified:** `LENS_REGULARITY.md` (cf) cites `BLOCKS.md` seven
  times *by filename and by content* ("`BLOCKS.md` Lemma: $2[\sharp\flat]$
  carries it with coefficient 2", "verified $\frac1X\sum\Lambda c_q=\mu(q)$")
  — i.e. it depends on the **cf** BLOCKS content surviving under the name
  `BLOCKS.md`. It does **not** cite BLOCKS by §-number, so the unified-file
  proposal in §2.3 keeps it valid. Conversely cu's `FRESNEL.md`/`FAMILY.md`/
  `ADELIC.md`/`APPENDIX_D.md`/`INDEX.md` cite `BLOCKS.md` **by §-number**
  (§1/§2/§3/§5), so cu's section numbering must survive.

### 1.5 Stale pointers (verified)

1. `INDEX.md` (cu) row "Fresnel reading is dressing-universal … `FAMILY.md`
   §2.3 / exp19": stale — the exp19 material is in `FAMILY.md` §2 (≈line 66);
   §2.3 is now the k-body ladder (exp22 cu). (`CROSSREVIEW_WAVE2.md` §1
   flagged the citation when §2.3 didn't exist; it now exists *with different
   content*, which is worse.)
2. `collab/STATE.md` (cf) corpus map lists **none** of cu's documents
   (INDEX/BLOCKS-cu/FRESNEL/LIOUVILLE/FAMILY) and its `BLOCKS.md` row
   describes only the cf document; claims table row for `BLOCKS.md` must be
   rewritten for the unified file.
3. `INDEX.md` (cu) header/sibling description and open-interface #2
   (LENS_REGULARITY × exp11 cu) predate the merge; interface #4 is this plan.
4. `REPORT.md` §8.1 erratum (cu) annotates a sentence cf deleted; the
   mathematical point (reciprocal factors remove swap freedom) is
   independently present in cf's patched Thm A′ proof (REDTEAM §2 patch: a
   reciprocal $F_0$ makes rigidity hold trivially) and in
   `RECIPROCAL_RESULTANT.md`. Resolution: cf text wins, one-line credit note.
5. Both audits on this branch cite the pre-merge cu tree (`f24ba97`, then
   cu head) — add a numbering-convention header when merged.
6. cf `PRODUCT.md` cites bare "`exp20`" which is ambiguous **within cf
   itself** (`exp20_buchstab.py` vs `exp20_product.py`; it means the latter).

### 1.6 Same-name-different-content summary

Only **one** true same-name-different-content pair exists: `notes/BLOCKS.md`
(§1.1). Everything else is either single-owner or a line-level merge.

---

## 2. Merge order and per-file resolutions

### 2.1 Order

```
integration branch: integration/pairfield-2026-08 (from origin/main)
  step 1: merge origin/claude/prime-pair-field-research-18tq7b   (cf)
  step 2: merge origin/claude/repo-catchup-math-tgs5hx           (cu)
          → resolve REPORT.md, APPENDIX_D.md, BLOCKS.md (below)
  step 3: merge origin/claude/math-repo-inter-agent-psvg2m       (audits + this plan)
  step 4: single "reconciliation sweep" commit                   (§2.4)
```

**Why cf first.** (a) The conflict set is identical in both orders
(simulated); order is chosen for resolution ergonomics. (b) cf *rewrites*
the conflicted passages (REPORT §8.1, APPENDIX_D §D.6.3) while cu
*annotates* them — with cf as HEAD, the resolution is "keep HEAD, graft cu's
additive brackets", which is mechanical. (c) cf carries the infrastructure
(collab/, papers/, formal/, CI) that everything else should land into.
(d) cu already positions itself relative to cf (cedes "Theorem F", cites
`GAUGE.md`/`SCREW.md`/`TENSIONS.md` by name), so applying it second matches
its own self-description. Step 3 is conflict-free (pure additions).

### 2.2 Resolution table

| file | resolution |
|---|---|
| `notes/BLOCKS.md` | **Unified file**, per §2.3 below |
| `notes/REPORT.md` | Base = cf. Keep cu's §5 Fresnel-update paragraph (non-conflicting hunk) with exp14 → `exp14_fresnel`. §8.1: keep cf's rewrite (A″_alg); drop cu's erratum bracket as superseded, add one line: *"an equivalent erratum was filed independently on the catchup branch (`FRESNEL.md` §1) before the A′′ upgrade landed."* |
| `notes/APPENDIX_D.md` | §D.6(1): keep cu's "numerically closed" bracket, cite `exp13_energy`, and soften per `CROSSREVIEW_BLOCKS.md` flags 2–3 ("linear over ~2.5 audited decades"; V/D interval is a grid statement). §D.6(3): keep cf's strikeout + SCREW correction as primary; append cu's D‴ bracket (cite `exp12_krein`); close with: *"Both refutations are consistent; the join is now closed by Theorem J (`BLOCKS.md` §5): the MS screw function IS the mixed block, so Krein positivity lives one block over from the pair measure."* |
| `README.md` | Accept auto-merge, then editorial pass: keep cf's rewritten rigidity bullet + cu's 8 bullets; soften the "0.1% gap reading" bullet per audit (§4.3); add bullets for Theorem F/gauge, Theorem J/screw closure, the certificate tower, Lean formalization; link `notes/INDEX.md` + `collab/STATE.md` as maps. |
| `notes/ADELIC.md`, `notes/PARITY.md` | Take cu (sole modifier). Sweep: qualify its bare exp numbers (`exp11`→`exp11_blocks` etc.). |
| all cu-only notes (`INDEX`, `FRESNEL`, `LIOUVILLE`, `FAMILY`) | Take, then apply §4 pre-publication edits and §1.5 pointer fixes. |
| all cf-only trees (`collab/`, `formal/`, `papers/`, `machinery/`, `site/`, notes) | Take as-is; `site/index.html` to be regenerated post-merge rather than hand-merged. |
| `notes/CROSSREVIEW_*.md`, `notes/MERGE_PLAN.md` | Take from psvg2m; add cu-numbering header note to the two audits. |

### 2.3 The unified `BLOCKS.md`

**Decision: one file, not a split.** A `BLOCKS_ADELIC.md`/`BLOCKS_CLOSURE.md`
split breaks 7 filename citations in `LENS_REGULARITY.md` (cf), the
monograph's §3.5/§3.8 citations (cf), and ~20 §-number citations across
`FRESNEL`/`FAMILY`/`ADELIC`/`APPENDIX_D`/`INDEX` (cu). The two documents
describe the **same decomposition** with complementary results, and the
citation patterns are compatible:

- cf cites `BLOCKS.md` by *filename and lemma name only* (verified: no §N).
- cu cites `BLOCKS.md` by *section number* (§1, §2, §3, §5).

Therefore: **keep cu's §§1–5 numbering verbatim; insert the cf document as
a new §0**, titled *"§0. The first measurement (exp13_blocks): Theorem E
made empirical, and the coefficient-2 lemma"*, with a three-line editorial
preamble recording that the two branches verified the decomposition
independently and consistently — cf proved the coefficient-2 Lemma and
measured 2.08→2 at Q=30; cu's Theorem E2 (exp11_blocks) is the sharpened
attribution (mixed = single-zero layer, corr/ratio 1.0000/1.0000) with the
coefficient folded into the model. The coefficient-2 **Lemma keeps its
name** (LENS_REGULARITY depends on it). Cross-wire the two internally:
§0 ↔ §1 pointers, and §5 (Theorem J) already cites cf's `SCREW.md`.

### 2.4 Reconciliation sweep (one commit, after step 3)

1. **New `notes/EXP_LEDGER.md`** — the authoritative number→file table of
   §1.3 with columns: number, cf file, cu file, note, figure, audit status.
   Convention adopted (matches cu `INDEX.md`/`LIOUVILLE.md` §"namespace by
   filename on merge" and `collab/PROTOCOL.md` §3 "don't renumber others'
   experiments"): **no file is renamed; no experiment is renumbered.**
   Rationale (churn vs clarity): a global renumber would touch 25+ filenames,
   ~100 prose citations, figure names, in-code output strings, all 38 collab
   messages, and the discovery packets' `statement_hash`es — for zero
   mathematical content. Filenames are already unique.
2. **Disambiguation rule**: in *shared/merged* files (`README.md`,
   `REPORT.md`, `APPENDIX_D.md`, `ADELIC.md`, `PARITY.md`, `BLOCKS.md`,
   `INDEX.md`, `papers/pairfield_monograph.md`, `site/`), every bare expNN
   with N≥11 is rewritten to the full stem (`exp13_blocks` vs
   `exp13_energy`). Single-branch notes keep their bare numbers (their
   meaning is fixed by the ledger; rewriting ~90 sites inside signed,
   audited notes is churn without benefit) — each *audited* note instead
   gets one header line: *"exp numbers in this note refer to the cf/cu
   series; see `notes/EXP_LEDGER.md`."* Short forms `exp.cf13` / `exp.cu13`
   are defined in the ledger for future prose.
3. **Numbering going forward**: next free number is **exp39** for every
   author (both 11–25 ranges are retired; cf-internal duplicates 20/32/34/36/38
   noted in the ledger as never-cite-bare).
4. Pointer fixes of §1.5: `INDEX.md` exp19 row → `FAMILY.md` §2;
   `STATE.md` corpus map extended with the five cu documents + unified
   BLOCKS row + this plan + the two audits; `PRODUCT.md` `exp20` →
   `exp20_product`.
5. Apply the mandatory content edits of §4 (audit-required corrections).
6. Update the monograph correction ledger (§9) and `README.md` per above.

---

## 3. Theorem-name ledger (unified)

Verified name-by-name against the trees. "Status" reflects the audits filed
on this branch where applicable.

| name | statement (one line) | branch | file | status |
|---|---|---|---|---|
| **A** (i–iii) | sum marginal injective on nonneg. sequences; difference kernel = homometry; heat resolution restores completeness | main | `REPORT.md` §2 | proved; A(i) Lean-formalized (`formal/pairfield`, 0 sorries) |
| **A′** | prime prefix rigid up to reflection *if* non-cyclotomic part of $F_X$ irreducible | main (proof patched on cf) | `REPORT.md` §2.1 | proved; three glossed points patched (`REDTEAM.md` §2) |
| **A′′** | **unconditional**: every prime prefix determined by its difference multiset up to translation/reflection (singleton parity) | cf | `REPORT.md` §2.1, `PARITY_RIGIDITY.md` | proved, elementary; supersedes Conjecture A″ (main) |
| **Conj. A″_alg** | non-cyclotomic part of $F_X$ irreducible for all $X$ | cf (renamed from main's Conj. A″) | `REPORT.md` §8.1 | open; layers ≤7 + reciprocal octics closed, first open layer = nonreciprocal octic |
| **B** | aperture law: $\log\|z\|\leftrightarrow\gamma+\gamma'$, $\arg z\leftrightarrow\gamma-\gamma'$ | main | `REPORT.md` §3 | proved+verified; scope sharpened by G (Hermitian statistics only) |
| **C** | heat smoothing makes "average Goldbach ⟺ RH" algebraic | main | `REPORT.md` §4 | proved; error-term exponent corrected on cf |
| **D** | Goldbach 2nd-order term = zero-pair sum at $\gamma_i+\gamma_j$, Beta weights | main | `REPORT.md` §5 | proved+verified (0.9999) |
| **D′** | opposite-sign suppression / $s^{-5/2}$ weight decay | main | `APPENDIX_D.md` | proved |
| **D″** | windowed Goldbach variance ⟺ weighted additive energy of zeros | main | `APPENDIX_D.md` | conditional (near-diagonal separation open); constants closed numerically by exp13_energy (cu); finite-check route closed negatively by `DCLOSE_NO_GO.md` (cf) |
| **D‴** | exact weight law $W=\sqrt{2\pi}s^{-5/2}e^{-i(sH(p)+5\pi/4)}$ — modulus knows the sum, phase = splitting entropy | cu | `BLOCKS.md` §2 (exp12_krein) | proved (Stirling) + verified; **audited CONFIRMED** (`CROSSREVIEW_BLOCKS.md`) |
| **D‴-k** | k-body ladder $W_k=(2\pi)^{(k-1)/2}s^{-(k+3)/2}e^{-i(sH_k+(k+3)\pi/4)}$ | cu | `FAMILY.md` §2.3 (exp22_kbody) | verified k=2,3,4; audit in flight |
| **D1** | depth Mellin closed form: $\zeta(s)\prod_{p\le y}(1-p^{-s})=e^{-\gamma}e^{\mathrm{Ein}(\lambda)}/\lambda$; Stieltjes ladder cancels | cf | `BUCHSTAB_LADDER.md` | proved (K2.2+Mertens); cross-reviewed (msg 0030); = **R0003**. *Name flag: "D1" invites confusion with D′/D″/D‴ — recommend "Theorem D₁ (depth)" in the monograph* |
| **E** | two-body adelic decomposition (canonical BC projector) | main | `ADELIC.md` §3 | construction; made empirical (cf BLOCKS §0), sharpened (cu E2), attribution corrected (cu ADELIC §3) |
| **E0 / E1** (Props.) | β=1 criticality; positive-cone rigidity | main | `ADELIC.md` | proved |
| **E2** | block spectral support: BC dead, mixed = single-zero layer, [♭♭] = pair layer | cu | `BLOCKS.md` §1 (exp11_blocks) | verified (closure 2×10⁻¹³); **audited CONFIRMED**; **renamed from "Theorem F" by cu to cede the name — verified at `INDEX.md`:27 and `LIOUVILLE.md`:144–146** |
| **F** | parity = protected gauge charge of the critical affine equilibrium (Cuntz $Q_{\mathbb N}$ no-go) | cf | `GAUGE.md` (exp11_gauge) | proved, audited vs Cuntz's paper; **name uncontested after cu's cession** |
| **Coefficient-2 Lemma** | mixed block carries the single-zero layer with coefficient exactly 2 | cf | `BLOCKS.md` (→ unified §0) | proved + measured (2.08 at Q=30); load-bearing for `LENS_REGULARITY.md` |
| **G** | Fresnel coupling: $\arg c_f\supset(\gamma-\gamma')^2/2f$ — difference spectrum in sum-line phases | cu | `FRESNEL.md` (exp14_fresnel) | proved+verified; **audited CONFIRMED with 2 framing corrections** (§4.3) |
| **H** | Liouville–Goldbach trace formula: λ-field pure spectrum, weights $\zeta(2\rho)/\zeta'(\rho)$ | cu | `LIOUVILLE.md` (exp15_liouville) | verified 0.9999–1.0000; **audited CONFIRMED** |
| **H′** | Möbius = the pure pair field (no pole ⟹ pair layer only) | cu | `FAMILY.md` §1 (exp16_mobius) | verified; **audited CONFIRMED** (convergence caveat to restore, §4.1) |
| **J** | screw×blocks join: MS screw function IS the mixed block of the reweighted field; RH ⟺ first-variation sector is a screw line | cu | `BLOCKS.md` §5 (exp23_screwjoin) | verified (corr 1.0000, ratio 0.9992, c₂=5.1407); **audit in flight** (`CROSSREVIEW_THMJ.md` pending) — merge flagged provisional |
| **K** | parity K-blindness of the affine Toeplitz extension: α_λ outer, no K-theory twist class | cf | `KBOUNDARY.md` | landed; = **R0004** (formalizing) |
| **W3** (Prop.) | Weil-positivity exact obstruction | cf | `WEIL.md` (exp14_weil) | landed |
| **LP2** (Prop.) | Hodge-index / Castelnuovo form of the Weil criterion ($n_+(I)=1$) | cf | `LP_CERT.md` (exp25_lp) | landed; = **R0005** (formalizing) |
| **W1** (Lemma) | power savings ⇒ Siegel-free region (barrier width ladder) | cf | `WIDTH.md` (exp24_width) | landed |
| certificate tower | quartic/quintic/sextic/septic/reciprocal-octic exclusions; all-degree parity & reciprocal resultants; global cyclotomic classification; effective factor-degree divergence | cf | `PARITY_RESULTANT`, `QUINTIC/SEXTIC/SEPTIC_OBSTRUCTION`, `RECIPROCAL_*`, `CYCLOTOMIC_TRACE`, `ASYMPTOTIC_FACTOR_RIGIDITY` | proved (exact computer-assisted); hostile audits passed |
| LENS theorems | interval cut norm ⟺ RH; Bohr cuts ⟺ GRH; exact arithmetic regularity; sieve-circuit rungs 1/1″/2/3 | cf | `LENS_REGULARITY.md`, `LENS_CIRCUIT.md` | proved; cross-reviewed (msgs 0028/0029) |
| **R0001** | character-anchor homometric rigidity (transport of A′′) | cf registry | `collab/discovery/claims/R0001-…` | proving (cycle 2) |
| **R0002** | nonic prime-prefix factor classification | cf registry | `…/R0002-…` | **seed only — census quarantined** (§4.6) |
| **R0003** | = Theorem D1 | cf registry | `…/R0003-…` | proving (cycle 3) |
| **R0004** | = Theorem K | cf registry | `…/R0004-…` | formalizing |
| **R0005** | = Prop. LP2 | cf registry | `…/R0005-…` | formalizing |

**Name-clash verdicts:** (1) "Theorem F" — resolved pre-merge by cu's
explicit cession (verified); F = gauge no-go everywhere. (2) "A″" — main's
*Conjecture* A″ vs cf's *Theorem* A′′: resolved by cf's split into Theorem
A′′ + Conjecture A″_alg; cu's §8.1 erratum referred to the dead text.
(3) "Theorem E" vs "E2" — cu chose E2 precisely to avoid main's E; keep.
(4) "D1" vs the D′/D″/D‴ prime-family — typographic hazard only; rename in
the monograph, keep in the note. (5) No other collisions found (G/H/H′/J/K
are single-owner).

---

## 4. What must NOT be merged blindly

Merging the files is fine; **propagating their claims into README/monograph/
site without these edits is not.** Sources: `CROSSREVIEW_WAVE2.md` (this
branch), `CROSSREVIEW_BLOCKS.md` (this branch), cf's own STATE/messages.

1. **`FAMILY.md` law 1 is false as stated** ("layer count = pole count + 1"
   contradicts its own table: Λ has 1 pole, 3 layers). Required restatement:
   layers = pairwise products of Mellin singularity sources
   (poles ∪ zero-string ∪ {s=0}), with residue-vanishing deletions.
   [WAVE2 §2.1]
2. **`FAMILY.md` §2.2 "0.8661 at $3\mid q$" is wrong at q=9** — the atom
   provably vanishes (exp21_fingerprints measures 0.0004); keep `ADELIC.md`'s
   "levels 3, 6" phrasing. Also §2 law 3's crowding parenthetical is garbled
   (it is the single line at γ₄=30.425 that crowds the (1,1) pair line;
   ratio ≈38×), and H′'s Gonek-type convergence caveat (present in
   `LIOUVILLE.md`) must be restored. [WAVE2 §2.1–2.4]
3. **`exp20_dirichlet` silently assumes GRH + simple zeros for
   $L(s,\chi_3)$** — the only unstated hypothesis in the family line; add
   the hypothesis to `FAMILY.md` §2.1 and anywhere the abelian tower is
   quoted. [WAVE2 §2.3]
4. **`FRESNEL.md` framing**: "gaps read off Goldbach data to 0.1%" is
   conditional (pair frequencies taken from the zero table; blind recovery
   is ~10–30%) — defensible form: *given the zero sums, the phases determine
   the differences to 0.1%*. exp14_fresnel's foreground subtraction consumes
   30k known zeros (essential: without it +185% error); promote exp19's
   self-calibration as the honest default. Doc bugs: "primes to 4·10⁶" →
   2·10⁶ (three places); exp17 zone-uniformity quoted at its best band.
   **These propagate**: cu's README bullet, REPORT §5 update, and INDEX
   Theorem-G row inherit the 0.1% slogan — soften all in the sweep.
   [WAVE2 §1]
5. **cu `BLOCKS.md` wording flags** (results CONFIRMED, wording not):
   the 2×10⁻¹³ closure is a tautological FFT check (label as sanity check);
   "E(η) linear over five decades" → ~2.5 audited decades; "V/D∈[0.955,1.037]
   for all L≥1" is a 13-point grid at one u₀ (u₀-independent statement is
   the limit); exp12_krein's failed bulk regression (−0.411 vs −1) must be
   disclosed next to the passing envelope statistic; the Besicovitch "tail
   prediction" is mislabeled (mean → 0 exactly by Carmichael orthogonality).
   [CROSSREVIEW_BLOCKS]
6. **cf quarantine (msg 0033)**: the full-octic certificate and all
   provisional nonic counts are **QUARANTINED** (Graeffe coefficient bounds
   mis-oriented). Nothing quarantined is on-branch — but do not resurrect
   `exp36_octic_*`/`OCTIC_OBSTRUCTION.md` from any stash, and R0002 stays
   "seed". `RIGIDITY_FRONTIER.md`/README claims must continue to say "first
   open layer = nonreciprocal octic", nothing stronger.
7. **Theorem J and cu exp22–25 are un-audited** as of this filing: this
   branch's audits cover cu exp11–21 only; `CROSSREVIEW_THMJ.md` is in
   flight. Merge `BLOCKS.md` §5 and `FAMILY.md` §§2.3–2.5 with an explicit
   "pending adversarial cross-review" status line, and do not promote
   Theorem J to the monograph's main line until it files.
8. **D″ status language**: cu `BLOCKS.md` §3 "numerically closed" must not
   drift into "closed" — cf's `DCLOSE_NO_GO.md` proves the finite-check
   route *cannot* certify the separation hypothesis (T⁻⁸ four-zero
   separation needed); the actual zeta estimate remains open. Keep both
   statements adjacent in the unified file.
9. **`CORE_KMS.md`** carries self-flagged gaps (§8) — merge, don't upgrade
   its status. **`PROJECTION_LEAKAGE.md`** has a requested cosmetic
   inner-product fix (msg 0038) — apply in sweep.
10. **`site/index.html`** — human-facing artifact; regenerate from the
    merged corpus rather than hand-merging.

---

## 5. Monograph chapter mapping

Target: `papers/pairfield_monograph.md` (cf). Its TOC (verified) and where
every note lands, extending cu `INDEX.md`'s sketch (GAUGE+LIOUVILLE = one
chapter; SCREW+BLOCKS§2+FRESNEL = one chapter; FAMILY+solvable-models = one
chapter):

| monograph part | existing sections | absorbs (cf) | absorbs (cu) |
|---|---|---|---|
| §1 Introduction | 1.1–1.4 | `TENSIONS.md` (method), correction trail | INDEX through-line ("read the phases") |
| §2 Part I — Information | A, A′′, E1, factor frontier (2.1–2.5) | `PARITY_RIGIDITY`, `ASYMPTOTIC_FACTOR_RIGIDITY`, `RIGIDITY_FRONTIER`, `CYCLOTOMIC_TRACE`, `PARITY_RESULTANT`, `CUBIC/QUINTIC/SEXTIC/SEPTIC_OBSTRUCTION`, `RECIPROCAL_SEXTIC/OCTIC/RESULTANT` (§2.5 tower detail), `CHARACTER_ANCHOR_RIGIDITY` (R0001, transport remark), companion `papers/prime_prefix_cyclotomic.md` | — |
| §3 Part II — Spectrum | B, C, D, D″, blocks, dichotomy, D-side, screw (3.1–3.8) | §3.4 += `ENERGY`, `DCLOSE_NO_GO`, `SHARP_CUTOFF` (k=0 boundary); §3.5 = unified `BLOCKS.md` §0; §3.8 += `PRODUCT`, `PRODUCT_WEIGHT_NO_GO` | §3.5 += E2 + D‴ + D″-constants (`BLOCKS.md` §§1–3); **new §3.9 "Fresnel phases: the off-diagonal cell"** = `FRESNEL.md` (Thm G + Cornu) — the SCREW+BLOCKS§2+FRESNEL chapter of INDEX's sketch lives as §3.5+§3.8+§3.9; §3.8 gains closing subsection **"the join closed: Theorem J"** (`BLOCKS.md` §5, exp23_screwjoin) once audited |
| §4 Part III — Equilibrium | critical BC, crossover, projector+Thm E (4.1–4.3) | `K2.md` (k-ladder + c₃ closed form → §4.2), crossover paper stays companion | cu `ADELIC.md` §3 correction is upstream of §4.3 |
| §5 Part IV — Charge | F, CORE_KMS, spectral types, Weil (5.1–5.4) | `CORE_KMS`, `KBOUNDARY` (**new §5.5 "Theorem K: no K-theoretic charge"**), `TOY_OBSTRUCTION`, `CUBICAL_QUOTIENT_AUDIT`, `PROJECTION_LEAKAGE` (charge-descent fine print), `WEIL`+`LP_CERT`+`ATIYAH`+`JEWELS` (§5.4 expanded: Hodge-index landscape), `FAREY_TRANSFER`, `KBOUNDARY` | **new §5.6 "the exposed place"** = `LIOUVILLE.md` (Thm H) — the GAUGE+LIOUVILLE protection/exposure chapter of INDEX's sketch = §5.1+§5.2+§5.6 |
| §6 Part V — Calibration | ternary, divisor (6.1–6.2) | `TERNARY` (+cu exp22_kbody closes its triple layer — cite both), `DIVISOR`, `FF` (function-field third column, when landed), `VV` | **new §6.3 "the residue-dressing family and the abelian tower"** = `FAMILY.md` (H′, classification, s=0 layer, fingerprints, §§2.4–2.5 circuit/null runs) — INDEX sketch's third chapter |
| §7 Part VI — The wall | wall chapter | `LENS_REGULARITY` (cut-norm RH, exact regularity, wall relocation), `LENS_CIRCUIT`, `WIDTH`, `BUCHSTAB_WINDOW`, `BUCHSTAB_LADDER`, `DSIDE` demand table, `BLINDSPOTS` | Fresnel caveat (what phase reading does *not* give: §4 of `FRESNEL.md`) |
| §8 Dependency diagram | mermaid | regenerate including cu nodes | E2/D‴/G/H/H′/J/D‴-k nodes |
| §9 Correction ledger + reproducibility | ledger | += REDTEAM entries | += cu corrections (ADELIC §3 attribution, REPORT §8.1 erratum-then-supersession, FRESNEL doc fixes) **and this branch's two audit reports**; reproducibility table gains the cu exp column keyed by `EXP_LEDGER.md` |
| meta / not monograph | — | `MATH_OS`, `METALOOP`, `UNIFICATION`, `ROSETTA_ENGINE`, `WOLFRAM_LENS`, `WOLFRAM_ADOPTION`, `CENTERING_ATOMS` (methods appendix candidates), `LEAN_STATUS`+`formal/` (formalization appendix), `REDTEAM`, collab/ | `INDEX.md` (superseded by ledger+STATE post-merge; keep as historical map) |

---

## 6. Execution checklist

- [ ] `git checkout -b integration/pairfield-2026-08 origin/main`
- [ ] merge cf; merge cu; resolve the 3 files per §2.2/§2.3
- [ ] merge psvg2m (audits + this plan)
- [ ] sweep commit: `EXP_LEDGER.md`, disambiguation rewrites in shared files,
      pointer fixes (§1.5), mandatory content edits (§4), README/monograph
      ledger updates, STATE corpus map
- [ ] regenerate `site/index.html`
- [ ] file `CROSSREVIEW_THMJ.md`; on CONFIRMED, lift Theorem J's provisional
      flag and add monograph §3.8 closing subsection
- [ ] PR to `main` with this plan linked
