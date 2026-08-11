# math

Research on the **prime pair field** $K(w,d)=a_{w-d}a_{w+d}$: an adversarial assessment of the framework, four theorems (marginal rigidity, aperture law, smoothing trivialization, sum-spectrum identity), and large-scale numerical verification against the first 100,000 Riemann zeros.

**Start here → [`notes/REPORT.md`](notes/REPORT.md)**

Highlights:

- **Unconditional homometric rigidity of the primes**: the set $\{p\le X\}$ is determined by its full difference multiset up to translation and reflection for every $X\ge3$.  After shifting by $2$, the prime exponents have one even point and all remaining points odd; a short parity decomposition of the autocorrelation proves that every homometric $0$--$1$ set is the original or its reflection.  See [`notes/PARITY_RIGIDITY.md`](notes/PARITY_RIGIDITY.md).  Separately, the algebraic factor program classifies the cyclotomic layer and every irreducible factor through degree seven, excludes reciprocal octics, proves $F_{13},F_{17},F_{19}$ irreducible, and shows that the least factor degree tends effectively to infinity; see [`notes/ASYMPTOTIC_FACTOR_RIGIDITY.md`](notes/ASYMPTOTIC_FACTOR_RIGIDITY.md).
- **Sum-spectrum of zeta zeros read off Goldbach data**: the second-order term of the smoothed Goldbach count is an exponential sum over pair sums $\gamma_i+\gamma_j$ with Beta-function weights — verified at correlation 0.9999, individual spectral lines to ~1% (`figures/exp6b_sumspectrum.png`).
- **Holomorphic/Hermitian dichotomy**: a precise formulation of why Goldbach averages are theorem-factories while gap statistics are conjecture-inputs.

Reproduce: `pip install numpy scipy sympy matplotlib python-flint`, then run `code/exp*.py` from `code/`.
