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

## 3. ~~Where $B$ could come from: the $q$-aspect~~ — REFUTED, with a better constraint in its place

**This section died in hostile audit within the hour (2026-08-12).** It
is kept struck rather than deleted, per protocol; the refutation and its
yields are §3′. §1–2 are untouched and were flagged in advance as
frame-internal.

~~

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

~~**Calibration.** The record for this family is $56\%$
(Conrey–Iwaniec–Soundararajan, [arXiv:1105.1177](https://arxiv.org/abs/1105.1177)),
improved to $61.07\%$ with a Feng mollifier
([arXiv:2105.07422](https://arxiv.org/abs/2105.07422)). Both use
Levinson's method. An inertia certificate at $\lambda=4/3$ needs only
$B<10/3$ to pass $2/3$, and $B=1$ would give $5/6$ at $\lambda=2$.~~

## 3′. The refutation, and the two constraints it leaves

**Where I was wrong.** The exponent algebra above is internally correct,
and its premise is not. The diagonal-dominance wall is not measured
against the *conductor* but against the **length of the $t$-integration**:
Prop 5.6's dominance condition is $X\ll T\ell$, and in the single-$\zeta$
case conductor and $t$-range coincide, which is exactly the conflation
my $\lambda\le(1+2\theta)/(1+\theta)$ exploited. Worse, character
orthogonality forces $q\mid(n-m)$, so surviving off-diagonal pairs have
$|h|\ge Q$: the off-diagonal mass is $\ll QX\ell^2$ against a main term
$\asymp Q^2T\ell^3$, giving $X\ll QT\cdot\mathrm{polylog}$ — i.e.
$$\lambda\le 1+O\!\big(\tfrac{\log\log\ell}{\ell}\big)\quad\text{for every }\theta .$$
The band excess is $o(1)$, so the gain is $o(1)$. Dead.

**And the manuscript said so.** Remark 7.2(i) states the opposite of my
proposal — for $q\le T^\vartheta$ the band *shrinks*, $\Lambda<1/(1+\vartheta)$
— and Remark 7.2(iii) predicts precisely the corrected conclusion: character
orthogonality "restores $\Lambda^*=1$ for the family average", with an
expected averaged Theorem E at proportion $2/3$. I read §1, §5 and §7.5
of the primary source and not §7.2–7.3, and proposed something the
source had already answered. Recording that as the process failure it is.

### 3′.1 The new constraint: a lossiness budget of 3

The audit's central finding is better than the proposal it killed, and
it is permanent. An upper bound on $\|\tilde G\|_F^2$ *does* suffice
(that part of §1–2 is confirmed) — but it must be **sharp-constant**,
because the certificate has almost no margin. If a tool inflates the
off-diagonal prime term by a factor $C$, then
$$H=2-\frac1\lambda-\frac{C\lambda}{3},
\qquad \max_\lambda H = 2-2\sqrt{C/3}\ \ \text{at}\ \ \lambda^*=\sqrt{3/C},$$
so
$$\boxed{\ \text{any global tool must satisfy } C<3\ }$$
to certify anything at all. The large sieve's inflation is the ratio of
its $Q^2$ to the true primitive-character count
$\sum_{q\le Q}\varphi^*(q)\sim 18Q^2/\pi^4$ (from
$\sum\varphi^*(q)q^{-s}=\zeta(s-1)/\zeta(s)^2$), i.e.
$$C=\pi^4/18=5.4116\ldots,\qquad \max H=-0.686 .$$
Vacuous — and failing by only a factor $1.80$. Dyadic $q$ is worse
($C=7.2$), prime moduli worse by $\log Q$, the sharp $q/\varphi(q)$-weighted
form worse still. Splitting (exact on $[0,1]$, lossy only on the tail)
fails too at large band excess: at $\lambda=\sqrt3$ the tail carries
$\ell^3/3$ of the prime term's $\ell^3\cdot0.866$, giving
$\|\tilde G\|_F^2/N=2.13>2$.

**What this rules out, as a class:** worst-case inequalities. The large
sieve's $Q^2T$ term *is* the diagonal, so $|\mathrm{OffDiag}|\le
\mathrm{Total}+\mathrm{Diag}$ bounds the off-diagonal by something of
the same order as the main term; no such inequality can ever certify
$\mathrm{OffDiag}=o(\mathrm{Diag})$, whatever the exponents do. The door
needs an *asymptotically sharp evaluation*, not a bound — which is
exactly the Hardy–Littlewood-strength requirement, now derived rather
than asserted, and with a number ($C<3$) attached.

So §1–2 and §3′.1 are two prices on the same door, and both must be
paid: a tail bound $B<B^*(\lambda)$, obtained by a tool of global
lossiness $C<3$.

### 3′.2 Two real targets the refutation exposes

1. **The family's payoff is $T$, not band.** Remark 7.2(iii): with the
   orthogonality-restored $\Lambda^*=1$, one expects an averaged
   Theorem E at $2/3$ **with $T$ as small as a power of $\log q$**
   (needing a Gevrey-class taper). That is a genuine, bounded,
   theorem-shaped target — and it is what the family actually buys.
2. **Under GRH the $q$-aspect band does reach 2**, and my exponent's
   ceiling was tracking something real. Özlük, and Chandee–Lee–Liu–
   Radziwiłł ([arXiv:1211.6725](https://arxiv.org/abs/1211.6725)),
   compute the $q$-aspect pair correlation uniformly for
   $|\alpha|\le2-\varepsilon$ under GRH — yielding $\ge11/12$ simple
   zeros — and their ceiling $2$ is the same $2$ my formula approached as
   $\theta\to\infty$. Not a coincidence: it is where $X=Q^2$ and the
   prime pairs $h=kq$ take over. The structure was right; the mass past
   $1$ needs GRH, which is the one thing this frame exists to avoid.

### 3′.3 Corrections to earlier notes

- `ATLAS.md` §5.4 called "re-proving the no-aliasing sampling identity
  across character orthogonality on a two-index frame" the concrete
  unclaimed piece. **Wrong and unnecessary:** the zero multiset of
  $L(s,\chi)$ is invariant under $\rho\mapsto1-\bar\rho$ (functional
  equation composed with $L(\bar s,\chi)=L(s,\bar\chi)$), $\nu_{X,\chi}$
  is real, so the $(1,1)$ reading holds verbatim per character and the
  family object is the block diagonal $\bigoplus_\chi G^\chi$, with
  $\operatorname{tr}$ and $\|\cdot\|_F^2$ additive. No two-index frame
  is needed; the obstruction was never there.
- Prime-side inputs that would still need re-derivation in any family
  attempt, none supplied by an inequality: $\operatorname{tr}\tilde G$
  (a two-sided asymptotic), the archimedean $1/\lambda$ with
  $\ell_{1,\chi}=\log(qT/2\pi)$ varying across the family, Mertens sums
  with $(n,q)=1$, the cross term, and Prop 4.2's taper uniformity in $q$.

## 4. Status, and what kills it

**Established here:** the Proposition, the three closed forms, the
degeneration $V(1,B)=2/3$ and $V^*(\infty)=2/3$, the break-even values,
and the $\lambda\le(1+2\theta)/(1+\theta)$ exponent. All verified
symbolically.

**Refuted (§3′):** the family route, on caveats 1, 4 and 5 of the five I
listed — the asymptotic requirement, the inequality-to-pointwise-bound
translation, and prior art. Caveats 2 and 3 turned out to be non-issues.
The audit resolved all five in one pass, which is the outcome the
asymmetry note anticipated: **§1–2 are frame-internal and survive.** They
price any future source of $B$, single-$\zeta$ or otherwise, and §3′.1
adds the second price that any such source must also pay.

## 5. Yield

The one remaining door now has a number on it. The program's task in
this direction is no longer "get information past the band" but:

> **exhibit any unconditional $B<10/3$ on $(1,4/3]$, by a tool whose
> global lossiness satisfies $C<3$** — and then read the answer off
> $V^*(B)=(2B-1)/(3B-2)$.

The second clause is the one the refutation added, and it is the more
restrictive: it eliminates worst-case inequalities as a class and leaves
only asymptotically sharp evaluation. That is the honest statement of
the door, and it is why the door is hard — now with two numbers on it
instead of a mood.
