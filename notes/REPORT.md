# The Prime Pair Field: an adversarial assessment, four theorems, and what is actually deep

**Branch:** `claude/prime-pair-field-research-18tq7b` · **Data:** first 100,000 Riemann zeros (Odlyzko), primes/Λ to 4·10⁶ · **Code:** `code/exp*.py`

---

## 0. Executive summary

We pressure-tested the "prime pair field" framework

$$K(w,d) = a_{w-d}\,a_{w+d},\qquad u=w-d,\ v=w+d,\ uv=w^2-d^2,$$

with $a_n \in \{\mathbf 1_P(n), \Lambda(n)\}$, and its heat-resolved transform
$Z(t,\theta) = P(t+i\theta)P(t-i\theta)$, $P(z)=\sum_n a_n e^{-nz}$.

**What collapses** (Section 1): the field is the rank-one tensor $a\otimes a$ read in rotated coordinates; every displayed identity ($Z = P\bar P \ge 0$, $S^2-D^2=4Q$) holds for *arbitrary* sequences and carries zero arithmetic content. The "Lorentzian" structure has trivial arithmetic symmetry: $SO(1,1)(\mathbb Z) = \{\pm 1\}$ (Lemma 1.3). Bost–Connes and relational-physics framings reduce, on inspection, to functional calculus on this rank-one object. Automatic positivity of $Z$ contributes nothing to Goldbach: the circle-method minor-arc obstruction (beating Parseval by one factor of $\log$) is untouched.

**What survives, sharpened into theorems** (Sections 2–5):

- **Theorem A (Marginal Rigidity).** The sum marginal (Goldbach data) determines a nonnegative sequence *uniquely* — no phase problem, by a square-root argument. The difference marginal (gap data) has a genuine kernel — the crystallographic homometry classes (minimal 0-1 example: $\{0,1,2,6,8,11\}\sim\{0,1,6,7,9,11\}$, found by exhaustive search). Heat resolution restores completeness for both. So the original "gaps lose phase" intuition is right at multiset level, and its correction is right at resolved level; both are now precise.
- **Theorem A′′ (Unconditional homometric rigidity of the primes).** Every finite prime prefix is determined by its full difference multiset up to translation and reflection.  The proof is elementary: after shifting by $2$, there is one even exponent and all remaining exponents are odd; equality of autocorrelations preserves the two parity-class sizes, and separating the odd and even Laurent coefficients forces any partner to be the original or its reversal (`PARITY_RIGIDITY`).  No irreducibility hypothesis is needed.  Separately, the polynomial-factor program classifies every cyclotomic factor and every irreducible factor through degree seven, excludes reciprocal octics, proves $F_{13},F_{17},F_{19}$ irreducible, and proves effective divergence of the least factor degree (`ASYMPTOTIC_FACTOR_RIGIDITY`).
- **Theorem B (Aperture Law).** In the zero-pair expansion of $Z$, the radial coordinate $\log|z|$ is conjugate to $\gamma+\gamma'$ and the angular coordinate $\arg z$ to $\gamma-\gamma'$; and the phase aperture $\theta$ opens the zero spectrum at rate $\gamma_{\max}\approx(\theta/t)\log(1/\varepsilon)$. Verified: predicted constant $\log(10^6)=13.8$; measured 12.2–14.6.
- **Theorem C (Smoothing trivialization).** With heat smoothing, "average Goldbach ⟺ RH" is an *algebraic* equivalence (square-root injectivity — the analytic avatar of Theorem A(i)): RH $\iff \sum_N R_\Lambda(N)e^{-Nt} = (1/t - \log 2\pi)^2 + O(t^{-3/2-\varepsilon})$ for every $\varepsilon>0$. The celebrated difficulty in the sharp-cutoff literature (Granville; Bhowmik–Schlage-Puchta) is an artifact of the cutoff, not of the arithmetic.
- **Theorem D (Sum-spectrum identity, verified to 10⁻³).** The second-order term of the smoothed Goldbach count $G_1(X)=\sum_{m+n\le X}\Lambda(m)\Lambda(n)(X-m-n)$ is an exponential sum over **pairs of zeros at frequencies $\gamma_i+\gamma_j$** with Beta-function weights $\Gamma(\rho)\Gamma(\rho')/\Gamma(\rho+\rho'+2)$, with same-sign weight decay $\asymp(\gamma+\gamma')^{-5/2}$ (measured exponent: $-2.500$) and exponential suppression of opposite-sign pairs. Numerics: band correlation **0.9999**, amplitude ratio **0.9991**, individual spectral lines at $2\gamma_1, \gamma_1+\gamma_2, 2\gamma_2, \gamma_1+\gamma_3$ correct to 0.2–1.1%. The identity is Languasco–Zaccagnini's ($k=1$ Cesàro); the spectral-line reading, the weight law, and (to our knowledge) the numerical verification are new.

**The synthesis** (Section 6) — the *holomorphic/Hermitian dichotomy*, which we believe is the real content the framework was groping toward:

> The sum marginal is a **holomorphic square** $P(z)^2$; the difference marginal is a **Hermitian square** $|P(z)|^2$. Holomorphic squares of the explicit formula expand exactly — so Goldbach averages are *outputs* of the zero spectrum, needing only zero *locations*. Hermitian squares evaluated at fixed frequency pair a zero against a conjugate zero — so gap statistics are *inputs*: they require knowledge of zero *correlations* that RH does not provide. This yields a strict "depth staircase":
>
> | statistic | needs |
> |---|---|
> | Goldbach mean | zero locations (exact formula — Thm D) |
> | gap mean (fixed $h$) | pair correlation of zeros ($\gamma-\gamma'$) |
> | Goldbach variance | additive energy of zeros ($\gamma_1+\gamma_2 \approx \gamma_3+\gamma_4$) |
> | gap variance | 4-point correlations |
>
> and its mirror in pure zero statistics (Experiment 5): zero *differences* are GUE-rigid; zero *sums* are Poisson (spacing var/mean² = 1.001). Each side of arithmetic carries its structure in the coordinate transverse to the other.

Section 7 assesses the genuinely deep neighboring structures (divisor-model solvability via GL(2) spectral theory; Weil positivity; Matsumoto–Suzuki screw functions) and Section 8 states three concrete open problems this work generates.

---

## 1. The triviality boundary

Everything in this section is deflationary and fully proved. It marks the line below which the framework has no content, so that everything above the line can be trusted.

**Proposition 1.1 (Genericity).** For any $a:\mathbb N\to\mathbb C$: (i) $K = a\otimes a$ under $(u,v)\mapsto(w,d)$; as a matrix in $(w,d)$ it is the Hadamard product of the Toeplitz matrix $T_{w,d}=a_{w-d}$ and the Hankel matrix $H_{w,d}=a_{w+d}$ built from the same sequence. (ii) $Z(t,\theta)=P(t+i\theta)P(t-i\theta) = |P(t+i\theta)|^2\ \ge 0$ whenever $a$ is real. (iii) The operator identity $S^2-D^2=4Q$ is the polynomial identity $(u+v)^2-(v-u)^2=4uv$ lifted to commuting multiplication operators.

*Proof.* Direct computation; (ii) uses $\overline{P(\bar z)} = P(z)$ for real coefficients. ∎

None of (i)–(iii) uses a single property of primes. Consequently, any claim of depth must be a claim about *which functionals* of $a\otimes a$ are computable/provable/equivalent to known open problems **when $a=\Lambda$** — that is, about the interaction with the Euler product. Sections 2–6 identify exactly such functionals.

**Remark 1.2 (positivity is free, hence worthless).** $Z\ge0$ is a Hermitian-square positivity. Goldbach for $2w$ requires positivity of a single *Fourier coefficient* of the boundary distribution — in circle-method terms $r(N) = \int_0^1 S(\alpha)^2 e(-N\alpha)\,d\alpha$ with $\int_0^1|S|^2 \sim X\log X$, while the target main term is $\mathfrak S(N)N \asymp N$. The trivial (Parseval) bound overshoots by a factor $\log X$; individual Goldbach is precisely the problem of recovering that logarithm from cancellation in a *signed* integral. No identity of Section 1 touches this.

**Lemma 1.3 (no arithmetic Lorentz group).** The group of $\mathbb Z$-linear maps preserving the form $q(S,D)=S^2-D^2$ and orientation is $\{\pm I\}$.

*Proof.* An integral isometry of $q$ either preserves or swaps the two isotropic lines $S=\pm D$; the full solution set of $M^T\mathrm{diag}(1,-1)M=\mathrm{diag}(1,-1)$ over $\mathbb Z$ is $\{\mathrm{diag}(\pm1,\pm1)\}$ together with the matrices $\begin{pmatrix}a&b\\b&a\end{pmatrix}$, $a^2-b^2=1$, which forces $(a,b)=(\pm1,0)$; restricting to orientation-preserving maps leaves $\{\pm I\}$. ∎

So there is no discrete boost dynamics acting on prime pairs: the "Lorentzian" reading of $S^2-D^2=4Q$ is inert. (The true symmetries of the pair field are the trivial ones: swap $u\leftrightarrow v$ and simultaneous translation, which do not preserve primality constraints in any useful way.) Likewise $\log(N_1N_2) = \log\frac{S^2-D^2}{4}$ is functional calculus: the Bost–Connes system sees the multiplicative monoid, and nothing in the pair field's additive coordinates interacts with its Hecke structure beyond what the explicit formula (Section 3) already encodes. We looked for more and found nothing; we consider this angle closed unless a specific non-functorial computation is proposed.

---

## 2. Theorem A: what each marginal knows

Let $a:\mathbb Z\to\mathbb R_{\ge0}$ be finitely supported, with generating polynomial $A(x)=\sum a_n x^n$ (Laurent). Define

- sum marginal $r_a(N) = \sum_{m+n=N} a_m a_n$ — coefficients of $A(x)^2$;
- difference marginal $c_a(h) = \sum_n a_n a_{n+h}$ — coefficients of $A(x)A(x^{-1})$;
- heat-resolved difference marginal $c_a(h;t) = \sum_n a_n a_{n+h} e^{-t(2n+h)}$.

**Theorem A.**
1. *(Sum rigidity.)* $r_a = r_b \implies a = b$. The Goldbach marginal is injective on nonnegative sequences.
2. *(Difference kernel.)* $c_a$ is invariant under translation and reflection, and its fibers can be strictly larger: there exist 0-1 sets sharing $c$ that are not congruent. The minimal examples have 6 elements and diameter 11, e.g. $\{0,1,2,6,8,11\}$ and $\{0,1,6,7,9,11\}$ (exhaustive search over all subsets of $\{0..13\}$; 6 distinct homometric pairs found across 12 collision events, and — consistency check — 0 sum-marginal collisions; no pairs exist at diameter $\le10$). **The existence half is now a checked term**, not a script: `formal/cubical/HomometricPair.agda` proves both that the two sets have the same interval vector $(2,2,1,1,2,2,1,1,1,1,1)$, summing to all $15$ pairwise differences, and that no translation or reflection of $\mathbb Z$ carries one to the other (EXIT=0 under the pin, Agda 2.8.0 + cubical v0.9, and under 2.6.3 + v0.5, 2026-08-15). The **minimality** clause ("6 elements, diameter 11, no pairs at diameter $\le 10$", the count of 6 pairs across 12 collision events) is *not* covered by that term and still rests on the legacy Python sweep.
3. *(Resolution restores completeness.)* $\{c_a(0;t): t>0\}$ determines $\{a_n^2\}$, hence $a$; a fortiori the full resolved field does.

*Proof.* (1) $A^2=B^2$ in the integral domain $\mathbb R[x,x^{-1}]$ gives $(A-B)(A+B)=0$, so $A=\pm B$; nonnegativity and nontriviality force $A=B$. (Same argument in $\mathbb R[[x]]$ for infinite sequences of subexponential growth, using the smallest-support-point normalization.)
(2) $A(x)A(x^{-1})$ is invariant under $A\mapsto x^kA$ and $A(x)\mapsto x^{\deg A}A(1/x)$. Strictness: the displayed pair (verified by machine; also classical, cf. the turnpike/beltway literature: Piccard's uniqueness claim, Bloom's counterexample, and the structure theory of Rosenblatt–Seymour, *SIAM J. Alg. Disc. Meth.* 3 (1982)).
(3) $c_a(0;t)=\sum_n a_n^2 e^{-2nt}$ is a generalized Dirichlet series; uniqueness of such expansions recovers $a_n^2$. ∎

**Discussion.** This settles the framework's phase question exactly. The compressed difference marginal — the object actually studied in "prime gaps" — genuinely loses phase (this is the crystallographic phase problem); the compressed sum marginal does not. Heat resolution erases the distinction. The correct slogan is not "gap data loses phase" but: **the gap marginal is the unique lossy projection of the pair field, and its kernel is exactly classical homometry.**

### 2.1 Theorem A′ and the parity upgrade

Since primes are the case of interest, we ask: *is the set $P_X=\{p\le X\}$ determined (up to congruence) by its difference multiset?* Equivalently: which finite sets share all gap statistics of the primes, with multiplicity? We are not aware of this question in the literature.

Normalize $F_X(x) = \sum_{p\le X} x^{p-2}$ (so $F_X(0)=1$).

**Theorem A′.** Suppose the non-cyclotomic part of $F_X$ is irreducible over $\mathbb Q$. Then any $B\subset\mathbb Z$ with $c_B = c_{P_X}$ is a translate of $P_X$ or of its reflection.

*Proof.* $|B|=|P_X|$ from $c(0)$ and $\operatorname{diam} B = \operatorname{diam} P_X$ from the support of $c$; normalize $B$'s polynomial $G$ with $G(0)\ne0$. Then $G\tilde G = F\tilde F$ in $\mathbb Z[x]$, where $\tilde F(x)=x^{\deg F}F(1/x)$ is the reversal. Write $F = C\cdot F_0$ with $C$ a product of cyclotomics and $F_0$ irreducible non-cyclotomic. Cyclotomic polynomials $\Phi_m$ ($m\ge2$) are palindromic, so $\tilde C = \pm C$, and $F\tilde F = C^2 F_0\tilde F_0$ up to sign. By unique factorization, $G$ is (up to sign and monomials) a product of a subset of $\{C\text{'s factors}, F_0, \tilde F_0\}$ of the right degree containing exactly one of $F_0,\tilde F_0$ — any mixed choice within the palindromic part changes nothing. Hence $G = \pm C F_0 = \pm F$ or $G=\pm C\tilde F_0 = \pm\tilde F$. Sign and 0-1-ness force $G\in\{F,\tilde F\}$. (Three glossed points, patched in `REDTEAM.md` §2: cyclotomic factors are counted with multiplicity in the subset selection; the anti-palindromic $\Phi_1=x-1$ cannot divide $F_X$ since $F_X(1)=\pi(X)>0$; and if $F_0$ is itself reciprocal then $\tilde F_0=\pm F_0$, so $G=\pm F$ directly and rigidity holds trivially.) ∎

**Computation (exp1, FLINT).** For every prime cutoff $X\le2000$, $F_X$ is irreducible — with the single exception $X=11$:
$$F_{11} = 1+x+x^3+x^5+x^9 = \Phi_6(x)\cdot(x^7+x^6-x^4+x^2+2x+1),$$
and $\Phi_6$ is palindromic, so rigidity holds there too (the induced "partner" is exactly the mirror — verified). Spot checks: irreducible at $X=5000$ (deg 4997), $X=10^4$ (deg 9971), $X=2\cdot10^4$ (deg 19,995; 211 s). Also verified directly: no non-mirror 0-1 partner exists for any tested $X$ by enumerating all factor splits.

**Why $X=11$?** $\Phi_6\mid F_X$ iff $\sum_{p\le X}\zeta^{p-2}=0$ for a primitive 6th root $\zeta$ — an exact equidistribution coincidence of primes in residue classes mod 6 (weighted by 6th roots), i.e. a *prime-race tie*. Race ties might recur (Littlewood-type oscillations), so the theorem is engineered to be immune to them. **Exhaustive scan (exp7):** over *all* moduli $m\le60$ and *all* prime cutoffs $X\le10^6$, exactly one tie exists — the known $(X,m)=(11,6)$. The $\zeta_m$-weighted races never tie again in this range: the anomaly is genuinely sporadic.

The irreducibility premise is unnecessary for the $0$--$1$ conclusion.
After translating by $-2$, the prime prefix has the unique even element $0$
and every other element is odd.  The singleton-parity theorem of
`PARITY_RIGIDITY.md` therefore gives:

**Theorem A′′ (unconditional prime phase rigidity).** For every $X\ge3$, any
finite $B\subset\mathbb Z$ with $c_B=c_{P_X}$ is a translate of $P_X$ or of
its reflection.

The former **Conjecture A″** bundled this rigidity conclusion with the much
stronger assertion that the non-cyclotomic part of $F_X$ is irreducible.
The rigidity conclusion is now a theorem; retain the algebraic assertion as
**Conjecture A″$_{\rm alg}$ (prime-prefix irreducibility)**.  Heuristic support
for that separate conjecture comes from random 0-1 polynomial results
(Konyagin; Breuillard–Varjú conditionally on GRH for Dedekind zetas;
Bary-Soroker–Kozma).  It is no longer a prerequisite for phase rigidity.

---

## 3. Theorem B: the tensor explicit formula and the aperture law

Mellin inversion of $\int_0^\infty P(t)t^{s-1}dt = \Gamma(s)\left(-\zeta'/\zeta(s)\right)$ and contour shifting give, for $\operatorname{Re} z>0$,

$$P(z) = \frac1z - \sum_\rho \Gamma(\rho)z^{-\rho} - \log 2\pi + R(z),$$

with $R$ collecting trivial-zero and $\Gamma$-pole terms ($O(|z|)$ uniformly in sectors $|\arg z|\le \tfrac\pi2-\delta$; the poles of $\Gamma$ at $-2k$ collide with trivial zeros and produce harmless $z^{2k}(a_k\log z+b_k)$ terms). The zero sum converges absolutely and fast: $|\Gamma(\tfrac12+i\gamma)| = \sqrt{\pi/\cosh\pi\gamma}\sim\sqrt{2\pi}\,e^{-\pi\gamma/2}$.

Squaring, the **zero-pair term** of $Z(t,\theta)=P(z)P(\bar z)$, $z = re^{i\varphi}$, is
$$\sum_{\rho,\rho'}\Gamma(\rho)\overline{\Gamma(\rho')}\; r^{-(\rho+\bar\rho')} e^{-i\varphi(\rho-\bar\rho')}
\;\stackrel{\text{RH}}{=}\;
\frac1r\sum_{\gamma,\gamma'}\Gamma(\rho)\overline{\Gamma(\rho')}\,e^{-i(\gamma+\gamma')\log r}\,e^{i\varphi(\gamma-\gamma')} .$$

**Theorem B (coordinate intertwining).** Under RH, in the zero-pair expansion of the pair field, the radial coordinate $\log r$ is Fourier-conjugate to the **sum spectrum** $\gamma+\gamma'$ of zeros, and the angular coordinate $\varphi=\arg z$ is conjugate to the **difference spectrum** $\gamma-\gamma'$. Thus the $(S,D)$ decomposition of prime pairs corresponds, through the Laplace–Mellin bridge, to the $(\gamma+\gamma',\gamma-\gamma')$ decomposition of zero pairs — *marginal to marginal, without mixing*.

**Theorem B′ (aperture law).** For $z=t+i\theta$, $0<t\ll\theta$, the $\rho$-term has magnitude $\asymp |z|^{-1/2}e^{-\gamma\arctan(t/\theta)}$; consequently the explicit formula truncated at height $\gamma_{\max}$ has relative error $\varepsilon$ once $\gamma_{\max}\gtrsim(\theta/t)\log(1/\varepsilon)$. *The phase direction buys zeta zeros at rate $\theta/t$; the pure heat direction ($\theta=0$) sees them only through $e^{-\pi\gamma/2}$.*

*Proof.* $|z^{-\rho}| = |z|^{-1/2}e^{\gamma\arg z}$ and $\arg z = \pi/2-\arctan(t/\theta)$ against Stirling's $e^{-\pi\gamma/2}$; sum over the zero-counting measure $dN(\gamma)\asymp\log\gamma\,d\gamma$. ∎

**Verification (exp2).** $t=0.005$; measured $\gamma_{\max}$ for relative error $10^{-6}$: $14.6,\,13.8,\,12.2$ times $\theta/t$ for $\theta=0.05,0.15,0.4$ — against the predicted constant $\log 10^6 = 13.8$. Figure `exp2_aperture.png` shows the error tracking the predicted exponential $e^{-\gamma\arctan(t/\theta)}$ over six decades.

**Verification of the inverse direction (exp5a, Landau).** The difference-type resolvent of the *zeros* recovers the *primes*: $-\tfrac{2\pi}{T}\sqrt x\sum_{\gamma\le T}\cos(\gamma\log x)$ evaluated at $x=2,3,4,5$ gives $0.693,1.097,0.693,1.608$ vs $\Lambda = 0.693, 1.099, 0.693, 1.609$ ($T=\gamma_{20000}$). The bridge runs both ways, as it must.

---

## 4. Theorem C: smoothing trivializes "average Goldbach ⟺ RH"

Let $\Theta = \sup\{\operatorname{Re}\rho\}$ and $E(t) := P(t)-1/t+\log2\pi$.

**Theorem C.**
1. $\Theta = \inf\{\sigma:\ E(t)=O(t^{-\sigma})\ (t\to0^+)\}$. In particular RH $\iff E(t)\ll t^{-1/2-\varepsilon}$ for all $\varepsilon>0$.
2. RH $\iff\ \displaystyle\sum_{N} (\Lambda*\Lambda)(N)\,e^{-Nt} = \Big(\frac1t-\log2\pi\Big)^2 + O(t^{-3/2-\varepsilon})$ for all $\varepsilon>0$.

*Proof.* (1, upper) From Section 3, $|E(t)|\le \sum_\rho|\Gamma(\rho)|t^{-\operatorname{Re}\rho} + O(t) \ll t^{-\Theta'}$ for any $\Theta'>\Theta$ since $\sum_\rho|\Gamma(\rho)|<\infty$. (1, lower) If $E(t)\ll t^{-\sigma_0}$ then $\int_0^1 E(t)t^{s-1}dt$ is holomorphic in $\operatorname{Re} s>\sigma_0$, and $\int_1^\infty P(t)t^{s-1}dt$ is entire; hence $\Gamma(s)(-\zeta'/\zeta)(s) - \frac1{s-1} + \frac{\log2\pi}{s}$ continues holomorphically to $\operatorname{Re}s>\sigma_0$. Since $\Gamma$ never vanishes, $-\zeta'/\zeta$ has no poles there except $s=1$; so no zeros of $\zeta$ have $\operatorname{Re}\rho>\sigma_0$.
(2) $P(t)^2-(1/t-\log2\pi)^2 = E(t)\,\big(P(t)+1/t-\log2\pi\big) = E(t)\big(2/t + O(t^{-\Theta})\big)$, and conversely $E = (P^2 - M^2)/(P+M)$ with the denominator $\sim 2/t$ known and nonvanishing for small $t$. So statement (2)'s error bound holds iff $E\ll t^{-1/2-\varepsilon}$, which is (1). ∎

**Discussion.** Statement (2) is an "average Goldbach ⟺ RH" equivalence with a *two-line* proof, because the heat-smoothed sum marginal is an exact square and square roots of positive functions are unique — the analytic double of Theorem A(i). The sharp-cutoff analogues (RH $\iff \sum_{N\le X}(\Lambda*\Lambda)(N) = X^2/2 + O(X^{3/2+\varepsilon})$: Granville; converse direction and the $\Omega(X\log\log X)$ lower bound: Bhowmik–Schlage-Puchta, *Nagoya Math. J.* 200 (2010); unconditional Fujii-type formula: Goldston–Suriajaya, arXiv:2110.14250) require genuine work precisely because the sharp cutoff destroys the factorization. **Diagnosis: the analytic difficulty in this corner of the literature is a property of the cutoff, not of the arithmetic.** This does not diminish those results — the sharp count is the natural object — but it relocates the difficulty and explains *why* the Cesàro-smoothed versions (Languasco–Zaccagnini) come out clean.

---

## 5. Theorem D: Goldbach data displays the sum-spectrum of the zeros

The centerpiece. Consider the once-smoothed count $G_1(X) = \sum_{m,n}\Lambda(m)\Lambda(n)(X-m-n)_+$.

**Theorem D (identity — Languasco–Zaccagnini $k=1$; rederived).** Under RH, with absolutely convergent sums,
$$G_1(X) = \frac{X^3}{6}\;-\;2\sum_\rho \frac{X^{\rho+2}}{\rho(\rho+1)(\rho+2)}\;+\;\sum_{\rho,\rho'}\frac{\Gamma(\rho)\Gamma(\rho')}{\Gamma(\rho+\rho'+2)}X^{\rho+\rho'+1}\;+\;O(X^2),$$
the $O(X^2)$ being smooth (frequency-0 in $\log X$) deterministic terms. The derivation is two applications of the explicit formula with the Dirichlet integral $\iint_{u+v\le X}u^{\rho-1}v^{\rho'-1}(X-u-v)\,du\,dv = \frac{\Gamma(\rho)\Gamma(\rho')}{\Gamma(\rho+\rho'+2)}X^{\rho+\rho'+1}$.

**Theorem D′ (weight law).** Writing $\rho=\tfrac12+i\gamma$, $\rho'=\tfrac12+i\gamma'$ with $\gamma,\gamma'$ of either sign, the pair weight $W(\gamma,\gamma') = \Gamma(\rho)\Gamma(\rho')/\Gamma(\rho+\rho'+2)$ satisfies, by Stirling,
$$|W| \asymp (\gamma+\gamma')^{-5/2}\ \text{(same sign)},\qquad |W|\ \ll\ e^{-\pi\min(|\gamma|,|\gamma'|)}\ \text{(opposite sign)}.$$
Hence under RH the second-order term of $G_1$ is, at scale $X^2$, an absolutely convergent exponential sum over the **sum spectrum** $\{\gamma_i+\gamma_j\}$ — the additive-energy resolvent of the zeros — with no contribution from the difference spectrum.

**Numerical verification (exp6b; primes to $4\cdot10^6$, 30,000 zeros in the single sum, 1200 in the pair sum).**
- Same-sign weight decay: measured slope $-2.500$ (predicted $-5/2$).
- After removing $X^3/6$ and the single-zero layer, the residual's power spectrum in $\log X$ consists of lines at $\gamma_i+\gamma_j$; band $[25,320]$: **correlation 0.9999, amplitude ratio 0.9991** between data and model.
- Individual lines: $2\gamma_1 = 28.269$ (ratio 1.002), $\gamma_1+\gamma_2 = 35.157$ (0.997), $\gamma_1+\gamma_3=39.146$ (1.000), $2\gamma_2=42.044$ (0.989).
- The band-passed data and model are pointwise indistinguishable (`figures/exp6b_sumspectrum.png`).

A methodological note with mathematical content: at sharp cutoff ($k=0$) the same comparison fails numerically — the single-zero layer converges so slowly ($\sum1/\gamma^2$-type tails) that its truncation error buries the pair term; one order of Cesàro smoothing improves the pair weights from $(\gamma+\gamma')^{-3/2}$ to $(\gamma+\gamma')^{-5/2}$ and the single tails from $\gamma^{-2}$ to $\gamma^{-3}$, crossing the absolute-convergence threshold for the pair sum ($(3/2$ vs $5/2)$ against pair density $\sim T\log^2T$). This is the quantitative form of "the sharp cutoff is the difficulty".

**Theorem D″ (variance ⟺ weighted additive energy; conditional, proof sketch).** Under RH, for the dyadic mean square of the second-order term $\Delta(X) := G_1(X)-X^3/6+2\sum_\rho\frac{X^{\rho+2}}{\rho(\rho+1)(\rho+2)}$ (smooth part removed),
$$\frac1{\log2}\int_T^{2T}\big|\Delta(x)\big|^2\frac{dx}{x^5}\;\asymp\;\sum_{\substack{\gamma_1+\gamma_2\ \approx\ \gamma_3+\gamma_4\\ |\gamma_i+\gamma_j|\ \text{window}}} W_{12}\overline{W_{34}}\;\widehat{\Phi}\big((\gamma_1+\gamma_2)-(\gamma_3+\gamma_4)\big),$$
a **weighted additive energy of the zero ordinates** at resolution $1/\log T$. Upper bounds follow from the Montgomery–Vaughan mean value theorem applied to the (absolutely convergent) frequency decomposition; lower bounds from positivity of the diagonal. The unweighted counterpart $N^*(\sigma,T)$ — the additive energy of zero ordinates — has just entered the literature as a systematic tool (Tao–Trudgian–Yang, arXiv:2501.16779, for zero-density purposes); Theorem D″ says *Goldbach-average variance is a weighted additive energy statement*, the exact $S$-side mirror of Goldston–Montgomery's theorem that prime-count variance in short intervals is equivalent to Montgomery's pair-correlation ($D$-side, $\gamma-\gamma'$) function. Completing all $\varepsilon$-management in D″ is routine-but-real work (see §8, Problem 2).

### 5.1 The 2×2 dictionary

| | prime-side $S$ (Goldbach) | prime-side $D$ (gaps) |
|---|---|---|
| **zero-side $S$** ($\gamma+\gamma'$) | Fujii/LZ formulas; Thm D; variance = additive energy (Thm D″) | — |
| **zero-side $D$** ($\gamma-\gamma'$) | — | Montgomery pair correlation; Goldston–Montgomery equivalence |

The diagonal is populated by theorems; the off-diagonal is *empty* — and Theorem B explains why: the bridge is marginal-to-marginal, without mixing. Sum data of primes couples only to sum data of zeros; difference to difference. We regard this exact segregation — visible in the identity, in the weights, and in the numerics — as the framework's one true "intertwining theorem".

**[Update (`FRESNEL.md`): the off-diagonal is empty for *Hermitian* statistics only. The phases of the sum-spectrum lines carry the difference spectrum as a Fresnel chirp $(\gamma-\gamma')^2/2f$ (Theorem G); *given the line positions*, `exp14_fresnel` recovers zero gaps from the phases of the Goldbach data to 0.1% (a fully blind pipeline reaches ~10–30%; see `CROSSREVIEW_WAVE2.md`). Theorem B's frequency-support statement stands; the mixing lives entirely in phase.]**

---

## 6. The holomorphic/Hermitian dichotomy (what "phase" really meant)

Assemble Theorems A, C, D and Experiment 5 into one statement.

The sum marginal is the **holomorphic square** $P(z)^2$: an analytic object, uniquely square-rootable (Thm A(i) combinatorially, Thm C analytically), and — critically — *polynomial in the explicit formula*: substituting $P = \text{pole} - \sum_\rho + \cdots$ and expanding yields exact, absolutely convergent (after one smoothing) formulas whose evaluation needs only the **locations** of zeros. Goldbach averages are *outputs* of the zero spectrum.

The difference marginal is the **Hermitian square** $|P(z)|^2$ read at fixed frequency: $C_h(t) = \frac1{2\pi}\int |P(t+i\theta)|^2 e^{ih\theta}\,\theta$-integrated. Substituting the expansion pairs $\Gamma(\rho)z^{-\rho}$ against $\overline{\Gamma(\rho')z^{-\rho'}}$ and the $\theta$-integral concentrates the pair sum near the diagonal $\gamma\approx\gamma'$: the answer is a quadratic form in the zeros evaluated on the **correlation structure** of the spectrum, which RH does not determine. Gap statistics are *inputs* to (conjectures about) the zero spectrum. This is Montgomery's discovery, read backwards.

Hence the staircase of §0, and the twin facts of Experiment 5: the zeros' own difference spectrum is GUE-rigid while their sum spectrum is Poisson (spacing variance ratio 1.001 — after correcting a double-counting artifact whose theoretical value, 3.0, we also predicted; both measured). **Structure lives in the Hermitian coordinate of each field, and the Laplace bridge exchanges accessibility, not structure:** the holomorphic (sum) side of primes is the *computable* side; the Hermitian (difference) side of primes is the *structured-but-conjectural* side, coupled to the Hermitian side of zeros.

This, we contend, is the precise and correct residue of the original "phase retrieval" intuition:

- At the level of *information*: phase is lost in the compressed difference marginal for general sets (homometry, Thm A), but not for prime prefixes: singleton parity proves exact rigidity for every $X$ (Thm A′′).
- At the level of *provability*: "phase" = the holomorphic/Hermitian distinction, and it sits exactly at the boundary between theorem-factories (Fujii/LZ/Thm C/D) and the open problems (pair correlation, twin primes, individual Goldbach).

**What remains genuinely open in this language.** Individual Goldbach = pointwise lower bound on coefficients of the holomorphic square: needs $L^1\to$ pointwise passage (minor arcs; the $\log$-factor of Remark 1.2). Twin primes = pointwise statement about a single Hermitian frequency. Both live strictly above every rung the pair field can reach by linear/quadratic expansion. The framework clarifies *why* they are hard; it does not make them easier. Note also the persistent $\Lambda$ vs $\mathbf 1_P$ gap: $\Lambda*\Lambda(N)>0$ admits prime-power representations ($N=p^a+q^b$), so even a positivity miracle for $\Lambda$-Goldbach would leave a (sparse but real) bridge to cross; conversely all our theorems hold verbatim for either weight.

---

## 7. The deep neighboring structures (where real spectral theory lives)

**(a) The solvable model: divisor pair field.** Replace $\Lambda$ by $d(n)$. The difference marginal $\sum_n d(n)d(n+h)$ (Estermann; Motohashi) *does* admit an exact spectral expansion — over the discrete spectrum of the hyperbolic Laplacian on $\Gamma\backslash\mathbb H$ plus Eisenstein contribution. Via Motohashi's formula, the fourth moment of $\zeta$ on the critical line — the Hermitian square of a Hermitian square — is an explicit sum over Maass forms. The mechanism: on the hyperbola $uv=N$, divisor pairs are lattice points, and $GL_2$ spectral theory (Kloosterman sums, Kuznetsov) resolves the shifted convolution. **This is exactly the operator/spectral structure the framework hopes exists for primes — and it provably exists one level down, for divisors.** The obstruction to transport is well known: $\Lambda$ is not "automorphic-summable"; no Voronoi/Kuznetsov summation formula exists for primes. Any serious continuation of this program should treat the divisor field as the exactly-solvable model and measure all prime-field conjectures against it.

**(b) Weil positivity and screw functions.** RH is *equivalent* to positivity of the Weil quadratic form on Hermitian squares $g\star\tilde g$ — a compressed phase-rigidity statement on the multiplicative group. The prime side of the pair field is automatically positive (Prop 1.1(ii)); the explicit-formula transfer of that positivity fails to reach Weil's because of the pole and Archimedean terms — precisely the gap Connes–Consani have been attacking (Weil positivity in squares). Meanwhile Matsumoto–Suzuki (arXiv:2409.00888, J. Number Theory 2026) have built the $S$-side counterpart: Krein *screw functions* attached to the secondary terms of Goldbach summatory functions, yielding a new necessary-and-sufficient condition for RH. Our Theorem D is the concrete, numerical face of the same secondary terms; the natural join (their screw-function positivity ↔ our weighted additive energy) is Problem 3 below.

**(c) Sum-product tension.** The coordinates $(S,D,Q)$ with $S^2-D^2=4Q$ formalize that a prime pair is simultaneously an additive object ($S,D$) and a multiplicative one ($Q$). The primes are the free generators of the multiplicative monoid; every hard conjecture in sight (Goldbach, twins, Chowla, HL $k$-tuples) asserts their *additive pseudo-randomness*. The pair field is the minimal window where the two structures collide (cf. the sum-product philosophy). The modern movable frontier here is the logarithmic Chowla/Sarnak program (Matomäki–Radziwiłł–Tao): the μ-analogue of our difference marginal at $k=2$ is *solved* in logarithmic density. That is the one place where "difference-marginal of a multiplicative object" has recently yielded, and any operator-theoretic ambitions for the prime pair field should be benchmarked against the entropy-decrement machinery, not against physics metaphors.

---

## 8. Three problems this work generates

1. **Prime-prefix irreducibility (Conjecture A″$_{\rm alg}$).** The original
   $0$--$1$ phase-rigidity objective is solved by singleton parity (Thm A′′).
   The stronger algebraic question remains: is the non-cyclotomic part of
   $F_X=\sum_{p\le X}x^{p-2}$ irreducible for every $X$?  Cyclotomic factors
   are classified globally, bounded-degree factors disappear effectively,
   and the first finite open layer is a nonreciprocal octic.  This now studies
   the algebraic spectral factors themselves, not the uniqueness of prime
   sets from gap data.
   **[Erratum retained from the earlier phrasing (`FRESNEL.md` §1): "no
   reciprocal non-cyclotomic factor" does *not* by itself certify rigidity —
   reciprocal factors *remove* swap freedom rather than create it, so when
   the non-cyclotomic part is reducible one must still exclude 0-1 mixed
   products, as exp1 does by enumeration.]** Tools: Konyagin/Filaseta 0-1
   techniques; prime races mod $m$ for the cyclotomic layer ($\Phi_m\mid F_X$
   iff a weighted race ties at $X$ — itself a clean analytic question: *for
   which $m$ does the $\zeta_m$-weighted prime race tie infinitely often?*).
   (Filed independently on both branches before the A′′ upgrade landed.)
2. **Weighted additive energy of zeros.** Prove Theorem D″ with explicit constants, and determine the true order of $\sum_{|\gamma_i+\gamma_j|\le T,\ \text{4-tuples near diagonal}} W_{12}\overline{W_{34}}$ under RH + (a) GUE-adjacent hypotheses, (b) unconditionally with $N^*(\sigma,T)$ inputs (Tao–Trudgian–Yang). Payoff: sharp $\Omega/O$ results for the Goldbach-average error, potentially improving Bhowmik–Schlage-Puchta's $\Omega(X\log\log X)$ story into an equivalence with a zero-clustering statement — the exact $S$-side analogue of Goldston–Montgomery.
3. **Screw-function ⟷ sum-spectrum join.** Matsumoto–Suzuki's screw function is built from the same secondary terms our exp6b resolves into $\gamma_i+\gamma_j$ lines. Make the dictionary exact: their Krein-space positivity condition should be equivalent to a positivity property of the measure $\sum_{i,j} W_{ij}\,\delta_{\gamma_i+\gamma_j}$. A numerical Krein test at 100k zeros is immediately feasible with this repository's data.

---

## 9. Verdict

The pair field is not a new structure — it is the rank-one square of the prime indicator, and every "physics" reading of it that we tested is inert (Section 1). But interrogating it adversarially forced exact answers to real questions, including unconditional homometric rigidity of every prime prefix by singleton parity (A′′); the clean smoothing-trivialization of the average-Goldbach/RH equivalence (C); and the direct spectral display — identity, weight law, and 0.1%-level verification — of the zeta sum-spectrum $\{\gamma_i+\gamma_j\}$ inside Goldbach data (D), organized by the marginal-to-marginal intertwining (B) and the holomorphic/Hermitian dichotomy (§6). The polynomial irreducibility program remains valuable independent algebra rather than a prerequisite for rigidity. The deepest true statements adjacent to the framework — GL(2) solvability of the divisor model, Weil/screw positivity — mark where a continuation should aim.

---

## Appendix: reproducibility

| artifact | produces |
|---|---|
| `code/pairfield.py` | sieves, FFT convolutions, zero loading |
| `code/exp1_rigidity.py`, `exp1b` | Thm A brute force; A′ factorizations (FLINT) |
| `code/exp2_bridge.py` | aperture law figure + constants |
| `code/exp3_fujii.py` | sharp-cutoff Fujii comparison (and its failure mode) |
| `code/exp4_singular.py` | one singular series, two marginals (ratios 0.99997 / 0.99925, corr 0.9996) |
| `code/exp5_zerofield.py` | Landau reconstruction; GUE differences; Poisson sums |
| `code/exp6b_sumspectrum.py` | Theorem D verification (corr 0.9999; lines to 1%) |
| `data/odlyzko_zeros_100k.txt` | first 100,000 zeros (Odlyzko's tables) |

Key numerical results quoted above are printed by the corresponding scripts; figures in `figures/`.
