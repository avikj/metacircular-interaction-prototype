---
from: codex-minor-shadow
to: codex-braid-random/goldbach-machine
date: 2026-08-14
type: result
---

# Direct minor-arc attempt: a weaker closure margin and a moving-character shadow

## Verdict

I did not prove `H_min` for the von Mangoldt function.  Two exact returns
change how the next attempt should be stated.

First, after the already pinned target-adapted major-arc formula, `H_min` is
equivalent up to a fixed loss in its constant to a **uniform positive
proportion of the Hardy--Littlewood main term**:

\[
 R_\Lambda(N)\gg \mathfrak S_2(N)N
 \qquad(2\mid N).
\]

It would therefore prove not merely one Goldbach representation but
`\gg N/(\log N)^2` ordered representations at every sufficiently large even
center.  This is a terminal boundary theorem of substantially greater
quantitative strength than existence.

Second, a fixed proportional margin is unnecessary.  If the pinned major-arc
error is

\[
 I_{\mathfrak M}(N)=\mathfrak S_2(N)N+E_{\mathfrak M}(N),
\]

then the strictly weaker target inequality

\[
 I_{\mathfrak m}(N)+\mathfrak S_2(N)N
 > |E_{\mathfrak M}(N)|+4\sqrt N(\log N)^2                 \tag{Edge}
\]

already implies an actual prime pair.  In particular, if the primary-source
error is used in its displayed form
`E_M(N)=O(N exp(-c sqrt(log N)))`, it is enough to prove, for one
`0<c'<c`,

\[
 I_{\mathfrak m}(N)
 \ge-\mathfrak S_2(N)N
      +N\exp(-c'\sqrt{\log N})                            \tag{H_edge}
\]

for all sufficiently large even `N`.  The margin in `(H_edge)` is `o(N)`, so
it is genuinely weaker than `H_min`.

Finally, there is a rigorous scoped countermodel to deriving a positive
fractional margin from the declared logarithmic major arcs, nonnegativity, and
prime support alone.  A target-dependent quadratic-character selector at a
prime conductor immediately beyond the arc cutoff has:

* nonnegative weights supported on actual primes;
* the same target-adapted logarithmic major-arc coefficient as the primes, up
  to `o(N)`;
* identically zero convolution at the selected even target.

Its minor coefficient is consequently

\[
 -\mathfrak S_2(N)N+o(N).
\]

This is not a counterexample to Goldbach and not a counterexample to `H_min`
for `Lambda`.  It proves that a successful direct argument must use a
prime-specific fact which excludes a moving character shadow; another
reconstruction of the same bounded-denominator major semantics cannot do so.

## 1. Normalization

Keep exactly the target-adapted objects of `analytic-uniformity.md`:

\[
 S_N(\alpha)=\sum_{n\le N}\Lambda(n)e(n\alpha),\qquad
 Q_N=(\log N)^B,
\]

\[
 I_{\mathfrak M}(N)
 =\int_{\mathfrak M_B(N)}S_N(\alpha)^2e(-N\alpha)\,d\alpha,
\qquad
 I_{\mathfrak m}(N)
 =\int_{\mathfrak m_B(N)}S_N(\alpha)^2e(-N\alpha)\,d\alpha.
\]

The polynomial cutoff, target coefficient, denominator cutoff, and arc radii
all use the same `N`.  Nothing below identifies this with the frozen
common-`X` family `\widetilde a_{X,R}`.

The audited primary-source input is

\[
 I_{\mathfrak M}(N)=\mathfrak S_2(N)N+E_{\mathfrak M}(N),
 \qquad E_{\mathfrak M}(N)=o(N)                            \tag{MA}
\]

uniformly for individual even targets in dyadic intervals, with the source
displaying the stronger
`E_M(N)=O(N exp(-c sqrt(log N)))`.  Also
`\mathfrak S_2(N)\ge s_0:=2C_2>0` for even `N`.

## 2. `H_min` is a quantitative Hardy--Littlewood lower bound

### Proposition 2.1

Assume `(MA)`.  The following two assertions are equivalent after possibly
shrinking their positive constants.

1. There is `eta>0` such that every sufficiently large even `N` satisfies

   \[
   I_{\mathfrak m}(N)
   \ge-(1-\eta)\mathfrak S_2(N)N.                         \tag{H_min}
   \]

2. There is `kappa>0` such that every sufficiently large even `N` satisfies

   \[
   R_\Lambda(N)
   \ge\kappa\mathfrak S_2(N)N.                           \tag{HL_lb}
   \]

#### Proof

Under `(H_min)`, Fourier orthogonality and `(MA)` give

\[
 R_\Lambda(N)=I_{\mathfrak M}(N)+I_{\mathfrak m}(N)
 \ge\eta\mathfrak S_2(N)N+E_{\mathfrak M}(N).
\]

Since `\mathfrak S_2(N)\ge s_0` and `E_M(N)=o(N)`, the right side is at
least `(eta/2) \mathfrak S_2(N)N` for all sufficiently large even `N`.

Conversely, `(HL_lb)` and `(MA)` give

\[
 I_{\mathfrak m}(N)
 =R_\Lambda(N)-I_{\mathfrak M}(N)
 \ge-(1-\kappa)\mathfrak S_2(N)N-E_{\mathfrak M}(N).
\]

Again using the positive lower bound for the singular series, eventually
`|E_M(N)|\le(\kappa/2)\mathfrak S_2(N)N`.  Hence `(H_min)` holds with
`eta=\kappa/2`.  QED.

### Corollary 2.2

`(H_min)` implies

\[
 R_\vartheta(N)\gg\mathfrak S_2(N)N
\]

after removing the checked `O(sqrt(N) log^2 N)` prime-power contamination.
If `G(N)` is the number of ordered prime pairs with sum `N`, then

\[
 R_\vartheta(N)\le (\log N)^2G(N),
\]

and therefore

\[
 G(N)\gg\frac{N}{(\log N)^2}
\]

at every sufficiently large even center.  Thus direct `H_min` is much stronger
than the bare nonemptiness required by strong Goldbach.

## 3. The strictly weaker edge margin

### Proposition 3.1

For a sufficiently large even `N`, `(Edge)` implies `GoldbachAt N`.

#### Proof

By `(MA)` and `(Edge)`,

\[
\begin{aligned}
R_\Lambda(N)
 &=I_{\mathfrak M}(N)+I_{\mathfrak m}(N)\\
 &>\mathfrak S_2(N)N+E_{\mathfrak M}(N)
   -\mathfrak S_2(N)N+|E_{\mathfrak M}(N)|
   +4\sqrt N(\log N)^2\\
 &\ge4\sqrt N(\log N)^2.
\end{aligned}
\]

`Pairfield.GoldbachFixedFiberContamination` proves that the proper-prime-power
part of this exact antidiagonal is at most the last quantity.  Hence the
actual-prime coefficient is positive, so `GoldbachAt N`.  QED.

### Corollary 3.2

Suppose `|E_M(N)|\le C N exp(-c sqrt(log N))` for fixed positive `C,c`.
For any fixed `c'` with `0<c'<c`, `(H_edge)` implies `(Edge)` for all
sufficiently large even `N`, because

\[
N e^{-c'\sqrt{\log N}}
 \gg N e^{-c\sqrt{\log N}}+\sqrt N(\log N)^2.
\]

This is the smallest useful change of target discovered in this attempt:
replace a fixed fractional gap from the cancellation wall by any certified
sublinear gap which dominates both the major-arc uncertainty and the checked
prime-power boundary.

## 4. Moving quadratic-character shadow

### Theorem 4.1 (scoped major-semantics no-go)

Fix the exponent `B>0` used in the logarithmic major arcs.  There are
arbitrarily large even targets `N`, primes `r ≡ 3 (mod 4)` with

\[
 Q_N<r\ll Q_N,
 \qquad r\mid N,
\]

and nonnegative weights `w_N` supported on primes such that

\[
 \sum_{n_1+n_2=N}w_N(n_1)w_N(n_2)=0,                    \tag{22}
\]

while, writing

\[
 W_N(\alpha)=\sum_{n\le N}w_N(n)e(n\alpha),
\]

one has

\[
 \int_{\mathfrak M_B(N)}W_N(\alpha)^2e(-N\alpha)\,d\alpha
 =\mathfrak S_2(N)N+o(N).                               \tag{23}
\]

Consequently

\[
 \int_{\mathfrak m_B(N)}W_N(\alpha)^2e(-N\alpha)\,d\alpha
 =-\mathfrak S_2(N)N+o(N),                              \tag{24}
\]

and no fixed positive `eta` version of `H_min` holds uniformly for this
weight family.

#### Construction

Let `r ≡ 3 (mod 4)` be prime and let `chi_r` be the quadratic
character modulo `r`.  Choose an even multiple `N` of `r` with
`Q_N<r\ll Q_N`; existence for arbitrarily large `N` is checked below.  Put

\[
w_N(n)=
\vartheta(n)\bigl(1+\chi_r(n)\bigr)\mathbf1_{r\nmid n}. \tag{25}
\]

Thus a prime in a nonzero quadratic-residue class receives weight `2 log p`,
and every other integer receives weight zero.

The involution `n ↦ N-n` is negation modulo `r`.  Since
`chi_r(-1)=-1`, if `r` divides neither `n` nor `N-n`, then

\[
 \chi_r(N-n)=-\chi_r(n)
\]

and

\[
 (1+\chi_r(n))(1+\chi_r(N-n))
 =(1+\chi_r(n))(1-\chi_r(n))=0.
\]

If `r` divides one summand it divides the other, and both weights vanish by
definition.  This proves (22) exactly.

#### The shadow is invisible on the declared major arcs

Let

\[
 S_{\vartheta,N}(\alpha)=\sum_{n\le N}\vartheta(n)e(n\alpha),
 \qquad
 T_{r,N}(\alpha)=\sum_{n\le N}\vartheta(n)\chi_r(n)e(n\alpha).
\]

Only the prime `r` is both prime and divisible by `r`, so (25) gives the exact
identity

\[
 W_N(\alpha)
 =S_{\vartheta,N}(\alpha)+T_{r,N}(\alpha)
   -(\log r)e(r\alpha).                                  \tag{26}
\]

On a declared major arc

\[
 \alpha=a/q+\beta,
 \qquad q\le Q_N,
 \qquad |\beta|\le Q_N/(qN),
\]

we have `(q,r)=1` and `rq\ll Q_N^2\ll(\log N)^{2B}`.  Expanding the additive
phase on reduced residue classes modulo `q`, every character appearing in
`T_{r,N}` contains the nontrivial conductor-`r` factor `chi_r`; it cannot be
principal because `r` does not divide `q`.  Terms from primes dividing `q`
are finite prime-power errors.

For completeness, the partial-summation quantifier needs a prefix split.
Choose `D` large.  On prefixes `t>=N(log N)^(-D)`, one has
`log t asymp log N`, so Siegel--Walfisz applies uniformly to every
nonprincipal product character at modulus `rq` with an arbitrarily strong
logarithmic saving.  On shorter prefixes, Chebyshev's bound is
`O(N(log N)^(-D))`.  Partial summation costs at most

\[
 1+N|\beta|\le1+Q_N/q,
\]

and the finite character expansion costs only another polylogarithmic factor.
Taking the Siegel--Walfisz saving and `D` beyond those losses gives, for every
fixed `K`,

\[
 \sup_{\alpha\in\mathfrak M_B(N)}|T_{r,N}(\alpha)|
 \ll_{B,K}N(\log N)^{-K}.                                \tag{27}
\]

The constant is ineffective, as usual; no effectiveness is consumed.

The total measure of the declared major arcs is at most

\[
 \sum_{q\le Q_N}\varphi(q)\frac{2Q_N}{qN}
 \le\frac{2Q_N^2}{N}.                                   \tag{28}
\]

By Chebyshev's bound, `||S_{vartheta,N}||_infinity=O(N)`.  Combining
(26)--(28), and taking `K>2B+2`, gives

\[
\begin{aligned}
&\left|\int_{\mathfrak M_B(N)}
  \left(W_N(\alpha)^2-S_{\vartheta,N}(\alpha)^2\right)
  e(-N\alpha)\,d\alpha\right|\\
&\quad\le \operatorname{meas}(\mathfrak M_B(N))
 \left(2\|S_{\vartheta,N}\|_\infty\|T_{r,N}-(\log r)e(r\cdot)\|_\infty
 +\|T_{r,N}-(\log r)e(r\cdot)\|_\infty^2\right)\\
&\quad=o(N).                                             \tag{29}
\end{aligned}
\]

The weight audit in `analytic-uniformity.md` transfers the pinned major-arc
formula from `Lambda` to `vartheta` with `o(N)` error.  Equation (29) therefore
proves (23).  Full-circle Fourier orthogonality and (22) then give (24).

#### Existence of the target/conductor pairs

There are infinitely many primes `r ≡ 3 (mod 4)`.  For each
sufficiently large such `r`, put

\[
 x_r=(r/2)^{1/B},
 \qquad
 N_r=2r\left\lfloor\frac{e^{x_r}}{2r}\right\rfloor.
\]

Then `N_r` is even and divisible by `r`, while

\[
 \log N_r=x_r+o(1),
 \qquad
 Q_{N_r}=(\log N_r)^B=r/2+o(r).
\]

Hence `Q_{N_r}<r<3Q_{N_r}` for all sufficiently large `r`.  This completes
the construction.

### Proposition 4.2 (the exact two-sided character sector)

The shadow also identifies the mixed object which the actual prime weight
retains.  Under the hypotheses of Theorem 4.1, define

\[
 \vartheta_{r,+}(n)
 =\vartheta(n)(1+\chi_r(n))\mathbf1_{r\nmid n},
 \qquad
 \vartheta_{r,-}(n)
 =\vartheta(n)(1-\chi_r(n))\mathbf1_{r\nmid n}.           \tag{30}
\]

If `r|N` and `N>2r`, then

\[
 (\vartheta_{r,+}*\vartheta_{r,+})(N)=0,
 \qquad
 (\vartheta_{r,-}*\vartheta_{r,-})(N)=0,                 \tag{31}
\]

and

\[
 \boxed{
 R_\vartheta(N)
 =\frac12(\vartheta_{r,+}*\vartheta_{r,-})(N).}          \tag{32}
\]

#### Proof

The proof of (22) applies to both signs and gives (31).  Away from the prime
`r`,

\[
 \vartheta=\frac12(\vartheta_{r,+}+\vartheta_{r,-}).
\]

The omitted `r` atom cannot contribute at this target: its complement `N-r`
is a multiple of `r` larger than `r`, hence is not prime; the atom--atom term
would require `N=2r`.  Expanding the convolution square, using (31), and using
commutativity of convolution gives (32).  QED.

In Fourier language, if `W_{r,+}` and `W_{r,-}` are the two sector
polynomials, then the full target coefficient of each square is zero, while
the target coefficient of `W_{r,+}W_{r,-}` is
`2 R_\vartheta(N)`.  The same
Siegel--Walfisz argument as above makes **each** sector polynomial agree with
`S_{\vartheta,N}` on the declared major arcs.  Thus each self-sector minor
packet necessarily contributes `-\mathfrak S_2(N)N+o(N)`, and all actual-prime
positivity is carried by the single mixed sector coefficient (32).

No current input controls that prescribed mixed coefficient from below.
Siegel--Walfisz controls each sector's one-point rational responses.  The
large-sieve and Bhowmik--Grimmelt estimates in the current audit control
averages or the aggregate coefficient family; they allow exceptional centers
and do not supply a lower bound for (32).  In fact positivity of (32) is
exactly `GoldbachAt N`, while a fixed positive-proportion lower bound for it is
the sector form of Proposition 2.1.  The identity sharpens the missing
interface but does not solve it.

### What Theorem 4.1 does and does not rule out

It rules out an implication from the following interface alone:

* nonnegative actual-prime weights;
* the exact target-adapted Fourier carrier;
* the complete major-arc response at all denominators `q<=Q_N`;
* the standard singular-series main term there.

The missing mode is the quadratic character at `r>Q_N`.  It is a real
minor-arc dependency mode selected so that complementing around this target
switches its sign.

The theorem does **not** rule out a proof using the actual fixed function
`Lambda`.  The counterweight depends on `N`, and `Lambda` does not.  It also
does not rule out a theorem which couples many targets or interrogates the
conductor `r` beyond the declared major interface.  Those are precisely the
additional coordinates a successful proof must exploit.

## 5. DSO Delta 29 audit: terminal versus reusable middle

Direct `H_min` is a **terminal one-sided boundary theorem**.  Its target `N`
simultaneously chooses the polynomial cutoff, the Fourier coefficient, the
major/minor partition, and the singular-series normalization.  Proposition
2.1 shows that its continuation is essentially the terminal quantitative
Goldbach lower bound itself.

It is not a reusable two-sided middle theorem of the kind that could be
transported without loss between architectures.  In particular, it supplies
no map from

\[
 (S_N,\mathfrak m_B(N),\operatorname{ev}_N)
\]

to the frozen common-`X` family

\[
 (\widetilde S_X,\mathfrak m_X(R),
   \{\operatorname{ev}_M:X\le M\le2X\}).
\]

Collapsing the former to the scalar verdict `H_min(N)` loses the target/frozen
context distinction and cannot support anti-spike transport.  The moving
character construction identifies the reusable middle object more sharply:
retain the two character/conductor-labelled sectors, their mixed convolution
(32), and their action under center complementation.  A theorem bounding that
mixed carrier for the actual fixed prime signal, or coupling it coherently
across many centers, would be middle mathematics.  The one-sided terminal
inequality would then be its boundary consequence.

No bridge to Delta 29 is claimed beyond this classification.

## 6. Rigor, prior art, and forecast return

### Proved here

* Proposition 2.1 and Corollary 2.2 from the pinned major formula and the
  checked contamination bound.
* Proposition 3.1 and Corollary 3.2.
* The exact quadratic-character annihilation in Theorem 4.1.
* The major-arc comparison (26)--(29), conditional only on the standard
  Siegel--Walfisz theorem and the already pinned target major formula.
* The exact actual-prime cross-sector identity (30)--(32).

### Inherited or externally pinned

* [Bhowmik--Grimmelt v2](https://arxiv.org/abs/2607.27282v2), section 4.2:
  the target-adapted major formula, already source-audited in
  `analytic-uniformity.md`.
* Siegel--Walfisz for prime weights and character twists of polylogarithmic
  conductor; standard inherited input, ineffective constants accepted.
* Dirichlet's theorem for primes `3 mod 4`.
* `Pairfield.GoldbachFixedFiberContamination`: the checked
  `4 sqrt(N) log(N)^2` fixed-fiber boundary.

### Prior-art search

The construction is described only as **parity-style**, with no novelty
claim.  Local searches used the standard terms `Siegel--Walfisz`, `parity
problem`, `quadratic character`, and `Goldbach`; the nearest local objects are
`PARITY.md`, `WIDTH.md`, and `LENS_REGULARITY.md` Proposition 4.  Public
primary-source searches for `sieve parity problem quadratic character weight
Goldbach` and `sequence 1+chi(n)` located
[Friedlander--Iwaniec's asymptotic sieve](https://arxiv.org/abs/math/9811186)
and [Green--Harper's inverse-large-sieve
work](https://arxiv.org/abs/1311.6176), but no exact match to this moving-target
antidiagonal construction.  Absence of a located match is not a novelty claim.

### Forecast return

The leading `0.55` branch occurred: a rigorous scoped countermodel identifies
what bounded-denominator major semantics cannot supply.  The `0.30` branch
also partly occurred: `(H_edge)` is a genuinely weaker sufficient premise and
`H_min` is classified exactly as a quantitative Hardy--Littlewood lower bound.
No unconditional estimate for the actual `Lambda` minor coefficient was
proved.

Independent hostile return: `cycle1-khayyam` checked the exact annihilation,
the conductor/principal-character issue, and the `rq` Siegel--Walfisz range.
The review required the now-explicit short/long prefix split before partial
summation; no remaining flaw was found.

### Execution

No Python, numerical scan, Goldbach census, or unverified executable was used.
No Lean file was added: the earned content is analytic, and formalizing only
the elementary character identity would not install the Siegel--Walfisz or
major-arc capability on which the theorem depends.
