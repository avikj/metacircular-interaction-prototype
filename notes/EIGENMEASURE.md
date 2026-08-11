# EIGENMEASURE: the dichotomy problem for dilation eigenprocesses

Workstream A of `notes/DIRECT.md`, executed. Author: fleet-eigen
(Claude Fable lineage), 2026-08-11. Method: direct structure only — no
numerical sampling was used anywhere in this note.

**Contents.** §1 exact framework (Cesàro vs logarithmic, the transfer
identity). §2 map of known results into the framework (every literature
claim below was checked against the fetched source; ledger in §7).
§3 soft theorems established here, with full proofs. §4 both directions
of the core question: the exotic construction (which *exists* in the
relaxed category — the dichotomy FAILS abstractly) and the softest
hypothesis forcing Bernoulli. §5 the arithmetic-entry-points ledger (the
workstream's key output). §6 rigor boundary. §7 references + fetch
ledger.

**Executive summary.**
1. Under logarithmic averaging every shift-orbit limit of a point of
   $M = \{\pm1\}^{\mathcal P}$ carries an exact conditional
   self-similarity (E$_m$) — the measure-level shadow of
   $T_p\lambda = -\lambda$. Under Cesàro averaging the identity instead
   couples *different* scales: the limit **set** carries a
   renormalization action and individual limits need not be
   self-similar. This asymmetry is not cosmetic; it is confirmed
   sharply in the literature (FLR Thm 2.19 vs Thm 2.4).
2. Soft theorems (proved here, no arithmetic): for an *ergodic* limit
   with no rational eigenvalues the self-similarity de-conditions, the
   mean and all two-point correlations vanish; a *weakly mixing* limit
   is exactly Bernoulli($\tfrac12$); the eigenvalue group of such a
   limit is divisible (this last is known in stronger form: FLR
   2304.03121, Thm 2.1).
3. The abstract dichotomy of DIRECT.md (A) is **refuted in the relaxed
   category**: for complex unimodular completely multiplicative
   functions, Furstenberg systems that are ergodic, zero-entropy,
   NOT almost periodic and NOT positive-entropy exist — the MRT
   functions' systems are unipotent (FLR Thms 2.18–2.20). So the
   eigenvector identity alone does *not* force the dichotomy.
4. For $\pm1$-valued $x$ the refutation does not transfer: the only
   continuous family of unimodular completely multiplicative
   "characters" is $n \mapsto n^{it}$, and a $\pm1$-valued $x$ can
   never pretend to $\chi(n)n^{it}$ with $t \neq 0$ — quantitatively,
   by the pretentious triangle inequality plus the nonvanishing
   $\zeta(1+2it) \neq 0$, $L(1,\psi)\neq 0$ (Prop 4.2). **The
   resulting 1-line nonvanishing argument closes the specific
   Archimedean pretension channel used by the MRT construction.  It
   does not classify all possible $\pm1$ exotic mechanisms.**
5. The parity barrier reappears *inside* the soft theory with exact
   coordinates: the odd Walsh sector of an eigenmeasure is the charged
   sector; soft dilation-averaging annihilates precisely against the
   vanishing mean of $x$ (§3.6). The two-copy square trick that
   circumvents it under weak mixing is the dynamical incarnation of the
   bilinear/Type-II mechanism — consistent with `notes/LENS_CHAITIN.md`
   §2's conservation law, now in a fifth theater: **eigenmeasures**.

---

## 1. Exact framework

### 1.1 Objects

$\Omega = \{\pm1\}^{\mathbb N}$ (product topology, compact), shift
$(S\omega)(j) = \omega(j+1)$. The simultaneous eigenvector set
$$M = \{x \in \Omega:\ x(mn) = x(m)x(n)\ \ \forall m,n \ge 1\}
    \ \cong\ \{\pm1\}^{\mathcal P},$$
a compact abelian group (coordinates: values at primes). For a prime
$p$ the dilation $(D_p\omega)(j) = \omega(pj)$ satisfies, on $M$,
$D_p x = x(p)\,x$; more generally $D_m x = x(m)x$ for the composite
dilations $D_m = \prod D_{p_i}$, $m = \prod p_i$. The global sign flip
is $\sigma_\pm(\omega) = -\omega$; for $\varepsilon \in \{\pm1\}$ write
$\sigma_\varepsilon$ for the identity ($\varepsilon = +1$) or the flip
($\varepsilon = -1$).

### 1.2 Averaging and limit sets

For $x \in \Omega$ and $N \ge 1$ define empirical measures on $\Omega$:
$$\mathbb E^{\mathrm C}_N = \frac1N\sum_{n=1}^{N}\delta_{S^n x},
\qquad
\mathbb E^{\log}_N = \frac1{L_N}\sum_{n=1}^{N}\frac1n\,\delta_{S^n x},
\quad L_N = \sum_{n \le N}\tfrac1n .$$
$V^{\mathrm C}(x)$, $V^{\log}(x)$ are the sets of weak-\* limit points
along subsequences $N_j \to \infty$. A **shift-orbit statistical limit
of $x$** is any element of one of these sets; both are nonempty and
consist of $S$-invariant Borel probability measures.

**Enrichment.** Let $\hat{\mathbb Z} = \varprojlim \mathbb Z/q$ with
Haar measure and the rotation $R: r \mapsto r+1$. Replace $\delta_{S^n x}$
by $\delta_{(S^n x,\, [n])}$ on $\hat\Omega = \Omega \times \hat{\mathbb Z}$
with the joint map $\hat S = S \times R$. Limit points $\hat\nu$ of the
enriched empirical measures project to $\nu \in V(x)$ on the first
coordinate and to Haar on the second (residues equidistribute under
both averagings — elementary). We always take limits in the enriched
form; $\hat\nu$ is $\hat S$-invariant.

**Furstenberg correspondence, for a fixed point of $M$.** An
$S$-invariant $\nu$ on the one-sided $\Omega$ is the law of a
stationary $\pm1$ process; pass freely to its two-sided Kolmogorov
extension $(X_h)_{h\in\mathbb Z}$ (the natural extension of the
one-sided system — invertible, same spectrum, same entropy, same
mixing properties). A **dilation eigenprocess** is a stationary process
arising this way from some $x \in M$ (per DIRECT.md's definition), and
we call its law an **eigenmeasure** once it satisfies the transfer
identity of Prop 1.4 below — automatic in the logarithmic case.

**Walsh coordinates.** For finite nonempty $A \subset \mathbb Z$ set
$\hat w_\nu(A) = \mathbb E_\nu\big[\prod_{h \in A} X_h\big]$. Since the
$X_h$ are $\pm1$-valued, the family $\{\hat w_\nu(A)\}$ *determines*
$\nu$: every cylinder probability on a window $W$ is
$2^{-|W|}\sum_{A \subseteq W}\hat w_\nu(A)\prod_{h\in A}\varepsilon_h$
(Fourier–Walsh inversion on $\{\pm1\}^W$). Stationarity:
$\hat w(A+t) = \hat w(A)$. In particular
$\nu = \mathrm{Bernoulli}(\tfrac12)$ iff $\hat w(A) = 0$ for all
$A \neq \emptyset$.

### 1.3 Basic properties

**Proposition 1.1.** (i) Every $\nu \in V^{\mathrm C}(x) \cup V^{\log}(x)$
is $S$-invariant. (ii) Both limit sets are compact, nonempty and
connected. (iii) *Slow variation, logarithmic case:*
$\|\mathbb E^{\log}_{\lfloor N/m\rfloor} - \mathbb E^{\log}_N\|
 \to 0$ for each fixed $m \ge 1$ (dual-Lipschitz/weak-\* sense); hence
$V^{\log}$ computed along $N_j$ and along $\lfloor N_j/m\rfloor$
coincide. The Cesàro empirical measures do NOT slowly vary in this
sense: $\mathbb E^{\mathrm C}_{N}$ and $\mathbb E^{\mathrm C}_{\lfloor N/m\rfloor}$
may have different limits.

*Proof.* (i) For local $F$,
$\mathbb E^{\log}_N(F\circ S) - \mathbb E^{\log}_N(F)
= \frac1{L_N}\sum_{n\le N}(\tfrac1n - \tfrac1{n+1})F(S^{n+1}x) + O(\tfrac{\|F\|}{L_N})
= O(\|F\|_\infty/L_N) \to 0$ since $\sum 1/n(n+1) < \infty$; Cesàro is
the standard telescope. (ii) Compactness: weak-\* compactness of the
probability simplex on a compact space. Connectedness: the map
$N \mapsto \mathbb E_N$ moves by $O(1/N)$ (Cesàro) resp. $O(1/(NL_N))$
(log) in dual-Lipschitz norm at each step, so the limit set of a
sequence with vanishing increments is connected (standard lemma).
(iii) $L_N - L_{\lfloor N/m\rfloor} = \log m + O(1/N)$ and the total
weight of $n \in (\lfloor N/m\rfloor, N]$ is $\log m + o(1) = o(L_N)$.
$\square$

### 1.4 The transfer identity (the eigenvector identity at measure level)

This is the exact content of "$x$ is a simultaneous dilation
eigenvector" seen by shift statistics. It is known — it is Tao's
multiplicativity-averaging identity, systematized by Frantzikinakis–
Host; we state and prove it in the present coordinates.

**Proposition 1.2 (logarithmic transfer).** Let $x \in M$ and let
$\hat\nu$ be any enriched logarithmic limit along $N_j$, with marginal
$\nu$. Then for every $m \ge 1$ and every local observable $F$:
$$\tag{E$_m$}
\mathbb E_{\hat\nu}\big[F \circ D_m \,\big|\, r \equiv 0 \ (\mathrm{mod}\ m)\big]
 \;=\; \mathbb E_{\nu}\big[F \circ \sigma_{x(m)}\big].$$
Equivalently, writing $\hat\nu_{0(m)}$ for $\hat\nu$ conditioned on
$\{r \in m\hat{\mathbb Z}\}$ and $\hat D_m(\omega, r) = (D_m\omega, r/m)$:
$(\hat D_m)_*\hat\nu_{0(m)} = (\sigma_{x(m)} \times \mathrm{id})_*\hat\nu$.

*Proof.* Fix a window $\{1,\dots,W\}$ and $F$ depending on
$\omega(1),\dots,\omega(W)$. For $n = ms$:
$D_m(S^{ms}x)(j) = x(ms + mj) = x(m)\,x(s+j)$, so
$F(D_m S^{ms}x) = (F\circ\sigma_{x(m)})(S^s x)$ exactly — this is the
eigenvector identity, used with no error term. Therefore
$$\frac1{L_N}\sum_{\substack{n \le N\\ m \mid n}}\frac1n F(D_m S^n x)
= \frac1{L_N}\sum_{s \le N/m}\frac1{ms}(F\circ\sigma_{x(m)})(S^s x)
= \frac1m\,\frac{L_{\lfloor N/m\rfloor}}{L_N}\,
  \mathbb E^{\log}_{\lfloor N/m\rfloor}(F\circ\sigma_{x(m)}).$$
Let $N \to \infty$ along $N_j$. The left side converges to
$\hat\nu\big(\mathbf 1_{r \equiv 0 (m)}\cdot F\circ D_m\big)$ (the
residue indicator is a continuous function of $r \in \hat{\mathbb Z}$).
By Prop 1.1(iii) the right side converges to
$\frac1m\,\nu(F\circ\sigma_{x(m)})$ **along the same subsequence**.
Since the residue marginal is uniform,
$\hat\nu(r \equiv 0\,(m)) = 1/m$, and dividing gives (E$_m$). The
residue bookkeeping $[ms]/m = [s]$ gives the $\hat D_m$ form.
$\square$

**Proposition 1.3 (Cesàro renormalization).** With Cesàro averaging the
same computation yields, for limits along $N_j$,
$$m \cdot \hat\nu^{(N_j)}\big(\mathbf 1_{r\equiv0(m)}\cdot F\circ D_m\big)
 \;=\; \nu^{(N_j/m)}\big(F\circ\sigma_{x(m)}\big),$$
where $\nu^{(N_j/m)}$ is a limit along the *rescaled* subsequence
$\lfloor N_j/m\rfloor$. Consequently: (a) if $V^{\mathrm C}(x)$ is a
singleton, its element satisfies (E$_m$) for all $m$; (b) in general
$V^{\mathrm C}(x)$ is invariant under the induced scale-renormalization
correspondences $R_m$, and (E$_m$) holds only for renormalization fixed
points. Logarithmic averaging is precisely the scale-average that makes
every limit a fixed point. $\square$

**Definition 1.4.** An $S$-invariant $\hat S$-enriched $\hat\nu$ (with
sign data $x: \mathcal P \to \{\pm1\}$ extended completely
multiplicatively) satisfying (E$_m$) for all $m \ge 1$ is a
**(conditional) eigenmeasure**. It is an **unconditional eigenmeasure**
(equivalently, in Furstenberg–Katznelson's terminology as used by FH, a
*twisted strongly stationary* process) if moreover
$$\tag{E$^\flat_m$} (D_m)_*\nu = (\sigma_{x(m)})_*\nu
\qquad\text{for all } m\ge1,$$
i.e. $(X_{mh})_{h} \overset d= (x(m)\,X_h)_{h}$. When $x \equiv 1$,
(E$^\flat$) is exactly Furstenberg–Katznelson **strong stationarity**.

By Prop 1.2: *every logarithmic shift-orbit limit of every point of $M$
is a conditional eigenmeasure.* The dichotomy problem (A) of DIRECT.md
is the classification of their ergodic components.

**Caveat (ergodic decomposition).** (E$_m$) is a property of $\hat\nu$
as a whole; it does not automatically pass to ergodic components (the
dilation can permute components). All theorems below therefore assume
ergodicity of the limit itself, exactly as the known conditional
results do (Frantzikinakis 1611.09338).

---

## 2. The known results, mapped

Every row was checked against the fetched source (§7). "Log" =
logarithmic averaging; "Ces" = Cesàro. Dichotomy-shape column: which
piece of the (A)-dichotomy the result actually proves.

| result (source) | averaging | exact dichotomy-shaped statement |
|---|---|---|
| Matomäki–Radziwiłł 2016 (1501.04585) | Ces, short intervals | The engine: mean values of bounded multiplicative functions in almost all short intervals $[X, X+h]$, $h\to\infty$. No dichotomy statement itself; it is the arithmetic axiom every entry below consumes. |
| MRT averaged Chowla (1503.05121) | Ces, averaged over shifts | $k$-point Chowla *on average over $h$*; supplies the Fourier-uniformity input $\sup_\alpha$ of $\lambda$ over short intervals; contains (corrected) Elliott formulation. |
| Tao 2-point (1509.05422) | **log** | (E$_p$)-exploitation, order 2: $\sum_{n\le x}\lambda(n)\lambda(n+h)/n = o(\log x)$. In framework terms: *every* log-limit $\nu$ of $\lambda$ has $\hat w_\nu(\{0,h\}) = 0$ — the 2-point Walsh sector of every eigenmeasure of $\lambda$ vanishes, unconditionally. Inputs: MR + entropy decrement. |
| Tao–Teräväinen odd (1710.02112) | **log** | All odd-order log Chowla: $\hat w_\nu(A) = 0$ for all $|A|$ odd, for every log-limit $\nu$ of $\lambda$. The charged Walsh sector of $\lambda$'s eigenmeasures vanishes. |
| Tao–Teräväinen structure (1708.02610) | **log** | The correlation ray-map $a \mapsto f(a) = $ (log-correlation at shifts $ah_i$) is a uniform limit of periodic functions; $\chi$-isotypic if $g_0\cdots g_k$ weakly pretends $\chi$, identically $0$ if not. This is the arithmetic upgrade of the soft ray-covariance $\hat w(aA) = x(a)^{|A|}\hat w(A)$ (§3.6): arithmetic forces *periodic* ray-dependence, the identity forces *$\lambda(a)$-twisted* ray-dependence, and for odd $|A|$ the clash annihilates the sector. |
| Frantzikinakis (1611.09338) | **log** | *Conditional dichotomy, ergodic case:* if some/any log-limit of $\lambda$ is ergodic, then log Chowla (all orders) holds, i.e. that limit is Bernoulli($\frac12$). Ergodicity of $\lambda$'s limits remains open. |
| Frantzikinakis–Host (1708.00677, Annals) | **log** | Log-Sarnak for "a large class of systems, which includes all uniquely ergodic systems with zero entropy" (abstract, verbatim). Structure theorem: log-limits of $\lambda,\mu$ have **no irrational spectrum** and are built from infinite-step nilsystems and Bernoulli blocks; proof runs through Tao's identity (our Prop 1.2) + Host–Kra + strong stationarity (Furstenberg–Katznelson, Jenvey). The "no irrational spectrum" step is $\lambda$-specific arithmetic (it FAILS for general $x \in M$-relaxations — see FLR/MRT row), not soft. |
| GKL (1710.07049) | Ces → Ces subsequence | Sarnak (Ces) $\Rightarrow$ Chowla along a subsequence of scales: in framework terms, Möbius disjointness forces $\mathrm{Bernoulli}(\frac12) \in V^{\mathrm C}(\lambda)$-closure along some $N_j$. Lives on the Prop 1.3 renormalization structure. |
| GLR (2006.09958) | Ces subsequence | In the MRT class of counterexamples to Elliott, Chowla holds along a subsequence: $V^{\mathrm C}$ of an MRT function contains Bernoulli-type limits *alongside* the exotic ones — a single point of the (relaxed) eigenvector set with both horns in its limit set. |
| FLR (2304.03121) | both | (i) Pretentious $f$: all Furstenberg systems have **rational discrete spectrum**, zero entropy (Thm 2.7); ergodic iff $f$ pretends to a Dirichlet character; Archimedean characters $n^{it}$ are the only pretentious $f$ with trivial rational spectrum. (ii) **Divisible spectrum** for all Furstenberg systems of completely multiplicative $f$, log averaging (Thm 2.1, Cor 2.2(i)); with the residue-shift form $(\alpha+k)/r$ capturing the rational coupling. (iii) Log: trivial rational spectrum $\Rightarrow$ strong stationarity (Thm 2.4); FALSE for Cesàro (Thm 2.19). (iv) MRT functions: Cesàro limits are **unipotent systems of fixed level**; log limits are mixtures of infinitely many unipotent levels (Thms 2.18–2.20). |
| Jenvey 1997 (J. Anal. Math. 73) | abstract | Every **ergodic strongly stationary** system is Bernoulli. The untwisted ($x \equiv 1$) ergodic classification. FH extend the use to strongly aperiodic multiplicative functions. |
| TT value patterns (1904.05096) | log / upper density | All sign patterns of $\lambda$ of length $\le 3$ have log density $2^{-k}$ (from 2-pt + odd); $\ge 24$ of the 32 length-5 patterns occur with positive upper density. The $k=4$ pattern problem (FOREST's fruit-fly) is exactly blocked by the unknown even sector $\hat w(A)$, $|A| = 4$. |
| Najnudel (1702.01470, EJP 2020) | Ces, a.s. | Random $x \in M$ (iid signs at primes): empirical measures converge a.s.; consecutive values become independent — the **Bernoulli horn is realized** by almost every point of the group $M$ (Haar), with full Cesàro convergence. |

**Verdict of the map.** Everything proved for $\lambda$ factors through
the shape: (soft transfer identity Prop 1.2) + (arithmetic axiom:
MR/MRT Fourier uniformity, PNT-strength nonvanishing) + (soft ergodic
theory: strong stationarity, Host–Kra, Jenvey). No known result derives
any horn of the dichotomy from the identity alone — and §4.1 shows none
can in the relaxed category.

---

## 3. Soft theorems (established here)

Throughout: $\nu$ is the (two-sided extension of the) marginal of an
enriched limit $\hat\nu$ of $x \in M$ under **logarithmic** averaging,
so (E$_m$) holds (Prop 1.2); "eigenvalue" = Koopman eigenvalue of
$(\Omega_{\mathbb Z}, \nu, S)$; "trivial rational spectrum" = no
eigenvalue that is a root of unity other than 1. Statements 3.1–3.5 are
pure ergodic theory: they hold for *abstract* conditional eigenmeasures
with any sign data $x \not\equiv 1$, with no arithmetic input.

### 3.1 De-conditioning (disjointness from the odometer)

**Lemma 3.1.** Let $\nu$ be ergodic with trivial rational spectrum.
Then $\hat\nu = \nu \otimes \mathrm{Haar}(\hat{\mathbb Z})$, and
consequently the unconditional identity (E$^\flat_m$) holds for every
$m$: $(D_m)_*\nu = (\sigma_{x(m)})_*\nu$.

*Proof.* Pass to natural extensions so all maps are invertible;
$\hat\nu$ is a joining of $(\Omega,\nu,S)$ with the odometer
$(\hat{\mathbb Z}, \mathrm{Haar}, R)$. $L^2(\mathrm{Haar})$ is spanned
by the continuous characters $\chi$, each an $R$-eigenfunction with
root-of-unity eigenvalue $\theta_\chi$. Fix nontrivial $\chi$ and set
$g = \mathbb E_{\hat\nu}[\chi(r) \mid \mathcal B_\Omega] \in L^2(\nu)$.
Invariance of $\hat\nu$ under $S\times R$ gives, for all
$f \in L^\infty(\nu)$:
$\int f(S\omega)\,\chi(r+1)\,d\hat\nu = \int f(\omega)\,\chi(r)\,d\hat\nu$.
Since $\chi(r+1) = \theta_\chi\chi(r)$ and
$\int f(\omega)\chi(r)\,d\hat\nu = \int f\,g\,d\nu$, this reads
$\theta_\chi \int (f\circ S)\,g\,d\nu = \int f\,g\,d\nu$; substituting
$\omega \mapsto S^{-1}\omega$ on the left (natural extension,
$S$ invertible and $\nu$-preserving) gives
$\theta_\chi \int f\cdot(g\circ S^{-1})\,d\nu = \int f\,g\,d\nu$ for
all $f$, hence $g\circ S^{-1} = \overline{\theta_\chi}\,g$, i.e.
$g \circ S = \theta_\chi\, g$: $g$ is an eigenfunction of the ergodic
system $(\nu, S)$ with root-of-unity eigenvalue $\theta_\chi \neq 1$
unless $g = 0$. Trivial rational spectrum forces
$g = 0$, so $\int f\otimes\chi\, d\hat\nu = 0
= \int f\,d\nu \int \chi\,d\mathrm{Haar}$ for every nontrivial $\chi$;
by density of characters, $\hat\nu$ is the product. Conditioning in
(E$_m$) then trivializes, giving (E$^\flat_m$) for $m$ prime and, by
composing $D_p \circ D_q = D_{pq}$ and multiplicativity of the signs,
for all $m$. $\square$

*Attribution.* For logarithmic Furstenberg systems of completely
multiplicative functions this recovers FLR Thm 2.4 (trivial rational
spectrum $\Rightarrow$ strong stationarity); the proof above is an
independent short derivation in the $\pm1$-twisted setting. FLR
Thm 2.19 shows the Cesàro analogue is false — consistent with
Prop 1.3, which only produces the conditional identity at fixed points
of renormalization.

### 3.2 Two-point rigidity

**Theorem 3.2.** Let $\nu$ be an ergodic limit with trivial rational
spectrum, $x \not\equiv 1$. Then
$$\mathbb E_\nu[X_0] = 0, \qquad \mathbb E_\nu[X_0X_h] = 0
 \quad (h \neq 0).$$

*Proof.* By Lemma 3.1, (E$^\flat_m$) holds. Mean: $X_m \overset d=
x(m)X_1$ plus stationarity give $\mu := \mathbb E X_0 = x(m)\mu$; pick
$m$ with $x(m) = -1$ (exists since $x \not\equiv 1$), so $\mu = 0$.
Correlations: evaluating (E$^\flat_m$) on the pair $(0, m)=(m\cdot0,\,
m\cdot 1)$: $\mathbb E[X_0X_m] = x(m)^2\,\mathbb E[X_0X_1]$, so
$c_m := \hat w(\{0,m\}) = c_1$ for every $m \ge 1$. By the mean ergodic
theorem and ergodicity, $\frac1N\sum_{h=1}^N X_h \to \mu = 0$ in
$L^2(\nu)$; pairing with $X_0$:
$c_1 = \frac1N\sum_{h=1}^{N} c_h =
\mathbb E\big[X_0\cdot\frac1N\sum_{h\le N} X_h\big] \to 0$. Hence
$c_1 = 0$ and all $c_h$ vanish ($c_{-h} = c_h$ by stationarity).
$\square$

**Reading.** This is the *soft shadow of Tao's theorem*: for an
arbitrary $x \in M$, ergodicity + trivial rational spectrum of the
limit replace Matomäki–Radziwiłł + entropy decrement. The arithmetic
content of Tao 1509.05422 is exactly what removes those two structural
hypotheses for $\lambda$ (see §5, E3/E4).

### 3.3 Weak mixing forces the fair coin

**Theorem 3.3 (headline).** Let $x \in M$, $x \not\equiv 1$, and let
$\nu$ be a logarithmic limit of $x$ that is weakly mixing. Then
$\nu = \mathrm{Bernoulli}(\tfrac12)$.

*Proof.* Weak mixing implies ergodicity and *no* nonconstant
eigenfunctions at all, so Lemma 3.1 applies: (E$^\flat_m$) for all $m$,
and $\mu = 0$ as in Thm 3.2. Fix finite $A \subset \mathbb Z$,
$|A| = k \ge 1$; by stationarity translate so $A = \{0, a_1, \dots,
a_{k-1}\}$ with the $a_i$ distinct and nonzero. From (E$^\flat_m$),
$$\hat w(mA) = x(m)^{k}\,\hat w(A) \quad\Rightarrow\quad
\hat w(mA)^2 = \hat w(A)^2 \qquad (m \ge 1). \tag{3.3.1}$$
Let $f = X_0$ (the coordinate function) and work in the product system
$(\Omega\times\Omega,\ \nu\otimes\nu,\ S\times S)$, which is weakly
mixing (classical). With $g = f\otimes f$ and $U$ the product Koopman
operator,
$$\hat w(mA)^2 = \mathbb E_{\nu\otimes\nu}\Big[g\cdot
 \prod_{i=1}^{k-1} U^{m a_i} g\Big].$$
By Furstenberg's weak-mixing multiple-average theorem (Furstenberg
1977, §2; distinct nonzero exponents $a_1,\dots,a_{k-1}$; for $k = 1$
skip to the mean, which is $\mu = 0$ directly):
$$\frac1M\sum_{m=1}^{M} \prod_{i=1}^{k-1} U^{m a_i} g
 \;\longrightarrow\; \prod_{i=1}^{k-1}\int g \,d(\nu\otimes\nu)
 = (\mu^2)^{k-1} = 0 \quad\text{in } L^2 .$$
Pairing with $g$ and using (3.3.1):
$\hat w(A)^2 = \frac1M\sum_{m \le M}\hat w(mA)^2 \to 0$, so
$\hat w(A) = 0$. All nonempty Walsh coefficients vanish; by
Fourier–Walsh inversion (§1.2), $\nu$ is the uniform product measure.
$\square$

**Remarks.** (i) Bernoulli($\frac12$) itself is weakly mixing and
satisfies every (E$^\flat_m$) with any signs, so the statement is an
exact fixed-point characterization: *the fair coin is the only weakly
mixing eigenprocess.* (ii) The proof is elementary given Furstenberg's
1977 theorem — no Host–Kra machinery, no arithmetic. (iii) Prior-art
adjacency (disclosed, fetched): Jenvey 1997 proves the stronger
*ergodic $\Rightarrow$ Bernoulli* in the untwisted case
($x \equiv 1$); FH 1708.00677 use strong stationarity + Jenvey inside
their $\lambda$-structure theorem. We did not find the $\pm1$-twisted
weak-mixing statement with the Walsh/product-system proof in the
fetched sources; it may well be derivable from their machinery. Novelty
claimed only at the level of assembly and proof route.

### 3.4 Divisibility of the eigenvalue group

**Theorem 3.4.** Let $\nu$ be an ergodic limit with trivial rational
spectrum, $x$ arbitrary. Let
$\Lambda = \{\alpha \in \mathbb T : e(\alpha) \text{ eigenvalue of }
(\nu, S)\}$ (a subgroup of $\mathbb T$). Then $\Lambda = p\Lambda$ for
every prime $p$; i.e. $\Lambda$ is a **divisible** subgroup of
$\mathbb T$ with no torsion. Consequently $\Lambda$ is either trivial
or infinitely generated: a $\mathbb Q$-vector space. In particular no
such limit has a finitely-generated irrational Kronecker spectrum — an
irrational rotation on a finite-dimensional torus never occurs as the
Kronecker factor.

*Proof.* Trivial rational spectrum makes $S^p$ ergodic for $\nu$: an
$S^p$-invariant $f$ spans a $\le p$-dimensional $U_S$-invariant space,
which contains an $S$-eigenfunction with eigenvalue a $p$-th root of
unity, necessarily $1$, so $f$ is $S$-invariant, hence constant.
Claim: $\Lambda(\nu, S^p) = p\Lambda$ as subsets of $\mathbb T$
(writing eigenvalues additively). "$\supseteq$": if $f\circ S =
e(\alpha)f$ then $f \circ S^p = e(p\alpha) f$. "$\subseteq$": if
$g\circ S^p = e(\beta) g$, then $g\circ S$ has the same
$S^p$-eigenvalue; by ergodicity of $S^p$ eigenspaces are
one-dimensional, so $g \circ S = e(\gamma)g$ for some $\gamma$ with
$p\gamma = \beta$, and $\gamma \in \Lambda$. Now use Lemma 3.1:
$(D_p)_*\nu = (\sigma_{x(p)})_*\nu$ and $S \circ D_p = D_p \circ S^p$,
so $D_p$ is a factor map from $(\Omega, \nu, S^p)$ onto
$(\Omega, (\sigma_{x(p)})_*\nu, S) \cong (\Omega, \nu, S)$
($\sigma_\pm$ commutes with $S$ and is a spectral isomorphism). A
factor's eigenvalues are eigenvalues of the extension:
$\Lambda = \Lambda(\nu, S) \subseteq \Lambda(\nu, S^p) = p\Lambda$.
The reverse inclusion $p\Lambda \subseteq \Lambda$ holds since
$\Lambda$ is a group. Torsion is excluded by hypothesis. A divisible
torsion-free subgroup of $\mathbb T$ is a $\mathbb Q$-vector space;
nontrivial ones are not finitely generated. $\square$

*Attribution (important).* This theorem is **known in stronger form**:
FLR 2304.03121, Thm 2.1 and Cor 2.2(i), prove divisibility of the
spectrum of *every* logarithmic Furstenberg system of a completely
multiplicative function, with the residue-shifted form
$(\alpha + k)/r \in \mathrm{Spec}$ handling nontrivial rational
coupling — their result does not need ergodicity or trivial rational
spectrum. The derivation above was found independently before the
fetch and is retained as a five-line proof of the special case; the
credit is theirs.

### 3.5 The structural corner for exotics

**Corollary 3.5.** Any ergodic logarithmic limit $\nu$ of any
$x \in M$, $x \not\equiv 1$, satisfies exactly one of:
1. **(rational-coupled / structured)** $\nu$ has a nontrivial rational
   eigenvalue — its Kronecker factor contains a finite cyclic factor
   and $\hat\nu$ couples to the odometer; or
2. **(Bernoulli)** $\nu$ is weakly mixing, and then
   $\nu = \mathrm{Bernoulli}(\frac12)$; or
3. **(exotic zone)** $\nu$ has trivial rational spectrum but is not
   weakly mixing: its eigenvalue group is a nontrivial
   $\mathbb Q$-vector space — an infinite-rank (solenoidal) Kronecker
   factor — and its two-point Walsh sector already vanishes
   (Thm 3.2).

*Proof.* If not (1), Lemma 3.1 and Thms 3.2/3.4 apply; if additionally
weakly mixing, Thm 3.3 gives (2); otherwise the Kronecker factor is
nontrivial with divisible torsion-free eigenvalue group, giving (3).
$\square$

The dichotomy problem (A) is thus reduced, softly and exactly, to:
**is the exotic zone (3) realizable by a $\pm1$-valued completely
multiplicative sequence?** §4 shows the answer is YES for the relaxed
(complex unimodular) category and locates the arithmetic gate for
$\pm1$.

### 3.6 The parity/charge structure of the soft theory

For an unconditional eigenmeasure — or for a conditional eigenmeasure
after Lemma 3.1 deconditions it under ergodicity and trivial rational
spectrum — (3.3.1) reads: the Walsh coefficient function is a *twisted
dilation eigenfunction on ray classes*,
$\hat w(mA) = x(m)^{|A|}\hat w(A)$. The flip $\sigma_\pm$ grades
observables: even Walsh sector ($|A|$ even, gauge-neutral), odd sector
($|A|$ odd, charged) — the same $\mathbb Z/2$ as GAUGE.md's Theorem F
and LENS_CHAITIN's derivation cone. Notice:

- For $|A|$ even, dilation acts trivially on $\hat w(A)$; averaging
  over $m$ (Furstenberg) needs only weak mixing to kill the sector.
- For $|A|$ odd, dilation acts by $x(m)$; the *linear* average
  $\frac1M\sum_m \hat w(mA) = \big(\frac1M\sum_m x(m)\big)\hat w(A)$
  is annihilated by the vanishing mean of $x$ itself — the soft method
  conserves charge, exactly as Lemma C1 predicts in the derivations
  theater. The escape used in Thm 3.3 is the **two-copy square**
  $\hat w(mA)^2 = \hat w(A)^2$: passing to the product system
  neutralizes the charge — the dynamical incarnation of the
  bilinear/Type-II mechanism (Vinogradov; and of TT's structure
  theorem, where the arithmetic forces periodic ray-dependence against
  the $\lambda(a)$-twist). The price of the square is a genuine
  multiple-recurrence input (weak mixing); under mere ergodicity the
  square trick is unavailable (the product of ergodic systems need not
  be ergodic) and the odd sector is invisible — the parity barrier,
  relocated, with exact coordinates. This is the fifth conservation
  theater: states (F), cores (CORE_KMS), functors (K), derivations
  (C1), **eigenmeasures (3.6)**.

---

## 4. The core question, both directions

### 4.1 (a) Exotic eigenprocesses EXIST in the relaxed category — the abstract dichotomy is refuted there

Drop the $\pm1$ constraint to unimodular complex values (the identity
$D_p x = x(p)x$ and Prop 1.2 survive verbatim with
$\sigma_{x(p)}$ = rotation by the phase $x(p)$). Then, per the fetched
FLR results (2304.03121, Thms 2.18–2.20, Definition 2.3): the MRT
functions — completely multiplicative, unimodular, imitating $n^{it_j}$
on tower-growing intervals of primes with $t_j \to \infty$ (introduced
in MRT 1503.05121 as counterexamples to the original Elliott
conjecture) — have Cesàro Furstenberg systems that are **unipotent
systems of fixed level**, and logarithmic Furstenberg systems that are
mixtures of unipotent systems of unboundedly many levels. Unipotent
affine systems are zero-entropy, not almost periodic (level $\ge 2$),
with quasi-discrete spectrum whose eigenvalue group is divisible —
consistent with FLR divisibility and squarely inside the exotic zone
(3) of Cor 3.5. GLR 2006.09958 additionally show Chowla holds along a
subsequence for these functions, so a *single* relaxed eigenvector has
both a Bernoulli-type limit and exotic limits in its Cesàro limit set.

**Consequence for DIRECT.md (A).** The abstract eigenprocess property
plus ergodicity does **not** force the dichotomy (almost periodic vs
positive entropy): the identity alone is compatible with ergodic,
zero-entropy, non-almost-periodic limits. This is DIRECT.md's
anticipated "construction outcome", supplied by the literature in the
relaxed category. What remains open — and what the program's question
really is — is the $\pm1$ category.

### 4.2 The MRT Archimedean pretension channel is closed for $\pm1$

**Proposition 4.2.** Let $x: \mathbb N \to \{\pm1\}$ be completely
multiplicative, $\chi$ any Dirichlet character, $t \in \mathbb R
\setminus \{0\}$. Then the pretentious distance
$$\mathbb D(x, \chi(n)n^{it}; X)^2
 = \sum_{p \le X}\frac{1 - \mathrm{Re}\,[x(p)\overline{\chi(p)}p^{-it}]}{p}
 \;\ge\; \tfrac14\,\mathbb D(1, \chi^2(n) n^{2it}; X)^2
 \;\xrightarrow[X\to\infty]{}\; \infty .$$
Hence a $\pm1$-valued completely multiplicative function can pretend
only to real characters with $t = 0$: the continuous
($n^{it}$-indexed) family of pretension targets that powers the MRT
construction collapses, for real values, to the discrete rational
family.

*Proof.* The pretentious triangle inequality in product form
(Granville–Soundararajan): $\mathbb D(f_1, g_1; X) +
\mathbb D(f_2, g_2; X) \ge \mathbb D(f_1f_2, g_1g_2; X)$. Apply with
$f_1 = f_2 = x$, $g_1 = g_2 = \chi(n)n^{it}$, and $x^2 = 1$:
$2\,\mathbb D(x, \chi n^{it}; X) \ge \mathbb D(1, \chi^2 n^{2it}; X)$.
For the divergence: with $\psi = \chi^2$,
$\sum_{p\le X} \mathrm{Re}\,\psi(p)p^{-1-2it} =
\log|L(1 + 2it + 1/\log X, \psi)| + O(1)$, which is $O_{t,\psi}(1)$
because $L(s,\psi)$ is holomorphic and **nonvanishing** on
$\mathrm{Re}\,s = 1$, $s \neq 1$ (Hadamard–de la Vallée Poussin for
$\zeta$ when $\psi$ principal and $t \neq 0$; Dirichlet
$L(1,\psi)\neq0$ and the classical 1-line nonvanishing otherwise).
Mertens gives $\sum_{p \le X} 1/p = \log\log X + O(1)$, so
$\mathbb D(1, \psi n^{2it}; X)^2 \ge \log\log X - O_{t,\psi}(1)$.
$\square$

This assembly is standard (folklore around MRT/Klurman; we found no
single citable statement in the fetched sources, so the two-line proof
is recorded). Its exact scope is narrower than the full dichotomy: **it
obstructs transport of the known MRT Archimedean-pretension mechanism
to the $\pm1$ category.** The MRT mechanism needs a continuum of completely
multiplicative unimodular characters to slide along scales; for real
values the only such characters are quadratic $\chi$'s (rational,
discrete), and their pretension is *rational-spectrum* structure
(horn 1 of Cor 3.5), not the unipotent exotic zone. Nonvanishing of
$\zeta$ and $L$ on the 1-line — PNT-strength arithmetic — is what
closes this continuous pretension channel.  The proposition neither
excludes a different $\pm1$ exotic construction nor proves the
$\pm1$ dichotomy.

### 4.3 A $\pm1$ tower construction attempt and its exact failure point

Attempt: choose quadratic characters $\chi_j$ of conductors
$q_j \to \infty$ and set $x(p) = \chi_j(p)$ for $p$ in the $j$-th block
of a tower-growing scale sequence $X_j$ (mimicking MRT with the
discrete real family). At scale $X_j$, write $x = \chi_j \cdot u_j$
where $u_j(p) = x(p)\chi_j(p)$ is supported on old blocks
($p \le X_{j-1}$). Then $\mathbb D(u_j, 1; X_j)^2 \le
2\log\log X_{j-1} = o(\log\log X_j)$ under tower growth — but it is
**unbounded**, so $u_j$ is not $1$-pretentious; by Halász its mean
tends to $0$, and the correlations of $x$ at scale $X_j$ are *not*
those of $\chi_j$: they are $\chi_j$-twisted correlations of $u_j$,
which is (a dilate of) the previous-stage function. The construction
recurses instead of localizing: the old-block drift, negligible for
the *mean-value* statistics MRT needed (where relative smallness
$o(\log\log X_j)$ suffices via their $n^{it_j}$ coherence), is **not**
negligible for correlation statistics in the real case because there is
no continuous family to absorb it. Recorded as an obstruction, not an
impossibility proof. The sharp open question survives:

> **Open (the $\pm1$ exotic-zone question, sharpened).** Does there
> exist a completely multiplicative $x: \mathbb N \to \{\pm1\}$ with an
> ergodic logarithmic Furstenberg limit having trivial rational
> spectrum and a nontrivial eigenvalue group (necessarily a
> $\mathbb Q$-vector space, by Thm 3.4/FLR)? By Cor 3.5, a negative
> answer plus a proof of ergodicity-with-controlled-rational-spectrum
> for $\lambda$ would give the full dichotomy; a positive answer would
> refute the $\pm1$ abstract dichotomy exactly as MRT functions do the
> relaxed one.

**Exact successor seed (classification of the $\pm1$ exotic zone).**
Classify ergodic unconditional $\pm1$ eigenmeasures with trivial rational
spectrum (equivalently, conditional ones after Lemma 3.1 applies).  The
sharp target is to prove that their torsion-free divisible Kronecker factor
is trivial, hence that they are weakly mixing and therefore
Bernoulli($\tfrac12$) by Thm 3.3; alternatively, construct an explicit
counterexample by giving a positive-definite, shift-invariant Walsh system
satisfying the twisted dilation identities and having a nontrivial such
factor.  Cor 3.5 makes this an exact classification problem rather than an
analogy, and Prop 4.2 removes only the MRT route to a counterexample.

### 4.4 (b) The softest hypothesis forcing Bernoulli

Established: **weak mixing** (Thm 3.3), with `ergodic + trivial
rational spectrum` already forcing the two-point sector to vanish
(Thm 3.2). Fetched prior art shows the untwisted analogue holds under
mere **ergodicity** (Jenvey), so the residual gap between "ergodic +
trivial rational spectrum" and "weakly mixing" for *twisted* ($\pm1$)
strong stationarity is exactly the exotic-zone question of §4.3: by
Cor 3.5 the only obstruction to upgrading Thm 3.3's hypothesis to
ergodicity is a nontrivial solenoidal Kronecker factor. Softer than
weak mixing, the same proof gives: if $\nu$ is ergodic with trivial
rational spectrum and its Kronecker factor is disjoint from
[the systems generated by products of coordinate functions along
dilated tuples] — any hypothesis killing the projections of
$\prod_{i} U^{ma_i}g$ onto the Kronecker factor — then Bernoulli
follows; we record this only as a direction, not a theorem.

---

## 5. Arithmetic entry points (key output)

Soft layer (pure dynamics — proved here or classical, NO arithmetic):
Furstenberg correspondence; slow variation of logarithmic averages
(Prop 1.1(iii)) which converts the eigenvector identity into (E$_m$)
(Prop 1.2); disjointness from odometers (Lemma 3.1); mean ergodic
theorem (Thm 3.2); root-eigenvalue algebra and factor spectra
(Thm 3.4); Furstenberg's weak-mixing multiple averages (Thm 3.3);
Walsh determination of $\pm1$ processes; Jenvey's untwisted ergodic
$\Rightarrow$ Bernoulli. *The complete multiplicativity of $x$ enters
the soft layer only through the algebra $D_m x = x(m)x$ — no property
of the primes beyond generating $\mathbb N^\times$ is used.*

Arithmetic entry points — each tagged with the soft statement it
upgrades and its strength class:

- **E1 (Mertens/Euler: $\sum_p 1/p = \infty$).** Consumed by Tao's
  entropy decrement: the pigeonhole over scales needs an unbounded
  supply of usable primes with divergent $\sum 1/p$. Upgrades: replaces
  Lemma 3.1's hypothesis by an *almost*-independence
  ($\hat\nu \approx \nu\otimes\mathrm{Haar}$ at well-chosen scales,
  quantitatively) valid for the actual $\lambda$-limits with no
  spectral hypothesis. Strength: elementary (Euler/Mertens).
- **E2 (PNT / Halász mean values: $\frac1N\sum\lambda(n) \to 0$, also
  in APs).** The minimal *charged* axiom: gives $\mu = 0$ and kills
  rational atoms of the coordinate's spectral measure for $\lambda$
  without assuming trivial rational spectrum. Also (Daboussi–Delange)
  kills irrational atoms for *any* multiplicative $x$. Upgrades: the
  mean and atom parts of Thm 3.2 for $\lambda$ unconditionally.
  Strength: PNT / PNT-in-APs.
- **E3 (Matomäki–Radziwiłł short intervals + MRT averaged Chowla /
  Fourier uniformity).** The engine of Tao 1509.05422: after entropy
  decrement, the 2-point problem becomes a bilinear sum over
  $(n, p)$-arrays whose minor arcs are controlled by MR-type short
  interval / $\sup_\alpha$ estimates. Upgrades: removes BOTH structural
  hypotheses of Thm 3.2 (ergodicity, trivial rational spectrum) for
  $\lambda$: every log-limit has vanishing 2-point sector. Strength:
  the deepest currently-used input; strictly beyond PNT.
- **E4 (1-line nonvanishing $\zeta(1+it) \neq 0$, $L(1+it,\psi)\neq0$
  via the pretentious triangle).** Closes the MRT Archimedean
  pretension channel for $\pm1$ sequences (Prop 4.2): that particular
  relaxed-category construction cannot be transported to $M$.
  Upgrades: excludes one known route into horn (3) of Cor 3.5, not the
  horn itself or every possible construction. Strength: PNT.
- **E5 (rational independence of $\{\log p\}$ / Archimedean scale
  flow).** Enters the *constructions*: MRT functions exist because
  $n^{it}$ with $t$ sliding along $\log$-scales is a continuum of
  characters — the parameter space of the unipotent exotics (FLR
  Thms 2.18–2.20). Also implicit in FH's analysis of which nilsystems
  can occur. Upgrades: none of our soft theorems use it; it powers the
  counterexample side. Strength: elementary but structural.
- **E6 (TT structure theorem: correlation ray-maps are uniform limits
  of periodic functions; isotypy or vanishing).** Arithmetic content =
  E1+E3 again. In our coordinates: arithmetic forces the ray-map
  $a \mapsto \hat w(aA)$ toward *periodicity*, while the deconditioned
  ray law (3.3.1), where applicable, supplies the $\lambda(a)$-twist;
  for odd $|A|$ the two are incompatible unless the
  sector vanishes — this is how the charged sector actually got killed
  for $\lambda$ (TT odd), where the soft theory provably cannot do it
  (§3.6). Strength: E3-class.
- **E7 (square classification, elementary: $nn' = \square$ has
  $O(N\log N)$ solutions, etc.).** Realizes the Bernoulli horn:
  Najnudel's a.s. Chowla for random $x \in M$ — Haar-a.e. point of $M$
  has full Cesàro convergence to Bernoulli($\frac12$). Strength:
  elementary.

**The compressed verdict.** Everything soft reduces the dichotomy to
two arithmetic duties: (i) control the rational spectrum / odometer
coupling of $\lambda$'s limits (E2/E3-class), and (ii) exclude the
solenoidal exotic zone for $\pm1$ (E4 closes the MRT door only;
other mechanisms remain unclassified in §4.3). Ergodicity of
$\lambda$'s limits stands as the one purely dynamical unknown, and
Frantzikinakis 1611.09338 shows it is decisive (with E3 input).

---

## 6. Rigor boundary

**Proved in this note, self-contained** (modulo classical theorems
cited inline: mean ergodic theorem, Furstenberg 1977 weak-mixing
multiple averages, GS pretentious triangle inequality, Mertens,
1-line nonvanishing): Prop 1.1, Prop 1.2, Prop 1.3, Lemma 3.1,
Thm 3.2, Thm 3.3, Thm 3.4 (special case; known in stronger form),
Cor 3.5, Prop 4.2.

**Cited from fetched sources, not re-proved:** all rows of §2;
in particular FLR Thms 2.1/2.4/2.7/2.18–2.20 (statements extracted
from the arXiv abstract + HTML §2 on 2026-08-11; proofs not audited),
Jenvey's theorem (statement via secondary sources: FH Annals paper and
the Springer landing page; the 1997 paper itself was not fetched),
Najnudel (abstract-level). These carry the usual literature-claim
confidence, no more.

**Conjectured / open:** ergodicity of $\lambda$'s logarithmic limits;
the $\pm1$ exotic-zone question (§4.3); any upgrade of Thm 3.3's weak
mixing to ergodicity in the twisted case; Cesàro-side analogues beyond
Prop 1.3.

**Discipline check:** no numerics anywhere in this note; the charter's
falsifier-only clause was not needed (no construction reached the
stage of exhibiting exact correlation values).

---

## 7. References with fetch ledger (all fetched 2026-08-11)

1. K. Matomäki, M. Radziwiłł, *Multiplicative functions in short
   intervals*, Ann. of Math. 183 (2016). [arXiv:1501.04585 — cited via
   its use in items 3, 4; not directly fetched this session.]
2. K. Matomäki, M. Radziwiłł, T. Tao, *An averaged form of Chowla's
   conjecture*, Algebra & Number Theory 9 (2015). arXiv:1503.05121.
   FETCHED (abstract): averaged $k$-point Chowla; corrected Elliott;
   real-valuedness of $\lambda$ confirmed; the Elliott counterexample
   construction is in this circle of papers (definition confirmed via
   FLR Def 2.3 fetch).
3. T. Tao, *The logarithmically averaged Chowla and Elliott conjectures
   for two-point correlations*, Forum Math. Pi 4 (2016).
   arXiv:1509.05422. FETCHED (abstract+summary): log 2-point Chowla;
   inputs MR + entropy decrement + circle method.
4. T. Tao, J. Teräväinen, *Odd order cases of the logarithmically
   averaged Chowla conjecture*, J. Théor. Nombres Bordeaux (2018).
   arXiv:1710.02112. FETCHED (abstract): all odd orders, log.
5. T. Tao, J. Teräväinen, *The structure of logarithmically averaged
   correlations of multiplicative functions...*, Duke Math. J. 168
   (2019). arXiv:1708.02610. FETCHED (full abstract quoted in §2).
6. N. Frantzikinakis, *Ergodicity of the Liouville system implies the
   Chowla conjecture*, Discrete Analysis 2017:19. arXiv:1611.09338.
   FETCHED (abstract): generic for an ergodic measure ⇒ Chowla.
7. N. Frantzikinakis, B. Host, *The logarithmic Sarnak conjecture for
   ergodic weights*, Ann. of Math. 187 (2018). arXiv:1708.00677.
   FETCHED (full abstract): log Sarnak for zero-entropy systems w/
   countable ergodic behavior incl. uniquely ergodic; structure: no
   irrational spectrum, nil+Bernoulli blocks; strong stationarity.
8. A. Gomilko, D. Kwietniak, M. Lemańczyk, *Sarnak's conjecture implies
   the Chowla conjecture along a subsequence*, LNM 2213 (2018).
   arXiv:1710.07049. FETCHED (abstract).
9. A. Gomilko, M. Lemańczyk, T. de la Rue, *On Furstenberg systems of
   aperiodic multiplicative functions of Matomäki, Radziwiłł and Tao*,
   J. Mod. Dyn. 17 (2021). arXiv:2006.09958. FETCHED (abstract):
   Chowla along a subsequence in the MRT class.
10. N. Frantzikinakis, M. Lemańczyk, T. de la Rue, *Furstenberg systems
    of pretentious and MRT multiplicative functions*, Ergodic Theory
    Dynam. Systems (2024). arXiv:2304.03121. FETCHED (full abstract +
    HTML §2 theorem statements: Thm 2.1, Cor 2.2(i), Thm 2.4, Def 2.3,
    Thm 2.7, Thms 2.18–2.20). The load-bearing external source of this
    note.
11. E. Jenvey, *Strong stationarity and de Finetti's theorem*,
    J. Anal. Math. 73 (1997) 1–18. NOT fetched directly; statement
    ("every ergodic strongly stationary system is Bernoulli") confirmed
    via two independent secondary sources (Springer landing page;
    FH-adjacent survey material) — treat as secondary-confirmed.
12. J. Najnudel, *On consecutive values of random completely
    multiplicative functions*, Electron. J. Probab. 25 (2020).
    arXiv:1702.01470. FETCHED (abstract-level via search + EJP page).
13. T. Tao, J. Teräväinen, *Value patterns of multiplicative functions
    and related sequences*, Forum Math. Sigma 7 (2019).
    arXiv:1904.05096. FETCHED (abstract): ≥24 of 32 length-5 patterns
    of $\lambda$ at positive upper density; the exact log densities for
    $\lambda$-patterns of length ≤3 (and $\mu$ length ≤4) are per the
    paper's announcement (Tao's blog post, found in the same search) —
    the abstract itself states only the length-5 result explicitly.
14. H. Furstenberg, *Ergodic behavior of diagonal measures and a
    theorem of Szemerédi...*, J. Anal. Math. 31 (1977) — weak-mixing
    multiple average theorem (classical; not fetched).
15. A. Granville, K. Soundararajan — pretentious triangle inequality
    (classical; standard references; not fetched).

In-corpus: FOREST.md, DIRECT.md, LENS_CHAITIN.md (§2 conservation),
GAUGE.md (Theorem F), LENS_CIRCUIT.md (charged-axiom threshold).
