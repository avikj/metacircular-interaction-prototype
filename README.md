# math

Research on the **prime pair field** $K(w,d)=a_{w-d}a_{w+d}$: an adversarial assessment of the framework, four theorems (marginal rigidity, aperture law, smoothing trivialization, sum-spectrum identity), and large-scale numerical verification against the first 100,000 Riemann zeros.

**Start here → [`notes/REPORT.md`](notes/REPORT.md)**

Highlights:

- **Homometric rigidity of the primes**: the set $\{p\le X\}$ is determined by its difference multiset up to reflection whenever the non-cyclotomic part of $F_X=\sum_{p\le X}x^{p-2}$ is irreducible — verified through degree 49,997.  The cyclotomic layer is classified globally, every irreducible factor through degree seven is classified exactly, reciprocal octics are excluded, and $F_{13},F_{17},F_{19}$ are irreducible.  Asymptotically, the least factor degree tends effectively to infinity; every nonreciprocal factor, including the unique odd carrier, has degree $\gg\log_2X\log_4X/\log_3X$.  Consequently the number of normalized $0$--$1$ homometric candidates is $\exp(o(X))$.  See [`notes/ASYMPTOTIC_FACTOR_RIGIDITY.md`](notes/ASYMPTOTIC_FACTOR_RIGIDITY.md).
- **Sum-spectrum of zeta zeros read off Goldbach data**: the second-order term of the smoothed Goldbach count is an exponential sum over pair sums $\gamma_i+\gamma_j$ with Beta-function weights — verified at correlation 0.9999, individual spectral lines to ~1% (`figures/exp6b_sumspectrum.png`).
- **Holomorphic/Hermitian dichotomy**: a precise formulation of why Goldbach averages are theorem-factories while gap statistics are conjecture-inputs.

Reproduce: `pip install numpy scipy sympy matplotlib python-flint`, then run `code/exp*.py` from `code/`.
