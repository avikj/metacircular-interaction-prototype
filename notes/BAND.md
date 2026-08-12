# The band exchange rate: the whole remaining gap is one constant

Author: cf-vesper, 2026-08-12. **Derived here; hostile audit running.**

Three independent closures (`ATLAS.md` §1.1) left the frontier method
with exactly one open freedom: unconditional information about the pair
correlation past band 1, in the form of an *upper* bound. This note
prices that freedom. The price turns out to be a single monotone
function of a single crude constant, and it interpolates the entire
distance from the current record to 100%.

## 1. The formula

Certificate $s\ge(2-\|\tilde G\|_F^2/N)N$ with
$\|\tilde G\|_F^2/N=\int_0^\lambda F K$, $F$ Montgomery's form factor,
$K$ the compression's $\alpha$-profile — necessarily a nonnegative
autocorrelation by `LEVER3` O1 / `L3_SDP` L3.2. Flat window:
$K(\alpha)=\tfrac2\lambda(1-\tfrac\alpha\lambda)$ on $[0,\lambda]$,
$\int K=1$.

Montgomery gives, unconditionally on $[0,1]$,
$F(\alpha)=T^{-2\alpha}\log T+\alpha+o(1)$: the first term integrates to
$K(0)/2=1/\lambda$, the second to $\lambda/3$ when $\lambda\le1$ —
recovering $H(\lambda)=2-1/\lambda-\lambda/3$, $H(1)=2/3$.

Past the wall only the tail is unknown. With $\int_0^1\alpha K
=\tfrac1\lambda-\tfrac{2}{3\lambda^2}$ and
$\int_1^\lambda K=(1-\tfrac1\lambda)^2$:

> **Proposition (exchange rate).** If $F\le B$ unconditionally on
> $(1,\lambda]$, then the flat-window certificate is
> $$V(\lambda,B)=2-\frac2\lambda+\frac{2}{3\lambda^2}
> -B\Big(1-\frac1\lambda\Big)^{2}.$$
> Each unit of $B$ costs $(1-1/\lambda)^2$: quadratic in the band
> excess. $V(1,B)=\tfrac23$ for every $B$ — the $B$-dependence switches
> off exactly at the old wall, as it must.

## 2. The reduction

Optimizing the band against the bound collapses everything:

$$\boxed{\ \lambda^*(B)=\frac{B-\tfrac23}{B-1},\qquad
V^*(B)=\frac{2B-1}{3B-2},\qquad
B^*(\lambda)=\frac{2(2\lambda-1)}{3(\lambda-1)}\ }$$

($\lambda^*$ the optimal band at bound $B$; $V^*$ the certificate there;
$B^*$ the break-even bound at band $\lambda$.)

| $B$ | $\lambda^*$ | $V^*$ | |
|---|---|---|---|
| $1$ | $\infty$ | $1$ | conjectured truth ⇒ 100% |
| $4/3$ | $2$ | $5/6$ | |
| $3/2$ | $5/3$ | $4/5$ | |
| $2$ | $4/3$ | $3/4$ | |
| $3$ | $7/6$ | $5/7$ | |
| $4$ | $10/9$ | $7/10$ | |
| $\infty$ | $1$ | $2/3$ | **current state of knowledge** |

$V^*$ is monotone decreasing from $1$ to $2/3$. Read the last row and
the first together:

> **The entire unconditional gap between the current world record and
> the full result, inside this frame, is the single constant $B$ — and
> our present knowledge of $B$ is $\infty$.**

Two consequences worth stating separately.

**(a) The ask is far weaker than the framing.** $B^*(4/3)=10/3$: *any*
unconditional bound $F\le3.33$ on a band excess of length $1/3$ beats
$2/3$. Not an asymptotic, not a sharp constant, not the conjectured
value — a crude ceiling on a quantity whose true value is believed to be
$1$. The corpus (and the manuscript) have treated past-band information
as Hardy–Littlewood-hard because that is the cost of *evaluating* $F$
there. The certificate never evaluates. It only ever subtracts an upper
bound. This is the sharpest vindication of the sign correction both L3
landings made independently: upper bounds pay, lower bounds do not.

**(b) The wall was never a wall; it was an infinity.** $\lambda\le1$ is
not a structural boundary of the method — it is the statement $B=\infty$
substituted into a formula that is otherwise perfectly happy at any
$\lambda$. Every closure we proved this week (sign, integrality, degree)
is a genuine structural exhaustion. This one is a missing number.

## 3. Where $B$ could come from: the $q$-aspect

The single-$\zeta$ wall is Montgomery–Vaughan diagonal dominance: a
Dirichlet polynomial of length $X$ averaged over $t\in[T,2T]$ has
diagonal-dominated second moment iff $X\ll T$, and $X=(T/2\pi)^\lambda$.

In the family of primitive $\chi$ mod $q\le Q$, the hybrid large sieve
$$\sum_{q\le Q}\ \sideset{}{^*}\sum_{\chi\bmod q}\int_T^{2T}
\Big|\sum_{n\le X}a_n\chi(n)n^{-it}\Big|^2dt\ \ll\ (Q^2T+X)\sum|a_n|^2$$
replaces the budget $X\ll T$ by $X\ll Q^2T$. With analytic conductor
$\asymp QT$, $\ell=\log(QT)$, $X=(QT)^\lambda$, $Q=T^\theta$:
$$\lambda\le\frac{1+2\theta}{1+\theta}\qquad
(\to2 \text{ as }\theta\to\infty;\ =\tfrac32 \text{ at } \theta=1;
\ \to1 \text{ as }\theta\to0).$$

Correct degeneration at $\theta\to0$, and $\lambda=4/3$ — where a bound
as weak as $10/3$ already pays — needs only $\theta=1/2$, i.e.
$Q=\sqrt T$.

Why the family is the natural home rather than a coincidence: **the
large sieve is an inequality, not an asymptotic** — precisely the shape
§1 consumes; and extending the computable support of correlation
statistics by averaging over a family is the standard mechanism of the
low-lying-zeros literature. The family is where past-band information
has always been available. What was missing was a certificate that could
*spend* an upper bound. That certificate is two days old.

**Calibration.** The record for this family is $56\%$
(Conrey–Iwaniec–Soundararajan, [arXiv:1105.1177](https://arxiv.org/abs/1105.1177)),
improved to $61.07\%$ with a Feng mollifier
([arXiv:2105.07422](https://arxiv.org/abs/2105.07422)). Both use
Levinson's method. An inertia certificate at $\lambda=4/3$ needs only
$B<10/3$ to pass $2/3$, and $B=1$ would give $5/6$ at $\lambda=2$.

## 4. Status, and what kills it

**Established here:** the Proposition, the three closed forms, the
degeneration $V(1,B)=2/3$ and $V^*(\infty)=2/3$, the break-even values,
and the $\lambda\le(1+2\theta)/(1+\theta)$ exponent. All verified
symbolically.

**Not established — any one is fatal to the family route (not to §1–2):**
1. $\operatorname{tr}\tilde G$ may need an *asymptotic* past the band,
   which an inequality cannot supply;
2. the signature-$(1,1)$ block structure for complex $\chi$, whose zeros
   pair with those of $L(s,\bar\chi)$ — possibly forcing a frame over
   pairs $\{\chi,\bar\chi\}$;
3. critical-density / no-aliasing for a two-index frame;
4. the translation of the large sieve's $\ell^2$ inequality into a
   pointwise $F_{\rm fam}\le B$ on a band excess of positive length —
   this is the real work, and it is not assumed anywhere in §1–2;
5. prior art: $q$-aspect pair correlation past band 1 may exist in the
   literature.

**Note the asymmetry.** §1–2 are frame-internal and survive regardless:
they price *any* future source of $B$, including a single-$\zeta$ one.
Only §3's route depends on the five.

## 5. Yield

The one remaining door now has a number on it. The program's task in
this direction is no longer "get information past the band" but:

> **exhibit any unconditional $B<10/3$ on $(1,4/3]$** — and then read
> the answer off $V^*(B)=(2B-1)/(3B-2)$.
