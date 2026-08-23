# LENS_REGULARITY: cut-norm RH and the block decomposition as an *exact* arithmetic regularity lemma

Executes blind spot 1 of `notes/BLINDSPOTS.md` (the additive-combinatorics
axis). Companion to `ADELIC.md` §3 and `BLOCKS.md` (which construct and
measure the decomposition) and `REPORT.md` §4 (Theorem C, whose machinery
drives the proofs). Code: `code/exp36_cutnorm.py` (small numerical check,
output quoted in §7). Author: fleet-graphon.

Contents: §1 a progression-sum lemma for the structured part (the exact
local model — used everywhere below); §2 **Theorem 1**, the one-page
theorem: interval cut norm of the flat pair array ⟺ RH, with the exponent
identity (cut-norm exponent $=2\Theta$); §3 **Lemma 2**, the degeneration of
the measurable cut norm (arithmetic pseudorandomness is *not* graphon
quasirandomness verbatim, and provably cannot be); §4 **Proposition 3**,
Bohr cuts ⟺ GRH — the test-family ↔ L-function dictionary; §5 **Theorem 2**,
the exact regularity theorem, with the honest fixed-$Q$ spectral-gap
propositions; §6 the counting lemma and the sharpest honest statement of
where regularity language *relocates* (not solves) the binary-Goldbach wall
(Propositions 7–8); §7 numerics; §8 references.

## 0. Setup and normalizations

Throughout $Q\ge1$ is fixed, $c_q(n)=\sum_{(a,q)=1}e(an/q)$ is Ramanujan's
sum, and (as in `ADELIC.md` §3, `BLOCKS.md`)
$$\Lambda^\sharp_Q(n)=\sum_{q\le Q}\frac{\mu(q)}{\varphi(q)}c_q(n),
\qquad \Lambda^\flat_Q=\Lambda-\Lambda^\sharp_Q .$$
For $Q=1$: $\Lambda^\sharp_1\equiv1$, $\Lambda^\flat_1=\Lambda-1$. Write
$$\psi^\flat_Q(y)=\sum_{n\le y}\Lambda^\flat_Q(n),\qquad
\psi^\flat_Q(I)=\sum_{n\in I}\Lambda^\flat_Q(n)\ \ (I\subseteq(0,X]\ \text{an interval}).$$

**The pseudorandom pair array.** On $(0,X]^2$ set
$$W_X(m,n)\;=\;\Lambda^\flat_Q(m)\,\Lambda^\flat_Q(n),$$
the flat$\times$flat block of the pair field $\Lambda\otimes\Lambda$
(`BLOCKS.md`: the $[\flat\flat]$ block). $W_X$ is rank one.

**Cut norms.** For a family $\mathcal S$ of subsets of $(0,X]$,
$$\|W_X\|_{\mathcal S}\;=\;\sup_{S,T\in\mathcal S}\Big|\sum_{m\in S}\sum_{n\in T}W_X(m,n)\Big| .$$
Three families: $\mathcal M$ = all subsets ("measurable cuts" — the
Frieze–Kannan/graphon cut norm [FK99, LS07] after rescaling $(0,X]\to[0,1]$,
which divides by $X^2$); $\mathcal I$ = intervals; $\mathcal B_q$ = level-$q$
Bohr cuts $\{n\in I:\ n\equiv a\ (\mathrm{mod}\ q)\}$ ($I$ an interval, $a$
arbitrary) — the intersections of an archimedean interval with a profinite
cylinder, i.e. the basic Bohr sets of $\mathbb Z$ with one rational
frequency, exactly the structured sets of Green's arithmetic regularity
[Gr05]. Note $\mathcal I=\mathcal B_1\subset\mathcal B_q\subset\mathcal M$.
Define the **interval discrepancy**
$$D_Q(X)\;=\;\sup_{I\subseteq(0,X]}\big|\psi^\flat_Q(I)\big|
\;=\;\max_{y\le X}\psi^\flat_Q(y)-\min_{y\le X}\psi^\flat_Q(y)\ \ (\text{oscillation of the partial-sum path}).$$

**Rank-one factorization (used constantly).** For any family $\mathcal S$
and any real $f$, the array $f\otimes f$ satisfies
$\sup_{S,T\in\mathcal S}|\sum_Sf\cdot\sum_Tf|
=\big(\sup_{S\in\mathcal S}|\sum_Sf|\big)^2$. In particular
$$\boxed{\ \|W_X\|_{\mathcal I}\;=\;D_Q(X)^2\ }$$
(Remark, standard: in the Aldous–Hoover representation of exchangeable
arrays [Ald81, Hoo79], rank-one product kernels are the extreme/dissociated
case — the pair field is the extreme point, the probabilistic clothing of
genericity Prop 1.1 of `REPORT.md`.)

## 1. Lemma 1.1: the structured part is the exact local model at every level $\le Q$

**Lemma 1.1.** Let $1\le q\le Q$ and $a\in\mathbb Z$. Then, uniformly in
$x\ge1$ and $a$,
$$\sum_{\substack{n\le x\\ n\equiv a\ (q)}}\Lambda^\sharp_Q(n)
\;=\;\frac{\mathbf 1_{(a,q)=1}}{\varphi(q)}\,x\;+\;O(C_Q),
\qquad C_Q:=\sum_{r\le Q}\frac{\sigma(r)}{\varphi(r)}\ \ (\le Q^3;\ \ll Q(\log\log Q)^2).$$

*Proof.* Fix $r\le Q$ squarefree (non-squarefree $r$ have $\mu(r)=0$).
Expand $c_r(n)=\sum_{d\mid r}d\,\mu(r/d)\mathbf 1_{d\mid n}$. The
simultaneous conditions $n\equiv a\ (q)$, $d\mid n$ are solvable iff
$(d,q)\mid a$, in which case they define one class modulo
$\mathrm{lcm}(d,q)=dq/(d,q)$; hence
$\#\{n\le x:\ n\equiv a\,(q),\ d\mid n\}=x\,(d,q)\mathbf 1_{(d,q)\mid a}/(dq)+\theta$,
$|\theta|\le1$. Therefore
$$\sum_{\substack{n\le x\\ n\equiv a(q)}}c_r(n)
=\frac{x}{q}\,f(r)+O(\sigma(r)),\qquad
f(r):=\sum_{d\mid r}\mu(r/d)\,g(d),\quad g(d):=(d,q)\mathbf 1_{(d,q)\mid a}.$$
$g$ is multiplicative (check prime-by-prime: for coprime $d_1,d_2$,
$(d_1d_2,q)=(d_1,q)(d_2,q)$ and the divisibility condition splits), so
$f=\mu*g$ is multiplicative with, for prime $p$,
$$f(p)=g(p)-g(1)=(p,q)\mathbf 1_{(p,q)\mid a}-1
=\begin{cases}0,&p\nmid q,\\ p\,\mathbf 1_{p\mid a}-1,&p\mid q.\end{cases}$$
So $f$ is supported on squarefree $r\mid\mathrm{rad}(q)$; all such $r$
satisfy $r\le q\le Q$, hence all contribute to the sum defining
$\Lambda^\sharp_Q$, and no $r\nmid\mathrm{rad}(q)$ contributes a main term.
Summing with the coefficients $\mu(r)/\varphi(r)$:
$$\sum_{r\le Q}\frac{\mu(r)}{\varphi(r)}f(r)
=\prod_{p\mid q}\Big(1-\frac{f(p)}{p-1}\Big)
=\prod_{p\mid q}\frac{p\,(1-\mathbf 1_{p\mid a})}{p-1}
=\mathbf 1_{(a,q)=1}\,\frac{q}{\varphi(q)} .$$
The main term is $\frac xq\cdot\mathbf 1_{(a,q)=1}\frac{q}{\varphi(q)}
=\mathbf 1_{(a,q)=1}x/\varphi(q)$; the error is
$\le\sum_{r\le Q}\sigma(r)/\varphi(r)=C_Q$, independent of $x,a,q$. $\square$

**Corollary 1.2.** ($q=1$.) $\ \sum_{n\le x}\Lambda^\sharp_Q(n)=x+O(C_Q)$,
hence
$$\psi^\flat_Q(x)\;=\;\psi(x)-x\;+\;O(C_Q+1)\qquad\text{uniformly in }x .$$
In particular $D_Q(X)=D_1(X)+O_Q(1)$: all fixed levels $Q$ have the same
interval discrepancy up to a constant (measured: exp36, §7, differences
$\le5.4$ at $X=10^7$).

Lemma 1.1 is the precise sense in which $\Lambda^\sharp_Q$ is an *exact*
local (Siegel–Walfisz) model: it reproduces the main term
$\mathbf 1_{(a,q)=1}x/\varphi(q)$ of $\psi(x;q,a)$ for **every** modulus
$q\le Q$ and **every** residue $a$ (including the density-0 non-coprime
classes), with error $O_Q(1)$ — not $o(x)$, but bounded.

*(Cross-review, msg 0029: independently re-derived line by line — the CRT
count, multiplicativity of $g(d)=(d,q)\mathbf 1_{(d,q)\mid a}$, the support
$r\mid\mathrm{rad}(q)$, and the Euler product collapse to
$\mathbf 1_{(a,q)=1}q/\varphi(q)$ all check, non-coprime residues included —
and numerically verified at $X=10^6$, $Q=30$: all 62 progressions $(q,a)$
for $q\in\{2,3,4,6,7,12,30\}$, non-squarefree moduli and non-coprime
residues included, have $\max_{x\le X}|\sum-\text{main}|\le10.4$, well
inside $C_{30}\approx99.8$.)*

## 2. Theorem 1 (the one-page theorem): interval cut norm ⟺ RH

Let $\Theta=\sup\{\operatorname{Re}\rho:\ \zeta(\rho)=0\}\in[1/2,1]$.

**Theorem 1.** Fix $Q\ge1$. For the flat pair array $W_X=\Lambda^\flat_Q\otimes\Lambda^\flat_Q$ on $(0,X]^2$:

1. (Rank-one identity) $\|W_X\|_{\mathcal I}=D_Q(X)^2$.
2. (Exponent identity) $\displaystyle\limsup_{X\to\infty}\frac{\log\|W_X\|_{\mathcal I}}{\log X}=2\Theta.$
3. (RH criterion) RH $\iff$ $\|W_X\|_{\mathcal I}\ll_\varepsilon X^{1+\varepsilon}$ for every $\varepsilon>0$
   $\iff$ $D_Q(X)\ll_\varepsilon X^{1/2+\varepsilon}$ for every $\varepsilon>0$.
   Under RH, quantitatively, $D_Q(X)\ll_Q X^{1/2}\log^2X$, i.e.
   $\|W_X\|_{\mathcal I}\ll_Q X\log^4X$. In the graphon normalization
   ($(0,X]^2\to[0,1]^2$, divide by $X^2$): RH $\iff$ the normalized
   interval cut norm is $\ll X^{-1+\varepsilon}$.
4. (Unconditional) $D_Q(X)\ll_Q X\exp(-c\sqrt{\log X})$ from the classical
   (de la Vallée Poussin) zero-free region, and
   $D_Q(X)\ll_Q X\exp\big(-c\,(\log X)^{3/5}(\log\log X)^{-1/5}\big)$ from
   Vinogradov–Korobov [Wal63, For02]; square these for $\|W_X\|_{\mathcal I}$.

*Proof.* (1) is the rank-one factorization of §0.

(3, forward) Under RH, $\psi(x)=x+O(x^{1/2}\log^2x)$ (von Koch [vK01]). For
an interval $I=(a,b]\subseteq(0,X]$, interval differencing plus
Corollary 1.2 give
$$|\psi^\flat_Q(I)|=|\psi^\flat_Q(b)-\psi^\flat_Q(a)|
\le|\psi(b)-b|+|\psi(a)-a|+O_Q(1)\ll_Q X^{1/2}\log^2X .$$

(3, converse) The prefix intervals $(0,x]$ lie in $\mathcal I$, so
$D_Q(X)\ll X^{\theta}$ (all large $X$) forces
$\psi(x)-x\ll x^{\theta}+O_Q(1)$ by Corollary 1.2. Then for
$\operatorname{Re}s>1$,
$$-\frac{\zeta'}{\zeta}(s)=s\int_1^\infty\psi(x)\,x^{-s-1}dx
\quad\Longrightarrow\quad
-\frac{\zeta'}{\zeta}(s)-\frac{s}{s-1}=s\int_1^\infty\big(\psi(x)-x\big)x^{-s-1}dx,$$
and the right side converges absolutely, locally uniformly, hence is
holomorphic, in $\operatorname{Re}s>\theta$. A zero $\rho$ of $\zeta$ with
$\operatorname{Re}\rho>\theta$ would be a pole of $-\zeta'/\zeta$ there,
contradiction; so $\Theta\le\theta$. With $\theta=1/2+\varepsilon$ for every
$\varepsilon$: RH.

(2) "$\le$": the truncated explicit formula
$\psi(x)=x-\sum_{|\gamma|\le T}x^\rho/\rho+O(xT^{-1}\log^2(xT))$ with $T=x$
gives $|\psi(x)-x|\le x^{\Theta}\sum_{|\gamma|\le x}|\rho|^{-1}+O(\log^2x)
\ll x^\Theta\log^2x$, and by the forward argument
$D_Q(X)\ll_Q X^\Theta\log^2X$. "$\ge$": if
$\limsup\log D_Q/\log X=\theta'<\Theta$ then the converse argument gives
$\Theta\le\theta'+\varepsilon<\Theta$ for small $\varepsilon$,
contradiction. Squaring transfers both to $\|W_X\|_{\mathcal I}$.

(4) Insert $\psi(x)=x+O(x\exp(-c\sqrt{\log x}))$ (classical), resp. the
Vinogradov–Korobov form $\psi(x)=x+O(x\exp(-c(\log x)^{3/5}(\log\log x)^{-1/5}))$
[Wal63], into the forward argument. $\square$

Statement (3) is "RH as a graph-limit statement": *the pseudorandom part of
the prime pair field is quasirandom for interval cuts, with power-saving
$X^{-1+\varepsilon}$ in the normalized cut norm, if and only if RH*. By (2)
the interval cut norm is exactly a spectral ruler: its growth exponent reads
off $2\Theta$. Every ingredient is classical (von Koch, Mellin); the content
is the *identification* — the correct cut-norm formulation costs one page
from Theorem C's machinery, as predicted in `BLINDSPOTS.md`.

## 3. Lemma 2: measurable cuts degenerate — quasirandomness verbatim is impossible

**Lemma 2 (degeneration of the measurable cut norm).**
1. For any real $f$ on $(0,X]$,
   $\sup_{S\subseteq(0,X]}\big|\sum_{n\in S}f(n)\big|
   =\max\big(\sum_n f_+(n),\ \sum_n f_-(n)\big)\ \ge\ \tfrac12\|f\|_{\ell^1}$,
   attained at $S=\{f>0\}$ or $S=\{f<0\}$. Hence for the rank-one array,
   $$\|f\otimes f\|_{\mathcal M}=\max\Big(\sum f_+,\ \sum f_-\Big)^2\ \ge\ \tfrac14\|f\|_{\ell^1}^2 .$$
2. For $f=\Lambda^\flat_1=\Lambda-1$:
   $\sum f_+=\psi(X)-\Pi(X)+O(\log X)$ and $\sum f_-=X-\Pi(X)+O(\log X)$,
   where $\Pi(X)=\#\{\text{prime powers}\le X\}\sim X/\log X$. Hence
   $$\|W_X\|_{\mathcal M}=\Big(1-\tfrac{1+o(1)}{\log X}\Big)^2X^2=(1+o(1))\,X^2 .$$
   For general fixed $Q$: $(1-o_Q(1))X^2\le\|W_X\|_{\mathcal M}\ll_Q X^2$
   (using $\|\Lambda^\sharp_Q\|_\infty\le Q$, which follows from Hölder's
   identity $c_q(n)=\mu(q_n)\varphi(q)/\varphi(q_n)$, $q_n=q/(q,n)$, so each
   of the $\le Q$ summands of $\Lambda^\sharp_Q$ is $\le1$ in modulus).

*Proof.* (1) is immediate ($S$ may align with the sign of $f$). (2): on
non-prime-powers $\Lambda^\flat_1=-1$; the positive part is
$\sum_{\Lambda(n)>1}(\Lambda(n)-1)=\psi(X)-\Pi(X)+O(\log X)$ (the only
prime powers with $\Lambda\le1$ are powers of 2, total mass $O(\log X)$).
For general $Q$: $\sum(\Lambda^\flat_Q)_+\ge\sum_{p^k\le X}(\Lambda-\Lambda^\sharp_Q)
\ge\psi(X)-Q\,\Pi(X)=(1-o_Q(1))X$, and on non-prime-powers
$(\Lambda^\flat_Q)_-=(\Lambda^\sharp_Q)_+\ge\Lambda^\sharp_Q$ there, whose sum is
$X-O_Q(X/\log X)$ by Corollary 1.2 minus the prime-power contribution
$O(Q\Pi(X))$; upper bounds are trivial. $\square$

**Discussion (this degeneration is itself the lemma).** The array $W_X$ is
at *essentially maximal* distance from $0$ in the measurable cut metric —
normalized cut norm $\to1$, no decay whatsoever (measured: $0.93$ at
$X=10^7$ vs. the predicted $1-1/\log X=0.938$; §7) — while its interval cut
norm is $X^{-1+\varepsilon}$-small under RH. Two structural readings:

- **Not an artifact of $\Lambda$'s unboundedness alone.** By Lemma 2(1) any
  rank-one signed array $f\otimes f$ has measurable cut norm
  $\ge\|f\|_{\ell^1}^2/4$: *no* mean-zero $\pm$-signed arithmetic weight
  with non-vanishing $L^1$ mass per unit density can be graphon-quasirandom
  verbatim. The bounded Liouville array $\lambda(m)\lambda(n)$ has
  $\|\cdot\|_{\mathcal M}\asymp X^2$ (take $S=\{\lambda=1\}$) even though
  Chowla predicts it is maximally pseudorandom arithmetically. Graphon
  quasirandomness [CGW89, LS07] is a theory of *bounded kernels tested
  against arbitrary measurable sets*, and its natural objects
  (edge-indicator deviations) are not rank-one; for rank-one signed
  arrays the measurable family solves the *recognition problem* — the
  maximizing cut $S^*=\{$prime powers$\}$ simply reads off the support —
  so the family must be restricted before "pseudorandom" means anything.
- **The correct restriction is complexity, and it is Green's.** Arithmetic
  regularity [Gr05, GT10] measures uniformity not against all sets but
  against *bounded-complexity structured sets* — Bohr sets in the abelian
  setting [Gr05], nilsequences in general [GT10] — equivalently through
  Fourier/Gowers norms. Lemma 2 is the rank-one instance of why: allowing
  arbitrary tests lets the test *memorize* the function. The interval and
  Bohr families of §0 are precisely the complexity-1 tests of the integers'
  two-ended (archimedean $\times$ profinite) structure; §2 and §4 show each
  such family measures exactly one L-function's RH. This is also the bridge
  to blind spot 2 (`BLINDSPOTS.md`): restricted test families = restricted
  circuit classes; the recognition move $S^*=\{$primes$\}$ is exactly what
  bounded-depth tests cannot do.

## 4. Proposition 3: Bohr cuts ⟺ GRH (the test-family ↔ L-function dictionary)

**Proposition 3.** Fix $q\ge1$ and take any $Q\ge q$. The following are
equivalent:
1. Every Dirichlet L-function of modulus $q$ satisfies RH (all zeros in the
   critical strip on $\operatorname{Re}s=1/2$).
2. $\displaystyle\|W_X\|_{\mathcal B_q}\ll_\varepsilon X^{1+\varepsilon}$
   for every $\varepsilon>0$; equivalently
   $\sup_{a}\sup_{I\subseteq(0,X]}\Big|\sum_{n\in I,\ n\equiv a(q)}\Lambda^\flat_Q(n)\Big|\ll_\varepsilon X^{1/2+\varepsilon}.$

*Proof.* By Lemma 1.1,
$$\sum_{\substack{n\le x\\ n\equiv a(q)}}\Lambda^\flat_Q(n)
=\psi(x;q,a)-\mathbf 1_{(a,q)=1}\frac{x}{\varphi(q)}+O_Q(1).$$
($\Rightarrow$) Under GRH mod $q$, $\psi(x;q,a)=x/\varphi(q)+O_q(x^{1/2}\log^2x)$
for $(a,q)=1$ (explicit formula for $\psi(x,\chi)$, [Dav, §§19–20]); for
$(a,q)>1$, $\psi(x;q,a)$ counts only powers of primes dividing $q$, hence is
$O(\omega(q)\log^2x)$. Interval differencing as in Theorem 1 gives (2).
($\Leftarrow$) Prefix intervals give, for each $a$,
$\psi(x;q,a)=\mathbf 1_{(a,q)=1}x/\varphi(q)+O(x^{1/2+\varepsilon})$. For
$\chi\neq\chi_0$ mod $q$,
$\psi(x,\chi)=\sum_{a\ (q)}\chi(a)\psi(x;q,a)
=\frac{x}{\varphi(q)}\sum_{(a,q)=1}\chi(a)+O(x^{1/2+\varepsilon})
=O(x^{1/2+\varepsilon})$, and the Mellin argument of Theorem 1 applied to
$-L'/L(s,\chi)=s\int_1^\infty\psi(x,\chi)x^{-s-1}dx$ shows $L(s,\chi)$ has
no zero with $\operatorname{Re}s>1/2$. Summing the $(a,q)=1$ bounds instead
gives $\psi(x)=x+O_q(x^{1/2+\varepsilon})$, i.e. RH for $\zeta$, which
covers $\chi_0$ (its L-function is $\zeta$ times finite Euler factors,
zero-free in $\operatorname{Re}s>0$ apart from $\zeta$'s zeros). $\square$

**The dictionary.** With Theorem 1 and Lemma 2 this closes a three-row
table, which we regard as the precise content of "Bohr/interval cuts are the
right test family for arithmetic":

| test family for $W_X$ | cut-norm decay $\ll X^{1+\varepsilon}$ is equivalent to | comment |
|---|---|---|
| intervals $\mathcal I$ | RH for $\zeta$ | Theorem 1 (archimedean frequency only) |
| level-$q$ Bohr cuts $\mathcal B_q$ ($q\le Q$) | GRH for modulus $q$ | Proposition 3 (one rational + one archimedean frequency) |
| all measurable cuts $\mathcal M$ | nothing — norm $\asymp X^2$ always | Lemma 2: degenerate, tests can memorize |

Uniformity over $q$ growing with $X$ (all $q\le X^{1/2}$) leaves the
fixed-$Q$ setting entirely — that is the terrain of `WIDTH.md` §3
(individual moduli $q\sim X^{1/2+\varepsilon}$: Siegel-hard) and of §5's
Propositions 4–5.

## 5. Theorem 2: the exact arithmetic regularity theorem

**Theorem 2.** For every fixed $Q\ge1$ the identity
$$\Lambda\;=\;\Lambda^\sharp_Q\;+\;\Lambda^\flat_Q$$
is an arithmetic regularity decomposition ~~in the sense of [Gr05, GT10]~~
*patterned on* [Gr05, GT10] — structured + uniform, with uniformity
certified against the matched interval/Bohr families of §0 rather than
their Fourier/Gowers norms (Propositions 4–5 below: Fourier-uniformity
*fails* at fixed $Q$), and for the unbounded $\Lambda$ rather than their
bounded $f$ *(scope phrase corrected in cross-review, msg 0029)* — with:

1. **Structured part, explicitly described.** $\Lambda^\sharp_Q$ is
   periodic of period $L_Q=\mathrm{lcm}(1,\dots,Q)$ — i.e. constant on the
   atoms of the level-$Q$ profinite partition, the basic level-$Q$ Bohr
   pieces — with closed form
   $\Lambda^\sharp_Q(n)=\sum_{q\le Q}\mu(q)\mu(q_n)/\varphi(q_n)$
   ($q_n=q/(q,n)$, Hölder), Fourier support exactly the Farey fractions
   $\{a/q:\ q\le Q,\ (a,q)=1\}$ with coefficient $\mu(q)/\varphi(q)$ at
   every primitive $a/q$ (a "major-arc polynomial"),
   $\|\Lambda^\sharp_Q\|_\infty\le Q$, and *exact* local averages: Lemma 1.1
   gives the Siegel–Walfisz main term $\mathbf 1_{(a,q)=1}x/\varphi(q)$ on
   every progression of modulus $q\le Q$ with error $O_Q(1)$. It is
   canonical: the Besicovitch-orthogonal projection of $\Lambda$ onto
   $\mathrm{span}\{c_q:q\le Q\}$, with coefficients
   $\langle\Lambda,c_q\rangle/\langle c_q,c_q\rangle=\mu(q)/\varphi(q)$
   computed in closed form (Hardy's Ramanujan–Fourier coefficients [Har21];
   in mean form equivalent to Siegel–Walfisz; `ADELIC.md` §3) — no
   energy-increment iteration.
2. **Uniform part, quantified.** $D_Q(X)=\sup_{I}|\psi^\flat_Q(I)|$
   satisfies, by Theorem 1:
   unconditionally $\ll_Q X\exp(-c(\log X)^{3/5}(\log\log X)^{-1/5})$
   (Vinogradov–Korobov; classical region gives $X\exp(-c\sqrt{\log X})$);
   under RH $\ll_Q X^{1/2}\log^2X$; and under GRH the same for every Bohr
   family $\mathcal B_q$, $q\le Q$ (Proposition 3).
3. **Exactness.** There is no third term: the decomposition is a two-term
   identity, $f_{\mathrm{sml}}\equiv0$.

**Contrast with the soft decomposition.** Green's arithmetic regularity
lemma [Gr05], and the Green–Tao arithmetic regularity lemma [GT10], write a
*bounded* $f:[N]\to\mathbb C$ as
$f=f_{\mathrm{str}}+f_{\mathrm{sml}}+f_{\mathrm{unf}}$ with
$f_{\mathrm{str}}$ of bounded complexity (Bohr-set/nilsequence structured),
$\|f_{\mathrm{sml}}\|_{L^2}\le\varepsilon$, and $f_{\mathrm{unf}}$ tiny in a
Gowers norm. *(Attribution sharpened in cross-review, msg 0029: the
displayed three-term functional form is [GT10]'s — its abstract decomposes
bounded $f$ into a nilsequence, an $L^2$-small error, and a
$U^{s+1}$-miniscule error; [Gr05] is the partition-form antecedent, "an
analogue of Szemerédi's regularity lemma in the context of abelian groups"
per its abstract. Both re-checked against the arXiv records.)* There the
small-$L^2$ term is unavoidable: $f$ is arbitrary,
the structured projection is found by pigeonhole/energy increment, and the
bounds are of tower type (tower-type losses are provably necessary in the
graph-regularity setting [Gow97]; the arithmetic versions inherit comparable
inefficiency). For $\Lambda$ the three reasons exactness is possible:

- the structured projection is *known in closed form* (the
  $\mu(q)/\varphi(q)$ Ramanujan–Fourier coefficients) — nothing is searched
  for, so nothing is lost;
- the explicit formula supplies a *complete spectral inventory* of the
  complement: the "frequencies" of $\Lambda^\flat_Q$ are the zeta zeros
  (archimedean) together with the discarded rationals $q>Q$; the uniform
  part is not merely small-in-a-norm, its structure is *identified* —
  `BLOCKS.md` measures the three blocks of the pair field on disjoint
  spectral supports (single-zero band vs. pair band at $34\times$/$360\times$
  contrast);
- smallness therefore comes from zero-free regions (quantitative,
  power-saving under RH) rather than from pigeonhole (qualitative
  $\varepsilon$'s).

In one line: *soft regularity trades exactness for generality; the explicit
formula makes the trade unnecessary for $\Lambda$.*

**Honesty: what the fixed-$Q$ flat part is *not*.** Exactness is relative to
a matched test family. Against linear phases the fixed-$Q$ flat part is
**not** uniform:

**Proposition 4 (fixed-$Q$ Fourier obstruction).** Let $q_0>Q$ be squarefree
and $(a,q_0)=1$. Then
$$\sum_{n\le X}\Lambda^\flat_Q(n)\,e(na/q_0)
=\mu(q_0)\frac{X}{\varphi(q_0)}+O_A\!\big(X(\log X)^{-A}\big)+O(Q^2q_0).$$
*Proof.* Siegel–Walfisz in the form
$\sum_{n\le X}\Lambda(n)e(na/q_0)=\mu(q_0)X/\varphi(q_0)+O_A(X(\log X)^{-A})$
[Dav, §26]; and for $r\le Q$,
$c_r(n)e(na/q_0)=\sum^*_{b\ (r)}e\big(n(b/r+a/q_0)\big)$ with every
frequency $b/r+a/q_0\notin\mathbb Z$ (else $q_0\mid r$), each geometric sum
$\le\tfrac12\|b/r+a/q_0\|^{-1}\le rq_0$, so the structured part contributes
$O(Q^2q_0)$. $\square$

So $\sup_\alpha|\sum_n\Lambda^\flat_Q(n)e(n\alpha)|\asymp_Q X$: the flat
part at fixed $Q$ retains the rational frequencies beyond $Q$ at full
strength, and no fixed-$Q$ exact decomposition is "$U^2$-regular". Full
phase-uniformity requires the level to grow:

**Proposition 5 (growing $Q$ = the circle method; classical).** For every
$A$ there is $B=B(A)$ such that with $Q(X)=(\log X)^B$,
$$\sup_{\alpha\in\mathbb R}\Big|\sum_{n\le X}\Lambda^\flat_{Q(X)}(n)\,e(n\alpha)\Big|
\ \ll_A\ X(\log X)^{-A}.$$
*Proof sketch (this is Vinogradov's major/minor-arc analysis restated).* On
a major arc $|\alpha-a/q|\le(\log X)^B/X$, $q\le(\log X)^B$: Siegel–Walfisz
plus partial summation show both $\sum\Lambda(n)e(n\alpha)$ and
$\sum\Lambda^\sharp_{Q(X)}(n)e(n\alpha)$ equal
$\frac{\mu(q)}{\varphi(q)}\sum_{n\le X}e(n(\alpha-a/q))+O_A(X(\log X)^{-A-1})$,
so the difference is small. On minor arcs, Vinogradov–Vaughan
[Dav, §§25–26; Vau97] give $\sum\Lambda(n)e(n\alpha)\ll X(\log X)^{4-B/2}$;
for the structured part, the frequencies $b/r$ ($r\le Q(X)$) are
$1/Q(X)^2$-separated (Farey), each at distance $\ge(\log X)^B/X$ from a
minor $\alpha$, so summing $\min(X,\|\alpha-b/r\|^{-1})$ over the nearest
fraction and dyadic shells gives
$\ll X(\log X)^{-B}+Q(X)^2\log X$. Choose $B\ge2A+10$. $\square$

The pair (Propositions 4, 5) is the sharp form of the trade-off: *exactness
at every fixed profinite level, with power-saving archimedean uniformity
(RH) against the matched interval/Bohr families — versus phase-uniformity
against all of $\mathbb T$, which forces $Q\to\infty$ and is precisely the
classical circle method.* Green's third term is the price of demanding, for
arbitrary bounded $f$, both bounded structured complexity and uniformity
against every phase; $\Lambda$'s special structure lets one refuse the
trade at fixed level and pay $Q\to\infty$ only when a configuration demands
it (§6).

## 6. The counting lemma, and where the wall relocates

**Proposition 6 (exact counting lemma for the once-smoothed binary count).**
Let $G_1(X)=\sum_{m,n}\Lambda(m)\Lambda(n)(X-m-n)_+$ and split
$G_1=[\sharp\sharp]+2[\sharp\flat]+[\flat\flat]$ by bilinearity
(`BLOCKS.md`; exact by construction). Then, with
$\Psi_1^\flat(y)=\int_0^y\psi^\flat_Q(u)\,du$:
$$[\flat\flat]=\int_0^X\psi^\flat_Q(v)\,\psi^\flat_Q(X-v)\,dv,\qquad
[\sharp\flat]=\sum_m\Lambda^\sharp_Q(m)\,\Psi_1^\flat(X-m),$$
$$\big|G_1(X)-[\sharp\sharp]_Q(X)\big|
\;\le\;2Q\,X^2\,D_Q(X)\;+\;X\,D_Q(X)^2 ,$$
where $[\sharp\sharp]_Q$ is the level-$Q$ singular-series count, exactly
computable from the $c_q$ calculus (`BLOCKS.md` verified
$[\sharp\sharp]=\sum_{n\le X}(X-n)\,n\,\mathfrak S_Q(n)$ to $3\times10^{-5}$).
Under RH the error is $\ll_Q X^{5/2}\log^2X$ — and this is sharp up to
logarithms, since the single-zero layer of $G_1$ is genuinely of size
$X^{5/2}$ (`BLOCKS.md` Lemma: $2[\sharp\flat]$ carries it with coefficient
exactly 2).

*Proof.* $(X-m-n)_+=\int_0^X\mathbf 1[m+n\le s]\,ds$ and
$\sum_n\Lambda^\flat(n)(y-n)_+=\int_0^y\psi^\flat(u)du$ (Fubini). For
$[\flat\flat]$: $[\flat\flat]=\sum_m\Lambda^\flat(m)H(m)$ with
$H(v)=\int_0^{(X-v)_+}\psi^\flat(u)du$; $H$ is Lipschitz with
$H'(v)=-\psi^\flat(X-v)$ a.e., $H(X)=0$, $\psi^\flat(0)=0$, so
Riemann–Stieltjes integration by parts gives
$\sum_m\Lambda^\flat(m)H(m)=\int_0^XH\,d\psi^\flat
=\int_0^X\psi^\flat(v)\psi^\flat(X-v)\,dv$. Bounds:
$|\Psi_1^\flat(y)|\le X D_Q(X)$ and $\|\Lambda^\sharp_Q\|_\infty\le Q$ give
$|2[\sharp\flat]|\le2QX^2D_Q$; $|[\flat\flat]|\le XD_Q^2$. $\square$

This is Theorem C (`REPORT.md` §4) in regularity clothing: *one archimedean
average per flat factor converts interval-cut data into a full asymptotic*
— which is exactly why "average Goldbach ⟺ RH" is cheap. The general
principle, with the dictionary of §4:

| configuration | free averaging | controlling family / norm | status |
|---|---|---|---|
| $\psi(x)$ | one archimedean interval | $\mathcal I$ | ⟺ RH (Thm 1) |
| $\psi(x;q,a)$ | interval $\times$ level-$q$ Bohr | $\mathcal B_q$ | ⟺ GRH mod $q$ (Prop 3) |
| smoothed/averaged binary $G_1$ | one archimedean average over $N$ | $\mathcal I$, squared (Prop 6) | ⟺ RH (Thm C) |
| ternary Goldbach, fixed $N$ | two internal variables | growing-$Q$ phase uniformity (Prop 5) + one $L^2$ (Parseval) factor | theorem (Vinogradov); *not* reachable at fixed $Q$ (Prop 4, and the $q>Q$ tail of $\mathfrak S$ is a genuine secondary main term) |
| binary Goldbach, fixed $N$ | none | **no norm in this note controls it** (Props 7–8) | open — the wall, relocated |

**The relocation, stated sharply.** The flat block of the binary count at a
single even $N$ is the *anti-diagonal slice*
$$B^\flat(N)=\sum_{m}\Lambda^\flat(m)\Lambda^\flat(N-m)
=\int_0^1S^\flat(\alpha)^2e(-N\alpha)\,d\alpha,
\qquad S^\flat(\alpha)=\sum_{n\le N}\Lambda^\flat_Q(n)e(n\alpha).$$
A cut norm — over *any* test family of product sets — controls integrals of
$W$ over boxes $S\times T$; the slice $\{m+n=N\}$ has measure zero in every
box scaling, and averaging over $N$ (which restores box structure:
$\sum_Nw(N)B^\flat(N)=\int|S^\flat|^2\hat w$-type integrals) is exactly what
Proposition 6 exploits and what fixing $N$ forfeits. This is not a defect of
our particular norms but of *all* of them, in two provable senses:

**Proposition 7 (no Gowers norm controls the slice, even for bounded
functions).** For every $k$ there exist 1-bounded $f_N:[N]\to\mathbb C$ with
$\|f_N\|_{U^k[N]}\to0$ as $N\to\infty$, while
$\sum_{m=1}^{N-1}f_N(m)f_N(N-m)=N-1$ exactly.
*Proof.* Take $j\ge k$ odd, $\alpha$ irrational (say $\sqrt2$), and
$f_N(m)=e\big(\alpha(m-N/2)^j\big)$. Since $j$ is odd,
$(m-N/2)^j+((N-m)-N/2)^j=0$, so $f_N(m)f_N(N-m)=1$ for every $m$. And a
polynomial phase of degree $j$ with irrational leading coefficient has
$\|\cdot\|_{U^k}=o(1)$ for every $k\le j$, by Weyl differencing: the Gowers
expression averages $e(\alpha\,\Delta_{h_1}\!\cdots\Delta_{h_k}(m-N/2)^j)$;
for $k<j$ the $k$-fold additive derivative is, for almost every shift
tuple, a nonconstant polynomial in $m$ of degree $j-k$ with irrational
leading coefficient (Weyl in $m$); for $k=j$ it is the constant
$j!\,\alpha\,h_1\cdots h_j$, equidistributed in the $h$-average (Weyl in the
shifts). Only $U^{j+1}$ and above see the phase ($\|f_N\|_{U^{j+1}}=1$).
$\square$

So the fixed-$N$ binary pattern has *infinite true complexity* in the
Gowers–Wolf sense [GW10]: no $U^k$-uniformity assumption, however strong,
implies anything about $B^\flat(N)$ for a general bounded function — in
stark contrast to its $N$-averaged versions (complexity 1, i.e.
$U^2$-controlled; with smoothing, interval-cut-controlled by Prop 6).

**Proposition 8 (magnitude information cannot beat the Parseval floor).**
Fix $Q$, let $N$ be even. There is a continuous 1-periodic $F$ with
$|F(\alpha)|=|S^\flat(\alpha)|$ for all $\alpha$ and
$$\int_0^1F(\alpha)^2e(-N\alpha)\,d\alpha
=\int_0^1|S^\flat(\alpha)|^2d\alpha=\sum_{n\le N}\Lambda^\flat_Q(n)^2
=(1+o_Q(1))\,N\log N .$$
Consequently, any upper bound on
$|B^\flat(N)|=|\int_0^1S^\flat(\alpha)^2e(-N\alpha)d\alpha|$ that is valid
for every integrand with the same magnitude profile
$\alpha\mapsto|S^\flat(\alpha)|$ — i.e. any estimate assembled from
pointwise magnitude data, such as the chains
$\le\int|S^\flat|^2$, $\le\sup_\alpha|S^\flat|\cdot\|S^\flat\|_{L^1}$, or
any Hölder interpolation of $L^p$ norms of $S^\flat$ (note
$\|S^\flat\|_{L^4}^4$ is the $U^2$-count of $\Lambda^\flat$) — cannot be
smaller than $(1+o(1))N\log N$, which *exceeds the expected main term*
$\mathfrak S(N)N\asymp N$ by a factor $\log N$.
*Proof.* $F(\alpha)=|S^\flat(\alpha)|e(N\alpha/2)$ is continuous and
1-periodic ($N$ even) and $F^2e(-N\alpha)=|S^\flat|^2\ge0$. The $L^2$
identity is Parseval; $\sum\Lambda^{\flat2}=\sum\Lambda^2+O_Q(X)=
(1+o(1))X\log X$ by PNT partial summation and
$\|\Lambda^\sharp_Q\|_\infty\le Q$. A magnitude-only bound cannot
distinguish $S^\flat$ from $F$, and for $F$ the integral attains
$\int|S^\flat|^2$. $\square$

(The interval and Bohr discrepancies of §§2–4 are *not* magnitude-only
functionals of $S^\flat$ — they carry phase information; Proposition 8 does
not preclude their use. What it precludes is reaching the slice through the
magnitude bottleneck $|S^\flat|$, and §2 shows the interval family's phase
content is exactly RH-strength archimedean data, which controls averages
over $N$ (Prop 6), not single slices — that gap is Proposition 7.)

*(Scope remark, added in cross-review, msg 0029. "Magnitude-only" is
formalized as "valid for every integrand with the magnitude profile
$|S^\flat|$", and the listed chains ($L^2$, $\sup\cdot L^1$, Hölder of
$L^p$'s) are all of this kind, so the proposition is true as stated and
sharp: the extremal $F$ shows the best bound in this class is exactly
$\int|S^\flat|^2$. But the class is genuinely narrower than "phase-blind"
colloquially: $|S^\flat|^2$ determines the trigonometric polynomial
$S^\flat$ up to a unimodular constant and finitely many Fejér–Riesz
zero-flips $z\mapsto1/\bar z$, so a functional that additionally exploits
the side constraint "the integrand is the square of a degree-$N$
exponential sum" — e.g. the max of $|\widehat{G^2}(N)|$ over the finitely
many such $G$ with $|G|=|S^\flat|$ — is still computable from the magnitude
profile alone, yet lies outside Prop 8's class (the extremal $F$ is not an
exponential sum), and the Parseval floor does not apply to it. No such
bound is known to beat the floor; the point is only that Prop 8 does not
close that route.)*

Together: (7) closes every uniformity-norm route *even in the bounded
model*; (8) closes every phase-blind route (precisely: every bound in
Prop 8's magnitude-profile class — see the scope remark, msg 0029) and
quantifies the
unbounded-weight surcharge — the $\log N$ excess of the Parseval floor over
the main term is precisely the $L^2$ mass that Green–Tao-type pseudorandom
majorants [GT08, CFZ15] tame *on average over $N$* (transference gives
lower-bound counts and averaged asymptotics) but cannot cancel at a single
$N$. Regularity language therefore does not shrink the parity/Goldbach
wall; it *relocates* it to a single sharp sentence:

> Binary Goldbach at fixed $N$ asks for the value of a rank-one signed
> array on one anti-diagonal slice; every norm in the additive-combinatorics
> toolbox (cut, Bohr-cut, $L^p$, $U^k$) is a box- or magnitude-functional,
> and Propositions 7–8 show box- and magnitude-information is *consistent
> with failure* — the missing input is pointwise phase information about
> $S^\flat$, which is exactly the zero/parity data the corpus studies from
> the spectral side (`GAUGE.md`: the charged sector has no atoms in any
> block; `WIDTH.md`: the wall's exponent-scale width; `PARITY.md`).

What the lens *gains* is calibration and transfer: (i) the exactness
theorem is free, and explains structurally why every once-averaged Goldbach
statement is cheap (Prop 6/Theorem C) — the difficulty was never in the
decomposition, only in the slice; (ii) the family ↔ L-function dictionary
(§4) aligns the corpus's spectral results with the regularity/transference
literature so that progress in either vocabulary moves the other; (iii) it
names the exact two upgrades any proof must make — beyond-norm (phase/slice)
information about $\Lambda^\flat$, and majorant-free handling of unbounded
weights at a point.

## 7. Numerical check (exp36)

`code/exp36_cutnorm.py`, sieve to $10^7$, no zeros table (output abridged —
the $X=10^5$ rows are in the script's full output):

```
  Q          X         D(X)  D/sqrt(X)   D/(sqrt X log^2 X)  meas-cut/X   D_Q - D_1
  1      10000        94.83      0.948            0.01118       0.8737        0.00
  1    1000000       994.29      0.994            0.00521       0.9213        0.00
  1   10000000      3107.96      0.983            0.00378       0.9335        0.00
 30      10000        92.24      0.922            0.01087       0.6220       -2.59
 30    1000000       988.92      0.989            0.00518       0.8376       -5.37
 30   10000000      3105.43      0.982            0.00378       0.8952       -2.53
```

**[POINTER 2026-08-14 — `notes/INTERVAL_DISCREPANCY_MEAN_SQUARE.md`: the
paragraph below quotes a constant that does not exist.
$\limsup_X D_Q(X)X^{-1/2}=+\infty$ unconditionally (Thm A there), so "flat over
three decades" is the theorem's own prediction and not evidence; the exactly
derivable statistic is the logarithmic mean square, whose limit is
$\sum_\gamma m_\gamma^2/(\tfrac14+\gamma^2)$, equal to this corpus's own
$B=2+\gamma_E-\log4\pi=0.0461914\ldots$ iff the zeros are simple, and whose
boundedness is itself equivalent to RH (Thm D there). Nothing in §§0–6 is
affected.]**

Read: $D_Q(X)/\sqrt X\approx0.98$, flat over three decades — square-root
cancellation of the interval cut norm on the nose (Theorem 1(3), RH regime;
even the $\log^2$ allowance is invisible at these heights); the measurable
cut scale $\max(\sum f_+,\sum f_-)/X\to1$ (at $X=10^7$: measured $0.9335$
vs. Lemma 2's prediction $1-1/\log X=0.938$) — the degeneration is exact;
and $D_{30}-D_1=O(1)$ at all scales (Corollary 1.2).

*(Independent replication, cross-review msg 0029: different pipeline —
smallest-prime-factor sieve for $\Lambda$, Hölder-identity evaluation of
$c_q$, sympy arithmetic — reproduces the $X\le10^6$ rows exactly:
$D_1(10^6)=994.29$, meas-cut$/X=0.9213$; $D_{30}(10^6)=988.92$,
meas-cut$/X=0.8376$, $D_{30}-D_1=-5.37$. Moreover Lemma 2(2)'s exact form
predicts meas-cut$/X\approx1-\Pi(X)/X=0.92126$ at $X=10^6$
($\Pi(10^6)=78{,}738$ prime powers), matching the measured $0.9213$ to four
decimals — the $1-1/\log X$ figure quoted above is the cruder gloss.)*

## 8. References

- [Ald81] D. Aldous, *Representations for partially exchangeable arrays of
  random variables*, J. Multivariate Anal. 11 (1981) 581–598. (With
  [Hoo79] D. Hoover, preprint 1979.)
- [CFZ15] D. Conlon, J. Fox, Y. Zhao, *A relative Szemerédi theorem*,
  Geom. Funct. Anal. 25 (2015) 733–762.
- [CGW89] F. Chung, R. Graham, R. Wilson, *Quasi-random graphs*,
  Combinatorica 9 (1989) 345–362.
- [Dav] H. Davenport, *Multiplicative Number Theory*, 3rd ed., GTM 74,
  Springer 2000 (esp. §§19–20, 25–26).
- [FK99] A. Frieze, R. Kannan, *Quick approximation to matrices and
  applications*, Combinatorica 19 (1999) 175–220. (The cut norm.)
- [For02] K. Ford, *Vinogradov's integral and bounds for the Riemann zeta
  function*, Proc. London Math. Soc. 85 (2002) 565–633.
- [Gow97] W.T. Gowers, *Lower bounds of tower type for Szemerédi's
  uniformity lemma*, Geom. Funct. Anal. 7 (1997) 322–337.
- [Gr05] B. Green, *A Szemerédi-type regularity lemma in abelian groups,
  with applications*, Geom. Funct. Anal. 15 (2005) 340–376.
  (arXiv:math/0310476; title/authorship verified against the arXiv record.)
- [GT08] B. Green, T. Tao, *The primes contain arbitrarily long arithmetic
  progressions*, Ann. of Math. 167 (2008) 481–547.
- [GT10] B. Green, T. Tao, *An arithmetic regularity lemma, associated
  counting lemma, and applications*, in: An Irregular Mind (Szemerédi is
  70), Bolyai Soc. Math. Stud. 21 (2010). (arXiv:1002.2028; the
  $f_{\mathrm{str}}+f_{\mathrm{sml}}+f_{\mathrm{unf}}$ decomposition
  verified against the arXiv abstract.)
- [GT10b] B. Green, T. Tao, *Linear equations in primes*, Ann. of Math.
  171 (2010) 1753–1850. (Complexity taxonomy for linear systems.)
- [GW10] W.T. Gowers, J. Wolf, *The true complexity of a system of linear
  equations*, Proc. London Math. Soc. 100 (2010) 155–176.
- [Har21] G.H. Hardy, *Note on Ramanujan's trigonometrical function
  $c_q(n)$ and certain series of arithmetical functions*, Proc. Cambridge
  Philos. Soc. 20 (1921) 263–271.
- [LS07] L. Lovász, B. Szegedy, *Szemerédi's lemma for the analyst*,
  Geom. Funct. Anal. 17 (2007) 252–270.
- [Vau97] R.C. Vaughan, *The Hardy–Littlewood Method*, 2nd ed., CUP 1997.
- [vK01] H. von Koch, *Sur la distribution des nombres premiers*, Acta
  Math. 24 (1901) 159–182.
- [Wal63] A. Walfisz, *Weylsche Exponentialsummen in der neueren
  Zahlentheorie*, Berlin 1963. (Vinogradov–Korobov PNT error term.)
