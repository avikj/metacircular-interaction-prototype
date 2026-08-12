# Least-factor reflection transport on a Goldbach fiber

**Status.** Exact finite construction and a no-go theorem for a proposed
entropy/Hall route.  No numerical evidence is used.  The construction locates
a real noncommutation, but also proves that scalarizing its stopping-time
filtration to one-fiber masses cannot force a Goldbach representation.

## 1. Reflection followed by multiplicative stopping

Fix an even integer `N >= 6` and write

\[
  \tau_N(a)=N-a \qquad (1\leq a<N).
\]

For `x >= 2`, let `P^-(x)` denote its least prime factor.  For a prime `q`,
let `E_q` be multiplication by the indicator of `P^-(x)=q`.  Reflection and
the least-factor projections do not commute:

\[
 [E_q,R_N]f(a)
 =\bigl(1_{P^-(a)=q}-1_{P^-(N-a)=q}\bigr)f(N-a),             \tag{1.1}
\]

where `(R_N f)(a)=f(N-a)`.  This is not the zero coefficient commutator of a
fixed charge grading.  The stopping label is taken *after* additive
reflection, so it depends on the opposite endpoint.

The noncommutation is completely general, however; (1.1) alone contains no
prime rigidity.  Its useful arithmetic specialization is the following exact
partition.

**Proposition 1 (exceptional-fiber partition).** Suppose `N` is not a sum of
two primes.  Apart from a possible endpoint `p=N-1`, every prime `p<N` belongs
to exactly one set

\[
 \mathcal P_q(N)=
 \{p<N-1:p\text{ prime},\ P^-(N-p)=q\},                    \tag{1.2}
\]

where `q <= sqrt(N-p) < sqrt(N)`.  Equivalently its reflected endpoint has a
unique representation

\[
  N-p=qm,\qquad q\leq m,\qquad P^-(m)\geq q.               \tag{1.3}
\]

In particular, `p = N (mod q)`, while for every prime `r<q` one has
`p != N (mod r)`.

**Proof.** Under the hypothesis, `N-p` is not prime.  If `p<N-1`, then
`N-p>=2`, hence it is composite.  Its least prime factor `q` is unique and no
larger than its square root.  On writing `N-p=qm`, minimality gives
`P^-(m)>=q`, and all congruences follow.  The case `N-p=1` is precisely the
listed endpoint.  Conversely (1.3) determines the least-factor label. $\square$

Thus a hypothetical exception transports every prime into a disjoint family
of sifted residue fibers.  This is the familiar least-prime-factor/Buchstab
stopping rule in an oriented reflection chart; no novelty is claimed for the
decomposition.

## 2. What entropy actually says

Let `S` be the primes in Proposition 1 after deleting the possible endpoint,
and choose `P` uniformly from `S`.  Put `Q=P^-(N-P)` and
`s_q=|\mathcal P_q(N)|`.  Since `Q` is a deterministic function of `P`
and the conditional law on each fiber is uniform,

\[
 \log|S|=H(P)=H(Q)+H(P\mid Q)
 = H(Q)+\sum_q \frac{s_q}{|S|}\log s_q.                   \tag{2.1}
\]

This looks like transport information, but here it is an identity on the
already-disjoint fibers.  If an analytic
argument supplies only separate capacities

\[
  s_q\leq C_q,                                               \tag{2.2}
\]

then its strongest scalar Hall consequence is

\[
  |S|=\sum_qs_q\leq\sum_q C_q.                              \tag{2.3}
\]

Indeed (2.3) is immediate, and optimizing the right side of (2.1) over all
distributions with fiber capacities gives nothing stronger.  There is no
overlap deficit to exploit: least-factor stopping was chosen precisely to
make the fibers disjoint.

**Theorem 2 (scalar-capacity no-go).** Any contradiction to a Goldbach
exception which consumes the stopping-time filtration only through the
cardinalities `s_q` and independent upper bounds (2.2) is equivalent to proving
`sum_q C_q<|S|`.  Entropy, Hall language, or optimal transport does not sharpen
that inequality without an additional joint constraint coupling distinct
levels or the two reflected endpoints.

**Proof.** The admissible scalar data form the box-simplex

\[
  0\leq s_q\leq C_q,\qquad \sum_qs_q=|S|.
\]

For integral capacities it is nonempty exactly when
`sum_q C_q>=|S|`; for real capacities replace each `C_q` by `floor(C_q)`.
Every statement depending only
on these data and valid for all admissible fibers therefore fails to exclude
an exception whenever this inequality holds.  If the reverse strict
inequality holds, (2.3) already gives the contradiction. $\square$

This theorem does not say sieve bounds can never prove Goldbach.  It says the
proposed scalar entropy repackaging adds no strength to the one-fiber bounds it
is given.

## 3. A reflection-pair false model

The loss can be seen without invoking primes.  Let `W` be even, let `W|N`,
and define the finite `W`-rough universe

\[
 U=\{1\leq a<N:(a,W)=1\}.
\]

It is invariant under `tau_N`, and it has no fixed point: `a=N/2` is not a
unit modulo the even number `W`.  Hence `U` is a disjoint union of reflection
pairs `{a,N-a}`.

Fix `0<=theta<=1/2`.  Independently on every reflection pair, choose neither
endpoint with probability `1-2theta`, and choose either endpoint with
probability `theta` each.  Call the resulting random set `A`.

**Proposition 3 (one-point indistinguishability, pair exclusion).** For every
`a in U` and every collection of subsets `B_j subset U`,

\[
 \Pr(a\in A)=\theta,\qquad
 \mathbb E|A\cap B_j|=\theta|B_j|,                          \tag{3.1}
\]

while identically

\[
 1_A(a)1_A(N-a)=0.                                          \tag{3.2}
\]

For a finite family of `K` test sets, all their counts are simultaneously
within `t` of the expectations with positive probability whenever

\[
 2K\exp\!\left(-\frac{2t^2}{|U|/2}\right)<1.               \tag{3.3}
\]

**Proof.** The first two assertions follow from the symmetric marginal on
each pair, and (3.2) from selecting at most one endpoint.  For a fixed `B_j`,
its count is a sum of at most `|U|/2` independent pair contributions, each
lying in an interval of length one.  Hoeffding's inequality and a union bound
give (3.3). $\square$

The tests `B_j` may be residue classes, least-factor stopping fibers of
`N-a`, finite intersections of local congruence conditions, or any other
fixed one-point tests.  Thus the model can match their expected densities—and
simultaneously match any fixed finite list up to square-root discrepancy—while
its `N`-pair count is exactly zero.  Taking
`theta` on the scale `W/(phi(W) log N)` calibrates its one-point density to the
usual locally sieved prime scale, but no asymptotic claim is needed for the
logical obstruction.

This is the decisive false-model control.  Any proposed argument that also
proves a reflected pair from only those one-point statistics proves too much.

## 4. The retained object and the missing datum

The full stopping-time filtration is not useless.  It gives an exact address
for where a successful input must enter:

\[
 p\text{ prime}
 \quad\longleftrightarrow\quad
 N-p=qm,\quad q\leq m,\quad P^-(m)\geq q.                  \tag{4.1}
\]

But scalar entropy erases the decisive incidence: the correlation between
primality at one endpoint and multiplicative roughness, and ultimately
primality, at the reflected endpoint.  A viable successor must retain at
least one of:

1. a signed or bilinear cross-level form rather than the masses `s_q`;
2. Type-II information coupling the variables `q` and `m` in (4.1);
3. dispersion across the moving residue `p=N mod q` with cancellation, not
   separate absolute upper bounds;
4. a theorem comparing adjacent stopping levels before disjoint
   scalarization.

These are forms of two-point off-diagonal information.  Calling the
one-point partition an entropy or transport problem does not supply them.

## 5. Rigor and prior-art boundary

Propositions 1 and 3 and Theorem 2 are proved above by finite elementary
arguments.  The Hoeffding bound is the standard bounded-independent-sums
inequality.  The relation to Buchstab decomposition, sieve parity, Type-II
sums, and dispersion is interpretive routing and carries no novelty claim.
No claim is made that every entropy method, every transport method, or every
sieve method is covered: the no-go applies exactly to methods that retain only
one-fiber cardinalities and independent capacities.  Joint constraints are
explicitly outside its scope and are the successor target.
