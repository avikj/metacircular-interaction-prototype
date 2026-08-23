# The circuit ladder, rung one: sieve circuits and unconditional λ-orthogonality

Executes blind spot 2 of `BLINDSPOTS.md` (the complexity-theory lens), task
"circuit ladder" (owner fleet-circuit). Companions: `PARITY.md` (Theorem P,
two spectral types), `GAUGE.md` (Theorem F, parity as protected charge),
`WIDTH.md` (the uniformity ladder that supplies every analytic input used
here). Model: B. Green, *On (not) computing the Möbius function using bounded
depth circuits*, arXiv:1103.4991 (Combin. Probab. Comput. 2012) — fetched and
read in full for this note; its actual proof structure (LMN Fourier
concentration + Kátai sparse-dyadic reduction + no-exceptional-zero trick at
2-power conductors) is dissected against ours in §6. Numerics:
`code/exp27_circuit.py`, `figures/exp27_circuit.png`.

Honesty header: every analytic input below is classical or recent published
work (Siegel–Walfisz transported to λ; Bombieri–Vinogradov for μ via
Motohashi's induction principle / Vaughan's identity, and its
multiplicative-function form in Granville–Shao ~~[cite-check journal data —
offline session]~~ Adv. Math. **350** (2019), 304–358, arXiv:1703.06865
[cite verified against source, cross-review msg 0028]; the
Montgomery–Vaughan Ex. 11.3.7 estimate; Green's
no-exceptional-zero observation for 2-power conductors). The contribution of
this note is: (i) the formalization of the class SIEVE_d(S,Q) and its
structure theory (normal form, periodicity collapse, provable incomparability
with AC⁰), (ii) Theorems 1/1″/2/3 — λ-orthogonality for the low rungs, with
the effective/ineffective and individual/averaged boundaries drawn exactly,
(iii) the restriction (W-trick) calculus, Lemma R, and the located obstruction
Prop 5.1, (iv) the precise naming of the open next rung. Ineffective
constants are flagged wherever Siegel is upstream. Proofs are given in full
where short; where an input is quoted, its source is named.

---

## 1. The classes SIEVE_d(S,Q)

Sample space $[X]=\{1,\dots,X\}$. All Boolean functions take values in
$\{0,1\}$.

**Definition 1.1 (sieve literal).** For $q\ge2$ and $0\le a<q$, the literal
$\ell_{q,a}(n) := 1_{q\,\mid\,n+a}$ — the indicator of the residue class
$n\equiv-a\pmod q$. Negated literals $\lnot\ell_{q,a}$ are permitted at the
input level (NOTs pushed to the inputs by De Morgan, as usual).

**Definition 1.2 (sieve circuit).** A *sieve circuit of depth $d$ and size
$S$ over modulus bound $Q$* is a directed acyclic graph with at most $S$
gates, each an AND or OR of unbounded fan-in, of gate-depth at most $d$,
whose inputs are (possibly negated) sieve literals with moduli $\le Q$.
$\mathrm{SIEVE}_d(S,Q)$ is the set of $f:[X]\to\{0,1\}$ so computed. The
**literal set** $\mathcal L(C)$ is the set of literals appearing;
the **lcm-complexity** is
$$L(C):=\operatorname{lcm}\{q:\ \ell_{q,a}\in\mathcal L(C)\}
\;\le\;\min\bigl(\operatorname{lcm}(1,\dots,Q),\,Q^{|\mathcal L(C)|}\bigr).$$

Depth 1 = a single gate on literals; depth 2 = OR-of-ANDs (DNF) or
AND-of-ORs (CNF).

**Lemma 1.3 (CRT normal form).** An AND of literals with moduli
$q_1,\dots,q_m$ is either identically $0$ or a single literal
$\ell_{L,c}$ with $L=\operatorname{lcm}(q_i)$: a simultaneous system of
congruences is one congruence mod the lcm when consistent. Hence every
depth-2 DNF of size $S$ is a union of at most $S$ residue classes whose
moduli are the AND-block lcms; "OR of $S$ literals" is the general depth-2
object up to this renormalization of moduli. $\square$

**Lemma 1.4 (periodicity collapse — the crucial difference from AC⁰).**
Every $f\in\mathrm{SIEVE}_d(S,Q)$, for **every** depth $d$ and size $S$, is
periodic with period dividing $L(C)$. Consequently, over the divisibility
basis, depth and size are invisible except through two parameters: the
lcm-complexity, and (when $L(C)>X$, §3) the multilinear expansion. Contrast:
AC⁰ over binary digits contains functions of every period up to $N$
(the top digit has period $N$), and there depth is the load-bearing
resource (LMN decay $2^{-t^{1/d}}$ degrades with $d$). *Proof.* Each literal
is periodic mod its $q$; Boolean combinations of periodic functions are
periodic mod the lcm. $\square$

**Lemma 1.5 (provable incomparability with AC⁰).** Neither class contains
the other, for any fixed $d\ge0,\ S,\ Q$ with $\operatorname{lcm}(1..Q)<N/2$,
over $\{0,\dots,N-1\}$:
1. $\ell_{3,0}=1_{3\mid n}\in\mathrm{SIEVE}_0(1,3)$ but
   $1_{3\mid n}\notin\mathrm{AC}^0$(binary digits): fixing the even-position
   bits to $0$ (a restriction, which preserves AC⁰) leaves
   $n\equiv 2\sum_{i\text{ odd}}x_i \pmod 3$, so a bounded-depth circuit for
   $1_{3|n}$ would compute $\mathrm{MOD}_3$ of the remaining bits, contradicting
   Razborov–Smolensky.
2. The top binary digit $1_{n\ge N/2}$ is an AC⁰ input literal (depth 0), but
   lies in no $\mathrm{SIEVE}_d(S,Q)$ with $\operatorname{lcm}(1..Q)<N/2$: a
   function of period $M<N/2$ cannot agree with a step function that is
   constant on $[0,N/2)$ and on $[N/2,N)$. $\square$

The two bases are *transverse*: divisibility bits are arithmetically aligned
with the multiplicative/periodic structure that λ lives against; binary
digits are aligned with the archimedean/interval structure. Green's theorem
and the theorems below are therefore about genuinely different function
classes, and neither implies the other (§6).

**Remark 1.6 (degenerate regimes and the canonical parameter window).**
(i) With $Q>X$ unrestricted, a single literal is a Dirac mass on $[X]$ and
$\mathrm{SIEVE}_2(S,\cdot)$ contains every $S$-point set: the class
trivializes into sparse sets. (ii) A literal at modulus $q$ has mass
$\|\ell_{q,a}\|_1\asymp X/q$; once $q>X^{1/2}$ this mass falls below the
global random-walk fluctuation $\sqrt X$ of $\sum_{n\le X}\lambda(n)$, and
cancellation *within* the class stops being certifiable against the trivial
bound by any global second-moment statistic. The moduli
ceiling $q\le X^{1/2-\varepsilon}$ of §3 is thus not an artifact: it is where
the *statement* of orthogonality stops degenerating, and it coincides with
the unconditional ceiling $\theta=1/2$ of the width ladder
(`WIDTH.md` §2(b)). The circuit ladder's moduli range *is* the parity
barrier's width ladder, literal by literal.

---

## 2. The small-lcm rungs: periodicity is everything, depth is free

**Theorem 1 (small-lcm orthogonality; unconditional, ineffective, all
depths).** For every $A,B>0$: if $f\in\mathrm{SIEVE}_d(S,Q)$ is computed by a
circuit $C$ with $L(C)\le(\log X)^A$ — any $d$, any $S$ — then
$$\Bigl|\sum_{n\le X}\lambda(n)f(n)\Bigr|\;\ll_{A,B}\;X(\log X)^{-B},$$
with ineffective constant (Siegel).

*Proof.* $f$ is periodic mod $L:=L(C)\le(\log X)^A$ (Lemma 1.4), so
$f=\sum_{b\bmod L}f(b)\,1_{n\equiv b\,(L)}$ and
$$\Bigl|\sum_{n\le X}\lambda f\Bigr|\le\sum_{b\bmod L}|D_\lambda(X;L,b)|
\le L\cdot\sup_{b}|D_\lambda(X;L,b)|\ll_{A,B'}L\,X(\log X)^{-B'}$$
by Siegel–Walfisz transported to $\lambda$, uniformly over all residues
(`WIDTH.md` §2(a): $\lambda=\mu*1_\square$; ineffective). Take $B'=A+B$.
$\square$

Three comments. (i) *Depth is free*: the entire hierarchy over small-lcm
divisibility data collapses to periodicity — the polar opposite of the AC⁰
situation, where Green needs LMN concentration precisely because depth-$d$
digit circuits are *not* structured. (ii) For a *fixed* circuit (fixed $L$),
the constant is effective and the saving improves to
$X e^{-c_L\sqrt{\log X}}$, with $c_L$ computable for any given $L$ by
checking the finitely many real characters mod $L$ for real zeros near $1$
(a finite verification, as Green performs for $L=2^t$); ineffectivity enters
only through uniformity in $L$. (iii) The theorem is exactly the quantitative
form of `GAUGE.md` Theorem F's zeroth level for this class: the equilibrium
(profinite) sector carries no parity, now with a rate, for every circuit
whose profinite footprint is polylogarithmic.

**Theorem 1″ (the Green port: dyadic circuits, effective, superlogarithmic
lcm).** There are effective constants $c,c'>0$ such that: if all moduli of
$C$ are powers of two and $L(C)=2^t\le e^{c\sqrt{\log X}}$, then for any
depth and size,
$$\Bigl|\sum_{n\le X}\lambda(n)f(n)\Bigr|\;\ll\;X\,e^{-c'\sqrt{\log X}},
\qquad\text{effectively.}$$

*Proof.* Step 1 (Green's Theorem ~~4~~ 3 [arXiv v2 source numbering,
checked msg 0028], λ-version). For $\chi$ mod $2^s\le
e^{c_2\sqrt{\log Y}}$: there are exactly three nonprincipal primitive real
characters of 2-power conductor ($\chi_4,\chi_8,\chi_4\chi_8$), and none has
a real zero in $(\tfrac12,1]$ (Ramaré–Rumely; explicit, hence effective), so
the Montgomery–Vaughan Ex. 11.3.7 bound applies with no exceptional zero:
$|\sum_{m\le Y}\mu(m)\chi(m)|\ll Y e^{-c_2\sqrt{\log Y}}$. Transfer to λ by
$\lambda=\mu*1_\square$:
$\sum_{n\le Y}\lambda\chi=\sum_{d}\chi^2(d)\sum_{m\le Y/d^2}\mu\chi$; split
$d\le e^{\frac{c_2}4\sqrt{\log Y}}$ (each inner sum saves
$e^{-\frac{c_2}{\sqrt2}\sqrt{\log Y}}$ since $\log(Y/d^2)\ge\frac12\log Y$)
from the tail ($\le Y/D$). Both are $\ll Ye^{-c_3\sqrt{\log Y}}$.
Step 2 (all residues mod $2^t$). For $a$ with $v:=v_2(a)<t$:
$n\equiv a\,(2^t)$ forces $n=2^v n'$, $n'$ odd, and
$\lambda(n)=(-1)^v\lambda(n')$, reducing to an odd residue mod $2^{t-v}$ at
scale $X/2^v$; odd residues are resolved by the characters mod $2^{t-v}$
(which vanish on even integers, so the character decomposition is exact),
giving $|D_\lambda(X;2^t,a)|\ll Xe^{-c_3\sqrt{\log X}}$ for
$2^t\le e^{c_3\sqrt{\log X}}$; the class $a\equiv0$ reduces to the plain PNT
for λ. Step 3. Sum over the $\le 2^t$ residue classes of the period as in
Theorem 1, absorbing $2^t\le e^{\frac{c_3}2\sqrt{\log X}}$. $\square$

This is Green's no-exceptional-zero trick transferring *verbatim*, and it
marks the effective/ineffective boundary exactly: at 2-power (more generally,
fixed-conductor-set) moduli the lcm range jumps from $(\log X)^A$ to
$e^{c\sqrt{\log X}}$ *with* effectivity; for general moduli that range is
Siegel-obstructed. Green's cap $|S|\lesssim n^{1/2}$ on Fourier–Walsh sets
and our dyadic-lcm cap $e^{c\sqrt{\log X}}$ are the *same wall* — the
classical zero-free region — seen from the two bases.

---

## 3. The BV rung: bounded size, large moduli — the first non-periodic
theorem

Here the class escapes periodicity: an OR of $S$ literals at moduli
$q_i\sim X^{1/2-\varepsilon}$ has $L(C)\asymp\prod q_i\gg X$ — no period fits
in the window, Lemma 1.4 gives nothing, and the function is a genuine
*sieve union* (size-$S$ union of sparse residue classes). This is the
proof-of-concept rung: orthogonality that is not a periodicity statement.

**Input (BV$_\lambda$).** For every $A>0$ there is $B=B(A)$ such that, for
every scale $Y\in[X^{1/2},X]$,
$$\sum_{q\le Y^{1/2}(\log Y)^{-B}}\ \max_{(a,q)=1}\,|D_\lambda(Y;q,a)|
\;\ll_A\;Y(\log Y)^{-A}.$$
*Provenance.* Bombieri–Vinogradov for $\mu$ is classical (Vaughan's identity
+ large sieve, exactly as for primes; systematically: Motohashi's induction
principle, Proc. Japan Acad. 52 (1976), 273–275 [verified to exist with this
title/volume, msg 0028]; multiplicative-function form:
Granville–Shao ~~2018 [cite-check]~~ Adv. Math. 350 (2019), 304–358
[verified, msg 0028]. *Caveat added in cross-review:* the general
Granville–Shao theorem — $f\in\mathcal C$ (Λ-dominated, includes 1-bounded
completely multiplicative) satisfying a 1-Siegel–Walfisz criterion, level
$x^{1/2-\delta}$ — saves only a factor $(\log x)^{1-\varepsilon}$, and their
Prop. on large-prime obstructions shows this is best possible for *general*
$f$; the arbitrary-$(\log X)^{-A}$ form of BV$_\mu$ used below is the
classical $\mu$-specific statement via Vaughan + large sieve, as listed
first — the citation order here is load-bearing, not decorative.)
Transfer to λ by $\lambda=\mu*1_\square$:
for $(a,q)=1$, $D_\lambda(X;q,a)=\sum_{d\le\sqrt X,(d,q)=1}
D_\mu(X/d^2;q,ad^{-2})$; summing $\max_a$ over $q\le\mathcal Q$ and splitting
$d\le(\log X)^{B_1}$ (BV$_\mu$ at scale $X/d^2$, level
$\mathcal Q\le(X/d^2)^{1/2}(\log)^{-B'}$, which holds for
$\mathcal Q=X^{1/2}(\log X)^{-B-B_1}$) from the tail
($\ll X(\log X)^{1-B_1}+\mathcal Q\sqrt X$) gives BV$_\lambda$. Constants
ineffective (Siegel–Walfisz sits inside BV$_\mu$). $\square$

**Lemma 3.1 (all-residue extension).** With
$\mathcal Q=X^{1/2}(\log X)^{-B}$: for every $A$ there is $B$ with
$$\sum_{q\le\mathcal Q}\ \max_{a\bmod q}\,|D_\lambda(X;q,a)|\ \ll_A\
X(\log X)^{-A},$$ the max now over **all** residues.

*Proof.* For $g:=\gcd(a,q)$: $n\equiv a\,(q)$ forces $g\mid n$, and complete
multiplicativity gives the exact reduction
$D_\lambda(X;q,a)=\lambda(g)\,D_\lambda(X/g;\,q/g,\,a/g)$ with
$(a/g,q/g)=1$. Hence
$$\sum_{q\le\mathcal Q}\max_{a}|D_\lambda(X;q,a)|
\le\sum_{g\le\mathcal Q}\ \sum_{q'\le\mathcal Q/g}\
\max_{(a',q')=1}|D_\lambda(X/g;q',a')|,$$
and each inner sum is BV$_\lambda$ at scale $Y=X/g\ge X^{1/2}$ (the level
condition $\mathcal Q/g\le Y^{1/2}(\log Y)^{-B}$ is implied by
$\mathcal Q=X^{1/2}(\log X)^{-B}$ and $g\le\mathcal Q$), so the double sum is
$\ll_{A'}\sum_{g\le\mathcal Q}(X/g)(\log X)^{-A'}\ll X(\log X)^{1-A'}$. Take
$A'=A+1$. $\square$

**Lemma 3.2 (the bad-modulus set).** For every $A,C>0$ there are
$B$ and a set $E=E_{X,A,C}\subseteq[1,\mathcal Q]$,
$\mathcal Q=X^{1/2}(\log X)^{-B}$, with
$$\sum_{q\in E}\frac1q\;\ll\;(\log X)^{-C},\qquad\text{and}\qquad
\max_{a\bmod q}|D_\lambda(X;q,a)|\le\frac Xq(\log X)^{-A}
\ \ \text{for all }q\le\mathcal Q,\ q\notin E.$$
*Proof.* Define $E$ as the set of failures; by Lemma 3.1 (applied with
$A+C$), $\sum_{q\in E}\frac1q\le\frac{(\log X)^A}X\sum_q\max_a|D_\lambda|
\ll(\log X)^{-C}$. $\square$

$E$ depends only on $X$ and the parameters — **not on any circuit** — and is
ineffective.

**Theorem 2 (bounded-size sieve circuits at large moduli; unconditional).**
Fix $A,\eta>0$ and $S\ge1$. Let $\mathcal Q=X^{1/2}(\log X)^{-B(A)}$ and let
$E$ be the bad set of Lemma 3.2 (with $C=A$). Let $q_1,\dots,q_S$ be
**pairwise coprime** moduli with
$$q_i\in[X^{1/4+\eta},\ \mathcal Q],\qquad q_i\notin E,$$
let $a_1,\dots,a_S$ be arbitrary residues, and let $F:\{0,1\}^S\to\{0,1\}$
be **any** Boolean function. Then $f:=F(\ell_{q_1,a_1},\dots,\ell_{q_S,a_S})$
satisfies
$$\Bigl|\sum_{n\le X}\lambda(n)f(n)\Bigr|\;\le\;C_A\Bigl[
F(\mathbf 0)\,X e^{-c\sqrt{\log X}}
\;+\;(\log X)^{-A}\sum_{i=1}^S\frac X{q_i}
\;+\;4^S\,X^{1/2-2\eta}\Bigr].$$
In particular, for a pure union ($F=\mathrm{OR}$, so $F(\mathbf 0)=0$) with
$S\le\eta\log X/3$:
$$\Bigl|\sum_{n\le X}\lambda(n)\bigvee_i\ell_{q_i,a_i}(n)\Bigr|
\;\ll_A\;(\log X)^{-A}\,\Bigl\|\bigvee_i\ell_i\Bigr\|_1 ,$$
cancellation at the scale of the union's mass.

*Proof.* Multilinear expansion: $F(x)=\sum_{T\subseteq[S]}c_T\prod_{i\in T}x_i$
with $c_T=\sum_{U\subseteq T}(-1)^{|T\setminus U|}F(\mathbf 1_U)$, so
$|c_T|\le2^{|T|}$. By pairwise coprimality and CRT,
$\prod_{i\in T}\ell_{q_i,a_i}=1_{n\equiv b_T\,(L_T)}$ with
$L_T=\prod_{i\in T}q_i$ (always consistent). Hence
$$\sum_{n\le X}\lambda f=c_\varnothing\sum_{n\le X}\lambda(n)
+\sum_{T\ne\varnothing}c_T\,D_\lambda(X;L_T,b_T).$$
$T=\varnothing$: $c_\varnothing=F(\mathbf 0)$ and
$\sum_{n\le X}\lambda(n)\ll Xe^{-c\sqrt{\log X}}$ (PNT for λ, effective).
$|T|=1$: $|c_{\{i\}}|\le2$ and $q_i\notin E$ gives
$\le2(X/q_i)(\log X)^{-A}$.
$|T|\ge2$: $L_T\ge X^{1/2+2\eta}>\mathcal Q$, and the **trivial** bound
$|D_\lambda(X;L_T,b_T)|\le X/L_T+1\le X^{1/2-2\eta}+1$ suffices; there are
$\le2^S$ such terms with coefficients $\le2^S$. Collect. For the pure-union
corollary: Bonferroni gives
$\|f\|_1\ge\sum_iX/q_i-\sum_{i<j}(X/(q_iq_j)+1)\ge(1-o(1))\sum_iX/q_i$ in
the stated range, and $4^SX^{1/2-2\eta}\le(\log X)^{-A}\sum_iX/q_i$ for
$S\le\eta\log X/3$. $\square$

Note what the proof shows: at bounded size and pairwise coprime large
moduli, **arbitrary Boolean structure — any depth — is again free** (the
$2^S$-term expansion never sees the circuit). Depth becomes a genuine
resource only when $S$ is large enough that expansion is impossible
($S\gg\log X$, §5) — precisely the situation where Håstad-style arguments
earn their keep in the Boolean world.

**Theorem 2′ (fully averaged form; unconditional, no exceptional set).** For
every $A$ there is $B$: with $\mathcal Q=X^{1/2}(\log X)^{-B}$, for every
$S$,
$$\frac1{\mathcal Q^S}\sum_{q_1,\dots,q_S\le\mathcal Q}\ \max_{a_1,\dots,a_S}
\Bigl|\sum_{n\le X}\lambda(n)\bigvee_{i\le S}\ell_{q_i,a_i}(n)\Bigr|
\;\ll_A\;S\,\frac{X(\log X)^{-A}}{\mathcal Q}
\;+\;S^2\Bigl(\frac{X\log^3X}{\mathcal Q^2}+1\Bigr).$$
*Proof.* $|\lambda$-sum$|\le\sum_i\max_a|D_\lambda(X;q_i,a)|
+\sum_{i<j}(X/\mathrm{lcm}(q_i,q_j)+1)$ (Bonferroni). Average the first term
coordinate-wise by Lemma 3.1; for the second,
$\sum_{q,q'\le\mathcal Q}1/\mathrm{lcm}(q,q')
=\sum_{q,q'}\gcd(q,q')/(qq')\ll\log^3\mathcal Q$. $\square$
Since the mean literal mass is $\mathbb E_q[X/q]\asymp X\log\mathcal Q/
\mathcal Q$, this is again a $(\log X)^{-A}$ *relative* saving, now for the
**average** circuit with no excluded moduli.

**Which statements are unconditional — the exact boundary.**
- Theorem 2 (pointwise in the circuit, moduli avoiding $E$): unconditional;
  $E$ is circuit-independent but ineffective and non-explicit.
- Theorem 2′ (averaged over moduli): unconditional, no exceptional set;
  ineffective constants only.
- The *individual* statement for **every** tuple (empty bad set) is not a
  theorem and is Siegel-hard already at $S=1$: a power-saving — indeed any
  fixed-power — individual bound at a single modulus
  $q\sim X^{\theta}$, $\theta>0$, at one real character implies an effective
  zero-free region (`WIDTH.md` §3, Lemma W1). The circuit ladder does not
  circumvent the width ladder; it inherits it literal-by-literal.
- Under GRH: $|D_\lambda(X;q,a)|\ll X^{1/2}\log^2X$ for all $q$, so every
  circuit of Theorem 2's shape with moduli $\le X^{1/2-\varepsilon}$, no
  coprimality or bad-set hypothesis, and $S\le\varepsilon\log X/2$ is
  orthogonal individually. (GRH collapses this rung entirely, consistent
  with `WIDTH.md` §2's "GRH collapses the ladder to one line".)

---

## 4. The restriction calculus: the W-trick as a structure-simplifying
operator

Håstad's engine is the random restriction: fix a random subset of input
bits; AC⁰ circuits simplify (switching lemma), while the target PARITY
restricts to PARITY of the free bits — *self-similarity of the target,
simplification of the class*. Here is the exact sieve analog and its
calculus.

**Lemma R (W-trick as restriction).** Let $\rho_{W,r}:m\mapsto Wm+r$
($0\le r<W$) restrict $[X]$ to the fiber $r+W\mathbb Z$. Then:

1. *(Literal transformation.)* With $g:=\gcd(q,W)$:
$$\ell_{q,a}\circ\rho_{W,r}=\begin{cases}
0\ (\text{constant}) & g\nmid r+a,\\[2pt]
\ell_{q/g,\,a'}\ \text{for some }a' & g\mid r+a,
\end{cases}$$
by the theory of the linear congruence $Wm\equiv-(r+a)\ (q)$: solvable iff
$g\mid r+a$, and then the solutions form a *single* class mod $q/g$. In
particular every literal with $q\mid W$ becomes a **constant**
($1_{q\mid r+a}$), and every literal with $(q,W)=1$ survives as a literal at
the **same modulus**.
2. *(Class map.)* $\rho_{W,r}$ maps $\mathrm{SIEVE}_d(S,Q)\to
\mathrm{SIEVE}_{d'}(S',Q')$ with $d'\le d$, $S'\le S$, $Q'\le Q$, each
surviving modulus divided by $\gcd(q,W)$; gates fed constants simplify
(AND absorbing 0, OR absorbing 1 die), exactly as under Boolean
restrictions.
3. *(Composition.)* ~~$\rho_{W_2,r_2}\circ\rho_{W_1,r_1}=\rho_{W_1W_2,\,
r_1+W_1r_2}$~~ $\rho_{W_2,r_2}\circ\rho_{W_1,r_1}=\rho_{W_1W_2,\,W_2r_1+r_2}$:
restrictions form a monoid; iterated W-tricks are one W-trick.

> **Offset corrected in place (SEED-109, 2026-08-14, Rule K3; found and
> announced by codex-random-weil-06,
> `collab/messages/codex-random-weil-06/20260814T0710Z-restriction-composition-correction.md`,
> which deferred the edit "once the stream is clean" and never made it).**
> $(\rho_{W_2,r_2}\circ\rho_{W_1,r_1})(m)=W_2(W_1m+r_1)+r_2=W_1W_2m+(W_2r_1+r_2)$,
> so the struck offset $r_1+W_1r_2$ belongs to the *opposite* composite
> $\rho_{W_1,r_1}\circ\rho_{W_2,r_2}$; the semigroup is non-commutative. The
> modulus $W_1W_2$, the monoid claim, and every use of R.3 downstream (which
> apply a single restriction, or only need the modulus) are unaffected — see
> `notes/LENS_CIRCUIT_COMPOSITION_CORRECTION.md`.
4. *(The unique self-similar fiber.)* On the fiber $r=0$:
$\lambda(Wm)=\lambda(W)\lambda(m)$ — the target restricts to (a sign times)
itself, exactly as PARITY does under bit restriction. On every fiber
$r\ne0$, $\lambda(Wm+r)$ is λ-in-a-progression: **the target is not
self-similar off the zero fiber.** This asymmetry (Boolean PARITY is
self-similar on *all* fibers, λ on *one*) is the first structural failure of
the switching-lemma transfer, and it is why our fiber analysis below runs
through progression theorems (BV) rather than through induction on the
target. $\square$

The restriction lemma is not decoration; it proves the mixed-moduli theorem
that neither Theorem 1 nor Theorem 2 covers alone:

**Theorem 3 (mixed circuits, via restriction).** Fix $A,A_0,\eta$, and let
$W\le(\log X)^{A_0}$. Let $f$ be any Boolean function of
(a) literals with moduli dividing $W$, and (b) literals
$\ell_{q_1,a_1},\dots,\ell_{q_S,a_S}$ with $q_i$ pairwise coprime, coprime
to $W$, $q_i\in[X^{1/4+\eta},\mathcal Q/W]$, and $Wq_i\notin E$ (the bad set
of Lemma 3.2). Then
$$\Bigl|\sum_{n\le X}\lambda(n)f(n)\Bigr|\ \ll_{A,A_0}\
X(\log X)^{-A}\;+\;(\log X)^{-A}\sum_i\frac X{q_i}
\;+\;(\log X)^{A_0}4^S X^{1/2-2\eta}.$$
*Proof.* Decompose $[X]$ into the $W$ fibers $\rho_{W,r}$. On each fiber the
type-(a) literals are constants (Lemma R.1), so
$f\circ\rho_{W,r}=F_r(\ell'_1,\dots,\ell'_S)$ with the $\ell'_i$ literals at
the original moduli $q_i$ (Lemma R.1, coprime case) and $F_r$ Boolean.
Expand multilinearly as in Theorem 2; the term $T$ on fiber $r$ is a single
class mod $WL_T$ (CRT: all moduli coprime). $|T|=1$: modulus
$Wq_i\le\mathcal Q$, not in $E$; summing the bound
$2(X/(Wq_i))(\log X)^{-A}$ over the $W$ fibers gives
$2(X/q_i)(\log X)^{-A}$. $|T|\ge2$: trivial bound, $\le4^SX^{1/2-2\eta}$
per fiber, $W$ fibers. $T=\varnothing$: $|D_\lambda(X;W,r)|$ summed over
fibers, $\ll_{A,A_0}X(\log X)^{-A}$ by Siegel–Walfisz (Theorem 1's input) at
modulus $W\le(\log X)^{A_0}$. $\square$

This is the W-trick doing exactly what random restriction does for Håstad:
*killing the structured (smooth-modulus) part of the circuit so that the
genuinely hard (large-coprime-modulus) part is exposed to the strongest
available estimate.* Iterating restrictions (Lemma R.3) composes cleanly;
what it cannot do is the subject of §5.

---

## 5. The next rung, stated honestly

What would a Håstad-style induction to depth 3 need? Take a depth-3 circuit,
say OR of ANDs of ORs of literals, size $S=(\log X)^C$. The switching move
would be: apply a random restriction under which each bottom OR collapses
(to a constant or a short AND), swap, merge depths, recurse to the depth-2
base case. Two precise obstructions, and then the precise open statement.

**Proposition 5.1 (profinite restrictions cannot switch prime literals).**
Let $\ell_{q,a}$ have prime modulus $q>W$, $q\le X/W$. Then for every fiber
$\rho_{W,r}$, $\ell_{q,a}\circ\rho_{W,r}$ is a non-constant literal at the
*same* modulus $q$ (Lemma R.1 with $g=1$; non-constancy uses $q\le X/W$, so
the fiber contains a full period). Consequently, for any restriction budget
$W\le X^{o(1)}$: a bottom-level OR of $2\le t\le X^{\varepsilon/2}$ literals
at distinct prime moduli in $(X^{\varepsilon},\,X^{1-\delta}]$ retains, on
**every** fiber, all $t$ of its literals at their original moduli — no fiber
makes it constant (each surviving class is nonempty in a fiber of length
$X/W\ge q$, and their union covers $\le\sum_i(X/(Wq_i)+1)\le
(X/W)(X^{-\varepsilon/2}+tW/X)<X/W$ points of the fiber), and no fiber
reduces its width. Profinite restriction has zero switching power against
prime-modulus literals. $\square$

[Cross-review edit, msg 0028: the original statement bounded the moduli only
from below ($>X^\varepsilon$) and put no cap on $t$; then "each surviving
class is nonempty in a fiber of length $X/W\ge q$" is unjustified for
$q>X/W$, and "$\sum_i 1/q_i<1$" can fail for $t\ge X^\varepsilon$ (Mertens:
the sum over all primes in $(X^\varepsilon,X^{1/2}]$ is
$\log(1/2\varepsilon)+o(1)$, which exceeds $1$ for small $\varepsilon$). The
added caps $q\le X^{1-\delta}$, $t\le X^{\varepsilon/2}$ restore the claim
and are automatic in the standing regime of §3 ($q\le\mathcal Q\le X^{1/2}$,
$t\le S\le\mathrm{poly}\log X$); the core structural claim — every literal
survives at its original modulus, zero width reduction, for **any** $t$ —
needs no caps and is unconditional.]

Together with Lemma W1 (`WIDTH.md` §3: individual savings at one large
modulus $\Rightarrow$ effective zero-free region), this locates the barrier
precisely: *any depth-reduction argument whose base case requires individual
estimates at unaveraged large prime moduli is Siegel-hard, and profinite
restrictions cannot remove those literals first.* The Boolean switching
lemma's power comes from the independence of bit-kills under random
restriction; sieve restrictions kill exactly the $W$-smooth part of the
literal set — kills are determined by multiplicative structure, never
independent, never touching prime moduli above the budget.

**Open Rung R3 (named: the bilinear switching lemma / well-factorable
BV$_\lambda$).** The two routes, either of which climbs to the next rung; we
state both precisely and claim neither.

*Route A (analytic — extend the base case).* **WF-BV$_\lambda(\theta)$:**
for every $A$ there is $B$ such that
$$\sum_{\substack{L\le X^{\theta}(\log X)^{-B}\\ L=q_1q_2,\ q_j\le X^{1/2-\varepsilon}}}
\max_{a\bmod L}\,|D_\lambda(X;L,a)|\ \ll_A\ X(\log X)^{-A}.$$
Known: $\theta\le1/2$ (this is BV$_\lambda$; no factorization structure
needed). Granville–Shao reach $\theta=20/39$ for single moduli and *fixed*
residues — the only known crossing, insufficient here (we need the max, and
products). If WF-BV$_\lambda(\theta)$ holds for some $\theta>1/2$, then
Theorem 2's proof extends verbatim to non-coprime moduli pairs whose lcms
fall in $[\mathcal Q,X^\theta]$ (the currently-trivial middle range), and
for $\theta>1-\varepsilon'$ the pairwise-coprimality and quarter-power-floor
hypotheses of Theorem 2 can be dropped entirely (all subset-lcms either in
the controlled range or above $X^\theta$ where the trivial bound wins). This
is the λ-analog of the Bombieri–Friedlander–Iwaniec / Zhang well-factorable
program, at lcm-structured moduli.

*Route B (combinatorial — a switching operator that is not profinite).* An
operator $\mathcal R$ on depth-2 sieve circuits and a measure on its
instances such that (i) $\mathcal R$ simplifies: with high probability a
size-$S$ CNF over literals at moduli $\le X^{1/2-\varepsilon}$ maps to a
width-$O(\log S)$ object in a class where Theorem 2/3-type estimates close;
(ii) $\mathcal R$ interacts with λ through *bilinear* (Type-II) structure
rather than through congruence fixing — because Prop 5.1 shows congruence
fixing has no switching power at prime moduli, while the known
parity-breaking results (Friedlander–Iwaniec asymptotic sieve, Vinogradov
type-II, Matomäki–Radziwiłł–Tao) all couple through bilinear forms
(`GAUGE.md` §F.3's "extra input", now with a precise job description:
*be the switching lemma*). We do not know a candidate $\mathcal R$; we
record the specification, not a construction.

**The expansion wall (why R3 is where circuit complexity genuinely
enters).** Every theorem in this note ultimately expands the circuit into
$\le2^S$ congruence terms. For $S\gg\log X$ the expansion exceeds $X$ and no
term-wise estimate — not even GRH's $X^{1/2}\log^2X$ per term — can survive
the coefficients: brute multilinearization is over at $S\asymp\log X$.
Reaching $S=(\log X)^C$, the honest analog of AC⁰'s polynomial size
($n^d=(\log X)^d$ gates on $n=\log X$ inputs!), requires an argument that
never expands — i.e., a switching argument. On the Boolean side LMN plays
that role below Håstad; on the sieve side the role is **vacant**. Rung R3 is
the request to fill it.

---

## 6. Honest comparison with Green 2012

Green's theorem: $F\in\mathrm{AC}^0(d)$ on binary digits of $x<N=2^n$
$\Rightarrow\ \mathbb E_{x<N}\,\mu(x)F(x)=O(e^{d\log n-cn^{1/6d}})$. Proof
skeleton (from the paper, §§2–4): (1) LMN: depth-$d$ size-$M$ circuits have
Fourier–Walsh mass $\le2M2^{-t^{1/d}/20}$ above level $t$; (2) Kátai /
Harman–Kátai: a large Walsh coefficient $\hat\mu(S)$, $|S|=k$, forces a
large *traditional* Fourier coefficient at a **sparse dyadic rational**
$\theta=\sum r_j2^{-i_j}$; (3) Vaughan-identity minor-arc bound: large
$\hat\mu(\theta)$ forces $\theta$ near a rational with small denominator;
(4) the Harman–Kátai diophantine lemma: a sparse dyadic rational near a
small-denominator rational has denominator a **power of two**; (5) at
2-power conductors there are only three real primitive characters, none with
an exceptional zero (Ramaré–Rumely), so Montgomery–Vaughan Ex. 11.3.7 gives
the **effective** $e^{-c\sqrt{\log N}}$ that closes the argument.

| Green's ingredient | status in the sieve-circuit world |
|---|---|
| (1) LMN Fourier concentration | **not needed / trivialized**: Lemma 1.4 — sieve circuits are *exactly* periodic, i.e. Fourier-supported on rationals of height $\le L(C)$; the "concentration" is an identity, not an estimate. This is what "arithmetically aligned literals" means. |
| (2) Kátai sparse-dyadic reduction | **not needed**: literals are already characters' territory; no basis mismatch to bridge. |
| (3) Vaughan minor arcs | absent at small lcm; reappears at large moduli **inside** the proof of BV$_\lambda$ (Theorem 2's input) — same tool, one level down. |
| (4) Harman–Kátai diophantine lemma | no analog needed (no dyadic approximation step exists). |
| (5) no exceptional zero at 2-power conductors | **transfers verbatim** = our Theorem 1″; the effective/ineffective boundary maps exactly. |
| Håstad switching (not used by Green; the road to stronger classes) | analog obstructed: Prop 5.1 (prime-modulus literals immune to profinite restriction) + Lemma R.4 (λ self-similar on one fiber only). Open Rung R3. |
| his class cap $|S|\lesssim\sqrt n$ (beyond needs GRH / Mauduit–Rivat / Bourgain) | our lcm cap $e^{c\sqrt{\log X}}$ at dyadic moduli; general moduli capped at $(\log X)^A$ by Siegel — the same zero-free-region wall in both bases. |

**The classes are incomparable** (Lemma 1.5): $\mathrm{MOD}_3$ separates
SIEVE from AC⁰, the top digit separates AC⁰ from SIEVE. Neither Green's
theorem nor ours implies the other; they are the *same program* (Möbius/
Liouville randomness against a computationally defined class) executed over
transverse bases. And the difficulty inverts: Green's hard step is bridging
the digit basis to the multiplicative world (his §3–4 are the whole paper);
for us the bridge is free and all difficulty migrates to the arithmetic
depth of the estimates (Siegel, BV, beyond-half levels). Circuit depth,
which for Green is the resource that LMN meters, is for us free at small lcm
(Lemma 1.4), free again at bounded size (Theorem 2's arbitrary $F$), and
becomes meaningful only at the expansion wall $S\gg\log X$ — which is
exactly where our unconditional technology ends. The two ladders are
complementary: his is capped by Fourier concentration, ours by
equidistribution level.

---

## 7. Numerics (exp27): the rungs cast no shadow at $X=2\cdot10^6$

`code/exp27_circuit.py`: $\lambda$ sieved to $X=2\cdot10^6$
($\sum\lambda=-1234$, well inside $\sqrt X$); 200 random circuits per cell;
families: pure unions (OR of $S$ literals, $q$ uniform $\le Q$), AND-blocks
(OR of $S$ two-literal ANDs), and BV-window unions (OR of $S$ literals at
prime $q\in[500,1400]\sim X^{1/2-\varepsilon}$ — Theorem 2's regime).
Statistic: $|\sum\lambda f|/\sqrt{\|f\|_1}$ — correlation in units of
Bernoulli sqrt-cancellation (null: half-normal, median $0.674$, expected max
over 200 trials $\approx3.26$).

| family | S | Q | median | max |
|---|---|---|---|---|
| union | 4 | 100 | 0.779 | 3.481 |
| union | 16 | 100 | 0.847 | 2.706 |
| union | 64 | 100 | 0.873 | 1.968 |
| union | 4 | 10000 | 0.677 | 3.000 |
| union | 16 | 10000 | 0.667 | 2.953 |
| union | 64 | 10000 | 0.717 | 3.292 |
| andblock | 4 | 100 | 0.734 | 3.022 |
| andblock | 16 | 100 | 0.792 | 3.020 |
| andblock | 64 | 100 | 0.871 | 3.237 |
| andblock | 4 | 10000 | 0.512 | 1.732 |
| andblock | 16 | 10000 | 0.730 | 2.840 |
| andblock | 64 | 10000 | 0.694 | 2.785 |
| bvwindow | 4 | $p\sim[500,1400]$ | 0.661 | 2.534 |
| bvwindow | 16 | $p\sim[500,1400]$ | 0.730 | 3.321 |
| bvwindow | 64 | $p\sim[500,1400]$ | 0.739 | 2.967 |

Every cell is consistent with the half-normal null (all max-ratios have
null $p>0.09$; the single largest, $3.48$ at union/$S{=}4$/$Q{=}100$, has
$p\approx0.095$ over 200 draws — an ordinary extreme). Medians hug $0.674$
(small upward drift at $Q{=}100$/large $S$ reflects overlap correlations
between the $S$ classes, not a λ signal — the andblock $Q{=}10^4$ cells,
where classes are near-disjoint, sit at and below the null median).
**Reading**: no random depth-2 sieve circuit, at any tested size or modulus
scale including the BV window, extracts any parity signal beyond
sqrt-cancellation — the empirical behavior is *stronger* than the proven
$(\log X)^{-A}$ bounds (which are invisible at this $X$), exactly as in
exp24: the theorems bound what can be guaranteed; the truth at polynomial
scales looks Bernoulli. The barrier's camouflage extends over the circuit
classes. `figures/exp27_circuit.png`.

---

## 8. Status

- Definitions and structure theory (§1): new packaging; Lemma 1.5's
  separations are standard-technique (Razborov–Smolensky; periodicity) but
  we have not seen the classes $\mathrm{SIEVE}_d(S,Q)$ isolated before.
  [Recorded search: Green 2012 and its citing literature treat AC⁰ on
  digits; Allender–Saks–Shparlinski treat primality in AC⁰; we found no
  formalization of divisibility-basis circuit classes vs λ. Novelty claim:
  *modest* — the theorems are assembled from classical inputs; the class
  formalization and the located obstruction (Prop 5.1) are the new content.]
- Theorem 1: proved (input: Siegel–Walfisz for λ, `WIDTH.md` §2(a)).
  Ineffective.
- Theorem 1″: proved (inputs: MV Ex. 11.3.7, Ramaré–Rumely as quoted by
  Green; λ-transfer written out). Effective.
- Theorems 2/2′/3, Lemmas 3.1/3.2, Lemma R: proved modulo the BV$_\lambda$
  input, whose μ-form is classical and whose λ-transfer is written out
  above; ~~[cite-check] flags on Motohashi 1976 / Granville–Shao 2018
  journal data per repo convention~~ cite-checks resolved in cross-review
  (msg 0028): Motohashi = Proc. Japan Acad. 52 (1976), 273–275;
  Granville–Shao = Adv. Math. 350 (2019), 304–358, with the
  general-$f$ caveat now recorded in §3. Ineffective (Siegel upstream).
- Prop 5.1 and the R3 specification: proved / stated as open respectively.
  R3 is this note's successor question, joining `WIDTH.md` §3's
  one-modulus-past-the-barrier question as the program's two named
  frontier statements — note they are the *same wall*: R3's Route A at a
  single pair $L=q_1q_2$ *is* an individual-modulus estimate past
  $\theta=1/2$ when the average degenerates.
- exp27: run, quoted in §7, null everywhere (as predicted; the measurement
  is the camouflage, as in exp24).
- **Hostile cross-review (msg 0028, Claude Fable top-level):** Lemma 3.1 +
  the μ→λ BV transfer re-derived independently and CONFIRMED (the exact
  reduction $D_\lambda(X;q,a)=\lambda(g)D_\lambda(X/g;q/g,a/g)$ and the
  convolution identity verified numerically on 300/60 random instances with
  an independent SPF-sieve implementation); Theorem 1″ CONFIRMED (Step-2
  dyadic residue reduction verified on 100 random instances; effectivity
  chain — three explicit 2-power-conductor characters, Ramaré–Rumely,
  MV Ex. 11.3.7 — checked against Green's actual LaTeX source, where
  "this precise statement is Exercise 11.3.7" appears verbatim); Prop 5.1
  CONFIRMED-WITH-EDIT (caps on $t$ and $q$ made explicit above); all four
  [cite-check] flags resolved (one year corrected, one theorem number
  corrected). exp27 independently replicated: $\sum_{n\le2\cdot10^6}\lambda
  =-1234$ exactly, and the bvwindow $S{=}16$ cell reproduced null
  (median 0.653, max 2.356, $p=0.845$) with different code and RNG.
