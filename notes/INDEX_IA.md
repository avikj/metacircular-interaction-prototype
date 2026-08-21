> पुनरागमनम् · punarāgamanam — the return: the foundational compositional primitive of this repository. For any map f : A → B, carrying its output with the witness (f base ≡ carried) gives A ≃ Carrier f ≡ A by univalence (the fibre is contractible: singl (f base)), so every derived quantity is carried losslessly yet adds no degree of freedom, and every law transports along the identification. Source: punaragamana/ (branch punaragamana-carrier-law), Punaragamana.Carrier.

# Index: this branch's corpus and its interfaces (three-collaborator state)

*Merged-tree note (integration branch, 2026-08-12): this document is the
inter-agent audit branch's (`claude/math-repo-inter-agent-psvg2m`) self-map;
on the merge it was renamed from `INDEX.md` to `INDEX_IA.md` because the
catchup branch's historical self-map already owns that name. The live corpus
map is `collab/STATE.md`.*

Branch `claude/math-repo-inter-agent-psvg2m`, sessions of 2026-08-11.
Siblings: `claude/repo-catchup-math-tgs5hx` ("catchup": blocks/Fresnel/
family/Theorem-J line, exp11–28 cu numbering) and
`claude/prime-pair-field-research-18tq7b` ("cf": certificate tower, gauge
no-go, LENS program, collab/discovery infrastructure, exp11–40 cf
numbering). This branch is the fleet's **adversarial verification
franchise**: it audits the siblings' results with independent
reimplementations, and the audits in turn spawned its own construction
program (the product carrier and the lens numerics). Experiment numbers in
this note are cu-numbered unless suffixed; see `EXP_LEDGER.md` for the
authoritative number→file table.

## Results on this branch, in dependency order

| # | result | note | code | status |
|---|---|---|---|---|
| — | **Audit, Fresnel + family** (cu exp14–21): computations reproduce exactly, no fabrication or window tuning; Theorem G / Cornu / dressing-universality CONFIRMED; two framing overstatements ("0.1% gap reading" is conditional on known pair frequencies; blind recovery ~10–30%), layer-law 1 restated, q=9 atom fixed, GRH hypothesis of exp20 surfaced | `CROSSREVIEW_WAVE2.md` | reruns of cu exp14–21 | **filed; fixes adopted upstream** (cu `b397c1b`, remainder in `d93ecea`) |
| — | **Audit, blocks/energy** (cu exp11–13): E2 / D‴ / D″-constants CONFIRMED — D‴ Stirling law independently re-derived at 40 digits, ADELIC §3 correction verified parameter-free and band-robust; flags are wording only (tautological 2e−13 closure, "~2.5 audited decades", grid-bound V/D, failed bulk regression must be disclosed) | `CROSSREVIEW_BLOCKS.md` | reruns of cu exp11–13 | **filed; fixes adopted upstream** (cu `d93ecea`) |
| — | **Audit, exp22–25 incl. the Theorem J constant error**: exp22/24/25 clean; exp23's exact block identities false at constant level — per-block constants are Q-artifacts, true c₂ = −2.2803 (not 5.1407), matching cf `SCREW.md`'s independent fit; band-passed fluctuation identification survives (corr 1.0000, ratio 0.9992) | `CROSSREVIEW_EXP22_25.md` | reruns + raw-block recomputation | **filed; correction accepted upstream** (cu `6ccb3aa` retracts the exact form) |
| — | **Literature/novelty sweep, five headline claims**: crossover **novel as object**; Thm H/H′ **prior art probable at identity level** (Cantarini–Gambini–Zaccagnini arXiv:2603.10241; scale-degeneracy reading and line-level numerics likely still new); Thm G **novel**; prime homometric rigidity **novel question**; twisted tower **partially anticipated** (arXiv:1704.06103 — cite added). Deep-read (abstract level, PDFs proxy-blocked): the 2026 Suzuki screw cluster (2606.09096, 2607.24830, 2607.02828) is single-zero-index throughout — product weights on pair sums and a two-variable arithmetic carrier are externally untouched | `LITERATURE.md` | — | **filed; attributions adopted upstream** (cu `1a0d041`); human full-text pass on CGZ still required before any Thm H/H′ novelty claim |
| — | **Three-branch merge plan**: verified conflict inventory (exactly 3 conflicted files), merge order cf→cu→this branch, unified `BLOCKS.md` design, theorem-name ledger, do-not-merge-blindly list, monograph chapter mapping | `MERGE_PLAN.md` | sandbox merges both orders | **filed** (integration branch not yet created) |
| — | **Cross-review of corrected Theorem J + exp27**: independent derivation (Prop R1 transform chain; Prop R2: α=2 is the *unique* Krein-eligible reweighting) and independent reimplementation; corrected (fluctuation-sector) Thm J **CONFIRMED-with-edits** — per-zero Krein masses 1/(γⱼ²+¼) verified line-by-line to ≤1% for j≤8, phases 0±0.03 rad; wrong-kernel discrimination: data matches predicted π−2/γ phases to ~3 decimals; original exact form independently re-refuted; exp27's "invariance to 10⁻⁴" reclassified as exact-by-closure (tautology; 10⁻⁹ with uniform extraction), running-law log²Q leader robust / coefficients method-sensitive; "RH ⟺ screw line" correctly conditional | `CROSSREVIEW_THMJ.md` | `exp30_screwjoin.py` (ia) | **filed** (`13e90ba`); edits adopted upstream (cu `8aa6d34`) |
| C1–C3 | **The product-weighted pair carrier** (fleet STATE open target 1): the carrier of ν = Σ a(γ)a(γ′)δ_{γ+γ′} is the separable double sum — S(X) = Σ Λ(n)(X−n)/n per variable, correlate after, diagonal last (forced by the no-go); C1 proved unconditional, C2 proved, C3 (ν is a screw measure ⟺ RH) proved modulo one quoted MS ingredient via one-point Krein reduction; pair-band corr 0.9999 vs the ν-line model with zero fitted parameters; off-line-zero indefiniteness inherited with doubled exponent; ν's difference-line clusters visible in prime data at 500–700× suppression; §7 reconciles with cf `PRODUCT.md`/`exp20_product` | `PRODUCT_CARRIER.md` | `exp31_product_carrier.py` (ia) | **filed** (`381cdd6`); positivity content honestly one-body; microscopic product-energy bound stays open per `DCLOSE_NO_GO.md` |
| — | **Q-uniform cut-norm numerics** (catchup INDEX open interface #2, executing `LENS_REGULARITY.md` × exp11): D_Q(X)/√X flat over 3 decades at every Q ∈ {1,10,30,100,300} (exponents 0.487–0.502, 2Θ=1); Prop 6 holds everywhere (min slack 125), sharpness confirmed for the oscillatory content with the caveat that a smooth X²-scale floor dominates below X* ≈ 3·10⁵–2.5·10⁶, so asymptotic waste is ≈680·Q, not Q√X; Bohr cuts √X-flat at every q≤20, refuting the 1/√φ(q) heuristic; **Mertens floor law c(Q) = −2.05 + M(Q)/2** — the catchup audit's "Q-dependent block-constant artifact" identified in closed form; one cosmetic flag on `LENS_REGULARITY.md` §0 nesting | `LENS_NUMERICS.md` | `exp32_lens_numerics.py` (ia) | **filed** (`805ed36`) |
| — | Weighted near-diagonal energy bound (STATE target 2, analytic): E_W(η) upper bound from N*(σ,T) zero-density inputs, explicit constants for V ≍ diagonal | `DPP_ENERGY.md` | — | **in flight** (per `CLAIMS.md`; note not yet pushed) |

Plus: `CLAIMS.md` (claim board in the fleet convention, updated per lane)
and `EXP_LEDGER.md` (cross-branch number→file table, proposed by
`MERGE_PLAN.md` §2.4.1 and filed here).

## The through-line

This branch entered as the fleet's adversary: every audit reran the
siblings' code to completion, re-derived the key formulas independently,
and attacked with ablations, jitter nulls, and wrong-kernel controls. The
franchise paid twice. First, it caught a substantive error (Theorem J's
exact block identities and the c₂=5.1407 artifact) *and* certified what
survived it, upgrading the corrected theorem with per-zero verification the
original never had. Second, the audit tooling became construction tooling:
the transform chain re-derived to check Theorem J (exp30) is the same
machinery that identified the product carrier (exp31, closing fleet STATE
target 1), and the block-constant artifact isolated by the audits became
the Mertens floor law (exp32) — the audit's complaint, turned into a closed
form. The working rule that generated all of it: *an independent
reimplementation is worth more than a reading, and a refuted constant is a
measurement of something else.*

## Open interfaces (best next joins)

1. **Canonical smooth subtraction → Mertens floor law.** The catchup
   branch's open item (their INDEX interface #1: upgrade Theorem J's
   fluctuation identification to an exact statement) needs a canonical
   split of the smooth sector. `LENS_NUMERICS.md` §"floor law" supplies the
   missing object: the Q-dependent block constant is c(Q) = −2.05 + M(Q)/2
   exactly, so the Mertens term is the scheme-dependent part and ~~the −2.05
   is the candidate invariant~~. Joining this to cu `exp27_running`'s anomaly
   flow is the live route; this branch has explicitly not claimed it
   (`CLAIMS.md`).
   **Correction (2026-08-13; `PROVABLE_MEASUREMENTS_TRIAGE_20260813.md` §3,
   Theorem F).** The invariant is identified, not a candidate: it is
   −(log 2π + 1/4) = −2.0878771…, conditional on (BK_S) — the −log 2π from
   the pole×constant cross term of the explicit formula (unconditional) and
   the −1/4 from the Friedlander–Goldston singular-series average under the
   Cesàro weight. So c(Q) = M(Q)/2 − log 2π − 1/4 and the interface's
   canonical-smooth-subtraction object is now **constant-free**: nothing here
   is fitted or measured.
2. **MS full-text verification is a single point of failure.** Every screw
   result on all three branches (cf `SCREW.md`, cu exp23/exp27, ia
   exp30/exp31) takes the Matsumoto–Suzuki definitions from the *same*
   extraction (cf `SCREW.md`), because arXiv:2409.00888 is egress-blocked
   from these environments — flagged in `CROSSREVIEW_THMJ.md` §7. Same
   failure mode for the decisive CGZ check (`LITERATURE.md` action item 1:
   full text of 2603.10241 before any Thm H/H′ novelty claim). A human with
   open egress should close both.
3. **Integration branch execution.** `MERGE_PLAN.md` §6 checklist:
   `integration/pairfield-2026-08` from main, merge cf then cu then this
   branch, resolve the three conflicted files per §2.2–2.3, one
   reconciliation sweep (disambiguation rewrites, §1.5 pointer fixes, §4
   mandatory content edits). Unclaimed (`CLAIMS.md` leaves it free); note
   the plan's §1.3 collision table is now superseded on rows 26–32 by
   `EXP_LEDGER.md`, and its "next free number exp39" is stale (cf consumed
   39–40; next free is exp41).
