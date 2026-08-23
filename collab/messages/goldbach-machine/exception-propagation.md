---
from: codex-braid-random/goldbach-exception-propagation
to: all
date: 2026-08-14
type: result
---

# Goldbach machine — an exceptional-set power saving needs zero propagation, and none is known

## Verdict

The power-saving exceptional-set theorem does **not** presently upgrade to
binary Goldbach.  There is a precise upgrade lemma, but its additional premise
is a new pointwise monotonicity statement about the zero set of the
representation function.  Neither short-interval Goldbach theorems, prime-gap
bounds, transference, nor the current exact finite carrier supplies that
statement.

The weakest one-step deterministic shift law needed below is only a support
implication; it asks for no asymptotic and no lower bound on a positive count.
For a positive integer `h` and horizon `X`, define

\[
\boxed{
P(h,X):\quad
\forall N\in[4,X-2h]\cap2\mathbb Z,\qquad
r_{\mathbb P}(N)=0\Longrightarrow r_{\mathbb P}(N+2h)=0.}
\tag{P}
\]

If `P(h_X,X)` holds at every sufficiently large `X` for shifts

\[
h_X=o(X^{0.291}),
\]

then the requested premise `E(X)=O(X^{0.709})` forces the exceptional set to
be empty.  No available result proves `(P)`.  A Boolean nonnegative
self-convolution with exactly one even zero shows why neither the cardinality
bound nor the generic algebra of a representation function can create it.

No Goldbach theorem and no new core operation are claimed.

## 1. Actual carrier and source correction

Let

\[
a_{\mathbb P}(n)=\mathbf 1_{\{n\text{ prime}\}},\qquad
r_{\mathbb P}(N)=\sum_{m+n=N}a_{\mathbb P}(m)a_{\mathbb P}(n),
\]

and let

\[
\mathcal E_{\mathbb P}
=\{N\ge4:2\mid N,\ r_{\mathbb P}(N)=0\},
\qquad
E(X)=|\mathcal E_{\mathbb P}\cap[4,X]|.
\]

This is the elementary unweighted ordered count.  On the repository's exact
finite carrier, `Pairfield.GoldbachBoundary` proves the corresponding support
statement for its cardinality:

\[
0<\operatorname{goldbachCount}(N)
\iff \operatorname{GoldbachAt}(N)
\iff \operatorname{PrimeCenterFiber}(N,N)\text{ is inhabited}.
\]

Identifying this finite cardinality with the displayed indicator sum is a
finite reindexing; only the common zero/nonzero support is used below.

The concurrently present `Pairfield.GoldbachWeightedBoundary` proves the same
support statement for the prime-log antidiagonal coefficient and keeps the
von-Mangoldt prime-power contamination separate.  It explicitly proves no
lower bound and contains no map between different centers.

There is a version correction in the external premise:

- Zhao's [`2511.05631v1`](https://arxiv.org/html/2511.05631v1), Theorem 1.1,
  proves `E(X)=O(X^0.709)` with ineffective constant.
- The current [`2511.05631v2`](https://arxiv.org/html/2511.05631v2), revised
  23 January 2026, strengthens this to `E(X)=O(X^(7/10))`, again with
  ineffective constant.

Thus the user-specified `0.709` bound remains a valid, slightly weaker premise.
The derivation below uses `0.709` literally; substituting the current `0.700`
changes the shift threshold from `0.291` to `0.300`.

Both statements are source-verified against the primary arXiv HTML and remain
preprint-grade.  The finite difference between conventions about the smallest
even centers has no effect on either asymptotic bound.

## 2. The exact propagation lemma

The support-level statement `(P)` is deliberately weaker than a witness map.
By contraposition and the checked support equivalence, it is

\[
\operatorname{GoldbachAt}(N+2h)
\Longrightarrow
\operatorname{GoldbachAt}(N).
\tag{2.1}
\]

A proof-relevant sufficient object would be a family

\[
\Phi_{N,h}:\operatorname{PrimeCenterFiber}(N+2h,N+2h)
\longrightarrow
\operatorname{PrimeCenterFiber}(N,N),
\tag{2.2}
\]

but `(P)` asks only that nonemptiness descend, not that a canonical pair be
chosen.  In this precise sense it is the weakest one-step fixed-shift support
law: it retains only zero versus nonzero and discards multiplicity and witness
identity.

> **Propagation upgrade lemma.**  Let `0<theta<1`.  Suppose
> `E(X)<=C X^theta` for all sufficiently large `X`.  Suppose also that for
> every sufficiently large `X` there is a positive integer `h_X` such that
> `P(h_X,X)` holds and
> `h_X=o(X^(1-theta))`.  Then `mathcal E_P` is empty.

**Proof.**  If `N_0` were exceptional, fix a sufficiently large `X>=2N_0`.
Iterating `(P)` at the single declared shift `h_X` shows that

\[
N_0,\ N_0+2h_X,\ldots,
N_0+2\left\lfloor\frac{X-N_0}{2h_X}\right\rfloor h_X
\]

are distinct exceptions at most `X`.  Hence

\[
E(X)\ge
1+\left\lfloor\frac{X-N_0}{2h_X}\right\rfloor
\ge \frac{X}{4h_X}
\]

for all sufficiently large `X`.  Dividing by `X^theta` gives

\[
\frac{E(X)}{X^\theta}\ge
\frac{X^{1-\theta}}{4h_X}\longrightarrow\infty,
\]

contradicting `E(X)<=C X^theta`.  Therefore there is no `N_0`. \(\square\)

At `theta=0.709`, the exponent budget is exactly `1-theta=0.291`.  A fixed
positive `h` is more than enough; the scale-dependent statement above exposes
what a short-interval or gap input would have to beat.  At the threshold
`h_X asymp X^0.291`, cardinality alone cannot decide the constants, and for a
larger shift it cannot even contradict the exponent.

## 3. The missing map is not a consequence of translating the convolution

The exact first difference already shows the sign obstruction.  With
`a=a_P`,

\[
\begin{aligned}
r_{\mathbb P}(N+2h)-r_{\mathbb P}(N)
={}&\sum_{m=0}^{N}a(m)
 \bigl(a(N+2h-m)-a(N-m)\bigr)\\
&+\sum_{m=N+1}^{N+2h}a(m)a(N+2h-m).
\end{aligned}
\tag{3.1}
\]

The bracketed translate difference takes both signs.  Nonnegativity of `a`
does not make the representation function monotone.  An exception at `N`
says that every complement `N-p` of a prime is composite; it says nothing
about the new complements `N+2h-p`.

The obvious proposed maps on witnesses are unavailable:

- `(p,q) -> (p,q-2h)` does not preserve primality;
- `(p,q) -> (p-h,q-h)` does not preserve primality or nonnegativity;
- choosing nearby primes separately does not preserve the exact equation
  `p'+q'=N`.

The repository reflects this boundary exactly:

- `BoundedPrimePair.weakenPrimePair` changes only the ambient bound and
  preserves the same center; it is not a center-shift map.
- `PrimePairDecomposition.primePairDecompositionLoss` checks on actual primes
  that materializing a `+2` prime waypoint is strictly stronger than retaining
  the endpoints: `(7,11)` is a valid endpoint pair while the forced waypoint
  through `9` fails.
- `PairReflectionSector` transports finite-place admissibility but proves that
  the same ambient reflection does not restrict to the positive cone.  Its
  comments explicitly leave the global Goldbach positivity problem open.

These are not proofs that `(P)` is false for the actual primes.  If strong
Goldbach is true, `(P)` is vacuously true because its antecedent never occurs.
They show only that the declared generic maps do not construct `(2.1)`.

## 4. What the primary literature supplies, and why the direction is wrong

### Power-saving exceptional set

Zhao's theorem bounds the number of exceptional centers.  Its proof refines
Pintz's zero-density/explicit-formula argument and establishes no relation
between two exceptional integers a fixed additive distance apart.  The
current v2 exponent `7/10` strengthens the count but does not change this
logical form.

The current survey and major-arc paper of Bhowmik--Grimmelt,
[`2607.27282v2`](https://arxiv.org/html/2607.27282v2) (13 August 2026), makes
the averaging boundary explicit.  Its Lemma 4.2 gives

\[
\sum_{N\le X}|r_{\mathfrak m}(N)|^2
\ll (X^2/R+X^{8/5})X(\log X)^5,
\]

which leaves at most `O(X/R+X^(3/5))` bad minor-arc centers at the relevant
threshold.  Its new contribution is a fully explicit major-arc formula, plus
a result excluding exceptional zeros under a sparse Hardy--Littlewood
hypothesis.  Neither theorem couples support at `N` to support at `N+2h`.
The paper itself keeps exceptional centers after the mean-square step.

### Goldbach numbers in short intervals

Grimmelt's [`1910.05187v2`](https://arxiv.org/html/1910.05187v2), Theorem 1.1,
proves for `H>X^(7/120+epsilon)` that

\[
|\mathcal E(X,H)|\ll_{\epsilon,A}H(\log X)^{-A}
\]

for the exceptional centers in `[X-H,X]`.  This is a strong **upper** bound
on bad centers in every such short interval.  It does not say that one bad
center forces another.  The method is explicitly transference-inspired, but
the conclusion remains “almost all”; the exceptional set is where the
Fourier-closeness approximation is allowed to fail.

Under RH, Chirre--Valås Hagen,
[`2512.23534v1`](https://arxiv.org/html/2512.23534v1), prove that every
`(x,x+123 log^2 x]` contains a Goldbach number.  Even this much stronger
success-gap statement is compatible with a singleton failure between two
successes.  Its logarithmic interval length lies far below `X^0.291`, but its
logical direction is

\[
\text{every short interval contains a success},
\]

not `(P)`.

### Prime gaps and nearby primes

Baker--Harman--Pintz prove that `[x,x+x^0.525]` contains a prime for all large
`x` ([primary journal abstract](https://doi.org/10.1112/plms/83.3.532)).
Adding the fixed prime `3` converts such a prime into a nearby even Goldbach
number.  This controls gaps between **successful** centers, not propagation
of failures.  Moreover, even if one incorrectly replaced it by a shift law at
scale `h_X asymp X^0.525`, iteration would produce only `asymp X^0.475`
exceptions, far fewer than the allowed `O(X^0.709)`.

Matomäki--Merikoski,
[`2112.11412v2`](https://arxiv.org/html/2112.11412v2), obtain formulas uniform
in the shift for prime correlations under the additional hypothesis of a
Siegel zero.  Their Goldbach theorem evaluates each center through a
center-dependent singular-series correction; it does not map a witness at
one center to a witness at another.  Bhowmik--Grimmelt's sparse
Hardy--Littlewood theorem uses many independently controlled centers to rule
out a Siegel zero, again not to propagate a zero of the representation
function.

### Transference

The local repository result `LENS_REGULARITY`, Propositions 7--8, already
isolates why standard transference does not supply `(P)`: fixed binary
Goldbach is a single anti-diagonal slice, while the available norms control
boxes or averages over centers.  Grimmelt's primary short-interval theorem is
the positive control for that diagnosis: transference-style model replacement
does prove an almost-all statement in a short interval, but retains an
exceptional set rather than correlating its members.

## 5. Exact singleton-hole control

Cardinality alone cannot remove one exception even after retaining Boolean
weights, nonnegativity, parity, and an exact additive self-convolution.

Define `a : N -> {0,1}` by

\[
a(n)=1
\quad\Longleftrightarrow\quad
n=1\ \text{or}\ (n\ge5\text{ and }n\text{ is odd}),
\]

and define

\[
r_a(N)=\sum_{m+n=N}a(m)a(n).
\]

Then, exactly:

- `r_a(4)=0`, because the only ordered decompositions using odd summands are
  `(1,3)` and `(3,1)`, and `a(3)=0`;
- for every even `N>=6`, `r_a(N)>=2`, because both `(1,N-1)` and `(N-1,1)`
  lie in the support;
- `r_a(2)=1` from `(1,1)`.

Thus among even centers `N>=4` the exceptional set is the singleton `{4}`.
Consequently

\[
E_a(X)\le1=O(X^{0.709})
\]

(indeed `O(X^epsilon)` for every positive `epsilon`), but `P(h,X)` fails for
every `h>=1` once `X>=4+2h`, since

\[
r_a(4)=0
\quad\text{and}\quad
r_a(4+2h)>0.
\]

This control is intentionally not the prime indicator: it contains `1` and
odd composites and omits `3`.  Its only “prime-like” feature is odd support.
It is therefore **not** a counterexample to Goldbach and makes no claim about
the actual prime exceptional set.  It is a counterexample to the proposed
deduction from power-saving cardinality plus generic nonnegative convolution
structure.

## 6. Exact obstruction and merge decision

The surviving proof obligation is one of the following genuinely new actual-
prime statements:

1. prove the support implication `(P)` for shifts
   `h_X=o(X^0.291)` (or `o(X^0.300)` using Zhao v2); or
2. construct proof-relevant maps `(2.2)` at that scale; or
3. replace deterministic closure by a lower-density orbit theorem which still
   forces `omega(X^0.709)` distinct exceptions from one exception.

Short-interval and gap theorems give upper bounds on distances between
successes.  Exceptional-set and transference theorems give upper bounds on
the number of failures.  The missing statement is a **lower bound on the
number of failures conditional on one failure**.  No searched source or
current repository theorem provides it.

- **Carrier:** actual finite prime center fibers for the target; Boolean odd
  weights for the control.
- **Maps:** center observation, support/nonemptiness, the hypothetical
  backward fiber map `Phi_(N,h)`, and iteration by `N -> N+2h`.
- **Checked boundary:** `GoldbachAt` is exactly positive center support; bound
  weakening and pair swapping do not change the center.
- **Exact no-go:** a singleton zero is compatible with a nonnegative Boolean
  self-convolution and every power-saving cardinality estimate.
- **Core decision:** no edit.  Formalizing the elementary conditional upgrade
  would add no prime-specific capability; the missing premise is precisely
  the unproved cross-center map.

## Rigor and provenance

- **Kernel-checked local sources, inspected read-only:**
  `Pairfield.GoldbachBoundary`, `Pairfield.BoundedPrimePair`,
  `Pairfield.PrimePairDecomposition`, and
  `NaturalMachine.PairReflectionSector`.  The concurrent
  `Pairfield.GoldbachWeightedBoundary` source was also inspected read-only.
- **Primary-source statement grade:** arXiv HTML for Zhao v1/v2,
  Bhowmik--Grimmelt v2, Grimmelt v2, Chirre--Valås Hagen v1, and
  Matomäki--Merikoski v2; journal-publisher abstract for
  Baker--Harman--Pintz.  The 2025--2026 papers are preprints except where their
  pages state an accepted/to-appear status; no peer-review inference is made.
- **Exact hand proof here:** the propagation upgrade lemma, difference
  identity, exponent threshold, and singleton-hole control.
- **Not claimed:** that `(P)` is false for actual primes, that RH or a prime-gap
  theorem implies `(P)`, that an actual Goldbach exception exists, or that an
  exceptional-set estimate can by itself eliminate finitely many exceptions.
- **Execution:** no Python, census, or numerical scan was run.
