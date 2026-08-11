# Post-merge reproducibility ledger (Weaver fleet, repro lane)

**Date:** 2026-08-11. **Scope:** spot-audit of headline numerics in the merged tree
(first post-merge run of anything). Six experiments spanning all three pre-merge
branches (main, cu, cf/fleet-k2, ia). All runs launched from `code/` per repo
convention; outputs compared against the quoting note at the note's own precision.

**Environment:** Linux x86_64, Python 3.11.15, numpy 2.4.6, scipy 1.17.1,
sympy 1.14.0, mpmath 1.3.0, matplotlib 3.11.1, python-flint 0.9.0 (installed
cleanly; exp1 used the FLINT backend). Runtimes below are wall-clock with all six
scripts running concurrently on one machine, so they are mild over-estimates of
solo runtimes. Ten-minute timeout per script; none needed it.

## Verdict table

| experiment (branch) | note + claim | reproduced value | verdict | runtime |
|---|---|---|---|---|
| `code/exp1_rigidity.py` (main) | `REPORT.md` §2 Thm A(2): minimal homometric pairs have 6 elements, diameter 11, e.g. {0,1,2,6,8,11}~{0,1,6,7,9,11}; 6 distinct pairs / 12 collision events; 0 sum-marginal collisions. §2.1: F_X irreducible, no non-mirror 0-1 partner | exact pair {0,1,2,6,8,11}~{0,1,6,7,9,11} found; 12 diff-collisions (6 distinct pairs: 2 of size 6, 4 of size 7); 0 sum collisions; F_X irreducible with 0 non-mirror partners at all default X∈{20..500} (FLINT backend) | REPRODUCED | 1 s |
| `code/exp6b_sumspectrum.py` (main) | `REPORT.md` §5 Thm D: band [25,320] corr **0.9999**, amplitude ratio **0.9991**; lines 2γ₁ 1.002, γ₁+γ₂ 0.997, γ₁+γ₃ 1.000, 2γ₂ 0.989 | corr = 0.9999, ratio = 0.9991; line ratios 1.002 / 0.997 / 1.000 / 0.989 — all four exact to quoted precision | REPRODUCED | 104 s |
| `code/exp11_blocks.py` (cu) | `BLOCKS.md` §1 Thm E2: closure **2.1e-13**; band-power split ([##] 1e-6/2e-6, [mix] 0.6218/0.0915, [bb] 0.000233/0.002234); [mix] vs single model corr/ratio 1.0000/1.0000; [bb] vs pair model **0.9997**/0.9995; [mix] vs pair corr 0.07; γ₁ amp 0.32 vs 1313.7; Hardy projection = μ(q) to 4 decimals incl. q=4,12; Besicovitch ≈1e-4 flat in Q | closure 2.06e-13; split 0.000001/0.000002, 0.621754/0.091548, 0.000233/0.002234; 1.0000/1.0000; 0.9997/0.9995; +0.071; 0.322 vs 1313.748; all 11 tested q match μ(q) to 4 decimals; D(Q) ∈ [-0.00003, 0.00014] flat | REPRODUCED | 52 s |
| `code/exp16_mobius.py` (cu) | `FAMILY.md` §1 Thm H′: pair band [28.5,60] corr **0.9999**, ratio **0.9999**; mean of G₁^μ/X² = +0.00007; pair lines 1.00/1.00/1.01; single-band RMS 6× below pair band; diagonal 0.151992 / 0.151982 vs 3/2π²=0.151982; off-diag −0.1473 / −0.1534 | corr = 0.9999, ratio = 0.9999; mean +0.000071; lines 1.00/1.00/1.01; RMS 0.00029 vs 0.00179 (6.2×); diagonal 0.151992 / 0.151982; off-diag −0.147349 / −0.153376. Cached `data/mobius_weights_40.npy` loaded fine | REPRODUCED | 5 s |
| `code/exp22_k2.py` (cf/fleet-k2) | `K2.md` §I.3: k=2 band [27,305] corr **0.99991**, ratio **1.0008**; k=1 re-run 0.99996/1.0003; five lines 0.9942, 1.0039, 0.9971, 0.9904, 1.0115; k-ratio meas/pred 1.0020/1.0123/1.0030; exact-weight \|ΣW₂\|/\|ΣW₁\| = 1/\|3+if\| to six decimals; weight-decay slope **−3.4999** | corr = 0.99991, ratio = 1.0008; k=1 0.99996/1.0003; lines 0.9942/1.0039/0.9971/0.9904/1.0115 (5 of 5 within 2%); k-ratios 1.0020/1.0123/1.0030; exact-weight check 1.000000 at all three lines; slope −3.4999 — every quoted digit matches | REPRODUCED | 103 s |
| `code/exp31_product_carrier.py` (ia) | `PRODUCT_CARRIER.md` §6: corr(q,h)=**1.00000000**, RMS ratio 1.000000, RMS(q−h)/RMS(h)=2.7e-5, max\|q−h\|=1.5e-6; P vs h² **1.000000**/1.000001; P vs binned-ν (34,284 lines) **0.999885**/0.995181; line table (0.9998/1.0005/1.0001/1.0022); γ₄,γ₅ suppression ~500–700× with ν-predicted residue 2.99e-6/3.59e-6 (0.3%) | corr(q,h)=1.00000000, RMS ratio 1.000000, 2.689e-5, 1.529e-6; P vs h² 1.000000/1.000001; binned-ν 34,284 lines, 0.999885/0.995181; line ratios 0.9998/1.0005/1.0001/1.0022; γ₄: q 2.166e-3 → P 2.997e-6 (ν pred 2.988e-6), γ₅: 1.851e-3 → 3.577e-6 (pred 3.585e-6) | REPRODUCED | 94 s |

**Overall: 6 / 6 REPRODUCED. No BROKEN, DISCREPANT, or TIMEOUT-PARTIAL results.**

## Merge-breakage check (imports, data files, paths)

No merge breakage found:

- All imports resolve (`pairfield` helpers used by exp6b/exp11/exp16/exp31; exp22 is
  deliberately self-contained; exp1 falls back flint→sympy and found flint).
- All data paths resolve from the merged layout: `data/odlyzko_zeros_100k.txt`
  (loaded by `pairfield.load_zeros` and directly by exp22 via
  `Path(__file__).parent.parent / "data"`), cached `data/mobius_weights_40.npy`
  (exp16 loads the existing cache rather than recomputing mpmath weights).
- Figure outputs write to `figures/` via `Path(__file__)`-relative paths; the runs
  regenerated `exp6b_sumspectrum.png`, `exp11_blocks.png`, `exp16_mobius.png`,
  `exp22_k2.png`, `exp31_product_carrier.png` (side effect of the scripts
  themselves, not of this audit).

## Minor caveats (pre-existing, not merge bugs)

1. **REPORT.md §5 parameter text vs code:** REPORT quotes exp6b as "primes to
   4·10⁶"; the script's `NMAX = 2_000_000`. `K2.md` §I.2 consistently describes
   exp6b as 2·10⁶, so this is a wording slip in REPORT.md, not code drift — the
   quoted corr/ratio/line numbers reproduce exactly from the 2·10⁶ code.
2. **exp6b slope claim not in printed output:** REPORT's "measured slope −2.500"
   (same-sign weight decay, k=1) is not printed by the current exp6b script, so it
   was not re-verified here; the analogous k=2 slope (−3.4999 vs predicted −3.5)
   is printed and reproduced by exp22.
3. **exp1 default scope:** the script's `__main__` sweeps X ≤ 500; REPORT's
   "every prime cutoff X ≤ 2000 ... single exception X = 11" and the large spot
   checks (X = 5000, 10⁴, 2·10⁴) require editing the X list / longer runs. The
   default-run subset fully reproduces.

## Reproduction protocol used

```
cd code/
python exp1_rigidity.py          # 1 s
python exp6b_sumspectrum.py      # ~2 min
python exp11_blocks.py           # ~1 min
python exp16_mobius.py           # 5 s (cache hit on data/mobius_weights_40.npy)
python exp22_k2.py               # ~2 min
python exp31_product_carrier.py  # ~1.5 min
```

Dependencies: `pip install numpy scipy sympy matplotlib mpmath python-flint`.
