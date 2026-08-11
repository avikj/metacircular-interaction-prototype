# The rigidity frontier: unconditional partial results toward Conjecture A″

**Context.** REPORT.md §2: $F_X(x)=\sum_{p\le X}x^{p-2}$ (monic, 0-1, $F_X(0)=1$, $\pi(X)$ terms).
Theorem A′: if the non-cyclotomic part of $F_X$ is irreducible, the primes $\le X$ are
determined by their difference multiset up to reflection. Conjecture A″: this holds for all $X$.
This note records (i) the new computational frontier, (ii) two unconditional theorems that
settle the low-degree and cyclotomic layers of A″, (iii) the resolution — negative — of the
"2-dimensional recurrence" question for $m\in\{3,4,6\}$, and (iv) a quantification of how much
weaker rigidity is than irreducibility.

Every claim is labeled **PROVED** (hand proof, checkable line by line), **MACHINE-VERIFIED**
(exact integer computation, code in repo), **DATA** (numerical observation), or **HEURISTIC**.

---

## 1. Computational frontier (exp1c) — DATA

`code/exp1c_bigfactor2.py`, FLINT `fmpz_poly.factor`, log in `data/exp1c_out.txt`:

| $X$ | degree | $\pi(X)$ | factors | time |
|---|---|---|---|---|
| 30000 | 29987 | 3245 | **1 (irreducible)** | 657 s |
| 50000 | 49997 | 5133 | **1 (irreducible)** | 1769 s |

$F_X$ is irreducible at every tested cutoff beyond $X=11$; by Theorem A′, **the primes up
to $5\cdot10^4$ are unconditionally determined by their difference multiset up to
reflection** (a 2.5× degree extension over the previous frontier $2\cdot10^4$). Timing
grows like $\deg^{2.1-2.2}$ (9.3 s → 44.7 s → 211 s → 657 s → 1769 s along
$5\text{k},10\text{k},20\text{k},30\text{k},50\text{k}$; the large runs shared 4 cores with
other jobs), putting $X=10^5$ at roughly 1.5–2 h — feasible but outside this session's
budget; it is the natural next checkpoint.

---

## 2. Theorem F1: $F_X$ has no factor of degree $\le 2$ (all $X\ge 13$) — PROVED

Throughout, factors are taken monic in $\mathbb Z[x]$ (Gauss), and then
$g(0)\mid F_X(0)=1$, so $g(0)=\pm1$.

**Lemma F0 (root annulus).** Every root $z$ of $F_X$ satisfies $\tfrac12<|z|<2$.

*Proof.* If $|z|\ge2$: writing $n=\deg F_X$, $|z|^n=\bigl|\sum_{j<n,\,a_j=1}z^j\bigr|
\le\sum_{j=0}^{n-1}|z|^j=\frac{|z|^n-1}{|z|-1}\le|z|^n-1$, absurd. The reciprocal
$x^nF_X(1/x)$ is again a 0-1 polynomial with constant term 1, giving $|z|>\tfrac12$. ∎

**Lemma F0′ (positivity).** $F_X(t)\ge1$ for all $t\ge0$: no nonnegative real roots.

**Theorem F1.** Let $X\ge3$.
1. *(degree 1)* $F_X$ has a linear factor iff $\pi(X)=2$ (i.e. $3\le X<5$), where
   $F_3=1+x=\Phi_2$. For $X\ge5$: none.
2. *(degree 2)* Any irreducible quadratic factor of $F_X$ is one of $\Phi_3,\Phi_4,\Phi_6$;
   and (by Theorem F2 below) the only occurrence over all $X$ is $\Phi_6\mid F_{11}$.
3. Hence for every $X\ge13$, every irreducible factor of $F_X$ has degree $\ge3$.

*Proof.* (1) A rational root divides $F_X(0)=1$, so is $\pm1$. $F_X(1)=\pi(X)>0$.
$F_X(-1)=1-(\pi(X)-1)=2-\pi(X)$, since $p=2$ contributes $(-1)^0=+1$ and every odd prime
contributes $(-1)^{p-2}=-1$. This vanishes iff $\pi(X)=2$.

(2) Let $g=x^2+ax+b$, $b=\pm1$.
*Case $b=-1$:* the discriminant $a^2+4>0$ gives two real roots of product $-1$, one of them
positive — contradicting Lemma F0′.
*Case $b=+1$:* the roots are $z,1/z$.
If they are non-real they lie on $|z|=1$ with $-a=2\cos\theta\in\mathbb Z$, so
$a\in\{0,\pm1\}$ ($a=\pm2$ gives the double roots $\mp1$, excluded by (1) for $X\ge5$; for
$X\le4$, $\deg F_X\le1$): these are exactly $\Phi_4$ ($a=0$), $\Phi_6$ ($a=-1$),
$\Phi_3$ ($a=1$).
If they are real they are both negative (Lemma F0′) and lie in $(-2,-\tfrac12)$ (Lemma F0);
but on that interval $z+1/z\in[-\tfrac52,-2]$ takes the integer value $-a$ only at $z=-1$
(value $-2$), excluded. ∎

**Corollary F1.1 (Kronecker dichotomy) — PROVED.** Any monic factor $g\mid F_X$ with all
roots on $|z|\le1$ is a product of cyclotomics; consequently every non-cyclotomic factor
has $|g(0)|=1=\prod|z_i|$ with roots strictly inside *and* strictly outside the unit circle,
hence Mahler measure $M(g)>1$. If moreover $g$ is non-reciprocal, Smyth's theorem gives
$M(g)\ge\theta_0=1.3247\ldots$ (the plastic number). An irreducible **cubic** factor would
necessarily be non-cyclotomic ($\varphi(m)=3$ has no solutions) and non-reciprocal (an odd-degree
reciprocal polynomial has $-1$ as a root), so it would be a cubic unit with one real root in
$(-2,-\tfrac12)$ and $M\ge\theta_0$; we cannot yet exclude this unconditionally — degree 3 is
where the provable zone currently ends. (The computations of §1 exclude all degrees up to
$5\cdot10^4$, of course.)

---

## 3. Theorem F2: the cyclotomic layer, solved for $m\le1000$ and ALL $X$

$\Phi_m\mid F_X\iff\sum_{p\le X}\zeta_m^{p-2}=0$: the "$\zeta_m$-weighted prime race tie"
(REPORT §2.1). Fix $m$ and let $X>P(m):=\max\{p:p\mid m\}$. Split the sum into the fixed
**ramified** part $t_m=\sum_{p\mid m}\zeta_m^{p-2}$ and the unramified part
$\sum_{c\in(\mathbb Z/m)^\times}n_c(X)\,\zeta_m^{c-2}$, where
$n_c(X)=\#\{p\le X:\ p\equiv c\ (m),\ p\nmid m\}$. Reducing mod $\Phi_m$, the tie condition is
the lattice equation

$$\sum_{c\in(\mathbb Z/m)^\times} n_c(X)\,v_c\;=\;-t_m\qquad\text{in }\mathbb Z^{\varphi(m)},
\qquad v_c := x^{(c-2)\bmod m}\bmod\Phi_m. \tag{$\ast$}$$

The counts $n_c(X)$ are **nondecreasing in $X$ and tend to $\infty$**. Everything below
exploits this monotonicity — the tie condition is *not* a recurrence question for a mean-zero
walk; see §4.

### 3.1 Squarefree $m$: the counts are forced — PROVED

**Lemma F2.1.** The primitive $m$-th roots of unity $\{\zeta_m^a:a\in(\mathbb Z/m)^\times\}$
are linearly independent over $\mathbb Q$ iff $m$ is squarefree.

*Proof.* ($\Leftarrow$) $\mathbb Q(\zeta_m)=\bigotimes_{p\mid m}\mathbb Q(\zeta_p)$ and each
$\{\zeta_p,\dots,\zeta_p^{p-1}\}$ is a basis of $\mathbb Q(\zeta_p)$ (multiplication by the
unit $\zeta_p$ maps the power basis $\{1,\dots,\zeta_p^{p-2}\}$ to it); a tensor product of
bases is a basis, and the primitive $m$-th roots are exactly the products
$\prod_p\zeta_p^{a_p}$. ($\Rightarrow$) If $p^2\mid m$ then for any unit $a$,
$\sum_{j\bmod p}\zeta_m^{\,a+j(m/p)}=\zeta_m^a\sum_j\zeta_p^j=0$, and each exponent
$a+j(m/p)$ is again a unit (as $p\mid m/p$ and $q\mid m/p$ for every other prime $q\mid m$):
a nontrivial relation. ∎

**Theorem F2-sf.** For squarefree $m$, ($\ast$) has at most one solution vector
$(n_c)=(t_c^{(m)})$, computable exactly; hence the tie set
$\{X>P(m):\Phi_m\mid F_X\}$ is the (possibly empty) interval
$[\max_c L_c,\ \min_c U_c)$, where $L_c$ is the $t_c$-th prime in class $c$ and $U_c$ the
$(t_c+1)$-th. In particular **for each squarefree $m$ there are at most finitely many ties,
all effectively bounded** — the tie interval is computed from the first few primes in each class.

*Proof.* By Lemma F2.1 the map $(n_c)\mapsto\sum n_c\zeta^{c-2}=\zeta^{-2}\sum n_c\zeta^{c}$
is injective ($\zeta^{-2}$ is a unit), so ($\ast$) forces the counts. Monotone counts hit a
prescribed value on an interval of $X$. ∎

**Worked examples — PROVED (two-line arithmetic each):**
- $m=6$: ($\ast$) forces $n_{1(6)}=1,\ n_{5(6)}=2$, i.e. $7\le X<13$ and $11\le X<17$:
  tie exactly for $X\in[11,13)$. **The $(11,6)$ tie is the unique $\Phi_6$ tie for all $X$, ever.**
- $m=3$: forces $n_{1(3)}=n_{2(3)}=1$; but $2,5\equiv2\ (3)$ gives $n_{2(3)}\ge2$ for
  $X\ge5$ while $n_{1(3)}=0$ until $X=7$: the intervals $[7,13)\cap[2,5)=\emptyset$. **$\Phi_3$
  never divides $F_X$.**
- $m=2$: forces $n_{1(2)}=1$: $X\in[3,5)$, the trivial tie $F_3=\Phi_2$. ($\Phi_1\nmid F_X$
  always, as $F_X(1)=\pi(X)>0$.)

### 3.2 $4\mid m$: parity obstruction — PROVED

**Theorem F2-4.** If $4\mid m$ then $\Phi_m\nmid F_X$ for every $X$.

*Proof.* $\sigma:\zeta_m\mapsto\zeta_m^{1+m/2}=-\zeta_m$ is a Galois automorphism
($1+m/2$ is odd since $4\mid m$, and coprime to $m$), acting on $\zeta_m^j$ by $(-1)^j$.
In $\sum_p\zeta_m^{p-2}$, the term $p=2$ contributes $\zeta^0=1$ ($\sigma$-even) and every
odd prime contributes an odd power of $\zeta_m$ ($\sigma$-odd). Averaging the tie equation
over $\{1,\sigma\}$ leaves $1=0$. ∎

This covers $m=4,8,12,16,20,\dots$ In particular **$\Phi_4\nmid F_X$ for all $X$** — the
constant "+1" from the prime 2 is frozen into the rational coordinate and can never cancel.

### 3.3 Every non-squarefree $m$ is impossible — PROVED

The former machine-only lattice obstruction is now a uniform theorem; see
`CYCLOTOMIC_TRACE.md` for the full proof. If $p^2\mid m$, put
$K=\mathbb Q(\zeta_m)$ and $K_0=\mathbb Q(\zeta_{m/p})$. Then
$[K:K_0]=p$ and

$$\operatorname{Tr}_{K/K_0}(\zeta_m^a)=
\begin{cases}0,&p\nmid a,\\p\zeta_m^a,&p\mid a.\end{cases}$$

A tie, multiplied by $\zeta_m^2$, is $\sum_{q\le X}\zeta_m^q=0$. If
$p\le X$, its relative trace is the impossible equation $p\zeta_m^p=0$,
because $p$ is the only prime exponent divisible by $p$. If $p>X$, then
$\varphi(m)\ge p(p-1)>\deg F_X$, so divisibility is impossible by degree.
Therefore

> **Theorem F2-ns.** If $m$ is non-squarefree, then
> $\Phi_m\nmid F_X$ for every $X$.

The earlier exact computation remains an independent finite verification:
`code/exp7b_ties_extended.py` (Part 3) computes lattice membership in exact
FLINT arithmetic. It found:

> **For every one of the 392 non-squarefree $m\le1000$, the target $-t_m$ is not in the
> step lattice: ties are impossible for $X>m$.** (`data/exp7b_out.txt`: for $m\le200$,
> Part 3 shows all 78 marked `Qspan=0` — not even rationally solvable; for $201\le m\le1000$
> the EXTENSION blocks certify lattice non-membership for all 314 non-squarefree values,
> with zero "walkers", i.e. zero solvable cases.)

This computation is now corroboration rather than a premise. Theorem F2-4 is
the $p=2$ shadow of the same relative-trace argument.

### 3.4 Synthesis: the complete tie theorem

**Theorem F2 (classification, $m\le1000$, all $X$) — PROVED + MACHINE-VERIFIED.**
For every $m\le1000$ and every $X\ge3$:
$$\Phi_m\mid F_X\iff (X,m)\in\{(3,2),\ (11,6)\}\ \text{(with }F_3=\Phi_2\text{ itself)}.$$
Structure of the proof: squarefree $m$ (607 values) → forced counts and explicit tie
intervals (Thm F2-sf; exp7b Part 3b and the EXTENSION mode: for $m\le200$ every forced
count is $\le2$, so each interval closes by the third prime of a class; all intervals
empty except $m=2\to[3,5)$ and $m=6\to[11,13)$); $4\mid m$ → parity (Thm F2-4); other
non-squarefree $m$ → relative-trace impossibility (§3.3, all $m$); the region
$X\le\max(m,P(m))$ → direct scan (to $10^7$ for $m\le200$, to $2000\ge m$ for
$201\le m\le1000$), plus independently all $X\le10^7$ for $m\le200$ (§3.5).

Combining Theorems F1 and F2: **for every $X\ge13$, $F_X$ has no irreducible factor of
degree $\le2$, and no cyclotomic factor $\Phi_m$ with $m\le1000$ — unconditionally, for
all $X$, not merely all tested $X$.** Any counterexample to Conjecture A″ must consist of
non-cyclotomic factors of degree $\ge3$, or a cyclotomic $\Phi_m$ with $m>1000$ (and then
$\varphi(m)\ge240$ — see remark below).

*Remark.* Since $\min\{\varphi(m):m>1000\}=\varphi(1050)=240$ (finite check up to $10^5$;
beyond, $\varphi(m)>m^{1/2}>316$), Theorem F2 gives unconditionally: **any cyclotomic
factor of any $F_X$ other than the known two has degree $\varphi(m)\ge240$.**

### 3.5 The extended scan — DATA

exp7b Part 1: all $m\le200$, all prime cutoffs $X\le10^7$
($\pi(10^7)=664{,}579$), exact integer vectors, chunked numpy cumulative sums, 199 s
(classification and interval computation: <1 s; total run 204 s):

> **Ties found: exactly one — $(X,m)=(11,6)$.** No new ties anywhere in
> $2\le m\le200$, $5\le X\le10^7$.

This is a $\sim$3-fold extension in $m$-range and 10-fold in $X$-range over exp7
($m\le60$, $X\le10^6$) and independently certifies the small-$X$ region of Theorem F2.

---

## 4. Is the tie condition recurrent for $m\in\{3,4,6\}$? No — PROVED (and what survives)

**The naive heuristic (HEURISTIC, stated to be corrected).** $\Phi_m\mid F_X$ imposes
$\varphi(m)$ integer equations; the class-count fluctuations behave (Rubinstein–Sarnak,
under GRH+LI) like a $\varphi(m)$-dimensional walk with $\sim\pi(X)$ steps. A mean-zero
lattice walk in dimension $d$ returns to a fixed point infinitely often iff $d\le2$; hence
one would predict: finitely many ties for $\varphi(m)\ge3$, but possibly **infinitely many**
for $\varphi(m)\le2$, i.e. $m\in\{3,4,6\}$ — "cyclotomic ties recur like Chebyshev-bias
sign changes".

**Why the heuristic is wrong for every one of $m=3,4,6$ — PROVED.** The walk of
$(n_c(X))_c$ is *not* mean-zero: it is monotone, with drift $\tfrac1{\varphi(m)}\pi(X)$ in
every coordinate.
- For $m=3,6$ ($\mu(m)\ne0$, squarefree): by Lemma F2.1 the tie *pins the actual counts*,
  not their differences: the equation has a monotone coordinate ($n_{1(3)}$, resp.
  $n_{1(6)}$) that must equal a fixed small integer. Once it passes that value — by
  $X=13$ in both cases — ties are impossible **forever**, deterministically, not just
  almost surely. Transience by drift, not by dimension.
- For $m=4$ ($\mu=0$): the walk *is* effectively 1-dimensional and recurrent — but in the
  wrong affine subspace. The reduced vector is $v=(1,\ n_{3(4)}-n_{1(4)})$: the rational
  coordinate is frozen at $1$ by the prime 2 (Theorem F2-4) and the tie point $(0,0)$ is
  off-lattice. The recurrent structure survives as **near-ties at distance exactly 1**:
  $|v|^2=1$ iff the classical mod-4 race ties, which happens infinitely often
  **unconditionally** (Littlewood 1914: $\pi(x;4,3)-\pi(x;4,1)$ changes sign infinitely
  often). So: infinitely many near-ties at the minimal possible distance, zero ties.

**DATA (exp7b Part 2), $X\le10^7$:** minimum of $|v_m|^2$ (squared $L^2$ norm of the
reduced vector; $0$ = tie) per decade of $X$:

| decade of $X$ | $m=3$ | $m=4$ | $m=6$ |
|---|---|---|---|
| $[10^1,10^2)$ | 2 (at 13) | 1 (at 17) | **0 (at 11)** |
| $[10^2,10^3)$ | 109 | 1 (at 461) | 101 |
| $[10^3,10^4)$ | 6436 | 2 | 6416 |
| $[10^4,10^5)$ | 372{,}149 | 1 (at 26833) | 372{,}125 |
| $[10^5,10^6)$ | 22{,}887{,}140 | 1 (at 616769) | 22{,}887{,}056 |
| $[10^6,10^7)$ | 1{,}539{,}072{,}517 | 730 | 1{,}539{,}072{,}385 |

The $m=4$ column realizes the theory: the minimum is exactly $1$ whenever the mod-4 race
ties — **111** prime cutoffs with $|v|^2=1$ up to $10^7$, first few
$X=5,17,41,461,26833$; the clusters near $2.7\cdot10^4$ and $6.2\cdot10^5$ are the
classical Leech / Hudson–Bays sign-change regions, and the absence of any $|v|^2=1$ in
$[10^6,10^7)$ matches the known race-tie gap until $\approx1.2\cdot10^7$. For $m=3,6$ the
minimum after $X=13$ grows like $\bigl(n_{1(m)}(X)-1\bigr)^2\approx(\pi(X)/2)^2$ — the
monotone coordinate — i.e. **quadratically in $\pi(X)$** (e.g. the decade minimum
$22{,}887{,}140$ at $X=100003$ vs $(\pi(10^5)/2)^2=4796^2=23{,}001{,}616$: agreement to
0.5\%, the deficit being the ordinary race deviation). "Recurrent but rare" is decisively
refuted in favor of "transient with
linear escape"; the closest approach to a tie after $X=11$ is $|v|^2=2$ at $X=13$ ($m=3$)
and $|v|^2=1$ at $X=17$ ($m=6$), never bettered again.

**Corrected expected-count heuristic (HEURISTIC, with a PROVED skeleton).** The effective
walk dimension is $D_m:=\operatorname{rank}_{\mathbb Q}\{v_c\}=\dim_{\mathbb Q}
\operatorname{span}\{\zeta_m^a:a\in(\mathbb Z/m)^\times\}$, with the closed form
$$D_m=\prod_{p^e\|m}d_{p^e},\qquad
d_{p^e}=\begin{cases}p-1,&e=1,\\ \varphi(p^e)-\varphi(p^{e-1}),&e\ge2,\end{cases}$$
**proved in `CYCLOTOMIC_TRACE.md` Proposition 4**: locally the primitive
$p^e$-root span is the kernel of the relative trace to level $p^{e-1}$, and
the coprime local spans tensor. It is also machine-verified for every
$m\le200$. Consequently the only
non-squarefree $m$ with $D_m\le3$ are $m=4$ ($D=1$), $m=8$, $m=12$ ($D=2$).
The former transience heuristic for all other non-squarefree moduli is now
superseded: Theorem F2-ns kills **every** one of them deterministically by
relative trace, regardless of dimension. The rank formula remains useful as a
structural description of which information the primitive-root orbit retains.
Thus the finiteness claim is now exact: squarefree $m$ have at most one forced
count vector; non-squarefree $m$ have zero ties.
**Conjecture F2∞: $(3,2)$ and $(11,6)$ are the only cyclotomic ties of the prime
polynomial, over all $m$ and all $X$.** A theorem for $m\le1000$ (Thm F2);
beyond, every non-squarefree modulus is now excluded by Theorem F2-ns, so the
conjecture is purely squarefree. For squarefree $m$, `CYCLOTOMIC_TRACE.md`
sharpens the forced vector to
$$n_c(X)=\#\{r\mid m:c\equiv r\pmod{m/r}\},
\qquad \pi(X)=\sum_{r\mid m}r.$$

**Which $m$ are most tie-prone? (theory note requested by the task.)** Ties require small
forced counts hit simultaneously in every class: probability decays like a coincidence among
the first few primes in $\varphi(m)$ classes, i.e. roughly $c^{\varphi(m)}$ — so small
$\varphi(m)$, i.e. $m\in\{3,4,6\}$ ($\varphi=2$), would be the only candidates for
recurrence, and they are exactly the ones killed above by drift ($3,6$) and parity ($4$).
Low-dimensional *reduced* vectors for composite non-squarefree $m$
($\operatorname{rank}<\varphi(m)$, e.g. $m=8,12$: rank 2) are the other soft spot, and there
the ramified-prime target is what saves irreducibility. The prime 2 — the "oddest prime" —
is thus the guardian of the cyclotomic layer twice over: it freezes the rational coordinate
for $4\mid m$ and inflates $n_{2\bmod 3}$, $n_{5\bmod 6}$ early for $m=3,6$.

---

## 5. Rigidity is strictly weaker than irreducibility — PROVED + DATA

**Setup (Rosenblatt–Seymour, cf. Thm A′).** Write $F_X=C\cdot G_1\cdots G_r$ with $C$ the
cyclotomic part and $G_i$ the non-cyclotomic irreducibles. Every homometric partner of the
prime set arises, up to shift/reflection, from a *split*: replace a subset
$S\subseteq\{1..r\}$ of the $G_i$ by their reversals $\tilde G_i$ (reversing factors of the
palindromic $C$ changes nothing). Rigidity fails iff some proper split
($\emptyset\ne S\ne\{1..r\}$, modulo reciprocal factors) yields a polynomial with
coefficients in $\{0,1\}$.

**Proposition R1 — PROVED.** Rigidity of the primes $\le X$ holds under any of:
1. $r\le1$ (Theorem A′; the cyclotomic layer is now controlled by Theorem F2);
2. every $G_i$ is reciprocal up to sign (then every split reproduces $\pm F_X$);
3. $r\ge2$ with at least one non-reciprocal factor, but **no** proper split is 0-1.

So a rigidity counterexample needs *simultaneously*: reducibility of the non-cyclotomic
part ($r\ge2$), **at least two non-reciprocal $G_i$** (reversing reciprocal factors does
nothing, and reversing *all* non-reciprocal ones gives the mirror — so with $\le1$
non-reciprocal factor every split is trivial), *and* the arithmetic miracle that the
recombined coefficients — sums of products of the $G_i$'s coefficients — land in $\{0,1\}$
at every one of the $\deg F_X+1$ positions.

**Anatomy of a genuine break — MACHINE-VERIFIED.** The minimal homometric pair
$\{0,1,2,6,8,11\}\sim\{0,1,6,7,9,11\}$ (Thm A(2)) factors as
$$1+x+x^2+x^6+x^8+x^{11}=\Phi_4\cdot(x^4+x+1)(x^5-x^3+1),$$
with **two distinct non-reciprocal non-cyclotomic factors, each of whose single reversals
is 0-1**: reversing $x^4+x+1$ gives support $\{0,2,4,5,10,11\}$ (≅ the partner reflected)
and reversing $x^5-x^3+1$ gives $\{0,1,6,7,9,11\}$. Both coincidences at once, at degree 11.

**Slack quantification — DATA (one-off experiment; FLINT factorization + split enumeration
via `exp1_rigidity.py` machinery, seeds = degree).** Random 0-1 polynomials, constant and
leading coefficient 1, prime-like density, 400 samples per row:

| deg | density | irreducible | reducible | reducible w/ cyclotomic factor | w/ reciprocal non-cyclotomic factor | rigidity broken |
|---|---|---|---|---|---|---|
| 40 | 0.30 | 328 (82%) | 72 | 72 | 0 | **0** |
| 80 | 0.25 | 335 (84%) | 65 | 65 | 0 | **0** |
| 120 | 0.20 | 354 (88%) | 46 | 46 | 0 | **0** |

In 1200 samples: *every* failure of irreducibility was purely cyclotomic (matching the
Breuillard–Varjú picture that the non-cyclotomic part of a random 0-1 polynomial is
irreducible whp), zero reciprocal non-cyclotomic factors, zero rigidity breaks. So in the
random model at these degrees, **the gap between "irreducible" and "rigid" absorbs 100% of
the observed reducibility**: rigidity is strictly and usefully weaker than A″. Heuristically
(HEURISTIC) a break requires $\deg F_X+1$ coefficient constraints to hold simultaneously
after reversal — probability exponentially small in the degree — so homometric partners of
prime-like sets should exist only at bounded degree, and the exhaustive search (exp1: none
for any prime cutoff $X\le500$ by direct split enumeration, none possible for $X\le5\cdot10^4$
by irreducibility) has already passed the plausible window.

**Consequence for the program.** The intermediate target of REPORT §8 Problem 1 ("no
reciprocal non-cyclotomic factor") splits cleanly now:
- degree $\le2$ reciprocal factors: **excluded unconditionally** (Thm F1);
- cyclotomic factors, $m\le200$: **excluded unconditionally for all $X$** (Thm F2);
- a reciprocal non-cyclotomic factor must have even degree $\ge4$ (odd-degree reciprocals
  have the root $-1$), Mahler measure in Lehmer's range, and both a root and its inverse
  inside the annulus $(\tfrac12,2)$ — Salem-type configurations; no instance observed in
  1200 random samples nor at any tested $X$.

---

## 6. Status and open problems

| layer of Conjecture A″ | status |
|---|---|
| factors of degree 1, 2 | **PROVED impossible** for $X\ge13$ (Thm F1) |
| cyclotomic factors $\Phi_m$, $m\le1000$, any $X$ | **PROVED/MACHINE: only $(3,2),(11,6)$** (Thm F2) |
| cyclotomic factors, $m>1000$ | every non-squarefree $m$ **PROVED impossible** by relative trace; squarefree $m$ obey explicit forced counts and $\pi(X)=\sum_{p\mid m}p$; Conjecture F2∞ remains only there |
| recurrence for $\varphi(m)=2$ | **refuted**: drift ($m=3,6$) / parity ($m=4$); only distance-1 near-ties recur ($m=4$, Littlewood, unconditional) |
| non-cyclotomic factors, degree $\ge3$ | open; $F_X$ irreducible up to $X=5\cdot10^4$ (degree 49{,}997); rigidity survives even $r\ge2$ unless a 0-1 split exists (Prop R1, slack data §5) |

Open problems generated: (1) eliminate the remaining squarefree forced vectors,
using $\pi(X)=\sum_{p\mid m}p$ together with the class-by-class condition;
(2) exclude cubic factors of $F_X$ unconditionally (the first genuinely open degree; needs
input beyond root location — e.g. a Smyth-type gap plus the annulus is not contradictory);
(3) push F2 beyond $m=1000$ (the EXTENSION mode of exp7b runs $m\in[201,1000]$ in
$\approx3$ min; cost is dominated by the exact linear solves at $\varphi(m)\sim m$, so
$m\le2000$ is hours, not days); (4) the $X=10^5$ factorization ($\approx2$ h with FLINT at
current scaling).
