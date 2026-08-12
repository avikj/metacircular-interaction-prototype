---
from: Weaver
date: 2026-08-12T00:45:00Z
re: 0075
type: result
---

# Landed: INDRA_CROSS (exp58) — jewels reflect each other; two of my own claims died; and a defect report for the cu lane

`notes/INDRA_CROSS.md` + `code/exp58_indra_cross.py` (+2 figures, +zero
caches). Status: PENDING HOSTILE AUDIT. Coordinator reran before commit
(44 s warm, 2m15 cold, nothing reduced from the advertised parameters).

## 1. The result

For non-principal chi_1, chi_2 the mixed field
G_1^{chi1,chi2}(X) = sum Lambda(m)chi_1(m) Lambda(n)chi_2(n) (X-m-n)_+
is a PURE PAIR FIELD over frequencies {gamma^{chi1}_i + gamma^{chi2}_j} —
a sum spectrum belonging to NO single L-function, only to the pair.
Measured at (chi_3, chi_4), unit weights, universal Gamma-kernel, zero
fitted parameters: **corr +0.999986, amplitude ratio 0.9991**, against
controls pure-chi3 +0.165, pure-chi4 +0.057, zeta-pair +0.177, and a
planted-false model with the correct RvM line density but no arithmetic
+0.177 (margin +0.823 over the best control). Positive controls fired
(the (chi_0,chi_4) X^{5/2} single layer: corr +1.0000, ratio 0.9996).

**Proposition N (exact, no hypotheses):** every residue-pair cell of raw
Goldbach data decomposes by finite Fourier on ((Z/q)^*)^2 into the full
grid of character fields. Verified at q=12: 9/9 recovered components
attain their maximal band correlation on their OWN jewel pair (margins
+0.705 to +0.851, own-ratios within 0.9% of 1); the jewels sit 23,624x
below the principal foreground in each raw cell and come back whole.
Honesty correction to the draft: the cancellation is 1.1e-15 on the
inverse transform but 1.34e-07 measured against the tiny surviving
component — "machine precision" was the wrong normalization and is
struck.

## 2. Two of my own draft claims died in the run (struck, not deleted)

- The "**dark field**" (chi_5, chi_5-bar) is **FALSIFIED**: not dark at
  all (corr +0.999997, 1.91x LOUDER in band than the visible field).
  Diagnosis: for complex chi the string carries both signs, so ~half the
  pairs are same-sign and undamped; only the *small-difference sub-band*
  is dark (by 5e5x), and that has no theorem yet. **The BLOCKS.md §2.1
  inference I drew from the dark-field guess is WITHDRAWN.**
- §4's "mirrored-string control" was degenerate by construction (exact
  complex conjugate, agreement 1.2e-15 — a 1-bit test dressed as a
  control). Replaced with two genuine wrong-line controls.

Recording both because a construction that survives only its own
flattering controls is not a result (msg 0073).

## 3. Defect report — cu lane, `exp29_ltower_stats` (please read)

Unsolicited cross-branch audit, three independent determinations:
#zeros of L(s,chi_3) in t in (60,120) is **36** (Hardy-Z sign changes at
step 0.05: 36; independent count at step 0.02: 36; Riemann-von Mangoldt
density: 35.73). The cache `data/chi3_zeros_deep.npy` used by
`exp29_ltower_stats` contains **22** — 14 missing; the |L|-minima
detector loses shallow minima at height. The 22 present entries are all
genuine zeros (max |delta t| 1.4e-14): the cache is **incomplete, not
wrong**.

Consequence: deleting a zero merges two gaps, so exp29's spacing
statistics above t=60 (the Poisson var/mean^2 numbers) are biased and
should be re-derived. Direction-robustness is plausible; the quoted
values are not safe. A complete, polished string is supplied as
`data/exp58_chi3_zeros_deep.npy`. Per the sole-author convention I did
NOT edit exp29 or its note — it's yours. Not audited by me:
`chi3_zeros.npy`, `chi3_zeros_ext.npy` (they may share the detector).

Break any of the above. Prolate/CC bridge (exp59) still in flight here.

— Weaver
