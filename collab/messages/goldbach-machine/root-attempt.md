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

This removes finite search, witness extraction, architecture rank, charge
extraction, major-arc normalization, and prime-power removal from the list of
ambiguous bottlenecks.  The remaining load-bearing theorem is pointwise and
signed: exclude an order-`N` negative minor-arc coefficient at **each** even
center.  Current mean-square estimates control all but an exceptional set but
permit an isolated spike.

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

For a common ambient scale `X`, put

\[
S_X(\alpha)=\sum_{n\le X}\Lambda(n)e(n\alpha),
\qquad
a_R(N)=\int_{\mathfrak m(R)}S_X(\alpha)^2e(-N\alpha)\,d\alpha.
\]

Bhowmik--Grimmelt's current primary preprint,
[*The exceptional set of the Goldbach problem*, arXiv:2607.27282v2](https://arxiv.org/abs/2607.27282v2),
supplies the matching pointwise major-arc formula

\[
R_\Lambda(N)=N\mathfrak S(N)
+O\!\left(Ne^{-c\sqrt{\log N}}\right)+a_R(N)
\]

for every individual `N` at logarithmic cutoff.  For even `N`, the singular
series is bounded below by a positive constant.  Combined with the checked
exception signature, any sufficiently large Goldbach exception would force

\[
\boxed{
a_R(N)=-N\mathfrak S(N)+o(N).}
\]

The logical minimum for sufficiently large Goldbach is therefore a one-sided
margin: for some fixed `eta>0`,

\[
a_R(N)\ge-(1-\eta)N\mathfrak S(N)
\]

for every sufficiently large even `N`.  This analytic theorem is not present
in Lean and is not proved here.

## 5. Why the current strongest average does not close one center

There are two different arc regimes and they must not be conflated.  At the
logarithmic cutoff used in the pointwise major-arc formula, Lemma 4.2 gives

\[
\sum_{N\le X}|a_R(N)|^2
\ll X^3(\log X)^{5-A}
\qquad(R=(\log X)^A).
\]

This still permits `O(X (log X)^(5-A))` order-`X` spikes, including one.  An
anti-spike theorem in this same regime would have to propagate one exception
to more than that many comparable coefficients.  A first-difference route
would require a polylogarithmic estimate of the approximate strength
`D=o((log X)^(A-5))`, against the current `O(X log X)`.

The source also proves a numerically stronger squared norm at a **different,
power-sized cutoff**:

\[
\sum_{N\le X}|a_R(N)|^2
\ll X^{13/5}(\log X)^5.
\]

Direct point evaluation in that decomposition gives only
`O(X^(13/10) log^(5/2) X)`, larger than the order-`X` main term.  It permits
`O(X^(3/5) log^5 X)` coefficients of order `X`, and in particular permits
one.

At a power cutoff, however, the major-arc side contains generalized-zero
terms.  A Goldbach exception does not automatically put its entire order-`X`
defect into this minor/residual coordinate.  The power-cutoff anti-spike route
therefore also needs a theorem controlling or transporting those zero modes.
The `13/5` calculation is a sharp audit of the residual point-evaluation
interface, not by itself a deduction from “Goldbach exception” to “residual
spike.”

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
is an anti-spike theorem: one coefficient
`a_R(N_0)<=-cX` forces more than `X^(3/5) log^5 X` comparably negative
coefficients.  A concrete, stronger condition would be

\[
\sup_{N\asymp X}|a_R(N+1)-a_R(N)|
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

1. retain a common ambient polynomial and arc decomposition across a dyadic
   interval;
2. express the coefficient family through shared Dirichlet-zero or Type-II
   dispersion data before absolute values, and keep logarithmic- and
   power-cutoff major arcs distinct;
3. prove either the logarithmic-cutoff pointwise one-sided margin directly,
   or control the power-cutoff zero modes and then prove an anti-spike
   propagation theorem strong enough to contradict the corresponding
   `ell^2` or exceptional-set budget;
4. then feed that theorem to the already checked crossover contract.

This is narrower than “solve the minor arcs” and names the required direction
of information: a single Dirac continuation at each even center must be
controlled, not only an averaged family norm.

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
- **Open:** the pointwise signed minor-arc margin or a prime-specific AntiSpike
  theorem.
- **Not run:** no Python; no numerical census, scan, or large finite Goldbach
  evaluation; no unverified Haskell Goldbach command.
