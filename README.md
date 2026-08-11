# math

Research on the **prime pair field** $K(w,d)=a_{w-d}a_{w+d}$: an adversarial assessment of the framework, four theorems (marginal rigidity, aperture law, smoothing trivialization, sum-spectrum identity), and large-scale numerical verification against the first 100,000 Riemann zeros.

**Start here → [`notes/REPORT.md`](notes/REPORT.md)**

Highlights:

- **Unconditional homometric rigidity of the primes**: the set $\{p\le X\}$ is determined by its full difference multiset up to translation and reflection for every $X\ge3$.  After shifting by $2$, the prime exponents have one even point and all remaining points odd; a short parity decomposition of the autocorrelation proves that every homometric $0$--$1$ set is the original or its reflection.  See [`notes/PARITY_RIGIDITY.md`](notes/PARITY_RIGIDITY.md).  Separately, the algebraic factor program classifies every irreducible factor through degree nine and excludes reciprocal degree-ten factors.  Hence for $X\ge13$ every factor has degree at least $10$, every reciprocal irreducible has degree at least $12$, and the unresolved degree-ten layer is purely nonreciprocal.  The least factor degree also tends effectively to infinity; see [`notes/FACTOR_ARCHITECTURE.md`](notes/FACTOR_ARCHITECTURE.md) and [`notes/ASYMPTOTIC_FACTOR_RIGIDITY.md`](notes/ASYMPTOTIC_FACTOR_RIGIDITY.md).
- **Exact algebraic ambiguity channel**: normalized spectral factors with the same autocorrelation form a product of integer chains, of exact size $M=\prod_j(m_j+1)$; reflection halves this fiber, while singleton parity leaves exactly one $0$--$1$ reflection class.  Thus algebraic ambiguity has an explicit zero-rate side code, but prime-set ambiguity modulo reflection is already zero.  See [`notes/ALGEBRAIC_ALLOCATION_CHANNEL.md`](notes/ALGEBRAIC_ALLOCATION_CHANNEL.md).
- **Sum-spectrum of zeta zeros read off Goldbach data**: the second-order term of the smoothed Goldbach count is an exponential sum over pair sums $\gamma_i+\gamma_j$ with Beta-function weights — verified at correlation 0.9999, individual spectral lines to ~1% (`figures/exp6b_sumspectrum.png`).
- **Holomorphic/Hermitian dichotomy**: a precise formulation of why Goldbach averages are theorem-factories while gap statistics are conjecture-inputs.

Reproduce: `pip install numpy scipy sympy matplotlib python-flint`, then run `code/exp*.py` from `code/`.
