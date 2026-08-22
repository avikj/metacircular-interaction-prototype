# The divisor-lattice charge polynomial and the Chen primitive-boundary functional

**Build worker, 2026-08-16. Queue item Q3 of `notes/D0026_BUILD_QUEUE.md`
(⊢ import). Source: `collab/upstream/raw/D0026-owner-egb-core-transmission-v2-2026-08-16.md`
§5.5 and §5.9, with §5.2 and §5.11 as surrounding context. The source is a
chat-mangled transmission; nothing below is copied. Every identity was
re-derived from scratch in this session and then compared against the
transmitted form. Disagreements found: none (see §5). Finite instances were
verified by exact integer computation (bash, exhaustive over divisors — no
floating point). Status: both objects PROVE-discharged as elementary exact
identities; the placement claim is SEARCH-pending (§6); the analytic content
that would make either object *do* anything (anti-saturation) is explicitly
NOT claimed (§4.4).**

Notation, fixed once: for $n \ge 1$, $\Omega(n)$ is the number of prime
factors with multiplicity (completely additive: $\Omega(mn) = \Omega(m) +
\Omega(n)$), $\omega(n)$ the number of distinct prime factors, $\mu$ the
Möbius function, $\lambda(n) = (-1)^{\Omega(n)}$ the Liouville function,
$\mu(n)^2 = \mathbf 1_{n\ \text{squarefree}}$, and $\mathbf 1_{\mathbb P}$
the prime indicator.

---

## 1. Object A — the divisor-lattice characteristic polynomial

### 1.1 Statement

For $n \ge 1$ define

$$\Phi_n(t) \;=\; \sum_{d \mid n} \mu(n/d)\, t^{\Omega(d)}.$$

**Theorem A.**
$$\Phi_n(t) \;=\; t^{\Omega(n)-\omega(n)}\,(t-1)^{\omega(n)}.$$

(For $n = 1$ both sides are $1$, reading the empty products as $1$.)

### 1.2 Proof

*Step 1 (multiplicativity).* $\Phi_n(t)$, as an arithmetic function of $n$
with values in $\mathbb Z[t]$, is the Dirichlet convolution $\mu * t^{\Omega}$.
Since $\Omega$ is completely additive, $n \mapsto t^{\Omega(n)}$ is
(completely) multiplicative; $\mu$ is multiplicative; and the Dirichlet
convolution of multiplicative functions is multiplicative. Hence for
$n = \prod_p p^{a_p}$,

$$\Phi_n(t) \;=\; \prod_{p^{a_p} \parallel n} \Phi_{p^{a_p}}(t).$$

*Step 2 (prime powers: the sum telescopes).* Let $n = p^a$, $a \ge 1$. The
divisors are $d = p^j$, $0 \le j \le a$, and $\mu(p^{a-j})$ vanishes unless
$a - j \in \{0, 1\}$. Exactly two terms survive:

$$\Phi_{p^a}(t) \;=\; \mu(1)\,t^{\Omega(p^a)} + \mu(p)\,t^{\Omega(p^{a-1})}
\;=\; t^a - t^{a-1} \;=\; t^{a-1}(t-1).$$

*Step 3 (reassembly).* Multiplying over the $\omega(n)$ prime-power blocks,

$$\Phi_n(t) \;=\; \prod_p t^{a_p - 1}(t-1)
\;=\; t^{\sum_p (a_p - 1)}\,(t-1)^{\omega(n)}
\;=\; t^{\Omega(n)-\omega(n)}(t-1)^{\omega(n)}. \qquad\blacksquare$$

### 1.3 Corner evaluations (three independent sanity locks)

Each classical special case falls out of both sides and they agree, which
locks the formula against transcription error:

| $t$ | left side $\sum_{d\mid n}\mu(n/d)t^{\Omega(d)}$ | closed form | classical identity |
|---|---|---|---|
| $t=0$ | only $d=1$ survives: $\mu(n)$ | $0$ if $\Omega>\omega$, else $(-1)^{\omega}$ | $\mu(n)$, both readings |
| $t=1$ | $\sum_{d\mid n}\mu(n/d) = \mathbf 1_{n=1}$ | $(1-1)^{\omega(n)} = 0$ for $n>1$ | Möbius column sum |
| $t=-1$ | $(\mu * \lambda)(n)$ | $(-1)^{\Omega-\omega}(-2)^{\omega} = \lambda(n)\,2^{\omega(n)}$ | $\mu*\lambda = \lambda\cdot 2^{\omega}$ |

### 1.4 Consequence: fixed-charge kernels and the two-charge split

Write the coefficients as

$$\Phi_n(t) \;=\; \sum_{r \ge 0} \kappa_r(n)\, t^r,
\qquad
\kappa_r(n) \;=\; \sum_{\substack{d \mid n \\ \Omega(d) = r}} \mu(n/d).$$

By construction $\kappa_r = \mu * \mathbf 1_{\Omega = r}$, so Möbius
inversion gives the **fixed-charge partition of unity**

$$\sum_{d \mid n} \kappa_r(d) \;=\; \mathbf 1_{\Omega(n) = r},
\qquad\text{equivalently}\qquad
\sum_{d \mid n} \Phi_d(t) = t^{\Omega(n)}.$$

This is what makes $\kappa_r$ consumable: it converts the fixed-charge
condition $\Omega(n) = r$ into a divisor sum, which is the engine of the
transmitted §5.6 CRT boundary operator
$C_{r,t}(X;h) = \sum_{d,e} \kappa_r(d)\kappa_t(e) N_X(d,e;h)$.

From Theorem A, the kernels are explicit binomials. Set

$$R(n) = \Omega(n) - \omega(n) \quad (\text{repeated-prime excess}),
\qquad
W(n) = \omega(n) \quad (\text{distinct-prime count}),$$

so that $\Omega = R + W$ — the **two-charge split**. Then
$\Phi_n(t) = t^{R(n)}(t-1)^{W(n)}$ and

$$\kappa_r(n) \;=\; (-1)^{\,\Omega(n) - r}\binom{\omega(n)}{\,r - R(n)\,},
\qquad R(n) \le r \le \Omega(n),$$

and $\kappa_r(n) = 0$ outside that range. In particular
$\sum_r |\kappa_r(n)| = 2^{\omega(n)}$ and the support of $\Phi_n$ in the
charge variable is the interval $[R(n), \Omega(n)]$ of length $\omega(n)$:
the polynomial *separates* the two charges — $R$ appears only as a
monomial shift, $W$ only as the $(t-1)$-degree. (The transmitted §5.5 draws
the analytic consequence via the bivariate Euler product
$\mathcal F(u,v;s) = \prod_p \frac{1+(v-u)p^{-s}}{1-up^{-s}}$; I re-derived
the local factor — $\sum_{a\ge0} u^{\max(a-1,0)} v^{\mathbf 1_{a\ge1}} p^{-as}
= 1 + \frac{vp^{-s}}{1-up^{-s}}$ — and it agrees, but that product is
*context*, not one of the two imported objects.)

*Lattice-theoretic reading (justifying the transmitted name).* The divisor
lattice of $n$ is graded by $\Omega$, with $\hat 0 = 1$, $\hat 0$-based
Möbius function $\mu(1, d) = \mu(d)$, and rank $\Omega(n)$. Rota's
characteristic polynomial of a finite graded lattice is
$p_L(t) = \sum_{x \in L} \mu(\hat 0, x)\, t^{\mathrm{rk}(L) - \mathrm{rk}(x)}$;
here, substituting $d \mapsto n/d$ and using complete additivity
$\Omega(n) - \Omega(n/d) = \Omega(d)$,
$$p_{D_n}(t) = \sum_{d \mid n} \mu(d)\, t^{\Omega(n) - \Omega(d)}
= \sum_{d \mid n} \mu(n/d)\, t^{\Omega(d)} = \Phi_n(t).$$
So Theorem A is literally the characteristic polynomial of a product of
chains: each chain of length $a$ contributes $t^{a-1}(t-1)$. The name
"divisor-lattice characteristic polynomial" in the transmission is exact,
not decorative.

### 1.5 Exact instances — finite verification tables

All tables computed by hand and re-verified by exhaustive exact integer
summation over all divisors (no closed form used in the check).

**$n = 12 = 2^2\cdot 3$** ($\Omega = 3$, $\omega = 2$, $R = 1$). Surviving
terms ($\mu(12/d) \ne 0$):

| $d$ | $12/d$ | $\mu(12/d)$ | $\Omega(d)$ | term |
|---|---|---|---|---|
| $2$ | $6$ | $+1$ | $1$ | $+t$ |
| $4$ | $3$ | $-1$ | $2$ | $-t^2$ |
| $6$ | $2$ | $-1$ | $2$ | $-t^2$ |
| $12$ | $1$ | $+1$ | $3$ | $+t^3$ |

$$\Phi_{12}(t) = t^3 - 2t^2 + t = t\,(t-1)^2. \qquad
(\kappa_1,\kappa_2,\kappa_3) = (1,-2,1).$$

**$n = 30 = 2\cdot 3\cdot 5$** ($\Omega = \omega = 3$, $R = 0$; squarefree,
all eight divisors survive):

| $d$ | $1$ | $2$ | $3$ | $5$ | $6$ | $10$ | $15$ | $30$ |
|---|---|---|---|---|---|---|---|---|
| $\mu(30/d)$ | $-1$ | $+1$ | $+1$ | $+1$ | $-1$ | $-1$ | $-1$ | $+1$ |
| $\Omega(d)$ | $0$ | $1$ | $1$ | $1$ | $2$ | $2$ | $2$ | $3$ |

$$\Phi_{30}(t) = t^3 - 3t^2 + 3t - 1 = (t-1)^3. \qquad
(\kappa_0,\ldots,\kappa_3) = (-1,3,-3,1).$$

**$n = 360 = 2^3\cdot 3^2\cdot 5$** ($\Omega = 6$, $\omega = 3$, $R = 3$).
Surviving $d$ are those with $360/d$ squarefree, i.e.
$360/d \in \{1,2,3,5,6,10,15,30\}$:

| $d$ | $360$ | $180$ | $120$ | $72$ | $60$ | $36$ | $24$ | $12$ |
|---|---|---|---|---|---|---|---|---|
| $\mu(360/d)$ | $+1$ | $-1$ | $-1$ | $-1$ | $+1$ | $+1$ | $+1$ | $-1$ |
| $\Omega(d)$ | $6$ | $5$ | $5$ | $5$ | $4$ | $4$ | $4$ | $3$ |

$$\Phi_{360}(t) = t^6 - 3t^5 + 3t^4 - t^3 = t^3(t-1)^3. \qquad
(\kappa_3,\ldots,\kappa_6) = (-1,3,-3,1).$$

**Evaluation checksums** (each computed twice: raw divisor sum and closed
form; all agree):

| | $t=2$ | $t=3$ | $t=5$ |
|---|---|---|---|
| $\Phi_{12}$ | $2$ | $12$ | — |
| $\Phi_{30}$ | $1$ | $8$ | — |
| $\Phi_{360}$ | $8$ | $216$ | $8000$ |

**Partition-of-unity checksums** ($\sum_{d\mid n}\Phi_d(t) = t^{\Omega(n)}$):
$\sum_{d \mid 360} \Phi_d(2) = 64 = 2^6$; $\sum_{d \mid 12} \Phi_d(3) = 27 = 3^3$.
Both verified exhaustively.

---

## 2. Object B — the Chen-envelope prime projector

### 2.1 Statement

The **Chen envelope** (the $P_2$ window) is the set of integers $N$ with
$1 \le \Omega(N) \le 2$: exactly the primes $p$, the prime squares $p^2$,
and the distinct semiprimes $pq$ ($p \ne q$).

**Theorem B.** For every $N$ with $1 \le \Omega(N) \le 2$,

$$\mathbf 1_{\mathbb P}(N)
\;=\; \mu(N)^2 - \bigl(\omega(N) - 1\bigr)
\;=\; \frac{1 - \lambda(N)}{2}.$$

### 2.2 Proof (exhaustive three-case table)

The envelope has exactly three shapes; a finite table is a complete proof:

| $N$ | $\Omega$ | $\mu^2$ | $\omega - 1$ | $\mu^2 - (\omega-1)$ | $\lambda$ | $\tfrac{1-\lambda}{2}$ | $\mathbf 1_{\mathbb P}$ |
|---|---|---|---|---|---|---|---|
| $p$ | $1$ | $1$ | $0$ | $1$ | $-1$ | $1$ | $1$ |
| $p^2$ | $2$ | $0$ | $0$ | $0$ | $+1$ | $0$ | $0$ |
| $pq,\ p \ne q$ | $2$ | $1$ | $1$ | $0$ | $+1$ | $0$ | $0$ |

All three columns agree in every row. $\blacksquare$

The second equality is shallow on its own ($\tfrac{1-\lambda}{2} =
\mathbf 1_{\Omega \text{ odd}}$, and on $\Omega \le 2$, odd charge = charge
one = prime). The content of Theorem B is the *first* equality: inside the
envelope, primality is detected by two sieve-native quantities — the
squarefree indicator $\mu^2$ and the additive defect $\omega - 1$
(the transmitted "first primitive multiplicity" $\pi_1(N) = \omega(N)-1$,
the number of primitive relative factor directions). A prime is what
remains when the square channel ($\mu^2$ kills $p^2$) and the relative
channel ($\pi_1$ kills $pq$) are both subtracted. Equivalently, the three
projectors $\Pi_{\mathrm{prime}} = \tfrac{1-\lambda}{2}$,
$\Pi_{\mathrm{sq}} = \tfrac{1+\lambda}{2}(1-\mu^2)$,
$\Pi_{\mathrm{rel}} = \tfrac{1+\lambda}{2}\mu^2$ sum to $1$ (identically,
in fact) and on the envelope are exactly the indicators of the three rows.

### 2.3 The primitive boundary functional

For a finite indexed family (multiset) $E$ of integers, define

$$\Delta(E) \;=\; \sum_{N \in E} \mu(N)^2 \;-\; \sum_{N \in E} \bigl(\omega(N) - 1\bigr).$$

**Corollary B1 (envelope counting).** If every $N \in E$ satisfies
$1 \le \Omega(N) \le 2$, then
$$\Delta(E) \;=\; \#\{\,N \in E : N \text{ prime}\,\}$$
(counted with multiplicity of the indexing). *Proof:* sum Theorem B over
$E$. $\blacksquare$

**Lemma B2 (primes survive completion).** If $N$ is prime then
$\Omega(N) = 1$, so $N$ lies in the envelope. Hence intersecting *any*
family with the envelope condition $\Omega \le 2$ discards no primes.
$\blacksquare$

These two trivialities compose into the two exact counting statements. Fix
$x \ge 1$ and an even $M \ge 4$.

**Theorem B3 (radius-one dyadic Chen slice).** Let
$$E_x \;=\; \{\, p + 2 \;:\; p \text{ prime},\ x < p \le 2x,\ \Omega(p+2) \le 2 \,\},$$
indexed by $p$ (the map $p \mapsto p+2$ is injective, so this is an honest
set). Then
$$\Delta(E_x) \;=\; \#\{\, p \in (x, 2x] : p \text{ and } p+2 \text{ both prime}\,\},$$
the full count of twin pairs with lower member in the dyadic window —
*full*, not just within-slice, because by Lemma B2 the restriction
$\Omega(p+2) \le 2$ discards no $p$ with $p + 2$ prime. ($\Omega(p+2)\ge1$
is automatic since $p + 2 \ge 4$.) *Proof:* Corollary B1 plus Lemma B2.
$\blacksquare$

**Theorem B4 (Chen-completed Goldbach center fiber).** Let
$$E_M \;=\; \{\, M - p \;:\; p \text{ prime},\ 2 \le p \le M-2,\ \Omega(M-p) \le 2 \,\},$$
indexed by $p$ (again injective). Then
$$\Delta(E_M) \;=\; \#\{\, p \text{ prime},\ p \le M-2 : M - p \text{ prime}\,\},$$
the number of *ordered* representations $M = p + q$ with $p, q$ prime.
*Proof:* identical. $\blacksquare$

**Micro-instances (exact, checked by hand).**

- $x = 10$: primes in $(10, 20]$ are $11, 13, 17, 19$; the values $p+2$
  are $13\ (\Omega{=}1)$, $15 = 3\cdot5\ (pq)$, $19\ (\Omega{=}1)$,
  $21 = 3\cdot 7\ (pq)$ — all in the envelope, none discarded.
  $\Delta = (1{+}1{+}1{+}1) - (0{+}1{+}0{+}1) = 2$, and the twin pairs with
  lower member in $(10,20]$ are exactly $(11,13), (17,19)$: two. ✓
- $M = 30$: over primes $p \le 28$, the values $M - p$ are $28 = 2^2\cdot 7$
  ($\Omega = 3$, discarded by completion), $27 = 3^3$ (discarded),
  $25 = 5^2$, $23, 19, 17, 13, 11, 7$. On the completed fiber
  $\Delta = 6 - 0 = 6$, and $30$ has exactly the six ordered prime
  representations $7{+}23, 11{+}19, 13{+}17, 17{+}13, 19{+}11, 23{+}7$. ✓
  (Note the discarded $28, 27$ are composite — Lemma B2 in action.)

### 2.4 SCOPE FENCE

This fence is the note; read it before consuming anything above.

1. **What "Chen-completed" must mean.** The identity
   $\Delta(E) = \#\text{primes in } E$ is exact **iff every element of $E$
   lies in the envelope** $1 \le \Omega \le 2$. "Chen-completed" therefore
   means, precisely: *the full fiber* ($\{p+2\}$ over all primes in the
   window, resp. $\{M-p\}$ over all primes $p \le M-2$) *intersected with
   the envelope condition* $\Omega \le 2$. Both halves are load-bearing:
   the intersection is needed because $\mu^2 - (\omega - 1)$ is **not**
   the prime indicator outside the envelope, and starting from the full
   fiber is needed so that (Lemma B2) no primes are lost, which is what
   upgrades "primes in the slice" to the *full* twin/Goldbach count.
   Failure values outside the envelope, for the record:

   | $N$ | $\mu^2 - (\omega - 1)$ | $\mathbf 1_{\mathbb P}$ |
   |---|---|---|
   | $1$ | $2$ | $0$ |
   | $p^3, p^4, \ldots$ | $0$ | $0$ (agreement is accidental) |
   | $p^2 q$ | $-1$ | $0$ |
   | $pqr$ | $-1$ | $0$ |

   A single stray $p^2q$ or $pqr$ in $E$ silently subtracts one from the
   count. The envelope check is not optional hygiene; it is the theorem.

2. **The identities are counting reformulations, not progress.** Twin
   primes in $(x, 2x]$ for all $x$ $\iff$ $\Delta(E_x) > 0$ for all $x$;
   Goldbach for $M$ $\iff$ $\Delta(E_M) > 0$. This transfers the
   conjectures onto positivity of one functional on transverse families —
   a *placement*, with the merit that both target sums
   ($\sum_E \mu^2$: squarefree counting; $\sum_E \pi_1$: an additive-
   function sum) are individually the kind of object sieve theory
   addresses. The parity obstruction is not evaded: it now lives,
   undiminished, in the *difference* of the two sums.

3. **What is open and NOT claimed here.** Chen (1973) gives
   $|E_x| \gg x/\log^2 x$ and $|E_M| \gg M/\log^2 M$ (lower bounds on the
   envelope population), which bounds the *sum* of the channels, not the
   difference. Positivity of $\Delta$ is exactly the statement that the
   primitive relative channel $\Pi_{\mathrm{rel}}$ (distinct semiprimes)
   does not saturate the Chen field: if twins were finite, $pq$ would
   asymptotically carry all of $E_x$'s mass. The missing ingredient is an
   independently sourced **anti-saturation estimate** for the conditional
   primitive-relative mass ($\sum_{E}\pi_1 < \sum_E \mu^2$ on the
   completed fibers). No such estimate is proved, sketched, or implied in
   this note, and any downstream text citing this note as evidence toward
   twin primes or Goldbach is misciting it.

4. **Multiset discipline.** $\Delta$ is defined on indexed families. In
   B3/B4 the indexing maps happen to be injective; a consumer building
   other slices (e.g. several shifts at once) must either keep the index
   or re-verify injectivity, since $\Delta$ counts with multiplicity.

---

## 3. Why these two, together

Both objects are charge-sector statements about the same grading
$C\lvert n\rangle = \Omega(n)\lvert n\rangle$ (transmitted §5.11): Theorem A
is the Möbius-dual basis for the fixed-charge sectors $\{\Omega = r\}$
(its $\kappa_r$ are exactly the kernels the §5.6 CRT boundary operator and
the §5.11 fugacity-propagator facets consume), and Theorem B is the
charge-one projector written in sieve variables after the envelope
restriction $\Omega \le 2$ — the restriction that Chen's theorem makes
population-nonempty. Object A supplies the vocabulary in which fixed-charge
correlation sums become divisor sums; Object B says what, in that
vocabulary, remains between a Chen bound and a prime-pair theorem.

---

## 4. Re-derivation vs. transmission: disagreement report

Per queue instruction, nothing transmitted was trusted; the comparison
after independent derivation:

- **§5.5 $\Phi_n$:** transmitted closed form, coefficient claim, and
  two-charge separation all confirmed. The transmitted bivariate Euler
  product $\mathcal F(u,v;s)$ was also independently re-derived and
  confirmed (local factor computation in §1.4).
- **§5.9 projector:** transmitted three-case table, the identity
  $\mathbf 1_{\mathbb P} = \mu^2 - \pi_1 = \tfrac{1-\lambda}2$ on $P_2$,
  the three-channel partition $\Pi_{\mathrm{prime}} + \Pi_{\mathrm{sq}} +
  \Pi_{\mathrm{rel}} = 1$, and the twin/Goldbach readings of $\Delta$ all
  confirmed. One sharpening made here that the transmission leaves
  implicit: the *full-count* (not slice-count) property of $\Delta$
  requires Lemma B2, i.e. that completion discards no primes; stated and
  proved above because the exactness claim is false without it.
- **Mangling observed:** LaTeX table row-breaks and aligned equations in
  the source are corrupted (e.g. the §5.9 case table renders as one run-on
  line); no *mathematical* corruption was detected at any point checked.
- The transmission's own Δ-correction in §5.2 ($z^{\Omega}\rvert_{z=0} =
  \mathbf 1_{n=1}$, not the prime indicator; primes are the $[z^1]$
  coefficient) is consistent with everything here and is the same
  envelope-discipline moral as §2.4.1.

## 5. Finite verification inventory (what was actually checked, and how)

Exact integer arithmetic only (bash, exhaustive loops over divisors);
every number below is a checked equality between the raw Möbius sum and
the closed form, or a hand-verified count:

- $\Phi_{12}(2) = 2$, $\Phi_{12}(3) = 12$, $\Phi_{30}(2) = 1$,
  $\Phi_{30}(3) = 8$, $\Phi_{360}(2) = 8$, $\Phi_{360}(3) = 216$,
  $\Phi_{360}(5) = 8000$;
- $\sum_{d \mid 360} \Phi_d(2) = 64 = 2^{\Omega(360)}$,
  $\sum_{d \mid 12} \Phi_d(3) = 27 = 3^{\Omega(12)}$;
- coefficient vectors $\kappa(12) = (0,1,-2,1)$,
  $\kappa(30) = (-1,3,-3,1)$, $\kappa(360) = (0,0,0,-1,3,-3,1)$
  (index $r = 0$ upward);
- twin micro-instance $\Delta(E_{10}) = 2$; Goldbach micro-instance
  $\Delta(E_{30}) = 6$.

Both theorems are ideal `refl`-certificate material (finite tables +
one general lemma each) per the Q3 obligation; the Agda landing is left to
a toolchain-bearing session — per queue §0, a green here would be a rumour.

## 6. Prior art — NO novelty claimed for components

- **Chen Jing-run,** *On the representation of a larger even integer as the
  sum of a prime and the product of at most two primes*, Sci. Sinica 16
  (1973), 157–176: the $P_2$ theorems that make the envelope populated;
  everything called "Chen" above refers to this.
- $\mu * t^{\Omega}$ at prime powers, $\tfrac{1-\lambda}2 =
  \mathbf 1_{\Omega \text{ odd}}$, $\mu * \lambda = \lambda\,2^{\omega}$,
  and $\mu^2$/$\lambda$ manipulations are standard multiplicative number
  theory (any treatment of Liouville/Möbius identities, e.g.
  Iwaniec–Kowalski ch. 1; the parity barrier framing is Selberg's).
- $\Phi_n$ as characteristic polynomial of the divisor lattice (product of
  chains) is classical combinatorics: Rota, *On the foundations of
  combinatorial theory I* (1964); Stanley, *Enumerative Combinatorics* vol. 1.
- Every component identity above is elementary and surely known. The only
  candidate novelty is the *placement*: $\Delta$ as one positive functional
  whose positivity on two transverse Chen-completed families is
  simultaneously twins and Goldbach, joined to the $\kappa_r$ divisor
  vocabulary. Even that is claimed only as **SEARCH-pending**: no
  literature search has been performed for this packaging (plausible
  neighborhoods: presentations of Chen's theorem via weighted sieves with
  the $\omega - 1$ weight — Chen's own weighting is close in spirit;
  Friedlander–Iwaniec, *Opera de Cribro*). Until that search lands, the
  placement is an import from D0026, not a house result.

## 7. Declared consumers

- **Analytic lane** (queue Q4 and transmitted §5.6/§5.11): $\kappa_r$ is
  the coefficient system of the CRT boundary operator $C_{r,t}(X;h)$ whose
  error term is the positive-cone discrepancy sum feeding the
  Kloosterman-fraction comparison; Theorem B4's fiber is the object on
  which transmitted §5.12 item 5 ("represent or bound conditional $\pi_1$
  on Chen-completed fields") is posed.
- **Machine vocabulary program** (queue Q6): the residual demands
  `Omega(n)`, `omega(n)`, `musq(n)` already landed in
  `machine/thoughts.math` (lines 22–24) name exactly the primitives needed
  to state Theorems A and B natively; this note is the real consumer those
  residuals were filed for. First native targets, in order:
  $\Phi_{p^a}(t) = t^a - t^{a-1}$ (needs only `Omega`),
  the three-row table of §2.2 (needs all three), and the $n = 12, 30, 360$
  tables as `refl` certificates.
- **Notes lane**: the remaining Q3 bullets (charge-deformed Buchstab
  semigroup §5.2; fugacity-propagator facets §5.11) are separate imports
  and are *not* covered by this note.
