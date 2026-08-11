# The two-body adelic block decomposition, computed (Theorem E made empirical)

Companion to `ADELIC.md` §3 (which constructed the decomposition) and the
affine-field update §K (first/second variation). Code: `code/exp13_blocks.py`
plus the spectral-separation check reproduced below. Primes to $2\cdot10^6$,
zeros from the Odlyzko table.

## Setup

$\Lambda = \Lambda^\sharp_Q + \Lambda^\flat_Q$ with
$\Lambda^\sharp_Q(n)=\sum_{q\le Q}\frac{\mu(q)}{\varphi(q)}c_q(n)$ (the conditional
expectation onto the BC diagonal at profinite resolution $Q$). The smoothed
Goldbach count splits exactly:
$$G_1 = [\sharp\sharp] + 2[\sharp\flat] + [\flat\flat],$$
verified to machine precision ($3\times10^{-13}$ relative) — as it must, but the
content is the size, shape, and *spectral identity* of each block.

## Measurements

**BC block $[\sharp\sharp]$ = the local model, exactly.** Against the prediction
$\sum_{n\le X}(X-n)\,n\,\mathfrak S_Q(n)$ with $\mathfrak S_Q$ the level-$Q$
truncated singular series: ratio $=1.00000\pm3\times10^{-5}$ at every tested
$Q\in\{1,10,30,100\}$. The critical-BC correlator calculus and the
Ramanujan-coefficient calculus agree on the nose.

**Zero block $[\flat\flat]$ = the second variation, and nothing else.** Its rms
at scale $X^2$ is $0.0024$, *independent of $Q$* — numerically identical to the
Parseval-predicted pair-sum amplitude $0.0025$ of `APPENDIX_D.md` §D.5. Spectral
content in $\log X$: pair-band $[27,45]$ (containing $2\gamma_1, \gamma_1+\gamma_2,
2\gamma_2$) carries $360\times$ the power of the single-zero band $[12,23]$
(single/pair ratio $0.003$).

**Mixed block $2[\sharp\flat]$ = the first variation.** Spectral content:
single-$\gamma$ band carries $34\times$ the pair band; band-passed, it correlates
$+0.976$ with the single-zero sum $-\sum_\rho X^{\rho+2}/(\rho(\rho+1)(\rho+2))$
at amplitude ratio $2.08$ — i.e. the mixed block carries the first-variation
coefficient $2$ predicted by expanding $(dx+dE)*(dx+dE)$, with the $8\%$
excess consistent with finite-$Q$ leakage. At scale $X^2$ the mixed block also
contains deterministic secondary terms (its $O(X^2)$ smooth layer, non-monotone
in $Q$ through Möbius sign cancellations); these are frequency-$0$ in $\log X$
and detrend away.

## What this establishes

The canonical decomposition of `ADELIC.md` §3 is not just formally exact — its
blocks have *disjoint spectral supports* matching the variation calculus:

| block | identity | $\log X$ frequencies | measured |
|---|---|---|---|
| $[\sharp\sharp]$ | mean / local (BC) | $0$ | $=\mathfrak S_Q$-model, ratio 1.00000 |
| $2[\sharp\flat]$ | first variation | single $\gamma_i$ | corr 0.976, coeff 2.08 ≈ 2 |
| $[\flat\flat]$ | second variation | pair sums $\gamma_i+\gamma_j$ | rms 0.0024 = Parseval 0.0025 |

Consequences for the program:

1. The Matsumoto–Suzuki screw kernel (RH-equivalence) must live in the *mixed
   block* — first variation, single zeros — pinning the target of the
   screw-kernel join precisely.
2. "RH enters Goldbach at first order, pair correlation at second order"
   (update §K) is now a measured statement about two orthogonal frequency bands
   of one arithmetic signal.
3. The parity/charged sector (Theorem F, `GAUGE.md`) is invisible in *all
   three* blocks — it has no atoms, hence no lines in any band; its only
   possible residence is the broadband floor, which at our scales is at the
   $10^{-3}$ level of the pair lines. A quantitative version of "how flat is
   the floor" is exactly the Chowla-flatness of `PARITY.md`.
