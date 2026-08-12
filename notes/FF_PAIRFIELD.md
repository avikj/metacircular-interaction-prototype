# The function-field pair field: genus 0 and genus 1, exact — and what it de-centers

**Status: PENDING HOSTILE AUDIT.** Code: `code/exp60_ff_pairfield.py`; figure:
`figures/exp60_ff_pairfield.png`. Companions: `notes/FF.md` (the genus-0
within-shell theory — read first; nothing here contradicts it and its fences
are inherited), `notes/ATIYAH.md` §3 (the three-column dictionary this note
executes), `notes/DIVISOR.md` (the other solvable column), `notes/REPORT.md`
§5 and `notes/BLOCKS.md` §§0–2 (the ℚ-side structures being calibrated),
`notes/TERNARY.md` (calibration style), `notes/PROOF_DIFF_FF.md` (the
Sawin–Shusterman proof anatomy).

**Strategic point (why this lane exists).** In $\mathbf F_q[t]$ and for curves
over $\mathbf F_q$, RH is a theorem (genus 0: vacuously — the zeta has *no*
zeros; genus $\ge1$: Weil). Therefore RH exerts no pull here: **every
structure of the ℚ pair field that survives in the function-field column is
provably not about RH; every structure that degenerates here is flagged as
possibly RH-shadowed — or, as it turns out for most of them, as an artifact of
the archimedean place.** This note is the de-centering instrument, not a
contribution to function-field arithmetic: everything below is classical
(Gauss, Hasse, Weil, Herglotz) or elementary; the value claimed is the
calibration dictionary and its exact verification.

**What FF adds beyond the divisor model** (`DIVISOR.md`): the divisor column
is solvable because $d(n)$ is automorphic — its spectrum (Maass forms
$\kappa_j$) is infinite, non-arithmetic, and *about the spectral resolution
of a different operator*. The function-field column has a genuine
Frobenius/zero structure: at genus $g$ the zero side is a **finite, exactly
known** set $\{\alpha_1,\dots,\alpha_{2g}\}$ with $|\alpha_i|=\sqrt q$
proved. So the entire double-explicit-formula becomes a finite integer
identity checkable with **zero truncation error and no hypothesis** — the
only column where "Theorem D" can be closed exactly, layer by layer.

**Forecast** (registered pre-run in the exp60 header, per PROTOCOL §4):
(1) genus-0 exactness ($\pi_q$ = Gauss; $R^\Lambda_n=(n-1)q^n$); (2) genus-1
integer residual 0 at every $n\le40$ for three curves, with direct
point-enumeration matching the Lucas recursion; (3) supersingular pair-layer
rigidity; (4) Krein PSD for genuine curves, strongly indefinite for a
Hasse-violating fake; (5) nonzero wrong-curve residual at scale
$q^{n-1/2}$. **All five confirmed**; two structures found in the data were
*not* forecast (the exact smooth/oscillatory resolution of the mixed layer,
§2.3, and the node-collapse of the pair spectrum, §2.4 — the second
*corrects* the brief's expectation that the pair layer would display
$\{\alpha_i\alpha_j\}$).

**Designed annihilation** (msg 0073 norm): control A — wrong-Frobenius model
(E1 data against E2's zeros) must and does fail, residual
$/q^{n-1/2}=+0.9938$ at $n=20,30$; control B — fake Weil number $(a,q)=(5,5)$
violating $|a|\le2\sqrt q$ breaks the Krein form (min eig $-2.288\times10^8$
vs $-9.4\times10^{-15}$ genuine) *while passing the naive
integrality/positivity sieve at every depth $d\le40$*; control C — every
identity is an exact integer statement: residual $0$ or dead. Pramāṇa labels:
computations are pratyakṣa (script prints them); derivations are anumāna
(complete proofs below); literature is śabda checked against sources
(Sawin–Shusterman abstract re-fetched this session from arXiv and the Annals
page; theorem-level details cited via `FF.md`'s source-checked record).

---

## 1. Genus 0: $\mathbf F_q[t]$ — the pair field with empty spectrum

Gauss: $\pi_q(d)=\frac1d\sum_{e\mid d}\mu(e)\,q^{d/e}$ (verified against a
full irreducibility sieve, exactly, for $q=2,d\le12$; $q=3,d\le8$;
$q=5,d\le6$). Hence the $\Lambda$-weighted shell mass is exact:
$$\psi_q(n)\;=\;\sum_{\substack{P^k:\ k\deg P=n}}\deg P\;=\;\sum_{d\mid n}d\,\pi_q(d)\;=\;q^n$$
— the function-field PNT with **zero error**, equivalently
$-u\frac{d}{du}\log\frac1{1-qu} = \sum_n q^nu^n$: the zeta of $\mathbf A^1$
is $1/(1-qu)$, one pole, **no zeros**.

### 1.1 The FF Theorem D at genus 0 (empty spectrum)

$$\boxed{\;R^\Lambda_n\;:=\;\sum_{a+b=n,\ a,b\ge1}\psi_q(a)\,\psi_q(b)\;=\;(n-1)\,q^n\;}$$
*exactly*, for every $n\ge2$ — verified as an integer identity for
$q\in\{2,3,5\}$, $n\le40$, max residual $0$. This is Theorem D
(`REPORT.md` §5) with the zero layers deleted: main term only, **no
oscillation, no lower-order terms, no error term at all**. The unweighted
version $R_n=\sum_{a+b=n}\pi_q(a)\pi_q(b)$ has the exact closed form obtained
by substituting Gauss's formula (a double $\mu$-sum of pure $q$-powers with
rational coefficients); its deviation from the harmonic-sum main term
$\frac{2H_{n-1}}{n}q^n$ is combinatorial (prime powers), of size $O(q^{n-1})$,
measured $(R_n-\mathrm{lead})/q^{n-1}\in[-0.27,0]$ shrinking like $1/n$ —
**combinatorial, not oscillatory: there is nothing in the $n$-aspect for a
zero to write on.** (The $\Lambda$-vs-$\mathbf 1_P$ gap of `REPORT.md` §6 is
here an exact finite bookkeeping, not an analytic issue.)

### 1.2 "Genus 0 = the BC/local block alone" — with the FF.md fence

In the block language of `BLOCKS.md`: the degree-indexed genus-0 pair field
is the $[\sharp\sharp]$ block **identically** — $[\sharp\flat]$ and
$[\flat\flat]$ are empty because the spectrum is empty. The singular-series
analogue at this aggregation level is trivial (the density factors
$1/(a\,b)$ in $R_n$; two random monics of complementary degrees are
simultaneously irreducible with probability $\sim\frac1{a\,b}$ — no
arithmetic local factors appear until a *target* is fixed).

**Fence (inherited from `FF.md`, Theorem 1(4)):** this is a statement about
the *degree-aggregated* field only. Within a shell, the fixed-target counts
$C_n(A)$ carry genuinely nonzero pair fluctuations
($\sum_h|C_n(h)-q^n|^2 \ge \frac{q^n}{q^n-1}\Delta_n^2>0$) and the honest
singular series $\mathfrak S_q(A)$ of `FF.md` §3; those live in the
nontrivial additive characters of $V_n$, which the zero-free base zeta says
nothing about. "Empty spectrum" kills the $n$-aspect oscillation, not the
within-shell arithmetic.

### 1.3 Smoothing: the decision

The right smoothing at genus 0 (and genus 1) is **none**: the degree shell is
a finite exact sum. The $k$-fold Cesàro weight exists if wanted — with
$(n{-}m)_+ = h_{n-m-1}(1,1)$ (complete homogeneous symmetric polynomial),
$k$-fold smoothing in degree is exactly *appending $k$ nodes at $1$* to the
kernels of §2.4 — but it buys nothing, because there is no divergent tail to
tame. Verified exactly: $\sum_{a+b\le n}(n{-}a{-}b)\psi\psi =
\sum_{m=2}^n(n{-}m)(m{-}1)q^m$, integer identity, $n\le25$, all $q$.
**Diagnosis:** the entire smoothing apparatus of the ℚ column — Cesàro
orders, Beta kernels, the $k=0$ renormalization wall (`SHARP_CUTOFF.md`),
Theorem C's "the difficulty is a property of the cutoff" — is the cost of the
archimedean place. Theorem C said the sharp-cutoff difficulty is an artifact;
the FF column now exhibits a world where the artifact-generating mechanism
(a continuous value group at $\infty$) is absent and the difficulty with it.

### 1.4 Degree-shell homometry: rigidity dies, quantifiably

Theorem A′′ (`REPORT.md` §2.1) reconstructs every prime prefix from its
difference multiset, anchored by the *singleton parity class* (the prime 2).
In the degree variable over $\mathbf F_q[t]$ the analogous statement fails
maximally: the degree-pair data $R_n$ (all of it, all $n$) depends only on
the counts $\pi_q(d)$, so **every** choice of $\pi_q(d)$ monics per degree is
an indistinguishable impostor. Exactly:
$\prod_{d\le D}\binom{q^d}{\pi_q(d)}$ impostor sets share all degree-pair
data — $62{,}720$ already for $q=2$, degrees $\le4$; $186{,}486{,}300$ for
$q=3$, degrees $\le3$. Two structural reasons, both instructive: (i) shells
are thick — there is no singleton class to anchor on (the anchor mechanism of
`PARITY_RIGIDITY.md` is a $\mathbb Z$-specific accident: one even prime);
(ii) for $q=2$ the ambient group $V_n$ is elementary abelian 2-torsion, so
reflection $x\mapsto-x$ is the *identity* — even the universal
translation/reflection kernel of Theorem A degenerates. The honest open
remnant: within-shell rigidity (does $\{P-Q\}$ as a multiset in $V_n$
determine the set of degree-$n$ irreducibles up to the obvious symmetries?)
— untested here, and the ℚ proof mechanism does not transfer.

---

## 2. Genus 1: the exact Theorem D with a finite, known spectrum

### 2.1 Setup, with the place at infinity explicit

Let $E/\mathbf F_q$ be an elliptic curve $y^2=x^3+Ax+B$ ($p>3$),
$Z_E(u)=\frac{P(u)}{(1-u)(1-qu)}$, $P(u)=1-au+qu^2=(1-\alpha u)(1-\bar\alpha
u)$, $a=q+1-\#E(\mathbf F_q)$, $|\alpha|=\sqrt q$ (Weil). The affine
coordinate ring $A=\mathbf F_q[x,y]/(E)$ is Dedekind; it omits exactly one
place — the rational point at infinity, degree 1 — so
$$\zeta_A(u)\;=\;(1-u)\,Z_E(u)\;=\;\frac{(1-\alpha u)(1-\bar\alpha u)}{1-qu}:$$
one pole ($u=1/q$), **two zeros** ($u=1/\alpha,1/\bar\alpha$). Logarithmic
derivative: the $\Lambda$-shell mass of $A$ is
$$\Psi_A(m)\;=\;q^m-s_m,\qquad s_m:=\alpha^m+\bar\alpha^m,\quad
s_m=a\,s_{m-1}-q\,s_{m-2},\ s_0=2,\ s_1=a,$$
and $\Psi_A(m)=\#E(\mathbf F_{q^m})-1$ = the number of affine points; primes
of $A$ of degree $d$ are the size-$d$ Galois orbits of affine points.
Curves used, **Weil input verified by direct enumeration over
$\mathbf F_{q^m}$** (squares table in $\mathbf F_p[x]/(g)$, $g$ irreducible —
found and certified by the same Rabin test as §1):

| curve | $\#E(\mathbf F_q)$ | $a$ | direct counts $=q^m-s_m$ | closed points $b_d\ge0$ integral |
|---|---|---|---|---|
| E1: $y^2=x^3+x+1/\mathbf F_5$ | 9 | $-3$ | exact, $m\le6$ (…, 15551) | $d\le40$ ✓; $b_{1..6}=8,9,33,162,612,2571$ |
| E2: $y^2=x^3+1/\mathbf F_5$ (**supersingular**) | 6 | $0$ | exact, $m\le6$ | ✓; $5,15,40,135,624,2620$ |
| E3: $y^2=x^3+x+3/\mathbf F_7$ | 6 | $2$ | exact, $m\le5$ | ✓; $5,27,124,585,3312,19458$ |

### 2.2 The exact three-layer identity (FF Theorem D, genus 1)

For $R^\Lambda_{A,n}=\sum_{a'+b'=n}\Psi_A(a')\Psi_A(b')$, expanding
$(q^{a'}-s_{a'})(q^{b'}-s_{b'})$ and summing geometric/Lucas sums:
$$\boxed{\;R^\Lambda_{A,n}\;=\;\underbrace{(n-1)\,q^n}_{\text{pole}\times\text{pole}}
\;\underbrace{-\,2\,T_n}_{\text{pole}\times\text{zero, coeff. exactly }2}
\;+\;\underbrace{(n-1)\,s_n\;+\;2q\,U_{n-2}}_{\text{zero}\times\text{zero}}\;}$$
with $T_n=\sum_{i=1}^{n-1}q^i s_{n-i}$ and $U_m=(\alpha^{m+1}-\bar\alpha^{m+1})/(\alpha-\bar\alpha)$
(second Lucas sequence). **Verified: integer residual exactly $0$ at every
$2\le n\le40$ for all three curves.** The closed form
$\sum_i q^i\alpha^{n-i}=q\alpha\frac{q^{n-1}-\alpha^{n-1}}{q-\alpha}$ was
independently verified by exact arithmetic in $\mathbb Z[\alpha]$
($\alpha^2=a\alpha-q$), including the exact divisibility by the norm
$(q-\alpha)(q-\bar\alpha)=q\,(q+1-a)=q\cdot\#E(\mathbf F_q)$ — the
pole×zero denominator is a **special value** ($P(1)\cdot q$ up to
normalization), the FF avatar of the $\rho(\rho+1)(\rho+2)$ denominators.
The coefficient **2** on the mixed layer is the FF incarnation of the
coefficient-2 Lemma (`BLOCKS.md` §0) — here exact by symmetry of a finite
sum, i.e. that lemma's content is combinatorial placement, not analysis.

Honesty fence: *given* $\Psi_A(m)=q^m-s_m$, the identity is bilinear
bookkeeping; the arithmetic input is Weil's theorem, which is what the direct
point counts check. The non-obvious content is in the two resolutions below.

### 2.3 The mixed layer resolved: smooth secondary term + single-zero lines

Un-forecast finding #1. The pole×zero layer is *not* purely oscillatory:
$$\boxed{\;T_n\;=\;\frac{(a-2)\,q^n\;+\;q\,(s_{n-1}-s_n)}{N_1},\qquad
N_1=\#E(\mathbf F_q)=q+1-a\;}$$
(exact integer identity, verified at every $n\le40$, all curves). So the
mixed block = a **smooth secondary term** $-2\frac{a-2}{N_1}q^n$ (frequency
0, at the *pole* scale $q^n$) plus the **single-zero oscillation**
$\frac{2q}{N_1}(s_n-s_{n-1})$ at scale $q^{n/2}$ — exactly the structure
`BLOCKS.md` §0 measured for the ℚ mixed block ("deterministic secondary
terms… plus the single-zero layer"). Measured at $n=20$ (E1):
smooth$/$main $=5.85\times10^{-2}$, single-osc$/$main $=1.17\times10^{-8}$,
pair$/$main $=1.13\times10^{-7}$.

Two exact corollaries. (i) **The smooth part has an explicit zero at
$a=2$:** curves with $\#E(\mathbf F_q)=q-1$ have a *purely oscillatory*
mixed block — E3 realizes this (measured smooth $=0$ exactly). The ℚ
column's smooth secondary layer is thus not structural: its coefficient is a
rational function of the zeros that can vanish. (ii) **Layer ordering
inverts:** over ℚ, single ($X^{5/2}$) dominates pair ($X^2$); here
single-osc ($\sim2q^{n/2+1}\!/N_1$, bounded coefficient) is *dominated* by
pair ($\sim n\,q^{n/2}$) for $n$ large — see §2.4 for why the ℚ ordering is
an archimedean bulk effect.

### 2.4 The pair layer: node collapse — the sum spectrum is archimedean

Un-forecast finding #2, and the sharpest de-centering result of this note.
The brief expected the pair layer to display the multiplicative sum spectrum
$\{\alpha_i\alpha_j\}$. It does not, and the correction is a one-line
theorem. All shell kernels are complete homogeneous symmetric polynomials:
$$\sum_{a'+b'=n,\ a',b'\ge1}\alpha_i^{a'}\alpha_j^{b'}
=\alpha_i\alpha_j\,h_{n-2}(\alpha_i,\alpha_j),\qquad
h_m(x,y)=\frac{x^{m+1}-y^{m+1}}{x-y},$$
and $k$-fold Cesàro smoothing appends $k$ nodes at $1$:
$\alpha_i\alpha_j\,h_{n-2-k}(\alpha_i,\alpha_j,1,\dots,1)$ (cf. §1.3).

**Lemma (node collapse).** For distinct nodes,
$\alpha_i\alpha_j h_{n-2}(\alpha_i,\alpha_j)
=\frac{\alpha_j}{\alpha_i-\alpha_j}\alpha_i^{\,n}
-\frac{\alpha_i}{\alpha_i-\alpha_j}\alpha_j^{\,n}$ — a linear combination of
$\alpha_i^n$ and $\alpha_j^n$ with **$n$-independent coefficients**; for
coincident nodes it is $(n-1)\alpha_i^n$. Hence the entire pair layer is
supported, in the $n$-aspect, on the **node frequencies** $\{2\theta_i\}$
($\alpha_i^n=q^{n/2}e^{in\theta_i}$; in the variable $\log X\leftrightarrow
\frac n2\log q$ these are the *diagonal* sum frequencies
$\theta_i+\theta_i$), with the diagonal terms carrying the $(n-1)$-enhanced
weight. **Off-diagonal sum frequencies $\theta_i+\theta_j$, $i\ne j$, do not
occur.** At genus 1 this is visible exactly: the conjugate-pair block
$(\alpha,\bar\alpha)$, which over ℚ would sit at frequency
$\theta+(-\theta)=0$, contributes $2qU_{n-2}$ — lines at $\pm2\theta$, no
frequency-0 oscillation at all; and no smoothing can restore the sum
frequencies, since the partial-fraction nodes are unchanged by appending
nodes at 1.

A further consequence, worth its own sentence because it degrades a
*verified* ℚ theorem: at genus 1 every zero-layer oscillation — the
single-zero term $s_n-s_{n-1}$, the pair diagonal $(n-1)s_n$, and
$2qU_{n-2}$ — is generated by the same two lines $e^{\pm in\theta}$. So the
ℚ block spectral-support theorem (E2, `BLOCKS.md` §1: single band
$\{\gamma_i\}$ disjoint from pair band $\{\gamma_i+\gamma_j\}$) has **no
genus-1 analogue**: the layers are separated by their polynomial-in-$n$
envelopes (constant vs $(n-1)$-growth) and by the pole-scale/zero-scale
split, not by frequency bands. Band-disjointness is downstream of the
archimedean sum-frequency mechanism.

Why the ℚ column differs: the Beta kernel
$\iint u^{\rho-1}v^{\rho'-1}(X-u-v)\,du\,dv = W\,X^{\rho+\rho'+1}$ is
**exactly homogeneous** — a property of the continuous dilation group
$\mathbb R_+$ at the archimedean place. Homogeneity is what adds exponents
and creates the frequency $\gamma_i+\gamma_j$; its stationary interior split
$m^*=pX$ is what creates the D‴ entropy phase $-sH(p)$ (`BLOCKS.md` §2, item
2). Over $\mathbf F_q[t]$ the value group at $\infty$ is $q^{\mathbb Z}$:
no continuous dilation, no interior stationary point, and the discrete
kernel partial-fractions onto its nodes — the pair correlations are carried
by the *boundary corners* (one factor of bounded degree paired with one of
degree $\approx n$), not by the bulk of balanced splits. Consequently:

- **Theorem D's line positions $\{\gamma_i+\gamma_j\}$ are archimedean**
  (bulk homogeneity), *not* universal explicit-formula structure.
- **What is universal:** the layer/block separation by *scale*
  ($q^n$ vs $q^{n/2}$, i.e. pole vs zero moduli — RH pins the pair-layer
  amplitude to exactly $q^{n/2}=|\alpha_i\alpha_j|^{n/2}$), the coefficient-2
  mixed block, the smooth-secondary phenomenon, and the **diagonal
  enhancement** — the $(n-1)$-weight on $i=j$ is the FF remnant of the
  additive-energy diagonal that dominates Theorem D″'s variance
  (`BLOCKS.md` §3). The diagonal dominance is universal; the off-diagonal
  near-collision bookkeeping (Tao–Trudgian–Yang $N^*$) is archimedean
  dressing.
- The D‴ **modulus law** $\sqrt{2\pi}s^{-5/2}$ and **entropy phase**
  $-sH(p)-\frac{5\pi}4$ are Stirling asymptotics of the archimedean kernel:
  here the weights are the exact node coefficients
  $\alpha_j/(\alpha_i-\alpha_j)$, with denominators that are node
  separations — $(\alpha_i-\alpha_j)$, $(\alpha-1)^k$ (smoothing nodes),
  $(q-\alpha)$ (pole node, norm $q\cdot\#E$) — the FF form of the
  $\Gamma$-pole denominators; no decay law is needed because the spectrum is
  finite. The **Fresnel chirp** $(\gamma-\gamma')^2/2f$ (`FRESNEL.md`),
  being the curvature of the entropy phase at its stationary point, has no
  FF analogue: all phases here are exactly linear in $n$ — Fraunhofer, not
  Fresnel. Likewise the **opposite-sign exponential suppression**
  $e^{-\pi\min(|\gamma|,|\gamma'|)}$ of D′ is a $\Gamma$-artifact: the
  conjugate block enters at full $q^{n/2}$ scale, unsuppressed.

### 2.5 Supersingular rigidity (the extreme case)

E2 has $a=0$, $\alpha=i\sqrt q$: the spectrum collapses to the single angle
$\theta=\pi/2$. Exact and verified at every $n\le40$: the pair layer
vanishes identically on odd shells and equals $2(n-2)(-q)^{n/2}$ on even
shells — maximal coherence, period-2 sign alternation, the FF endpoint of
"zero-spectrum rigidity" with everything exactly known. This is the
degenerate control for §2.4's frequency statements: with one angle, node
frequencies and diagonal sum frequencies coincide, and the layer is a single
alternating line.

---

## 3. Krein/screw positivity: unconditional, and exactly the RH-carrying joint

The FF screw object is the normalized error sequence
$c_m := s_m/q^{m/2} = 2\cos(m\theta)$. **Weil RH for $E$ $\iff$ $c$ is a
positive-definite sequence** ($c_m=\int e^{im\vartheta}d\mu$,
$\mu=\delta_\theta+\delta_{-\theta}\ge0$; Herglotz/Carathéodory–Toeplitz).
Verified: the $40\times40$ Toeplitz matrix $[c_{|i-j|}]$ has min eigenvalue
$-9.4\times10^{-15}$ (E1), $-7.6\times10^{-15}$ (E2), $-1.6\times10^{-14}$
(E3) — PSD to machine precision, rank 2 as it must be. Controls:
the fake Weil number $(a,q)=(5,5)$ ($|a|>2\sqrt q$; no such curve exists)
gives min eigenvalue $-2.288\times10^{8}$; and — the honest surprise — **the
fake passes the closed-point integrality/positivity sieve at every
$d\le40$**: naive counting consistency does not detect the RH violation at
this depth; the Krein form does, instantly. This is the cleanest possible
instance of the corpus's verdict (`BLOCKS.md` §2.1, `WEIL.md`): *positivity
is a Hermitian-square phenomenon and it is exactly where RH lives.* On the ℚ
side the same object (Weil positivity / screw functions) **is** RH; on the
FF side it is a theorem — so this row of the dictionary, and essentially
only this row, is correctly flagged "about RH". Note also: the
amplitude-level pair measure with node weights (§2.4) is complex with
linear phases — not positive, echoing `BLOCKS.md` §2.1's "maximally
non-positive amplitude measure" verdict, but *without* the chirp mechanism:
non-positivity of the amplitude layer is universal; the chirp is archimedean.

---

## 4. The de-centering table

| structure (ℚ column) | survives in $\mathbf F_q[t]$/curves? | verdict |
|---|---|---|
| block decomposition $[\sharp\sharp]/[\sharp\flat]/[\flat\flat]$ (`BLOCKS.md`) | YES — exact; genus 0 is $[\sharp\sharp]$ alone (§1.2), genus 1 has all three with integer residual 0 (§2.2) | **not about RH** |
| pole-scale/zero-scale layer separation; coefficient-2 mixed block | YES — exact; pole content at $q^n$, zero content at $q^{n/2}$; coefficient 2 combinatorial (§2.2) | **not about RH** |
| band-disjointness of single vs pair layers (Thm E2 frequency attribution) | NO at genus 1 — all zero layers share the lines $e^{\pm in\theta}$; separation only by $n$-envelope (§2.4) | **archimedean artifact** (downstream of sum frequencies) |
| mixed block = smooth secondary + single-zero lines (`BLOCKS.md` §0/E2) | YES — exact closed form, denominator $=q\cdot\#E$; smooth part can vanish ($a=2$) (§2.3) | **not about RH** |
| sum-spectrum line positions $\{\gamma_i+\gamma_j\}$ (Thm D/exp6b) | NO — collapses to node frequencies $\{2\theta_i\}$; off-diagonal sum lines absent (§2.4) | **archimedean artifact** (bulk homogeneity) |
| additive-energy *diagonal* dominance (Thm D″) | YES — the $(n-1)$-enhanced diagonal is the only growing pair weight (§2.4) | **not about RH** |
| D‴ modulus law $\sqrt{2\pi}s^{-5/2}$ | NO — replaced by finite node coefficients; no decay needed | **archimedean artifact** (Stirling) |
| D‴ entropy phase $-sH(p)$; stationary split $m^*=pX$ | NO — no interior stationary point; phases linear in $n$ | **archimedean artifact** |
| Fresnel/Cornu chirp $(\gamma-\gamma')^2/2f$ (`FRESNEL.md`) | NO — no quadratic phase anywhere; "Fraunhofer, not Fresnel" | **archimedean artifact** |
| opposite-sign pair suppression $e^{-\pi\min}$ (D′) | NO — conjugate block at full $q^{n/2}$ scale | **archimedean ($\Gamma$) artifact** |
| sharp-cutoff difficulty / smoothing apparatus (Thm C, `SHARP_CUTOFF.md`) | moot — degree shells exact, smoothing = optional nodes at 1 (§1.3) | **archimedean artifact** |
| singular series / local block | YES — within-shell $\mathfrak S_q(A)$ (`FF.md` §3); degree level: pure density | **not about RH** |
| parity barrier | **FALLS** — Sawin–Shusterman (§5), fixed odd $q>685090\,p^2$, via derivative/Pellet + auxiliary sheaf cohomology, *not* base-zeta zeros | not RH-shadowed; auxiliary-cohomology-shadowed (`PROOF_DIFF_FF.md`) |
| homometric rigidity of prefixes (Thm A′′) | NO at degree level — $\prod_d\binom{q^d}{\pi_q(d)}$ impostors (62,720 at $q=2,D\le4$); anchor mechanism (singleton parity) has no analogue; char 2 kills reflection (§1.4) | **$\mathbb Z$-specific** (order + parity accident); within-shell version open |
| Krein/screw/Weil positivity | YES and unconditionally TRUE; fake Weil number breaks it while passing integrality (§3) | **this is where RH lives** — correctly flagged |
| zero-statistics calibration (Poisson sums/GUE gaps) | untestable at genus 1 (2 zeros); needs growing genus (Katz–Sarnak regime) | out of scope here — honest gap |

**The invisible attractor, named.** The ℚ-side structures that *felt* most
spectral — the sum-frequency line spectrum, the $5/2$ modulus law, the
entropy phase, the Fresnel chirp, the opposite-sign suppression, the
smoothing hierarchy — are all products of one object: the continuous
dilation group of the archimedean place (Mellin homogeneity + Stirling
asymptotics of its $\Gamma$-kernels). The structures that looked like
bookkeeping — block decomposition, coefficient 2, scale separation, smooth
secondary terms, diagonal dominance, Hermitian-square positivity — are the
universal arithmetic, surviving verbatim in a world with a discrete place at
infinity. The pair field's "physics" was archimedean optics; its
"accounting" was the arithmetic.

---

## 5. Sawin–Shusterman, cited precisely

Fetched this session (arXiv:1808.04001 abstract page and the Annals page,
Annals of Mathematics **196** (2022), no. 2, 457–506,
doi:10.4007/annals.2022.196.2.1), abstract verbatim in relevant part:
"…we obtain a level of distribution close to 1 for the Möbius function in
arithmetic progressions and resolve Chowla's $k$-point correlation
conjecture with large uniformity in the shifts. … we obtain a level of
distribution beyond $1/2$ for irreducible polynomials, and establish the
twin prime conjecture in a quantitative form. All these results hold for
finite fields satisfying a simple condition." The "simple condition", per
`FF.md`'s source-checked record (śabda, checked there): $q$ odd,
$q>685090\,p^2$; Theorem 1.1 = the twin-prime count
$\#\{f\in\mathcal M_n: f,f+A\text{ irreducible}\}\sim\mathfrak
S_q(A)q^n/n^2$ for every fixed nonzero $A$; Theorem 6.3 = the
$\Lambda$-weighted correlation with power saving; Remark 1.2 = the
Goldbach/linear-forms extension. All fences of `FF.md` §§2–4 apply verbatim
(infinity-type/leading-coefficient conventions; Bender–Pollack is the
large-$q$-vs-$n$ regime; Effinger–Hayes is ternary). Their mechanism
consumes Deligne purity on *auxiliary, growing-dimensional* sheaves plus
hard vanishing/Betti bounds — not the (zero-free!) base zeta
(`FF.md` §3, `PROOF_DIFF_FF.md`). So the FF parity breakthrough neither
used nor needed the pair field's zero side: further evidence that the
charge/parity layer and the zero layer are separate theaters.

---

## 6. What the FF side asks ℚ

1. **(Sharpest.) Boundary/bulk decomposition of Theorem D.** Over FF the
   pair correlations are carried entirely by boundary corners (one factor of
   bounded degree) at node frequencies, with $n$-independent weights; over ℚ
   the verified exp6b lines sit at bulk sum frequencies with entropy phases.
   Both are exact in their worlds. Q: split the ℚ Beta kernel into a
   boundary part (Euler–Maclaurin corners — the FF shadow) and a bulk part
   (stationary-phase — purely archimedean), and determine which part carries
   the RH-equivalent content of Theorem C/D″. The FF calculus predicts: the
   amplitude scale and the diagonal — not the off-diagonal line positions —
   are the load-bearing data. A concrete first test: reprove Theorem C using
   only corner data, or exhibit an RH-equivalent functional of $G_1$ that is
   blind to the off-diagonal lines.
2. **$q\to1$ degeneration.** The node kernel
   $\alpha\beta\,h_{n-2-k}(\alpha,\beta,1^k)$ must degenerate to
   $\Gamma(\rho)\Gamma(\rho')/\Gamma(\rho+\rho'+k+1)X^{\rho+\rho'+k}$ as the
   value group $q^{\mathbb Z}\to\mathbb R_+$ ($\alpha=q^{1/2}e^{i\theta}$,
   $n\log q\to\log X$ with $\theta/\log q$ fixed). Make this quantitative:
   at which step do the sum frequencies and the entropy phase emerge? (This
   is where the archimedean artifact is *manufactured*, term by term.)
3. **Within-shell homometry.** Is the set of degree-$n$ irreducibles in
   $V_n$ determined by its difference multiset (q odd; and separately in
   char 2, where reflection is trivial)? The ℚ anchor (singleton parity) is
   unavailable; a genuinely new mechanism or a counterexample would both be
   informative — `FF.md`'s Fourier identities give the natural attack
   surface.
4. **Growing genus.** The node-collapse lemma is proved for any node set,
   so a genus-2 verification is not needed for §2.4; what growing genus
   *would* add is the Katz–Sarnak statistics of the node set itself — the
   FF calibration of Experiment 5's "sums are Poisson" — and the first
   nontrivial test of which zero-statistics claims survive when the
   spectrum is finite but large.

---

## 7. Reproduction

`code/exp60_ff_pairfield.py` (7 s, pure Python + numpy for one eigenvalue
test; all arithmetic identities in exact integers): genus-0 sieve vs Gauss
(exact, 3 fields), $R^\Lambda_n=(n-1)q^n$ (residual 0, $n\le40$), Cesàro
closed form (exact), impostor counts; genus-1 direct point counts vs Lucas
(exact, $m\le6/6/5$), three-layer identity (integer residual 0, $n\le40$,
3 curves), $\mathbb Z[\alpha]$ closed forms with norm divisibility (exact),
mixed-layer resolution (exact), supersingular rigidity (exact), wrong-curve
control (nonzero, $+0.9938\,q^{n-1/2}$), Krein test (PSD $-9\times10^{-15}$
vs fake $-2.3\times10^8$), fake-integrality honesty check.
Figure: `figures/exp60_ff_pairfield.png` (E1 layer hierarchy; Krein spectra
genuine vs fake).
