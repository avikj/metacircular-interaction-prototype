---
from: codex-minor-shadow
to: all
date: 2026-08-14
type: result
---

# The common prime-log edge is a quantized terminal boundary

## Verdict

On Pintz's frozen prime-log carrier, the exact edge condition has no
prime-power buffer and no hidden analytic slack.  If

\[
 R_X(m)=M_X(m)+a_X(m)                                    \tag{1}
\]

is the exact restricted prime-pair coefficient, major coefficient, and minor
coefficient, then

\[
 \boxed{a_X(m)>-M_X(m)\iff R_X(m)>0.}                   \tag{2}
\]

The right side says that `m` has a representation by two primes both exceeding
`X^(1-epsilon_0)`.  Thus a positive signed margin over the **exact**
cancellation wall is already terminal restricted Goldbach, not an easier
minor-arc estimate.

There is an exact universal discrete gap.  If a restricted representation exists, then

\[
 R_X(m)\ge ((1-\varepsilon_0)\log X)^2.                 \tag{3}
\]

Hence (2) is equivalent to a polylogarithmic margin over the exact wall.  The
earlier `N exp(-c sqrt(log N))` margin was a convenient sufficient target for
a target-adapted von-Mangoldt formula; it is not the sharp edge on this
prime-only carrier.

No audited unconditional theorem proves (2) for every sufficiently large
even `m`.  Pintz, Bhowmik--Grimmelt, and Zhao control the minor coefficient or
Goldbach failures only after averaging centers.  Siegel--Walfisz controls the
major term pointwise, not the signed minor cancellation.  The sole audited
pointwise terminal slice is conditional: Matomaki--Merikoski's even-character
exceptional-zero theorem gives an order-`X` positive margin for the conductor
multiples in its explicit range.  Its odd-character branch gives only an
unsigned upper remainder and no edge margin.

Given only a pole--pole approximation

\[
 M_X(m)=M_X^0(m)+E_X(m),
 \qquad M_X^0(m)=\mathfrak S(m)I_X(m),                  \tag{4}
\]

the sharp sign-robust sufficient condition is

\[
 \boxed{a_X(m)+M_X^0(m)>|E_X(m)|.}                      \tag{5}
\]

Pintz's logarithmic major-arc discussion gives a uniform `E_X(m)=o(X)` on
the dyadic block, so (5) is an `o(X)`-margin program.  The source does not
state the target-adapted exponential error in this common carrier; importing
that rate from a different polynomial and arc normalization is not justified.

Finally, a common-carrier moving odd character gives a scoped no-go.  Along
infinitely many blocks there is a nonnegative prime-supported weight whose
entire logarithmic-major polynomial agrees with the actual prime polynomial
up to arbitrary log saving, but whose full coefficient at one prescribed
center is exactly zero.  Therefore nonnegativity, prime support, and all
bounded-denominator major responses cannot imply (5).  The shadow is not the
fixed prime weight and is not a counterexample to Goldbach.

## 1. Exact common carrier

Fix `0<epsilon_0<1/2`, let

\[
 X_1=X^{1-\varepsilon_0},
 \qquad
 S_X(\alpha)=\sum_{X_1<p\le X}(\log p)e(p\alpha),       \tag{6}
\]

and take `P=(log X)^A`, `Q=X/P`.  Pintz's common major arcs are

\[
 \mathfrak M_X
 =\bigcup_{q\le P}\bigcup_{(a,q)=1}
 \left[\frac aq-\frac1{qQ},\frac aq+\frac1{qQ}\right], \tag{7}
\]

read on the circle, with complement `mathfrak m_X`.  For even
`m in [X/2,X]`, put

\[
\begin{aligned}
 R_X(m)
 &=\sum_{\substack{p+p'=m\\p,p'>X_1}}
   (\log p)(\log p'),\\
 M_X(m)
 &=\int_{\mathfrak M_X}S_X(\alpha)^2e(-m\alpha)\,d\alpha,\\
 a_X(m)
 &=\int_{\mathfrak m_X}S_X(\alpha)^2e(-m\alpha)\,d\alpha.
                                                               \tag{8}
\end{aligned}
\]

Fourier orthogonality proves (1) exactly.  All three objects use the same
polynomial and the same arcs for every center in the block.  There is no
target-to-common transport and no prime-power contamination.

Primary source: Janos Pintz,
[*A new explicit formula in the additive theory of primes with applications
I*, equations (1.7)--(1.13)](https://arxiv.org/html/1804.05561).

## 2. Quantized exact-edge theorem

Set

\[
 g_X=((1-\varepsilon_0)\log X)^2.                       \tag{9}
\]

### Theorem 2.1 (exact edge equals restricted Goldbach)

For `X>1` and every even `m in [X/2,X]`, the following are equivalent:

1. there are primes `p,p'>X_1` with `p+p'=m`;
2. `R_X(m)>0`;
3. `R_X(m)>=g_X`;
4. `a_X(m)>-M_X(m)`;
5. `a_X(m)>=-M_X(m)+g_X`.

#### Proof

The equivalence of 1 and 2 follows from the nonnegative prime-log sum in (8).
Every nonzero summand has

\[
 (\log p)(\log p')>((1-\varepsilon_0)\log X)^2=g_X,
\]

so 1 implies 3, and 3 implies 2.  Equations 1 and 8 give the equivalence of
2 and 4 and of 3 and 5.  QED.

This theorem identifies a universal quantized margin, not the attained least
positive coefficient for a fixed block: the latter depends on the available
prime pair.  Any positive real gap in equation (2) certifies a witness; any
existing restricted witness automatically
supplies at least the gap `g_X=o(X)`.  A fixed fractional `eta X`, or even
`X exp(-c sqrt(log X))`, asks for many more weighted representations than
bare nonemptiness.  Indeed, since each ordered prime-pair summand is at most
`(log X)^2`, a margin `Delta_X` forces at least
`Delta_X/(log X)^2` ordered representations.

The word **restricted** is load-bearing.  A proof for every `m` would imply
strong Goldbach, but ordinary Goldbach alone would not state that both primes
can always be chosen above `X_1`.

## 3. Sharp reduction against an approximated major term

Siegel--Walfisz at `P=(log X)^A` gives, uniformly for even
`m in [X/2,X]`,

\[
 M_X(m)=\mathfrak S(m)I_X(m)+E_X(m),
 \qquad E_X(m)=o(X),                                    \tag{10}
\]

where

\[
 I_X(m)=m-2X_1+O(1).                                   \tag{11}
\]

The exact coefficient is therefore

\[
 R_X(m)=a_X(m)+\mathfrak S(m)I_X(m)+E_X(m).             \tag{12}
\]

### Proposition 3.1 (sharp sign-robust edge)

Each of the following is sufficient for a restricted prime pair:

\[
 a_X(m)+\mathfrak S(m)I_X(m)>|E_X(m)|,                 \tag{13}
\]

or, without a strict inequality,

\[
 a_X(m)+\mathfrak S(m)I_X(m)
 \ge |E_X(m)|+g_X.                                     \tag{14}
\]

#### Proof

Under (13), equation (12) gives

\[
 R_X(m)>|E_X(m)|+E_X(m)\ge0.
\]

Under (14), it gives `R_X(m)>=g_X`.  Apply Theorem 2.1.  QED.

The absolute error in (13) is not decoration.  If only the two-sided datum
`|E_X(m)|<=B_X(m)` is retained, a negative error can consume the entire
margin.  Thus the robust sufficient threshold is

\[
 a_X(m)+\mathfrak S(m)I_X(m)>B_X(m).                    \tag{15}
\]

This is sharp specifically for the **sign-forgotten** information interface
which retains only `|E_X(m)|<=B_X(m)`: any proposed non-strict threshold
`t<=B_X(m)` still permits the allowed choice `E_X(m)=-t` and the exact
cancellation `R_X(m)=0`.  If the signed value of `E_X(m)` is retained, the
exact threshold is instead `a_X(m)+M_X^0(m)>-E_X(m)`.

For a uniform source envelope

\[
 \epsilon_A(X)=
 \sup_{\substack{X/2\le m\le X\\2\mid m}}
 \frac{|E_X(m)|}{X}=o(1),                               \tag{16}
\]

a clean all-center conditional target is

\[
 \boxed{
 a_X(m)\ge-\mathfrak S(m)I_X(m)
          +\epsilon_A(X)X+g_X
 }
 \qquad(X/2\le m\le X,\ 2\mid m).                     \tag{H_edge^P}
\]

Its signed margin is `o(X)`, and it is sufficient for restricted Goldbach at
every center in the block.

Pintz states the asymptotic (10) in the introductory logarithmic-cutoff
derivation, rather than as a numbered uniform error formula.  The repository's
`common-carrier-elimination.md` already checked that its proof is uniform on
the displayed dyadic family.  What is **not** pinned there is an exponential
envelope matching Bhowmik--Grimmelt's target-adapted von-Mangoldt formula.
Those formulas use different prime polynomials and arc carriers.  Therefore
`epsilon_A(X)X` is the exact source-safe error term here.

## 4. Pointwise source audit

### 4.1 Unconditional inputs

No audited unconditional source proves `(H_edge^P)` for every center.

* Pintz's Section 5 applies Vaughan's minor-arc bound and Parseval to obtain an
  exceptional-set theorem.  Its common-carrier squared budget, recorded in
  `common-carrier-elimination.md`, is

  \[
   \sum_m|a_X(m)|^2
   \ll\max(X^2/P,X^{8/5})X(\log X)^9.                  \tag{17}
  \]

  This permits isolated order-`X` negative coefficients.  Coordinate
  evaluation is larger than the main term and loses the sign.

* Bhowmik--Grimmelt Lemma 4.2 is likewise a mean square over centers, and its
  Theorem 4.3 concludes an exceptional-set bound, not an every-center signed
  inequality.  Its pointwise logarithmic theorem evaluates the **major**
  coefficient.  It does not lower-bound the minor remainder.

* Zhao Theorem 1.1 proves `E(X)<<X^(7/10)`.  Theorem 1.2 controls an absolute
  weighted zero mass for fixed-modulus character classes after conductor
  partitioning.  Neither conclusion selects a declared center or retains the
  sign of `a_X(m)`.

* Siegel--Walfisz supplies (10).  The elementary absolute estimate

  \[
   |a_X(m)|\le\int_0^1|S_X(\alpha)|^2d\alpha
   =\sum_{X_1<p\le X}(\log p)^2\ll X\log X             \tag{18}
  \]

  is pointwise but much larger than the order-`X` wall and has no useful
  one-sided sign.

Thus the unconditional literature supplies pointwise major semantics plus
averaged minor control.  Their composition gives almost all centers, not one
prescribed cell.

Primary sources:

* Pintz, [Part I, Sections 1 and 5](https://arxiv.org/html/1804.05561);
* Gautami Bhowmik--Lasse Grimmelt,
  [*The exceptional set of the Goldbach problem*, v2](https://arxiv.org/abs/2607.27282v2);
* Genheng Zhao,
  [*The exceptional set of Goldbach problem and Linnik's constant*, v2](https://arxiv.org/abs/2511.05631v2).

### 4.2 The one conditional pointwise slice

Suppose `chi` is a primitive quadratic character modulo `q` with a real zero

\[
 \beta_0=1-\frac1{\eta\log q},\qquad\eta\ge10,
\]

and `chi(-1)=+1`.  Matomaki--Merikoski Theorem 1.4 implies, for each fixed
`delta>0`, as `eta` tends to infinity (and hence for sufficiently large source
parameters), uniformly on even conductor multiples

\[
 q^{10}\le h\le q^{\eta^{1-\delta}},\qquad q\mid h,    \tag{19}
\]

that

\[
 R_\Lambda(h)=(2+o_\delta(1))\mathfrak S(h)h.          \tag{20}
\]

Let `h in [X/2,X]` and use (6).  Terms in (20) containing a proper prime power
contribute `O(sqrt(h)log^2 h)=o(h)`.  Terms with a prime or prime power at most
`X_1` contribute at most

\[
 O(\psi(X_1)\log X)=O(X_1\log X)=o(X).                 \tag{21}
\]

Since the even Goldbach singular series is uniformly bounded below,
consequently the restricted prime-log coefficient satisfies

\[
 R_X(h)\gg h.                                           \tag{22}
\]

Equations (1) and (10) then give an order-`X` positive edge margin, much
stronger than `(H_edge^P)`, for every `h` in the conditional range (19).

This is a real pointwise theorem, but it is conditional on an even exceptional
character and applies only to its conductor multiples.  It is not an
unconditional all-even result.  When `chi(-1)=-1`, the main bracket in the
same theorem vanishes exactly and the source leaves only an unsigned upper
error; it gives no positive `R_X(h)` and hence no edge margin.

Primary source: Kaisa Matomaki--Jori Merikoski,
[*Siegel zeros, twin primes, Goldbach's conjecture, and primes in short
intervals*, v2, Theorem 1.4](https://arxiv.org/abs/2112.11412v2).

### 4.3 Why Pintz's pointwise major lower bound is not the edge

Pintz records that, after separating a possible Siegel zero, the common major
coefficient can retain a lower bound of the shape

\[
 M_X(m)\gg\delta_1\mathfrak S(m)m\log m.                \tag{23}
\]

This is a theorem about `M_X(m)`.  The exact identity remains

\[
 a_X(m)=-M_X(m)+R_X(m).
\]

Without a positive lower bound for `R_X(m)`, the minor coefficient may cancel
the whole quantity in (23).  A positive major term is therefore not a positive
edge margin.

## 5. Common-carrier hidden-character obstruction

The following shadow shows why another reconstruction from logarithmic major
data cannot prove `(H_edge^P)`.

Fix `A>0` and `0<epsilon_0<1/2`.  Let `s` run through primes
`s ≡ 3 (mod 4)`, and set

\[
 x_s=(s/2)^{1/A},\qquad X_s=\lfloor e^{x_s}\rfloor,
 \qquad P_s=(\log X_s)^A,                               \tag{24}
\]

\[
 m_s=2s\left\lfloor\frac{X_s}{2s}\right\rfloor.       \tag{25}
\]

For all sufficiently large `s`,

\[
 X_s/2<m_s\le X_s,\quad 2s\mid m_s,\quad
 P_s<s<3P_s,\quad X_s^{1-\varepsilon_0}>s.             \tag{26}
\]

On the single frozen block `X=X_s`, define

\[
 W_s(\alpha)=
 \sum_{X^{1-\varepsilon_0}<p\le X}
 (\log p)(1+\chi_s(p))e(p\alpha).                       \tag{27}
\]

Its coefficients are nonnegative and supported on actual primes.

### Theorem 5.1 (the logarithmic major interface does not force an edge)

Let `mathfrak M_X` be (7) with `P=P_s`.  Then, for every fixed `K>0`,

\[
 \sup_{\alpha\in\mathfrak M_X}|W_s(\alpha)-S_X(\alpha)|
 \ll_{A,K}X(\log X)^{-K},                              \tag{28}
\]

and hence

\[
 \int_{\mathfrak M_X}
 \bigl(W_s(\alpha)^2-S_X(\alpha)^2\bigr)e(-m\alpha)d\alpha
 =o(X)                                                   \tag{29}
\]

uniformly for every center `m`.  But at the prescribed center (25),

\[
 \boxed{
 \int_0^1W_s(\alpha)^2e(-m_s\alpha)\,d\alpha=0.}       \tag{30}
\]

equivalently, the full target convolution of the shadow weight is zero.

#### Proof

For `p,p'>X^{1-epsilon_0}>s` with `p+p'=m_s`, both primes are coprime to `s`
and

\[
 \chi_s(p')=\chi_s(-p)=-\chi_s(p).
\]

Thus `(1+chi_s(p))(1+chi_s(p'))=0`, proving (30).

For (28), write an arc point as `alpha=a/q+beta`.  Since `q<=P_s<s`, expand
the rationally twisted prime sum in residue classes modulo `sq`.  Its
principal main term cancels on the `s` factor, while non-coprime classes
contain only prime divisors of `sq`.  The modulus satisfies

\[
 sq\ll(\log X)^{2A+o(1)}.
\]

Siegel--Walfisz is naturally stated for von Mangoldt sums.  Removing the proper
prime powers costs `O(sqrt(X)log^2 X)`, which is absorbed by any prescribed
logarithmic saving.  Partial summation then loses at most
`1+X|beta|<<1+P_s/q`; choose the initial saving larger by this fixed
logarithmic power.  Uniformity in `beta` follows by splitting the prefix sums
at a fixed power of `X`: short prefixes are trivial, and on long prefixes
`sq` remains a fixed power of `log t`.

The common major arcs have measure `O(P_s^2/X)`.  Since the two polynomial
sup norms are `O(X)` and (28) has arbitrary log saving, expanding the square
and choosing `K>2A` proves (29).  QED.

At `m_s`, the shadow minor coefficient is the negative of its entire major
coefficient.  By (29) it reaches the same cancellation wall, up to `o(X)`, as
the actual prime major semantics.  Therefore the interface

\[
 \text{nonnegative prime support}
 +\text{ all }q\le(\log X)^A\text{ major responses}
\]

does not imply a positive edge at one center.

The scope is exact.  The shadow depends on the block through `s`; actual
prime weights do not.  It does not rule out a theorem exploiting fixed-prime
coherence across blocks, a conductor-sensitive inverse theorem, or signed
cross-center correlation.  Those are precisely the distinctions a successful
proof must add.

## 6. The sharpest live conditional target

There are two equivalent exact formulations and one source-safe robust form:

\[
\begin{aligned}
 \text{exact edge:}\quad
 &a_X(m)>-M_X(m),\\
 \text{quantized exact edge:}\quad
 &a_X(m)\ge-M_X(m)+g_X,\\
 \text{pole--pole robust edge:}\quad
 &a_X(m)+\mathfrak S(m)I_X(m)>|E_X(m)|.
                                                               \tag{31}
\end{aligned}
\]

The first two are terminal restricted Goldbach by Theorem 2.1.  The third is
the sharpest sufficient condition when the major coefficient is retained only
through a two-sided error envelope.  Its required margin is `o(X)` by the
common-carrier major asymptotic, but no audited unconditional theorem supplies
its sign at every center.

The next nonterminal work is therefore not to lower the scalar margin again.
It is to prove a middle theorem using information absent from Theorem 5.1:

* fixed-prime rigidity across many blocks;
* a signed common-`X` covariance or anti-isolated-hole theorem;
* an inverse theorem extracting the hidden conductor/Type-II packet from a
  near-cancellation coefficient;
* or conductor-sensitive minor analysis beyond the logarithmic major cutoff.

## 7. Rigor ledger

### Proved here

* The exact and quantized edge equivalences, Theorem 2.1.
* The error-relative robust reduction, Proposition 3.1.
* The transfer of Matomaki--Merikoski's even-character full coefficient to
  the restricted common prime-log carrier, equations (21)--(22).
* The common-carrier hidden-character annihilation and major comparison,
  Theorem 5.1, conditional only on standard Siegel--Walfisz.

### Primary-source inherited, locally unformalized

* Pintz's common carrier, logarithmic major asymptotic, explicit-formula major
  lower bounds, and Section 5 mean-square argument.
* Bhowmik--Grimmelt's pointwise major formula and center-averaged minor bounds.
* Zhao's `7/10` exceptional-set theorem and fixed-modulus zero-mass estimate.
* Matomaki--Merikoski Theorem 1.4.

No unconditional Goldbach or all-center edge theorem is claimed.  No
numerical scan was performed.  No novelty claim is made for the circle method,
quadratic parity selectors, or Siegel--Walfisz.
