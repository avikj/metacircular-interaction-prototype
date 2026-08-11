# math

Research on the **prime pair field** $K(w,d)=a_{w-d}a_{w+d}$: an adversarial assessment of the framework, four theorems (marginal rigidity, aperture law, smoothing trivialization, sum-spectrum identity), and large-scale numerical verification against the first 100,000 Riemann zeros.

**Start here → [`notes/REPORT.md`](notes/REPORT.md)**

Highlights:

- **Homometric rigidity of the primes**: the set $\{p\le X\}$ is determined by its difference multiset up to reflection whenever the non-cyclotomic part of $\sum_{p\le X}x^{p-2}$ is irreducible — verified for all $X\le 2000$ (single sporadic cyclotomic factor $\Phi_6$ at $X=11$, provably harmless) and at degree 19,995.
- **Sum-spectrum of zeta zeros read off Goldbach data**: the second-order term of the smoothed Goldbach count is an exponential sum over pair sums $\gamma_i+\gamma_j$ with Beta-function weights — verified at correlation 0.9999, individual spectral lines to ~1% (`figures/exp6b_sumspectrum.png`).
- **Holomorphic/Hermitian dichotomy**: a precise formulation of why Goldbach averages are theorem-factories while gap statistics are conjecture-inputs.
- **Adelic block decomposition, numerically closed** ([`notes/BLOCKS.md`](notes/BLOCKS.md)): the BC/zero block split of the smoothed Goldbach count closes to $2\times10^{-13}$, with each spectral layer in exactly one block — BC block smooth, pole×zero block = single-zero layer (corr 1.0000), zero×zero block = pair layer (corr 0.9997).
- **The phase law of the pair weights (Theorem D‴)**: $W(\gamma,\gamma')=\sqrt{2\pi}\,s^{-5/2}e^{-i(sH(p)+5\pi/4)}$ with $s=\gamma+\gamma'$ and $H$ the binary entropy of the splitting $p=\gamma/s$ — modulus depends only on the sum, phase encodes the stationary point of the Goldbach constraint; verified to 0.3% / 0.005 rad. Consequence: the sum-spectrum measure is maximally non-positive, relocating the Krein/screw join to the Hermitian-square level.

Reproduce: `pip install numpy scipy sympy matplotlib python-flint`, then run `code/exp*.py` from `code/`.
