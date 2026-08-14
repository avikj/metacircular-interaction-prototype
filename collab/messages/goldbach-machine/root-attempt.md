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

For asymptotic rather than explicit use, `Pairfield.GoldbachChebyshevAdapter`
also consumes Mathlib's sharper existential theorem
`psi(N)-theta(N)<=C sqrt(N)` and checks

\[
C(N)\le C'\sqrt N\log N.
\]

The constant is not made explicit.  This sharpens the analytic scale but does
not supply a lower bound for `R_Lambda(N)`.

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

**Weaker exact edge target.**  A fixed fractional `eta` is more than Goldbach
needs.  If

\[
I_{\mathfrak M}(N)=\mathfrak S(N)N+E_{\mathfrak M}(N),
\]

then the strictly weaker sufficient condition is

\[
I_{\mathfrak m}(N)+\mathfrak S(N)N
>|E_{\mathfrak M}(N)|+4\sqrt N(\log N)^2.
\]

Using the source's displayed exponential major error, it is enough, for any
fixed `0<c'<c`, to prove

\[
I_{\mathfrak m}(N)
\ge-\mathfrak S(N)N+Ne^{-c'\sqrt{\log N}}.
\tag{H_edge}
\]

The margin is `o(N)` but still dominates both the major uncertainty and the
checked prime-power contamination.  Conversely, the fixed-margin `H_min` is,
up to a change of constant, equivalent to a uniform lower bound
`R_Lambda(N) >= kappa mathfrak S(N)N`; it would yield
`gg N/(log N)^2` ordered prime pairs at every center, substantially more than
nonemptiness.  The proof and exact boundary are in
[`direct-minor-shadow.md`](direct-minor-shadow.md).

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

The strictly weaker finite interface is now checked in
`Pairfield.UpwardEscape`.  From a spike `a(i_0)<=-depth` it charges only

\[
\sum_{i\in H}(a(i)-a(i_0))_+,
\]

leaving downward motion free.  If this is at most
`gamma * depth * |H|` with `gamma<1/2`, Lean proves that at least a
`1-2 gamma` proportion remains below `-depth/2`, together with the resulting
square-energy lower bound.  No arithmetic theorem presently supplies this
one-sided budget for the prime minor coefficients.

**Direction-reversal correction.**  That premise is logically weaker than a
uniform first-difference estimate, but it is not a plausible output of the
existing global norm.  The companion module
`Pairfield.UpwardEscapeNecessity` checks the converse pressure

\[
 \sum_{i\in H}(a(i)-a(i_0))_+
 \ge (depth-\varepsilon)
 \left(|H|-\frac{B}{\varepsilon^2}\right)
\]

whenever `a(i_0)<=-depth` and `sum_(i in H) a(i)^2<=B`, for
`0<epsilon<depth`.  In the analytic normalization `depth=cX`, substitute
`epsilon=epsilon_0 X`; the exceptional-cardinality term becomes
`B/(epsilon_0^2 X^2)`.  Thus, once `H` is larger than the spike budget, the
same `ell^2` estimate which was supposed to contradict persistence says that
most shifted coefficients are small and have escaped upward by almost the
full depth.

Before absolute values, total upward escape is exactly a supremum over all
selectors `0<=u_h<=1` of a prescribed-centre shifted minor-arc correlation.
It is already a conditioned signed theorem, not an ordinary dispersion norm.
The finite odd-character model in
[`upward-escape-duality-no-go.md`](upward-escape-duality-no-go.md) has one
order-scale negative convolution residual, `O(1)` residual elsewhere, and
square-root nontrivial Fourier marginals, yet violates every
`(UP_gamma)` budget with `gamma<1`.  The surviving arithmetic target is an
inverse theorem which recovers a conductor/packet-aligned shift family, or a
new conditioned correlation proving persistence on such a family.

**Weak inverse theorem, and its exact shortfall.**  Dirichlet partitioning of
the common minor arcs does recover one proof-relevant additive packet: an
order-`X` negative coefficient forces a cell with a comparable negative
phase-to-mass ratio, and its additive denominator `q` gives exact recurrence
on `q`-multiple shifts.  The certified packet window is smaller than Pintz's
order-`X` spike budget by logarithmic factors, and the complementary packets
remain uncontrolled.  The denominator is only an additive approximation
denominator; identifying it with a character conductor or a Type-II block is
unjustified.  A fixed nonnegative prime-supported signal can also use changing
hidden odd characters on disjoint prime annuli while preserving each selected
logarithmic-major response and producing infinitely many spikes.  Therefore
bare fixedness, nonnegativity, prime support, and major response do not force a
stable arithmetic mode.  The missing rigidity must use cross-scale coherence
specific to `vartheta`/`Lambda`; see
[`fixed-prime-packet-rigidity.md`](fixed-prime-packet-rigidity.md).

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
- **Bounded-denominator major semantics.**  A moving quadratic-character
  selector at a prime conductor just beyond the logarithmic arc cutoff is
  nonnegative and supported on actual primes, has the same declared major-arc
  coefficient up to `o(N)`, but has zero convolution at a chosen conductor
  multiple.  This is not the prime sequence and not a counterexample to
  Goldbach; it proves that major semantics, nonnegativity, and prime support
  alone cannot yield a fixed minor-arc margin.  A successful proof must exclude
  or couple the hidden character mode across targets.  For the actual
  prime-log weight and an odd quadratic character with conductor dividing the
  center, the two same-sector convolutions vanish and the entire coefficient
  is exactly one half of the mixed `(+,-)` sector convolution.  That prescribed
  mixed coefficient is the precise two-sided object which current
  Siegel--Walfisz and large-sieve marginals do not control from below.  It is
  also terminal: for every admissible odd conductor `r|N`, the mixed
  coefficient is exactly `2 R_vartheta(N)`, independent of `r`, so averaging
  over conductor divisors merely repeats Goldbach.  Zhao gives density one
  among such multiples uniformly for `r<=X^(3/10-delta)`, but still cannot
  select a prescribed multiple.  A second hidden character just beyond the
  logarithmic cutoff preserves both visible sector marginals and their major
  mixed response up to `o(N)` while annihilating the full mixed coefficient.
  This scopes the surviving target to a conductor-sensitive minor theorem for
  the fixed prime signal; see
  [`mixed-sector-prescribed-center.md`](mixed-sector-prescribed-center.md).
- **Exceptional-set bounds.**  Zhao's current
  [preprint, arXiv:2511.05631v2](https://arxiv.org/abs/2511.05631v2) proves
  `E(X)=O(X^(7/10))`, with ineffective constant.  A power saving still permits
  isolated exceptions.  Upgrading it would require a new failure-propagation
  law; short-interval success and prime-gap theorems have the opposite logical
  direction.
- **Odd exceptional-character remainder.**  At an even conductor multiple,
  Matomaki--Merikoski's main bracket is `1+chi(-1)`.  For odd `chi` it
  vanishes exactly and the theorem leaves only an unsigned upper error, not a
  positive next term.  Even when that error is relatively `o(1)`, it cannot
  produce a prime-pair witness; its published envelope also remains above the
  checked prime-power scale.  The exact surviving implication runs backward:
  assumed main-scale Goldbach mass excludes the specified odd exceptional
  zero.  See
  [`odd-siegel-conductor-multiple-no-go.md`](odd-siegel-conductor-multiple-no-go.md).
- **The historical Haskell executable.**  Its term language has no Goldbach
  proposition or command.  Adding a flag without a primality certificate path
  would only create an unverified side program.  The checked Lean search is the
  honest executable seam.

## 7. Most important next work

The next work is not a larger finite verification and not another quotient.
It is to retain and control the arithmetic mode which a prescribed bad center
would force:

1. for the shortest logarithmic route, stay on Pintz's common prime-log
   carrier and prove the direct edge margin `(H_edge)`, or prove an inverse
   theorem extracting a conductor/Type-II packet from a negative coefficient
   with dominance over complementary packets and enough recurrence to beat the
   spike budget.  The exact candidate is a conditioned, fixed-decomposition,
   scale-natural Vaughan inverse for the `Lambda=mu*log` tensor;
2. retain the resulting character/bilinear mode on both sides of the center
   and control the prescribed mixed coefficient, rather than replacing it by
   sector marginals or an unconditioned norm;
3. if a persistence route is attempted, choose its shift family from that
   recovered mode and prove the conditioned selector correlation explicitly;
   do not infer `(UP_gamma)` from the current `ell^2` or dispersion estimates;
4. for a power-cutoff alternative, formulate zero-mode positivity on one
   common carrier `(CZM)` and keep the raw minor and smoothed explicit-formula
   residual distinct;
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

Matomaki--Merikoski provide one genuine terminal slice beyond packet
coherence.  Under a sufficiently close zero of an **even** primitive
quadratic character, their full von-Mangoldt formula implies Goldbach for
sufficiently large even conductor multiples in their explicit scale range.
For an odd character the leading conductor-multiple bracket vanishes and no
positivity follows.  This is a conditional full-coefficient theorem, not a
route from one exception to propagation; the exact quantifiers are audited in
[`zero-mode-terminal-and-upward-escape.md`](zero-mode-terminal-and-upward-escape.md).

The sufficient power-cutoff interface is therefore the following three-part
contract, recorded precisely in `arithmetic-antispike.md`:

- `(TR)`: one-sided transport of a target-adapted negative minor coefficient
  to the frozen common-dyadic carrier;
- `(ZM)`: prescribed-center positivity of the main-plus-zero-mode major term;
- `(AC)`: a conditional signed covariance that spreads a large negative raw
  minor coefficient over more than the `X^(3/5) log^5 X` residual budget.

**Residual correction.**  `(AC)` can be logically replaced by `(UP_gamma)`,
a first-moment bound only on positive escape from the negative spike, and the
checked Markov implication is valid.  But `(UP_gamma)` is not an easier
consequence of the available estimates: selector duality makes it a maximal
conditioned correlation, while `Pairfield.UpwardEscapeNecessity` shows that
the global norm forces near-maximal escape on any family larger than its
spike budget.  It should be treated as an alternative statement of the
missing persistence theorem, not as a route derived from dispersion.

Current zero-density, Linnik, and dispersion estimates provide upper mass or
equidistribution statements, not these signed prescribed-center inequalities.
This three-part contract belongs specifically to the target-adapted
power-cutoff architecture.  A common-carrier power formulation would replace
`(ZM)+(TR)` by one common zero-mode positivity premise `(CZM)`; its remaining
residual contract is `(UP_gamma)`.  The logarithmic prime-log route needs
neither zero-mode premise nor transport, only the corresponding propagation
or a direct edge-margin theorem.

## Rigor and execution ledger

- **Lean checked:** bounded carrier; center support equivalences; complete
  single-center search; finite-range search and proof-relevant decoder;
  weighted support; exact contamination decomposition; fixed-antidiagonal
  contamination bounds; exception signature; finite-prefix/tail crossover;
  finite first-difference AntiSpike propagation.
  The one-sided Markov survivor and energy inequalities are checked in
  `Pairfield.UpwardEscape`; the converse `ell^2` pressure is checked in
  `Pairfield.UpwardEscapeNecessity`.
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
  (`9aff3cd8`), plus the weaker one-sided
  [`UpwardEscape`](../../../formal/pairfield/Pairfield/UpwardEscape.lean) and
  its converse-pressure audit
  [`UpwardEscapeNecessity`](../../../formal/pairfield/Pairfield/UpwardEscapeNecessity.lean).
  The analytic normalization and amplifier audits are
  [`analytic-uniformity.md`](analytic-uniformity.md) (`a853c995`) and
  [`pointwise-amplifier.md`](pointwise-amplifier.md) (`b7b66049`); the
  direct edge-margin and moving-character audit is
  [`direct-minor-shadow.md`](direct-minor-shadow.md); the sharpened common
  prime-log edge closure is
  [`common-prime-edge.md`](common-prime-edge.md); the
  prescribed mixed-sector closure is
  [`mixed-sector-prescribed-center.md`](mixed-sector-prescribed-center.md);
  the additive-packet inverse boundary is
  [`fixed-prime-packet-rigidity.md`](fixed-prime-packet-rigidity.md);
  the two-sided packet typing and continuation obstruction is
  [`packet-two-sided-middle.md`](packet-two-sided-middle.md), and the
  scale-natural `mu*log` coherence audit is
  [`lambda-cross-scale-coherence.md`](lambda-cross-scale-coherence.md);
  the
  arithmetic coherence audit is
  [`arithmetic-antispike.md`](arithmetic-antispike.md) (`61809c79`); the
  logarithmic common-carrier correction is
  [`common-carrier-elimination.md`](common-carrier-elimination.md); the
  conditional zero-mode and upward-escape audit is
  [`zero-mode-terminal-and-upward-escape.md`](zero-mode-terminal-and-upward-escape.md);
  the reversal/no-go is
  [`upward-escape-duality-no-go.md`](upward-escape-duality-no-go.md), and the
  odd exceptional-character closure is
  [`odd-siegel-conductor-multiple-no-go.md`](odd-siegel-conductor-multiple-no-go.md);
  the
  executable audit is [`execution-compiler.md`](execution-compiler.md)
  (`7a02f908`).
- **Open:** the pointwise edge margin `(H_edge)`, or an actual-prime inverse
  theorem extracting a conductor/Type-II packet together with a conditioned
  persistence estimate on its aligned shifts.
- **Not run:** no Python; no numerical census, scan, or large finite Goldbach
  evaluation; no unverified Haskell Goldbach command.
