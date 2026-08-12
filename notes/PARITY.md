# The parity barrier as a spectral sector, and an audit of the affine/adelic update

Companion to `REPORT.md`, `APPENDIX_D.md`, `ADELIC.md`. Two parts: (1) an audit of
the "critical affine arithmetic field" update, claim by claim, with verification
status and prior art; (2) the parity-sector formulation (the update's §L/§N
target), taken as far as current mathematics honestly allows, with a new
numerical demonstration.

---

## 1. Audit of the update

**A ($\beta=1$ forcing).** Derivation *correct* — and it is a known theorem with
this proof. Cuntz proved that $Q_{\mathbb N}$ admits a *unique* KMS state, at
$\beta=1$, for exactly this dynamics ($\sigma_t(s_n)=n^{it}s_n$, $u$ fixed); the
residue-partition + KMS argument is the standard one. The surrounding phase
diagram is Laca–Raeburn (Toeplitz algebra of $\mathbb N\rtimes\mathbb N^\times$:
KMS$_\beta$ simplices on $(0,1]$, uniqueness for $\beta\in[1,2]$, symmetry
breaking with cyclotomic Galois groups), and $Q_{\mathbb N}$ is the Crisp–Laca
boundary quotient of that system. The *interpretation* — "exact additive
translation + multiplicative KMS scaling forces criticality" — is legitimate
packaging of Cuntz's theorem, not a new result. Classify accordingly.

**B–E (Neshveyev measures, critical sieve field, weak-* convergence to
$m_{\widehat{\mathbb Z}^\times}$, Fourier coefficients $\mu(q)/\varphi(q)$).** All
verified (exp8 previously; the martingale moment identity
$\mathbb E[\mathcal G_z^r]=V(z)^{1-r}$ is a two-line computation). The weak-*
convergence proof via cylinder functions is correct. The Fourier coefficient of
Haar on $\widehat{\mathbb Z}^\times$ at a primitive $a/q$ being $\mu(q)/\varphi(q)$
is classical (Ramanujan). The "critical martingale" phenomenology
($\mathcal G_z\to0$ a.s., $\mathbb E\mathcal G_z=1$, $L^r$ blowup
$\sim(e^\gamma\log z)^{r-1}$) is real and correctly stated; note it is the
arithmetic cousin of a uniformly-integrable-failure at a phase transition, and
adjacent to (but simpler than) the multiplicative-chaos analogies studied for
$\zeta$ — worth keeping separate from novelty claims.

**F (sampling identity), G (stopped field).** Elementary and correct as stated;
$1_{\mathbb P}(n)=V(\sqrt n)\,\mathcal G_{\sqrt n}(\Delta n)$ checks for all
$n\ge2$ including the empty-product cases $n=2,3$. The geometric form of the
sampling obstruction ($M(z)=e^{(1+o(1))\sqrt X}$ vs $X$ samples) is a good
formulation of a familiar fact.

**H (crossover law).** *Verified numerically and now proved to my satisfaction.*
The local factor $L_{\beta,p}(H)=\frac{p-\nu_p}{p-1}(1-p^{-\beta})^{1-k}$ is
correct for the anchored ($0\in H$) normalization; the trichotomy
$(+\infty,\ \mathfrak S(H),\ 0)$ reproduces `ADELIC.md` Prop. E0 at $k=2$; and
the scaling limit
$$\frac{C_{\beta_z,z}(H)}{C_{1,z}(H)}\longrightarrow
\exp\Bigl[(k-1)\int_0^1\frac{e^{-\lambda u}-1}{u}du\Bigr]
=e^{-(k-1)\,\mathrm{Ein}(\lambda)}$$
follows from $\sum_{p\le z}p^{-1}(e^{-\lambda\log p/\log z}-1)\to
\int_0^1(e^{-\lambda u}-1)\frac{du}{u}$ (Mertens; the sum over $p\in(z^u,z^{u+du})$
contributes $du/u$). **Numerics (exp9):** at $z=10^3..10^6$ with Richardson
extrapolation in $1/\log z$, all eight $(k,\lambda)$ test cases land on the
prediction to 3–4 decimals (e.g. $k=2,\lambda=1$: extrapolated $0.45106$ vs
predicted $0.45086$; $k=3,\lambda=0.5$: $0.41177$ vs $0.41161$). Note
$\mathrm{Ein}(\lambda)=\gamma+\log\lambda+E_1(\lambda)$, so for large $\lambda$ the
crossover ratio behaves as $(e^{-\gamma}/\lambda)^{k-1}$ — a Mertens-type law in
the scaling variable, pleasingly. My searches (this session and previously)
found no β-deformed Hardy–Littlewood scaling law in the literature; it remains
the strongest *novelty candidate* of the program. Before claiming it: search
specifically in the sieve-theory weighted-density literature and in
Laca–Neshveyev-adjacent KMS papers.

**I (operator identity (L)).** Correct, and verified to $3.8\times10^{-10}$
(exp9: $q=5$, primitive quartic $\chi$, $s=2$, against Hurwitz-zeta-computed
$-\tau(\chi)L'/L(s,\bar\chi)$). As the update itself says: the ingredients
(additive twist, Gauss sums) are the classical major-arc computation; the
packaging — one additive operator $\mathcal P_s$ on the profinite line whose
eigenvalue field over the rational spectrum, resolved by multiplicative
characters shell-by-shell, assembles every abelian $L'/L$ — is clean and makes
the "why abelian GRH" point structurally. Consistent with Burnol's abelian-$L$
causality family being forced rather than imported.

**J (susceptibility resonances).** The Goldston–Suriajaya continuation and the
$s=\rho/2-1$ resonance poles are as cited; our exp9 partial-sum check of
$\sum_{h\le H}\mathfrak S(h)-H\approx-\tfrac12\log H+C$ is consistent (drift in the
constant at the last sieve-boundary point is a numerical artifact, flagged).
The reading "zeros = scaling resonances of the critical two-point function" is
correct and, in this repo's language, is the susceptibility-side face of the
Theorem D sum-spectrum.

**K (first/second variation).** This is exactly the block structure proved and
verified here as Theorems C/D (first variation = single-zero layer, second
variation = the $\gamma_i+\gamma_j$ layer at corr 0.9999). Agreed that the correct
next step is to identify the Matsumoto–Suzuki screw kernel as the
first-variation sector; `APPENDIX_D.md` §D.6(3) already poses the same join.

---

## 2. The parity sector: precise formulation, one theorem-let, one demonstration

The update's §L asks: *which spectral component is invisible to finite
divisibility statistics yet carries factorization parity?* Here is the honest
current answer.

### 2.1 Two spectral types

For $f:\mathbb N\to\mathbb C$ with bounded averages, define the rational
**spectral atoms**
$$m_f(a/q)=\lim_{X\to\infty}\Bigl|\frac1X\sum_{n\le X}f(n)e(an/q)\Bigr|^2$$
(when the limits exist) — the point masses of the Wiener–Bohr spectral measure
$\sigma_f$ of $f$ (the measure on $\mathbb T$ whose Fourier coefficients are the
autocorrelations of $f$).

**Theorem P (two spectral types; assembled from known results).**
1. *(Atoms of $\Lambda$.)* $m_\Lambda(a/q)=\mu(q)^2/\varphi(q)^2$ for every
   primitive $a/q$ (Siegel–Walfisz). Under the Hardy–Littlewood conjecture,
   these atoms exhaust $\sigma_{\Lambda-1}$: the spectral measure is **purely
   atomic**, supported on $\mathbb Q/\mathbb Z$, i.e.
   $\sigma_{\Lambda-1}=\sum_{q\ge2}\frac{\mu(q)^2}{\varphi(q)^2}
   \sum_{(a,q)=1}\delta_{a/q}$ — the Fourier transform of $\mathfrak S-1$, whose
   absolute convergence follows from $\sum_q\mu^2(q)\varphi(q)^{-2}\varphi((q,h))<\infty$.
   (This is the Gadiyar–Padma/Wiener–Khintchine reading, and equally the
   spectral face of the BC block.)
2. *(Atoms of Liouville.)* $m_\lambda(\alpha)=0$ for **every** $\alpha\in[0,1)$,
   unconditionally: $\sup_\alpha|\sum_{n\le X}\lambda(n)e(n\alpha)|\ll_A X\log^{-A}X$
   (Davenport). So $\sigma_\lambda$ is **atomless**, unconditionally.
3. *(Chowla = flatness.)* The Chowla conjecture is equivalent to
   $\sigma_\lambda=$ Lebesgue measure — $\lambda$ spectrally indistinguishable from
   a Bernoulli sequence. The ergodic-theoretic formalization is
   el Abdalaoui–Kułaga-Przymus–Lemańczyk–de la Rue (arXiv:1410.1673); see also
   Frantzikinakis ("Ergodicity of the Liouville system implies Chowla").

**Corollary (parity blindness of the BC block, exact form).** The conditional
expectation $E_Q$ onto the profinite diagonal (the $\Lambda^\sharp$ projector of
`ADELIC.md` §3, equivalently the atomic-spectrum sector) satisfies, unconditionally,
$$E_Q[\lambda]=0\quad\text{for every }Q,\qquad\text{while}\qquad
E_Q[\Lambda]\to\Lambda\ \text{in the conjectural (HL) spectral sense}.$$
Divisibility statistics see (conjecturally) *all* of $\Lambda$'s pair structure
and provably *none* of $\lambda$'s. The Friedlander–Iwaniec parity barrier —
sieves cannot distinguish even from odd numbers of prime factors without extra
input — is exactly the statement that **the atomic sector of the sampling
operator's spectral measure carries no information about the atomless sector.**
In the update's sampling identity (§F): the parity sector is the atomless
component; it contributes to no rational mode at any finite level, so no
refinement of the $\widehat F_{z,H}(r)$ expansion can see it. This converts the
methodological warning into a spectral-support statement, which was the §N
subgoal — with the caveat that the *hard* content (flatness, i.e. Chowla) is
not touched, only correctly located.

**Numerical demonstration (exp10, primes and Liouville to $2\cdot10^6$):**

| $a/q$ | $m_\Lambda$ measured | $\mu^2/\varphi^2$ | $m_\lambda$ measured |
|---|---|---|---|
| 1/1 | 1.00012 | 1 | 3.8e-07 |
| 1/2 | 1.00009 | 1 | 1.3e-06 |
| 1/3 | 0.25002 | 0.25 | 7.8e-07 |
| 1/4 | 0.00000 | 0 | 5.4e-07 |
| 1/6 | 0.25001 | 0.25 | 2.6e-06 |
| 2/5 | 0.06250 | 1/16 | 8.5e-07 |

Every $\Lambda$-atom matches Möbius–Euler exactly (including the *vanishing*
atom at $q=4$); every $\lambda$-atom is dead and falling
(`figures/exp10_parity.png`).

### 2.2 GNS formulation and what a genuinely new theorem would look like

In the Besicovitch GNS representation attached to an arithmetic function $f$,
additive translation $u$ acts unitarily and $\sigma_f$ is its spectral measure on
the cyclic vector. Theorem P then reads: the GNS representation of
$\Lambda-1$ is (conjecturally) **pure point with rational spectrum** — it factors
through the BC diagonal $C(\widehat{\mathbb Z})$ — while the GNS representation of
$\lambda$ is (provably) **weakly mixing** (no eigenvalues), conjecturally Lebesgue.
The parity barrier is the disjointness of these two representations; sieve
theory operates entirely in the first.

A new theorem here would have to couple the sectors through the
*multiplicative* structure — the atomless sector is not random noise, it is
$\lambda$, an exact multiplicative character of the factorization monoid. Two
concrete targets, in increasing ambition:
1. **Sector-coupling identity.** In the affine algebra, $\lambda$ generates a
   $\mathbb Z/2$ extension of the BC diagonal (grading by parity of $\Omega$).
   Compute the pair field of the *graded* algebra: the $(+,+)$ and $(-,-)$
   blocks reproduce sieve data, the off-diagonal block is precisely the parity
   sector. Question: does the KMS/criticality argument of §A extend to the
   graded system, and does it force any nontrivial constraint on the
   off-diagonal block? (If yes — that is a new theorem. If provably no — that
   is a sharp no-go theorem explaining parity as a KMS-invisible grading, also
   publishable.)
2. **Quantitative disjointness.** Prove any polynomial-rate quantitative form
   of $E_Q$-blindness: e.g. $\|E_Q[\lambda\cdot g]\|$ bounds for $g$ in the atomic
   sector, uniform in $Q$ up to $X^\varepsilon$ — this is a reformulation of
   Möbius orthogonality to limit-periodic functions, *known* qualitatively
   (and quantitatively at Siegel–Walfisz strength), whose uniformization in $Q$
   toward $\exp(\sqrt X)$ is exactly where the sampling-geometry obstruction
   of §F lives. The gap between $Q\le X^{O(1)}$ (known) and
   $Q\sim e^{\sqrt X}$ (needed for primality certification) is a clean way to
   *measure* the parity barrier's width.

### 2.3 Status

- Everything in §2.1 except the HL-conditional atomicity is unconditional and
  classical (Davenport; Siegel–Walfisz; ALKPR for the modern spectral frame).
  The contribution is the exact placement inside the affine/BC decomposition
  and the measured table.
- The §N target list is updated: items 1–3 are done or done-modulo-bookkeeping
  in this repo (`ADELIC.md` §3, exp6b, exp9); item 4 (screw kernel = first
  variation) is open and concrete; items 5–6 are absorbed into §2.2 above,
  which we propose as the sharpest available formulation of "identify the
  parity barrier as a spectral sector."
- **[Update (`LIOUVILLE.md`): the disjointness reading of this document is now
  dissolved. The parity sector is invisible at the finite places only: the
  archimedean explicit formula sees $\lambda$ at full strength through
  $\zeta(2s)/\zeta(s)$, and the Liouville pair field obeys an exact trace
  formula (Theorem H) — main term $\pi X^2/8\zeta(1/2)^2$, single- and
  pair-zero lines with weights $\zeta(2\rho)/\zeta'(\rho)$, all at scale $X^2$,
  verified at corr 0.9999–1.0000 (exp15_liouville). The parity barrier is a property of
  the place, not the function; Chowla is the Hermitian side of this same
  field.]**
