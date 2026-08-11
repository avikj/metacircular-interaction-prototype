# The prime-prefix factor frontier: independent algebra beyond phase rigidity

**Context.** REPORT.md §2: $F_X(x)=\sum_{p\le X}x^{p-2}$ (monic, 0-1, $F_X(0)=1$, $\pi(X)$ terms).
The singleton-parity theorem in `PARITY_RIGIDITY.md` now proves directly that
every prime prefix is determined by its full pairwise difference multiset up
to translation and reflection. Thus phase rigidity is solved independently
of factorization. Write **Conjecture A″$_{\rm alg}$** for the strictly
stronger assertion that the non-cyclotomic part of every $F_X$ is
irreducible. This note records (i) the computational factor frontier, (ii)
unconditional results on the low-degree and cyclotomic layers of
A″$_{\rm alg}$, (iii) the resolution — negative — of the
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

$F_X$ is irreducible at every tested cutoff beyond $X=11$. This is evidence
for A″$_{\rm alg}$; prime-set reconstruction itself is already unconditional
for every cutoff by singleton parity. Timing
grows like $\deg^{2.1-2.2}$ (9.3 s → 44.7 s → 211 s → 657 s → 1769 s along
$5\text{k},10\text{k},20\text{k},30\text{k},50\text{k}$; the large runs shared 4 cores with
other jobs), putting $X=10^5$ at roughly 1.5–2 h — feasible but outside this session's
budget; it is the natural next checkpoint.

### 1.1 The asymptotic low-degree frontier is closed — PROVED

`ASYMPTOTIC_FACTOR_RIGIDITY.md` combines Lenstra's lacunary gap theorem
with Ford--Maynard--Tao's theorem on two consecutive large prime gaps.  A
single Lenstra-admissible support gap makes any bounded-degree
noncyclotomic factor divide both sides.  Two consecutive such gaps force
the factor to divide the isolated monomial between them, which is
impossible.  The global cyclotomic theorem removes the root-of-unity
exception for $X\ge13$.

> **Theorem F$\infty$.** If $\delta(F_X)$ is the least degree of an
> irreducible factor of $F_X$, then
> $$
> \delta(F_X)\gg
> \frac{\log_2X\,(\log_4X)^4}{(\log_3X)^4},
> $$
> with an effective absolute implied constant.  In particular,
> $\delta(F_X)\to\infty$.

Voutier's main height theorem supplies the displayed general rate.  Smyth's
uniform Mahler-measure gap for nonreciprocal algebraic integers gives the
stronger rigidity-sensitive tier

$$
\min_{\substack{g\mid F_X\\g\ {\rm irreducible, nonreciprocal}}}
\deg g
\gg\frac{\log_2X\,\log_4X}{\log_3X}.
$$

The unique odd-degree carrier is necessarily nonreciprocal for $X\ge13$,
so its degree satisfies this stronger bound.

Grouping nonreciprocal factors into reciprocal pairs then bounds the number
$\mathcal H_X$ of normalized $0$--$1$ polynomials with the same labeled
difference multiset:

$$
\log|\mathcal H_X|
\ll\frac{X\log_3X}{\log_2X\,\log_4X}=o(X).
$$

This bounds the number of **algebraic factor allocations** before the
$0$--$1$ coefficient constraint is imposed. Exact $0$--$1$ uniqueness is
already supplied by singleton parity.

This does not supply an accessible explicit cutoff for the octic layer;
the exact low-degree certificates below remain strictly stronger at finite
$X$.

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
If they are real they are both negative (Lemma F0′) and lie in $(-1,-\tfrac12)$ (the
mandatory $x,x^3$ terms exclude roots $\le-1$, while Lemma F0 gives the lower modulus bound);
but on that interval $z+1/z\in[-\tfrac52,-2]$ takes the integer value $-a$ only at $z=-1$
(value $-2$), excluded. ∎

**Corollary F1.1 (Kronecker dichotomy) — PROVED.** Any monic factor $g\mid F_X$ with all
roots on $|z|\le1$ is a product of cyclotomics; consequently every non-cyclotomic factor
has $|g(0)|=1=\prod|z_i|$ with roots strictly inside *and* strictly outside the unit circle,
hence Mahler measure $M(g)>1$. If moreover $g$ is non-reciprocal, Smyth's theorem gives
$M(g)\ge\theta_0=1.3247\ldots$ (the plastic number). An irreducible **cubic** factor would
necessarily be non-cyclotomic ($\varphi(m)=3$ has no solutions) and non-reciprocal (an odd-degree
reciprocal polynomial has $-1$ as a root), so it would be a cubic unit with one real root in
$(-1,-\tfrac12)$ and $M\ge\theta_0$.  This is the first case not settled by
F1 alone, and Theorem F3 below now closes it. (The computations of §1 exclude
all degrees up to $5\cdot10^4$, of course.)

### 2.1 The cubic layer is also closed — PROVED

`CUBIC_OBSTRUCTION.md` proves a stronger odd-support theorem: a finite
$0$--$1$ polynomial
$$1+x+x^3+\sum_{j\ge5,\ j\text{ odd}}\epsilon_jx^j$$
has an irreducible cubic factor if and only if every higher coefficient
vanishes, in which case the polynomial is the irreducible cubic
$x^3+x+1$.  Since every $F_X$ for $X\ge5$ has this support form,

> **Theorem F3.** $F_X$ has an irreducible cubic factor iff $5\le X<7$.
> In particular, it has no cubic factor for $X\ge7$.

The proof uses root-product signs, the elementary root annulus, Vieta, and
an exact six-case integer enumeration; it uses no prime-distribution input.
### 2.2 The quartic layer is closed — MACHINE-VERIFIED EXACT THEOREM

The parity identity $F_X(x)+F_X(-x)=2$ implies that every monic degree-$d$
factor $g$ satisfies

$$0\ne\operatorname{Res}(g(x),g(-x))\mid 2^d.$$

For $g=x^4+ax^3+bx^2+cx+1$, this becomes the exact unit equation

$$a^2-abc+c^2=\pm1.$$

The odd-support root geometry sharpens this to $62$ integer triples.  Exact
Sturm counts and a cubic-resolvent annulus test leave $26$: two cyclotomic
cases already excluded by F2 and $24$ noncyclotomic cases.  Each of those
$24$ is eliminated for all cutoffs by an exact resultant/tail certificate
at $q\in\{7,11,13\}$; the smallest rational safety margin is
$0.04181409\ldots>0$.

> **Theorem F4 (computer-assisted, exact).** No irreducible quartic
> polynomial divides any $F_X$.

The finite certificate uses only integer and rational arithmetic (Sturm
chains, Bareiss resultants, and fraction comparisons), runs in under a
tenth of a second, and is independently checkable in
`code/exp30_quartic_certificate.py`.  The proof and certificate derivation
are in `PARITY_RESULTANT.md`.

### 2.3 The quintic layer is closed — MACHINE-VERIFIED EXACT THEOREM

The degree-independent parity identity sharpens to

$$
\operatorname{Res}_x(g(x),g(-x))
=2^{\deg g}\operatorname{Res}_y(E,O)^2
$$

for $g(x)=E(x^2)+xO(x^2)$.  Thus every factor has
$\operatorname{Res}(E,O)=\pm1$.  In degree five this is an explicit
four-variable Diophantine equation.  Root geometry reduces it to $1{,}591$
integer tuples; exact Sturm and reducibility tests leave $18$.

Every odd-degree factor owns the unique negative root $-t$ of $F_X$.
Consequently divisibility becomes the scalar condition
$\sum_{3\le p\le X}t^{p-2}=1$, whose left side is strictly increasing with
the prime cutoff.  Exact rational root isolation and a geometric tail
majorant eliminate $17$ candidates.  The sole survivor is $F_7$ itself.

> **Theorem F5 (computer-assisted, exact).** $F_X$ has an irreducible
> quintic factor iff $7\le X<11$.  On that interval
> $F_X=x^5+x^3+x+1$, which is irreducible.

The exact certificate is `code/exp31_quintic_certificate.py`; its smallest
tail safety margin is $0.0023189\ldots>0$.  The proof is in
`QUINTIC_OBSTRUCTION.md`, and an independent hostile audit accepted every
enumeration, sign, resultant, and cutoff-coverage step.

### 2.4 The reciprocal sextic layer is closed — MACHINE-VERIFIED EXACT THEOREM

For a reciprocal sextic

$$g=x^6+ax^5+bx^4+cx^3+bx^2+ax+1,$$

the unit resultant factors completely:

$$
\operatorname{Res}(E,O)
=(2a-c)\bigl(c-a(b-1)\bigr)^2=\pm1.
$$

Exact Joukowski/Sturm root geometry leaves $12$ irreducible candidates.
The singleton exponent classes modulo $3$ and $5$ reduce them to four;
$\Phi_7$ and $\Phi_{14}$ are removed by F2.  Exact resultants at $F_{11}$
and rational infinite-tail bounds exclude the final two with large positive
margins.

> **Theorem F6r (computer-assisted, exact).** No irreducible reciprocal
> sextic divides any $F_X$.

See `RECIPROCAL_SEXTIC.md` and
`code/exp32_reciprocal_sextic.py`.  Thus the first open factor degree remains
six, but only the nonreciprocal sextic subfamily remains relevant there.

### 2.5 The full sextic layer is closed — MACHINE-VERIFIED EXACT THEOREM

For a general sextic $g=E(x^2)+xO(x^2)$, the unit equation
$\operatorname{Res}(E,O)=\pm1$ combines with the valid odd-support bounds
$\varphi^{-1}<|z|<2$.  Exact coefficient optimization yields

$$
|a|,|e|\le6,\qquad |b|,|d|\le18,\qquad |c|\le24.
$$

The resulting exact search has the auditable reduction

$$
18{,}506\longrightarrow4{,}894\longrightarrow392
\longrightarrow362,
$$

respectively: unit-resultant tuples, no-real-root tuples, a conservative
rational-annulus superset certified by Cayley--Routh counts, and irreducible
candidates.  Four are $\Phi_7,\Phi_9,\Phi_{14},\Phi_{18}$ and are removed by
F2.  Exact disk-radius/resultant/tail inequalities exclude the other $358$
by cutoff $47$; the smallest exact margin is
$0.060188651182\ldots>0$.

> **Theorem F6 (computer-assisted, exact).** No irreducible sextic
> polynomial divides any $F_X$.

See `SEXTIC_OBSTRUCTION.md` and
`code/exp32_sextic_certificate.py`.  The reciprocal theorem F6r is retained
as a much smaller conceptual subcertificate.  Combining F1--F6, for every
$X\ge13$ every irreducible factor of $F_X$ is noncyclotomic and has degree
at least $7$.

### 2.6 The septic layer is classified — MACHINE-VERIFIED EXACT THEOREM

An irreducible odd-degree factor owns the unique negative root of $F_X$.
For a septic

$$
g=x^7+a x^6+b x^5+c x^4+d x^3+e x^2+f x+1
  =E(x^2)+xO(x^2),
$$

the parity resultant again forces $\operatorname{Res}(E,O)=\pm1$.  The
valid root bounds $\varphi^{-1}<|z|<2$, together with the product of the
three conjugate-pair radii, give the complete coefficient box

$$
|a|,|f|\le7,\qquad |b|,|e|\le25,\qquad |c|,|d|\le44.
$$

Exact enumeration and rational root filtering reduce this box as follows:

$$
90{,}893{,}475\longrightarrow21{,}647{,}831
\longrightarrow2{,}266\longrightarrow537\longrightarrow37.
$$

The stages are scalar-window tuples, unit-resultant tuples, one-real-root
tuples, and a conservative rational-annulus superset.  Exact monotone
prefix and all-odd-tail certificates exclude 36 of the final candidates.
The sole survivor is

$$
H_7=x^7+x^6-x^4+x^2+2x+1,
\qquad F_{11}=\Phi_6H_7.
$$

It is irreducible over $\mathbb Q$, and adding the $p=13$ term makes its
negative-root value strictly negative forever.

> **Theorem F7 (computer-assisted, exact).** An irreducible septic factor
> divides $F_X$ if and only if $11\le X<13$, and then it is $H_7$.

See `SEPTIC_OBSTRUCTION.md` and
`code/exp33_septic_certificate.py`.  Combining F1--F7, no irreducible
factor of degree at most seven occurs for $X\ge13$.  The unique-odd-carrier
theorem then proves $F_{13}$ and $F_{17}$ irreducible; at $F_{19}$ the only
remaining proper degree pattern is $8+9$.  Thus degree eight is the first
open factor layer.

### 2.7 Reciprocal octics are excluded — MACHINE-VERIFIED EXACT THEOREM

For a reciprocal octic

$$
g=x^8+a x^7+b x^6+c x^5+d x^4+c x^3+b x^2+a x+1,
$$

the parity resultant factors completely:

$$
\operatorname{Res}(E,O)
=(d-2b+2)
\left((a-c)^2+ab(a-c)+a^2(d-2)\right)^2.
$$

Thus both displayed integer factors are units.  Reciprocity upgrades the
root annulus to $\varphi^{-1}<|z|<\varphi$; the Joukowski coordinate
$T=z+z^{-1}$ then gives a complete finite coefficient box.  The exact
reduction is

$$
928\longrightarrow424\longrightarrow58\longrightarrow38.
$$

The $58$ rational-annulus candidates split into $20$ explicit reducibles,
$36$ noncyclotomic polynomials certified irreducible modulo $2$, $3$, or
$7$, and the two cyclotomics $\Phi_{15},\Phi_{30}$.  F2 removes the latter;
exact ordered-radius/resultant/tail inequalities exclude the other $36$ by
cutoff $37$.  The smallest margin is $55.165\ldots>0$.

> **Theorem F8r (computer-assisted, exact).** No irreducible reciprocal
> octic divides any $F_X$.

See `RECIPROCAL_OCTIC.md` and `code/exp34_reciprocal_octic.py`.  The same
certificate applies Rabin's criterion modulo $71$ directly to $F_{19}$,
proving that degree-$17$ prefix irreducible and closing the residual $8+9$
possibility left by F7.  The first open layer is therefore specifically the
**nonreciprocal** octic layer.

### 2.8 Reciprocal parity resultants factor in every degree — PROVED

The sextic and octic square factorizations are instances of one exact
Joukowski identity.  Let a reciprocal monic factor of even degree split as

$$
g(x)=E(x^2)+xO(x^2),
\qquad T=y+y^{-1}.
$$

If $\deg g=4k$, write

$$
E=y^kA(T),\qquad O=y^{k-1}(y+1)B(T).
$$

Then

$$
\boxed{
\operatorname{Res}_y(E,O)
=E(-1)\operatorname{Res}_T(A,B)^2.
}
$$

If $\deg g=4k+2$, write

$$
E=y^k(y+1)A(T),\qquad O=y^kB(T).
$$

Then

$$
\boxed{
\operatorname{Res}_y(E,O)
=(-1)^kB(-2)\operatorname{Res}_T(A,B)^2.
}
$$

These are root-pair identities and remain valid through degree drops by
polynomial continuation.  For a divisor of an odd-support polynomial,
the parity-unit theorem therefore forces the distinguished evaluation and
the smaller Joukowski resultant separately to be units.  Equivalently,

$$
\boxed{g(i)\in\{\pm1,\pm i\}.}
$$

See `RECIPROCAL_RESULTANT.md` and
`code/exp35_reciprocal_resultant.py`; the latter gives exact regression
checks in degrees $4$ through $14$.  The square structure is classical:
it follows from Baker's reciprocal trace-resultant theorem (Monthly 2025,
Prop. 2.3), with antecedents in Loper--Werner and Gross--McMullen.  The
repo-specific contribution is the odd-support parity specialization and
Gaussian-unit consequence, which explain rather than merely repeat the
low-degree factorizations.

---

## 3. Theorem F2: the cyclotomic layer, solved globally

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

**Theorem F2 (global classification) — PROVED.** For every integer $m\ge1$
and every real $X\ge2$,
$$
\Phi_m\mid F_X
\iff
\bigl(m=2\text{ and }3\le X<5\bigr)
\text{ or }
\bigl(m=6\text{ and }11\le X<13\bigr).
$$
Equivalently, at prime cutoffs the only pairs $(X,m)$ are $(3,2)$ and
$(11,6)$.

The non-squarefree case is Theorem F2-ns.  In the squarefree case the forced
vector implies that every prime below the cutoff is covered by one of the
congruences $q\equiv r\pmod{m/r}$.  A largest-prime and Bertrand-postulate
argument reduces $m$ to $P$ or $2P$; one complete-residue-system theorem of
Hajdu--Saradha then leaves only $m=2,6$.  See `CYCLOTOMIC_TRACE.md` for the
full proof and exact citations.

Combining Theorems F1--F6: **for every $X\ge13$, $F_X$ has no
irreducible factor of degree $\le6$ and no cyclotomic factor of any degree.**
Every possible counterexample to Conjecture A″$_{\rm alg}$ must therefore come entirely
from non-cyclotomic factors of degree at least $7$.

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
count vector; non-squarefree $m$ have zero ties.  The former Conjecture F2∞ is
now Theorem F2: globally, only $(3,2)$ and $(11,6)$ occur at prime cutoffs.
For squarefree $m$, the decisive forced vector is
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

## 5. Why the factor program is stronger than rigidity — PROVED + DATA

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
after reversal — probability exponentially small in the degree. For actual
prime prefixes, `PARITY_RIGIDITY.md` now proves that this $0$--$1$
recombination never occurs, at any degree. The experiments remain useful as
calibration for prime-like sets without a singleton parity class.

**Consequence for the program.** The intermediate target of REPORT §8 Problem 1 ("no
reciprocal non-cyclotomic factor") splits cleanly now:
- degree $\le7$ factors: **classified unconditionally** (Thms F1, F3--F7);
- cyclotomic factors: **globally classified; only the two small ties** (Thm F2);
- a reciprocal non-cyclotomic factor must have even degree (odd-degree reciprocals
  have the root $-1$), and Theorem F8r excludes degree $8$; any such factor
  must therefore have degree at least $10$, Mahler measure in Lehmer's range, and both a root
  and its inverse inside the annulus $(\tfrac12,2)$ — Salem-type configurations; no
  instance was observed in 1200 random samples nor at any tested $X$.

---

## 6. Status and open problems

| layer of Conjecture A″$_{\rm alg}$ | status |
|---|---|
| factors of degree 1, 2, 3 | **PROVED impossible** for $X\ge13$ (Thms F1, F3) |
| irreducible factors of degree 4 | **PROVED impossible for every $X$ by an exact finite certificate** (Thm F4) |
| irreducible factors of degree 5 | **PROVED: only $F_7$ itself; impossible for $X\ge11$** (Thm F5) |
| reciprocal irreducible factors of degree 6 | **PROVED impossible for every $X$** (Thm F6r) |
| all irreducible factors of degree 6 | **PROVED impossible for every $X$ by an exact 362-case certificate** (Thm F6) |
| irreducible factors of degree 7 | **PROVED: only $F_{11}/\Phi_6$; impossible for $X\ge13$** (Thm F7) |
| reciprocal irreducible factors of degree 8 | **PROVED impossible for every $X$** (Thm F8r) |
| cyclotomic factors $\Phi_m$, every $m$ and $X$ | **PROVED: only $(3,2),(11,6)$ at prime cutoffs** (Thm F2) |
| recurrence for $\varphi(m)=2$ | **refuted**: drift ($m=3,6$) / parity ($m=4$); only distance-1 near-ties recur ($m=4$, Littlewood, unconditional) |
| non-cyclotomic factors, degree $\ge8$ | open; $F_X$ irreducible up to $X=5\cdot10^4$ (degree 49{,}997); independent of the now-proved $0$--$1$ phase rigidity |

Open problems generated: (1) attack the nonreciprocal octic layer, now the first open
factor degree; (2) the $X=10^5$ factorization ($\approx2$ h with FLINT at
current scaling).  The carrier theorem and F7 reduce $F_{19}$ to one
possible $8+9$ split, while the independent mod-$71$ certificate in exp34
closes even that prefix unconditionally.
