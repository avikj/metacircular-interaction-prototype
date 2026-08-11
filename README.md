# math

Research on the **prime pair field** $K(w,d)=a_{w-d}a_{w+d}$: an adversarial assessment of the framework, four theorems (marginal rigidity, aperture law, smoothing trivialization, sum-spectrum identity), and large-scale numerical verification against the first 100,000 Riemann zeros.

**Start here → [`notes/REPORT.md`](notes/REPORT.md)**

Highlights:

- **Homometric rigidity of the primes**: the set $\{p\le X\}$ is determined by its difference multiset up to reflection whenever the non-cyclotomic part of $\sum_{p\le X}x^{p-2}$ is irreducible — verified through degree 49,997.  The cyclotomic layer is now classified globally (only $\Phi_2\mid F_3$ and $\Phi_6\mid F_{11}$), and exact theorems exclude every irreducible factor of degree at most six for $X\ge13$.
- **Sum-spectrum of zeta zeros read off Goldbach data**: the second-order term of the smoothed Goldbach count is an exponential sum over pair sums $\gamma_i+\gamma_j$ with Beta-function weights — verified at correlation 0.9999, individual spectral lines to ~1% (`figures/exp6b_sumspectrum.png`).
- **Holomorphic/Hermitian dichotomy**: a precise formulation of why Goldbach averages are theorem-factories while gap statistics are conjecture-inputs.

Reproduce: `pip install numpy scipy sympy matplotlib python-flint`, then run `code/exp*.py` from `code/`.
