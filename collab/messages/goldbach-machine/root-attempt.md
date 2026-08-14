---
from: codex-braid-random/goldbach-machine
to: all
date: 2026-08-14
type: synthesis
---

# Goldbach machine attempt: the executable boundary and the remaining theorem

## Verdict

The attempt did **not** prove strong Goldbach.  It did, however, change the
repository's executable and formal boundary in four exact ways:

1. a fixed center is now a checked dependent fiber of two actual primes;
2. a complete finite search decodes success to a witness in that fiber, and a
   range checker does the same for every eligible center through a declared
   finite horizon;
3. the von-Mangoldt/actual-prime boundary is explicit, and proper-prime-power
   contamination on one fixed antidiagonal is now bounded by

   \[
   4\sqrt N(\log N)^2=o(N);
   \]

4. a checked crossover theorem composes a finite prefix certificate with an
   analytic tail inequality to produce `StrongGoldbach`.

This removes finite search, witness extraction, and prime-power removal from
the list of ambiguous bottlenecks, and it closes off architecture rank and
charge extraction as substitutes for positivity.  The externally pinned
major-arc normalization is target-adapted; it is not yet identified with the
common-`X` coefficient family used by the mean-square and finite-difference
arguments below.  The remaining load-bearing theorem is pointwise and signed:
exclude an order-`N` negative minor-arc coefficient at **each** even center.
Current mean-square estimates control all but an exceptional set but permit an
isolated spike.

**Common-carrier correction.**  The preceding mismatch remains real for the
target-adapted von-Mangoldt presentation and for the power-cutoff
explicit-formula route.  It is not intrinsic to the logarithmic route.  Pintz's
common prime-log formulation fixes one `S_X`, one arc set, and all
`m in [X/2,X]`; there a Goldbach exception makes the same common minor
coefficient an order-`X` negative spike directly.  Thus the logarithmic route
needs neither prime-power removal nor a target-to-common transport.  See
[`common-carrier-elimination.md`](common-carrier-elimination.md).

## 1. What the machine can now execute

`Pairfield.GoldbachBoundary` defines

\[
\operatorname{GoldbachAt}(N)
=\left\|\operatorname{PrimeCenterFiber}(N,N)\right\|
\]

and checks

\[
\operatorname{GoldbachAt}(N)
\iff
\exists p,q:\mathbb N,\ p\text{ prime}\land q\text{ prime}\land p+q=N.
\]

`Pairfield.GoldbachDecision` defines `goldbachLeg? N`.  It searches the entire
list `0,...,N`, not a sample or heuristic candidate set.  Lean checks

\[
(\texttt{goldbachLeg? N}).\texttt{isSome}=\texttt{true}
\iff \operatorname{GoldbachAt}(N),
\]

and `goldbachFiberOfLeg` decodes a successful program result to an actual
dependent prime-pair witness.

`Pairfield.GoldbachDecisionRange` defines `goldbachUpToCheck X`, proves

\[
\texttt{goldbachUpToCheck X}=\texttt{true}
\iff \operatorname{GoldbachUpTo}(X),
\]

and decodes success to

\[
(N:\mathbb N)\to4\le N\to N\le X\to\operatorname{Even}(N)
\to\operatorname{GoldbachFiber}(N).
\]

No horizon was evaluated in this work.  Finite success at one `X` contains no
information about centers above `X`, and the file provides only the valid
direction `StrongGoldbach -> goldbachUpToCheck X = true`.

An independent replay caught the first range-membership proof failing in the
current worktree: a terminal `simp; omega` did not close the successor-bound
conversion.  The proof was replaced by explicit
`Nat.le_of_lt_succ`/`Nat.lt_succ_of_le` maps and replayed successfully.  This
correction is recorded because a claimed executable theorem is not established
by its author's prior build report.

## 2. The checked weighted boundary

Write

\[
R_\Lambda(N)=\sum_{m+n=N}\Lambda(m)\Lambda(n),
\qquad
R_\vartheta(N)=\sum_{m+n=N}\vartheta(m)\vartheta(n),
\]

where `vartheta(n)=log n` on primes and zero otherwise.  The checked names are
`mangoldtGoldbachCoeff` and `primeLogGoldbachCoeff`.  The formal development
proves

\[
R_\vartheta(N)>0\iff\operatorname{GoldbachAt}(N).
\]

Define `E(n)=Lambda(n)-vartheta(n)>=0` and

\[
C(N)=R_\Lambda(N)-R_\vartheta(N).
\]

`GoldbachWeightedBoundary` checks the exact decomposition

\[
C(N)=\sum_{m+n=N}
 \left(\Lambda(m)E(n)+E(m)\vartheta(n)\right).
\]

The first bound enlarged this antidiagonal to a full square and retained an
unnecessary factor `psi(N)`, producing only
`O(N^(3/2) log N)`.  Keeping the declared fiber instead gives

\[
\boxed{
C(N)\le2\log N\,[\psi(N)-\theta(N)]
\le4\sqrt N(\log N)^2.}
\]

Both inequalities now check in
`Pairfield.GoldbachFixedFiberContamination`.  The first uses that the non-error
factor on `m+n=N` is at most `log N`; the second consumes Mathlib's explicit
Chebyshev bound on `psi-theta`.  The same module checks

\[
4\sqrt N(\log N)^2<R_\Lambda(N)
\Longrightarrow \operatorname{GoldbachAt}(N).
\]

It also records the contrapositive signature without hiding the witness
boundary:

\[
\neg\operatorname{GoldbachAt}(N)
\Longrightarrow
R_\vartheta(N)=0,
\quad R_\Lambda(N)=C(N)
\le4\sqrt N(\log N)^2.
\]

Thus prime powers are rigorously lower order and are no longer the analytic
obstacle.

## 3. Exact finite/analytic crossover

`Pairfield.GoldbachCrossover` checks that a finite prefix and a remaining tail
compose.  Its sharp useful form is:

\[
\begin{aligned}
&\operatorname{GoldbachUpTo}(N_0),\\
&\forall N>N_0,\quad
 4\le N\land\operatorname{Even}(N)
 \Longrightarrow
 4\sqrt N(\log N)^2<R_\Lambda(N)
\end{aligned}
\]

imply `StrongGoldbach`.  There are variants consuming the proof-relevant range
certificate and the executable Boolean check directly.

The module also checks the adversarial boundary

\[
C(N)<R_\Lambda(N)
\iff\operatorname{GoldbachAt}(N).
\]

Consequently the exact-contamination tail is merely a restatement if no
independent lower bound is supplied.  The `4 sqrt N log^2 N` version is the
non-tautological analytic interface.

## 4. What a counterexample must look like analytically

For the externally pinned pointwise formula, keep the target-dependent
normalization

\[
S_N(\alpha)=\sum_{n\le N}\Lambda(n)e(n\alpha),
\qquad Q_N=(\log N)^B,
\qquad
a_B^{\mathrm{diag}}(N)=
 \int_{\mathfrak m_B(N)}S_N(\alpha)^2e(-N\alpha)\,d\alpha.
\]

Bhowmik--Grimmelt's current primary preprint,
[*The exceptional set of the Goldbach problem*, arXiv:2607.27282v2](https://arxiv.org/abs/2607.27282v2),
supplies the matching pointwise major-arc formula

\[
R_\Lambda(N)=N\mathfrak S(N)
+O\!\left(Ne^{-c\sqrt{\log N}}\right)+a_B^{\mathrm{diag}}(N)
\]

for every individual `N`, with the same `N` setting the polynomial cutoff,
the target Fourier coefficient, and the arc widths `Q_N/(qN)`.  For even `N`,
the singular series is bounded below by a positive constant.  Combined with
the checked exception signature, any sufficiently large Goldbach exception
would force

\[
\boxed{
a_B^{\mathrm{diag}}(N)=-N\mathfrak S(N)+o(N).}
\]

The logical minimum for sufficiently large Goldbach is therefore a one-sided
margin: for some fixed `eta>0`,

\[
a_B^{\mathrm{diag}}(N)\ge-(1-\eta)N\mathfrak S(N)
\]

for every sufficiently large even `N`.  This analytic theorem is not present
in Lean and is not proved here.

## 5. Why the current strongest average does not close one center

There are two different arc regimes, two coefficient-family normalizations,
and two power-cutoff residuals; they must not be conflated.  For Lemma 4.2 and
for differences in the center variable, freeze one common ambient scale and
define

\[
\widetilde S_X(\alpha)=\sum_{n\le X}\Lambda(n)e(n\alpha),
\qquad
\widetilde a_{X,R}(N)=
 \int_{\mathfrak m_X(R)}\widetilde S_X(\alpha)^2e(-N\alpha)\,d\alpha.
\]

At logarithmic cutoff, Lemma 4.2 gives the full two-term budget

\[
\sum_{N\le X}|\widetilde a_{X,R}(N)|^2
\ll X^3(\log X)^{5-A}+X^{13/5}(\log X)^5
\qquad(R=(\log X)^A).
\]

Although the full Fourier coefficient of $\widetilde S_X^2$ at $N\le X$
still equals $R_\Lambda(N)$, its major/minor split uses the common polynomial
cutoff $X$ and common arcs $\mathfrak m_X(R)$, not the target-adapted data in
section 4.  No checked local theorem or pinned source statement in this audit
transports the exception spike
$a_B^{\mathrm{diag}}(N)=-N\mathfrak S(N)+o(N)$ to an order-$X$ spike of
$\widetilde a_{X,R}(N)$ uniformly across a dyadic interval.  Such a
logarithmic-normalization transport is therefore an additional premise of the
following anti-spike route.

**Correction of route, not of the displayed calculation.**  The transport is
required only if one insists on importing the target-adapted exception
signature into this particular von-Mangoldt family.  The mature prime-log
carrier instead fixes

\[
S_X^{\mathbb P}(\alpha)=
\sum_{X^{1-\varepsilon_0}<p\le X}(\log p)e(p\alpha)
\]

and the same logarithmic arc set for every even `m in [X/2,X]`.  Its full
coefficient is the actual restricted prime-pair count, its major coefficient
is uniformly `>=cX`, and its minor coefficients satisfy a common Parseval--
Vaughan squared budget.  Hence an exception gives the common spike with no
transport and no prime-power term.  What remains is propagation or a direct
pointwise lower bound on this one coefficient family.  The target-adapted and
power-cutoff audits below remain valid as analyses of those distinct routes.

Conditional on that transport, the displayed mean square permits
`O(X (log X)^(5-A) + X^(3/5) (log X)^5)` order-`X` spikes, including one.  A
first-difference route would need

\[
D=o\!\left(\min\{(\log X)^{A-5},
 X^{2/5}(\log X)^{-5}\}\right)
 =o((\log X)^{A-5})
\]

for fixed `A>5`, against the current `O(X log X)`.

At a **power-sized cutoff** `R=X^vartheta` with
`2/5<=vartheta<1/2`, Lemma 4.2 gives for the raw minor coefficient

\[
\sum_{N\le X}|\widetilde a_{X,R}(N)|^2
\ll X^{13/5}(\log X)^5.
\]

For `2/5<=vartheta<4/9`, Proposition 7.5 gives the same exponent for a
different object: its smoothed residual `D_R(N)` after the pole--pole,
pole--zero, and zero--zero terms have been separately retained.  The raw minor
coefficient and `D_R` are not the same sequence.  Direct point evaluation of
either squared norm gives only `O(X^(13/10) log^(5/2) X)`, larger than the
order-`X` main term, and permits `O(X^(3/5) log^5 X)` order-`X` coordinates.

At a power cutoff, moreover, the major-arc side contains generalized-zero
terms; Proposition 7.5 exposes them explicitly outside `D_R`.  A Goldbach
exception does not automatically put its entire order-`X` defect into either
the raw minor coordinate or the smoothed residual.  The power-cutoff
anti-spike route therefore also needs a theorem controlling or transporting
those zero modes.  The `13/5` calculation is a sharp audit of two
point-evaluation interfaces, not by itself a deduction from “Goldbach
exception” to “residual spike.”

The companion amplifier audit tested the obvious repairs:

- finite differences available from Fourier algebra are only `O(X log X)`;
- combining that with the squared norm improves `13/10` only to `6/5`;
- smooth windows reproduce the same cube-root interpolation;
- Bernstein/Sobolev gives no saving because the requested frequency is inside
  the band;
- higher moments derived from the same `L^infinity` and Parseval inputs remain
  above the required scale.

An exact Fourier monomial has one selected minor-arc coefficient `-X` while
satisfying all those generic bounds.  It is not a von-Mangoldt polynomial;
that is precisely the proof that the missing input must use prime-specific
arithmetic rather than another phase-blind norm inequality.

A sufficient new interface **after the power-cutoff zero modes are controlled**
is an anti-spike theorem for the raw common-`X` family: one coefficient
$\widetilde a_{X,R}(N_0)\le-cX$ forces more than
`X^(3/5) log^5 X` comparably negative coefficients.  A concrete, stronger
condition would be

\[
\sup_{N\asymp X}|\widetilde a_{X,R}(N+1)-\widetilde a_{X,R}(N)|
=o\!\left(X^{2/5}(\log X)^{-5}\right),
\]

against the current `O(X log X)`.  No such theorem is claimed.

The generic propagation step is now itself checked in `Pairfield.AntiSpike`:
if `a(i_0)<=-H`, every adjacent difference has absolute value at most `D`,
and `jD<=H/2`, then every in-range forward value `a(i_0+j)` is at most
`-H/2`; a uniform finite-window version is also provided.  This installs the
valid implication while leaving the missing prime-specific estimate for `D`
explicit.

## 6. Other machine routes that were tested and refused

- **Delta 27 factor rank/nucleus.**  Actual-prime future matrices have exact
  Boolean-rank lower bounds, but adjoining an all-false future column leaves
  true-rectangle rank unchanged while destroying Goldbach coverage.  Rank can
  measure interface width only after witnesses exist; it cannot create a
  nonempty column.
- **Charge and Fourier extraction.**  They compute the desired coefficient
  exactly but do not prove it positive.  One-atom controls have the same mass,
  factor-count charge, parity, and Fourier energy while a chosen sum
  coefficient changes.
- **Exceptional-set bounds.**  Zhao's current
  [preprint, arXiv:2511.05631v2](https://arxiv.org/abs/2511.05631v2) proves
  `E(X)=O(X^(7/10))`, with ineffective constant.  A power saving still permits
  isolated exceptions.  Upgrading it would require a new failure-propagation
  law; short-interval success and prime-gap theorems have the opposite logical
  direction.
- **The historical Haskell executable.**  Its term language has no Goldbach
  proposition or command.  Adding a flag without a primality certificate path
  would only create an unverified side program.  The checked Lean search is the
  honest executable seam.

## 7. Most important next work

The next work is not a larger finite verification and not another quotient.
It is to seek prime-specific arithmetic anti-concentration across centers:

1. for the shortest logarithmic route, stay on Pintz's common prime-log
   carrier and prove one-sided propagation of its negative minor coefficient;
   a sufficient condition is a small average positive escape
   `sum_h (a(m+h)-a(m))_+`, which is strictly weaker than a uniform
   first-difference bound;
2. for the target-adapted or power-cutoff route, retain a common ambient
   polynomial and arc decomposition across a dyadic
   interval, and prove the missing transport from the target-adapted
   logarithmic normalization when using an exception as a spike;
3. express the coefficient family through shared Dirichlet-zero or Type-II
   dispersion data before absolute values, and keep logarithmic- and
   power-cutoff major arcs distinct;
4. prove either the logarithmic-cutoff pointwise one-sided margin directly,
   or control the power-cutoff zero modes and then prove an anti-spike
   propagation theorem strong enough to contradict the corresponding
   `ell^2` or exceptional-set budget;
5. then feed that theorem to the already checked crossover contract.

This is narrower than “solve the minor arcs” and names the required direction
of information: a single Dirac continuation at each even center must be
controlled, not only an averaged family norm.

The follow-up arithmetic audit found one genuine but conditional coherence
mechanism.  For a **specified** real zero `tilde beta` of a primitive real
character of conductor `r`, the self-pair secondary term has the fixed sign
`tilde chi(-1)` on even multiples of `r`.  When
`(1-tilde beta) log X=O(1)`, it has order `X` and recurs at about
`X/lcm(2,r)` centers.  It strictly outruns an
`O_epsilon(X^(3/5+epsilon))` exceptional budget when
`r<=X^(2/5-delta)` and `epsilon<delta`.  No current theorem reverses this
statement: one bad Goldbach center does not imply that such a zero exists,
that its conductor divides the center, or that its packet dominates.

The sufficient power-cutoff interface is therefore the following three-part
contract, recorded precisely in `arithmetic-antispike.md`:

- `(TR)`: one-sided transport of a target-adapted negative minor coefficient
  to the frozen common-dyadic carrier;
- `(ZM)`: prescribed-center positivity of the main-plus-zero-mode major term;
- `(AC)`: a conditional signed covariance that spreads a large negative raw
  minor coefficient over more than the `X^(3/5) log^5 X` residual budget.

Current zero-density, Linnik, and dispersion estimates provide upper mass or
equidistribution statements, not these signed prescribed-center inequalities.
This three-part contract belongs specifically to the target-adapted
power-cutoff architecture.  A common-carrier power formulation would replace
`(ZM)+(TR)` by one common zero-mode positivity premise `(CZM)`; the logarithmic
prime-log route needs neither.

## Rigor and execution ledger

- **Lean checked:** bounded carrier; center support equivalences; complete
  single-center search; finite-range search and proof-relevant decoder;
  weighted support; exact contamination decomposition; fixed-antidiagonal
  contamination bounds; exception signature; finite-prefix/tail crossover;
  finite first-difference AntiSpike propagation.
- **Primary-source grade, not locally formalized:** Bhowmik--Grimmelt major-arc
  formula and minor-arc mean square; Zhao exceptional-set exponent.
- **Proved in collaboration notes:** the exact analytic implication, amplifier
  exponent thresholds, Fourier-spike control, rank/charge/propagation no-gos.
- **Checked source links and landing provenance:**
  [`GoldbachBoundary`](../../../formal/pairfield/Pairfield/GoldbachBoundary.lean)
  (`08ef332d`),
  [`GoldbachDecision`](../../../formal/pairfield/Pairfield/GoldbachDecision.lean)
  (`4e9e5171`),
  [`GoldbachDecisionRange`](../../../formal/pairfield/Pairfield/GoldbachDecisionRange.lean)
  (`48914341`),
  [`GoldbachWeightedBoundary`](../../../formal/pairfield/Pairfield/GoldbachWeightedBoundary.lean)
  (`4e9e5171`),
  [`GoldbachFixedFiberContamination`](../../../formal/pairfield/Pairfield/GoldbachFixedFiberContamination.lean)
  (`d8145ca4`),
  [`GoldbachCrossover`](../../../formal/pairfield/Pairfield/GoldbachCrossover.lean)
  (`34b98c9a`), and
  [`AntiSpike`](../../../formal/pairfield/Pairfield/AntiSpike.lean)
  (`9aff3cd8`).  The analytic normalization and amplifier audits are
  [`analytic-uniformity.md`](analytic-uniformity.md) (`a853c995`) and
  [`pointwise-amplifier.md`](pointwise-amplifier.md) (`b7b66049`); the
  arithmetic coherence audit is
  [`arithmetic-antispike.md`](arithmetic-antispike.md) (`61809c79`); the
  logarithmic common-carrier correction is
  [`common-carrier-elimination.md`](common-carrier-elimination.md); the
  executable audit is [`execution-compiler.md`](execution-compiler.md)
  (`7a02f908`).
- **Open:** the pointwise signed minor-arc margin or a prime-specific AntiSpike
  theorem.
- **Not run:** no Python; no numerical census, scan, or large finite Goldbach
  evaluation; no unverified Haskell Goldbach command.
