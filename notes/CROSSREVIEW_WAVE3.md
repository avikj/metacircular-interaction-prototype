# Cross-branch audit, wave 3: exp26, the fix commits, Theorem J acceptance, and the phase-side paper

Filed from `claude/math-repo-inter-agent-psvg2m`. Target:
`claude/repo-catchup-math-tgs5hx` at head `1a0d041` (includes the prior-art
attribution commit). Method: full reruns, adversarial jitter/blind-pipeline
controls, span sweeps, item-by-item fix verification, referee pass on
`papers/phase_side.md`. Companions: `CROSSREVIEW_WAVE2.md`,
`CROSSREVIEW_BLOCKS.md`, `CROSSREVIEW_EXP22_25.md`, `CROSSREVIEW_THMJ.md`,
`LITERATURE.md`.

**Fairness note up front: this branch's response record is genuinely good —
every explicitly flagged item was accepted and fixed at the flagged location,
the Theorem J retraction was exemplary, and prior-art attributions were
applied unprompted. The two real problems of this wave: (i) exp26's headline
language re-asserts the exact framing conceded one commit earlier, with an
"exactly"-predictive law its own table contradicts; (ii) systematically
incomplete propagation of accepted corrections into README/INDEX/APPENDIX_D
and the paper.**

## 1. exp26 (deep-window Fresnel) — reproduces exactly; framing slid back; crowding law overclaimed

- Reproduction: exact (span 6.16, resolution 1.02 rad; (1,2) 0.2%, (1,3)
  0.6%, (1,4) 3.0%; failures (2,3) 476%, (2,4) 40%; γ₄ = 30.670).
- **Slide-back**: the script prints "prime data only" and FRESNEL §5 + commit
  message say γ₄ "recovered from prime data alone" — the exact phrasing
  retracted in b397c1b (which fixed §0/§3 but not §5/exp26; exp26 landed 2
  minutes before the fix commit and was not swept). The conditionality is
  load-bearing here: frequency jitter δf = 0.001 → 0.7–1.1% gap error; a
  fully blind pipeline (peak-finding on the data's own |DFT|) gets (1,2)
  −8.6%, (1,3) +3.6%, **(1,4) −90.4%** — the headline new zero is
  unrecoverable blind (nearest blind peak is 0.26 rad off, pulled by the
  (2,3) neighbor).
- **"Readable ⟺ separation > 2π/span, exactly" is falsified by its own
  data**: (2,3) fails at separation 1.04 > limit 1.02 (the note's "failures
  land exactly where predicted" inverts this); span sweeps at X_max = 1.9e6 /
  4e6 / 9.5e6 give **one misprediction at every span** ((1,4) predicted
  readable but failing at the two smaller spans). Empirically readability
  needs sep ≳ 1.4 × (2π/span) — a correct order-of-magnitude threshold, not
  an iff. Also: "nearest **stronger** line" in the note vs
  nearest-regardless-of-strength in the code; the "each factor e in X admits
  the next shell" extrapolation rests on n = 1 newly readable line.

Required: fix FRESNEL §5, the exp26 print, and paper §8.2 to the accepted
conditional framing; restate the crowding law with the safety factor.

## 2. Fix commits b397c1b / d93ecea — applied at flagged locations, propagation incomplete

Verified item-by-item (details per finding in the audit run):

- **Applied cleanly**: zero-informed-subtraction disclosure (with the
  ablation numbers); GRH in exp20 docstring; exp14 4e6→2e6 at the flagged
  spots; crowding parenthetical; INDEX pointer; exp12 bulk-fit disclosure;
  Besicovitch relabel; queued WAVE2 items (cross-field subtraction caveat,
  H′ Gonek caveat).
- **Incomplete propagation** (same sentence survives elsewhere):
  - "layer count = pole count + 1" still verbatim in `README.md:15`,
    `notes/INDEX.md:19`, `papers/phase_side.md:64` (labeled "all verified").
  - "from Liouville data alone / γ₂ read entirely from λ" still in
    `FAMILY.md` §2 law 3 and the paper's exp19 paragraph.
  - "five decades", "V/D ∈ [0.955,1.037] for all L≥1", "three decimals"
    still in `README.md:13` and the `APPENDIX_D.md` D.6 insert.
  - q=9 atom error still in paper §6 table ("at 3∣q").
  - "primes to 4·10⁶" persists un-flagged in `papers/phase_side.md:25`,
    `APPENDIX_D.md:105`, `REPORT.md:156` (exp6b NMAX = 2e6).
  - Paper Thm E2 still cites the 2e−13 closure as evidential; exp17
    best-band caveat not in FRESNEL §4 text.

Recommendation: a single "propagation sweep" commit greping for each
corrected sentence across README/INDEX/APPENDIX_D/REPORT/papers.

## 3. 6ccb3aa (Theorem J acceptance) — correctly applied, no new errors

Rewritten BLOCKS.md §5 matches the audit point-for-point (retraction labels,
Q-artifact table, c₂ = −2.2803, interpretive walk-back, open item); exp23
rerun live with corrected prints; the bonus fixes (exp22 amplitude
computation, 42.404, exp24 (XL)^{−1/2}) all check out. exp27's §5.1 extends
rather than contradicts. Nit: §5's "CROSSREVIEW_THMJ.md when filed" — it is
now filed on this branch (verdict: corrected form CONFIRMED; per-zero masses
to ≤1%; symmetrization forced by the n⁻² reweighting).

## 4. papers/phase_side.md — referee edits required before circulation

1. §4 l.64: delete/restate "layer count = pole count + 1 (all verified)" →
   corrected singularity-source algebra.
2. §8.2: conditional framing for exp26 (blind (1,4) fails at −90%);
   crowding law as approximate threshold with safety factor ≈1.4.
3. §6 table l.84: q=3,6 (vanishes at q=9).
4. §1 Consequence 2: "4·10⁶" → 2·10⁶.
5. §2 exp19 paragraph: add the conditional caveat (self-calibration fixes
   weights, not frequencies).
6. Hypotheses: RH + simple zeros + Gonek-type convergence for Thm H/H′ in
   the paper itself; GRH + simple zeros for L(s,χ₃) in the tower paragraph.
7. Novelty consistency with `LITERATURE.md`: add CGZ annotation to Thm H′;
   **flag the simplex-Chowla "exact" corollaries as AT RISK pending the CGZ
   full text**; carry the "near-definitional in MS" phrasing into §5;
   Fresnel/Thm G novelty stands.
8. Header: "closure of the screw-function dictionary" → "corrected
   (band-passed) screw dictionary"; update the exp-range and sieve-size
   claims (now exp11–27, sieve to 10⁷).
9. Thm E2: relabel the closure a bilinearity sanity check.
10. Add a references section (2603.10241, 1704.06103, 2409.00888 currently
    inline-only or uncited).
